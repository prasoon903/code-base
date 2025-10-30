DROP TABLE IF EXISTS #TempChargeOffAccounts
DROP TABLE IF EXISTS #TempChargeOffAccountsJobTable

CREATE TABLE #TempChargeOffAccounts
(
	acctId INT, AccountNumber VARCHAR(19), SystemStatus INT, ManualInitialChargeOffReason VARCHAR(5), AutoInitialChargeOffReason VARCHAR(5), ccinhparent125aid INT, Chargeoffdate DATETIME
)

CREATE TABLE #TempChargeOffAccountsJobTable
(
	acctId INT, SystemStatus INT, ccinhparent125aid INT, ManualInitialChargeOffReason VARCHAR(5), JobStatus INT
)

INSERT INTO #TempChargeOffAccounts
SELECT acctId, AccountNumber, SystemStatus, ManualInitialChargeOffReason, AutoInitialChargeOffReason, ccinhparent125AID, Chargeoffdate
FROM LS_PRODDRGSDB01.CCGS_CoreIssue_secondary.dbo.StatementHeader BP WITH (NOLOCK)
WHERE SystemStatus = 14 
AND StatementDate = '2021-03-31 23:59:57' 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')
AND ccinhparent125AID <> 16022

--SELECT * FROM #TempChargeOffAccounts

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

INSERT INTO #TempChargeOffAccountsJobTable
SELECT acctId, SystemStatus, ccinhparent125AID, 3, 0
FROM LS_PRODDRGSDB01.CCGS_CoreIssue_secondary.dbo.StatementHeader WITH (NOLOCK)
WHERE SystemStatus = 14 
AND StatementDate = '2021-03-31 23:59:57' 
and ISNULL(ManualInitialChargeOffReason, '0') <> '3' 
AND ISNULL(AutoInitialChargeOffReason, '0') <> '3' 
AND ccinhparent125AID = 16022



SELECT acctId, SystemStatus, ccinhparent125AID, ManualInitialChargeOffReason, ManualInitialChargeOffReason SH_ManualInitialChargeOffReason,
'UPDATE TOP(1) StatementHeader SET ManualInitialChargeOffReason = ''' + ManualInitialChargeOffReason + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) + ' AND StatementDate = ''2021-03-31 23:59:57''' UPDATE_StatementHeader,
'UPDATE TOP(1) AccountInfoForReport SET ManualInitialChargeOffReason = ''' + ManualInitialChargeOffReason + ''' WHERE BSacctId = ' + TRY_CAST(acctId AS VARCHAR) + ' AND BusinessDay = ''2021-03-31 23:59:57''' UPDATE_AIR
FROM #TempChargeOffAccountsJobTable 
