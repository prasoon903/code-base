
DECLARE @JIRAID VARCHAR(20) = 'COOKIE-00000'
DECLARE @TranCode VARCHAR(20) = '4907'


DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.Amount
INTO #TempRecords
FROM ##TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)

DROP TABLE IF EXISTS #TempRecordsAcrossPOD
SELECT T1.*
INTO #TempRecordsAcrossPOD
FROM ##TempData T1
LEFT JOIN #TempRecords T2 ON (T1.AccountUUID = T2.AccountUUID)
WHERE T2.AccountUUID IS NULL

DROP TABLE IF EXISTS #NonMergedAccounts
SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, acctId, Amount TransactionAmount
INTO #NonMergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NULL
ORDER BY acctID

DROP TABLE IF EXISTS #MergedAccounts
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.Amount TransactionAmount 
INTO #MergedAccounts
FROM #TempRecords T1
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountNumber = MA.SRCAccountNumber)
WHERE T1.MergeInProcessPH = 4

DROP TABLE IF EXISTS #MergedAccountsAcrossPOD
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.Amount TransactionAmount
INTO #MergedAccountsAcrossPOD
FROM #TempRecordsAcrossPOD T1
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountUUID = MA.SRCBSAccountUUID)

--SELECT * FROM #NonMergedAccounts
--SELECT * FROM #MergedAccounts
--SELECT * FROM #MergedAccountsAcrossPOD

DROP TABLE IF EXISTS #TempCombined
;WITH CTE
AS
(
SELECT * FROM #NonMergedAccounts UNION ALL
SELECT * FROM #MergedAccounts UNION ALL
SELECT * FROM #MergedAccountsAcrossPOD
)
SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount
INTO #TempCombined
FROM CTE 
GROUP BY AccountNumber, acctID

SELECT 'INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) 
VALUES (''' + @JIRAID + ''', ' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', '''+ @TranCode +''')'
FROM #TempCombined
