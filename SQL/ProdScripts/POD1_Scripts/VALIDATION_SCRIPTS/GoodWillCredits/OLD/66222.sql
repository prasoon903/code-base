---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STEP-1: Fill the temp table ##TempData
-------------------------------------------------------

SELECT * FROM ##TempData WHERE TransactionUUID = 'e0c30163-21a0-4e33-8548-915175c82698'


-------------------------------------------------------
-- STEP-2: Seperate the data into LM40 and LM43 
-------------------------------------------------------

DROP TABLE IF EXISTS #LM40
SElect * INTO #LM40 FROM ##TempData WHERE cmttrantype = '40'

--SElect DISTINCT transactionlifecycleuniqueid, AccountNumber FROM ##TempData WHERE cmttrantype = '40'

--SELECT * 
--FROm #LM40 t1
--RIGHT JOIN  ##TempRecords t2 ON (t1.TransactionUUID = t2.TransactionUUID)
--WHERE t1.TransactionUUID IS NULL


--WITH CTE AS (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime ) RowCounter
--FROM #LM40 )
--SELECT * FROM CTE WHERE RowCounter > 1

--SELECT C.TransactionLifeCycleUniqueID, BSAcctId, AccountNumber, TransactionAmount, ARTxnType, AuthTranID, * FROM CCard_Primary C WITH (NOLOCK) WHERE C.TransactionLifeCycleUniqueID = 416247376 --854723 Exclude


--WITH CTE AS (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime ) RowCounter
--FROM #LM40 )
--SELECT * 
--FROM CTE C
--LEFT JOIN #LM40ToPost L ON (C.TransactionLifeCycleUniqueID = L.TransactionLifeCycleUniqueID)
--WHERE RowCounter = 1
--AND L.TransactionLifeCycleUniqueID IS NULL



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
--DELETE FROM #LM40ToPost WHERE transactionlifecycleuniqueid = 416247376 AND acctId = 854723
--UPDATE #LM40ToPost SET AccountNumber = '1100011114574191' WHERE TransactionLifeCycleUniqueID = 835286667
--UPDATE #LM40ToPost SET AccountNumber = '1100011139156206' WHERE TransactionLifeCycleUniqueID = 890299021

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

SELECT RTRIM(T1.AccountNumber) AccountNumber, T2.AccountUUID, /*T2.ClientID,*/ T2.TransactionUUID [CoreCard Transaction ID], 
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


/*

SELECT * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData with (nolock)
where accountnumber = '1100011119320798'
AND TransactionStatus = 1

; with cte as (
SELECT * , Row_number() over (partition by AccountNumber order by posttime desc) rowcountvalue
FROM #LM40ToPost)
SELECT c1.rowcountvalue, *, Row_number() over (partition by AccountNumber, transactionamount order by posttime desc) rowcountvalue1
FROM cte c1
where  rowcountvalue > 1
ORDER BY acctID, c1.rowcountvalue

; with cte as (
SELECT * , Row_number() over (partition by AccountNumber, transactionamount order by posttime desc) rowcountvalue
FROM #LM40ToPost)
SELECT 'UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''' WHERE AccountNumber =  ''' + RTRIM(AccountNumber) + ''' AND TransactionStatus = 1' + ' AND Transactionamount = ' + try_convert(varchar, Transactionamount)
FROM cte
where  rowcountvalue = 1
ORDER BY acctID

; with cte as (
SELECT * , Row_number() over (partition by AccountNumber, transactionamount order by posttime desc) rowcountvalue
FROM #LM40ToPost)
SELECT 'UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''' WHERE AccountNumber =  ''' + RTRIM(AccountNumber) + ''' AND Skey = ' + try_convert(varchar, Transactionamount)
FROM cte
where  rowcountvalue > 1
ORDER BY acctID


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+'''' + ', ''' + RTRIM(TransactionUUID) +''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + '''),'
FROM #LM40ToPost ORDER BY acctID


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + '''),'
FROM #LM40ToPost ORDER BY acctID

SELECT 'UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''' WHERE AccountNumber =  ''' + RTRIM(AccountNumber) + ''' AND TransactionStatus = 1'
FROM #LM40ToPost T1
JOIN ##TempTransactions T2 ON (T1.TransactionUUID = T2.TransactionUUID) 
ORDER BY acctID


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ',''49''' + ', ''4907''),'
FROM #LM40ToPost T1
JOIN ##TempTransactions T2 ON (T1.TransactionUUID = T2.TransactionUUID) 
ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime 
FROM #LM40ToPost ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime
FROM #LM40NotToPost ORDER BY acctID

SELECT acctID, RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime 
FROM #LM40ToPost ORDER BY acctID




SELECT * FROM ##TempTransactions

;with cte as (
SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber, TransactionUUID ORDER BY POSTTIME DESC) AS COUNTER1 
FROM  ##TempData T1 )
SELECT * FROm CTE WhERE COUNTER1 = 1

;with cte as (
SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber, TransactionUUID ORDER BY POSTTIME DESC) AS COUNTER1 
FROM  #LM40 T1 )
SELECT * FROm CTE WhERE COUNTER1 = 1

;with cte as (
SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber, TransactionUUID ORDER BY POSTTIME DESC) AS COUNTER1 
FROM  #LM43 T1 )
SELECT * FROm CTE WhERE COUNTER1 = 1


SELECT * 
FROM  #LM40 T1 
JOIN ##TempTransactions T2 ON (T1.TransactionUUID = T2.TransactionUUID)


SELECT * 
FROM  #LM43 T1 
JOIN ##TempTransactions T2 ON (T1.TransactionUUID = T2.TransactionUUID)

DROP TABLE IF EXISTS #LM40NotToPost
;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionUUID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT * INTO #LM40NotToPost FROM CTE WHERE Ranking = 1


SELECT * FROM ##TempData where AccountNumber = '1100011119320798'

SELECT DISTINCT InstitutionID 
FROM ##TempData TT
JOIN BSegment_Primary BP WITH (NOLOCK) ON (TT.AccountNumber = BP.AccountNumber)

DROP TABLE IF EXISTS #LM40
SElect * INTO #LM40 FROM ##TempData WHERE cmttrantype = '40'

DROP TABLE IF EXISTS #LM43
SElect * INTO #LM43 FROM ##TempData WHERE cmttrantype = '43'

SELECT * 
FROM #LM40 LM40
LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
WHERE LM43.acctID IS  NULL
AND LM40.AccountNumber = '1100000100229787'

DROP TABLE IF EXISTS #LM40ToPost
;WITH LM40ToPost
AS
(
	SELECT LM40.*, RANK() OVER (PARTITION BY LM40.TransactionUUID ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
	LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
	WHERE LM43.acctID IS NULL
)
SELECT * INTO #LM40ToPost FROM LM40ToPost WHERE Ranking = 1


;WITH LM40ToNotPost
AS
(
	SELECT LM40.*, RANK() OVER (PARTITION BY LM40.TransactionUUID ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
	LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
	WHERE LM43.acctID IS NOT NULL
)
SELECT * FROM LM40ToNotPost WHERE Ranking = 1

;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionUUID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT * FROM CTE WHERE Ranking = 1

; WITH CTE AS (SELECT *, RANK() OVER (PARTITION BY TransactionUUID ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
SELECT 'TOTAL LM40===> ', COUNT(1) FROM CTE WHERE Ranking = 1

SELECT 'ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM #LM40ToPost

SELECT 'NOT ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM #LM40NotToPost

;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionUUID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT 'NOT ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM CTE WHERE Ranking = 1

SELECT * FROM ##PostedTxns

SELECT T1.*
FROM #LM40ToPost T1
JOIN ##PostedTxns T2 ON (T1.AccountNumber = T2.AccountNumber AND T1.TranTime = T2.TranTime)




select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid
--into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where 
cp.cmttrantype = '40'
--and ap.cmttrantype = '93'
and ap.transactionuuid in
('000f9084-4b24-444e-a973-e68f99eac3e2')


SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '000f9084-4b24-444e-a973-e68f99eac3e2'

SELECT AccountNumber,* FROM BSegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '0c2b38ba-3a5d-4811-a249-f8a0c73bbf24'



DROP TABLE IF EXISTS #TempAuth
;WITH CTE AS (
SELECT t2.TransactionLifeCycleUUID 
FROm #LM40 t1
RIGHT JOIN  ##TempRecords t2 ON (t1.TransactionUUID = t2.TransactionLifeCycleUUID)
WHERE t1.TransactionUUID IS NULL)
SELECT TransactionLifeCycleUniqueID, TransactionUUID
INTO #TempAuth 
FROM Auth_Primary A WITH (NOLOCK) 
JOIN CTE C ON (C.TransactionLifeCycleUUID = A.TransactionUUID)

SELECT * FROM Auth_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 31667552

SELECT CMTTranType, TransactionAmount, TransactionDescription, * 
FROM CCard_Primary WITH (NOLOCK) 
WHERE TransactionLifeCycleUniqueID = 1037446693 --AND TxnSource <> 4
ORDER BY POSTTIME 


SELECT CP.TransactionLifeCycleUniqueID, TT.TransactionUUID, RTRIM(CP.CMTTranType) CMTTranType, CP.TransactionAmount, RTRIM(TransactionDescription) TransactionDescription, CP.PostTime, Reversed 
FROM CCard_Primary CP WITH (NOLOCK)
JOIN #LM40NotToPost TT ON (CP.TransactionLifeCycleUniqueID = TT.TransactionLifeCycleUniqueID)
--WHERE TransactionLifeCycleUniqueID = 1037446693 --
WHERE TxnSource <> 4
ORDER BY CP.TransactionLifeCycleUniqueID, CP.POSTTIME 



SELECT DISTINCT CP.TransactionLifeCycleUniqueID
FROM CCard_Primary CP WITH (NOLOCK)
JOIN #LM40NotToPost TT ON (CP.TransactionLifeCycleUniqueID = TT.TransactionLifeCycleUniqueID)
--WHERE TransactionLifeCycleUniqueID = 1037446693 --
WHERE TxnSource <> 4


SELECT * FROM CoreAuthTransactions


SELECT * FROM #LM40NotToPost WHERE TransactionLifeCycleUniqueID = 925112279




SELECT * FROM ##TempData WHERE transactionuuid = 'f6ca14e5-415a-47b1-9de6-a1d3add41475'

WITH CTE AS (
SELECT *, RANK() OVER(PARTITION BY transactionuuid ORDER BY TranTIme ASC) Ranking 
FROM ##TempData
WHERE cmttranType = '40')
SELECT * FROM CTE 
ORDER BY transactionuuid


SELECT BSAcctId, ArTxnType, CMTTranType, TransactionDescription, TransactionAmount, * 
FROM CCard_Primary WITH (NOLOCK) 
WHERE TransactionLifeCycleUniqueID = 139891084 ORDER BY TranTIme

SELECT *
FROM #LM40NotToPost ORDER BY acctID
--537450217, 828585252

--835286667
--890299021
--1223915958

SELECT RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime
FROM #LM40ToPost 
WHERE TransactionLifeCycleUniqueID = 835286667
ORDER BY acctID

SELECT * FROM DisputeStatusLog WITh (NOLOCK) WHERE TransactionLifeCycleUniqueID = 309416496

SELECT * FROM ##TempData WHERE TransactionLifeCycleUniqueID = 828585252

SELECT *, ROW_NUMBER() OVER (PARTITION BY LM40.TransactionUUID ORDER BY LM40.POSTTIME DESC)  AS Ranking
FROM #LM40 LM40
LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
WHERE LM40.TransactionLifeCycleUniqueID = 866546992
AND LM43.TranID IS null

SELECT * FROM #LM40 WHERE TransactionLifeCycleUniqueID = 537450217
SELECT * FROM #LM43 WHERE TransactionLifeCycleUniqueID = 866546992
SELECT * FROM #LM40 WHERE TransactionLifeCycleUniqueID = 866546992 AND TranID = 37085306150

SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40' AND TransactionLifeCycleUniqueID = 866546992

SELECT * FROM #LM40ToPost WHERE TransactionLifeCycleUniqueID = 828585252



;WITH LM40ToPost
AS
(
	SELECT LM40.*, ROW_NUMBER() OVER (PARTITION BY LM40.AccountNumber, LM40.transactionlifecycleuniqueid ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
)
SELECT *  FROM LM40ToPost WHERE Ranking = 1


;WITH LM40ToPost
AS
(
	SELECT LM40.*, ROW_NUMBER() OVER (PARTITION BY LM40.transactionlifecycleuniqueid ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
)
SELECT *  FROM LM40ToPost WHERE Ranking > 1

SELECT * FROM #LM40ToPost  L1
RIGHT JOIN ##TempRecords L2 ON (L1.TransactionLifeCycleUniqueID = L2.TransactionLifeCycleUniqueID)
WHERE L1.TransactionLifeCycleUniqueID IS NULL

WITH CTE AS (
SELECT *,  ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime DESC)  AS Ranking
FROM ##TempRecords)
SELECT * FROM CTE WHERE Ranking > 1


DROP TABLE IF EXISTS #TempJobsToPost
SELECT acctId, AccountNumber, TranTime, TransactionAmount, TransactionLifeCycleUniqueID, TranID, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY TranTime) RowCountData
INTO #TempJobsToPost
FROM #LM40ToPost

SELECT * FROM #TempJobsToPost WHERE acctId = 2207123

SELECT AccountNumber, T.RowCountData, * FROM #TempJobsToPost T ORDER BY T.RowCountData DESC

SELECT AccountNumber, MAX(RowCountData) FROM #TempJobsToPost  GROUP BY AccountNumber ORDER BY MAX(RowCountData) DESC

SELECT MAX(RowCountData) FROM #TempJobsToPost



;WITH CTE AS (
SELECT * FROM #LM40ToPost
UNION
SELECT * FROM #LM40NotToPost
), CTE2 AS (SELECT *, RANK() OVER (PARTITION BY TransactionUUID ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
SELECT * 
FROM CTE2 TT
LEFT JOIN CTE C ON (TT.TransactionLifeCycleUniqueID = C.TransactionLifeCycleUniqueID)
WHERE TT.Ranking = 1
AND C.TransactionLifeCycleUniqueID IS NULL


;WITH CTE AS (SELECT * FROM #LM40ToPost UNION SELECT * FROM #LM40NotToPost)
SELECT * FROM CTE ORDER BY TransactionLifeCycleUniqueID

;WITH CTE2 AS (SELECT *, RANK() OVER (PARTITION BY TransactionUUID ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
SELECT * FROM CTE2 WHERE Ranking = 1 ORDER BY TransactionLifeCycleUniqueID




SELECT TransactionStatus, COUNT(1) RecordCount
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
GROUP BY TransactionStatus

SELECT COUNT(1) CommonTNPRecordCount
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()

SELECT COUNT(1) ErrorTNPRecordCount
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.ErrorTNP WITH (NOLOCK)