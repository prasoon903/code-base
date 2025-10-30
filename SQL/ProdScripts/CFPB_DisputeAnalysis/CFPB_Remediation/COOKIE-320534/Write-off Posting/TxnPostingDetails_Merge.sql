SELECT *
FROM ##CBRGWCPosting_COOKIE_311077

SELECT COUNT(1) TotalTxns
FROM ##CBRGWCPosting_COOKIE_311077
--28420

SELECT COUNT(DISTINCT Account_Id) TotalAccounts
FROM ##CBRGWCPosting_COOKIE_311077
--28403


--FETCH ACCOUNT DATA
DROP TABLE IF EXISTS #AccountData_POD1_Merge
SELECT T1.*, B.DestAccountNumber AccountNumber, B.DestBSAcctId acctID, B.JobStatus, B.DestPODID
INTO #AccountData_POD1_Merge
FROM ##CBRGWCPosting_COOKIE_311077 T1
JOIN MergeAccountJob B WITH (NOLOCK) ON (B.SrcBSAccountUUID = T1.Account_Id)
WHERE B.JobStatus = 'DONE'
AND B.DestPODID = 1
--56


--SELECT T1.*, B.DestAccountNumber AccountNumber, B.DestBSAcctId acctID, B.JobStatus, B.DestPODID
--FROM ##CBRGWCPosting_COOKIE_311077 T1
--JOIN MergeAccountJob B WITH (NOLOCK) ON (B.SrcBSAccountUUID = T1.Account_Id)
--WHERE B.JobStatus = 'DONE'
--AND B.DestPODID = 1 AND B.SrcPODID <> 1




-- TRANSACTION POSTING VALIDATION


;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY SN) TxnCount
FROM #AccountData_POD1_Merge
)
SELECT *
FROM CTE
WHERE TxnCount > 1

SELECT *
FROM #AccountData_POD1_Merge
WHERE ISNULL(Transaction_Amount, 0) = 0


DROP TABLE IF EXISTS #AccountData_POD1_Merge_TxnPosting
SELECT AccountNumber, acctID, Account_Id, Transaction_Code, SUM(Transaction_Amount) TransactionAmount
INTO #AccountData_POD1_Merge_TxnPosting
FROM #AccountData_POD1_Merge
GROUP BY AccountNumber, acctID, Account_Id, Transaction_Code


DROP TABLE IF EXISTS #AccountData_POD1_Merge_Txns
SELECT CP.AccountNumber, T.Account_Id, T.acctID, CP.TranID, CP.TransactionAmount, CP.TranTime, CP.PostTime, CP.PostingRef, CP.TransactionDescription
INTO #AccountData_POD1_Merge_Txns
FROM #AccountData_POD1_Merge_TxnPosting T
JOIN CCard_Primary CP WITH (NOLOCK) ON (CP.AccountNumber = T.AccountNumber)
WHERE TxnCode_Internal = '17505'
AND CMTTRANTYPE = '49'
AND PostTime > '2025-05-13'


DROP TABLE IF EXISTS #AccountData_POD1_Merge_PostedTxns
SELECT T.*
INTO #AccountData_POD1_Merge_PostedTxns
FROM #AccountData_POD1_Merge_Txns T
JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (T.TranID = TIA.Tran_Id_Index)
WHERE ATID = 51


DROP TABLE IF EXISTS #PostingResults
;WITH CTE
AS
(
SELECT AccountNumber, SUM(TransactionAmount) TransactionAmount
FROM #AccountData_POD1_Merge_PostedTxns
GROUP BY AccountNumber
)
SELECT T1.*, ISNULL(T2.TransactionAmount, 0) PostedTransactionAmount,
CASE 
	WHEN T1.TransactionAmount = 0 THEN 'POSTING NOT REQUIRED AS AMOUNT IS $0'
	WHEN T1.TransactionAmount > 0 AND ISNULL(T2.TransactionAmount, 0) = 0 THEN 'NOT POSTED YET'
	WHEN T1.TransactionAmount > 0 AND T1.TransactionAmount = ISNULL(T2.TransactionAmount, 0) THEN 'SUCCESSFULLY POSTED'
	WHEN T1.TransactionAmount > 0 AND T1.TransactionAmount > ISNULL(T2.TransactionAmount, 0) THEN 'PARTIALLY POSTED'
	WHEN T1.TransactionAmount > 0 AND T1.TransactionAmount < ISNULL(T2.TransactionAmount, 0) THEN 'EXTRA AMOUNT POSTED'
END PostingResult
INTO #PostingResults
FROM #AccountData_POD1_Merge_TxnPosting T1
LEFT JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)


SELECT PostingResult, COUNT(1) RecordCount
FROM #PostingResults
GROUP BY PostingResult

SELECT * 
FROM #PostingResults


SELECT * 
FROM #AccountData_POD1_Merge_Txns






--SELECT top 100 Accountnumber ,TranID, PostingRef ,transactionDescription, MergeActivityFlag, TranTime, PostTime
--FROM CCard_Primary WITH (NOLOCK)
--WHERE CMTTRANTYPE = '49'
--AND TxnCode_Internal = '19393'
--AND MergeActivityFlag IS NOT NULL





--SELECT *
--FROM MonetaryTxnControl WITH (NOLOCK)
--WHERE ActualTranCode = '4907M'




