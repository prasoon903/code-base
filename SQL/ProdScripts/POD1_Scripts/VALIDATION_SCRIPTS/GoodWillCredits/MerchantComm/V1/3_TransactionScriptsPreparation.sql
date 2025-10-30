---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STEP-1: Fill the temp table ##TempData
-------------------------------------------------------

SELECT * FROM ##TempData WHERE TransactionUUID = 'e0c30163-21a0-4e33-8548-915175c82698'


-------------------------------------------------------
-- STEP-2: Seperate the data into LM40 and LM43 
-------------------------------------------------------

DROP TABLE IF EXISTS #LM40
SElect * INTO #LM40 FROM ##TempData WHERE cmttrantype = '40'




DROP TABLE IF EXISTS #LM43
SElect * INTO #LM43 FROM ##TempData WHERE cmttrantype = '43'


-------------------------------------------------------
-- STEP-3: FILTER OUT THE DATA
-------------------------------------------------------

DROP TABLE IF EXISTS #LM40ToPost
;WITH LM40ToPost
AS
(
	SELECT LM40.*, ROW_NUMBER() OVER (PARTITION BY LM40.AccountNumber, LM40.transactionlifecycleuniqueid ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
	LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
	WHERE LM43.acctID IS NULL
)
SELECT * INTO #LM40ToPost FROM LM40ToPost WHERE Ranking = 1

DROP TABLE IF EXISTS #LM40NotToPost
;WITH CTE AS (
SELECT L2.*, ROW_NUMBER() OVER (PARTITION BY L2.AccountNumber, L2.transactionlifecycleuniqueid ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT * INTO #LM40NotToPost FROM CTE WHERE Ranking = 1

-- Merge Accounts

DROP TABLE IF EXISTS #LM40ToPost_NonMerge
SELECT TT.*
INTO #LM40ToPost_NonMerge
FROM #LM40ToPost TT
JOIN BSegment_Primary BP ON (BP.AccountNumber = TT.AccountNumber)
WHERE MergeInProcessPH IS NULL
ORDER BY BP.acctID

DROP TABLE IF EXISTS #MergedAccount
SELECT RTRIM(BP.AccountNumber) SourceAccountNumber, ClientID SrcClientID, BP.MergeInProcessPH, TransactionLifeCycleUniqueID, TransactionAmount, TranTime, BP.DateAcctOpened DateAcctOpened_SRC
INTO #MergedAccount
FROM #LM40ToPost TT
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = TT.AccountNumber)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
WHERE MergeInProcessPH IS NOT NULL
ORDER BY BP.acctID

SELECT RTRIM(BP.AccountNumber) SourceAccountNumber, BP.MergeInProcessPH, TransactionLifeCycleUniqueID, TransactionAmount, TranTime, BP.DateAcctOpened DateAcctOpened_DEST
FROM #LM40NotToPost TT
JOIN BSegment_Primary BP ON (BP.AccountNumber = TT.AccountNumber)
WHERE MergeInProcessPH IS NOT NULL
ORDER BY BP.acctID

SELECT DestAccountNumber, * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) WHERE SrcAccountNumber = '1100011127787368'

--SELECT SrcAccountNumber, DestAccountNumber AccountNumber, T1.TransactionLifeCycleUniqueID, DestBSAcctId acctId, T1.TransactionAmount Amount, MA.EndTime TranTime, BP.DateAcctOpened DateAcctOpened_DEST, 
--MA.EndTime MergeTime, T1.TranTime ActualTxnTranTime, ROW_NUMBER() OVER(PARTITION BY DestAccountNumber ORDER BY T1.TranTime) RowCountData

DROP TABLE if EXISTS #LM40ToPost_Merge
SELECT BP.acctID, RTRIM(T1.SourceAccountNumber) SourceAccountNumber, T1.SrcClientID, RTRIM(DestAccountNumber) DestAccountNumber, BS.ClientID DestClientID, TransactionLifeCycleUniqueID, TransactionAmount, TranTime
INTO #LM40ToPost_Merge
FROM #MergedAccount t1
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId )


WHERE  T1.AccountNumber IN ('1100011127787368')
AND T1.TranTime < BP.DateAcctOpened
ORDER BY DestAccountNumber


-------------------------------------------------------
-- STEP-3-A: FILTER OUT THE DATA
-------------------------------------------------------

DROP TABLE IF EXISTS #SumOfTotalLM43
;WITH CTE AS (
SELECT transactionlifecycleuniqueid, SUM(TransactionAmount) AS TransactionAmount
FROM #LM43
GROUP BY transactionlifecycleuniqueid
)
SELECT * INTO #SumOfTotalLM43 FROM CTE


DROP TABLE IF EXISTS #DiffAmountForLM40
;WITH CTE AS (
SELECT LM40.*, LM43.TransactionAmount TotalLM43Amount, LM40.TransactionAmount - LM43.TransactionAmount DiffAmount
FROM #LM40 LM40 JOIN #LM43 LM43 ON (LM40.transactionlifecycleuniqueid = LM43.transactionlifecycleuniqueid)
)
SELECT * INTO #DiffAmountForLM40 FROM CTE


-------------------------------------------------------
-- STEP-4: VALIDATION
-------------------------------------------------------

; WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY transactionlifecycleuniqueid ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
SELECT 'TOTAL LM40===> ', COUNT(1) FROM CTE WHERE Ranking = 1

SELECT 'ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM #LM40ToPost

SELECT 'NOT ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM #LM40NotToPost

SELECT RTRIM(T1.AccountNumber) AccountNumber, T2.AccountUUID, T2.ClientID, T2.TransactionUUID [CoreCard Transaction ID], 
Amount [DisputeAmount], TranTime TransactionTime
FROM #LM40NotToPost T1
JOIN ##TempRecords T2 ON (T1.UniversalUniqueID = T2.AccountUUID AND T1.TransactionUUID = T2.TransactionUUID)
ORDER BY T2.acctID

SELECT RTRIM(T1.AccountNumber) AccountNumber, T2.AccountUUID, T2.ClientID, T2.TransactionUUID [CoreCard Transaction ID], 
TransactionAmount TransactionAmountToBePosted, TranTime TransactionTime
FROM #LM40ToPost_NonMerge T1
JOIN ##TempRecords T2 ON (T1.UniversalUniqueID = T2.AccountUUID AND T1.TransactionUUID = T2.TransactionUUID)
--WHERE T2.TransactionUUID = '16fa4d08-8744-41b1-a207-adef597700de'
--WHERE Amount <> TransactionAmount
ORDER BY T1.acctID

SELECT * FROM #LM40ToPost_NonMerge WHERE AccountNumber = '1100011105372217'
SELECT * FROM #LM40ToPost_NonMerge WHERE TransactionUUID = '16fa4d08-8744-41b1-a207-adef597700de'
SELECT * FROM ##TempRecords

SELECT RTRIM(AccountNumber) AccountNumber, transactionlifecycleuniqueid TransactionID, TransactionAmount, TranTime TransactionTime
FROM #LM40NotToPost ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, transactionlifecycleuniqueid TransactionID, TransactionAmount, TranTime TransactionTime 
FROM #LM40ToPost_NonMerge ORDER BY acctID

SELECT SourceAccountNumber, SrcClientID, DestAccountNumber, DestClientID, TransactionLifeCycleUniqueID, TransactionAmount, TranTime
FROM #LM40ToPost_Merge ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, transactionlifecycleuniqueid TransactionID, TransactionAmount, TotalLM43Amount, DiffAmount EligibleCreditAmount, TranTime TransactionTime
FROM #DiffAmountForLM40 ORDER BY acctID



SELECT RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, ClientID, transactionlifecycleuniqueid TransactionID, TransactionAmount, TranTime TransactionTime 
FROM #LM40ToPost T1
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (T1.acctId = BS.acctId)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BS.acctId = BP.acctId)
--WHERE BP.SystemStatus = 14
WHERE MergeInProcessPH IS NULL
ORDER BY T1.acctID


SELECT RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, ClientID, transactionlifecycleuniqueid TransactionID, TransactionAmount, TranTime TransactionTime 
FROM #LM40NotToPost T1
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (T1.acctId = BS.acctId)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BS.acctId = BP.acctId)
ORDER BY T1.acctID



-------------------------------------------------------
-- STEP-5: GENERATING THE TRANSACTIONS
-------------------------------------------------------

SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + '''),'
FROM #LM40ToPost ORDER BY TranTime

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #LM40ToPost
ORDER BY TranTime

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #LM40ToPost_NonMerge
ORDER BY TranTime


SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(DestAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #LM40ToPost_Merge
ORDER BY TranTime


-- FOR DIFF AMOUNT

SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, DiffAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + '''),'
FROM #DiffAmountForLM40 ORDER BY acctID


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
