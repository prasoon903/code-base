SELECT *
FROM ##CBRWriteOff_COOKIE_320534

SELECT COUNT(1)
FROM ##CBRWriteOff_COOKIE_320534
--28420




--FETCH ACCOUNT DATA
DROP TABLE IF EXISTS #AccountData_POD1
SELECT T1.*, B.AccountNumber, B.acctID, B.ccinhparent125AID, B.SystemStatus
INTO #AccountData_POD1
FROM ##CBRWriteOff_COOKIE_320534 T1
JOIN BSegment_Primary B WITH (NOLOCK) ON (B.UniversalUniqueID = T1.Account_UUID)
WHERE B.MergeInProcessPH IS NULL

SELECT COUNT(1) FROM CommonAP WITH (NOLOCK) WHERE TranTime < GETDATE()


--SELECT * FROM #AccountData_POD1 
--SELECT COUNT(1) FROM #AccountData_POD1 


--STATUS VALIDATION
;WITH CTE
AS
(
SELECT ccinhparent125AID, COUNT(1) RecordCount
FROM #AccountData_POD1
GROUP BY ccinhparent125AID
)
SELECT C.*, CL.LutDescription StatusDescription
FROM CTE C
LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (C.ccinhparent125AID = CL.LutCode AND CL.LUTid = 'AsstPlan')
WHERE LutLanguage = 'dbb'
AND CL.Module = 'BC'
ORDER BY C.RecordCount DESC

;WITH CTE
AS
(
SELECT SystemStatus, COUNT(1) RecordCount
FROM #AccountData_POD1
GROUP BY SystemStatus
)
SELECT C.*, CL.LutDescription StatusDescription
FROM CTE C
LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (C.SystemStatus = CL.LutCode AND CL.LUTid = 'AsstPlan')
WHERE LutLanguage = 'dbb'
AND CL.Module = 'BC'
ORDER BY C.RecordCount DESC


SELECT MergeInProcessPH, COUNT(1) RecordCount
FROM #AccountData_POD1
GROUP BY MergeInProcessPH



-- TRANSACTION POSTING VALIDATION


;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY SN) TxnCount
FROM #AccountData_POD1
)
SELECT *
FROM CTE
WHERE TxnCount > 1

SELECT *
FROM #AccountData_POD1
WHERE ISNULL(CURRENT_BALANCE+CURRENT_BALANCE_CO, 0) = 0


DROP TABLE IF EXISTS #AccountData_POD1_TxnPosting
SELECT AccountNumber, acctID, Account_UUID, ccInhparent125AID, SystemStatus, SUM(CURRENT_BALANCE+CURRENT_BALANCE_CO) TransactionAmount
INTO #AccountData_POD1_TxnPosting
FROM #AccountData_POD1
GROUP BY AccountNumber, acctID, Account_UUID, ccInhparent125AID, SystemStatus


DROP TABLE IF EXISTS #AccountData_POD1_Txns
SELECT CP.AccountNumber, T.Account_UUID, T.acctID, CP.TranID, CP.TransactionAmount, CP.TranTime, CP.PostTime, CP.PostingRef, CP.TransactionDescription, CP.ClientID
INTO #AccountData_POD1_Txns
FROM #AccountData_POD1_TxnPosting T
JOIN CCard_Primary CP WITH (NOLOCK) ON (CP.AccountNumber = T.AccountNumber)
WHERE TxnCode_Internal = '19972'
AND CMTTRANTYPE = '49'
AND PostTime > '2025-05-14'


DROP TABLE IF EXISTS #AccountData_POD1_PostedTxns
SELECT T.*
INTO #AccountData_POD1_PostedTxns
FROM #AccountData_POD1_Txns T
JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (T.TranID = TIA.Tran_Id_Index)
WHERE ATID = 51


DROP TABLE IF EXISTS #PostingResults
;WITH CTE
AS
(
SELECT AccountNumber, SUM(TransactionAmount) TransactionAmount
FROM #AccountData_POD1_PostedTxns
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
FROM #AccountData_POD1_TxnPosting T1
LEFT JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)


SELECT PostingResult, COUNT(1) RecordCount
FROM #PostingResults
GROUP BY PostingResult

SELECT * 
FROM #PostingResults


SELECT * 
FROM #AccountData_POD1_Txns





--SELECT top 100 Accountnumber ,TranID, PostingRef ,transactionDescription, MergeActivityFlag, TranTime, PostTime
--FROM CCard_Primary WITH (NOLOCK)
--WHERE CMTTRANTYPE = '49'
--AND TxnCode_Internal = '19393'
--AND MergeActivityFlag IS NOT NULL





--SELECT *
--FROM MonetaryTxnControl WITH (NOLOCK)
--WHERE ActualTranCode = '4933'




DROP TABLE IF EXISTS #AccountData_POD1
SELECT B.AccountNumber, B.acctID
INTO #AccountData_POD1
FROM ##CBRWriteOff_COOKIE_320534 T1
JOIN BSegment_Primary B WITH (NOLOCK) ON (B.UniversalUniqueID = T1.Account_UUID)
WHERE B.MergeInProcessPH IS NULL

INSERT INTO #AccountData_POD1
SELECT B.DestAccountNumber AccountNumber, B.DestBSAcctId acctID
FROM ##CBRWriteOff_COOKIE_320534 T1
JOIN MergeAccountJob B WITH (NOLOCK) ON (B.SrcBSAccountUUID = T1.Account_UUID)
WHERE B.JobStatus = 'DONE'
AND B.DestPODID = 1

SELECT COUNT(1) TotalRecords FROM #AccountData_POD1  WITH(NOLOCK) 


SELECT ResponseMessage, COUNT(1) RecordCount
FROM TCIVRRequest T WITH (NOLOCK)
JOIN #AccountData_POD1 A ON (T.BSAcctID = A.acctID AND T.RequestName = '11012')
WHERE T.RequestName = '11012'
AND RequestDate > '2025-05-13'
GROUP BY ResponseMessage

--'1100011124751961'

--SELECT *
--FROM TCIVRRequest WITH (NOLOCK)
----WHERE AccountNumber = '1100011124751961'
--WHERE BSAcctID = 2496011
--ORDER BY Skey DESC


--SELECT * FROM sys.tables where name like '%TCIVRRequest%'

--SELECT * FROM APIMaster WITH (NOLOCK) WHERE apICode = '11012'