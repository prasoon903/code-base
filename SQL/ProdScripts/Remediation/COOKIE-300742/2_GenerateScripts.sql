
DECLARE @JIRAID VARCHAR(20) = 'COOKIE-300742'
DECLARE @TranCode VARCHAR(20) = '2202'

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BC.ChargeOffDate ChargeOffDate_Acct, BS.ClientID, BP.MergeInProcessPH, T.*
INTO #TempRecords
FROM ##TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BC.acctId = BS.acctID)

DROP TABLE IF EXISTS #ActivePayments
;WITH CTE
AS
(
SELECT * 
FROM #TempRecords 
WHERE RevTgt IS NULL 
AND ChargeOffDate IS NULL
AND ChargeOffDate_Acct IS NULL
), 
PaymentRIPCheck
AS
(
SELECT C.*
FROM CCard_Primary CP WITH (NOLOCK)
RIGHT JOIN CTE C ON (CP.AccountNumber = C.AccountNumber AND CP.TranRef = C.TranID AND CP.CMTTRANTYPE = '22')
WHERE CP.TranRef IS NULL
)
SELECT C.*, CP1.TransactionDescription
INTO #ActivePayments
FROM CCard_Primary CP1 WITH (NOLOCK)
JOIN CTE C ON (CP1.AccountNumber = C.AccountNumber AND CP1.TranID = C.TranID AND CP1.CMTTRANTYPE = '21')


SELECT * FROM #ActivePayments

DROP TABLE IF EXISTS #TempRecordsAcrossPOD
SELECT T1.*
--INTO #TempRecordsAcrossPOD
FROM ##TempData T1
LEFT JOIN #TempRecords T2 ON (T1.AccountUUID = T2.AccountUUID)
WHERE T2.AccountUUID IS NULL

DROP TABLE IF EXISTS #NonMergedAccounts
SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, acctId, Amount TransactionAmount, TT.TranTime 
INTO #NonMergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NULL
ORDER BY acctID

DROP TABLE IF EXISTS #MergedAccounts
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.Amount TransactionAmount, T1.TranTime 
INTO #MergedAccounts
FROM #TempRecords T1
JOIN MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountNumber = MA.SRCAccountNumber)
WHERE T1.MergeInProcessPH = 4

DROP TABLE IF EXISTS #MergedAccountsAcrossPOD
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.TransactionAmount TransactionAmount, T1.CreatedDate TranTime 
INTO #MergedAccountsAcrossPOD
FROM #TempRecordsAcrossPOD T1
JOIN MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountUUID = MA.SRCBSAccountUUID)

--SELECT * FROM #NonMergedAccounts
--SELECT * FROM #MergedAccounts
--SELECT * FROM #MergedAccountsAcrossPOD
--SELECT * FROM #TempRecords

DROP TABLE IF EXISTS #TempCombined
;WITH CTE
AS
(
SELECT * FROM #NonMergedAccounts UNION ALL
SELECT * FROM #MergedAccounts UNION ALL
SELECT * FROM #MergedAccountsAcrossPOD
)
SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount, MIN(TranTime) TranTime
INTO #TempCombined
FROM CTE 
GROUP BY AccountNumber, acctID

SELECT 'INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) 
VALUES (''' + @JIRAID + ''', ' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', '''+ @TranCode +'''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #TempCombined
ORDER BY TranTime
