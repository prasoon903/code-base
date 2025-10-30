--DROP TABLE ExternalFileProcessing
--DROP TABLE Apply_DBCr_FileDump
--DROP TABLE Apply_DBCr_FileLog
--DROP TABLE Apply_DBCr_Transaction

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60

--UPDATE CCard_Primary SET Transactionidentifier = 'BTSFile'


SELECT TOP 1 INFO_VALUE FROM Admin.dbo.TB_INFO WHERE INFO_KEY = 'SERVERNAME'


SELECT TOP 1 JobID, FileName FROM ExternalFileProcessing WITH (NOLOCK) WHERE JobStatus = 'INPROCESS' ORDER BY JobID ASC


SELECT JobStatus, TotalRecord, SuccesRecord, ErrorRecord, ErrorReason 
FROM ExternalFileProcessing WITH (NOLOCK) 
WHERE FileName = 'BTS1^_retail_bts_gs_promo_122677116_20200527042407_1.csv' AND JobID = 1

SELECT * FROM Apply_DBCr_Transaction WITH (NOLOCK)

SELECT * FROM ExternalFileProcessing WITH (NOLOCK) 
SELECT * FROM Apply_DBCr_FileDump WITH (NOLOCK)
SELECT * FROM Apply_DBCr_FileLog WITH (NOLOCK)

--TRUNCATE TABLE Apply_DBCr_FileLog
--TRUNCATE TABLE ExternalFileProcessing
--TRUNCATE TABLE Apply_DBCr_Transaction

--UPDATE ExternalFileProcessing SET JobStatus = 'INPROCESS' WHERE JobID = 1
--UPDATE Apply_DBCr_Transaction SET JobStatus = 1 WHERE JobID = 1

SELECT
	Transaction_Method AS TransactionType, Transaction_Type AS Method, Reason
FROM Apply_DBCr_Transaction WITH (NOLOCK)
--WHERE FileName = 'BTS1^_retail_bts_gs_promo_MIX_2.csv'
--AND JobID = 9
GROUP BY Transaction_Method, Transaction_Type, Reason


SELECT
	Transaction_Method AS TransactionType, Transaction_Type AS Method, 
	CASE WHEN Reason = 'SUCCESS' THEN COUNT(1) ELSE 0 END AS SUCCESS,
	CASE WHEN Reason <> 'SUCCESS' THEN COUNT(1) ELSE 0 END AS ERROR
FROM Apply_DBCr_Transaction WITH (NOLOCK)
--WHERE FileName = 'BTS1^_retail_bts_gs_promo_MIX_2.csv'
--AND JobID = 9
GROUP BY Transaction_Method, Transaction_Type, Reason

;WITH CTE
AS
(
SELECT
	Transaction_Method AS TransactionType, Transaction_Type AS Method, 
	CASE WHEN Reason = 'SUCCESS' THEN COUNT(1) ELSE 0 END AS Success,
	CASE WHEN Reason <> 'SUCCESS' THEN COUNT(1) ELSE 0 END AS Error
FROM Apply_DBCr_Transaction WITH (NOLOCK)
WHERE FileName = 'ProcessLocalFile.csv'
AND JobID = 1
GROUP BY Transaction_Method, Transaction_Type, Reason
)
SELECT TransactionType,  Method, SUM(Success) AS Success, SUM(Error) AS Error, SUM(Success) + SUM(Error) AS Total
FROM CTE WITH (NOLOCK)
GROUP BY TransactionType,  Method
ORDER BY TransactionType,  Method

SELECT 
	Transaction_Method AS TransactionType, 
	Transaction_Type AS Method, 
	Response_Id AS ResponseID, 
	Pan_Last_4_Nr AS Last4Pan,
	CAST(Amount AS FLOAT) AS TransactionAmount,
	RTRIM(AccountNumber) AS AccountNumber,
	Reason AS ErrorReason
FROM PARASHAR_CB_CI..Apply_DBCr_Transaction WITH (NOLOCK)
WHERE FileName = 'ProcessLocalFile_1.csv'
AND JobID = 1
AND JobStatus <> 3
ORDER BY Transaction_Method, Transaction_Type

SELECT ROUND(123.12345, 2, 2)



--TRUNCATE TABLE ExternalFileProcessing

SELECT JobStatus, TotalRecord, SuccesRecord, ErrorRecord, ErrorReason FROM ExternalFileProcessing WITH (NOLOCK) WHERE FileName = '' AND JobID = 0

SELECT * FROM VP_CP_CI..Apply_DBCr_Transaction WITH (NOLOCK)

SELECT * FROM VP_CP_CI..ExternalFileProcessing WITH (NOLOCK)


/*
Invoice Id = NA,
Invoice Create Ts = NA,
Transaction Method = NA,
Transaction Type = NA,
Response Id = PlanUUID of AuthPrimary of retailTxn/ TraceId of AuthSecondary for non-retail,
Pan Last 4 Nr = CardNumber4Digits of AuthPrimary,
Amount = TransactionAmount of AuthPrimary,
Publish Ts = NA
*/


SELECT 
	P.MessageTypeIdentifier,PlanUUID, TraceId, CardNumber4Digits, TransactionAmount
FROM Auth_Primary P WITH (NOLOCK)
JOIN Auth_Secondary S WITH (NOLOCK) ON (P.TranId = S.TranId)
WHERE P.AuthStatus NOT IN (1,4)

SELECT 
	'ABCDEFGJH_' + CAST(ROW_NUMBER() OVER(PARTITION BY A.ATID ORDER BY A.PostTime) AS VARCHAR) AS [Invoice Id],
	CONVERT(VARCHAR(50), A.PostTime, 20) AS [Invoice Create Ts],
	CASE WHEN A.PlanUUID IS NOT NULL THEN 'ACMI' ELSE 'PIF' END AS [Transaction Method],
	'REFUND' AS [Transaction Type],
	COALESCE(A.PlanUUID,B.TraceId) AS [Response Id],
	A.CardNumber4Digits AS [Pan Last 4 Nr],
	A.TransactionAmount AS [Amount],
	CONVERT(VARCHAR(50), DBO.PR_ISOGetBusinessTime(), 20) AS [Publish Ts]
FROM Auth_Primary A WITH(NOLOCK) JOIN Auth_Secondary B WITH(NOLOCK) ON A.TranId = B.TranId
JOIN CCardLookUp CL WITH(NOLOCK) ON (A.AuthStatus = CL.LutCode AND CL.LUTid = 'TMAuthStatus')
WHERE (PlanUUID IS NOT NULL OR TraceId IS NOT NULL) AND A.AuthStatus NOT IN (1,4)


SELECT 
	COALESCE(A.PlanUUID,B.TraceId),
	A.CardNumber4Digits,
	A.PAN_Hash,A.AccountNumber,
	A.TransactionAmount,
	A.AuthStatus,
	CL.LutDescription,
	A.AuthType,
	A.TxnAcctId
FROM Auth_Primary A WITH(NOLOCK) JOIN Auth_Secondary B WITH(NOLOCK) ON A.TranId = B.TranId
JOIN CCardLookUp CL WITH(NOLOCK) ON (A.AuthStatus = CL.LutCode AND CL.LUTid = 'TMAuthStatus')
WHERE (PlanUUID IS NOT NULL OR TraceId IS NOT NULL) AND A.AuthStatus NOT IN (1,4)

