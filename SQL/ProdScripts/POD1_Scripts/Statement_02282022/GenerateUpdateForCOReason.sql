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

DECLARE @LastStatementDate DATETIME = '2020-12-31 23:59:57.000'--, @Businessday VARCHAR(50) = '2020-11-30 23:59:57.000'

INSERT INTO #TempChargeOffAccounts
SELECT BP.acctId, BP.AccountNumber, BP.SystemStatus, BCC.ManualInitialChargeOffReason, BCC.AutoInitialChargeOffReason, BP.ccinhparent125AID, BP.Parent05AID, BCC.Chargeoffdate
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE SystemStatus = 14 and ManualInitialChargeOffReason = '0' AND AutoInitialChargeOffReason = '0'

;WITH CTE AS
(
	SELECT 
		TA.acctId, TA.SystemStatus, TA.ccinhparent125AID, 
		CASE 
			WHEN SH.ManualInitialChargeOffReason IS NOT NULL AND SH.ManualInitialChargeOffReason <> '0' THEN SH.ManualInitialChargeOffReason
			WHEN SH.AutoInitialChargeOffReason IS NOT NULL AND SH.AutoInitialChargeOffReason <> '0' THEN SH.AutoInitialChargeOffReason
			ELSE MTC.ChargeOffReason
		END AS ChargeOffReason,
		--COALESCE(SH.ManualInitialChargeOffReason, SH.AutoInitialChargeOffReason, MTC.ChargeOffReason) ChargeOffReason, 
		RANK() OVER (PARTITION BY TA.acctId ORDER BY CP.PostTime DESC) Ranking,
		CASE 
			WHEN ISNULL(SH.ManualInitialChargeOffReason, '0') = '0' AND ISNULL(SH.AutoInitialChargeOffReason, '0') = '0' THEN 2
			ELSE 1
		END AS CorrectionFlag
	FROM #TempChargeOffAccounts TA WITH (NOLOCK)
	JOIN StatementHeader SH WITH (NOLOCK) ON (TA.acctId = SH.acctId AND SH.StatementDate = @LastStatementDate)
	JOIN CCard_Primary CP WITH (NOLOCK) ON (TA.AccountNumber = CP.AccountNumber)
	JOIN MonetaryTxnControl MTC WITH (NOLOCK) ON (CP.TxnCode_Internal = MTC.TransactionCode AND CP.CMTTranType = '51')
)
INSERT INTO #TempChargeOffAccountsJobTable
SELECT acctId, SystemStatus, ccinhparent125AID, ISNULL(ChargeOffReason, 1), CorrectionFlag FROM CTE WHERE Ranking = 1


DECLARE @LastStatementDateVARCHAR VARCHAR(50) = '2020-12-31 23:59:57.000', @Businessday VARCHAR(50) = '2020-12-31 23:59:57.000'

SELECT *,
'UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = ''' + RTRIM(ManualInitialChargeOffReason) + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard,
'UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary,
'UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = ''' + RTRIM(ManualInitialChargeOffReason) + ''' WHERE BSacctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_AccountInfoForReport,
'UPDATE StatementHeader SET ManualInitialChargeOffReason = ''' + RTRIM(ManualInitialChargeOffReason) + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @LastStatementDateVARCHAR + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_StatementHeader
FROM #TempChargeOffAccountsJobTable
--WHERE JobStatus = 2  -- 2 for statementupdate