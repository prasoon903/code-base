DROP TABLE IF EXISTS #TempChargeOffAccounts
DROP TABLE IF EXISTS #TempChargeOffAccountsJobTable

CREATE TABLE #TempChargeOffAccounts
(
	acctId INT, AccountNumber VARCHAR(19), SystemStatus INT, ManualInitialChargeOffReason VARCHAR(5), AutoInitialChargeOffReason VARCHAR(5), ccinhparent125aid INT, Parent05AID INT, Chargeoffdate DATETIME
)

CREATE TABLE #TempChargeOffAccountsJobTable
(
	acctId INT, SystemStatus INT, ccinhparent125aid INT, ManualInitialChargeOffReason VARCHAR(5), JobStatus INT
)

INSERT INTO #TempChargeOffAccounts
SELECT BP.acctId, BP.AccountNumber, BP.SystemStatus, BCC.ManualInitialChargeOffReason, BCC.AutoInitialChargeOffReason, BP.ccinhparent125AID, BP.Parent05AID, BCC.Chargeoffdate
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE SystemStatus = 14 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')
AND BP.ccinhparent125AID <> 16022

/*
;WITH CTE AS
(
	SELECT 
		TA.acctId, TA.SystemStatus, TA.ccinhparent125AID, MTC.ChargeOffReason, RANK() OVER (PARTITION BY TA.acctId ORDER BY CP.PostTime DESC) Ranking
	FROM #TempChargeOffAccounts TA WITH (NOLOCK)
	JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCard_Primary CP WITH (NOLOCK) ON (TA.AccountNumber = CP.AccountNumber)
	JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.MonetaryTxnControl MTC WITH (NOLOCK) ON (CP.TxnCode_Internal = MTC.TransactionCode AND CP.CMTTranType = '51')
)
INSERT INTO #TempChargeOffAccountsJobTable
SELECT acctId, SystemStatus, ccinhparent125AID, ISNULL(ChargeOffReason, 1), 0 JobStatus FROM CTE WHERE Ranking = 1
*/

INSERT INTO #TempChargeOffAccountsJobTable
SELECT 
	TA.acctId, TA.SystemStatus, TA.ccinhparent125AID, ISNULL(A.COReasonCode, 1), 0 JobStatus
FROM #TempChargeOffAccounts TA WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.AStatusAccounts A WITH (NOLOCK) ON (A.Parent01AID = TA.ccinhparent125AID AND A.MerchantAID = 14992)

INSERT INTO #TempChargeOffAccountsJobTable
SELECT BP.acctId, BP.SystemStatus, BP.ccinhparent125AID, 3, 0
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE SystemStatus = 14 and ISNULL(ManualInitialChargeOffReason, '0') <> '3' AND ISNULL(AutoInitialChargeOffReason, '0') <> '3' AND BP.ccinhparent125AID = 16022


SELECT *,
'UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = ''' + ManualInitialChargeOffReason + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard,
'UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary
FROM #TempChargeOffAccountsJobTable

/*
SELECT TT.acctId, TT.SystemStatus, TT.ccinhparent125AID, TT.ManualInitialChargeOffReason, SH.ManualInitialChargeOffReason SH_ManualInitialChargeOffReason, SH.AutoInitialChargeOffReason SH_AutoInitialChargeOffReason,
'UPDATE TOP(1) StatementHeader SET ManualInitialChargeOffReason = ''' + TT.ManualInitialChargeOffReason + ''' WHERE acctId = ' + TRY_CAST(SH.acctId AS VARCHAR) + ' AND StatementDate = ''2021-01-31 23:59:57''' UPDATE_StatementHeader,
'UPDATE TOP(1) AccountInfoForReport SET ManualInitialChargeOffReason = ''' + TT.ManualInitialChargeOffReason + ''' WHERE BSacctId = ' + TRY_CAST(SH.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-01-31 23:59:57''' UPDATE_AIR
FROM LS_PRODDRGSDB01.CCGS_CoreIssue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
JOIN #TempChargeOffAccountsJobTable TT ON (SH.acctId = TT.acctId AND SH.StatementDate = '2021-03-31 23:59:57.000')
WHERE ISNULL(SH.ManualInitialChargeOffReason, '0') = '0' AND ISNULL(SH.AutoInitialChargeOffReason, '0') = '0'
*/