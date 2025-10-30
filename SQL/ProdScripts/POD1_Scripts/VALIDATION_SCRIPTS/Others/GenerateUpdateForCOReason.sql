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
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE SystemStatus = 14 and ManualInitialChargeOffReason = '0' AND AutoInitialChargeOffReason = '0'

;WITH CTE AS
(
	SELECT 
		TA.acctId, TA.SystemStatus, TA.ccinhparent125AID, MTC.ChargeOffReason, RANK() OVER (PARTITION BY TA.acctId ORDER BY CP.PostTime DESC) Ranking
	FROM #TempChargeOffAccounts TA WITH (NOLOCK)
	JOIN CCard_Primary CP WITH (NOLOCK) ON (TA.AccountNumber = CP.AccountNumber)
	JOIN MonetaryTxnControl MTC WITH (NOLOCK) ON (CP.TxnCode_Internal = MTC.TransactionCode AND CP.CMTTranType = '51')
)
INSERT INTO #TempChargeOffAccountsJobTable
SELECT acctId, SystemStatus, ccinhparent125AID, ISNULL(ChargeOffReason, 1), 0 JobStatus FROM CTE WHERE Ranking = 1


SELECT *,
'UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = ''' + ManualInitialChargeOffReason + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard,
'UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary
FROM #TempChargeOffAccountsJobTable