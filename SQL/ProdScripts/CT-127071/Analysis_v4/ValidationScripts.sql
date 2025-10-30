SELECT DISTINCT TransactionUUID, TransactionLifeCycleUniqueID INTO #TxnFound FROM ##TempDataDisputes

SELECT * FROM ##TempDisputes
SELECT * FROM ##TempDataDisputes

SELECT * FROM ##TempDisputes WHERE TransactionUUID = 'f1af6418-15b1-4976-8ab8-95f0f4946c47'
SELECT * FROM #TxnFound WHERE TransactionUUID = 'f1af6418-15b1-4976-8ab8-95f0f4946c47'
SELECT * FROM #TxnNotFound WHERE TransactionUUID = 'f1af6418-15b1-4976-8ab8-95f0f4946c47'

DROP TABLE IF EXISTS #UniqueRecords
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, Amount, TranTime ORDER BY TranTime) [Ranking1]  FROM ##TempDisputes
)
SELECT ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) SN, TransactionUUID, Amount, TranTime, TRY_CAST(1 AS INT) Found,
TRY_CAST(NULL AS VARCHAR(19)) AccountNumber, TRY_CAST(0 AS INT) LM43, TRY_CAST(0 AS INT) LM49, TRY_CAST(0 AS DECIMAL(19,0)) TransactionLifeCycleUniqueID
INTO #UniqueRecords FROM CTE WHERE [Ranking1] = 1
--1983

DROP TABLE IF EXISTS #DuplicateRecords
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, Amount, TranTime ORDER BY TranTime) [Ranking1]  FROM ##TempDisputes
)
SELECT ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) SN, TransactionUUID, Amount, TranTime, TRY_CAST(1 AS INT) Found,
TRY_CAST(NULL AS VARCHAR(19)) AccountNumber, TRY_CAST(0 AS INT) LM43, TRY_CAST(0 AS INT) LM49, TRY_CAST(0 AS DECIMAL(19,0)) TransactionLifeCycleUniqueID
INTO #DuplicateRecords FROM CTE WHERE [Ranking1] > 1

SELECT TransactionLifeCycleUniqueID,count(1) FROM #UniqueRecords group by TransactionLifeCycleUniqueID
having count(1) > 1

SELECT * FROM #UniqueRecords

SELECT Found, COUNT(1) FROM #UniqueRecords GROUP BY Found

SELECT * INTO #UniqueRecords_Single FROM #UniqueRecords WHERE TransactionLifeCycleUniqueID NOT IN (0,23145878,697639863,823613629,846549782,867136021,883463066)
SELECT * INTO #UniqueRecords_Multiple FROM #UniqueRecords WHERE TransactionLifeCycleUniqueID IN (23145878,697639863,823613629,846549782,867136021,883463066)


SELECT * FROM #UniqueRecords
SELECT * FROM #TxnNotFound
SELECT * FROM #UniqueRecords_Single
SELECT * FROM #UniqueRecords_Multiple

--NotFound

SELECT * INTO #TxnNotFound FROM ##TempDisputes WHERE TransactionUUID IN (
SELECT DISTINCT TransactionUUID  FROM ##TempDisputes
EXCEPT
SELECT DISTINCT TransactionUUID  FROM ##TempDataDisputes)

UPDATE #UniqueRecords SET Found = 0 WHERE TransactionUUID IN (
SELECT TransactionUUID FROM #TxnNotFound)

SELECT * 
FROM #UniqueRecords T1
JOIN #TxnFound T2 ON (T1.TransactionUUID = T2.TransactionUUID)


UPDATE T1
SET TransactionLifeCycleUniqueID = T2.TransactionLifeCycleUniqueID
FROM #UniqueRecords T1
JOIN #TxnFound T2 ON (T1.TransactionUUID = T2.TransactionUUID)


DROP TABLE IF EXISTS #CCard
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount/*, CP.TransactionDescription*/, RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime--, CP.ClaimID, CP.TxnSource, CP.ArTxnType, MemoIndicator
INTO #CCard
FROM #UniqueRecords_Single T
JOIN ##TempDataDisputes CP WITH (NOLOCK) ON (T.TransactionUUID = CP.TransactionUUID)
WHERE CMTTranType IN ('40', '43')
AND T.Found = 1

SELECT CMTTranType, COUNT(1)
FROM #CCard
GROUP BY CMTTranType

SELECT UniversalUniqueID,* FROM ##TempDataDisputes WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 23145878
SELECT * FROM #UniqueRecords WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 23145878



DROP TABLE IF EXISTS #LM40
SELECT * INTO #LM40 FROM #CCard WHERE CMTTranType = '40'

DROP TABLE IF EXISTS #LM43
SELECT * INTO #LM43 FROM #CCard WHERE CMTTranType = '43'


;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime) [Rank] FROM #LM40 --WHERE Found = 1
)
SELECT * 
FROM CTE C
WHERE [Rank] > 1

DROP TABLE IF EXISTS #Unique40
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY TransactionUUID ORDER BY TranTime) [Rank] FROM #LM40
)
SELECT * 
INTO #Unique40
FROM CTE C
--RIGHT JOIN #UniqueRecords T ON (C.TransactionUUID = T.TransactionUUID)
WHERE [Rank] = 1
--AND C.TransactionUUID IS NULL

DROP TABLE IF EXISTS #CCardRecords
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, CP.ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, MemoIndicator
INTO #CCardRecords
FROM #Unique40 T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.TranID = CP.TranID)

SELECT * FROM #CCardRecords WHERE CaseID IS NULL AND ClaimID IS NULL
SELECT * FROM #CCardRecords WHERE TranID = 1171804297

UPDATE #CCardRecords SET ClaimID = 'aac439cf-3373-47aa-a4ff-c50f3f951d39' WHERE TranID = 1122734054
UPDATE #CCardRecords SET ClaimID = '7ad7c966-2b52-44d5-b432-ced819d08694' WHERE TranID = 1171804297

DROP TABLE IF EXISTS #TempWithDisputes
SELECT * INTO #TempWithDisputes FROM #CCardRecords WHERE ClaimID IS NOT NULL
--INSERT INTO #TempWithDisputes
--SELECT * FROM #CCardRecords WHERE CaseID IS NOT NULL

DROP TABLE IF EXISTS #TempTrue43
SELECT * INTO #TempTrue43 FROM #CCardRecords WHERE TranID IN (43906158411,44369239656,45817551988,46869380931)

SELECT * FROM #TempWithDisputes
SELECT * FROM #TempTrue43
SELECT * FROM #TempNoPC

SELECT COUNT(1) FROM #CCardRecords
SELECT COUNT(1) FROM #TempWithDisputes --WHERE AccountNumber IS NULL
SELECT COUNT(1) FROM #TempTrue43
SELECT COUNT(1) FROM #TempNoPC

SELECT TranID FROM #TempWithDisputes UNION SELECT TranID FROM #TempTrue43

DROP TABLE IF EXISTS #TempNoPC
SELECT * INTO #TempNoPC FROM #CCardRecords WHERE TranID NOT IN (SELECT TranID FROM #TempWithDisputes UNION SELECT TranID FROM #TempTrue43)

DROP TABLE IF EXISTS #TempWithDisputesHistory
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, ISNULL(CP.ClaimID, T.ClaimID) ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, CP.MemoIndicator
INTO #TempWithDisputesHistory
FROM #TempWithDisputes T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.ClaimID = CP.ClaimID AND T.AccountNumber = CP.AccountNumber)

INSERT INTO #TempWithDisputesHistory
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, ISNULL(CP.ClaimID, T.ClaimID) ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, CP.MemoIndicator
--INTO #TempWithDisputesHistory
FROM #TempWithDisputes T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.TranID = CP.TranID)
WHERE CP.TranID IN (1122734054, 1171804297)



SELECT * FROM #TempWithDisputesHistory WHERE ArTxnType <> '104' ORDER BY AccountNumber, ClaimID, PostTime DESC


SELECT AccountNumber, ClaimID, CMTTranType, SUM(TransactionAmount) TransactionAmount
INTO #TxnsAmount
FROM #TempWithDisputesHistory WHERE ArTxnType NOT IN ('104', '99') GROUP BY AccountNumber, ClaimID, CMTTranType 

DROP TABLE IF EXISTS #OriginalPurchase
SELECT *, TRY_CAST(0 AS MONEY) TotalPurchaseAmount, TRY_CAST(0 AS MONEY) TotalPC, TRY_CAST(0 AS MONEY) OTBHoldAmount,
TRY_CAST(0 AS DECIMAL(19,0)) GWC_TranID, TRY_CAST(NULL AS DATETIME) GWC_TranTime, TRY_CAST(NULL AS DATETIME) GWC_PostTime, TRY_CAST(0 AS MONEY) GWC_Amount
INTO #OriginalPurchase
FROM #TempWithDisputesHistory WHERE  CMTTranType = '40' AND TxnSource <> '10'

UPDATE T
SET TotalPurchaseAmount = T2.TransactionAmount
FROM #OriginalPurchase T
JOIN #TxnsAmount T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)
WHERE T2.CMTTranType = '40'


UPDATE T
SET TotalPC = T2.TransactionAmount
FROM #OriginalPurchase T
JOIN #TxnsAmount T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)
WHERE T2.CMTTranType = '43'

DROP TABLE IF EXISTS #OTB
;WITH CTE
AS
(
SELECT DISTINCT DisputeID, D.ClaimID, AccountNumber
FROM #OriginalPurchase T
JOIN DisputeStatusLog D WITH (NOLOCK) ON (T.ClaimID = D.ClaimID AND T.TranID = D.PurchaseTranId)
)
SELECT C.*, AmtOfDispRelFromOTB INTO #OTB FROM CTE C JOIN DisputeLog D WITH (NOLOCK) ON (C.DisputeID = D.DisputeID)

UPDATE T
SET OTBHoldAmount = T2.AmtOfDispRelFromOTB
FROM #OriginalPurchase T
JOIN #OTB T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)



SELECT * FROM #OriginalPurchase WHERE TotalPurchaseAmount <> TotalPC

SELECT * FROM DisputeStatusLog WITH (NOLOCK) WHERE ClaimID = '9f38d99d-b3ca-454c-aec0-d0e9e0d0962c'
SELECT * FROM DisputeLog WITH (NOLOCK) WHERE DisputeID = 837169

DROP TABLE IF EXISTS #GWC
SELECT T.*, C.TranID GWC_TranID, C.TranTime GWC_TranTime, C.PostTime GWC_PostTime , C.TransactionAmount GWC_TxnAmount,
ROW_NUMBER() OVER (PARTITION BY T.AccountNumber, C.TranID ORDER BY T.PostTime) GWC_Rank
INTO #GWC
FROM #OriginalPurchase T
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK) ON (T.AccountNumber = C.AccountNumber)
WHERE C.CMTTranType = '49' AND TransactionStatus = 2 AND ActualTranCode = '4907'

SELECT * FROM #GWC WHERE GWC_Rank = 1 AND GWC_TxnAmount = TransactionAmount

DROP TABLE IF EXISTS #GWC_Unique
SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber, TranID ORDER BY PostTime) T_Rank INTO #GWC_Unique FROM #GWC WHERE GWC_Rank = 1


SELECT * 
FROM #OriginalPurchase T
JOIN #GWC_Unique G ON (T.TranID = G.TranID AND G.T_Rank = 1)
WHERE  G.GWC_TxnAmount = G.TransactionAmount

UPDATE T
SET GWC_TranID = G.GWC_TranID, GWC_TranTime = G.GWC_TranTime, GWC_PostTime = G.GWC_PostTime, GWC_Amount = G.GWC_TxnAmount
FROM #OriginalPurchase T
JOIN #GWC_Unique G ON (T.TranID = G.TranID AND G.T_Rank = 1)
WHERE  G.GWC_TxnAmount = G.TransactionAmount

SELECT * FROM #OriginalPurchase

SELECT * FROM #GWC_Unique WHERE T_Rank = 1 AND GWC_TxnAmount = TransactionAmount





----------------------------------


--ALTER TABLE #UniqueRecords_Multiple ADD CCArdTranID DECIMAL(19,0)
SELECT * FROM #UniqueRecords_Multiple WHERE CCArdTranID IS NULL

SELECT TransactionAmount, CMTTranType, UniversalUniqueID, * FROM CCard_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 883463066 ORDER BY PostTime
SELECT * FROM #UniqueRecords_Multiple WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 883463066

UPDATE #UniqueRecords_Multiple SET CCArdTranID = 37323078957 WHERE SN = 945
UPDATE #UniqueRecords_Multiple SET CCArdTranID = 37323078959 WHERE SN = 948
UPDATE #UniqueRecords_Multiple SET CCArdTranID = 37323078961 WHERE SN = 949


SELECT TransactionAmount, CMTTranType, TransactionLifeCycleUUID, CoreAuthTranId, * FROM Auth_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 846549782 ORDER BY PostTime
SELECT * FROM #UniqueRecords_Multiple WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 846549782
SELECT TransactionAmount, CMTTranType, AuthTranID, * FROM CCard_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 846549782 AND AuthTranID = 846549782

SELECT T.* , A.CoreAuthTranId
FROM #UniqueRecords_Multiple T
JOIN Auth_Primary A WITH (NOLOCK) ON (T.TransactionLifeCycleUniqueID = A.TransactionLifeCycleUniqueID AND T.TransactionUUID = A.TransactionLifeCycleUUID)
WHERE T.CCardTranID IS NULL


SELECT T.* , A.TranID
FROM #UniqueRecords_Multiple T
JOIN CCard_Primary A WITH (NOLOCK) ON (T.TransactionLifeCycleUniqueID = A.TransactionLifeCycleUniqueID AND T.TransactionUUID = A.UniversalUniqueID)

SELECT * FROM #UniqueRecords_Multiple WHERE CCArdTranID IS  NULL


DROP TABLE IF EXISTS #CCardRecords_Multiple
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, CP.ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, MemoIndicator
INTO #CCardRecords_Multiple
FROM #UniqueRecords_Multiple T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.CCArdTranID = CP.TranID)

SELECT * FROM #CCardRecords_Multiple

DROP TABLE IF EXISTS #TempWithDisputes_Multiple
SELECT * INTO #TempWithDisputes_Multiple FROM #CCardRecords_Multiple WHERE ClaimID IS NOT NULL
--INSERT INTO #TempWithDisputes
--SELECT * FROM #CCardRecords WHERE CaseID IS NOT NULL

SELECT * FROM #CCardRecords_Multiple WHERE ClaimID IS NULL

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE RevTgt IN (SELECT TranID FROM #CCardRecords_Multiple WHERE ClaimID IS NULL)

--DROP TABLE IF EXISTS #TempTrue43_Multiple
--SELECT * INTO #TempTrue43_Multiple FROM #CCardRecords_Multiple WHERE TranID IN (43906158411,44369239656,45817551988,46869380931)

SELECT * FROM #TempWithDisputes_Multiple
SELECT * FROM #TempTrue43_Multiple
SELECT * FROM #TempNoPC_Multiple

SELECT COUNT(1) FROM #CCardRecords
SELECT COUNT(1) FROM #TempWithDisputes --WHERE AccountNumber IS NULL
SELECT COUNT(1) FROM #TempTrue43
SELECT COUNT(1) FROM #TempNoPC

SELECT TranID FROM #TempWithDisputes UNION SELECT TranID FROM #TempTrue43

DROP TABLE IF EXISTS #TempNoPC_Multiple
SELECT * INTO #TempNoPC_Multiple FROM #CCardRecords_Multiple WHERE TranID NOT IN (SELECT TranID FROM #TempWithDisputes_Multiple)

DROP TABLE IF EXISTS #TempWithDisputesHistory_Multiple
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, ISNULL(CP.ClaimID, T.ClaimID) ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, CP.MemoIndicator
INTO #TempWithDisputesHistory_Multiple
FROM #TempWithDisputes_Multiple T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.ClaimID = CP.ClaimID AND T.AccountNumber = CP.AccountNumber)

INSERT INTO #TempWithDisputesHistory_Multiple
SELECT CP.AccountNumber, CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.TransactionDescription, CP.RevTgt, T.TransactionUUID, CP.TransactionLifeCycleUniqueID,
CP.TranTime, CP.PostTime, ISNULL(CP.ClaimID, T.ClaimID) ClaimID, CP.CaseID, CP.TxnSource, CP.ArTxnType, CP.MemoIndicator
--INTO #TempWithDisputesHistory
FROM #TempWithDisputes_Multiple T
JOIN CCArd_Primary CP WITH (NOLOCK) ON (T.TranID = CP.TranID)
WHERE CP.TranID IN (1122734054, 1171804297)



SELECT * FROM #TempWithDisputesHistory WHERE ArTxnType <> '104' ORDER BY AccountNumber, ClaimID, PostTime DESC

DROP TABLE IF EXISTS #TxnsAmount_Multiple
SELECT AccountNumber, ClaimID, CMTTranType, SUM(TransactionAmount) TransactionAmount
INTO #TxnsAmount_Multiple
FROM #TempWithDisputesHistory_Multiple WHERE ArTxnType NOT IN ('104', '99') AND CMTTRanType <> '16' GROUP BY AccountNumber, ClaimID, CMTTranType 

SELECT * FROm #TxnsAmount_Multiple

DROP TABLE IF EXISTS #OriginalPurchase_Multiple
SELECT *, TRY_CAST(0 AS MONEY) TotalPurchaseAmount, TRY_CAST(0 AS MONEY) TotalPC, TRY_CAST(0 AS MONEY) OTBHoldAmount,
TRY_CAST(0 AS DECIMAL(19,0)) GWC_TranID, TRY_CAST(NULL AS DATETIME) GWC_TranTime, TRY_CAST(NULL AS DATETIME) GWC_PostTime, TRY_CAST(0 AS MONEY) GWC_Amount
INTO #OriginalPurchase_Multiple
FROM #TempWithDisputesHistory_Multiple WHERE  CMTTranType = '40' AND TxnSource <> '10'

UPDATE T
SET TotalPurchaseAmount = T2.TransactionAmount
FROM #OriginalPurchase_Multiple T
JOIN #TxnsAmount_Multiple T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)
WHERE T2.CMTTranType = '40'


UPDATE T
SET TotalPC = T2.TransactionAmount
FROM #OriginalPurchase_Multiple T
JOIN #TxnsAmount_Multiple T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)
WHERE T2.CMTTranType = '43'

DROP TABLE IF EXISTS #OTB_Multiple
;WITH CTE
AS
(
SELECT DISTINCT DisputeID, D.ClaimID, AccountNumber
FROM #OriginalPurchase_Multiple T
JOIN DisputeStatusLog D WITH (NOLOCK) ON (T.ClaimID = D.ClaimID AND T.TranID = D.PurchaseTranId)
)
SELECT C.*, AmtOfDispRelFromOTB INTO #OTB_Multiple FROM CTE C JOIN DisputeLog D WITH (NOLOCK) ON (C.DisputeID = D.DisputeID)

UPDATE T
SET OTBHoldAmount = T2.AmtOfDispRelFromOTB
FROM #OriginalPurchase_Multiple T
JOIN #OTB_Multiple T2 ON (T.AccountNumber = T2.AccountNumber AND T.ClaimID = T2.ClaimID)



SELECT * FROM #OriginalPurchase WHERE TotalPurchaseAmount <> TotalPC

SELECT * FROM DisputeStatusLog WITH (NOLOCK) WHERE ClaimID = '9f38d99d-b3ca-454c-aec0-d0e9e0d0962c'
SELECT * FROM DisputeLog WITH (NOLOCK) WHERE DisputeID = 837169

SELECT * FROm #OriginalPurchase_Multiple

DROP TABLE IF EXISTS #GWC_Multiple
SELECT T.*, C.TranID GWC_TranID1, C.TranTime GWC_TranTime1, C.PostTime GWC_PostTime1 , C.TransactionAmount GWC_TxnAmount1,
ROW_NUMBER() OVER (PARTITION BY T.AccountNumber, C.TranID ORDER BY T.PostTime) GWC_Rank
INTO #GWC_Multiple
FROM #OriginalPurchase_Multiple T
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK) ON (T.AccountNumber = C.AccountNumber)
WHERE C.CMTTranType = '49' AND TransactionStatus = 2 AND ActualTranCode = '4907'

SELECT * FROM #GWC WHERE GWC_Rank = 1 AND GWC_TxnAmount = TransactionAmount

DROP TABLE IF EXISTS #GWC_Unique_Multiple
SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber, TranID ORDER BY PostTime) T_Rank INTO #GWC_Unique_Multiple FROM #GWC_Multiple WHERE GWC_Rank = 1


SELECT * 
FROM #OriginalPurchase_Multiple T
JOIN #GWC_Unique_Multiple G ON (T.TranID = G.TranID AND G.T_Rank = 1)
WHERE  G.GWC_TxnAmount1 = G.TransactionAmount

UPDATE T
SET GWC_TranID = G.GWC_TranID, GWC_TranTime = G.GWC_TranTime, GWC_PostTime = G.GWC_PostTime, GWC_Amount = G.GWC_TxnAmount
FROM #OriginalPurchase T
JOIN #GWC_Unique G ON (T.TranID = G.TranID AND G.T_Rank = 1)
WHERE  G.GWC_TxnAmount = G.TransactionAmount




SELECT * FROM #OriginalPurchase

SELECT COUNT(1) FROM #CCardRecords
SELECT COUNT(1) FROM #TempWithDisputes --WHERE AccountNumber IS NULL
SELECT COUNT(1) FROM #TempTrue43
SELECT COUNT(1) FROM #TempNoPC

SELECT * FROM #OriginalPurchase_Multiple

SELECT COUNT(1) FROM #CCardRecords_Multiple
SELECT COUNT(1) FROM #TempWithDisputes_Multiple --WHERE AccountNumber IS NULL
--SELECT COUNT(1) FROM #TempTrue43
SELECT COUNT(1) FROM #TempNoPC_Multiple

SELECT * FROM #TempNoPC


SELECT * FROM #UniqueRecords
SELECT * FROM #TxnNotFound
SELECT * FROM #UniqueRecords_Single
SELECT * FROM #UniqueRecords_Multiple

;WITH CTE
AS
(
SELECT * FROM #OriginalPurchase
UNION 
SELECT * FROM #OriginalPurchase_Multiple
)
SELECT BS.ClientID, BP.UniversalUniqueID AccountUUID, C.*
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctID = BS.acctID)
JOIN CTE C ON (C.AccountNumber = BP.AccountNumber)

SELECT * FROM #TxnNotFound

SELECT TransactionUUID,Amount,TranTime FROM #UniqueRecords_Multiple WHERE CCArdTranID IS  NULL

;WITH CTE
AS
(
SELECT * FROM #TempNoPC_Multiple
)
SELECT BS.ClientID, BP.UniversalUniqueID AccountUUID, C.*
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctID = BS.acctID)
JOIN CTE C ON (C.AccountNumber = BP.AccountNumber)

;WITH CTE
AS
(
SELECT * FROM #TempTrue43
)
SELECT BS.ClientID, BP.UniversalUniqueID AccountUUID, C.*
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctID = BS.acctID)
JOIN CTE C ON (C.AccountNumber = BP.AccountNumber)

SELECT TransactionUUID,Amount,TranTime FROM #UniqueRecords

SELECT TransactionUUID,Amount,TranTime FROM #DuplicateRecords




/*

SELECT ClaimID, CaseID, MemoIndicator,* FROM CCard_Primary WITH (NOLOCK) WHERE RevTgt IN (SELECT TranID FROM #CCardRecords WHERE CaseID IS NULL AND ClaimID IS NULL) AND CMTTranType = '43'
SELECT ClaimID, CaseID, MemoIndicator,* FROM CCard_Primary WITH (NOLOCK) WHERE RevTgt IN (43906158411)


SELECT * FROM #TempWithDisputes



SELECT TxnSource, COUNT(1)
FROM #LM40
WHERE ClaimID IS NOT NULL
GROUP BY TxnSource


SELECT MemoIndicator, COUNT(1)
FROM #LM43
GROUP BY MemoIndicator

SELECT * FROM #LM40 WHERE ClaimID IS NOT NULL

SELECT DISTINCT ClaimID FROM #LM40 WHERE ClaimID IS NOT NULL

SELECT *, ROW_NUMBER() OVER (PARTITION BY T2.TransactionUUID, TranID ORDER BY T2.TranTime) [Ranking1] 
FROM ##TempDisputes T1
JOIN #LM43 T2 ON (T1.TransactionUUID = t2.TransactionUUID)
WHERE T1.Amount = T2.TransactionAmount
AND T1.TransactionUUID = '497bac0f-5bef-4fd0-9b83-6bb6fa9d5702'

SELECT * FROM ##TempDisputes WHERE TransactionUUID = 'f1af6418-15b1-4976-8ab8-95f0f4946c47'
SELECT * FROM #LM43 WHERE TransactionUUID = '497bac0f-5bef-4fd0-9b83-6bb6fa9d5702'


DROP TABLE IF EXISTS #LM43Found
;WITH CTE
AS
(
SELECT T1.SN, T2.*, ROW_NUMBER() OVER (PARTITION BY T1.SN ORDER BY T2.TranTime DESC) [Ranking1] 
FROM #UniqueRecords T1
JOIN #LM43 T2 ON (T1.TransactionUUID = t2.TransactionUUID)
WHERE T1.Amount = T2.TransactionAmount
)
SELECT * INTO #LM43Found FROM CTE WHERE [Ranking1] = 1
--1350

--DROP TABLE IF EXISTS #LM43Found
;WITH CTE
AS
(
SELECT T1.SN, T1.TranTime TxnTime, T2.*, ROW_NUMBER() OVER (PARTITION BY T1.SN ORDER BY T1.TranTime) [Ranking1] 
FROM #UniqueRecords T1
JOIN #LM43 T2 ON (T1.TransactionUUID = t2.TransactionUUID)
WHERE T1.Amount = T2.TransactionAmount
)
SELECT * 
--INTO #LM43Found 
FROM CTE WHERE [Ranking1] > 1

SELECT DISTINCT SN FROM #LM43Found

SELECT * FROM #UniqueRecords WHERE SN = 46
SELECT * FROM #LM43 WHERE TransactionUUID = '6f3b4e9c-6b58-44b6-b495-d517c0273eda'

SELECT * FROM #Ccard WHERE TransactionLifeCycleUniqueID = 108293067

UPDATE T1
SET LM43 = 1
FROM #UniqueRecords T1
JOIN #LM43Found T2 ON (T1.SN = T2.SN)
--1350

SELECT * INTO ##UniqueRecordsNotNULL FROM #UniqueRecords WHERE AccountNumber IS NOT NULL

;WITH CTE
AS
(
SELECT DISTINCT TransactionUUID, AccountNumber
FROM #CCard
)
UPDATE T
SET AccountNumber = C.AccountNumber
FROM #UniqueRecords T
JOIN CTE C ON (T.TransactionUUID = C.TransactionUUID)

SELECT * FROM #UniqueRecords 

SELECT ActualTranCode, COUNT(1) FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK) WHERE CMTTranType = '49' GROUP BY ActualTranCode

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK) WHERE CMTTranType = '49' AND ActualTranCode = '4918'

SELECT T.SN, T.Amount, C.TranID, C.TransactionAmount, C.TranTime, C.PostTime 
FROM #UniqueRecords T
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK) ON (T.AccountNumber = C.AccountNumber)
WHERE T.AccountNumber IS NOT NULL AND C.CMTTRanType = '49' AND TransactionStatus = 2
AND T.Amount = C.TransactionAmount

DROP TABLE IF EXISTS #CCardDataLM49
SELECT T.SN, T.Amount, C.TranID, C.TransactionAmount, C.CMTTRanType, C.TranTime, C.PostTime, TxnCode_Internal, TransactionDescription 
INTO #CCardDataLM49
FROM #UniqueRecords T
JOIN CCard_Primary C WITH (NOLOCK) ON (T.AccountNumber = C.AccountNumber)
WHERE T.AccountNumber IS NOT NULL --AND C.CMTTRanType = '49' --AND TxnCode_Internal = '17505'
--AND T.Amount = C.TransactionAmount


*/



