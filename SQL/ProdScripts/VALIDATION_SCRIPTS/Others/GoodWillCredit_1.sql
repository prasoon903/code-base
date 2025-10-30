SELECT posttime, count(1) 
FROM LINK_PROD1GSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData with (nolock)
WHERE AccountNumber = 

; with cte as (
SELECT * , Row_number() over (partition by AccountNumber order by posttime desc) rowcountvalue
FROM #LM40ToPost)
SELECT 'UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''' WHERE AccountNumber =  ''' + RTRIM(AccountNumber) + ''' AND TransactionStatus = 1' + ''' AND Transactionamount = 1'
FROM cte
where  rowcountvalue > 1
ORDER BY acctID

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


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+'''' + ', ''' + RTRIM(TransactionUUID) +''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + '''),'
FROM #LM40ToPost ORDER BY acctID

SELECT 'UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''' WHERE AccountNumber =  ''' + RTRIM(AccountNumber) + ''' AND TransactionStatus = 1'
FROM #LM40ToPost 
ORDER BY acctID


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ',''49''' + ', ''4907''),'
FROM #LM40ToPost 
ORDER BY acctID

SELECT RTRIM(L1.AccountNumber) AccountNumber, A1.TransactionUUID TransactionID, L1.TransactionAmount, L1.TranTime TransactionTime, RANK() OVER (PARTITION BY A1.TransactionUUID ORDER BY A1.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
LEFT JOIN Auth_Primary A1 WITH (NOLOCK) ON (L1.TransactionLifeCycleUniqueID = A1.TransactionLifeCycleUniqueID AND A1.AccountNumber = L1.AccountNumber)
ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime
FROM #LM40NotToPost ORDER BY acctID

SELECT RTRIM(AccountNumber) AccountNumber, TransactionUUID TransactionID, TransactionAmount, TranTime TransactionTime
FROM #LM40ToPost ORDER BY acctID

SELECT * FROm #LM40ToPost


/*
;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionUUID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT * INTO #LM40NotToPost FROM CTE WHERE Ranking = 1


SELECT * FROM ##TempData2

SELECT DISTINCT InstitutionID 
FROM ##TempData1 TT
JOIN BSegment_Primary BP WITH (NOLOCK) ON (TT.AccountNumber = BP.AccountNumber)

DROP TABLE IF EXISTS #LM40
SElect * INTO #LM40 FROM ##TempData2 WHERE cmttrantype = '40'

DROP TABLE IF EXISTS #LM43
SElect * INTO #LM43 FROM ##TempData2 WHERE cmttrantype = '43'

SELECT * 
FROM #LM40 LM40
LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
WHERE LM43.acctID IS  NULL
AND LM40.AccountNumber = '1100011105017747'

DROP TABLE IF EXISTS #LM40ToPost
;WITH LM40ToPost
AS
(
	SELECT LM40.*, RANK() OVER (PARTITION BY LM40.TransactionUUID ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
	LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
	WHERE LM43.acctID IS NULL
)
SELECT * 
INTO #LM40ToPost 
FROM LM40ToPost WHERE Ranking = 1


;WITH LM40ToNotPost
AS
(
	SELECT LM40.*, RANK() OVER (PARTITION BY LM40.transactionuuid ORDER BY LM40.POSTTIME DESC)  AS Ranking
	FROM #LM40 LM40
	LEFT JOIN #LM43 LM43 ON (LM40.TranID = LM43.RevTGT)
	WHERE LM43.acctID IS NOT NULL
)
SELECT * FROM LM40ToNotPost WHERE Ranking = 1

;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionLifeCycleUniqueID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT * FROM CTE WHERE Ranking = 1

; WITH CTE AS (SELECT *, RANK() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
SELECT 'TOTAL LM40===> ', COUNT(1) FROM CTE WHERE Ranking = 1

SELECT 'ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM #LM40ToPost

;WITH CTE AS (
SELECT L2.*, RANK() OVER (PARTITION BY L2.TransactionLifeCycleUniqueID ORDER BY L2.POSTTIME DESC)  AS Ranking
FROM #LM40ToPost L1 
RIGHT JOIN #LM40 L2 ON (L1.UniversalUniqueID = L2.UniversalUniqueID)
WHERE L1.UniversalUniqueID IS NULL)
SELECT 'NOT ELIGIBLE FOR CREDIT===> ', COUNT(1) FROM CTE WHERE Ranking = 1




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

SELECT * FROM Auth_Primary WITH (NOLOCK) WHERE transactionuuid = '000f9084-4b24-444e-a973-e68f99eac3e2' and cmttrantype = '93'

SELECT * FROM Auth_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 31667552

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 31667552

SELECT * FROM CoreAuthTransactions