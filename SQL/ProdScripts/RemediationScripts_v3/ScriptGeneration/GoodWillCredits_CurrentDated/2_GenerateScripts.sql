
DECLARE @JIRAID VARCHAR(20) = 'COOKIE-280313'
DECLARE @TranCode VARCHAR(20) = '4933'
DECLARE @TranType VARCHAR(5) = '49'
DECLARE @PostOnSpecificCustomer INT = 1


DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, T.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.Amount
INTO #TempRecords
FROM ##TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)

--SELECT T1.*, C.CustomerType
--FROM #TempRecords T1
--JOIN Customer C WITH (NOLOCk) ON (T1.acctID = C.BSAcctID AND T1.ClientID = C.ClientID)

DROP TABLE IF EXISTS #TempRecordsAcrossPOD
SELECT T1.*
INTO #TempRecordsAcrossPOD
FROM ##TempData T1
LEFT JOIN #TempRecords T2 ON (T1.AccountUUID = T2.AccountUUID)
WHERE T2.AccountUUID IS NULL

DROP TABLE IF EXISTS #NonMergedAccounts
SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, acctId, Amount TransactionAmount,  TT.ClientID
INTO #NonMergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NULL
ORDER BY acctID

DROP TABLE IF EXISTS #MergedAccounts
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.Amount TransactionAmount, T1.ClientID
INTO #MergedAccounts
FROM #TempRecords T1
JOIN MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountNumber = MA.SRCAccountNumber)
WHERE T1.MergeInProcessPH = 4

DROP TABLE IF EXISTS #MergedAccountsAcrossPOD
SELECT DestAccountNumber AccountNumber, DestBsAccountUUID AccountUUID, DestBSAcctID acctId, T1.Amount TransactionAmount, T1.ClientID
INTO #MergedAccountsAcrossPOD
FROM #TempRecordsAcrossPOD T1
JOIN MergeAccountJob MA WITH (NOLOCK) ON (T1.AccountUUID = MA.SRCBSAccountUUID)

--SELECT * FROM #NonMergedAccounts
--SELECT * FROM #MergedAccounts
--SELECT * FROM #MergedAccountsAcrossPOD

IF(@PostOnSpecificCustomer = 1)
BEGIN
	DROP TABLE IF EXISTS #TempCombinedWithClientID
	;WITH CTE
	AS
	(
	SELECT * FROM #NonMergedAccounts UNION ALL
	SELECT * FROM #MergedAccounts UNION ALL
	SELECT * FROM #MergedAccountsAcrossPOD
	)
	SELECT AccountNumber, acctID, ClientID, SUM(TransactionAmount) TransactionAmount
	INTO #TempCombinedWithClientID
	FROM CTE 
	GROUP BY AccountNumber, acctID, ClientID

	SELECT 'INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID) 
	VALUES (''' + @JIRAID + ''', ' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''' + @TranType + '''' + ', ''' + @TranCode + '''' + ', ''' + ClientID + ''')'
	FROM #TempCombinedWithClientID
END
ELSE IF (@PostOnSpecificCustomer = 0)
BEGIN
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

	SELECT 'INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode) 
	VALUES (''' + @JIRAID + ''', ' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''' + @TranType + '''' + ', '''+ @TranCode +''')'
	FROM #TempCombined
END
