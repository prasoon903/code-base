DROP TABLE IF EXISTS #ValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, CaseID ORDER BY SN) [Rank] 
	FROM ##TempRecords
	WHERE CaseID IS NOT NULL
)
SELECT * 
--INTO #ValidData 
FROM CTE WHERE [Rank] > 1

--SELECT * FROM ##TempRecords WHERE TransactionUUID = '29ed4c73-0bed-465f-8faf-7eff4cd199db'
SELECT * FROM ##TempData WHERE TransactionUUID = '29ed4c73-0bed-465f-8faf-7eff4cd199db'
SELECT * FROM #ValidData WHERE TransactionUUID = '29ed4c73-0bed-465f-8faf-7eff4cd199db'


DROP TABLE IF EXISTS #LM40
;WITH CTE
AS
(
	SElect *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID, TranID ORDER BY TranTime) [Ranking1] 
	FROM ##TempData WHERE cmttrantype = '40'
)
SELECT * INTO #LM40 FROM CTE WHERE [Ranking1] = 1

DROP TABLE IF EXISTS #OriginalLM40
SELECT T1.*, CP.TxnSource, CP.ClaimID
INTO #OriginalLM40 
FROM #LM40 T1
JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranID)
WHERE CP.TxnSource <> '10'


SELECT * FROM #OriginalLM40 WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')
SELECT * FROM #LM40 WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')
SELECT * FROM ##TempRecords WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')

SELECT CaseID, ClaimID,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 885871040

DROP TABLE IF EXISTS #LM40WithDisputes
;WITH CTE
AS
(
	SELECT T1.*, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, T1.ClaimID ORDER BY T1.TranTime) [Rank]
	FROM #OriginalLM40 T1
	JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranRef)
	WHERE CP.CMTTranType = '110'
)
SELECT * INTO #LM40WithDisputes FROM CTE WHERE [Rank] = 1

SELECT * FROM #LM40WithDisputes WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')

DROP TABLE IF EXISTS #TempRewardDetails
SELECT D1.Skey,T1.acctId, T1.AccountNumber, T1.UniversalUniqueID AccountUUID, D1.PurchaseTranId, T1.TranTime, T1.TransactionLifeCycleUniqueID, 
T1.TransactionUUID, D1.DisputeID, D1.TotalRewardPoints, D1.DisputeStage
INTO #TempRewardDetails
FROM #LM40WithDisputes T1
JOIN DisputeLog D1 WITH (NOLOCK) ON (T1.TranId = D1.PurchaseTranId)


SELECT * FROM #TempRewardDetails WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')

DROP TABLE IF EXISTS #TempRewardDetailsWithClaimID
SELECT T1.*, ISNULL(CP.ClaimID, CP.CaseID) ClaimID
INTO #TempRewardDetailsWithClaimID
FROM #TempRewardDetails T1
JOIN CCard_Primary CP WITH (NOLOCK) ON (T1.PurchaseTranID = CP.TranID)

SELECT * FROM #TempRewardDetailsWithClaimID WHERE PurchaseTranID = 885871040

SELECT * FROM #ValidData WHERE TransactionUUID IN ('29ed4c73-0bed-465f-8faf-7eff4cd199db')

SELECT * FROM #TempRewardDetailsWithClaimID WHERE DisputeStage <> 0

--DROP TABLE IF EXISTS #ValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY PurchaseTranID, ClaimID ORDER BY TranTime) [Rank] 
	FROM #TempRewardDetailsWithClaimID
)
SELECT * FROM CTE WHERE [Rank] > 1

DROP TABLE IF EXISTS #TempNotMapped
SELECT T2.*
INTO #TempNotMapped 
FROM #TempRewardDetailsWithClaimID T1
RIGHT JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
WHERE --T2.CaseID IS NOT NULL AND 
T1.ClaimID IS NULL

DROP TABLE IF EXISTS #TempMapped
SELECT T1.*
INTO #TempMapped 
FROM #TempRewardDetailsWithClaimID T1
JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
--WHERE T2.CaseID IS NOT NULL


SELECT COUNT(1) FROM #TempMapped

SELECT COUNT(1) FROM #TempNotMapped

SELECT COUNT(1) FROM #ValidData-- WHERE CaseID IS NOT NULL



SELECT 'UPDATE TOP(1) DisputeLog SET TotalRewardPoints = 0.00 WHERE Skey = ' + TRY_CAST(Skey AS VARCHAR) --, * 
FROM #TempMapped

SELECT * FROM #TempNotMapped
SELECT * FROM ##TempData WHERE TransactionUUID = 'dd8641e0-64e8-445b-a465-a93fb75a7c74'
SELECT * FROM #ValidData WHERE CaseID = 'ce73bc20-4cc9-4cd8-8bc6-bf6278dc8993'
SELECT * FROM #TempRewardDetailsWithClaimID WHERE ClaimID = 'ce73bc20-4cc9-4cd8-8bc6-bf6278dc8993'

SELECT * FROM #ValidData-- WHERE CaseID IS NOT NULL

SELECT RTRIM(AccountNumber) AccountNumber, acctid, AccountUUID, PurchaseTranID, TranTime TransactionTime, TransactionUUID TransactionID, DisputeID, ClaimID CaseID, TotalRewardPoints
FROM #TempMapped
WHERE ISNULL(TotalRewardPoints, 0.00) <> 0.00


SELECT COUNT(1)
FROM #TempMapped T1
JOIN DisputeLog D1 WITH (NOLOCK) ON (T1.Skey = D1.Skey)
WHERE ISNULL(D1.TotalRewardPoints, 0.00) <> 0.00

SELECT T1.CaseID, T1.ClientID, T1.TransactionUUID, T1.AccountUUID, T1.Amount
FROM #TempNotMapped T1
LEFT JOIN Bsegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)
WHERE BP.UniversalUniqueID IS NOT NULL


SELECT T1.CaseID, T1.ClientID, T1.TransactionUUID, T1.AccountUUID, T1.Amount
FROM #TempNotMapped T1
LEFT JOIN Bsegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)
WHERE BP.UniversalUniqueID IS NULL


SELECT T1.CaseID, T1.ClientID, T1.TransactionUUID, T1.AccountUUID, T1.Amount FROM #ValidData t1-- WHERE CaseID IS NOT NULL



---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STEP-1: Fill the temp table ##TempData
-------------------------------------------------------

SELECT * FROM ##TempData --WHERE TransactionUUID = '36c37c5c-d549-422e-807f-5c9c98b681b4'

--1128254252
-------------------------------------------------------
-- STEP-2: Seperate the data into LM40 and LM43 
-------------------------------------------------------

DROP TABLE IF EXISTS #LM40
SElect * INTO #LM40 FROM ##TempData WHERE cmttrantype = '40'

SELECT * FROM #LM40 WHERE transactionlifecycleuniqueid = 1128254252

--SElect DISTINCT transactionlifecycleuniqueid, AccountNumber FROM ##TempData WHERE cmttrantype = '40'

--SELECT * 
--FROm #LM40 t1
--RIGHT JOIN  ##TempRecords t2 ON (t1.TransactionUUID = t2.TransactionUUID)
--WHERE t1.TransactionUUID IS NULL

DROP TABLE IF EXISTS #OriginalLM40
SELECT T1.*, CP.TxnSource, CP.ClaimID
INTO #OriginalLM40 
FROM #LM40 T1
JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranID)
WHERE CP.TxnSource <> '10'

DROP TABLE IF EXISTS #LM40WithDisputes
SELECT T1.*
INTO #LM40WithDisputes
FROM #OriginalLM40 T1
JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranRef)
WHERE CP.CMTTranType = '110'
--AND T1.TranID = 41378136636



--DROP TABLE IF EXISTS #OriginalLM40
--;WITH CTE AS (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime ) RowCounter
--FROM #LM40 )
--SELECT *
--INTO #OriginalLM40 
--FROM CTE WHERE RowCounter = 1

--DROP TABLE IF EXISTS #DuplicateLM40
--;WITH CTE AS (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime ) RowCounter
--FROM #LM40 )
--SELECT *
--INTO #DuplicateLM40 
--FROM CTE WHERE RowCounter > 1

SELECT * FROM #OriginalLM40 WHERE TransactionLifeCycleUniqueID = 1128254252

--SELECT * FROM #DuplicateLM40 WHERE TransactionLifeCycleUniqueID = 108293067

SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE PurchaseTranId = 33767559689

DROP TABLE IF EXISTS #TempRewardDetails
SELECT T1.acctId, T1.AccountNumber, T1.UniversalUniqueID AccountUUID, D1.PurchaseTranId, T1.TranTime, T1.TransactionLifeCycleUniqueID, T1.TransactionUUID, D1.DisputeID, D1.TotalRewardPoints
INTO #TempRewardDetails
FROM #LM40WithDisputes T1
JOIN DisputeLog D1 WITH (NOLOCK) ON (T1.TranId = D1.PurchaseTranId)
--JOIN ##TempRecords T2 ON (T1.TransactionUUID = T2.TransactionUUID)

SELECT * FROM ##TempRecords WHERE CaseID IS NOT NULL

SELECT * FROM #LM40WithDisputes

SELECT * FROM #OriginalLM40 WHERE TransactionUUID = '0c3eed1f-708a-4002-b910-9737bdbbcfb0'

SELECT * FROM #LM40WithDisputes

SELECT * FROM #TempRewardDetails ORDER BY TransactionUUID

--DROP TABLE IF EXISTS #ValidData
;WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID ORDER BY TransactionUUID) RowCounter
FROM ##TempRecords

)
SELECT * 
--INTO #ValidData
FROM cte WHERE RowCounter > 1
AND CaseID IS NOT NULL 

SELECT * FROM #ValidData

SELECT * FROM ##TempRecords WITH (NOLOCK) WHERE TransactionUUID = '0c3eed1f-708a-4002-b910-9737bdbbcfb0'


SELECT T1.*, CP.ClaimID
INTO #TempRewardDetailsWithClaimID
FROM #TempRewardDetails T1
JOIN CCard_Primary CP WITH (NOLOCK) ON (T1.PurchaseTranID = CP.TranID)

SELECT * FROM #TempRewardDetailsWithClaimID

DROP TABLE IF EXISTS #TempNotMapped
SELECT T2.*
INTO #TempNotMapped 
FROM #TempRewardDetailsWithClaimID T1
RIGHT JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
WHERE --T2.CaseID IS NOT NULL AND 
T1.ClaimID IS NULL

DROP TABLE IF EXISTS #TempMapped
SELECT T1.*
INTO #TempMapped 
FROM #TempRewardDetailsWithClaimID T1
JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
--WHERE T2.CaseID IS NOT NULL

SELECT T1.* 
FROM #TempNotMapped T1
LEFT JOIN Bsegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)
WHERE BP.UniversalUniqueID IS NULL

SELECT acctId, AccountNumber FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '703104c8-5840-4425-98be-da2704b713a8'


SELECT acctId FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.Bsegment_Secondary WITH (NOLOCK) WHERE ClientID = 'eb6aba92-b4ba-4fec-bbad-82e0d01327b3'

SELECT * FROM ##TempRecords WITH (NOLOCK) WHERE TransactionUUID = '229c9786-7ccb-4d58-82d3-9907e6abc8a5'

SELECT COUNT(1) FROM #TempFinal

SELECT COUNT(1) FROM #TempNotMapped

SELECT COUNT(1) FROM #ValidData-- WHERE CaseID IS NOT NULL

SELECT * FROM ##TempRecords WHERE AccountUUID IS NULL AND CaseID IS NOT NULL


;WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID ORDER BY TransactionUUID) RowCounter1
FROM #ValidData 
)
SELECT * FROM cte WHERE RowCounter1 > 1

DROP TABLE IF EXISTS #TempFinal
;WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY PurchaseTranID ORDER BY TranTime) RowCounter
FROM #TempMapped 
)
SELECT * INTO #TempFinal FROM cte WHERE RowCounter = 1


SELECT * 
FROm #TempRewardDetails T1
RIGHT JOIN #LM40WithDisputes T2 ON (T1.PurchaseTranId = T2.TranID)
WHERE t1.PurchaseTranId IS NULL


SELECT * FROM #OriginalLM40 WHERE TranID = 41378136636

SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE PurchaseTranId = 33767559689

SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE TransactionLifeCycleUniqueID = 681826074

SELECT * FROM #DuplicateLM40 WHERE TransactionLifeCycleUniqueID = 544832484

SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE PurchaseTranId = 33767559689


SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE TransactionLifeCycleUniqueID = 544832484


SELECT ClaimID,* 
FROM DisputeStatusLog WITH (NOLOCK)
WHERE DisputeID IN (1804815,1804817,1804820)
ORDER BY Skey DESC


SELECT TotalRewardPoints,* 
FROM DisputeLog WITH (NOLOCK)
WHERE PurchaseTranId = 35902009354

;WITH cte
AS
(
--DROP TABLE IF EXISTS #TempRewardDetails
SELECT T1.AccountNumber, T1.UniversalUniqueID AccountUUID, D1.PurchaseTranId, T1.TranTime, T1.TransactionLifeCycleUniqueID, D1.DisputeID, 
ROW_NUMBER() OVER (PARTITION BY T1.TransactionLifeCycleUniqueID ORDER BY TranTime) RowCounter
--INTO #TempRewardDetails
FROM #OriginalLM40 T1
JOIN DisputeLog D1 WITH (NOLOCK) ON (T1.TransactionLifeCycleUniqueID = D1.TransactionLifeCycleUniqueID)
)
SELECT * FROm CTE WHERE RowCounter > 1

SELECT C.TransactionLifeCycleUniqueID, C.TxnSource, BSAcctId, AccountNumber, TransactionAmount, ARTxnType, AuthTranID, * 
FROM CCard_Primary C WITH (NOLOCK) WHERE C.TransactionLifeCycleUniqueID = 108293067 --854723 Exclude
AND CMTTranType = '40'


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

#LM40ToPost_NonMerge

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


'f6ca14e5-415a-47b1-9de6-a1d3add41475',
'0b877810-7ef5-4c35-a97d-e3ef82a47cbf',
'f7f490a5-474c-436e-b5af-cbf28e15d674',
'5155941e-24ac-4e0f-a910-cd664007d237',
'e497a398-a32e-4519-b394-2cd584ba782d',
'2621f861-efa4-410e-b6b2-04dd4325c658',
'69e7b58d-ba3c-4ebe-b52f-50ebedd071b2',
'6fb19900-3049-4bdc-b12b-3281da2014c9',
'05168265-d5cc-4f4a-828b-b7fa384aba3e'




SELECT * FROM ##TempData WHERE transactionuuid = 'f6ca14e5-415a-47b1-9de6-a1d3add41475'

WITH CTE AS (
SELECT *, RANK() OVER(PARTITION BY transactionuuid ORDER BY TranTIme ASC) Ranking 
FROM ##TempData
WHERE cmttranType = '40')
SELECT * FROM CTE 
ORDER BY transactionuuid


SELECT BSAcctId, ArTxnType, TransactionAmount, * 
FROM CCard_Primary WITH (NOLOCK) 
WHERE TransactionLifeCycleUniqueID = 537450217 ORDER BY TranTIme

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