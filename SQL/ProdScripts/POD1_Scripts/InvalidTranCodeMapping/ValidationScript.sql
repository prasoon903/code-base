DROP TABLE IF EXISTS #TempTransactionPosted
SELECT *
INTO #TempTransactionPosted
FROM LS_ProdDRGSDB01.CCGS_CoreIssue.DBO.CreateNewSingleTransactionData CN WITH (NOLOCK)
WHERE CMTTranType = '49'

SELECT ChargeOffReason, *
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE ActualTranCode IN ('4901D', '4902D', '4903D')

--('18619','18622','18628')

SELECT COUNT(1)
FROM CCard_Primary WITH (NOLOCK)
WHERE TxnCode_Internal IN ('18619','18622','18628')
AND ArTxnType = '96'

;WITH CTE
AS
(
SELECT TranID, TxnCode_Internal, TransactionDescription
FROM CCard_Primary WITH (NOLOCK)
WHERE TxnCode_Internal IN ('18619','18622','18628')
AND ArTxnType = '96'
)
, CTE2 AS
(
SELECT *
FROM #TempTransactionPosted CN WITH (NOLOCK)
WHERE CMTTranType = '49'
)
SELECT RTRIM(C2.AccountNumber) AccountNumber, C1.TranID, C1.TxnCode_Internal TxnCode_Internal_Posted, 
C2.TxnCode_Internal TxnCode_Internal_Correct, C1.TransactionDescription TransactionDescription_Posted, 
C2.ActualTranCode TxnPostedWithTranCode, C2.TransactionAmount, TranTime, PostTime
FROM CTE C1
JOIN CTE2 C2 ON (C1.TranID = C2.TranID)



;WITH CTE
AS
(
SELECT RTRIM(C1.AccountNumber) AccountNumber, C1.TranID, TransactionAmount, TranTime, PostTime, TxnCode_Internal, TransactionDescription, C2.PreparedBy
FROM CCard_Primary C1 WITH (NOLOCK)
LEFT JOIN CCArd_Secondary C2 WITH (NOLOCK) ON (C1.TranID = C2.TranID)
WHERE TxnCode_Internal IN ('18619','18622','18628')
AND ArTxnType = '96'
)
, CTE2 AS
(
SELECT *
FROM #TempTransactionPosted CN WITH (NOLOCK)
WHERE CMTTranType = '49'
)
SELECT C1.*
FROM CTE C1
Left JOIN CTE2 C2 ON (C1.TranID = C2.TranID)
WHERE C2.TranID IS NULL
