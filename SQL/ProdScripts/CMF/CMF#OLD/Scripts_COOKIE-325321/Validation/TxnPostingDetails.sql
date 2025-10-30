DECLARE @JiraID VARCHAR(20) = 'COOKIE-325321'

DROP TABLE IF EXISTS #TempTxns
CREATE TABLE #TempTxns (TranID DECIMAL(19,0), TransactionStatus INT)

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData (FieldValue VARCHAR(50), RecordStatus VARCHAR(50), RecordCount INT)

INSERT INTO #TempData
SELECT 'TotalInsertedRecords' FieldValue, 
CASE 
	WHEN JobStatus = 0 THEN 'NEW'
	WHEN JobStatus = 1 THEN 'RECORDS INSERTED'
	ELSE 'INVALID STATUS'
END RecordStatus, COUNT(1) RecordCount
FROM TransactionCreationTempData WITH (NOLOCK)
WHERE JiraID = @JiraID
GROUP BY JobStatus

INSERT INTO #TempTxns
SELECT TranID, TransactionStatus
FROM CreateNewSingleTransactionData WITH (NOLOCK)
WHERE Reason = @JiraID

INSERT INTO #TempData
SELECT 'TotalInsertedToTNP' FieldValue, 
CASE 
	WHEN TransactionStatus = 0 THEN 'NEW'
	WHEN TransactionStatus = 1 THEN 'DATA COOKED'
	WHEN TransactionStatus = 2 THEN 'INSERTED TO TNP'
	ELSE 'INVALID STATUS'
END RecordStatus, COUNT(1) RecordCount
FROM #TempTxns T
GROUP BY TransactionStatus

INSERT INTO #TempData
SELECT 'ErrorInCookingData' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM #TempTxns T
WHERE TransactionStatus = 1 AND ISNULL(TranID, 0) = 0

INSERT INTO #TempData
SELECT 'TNPBackLog' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()

INSERT INTO #TempData
SELECT 'TotalJobsInError' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM ErrorTNP WITH (NOLOCK)

INSERT INTO #TempData
SELECT 'InsertedJobsinTNP' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM CommonTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)

INSERT INTO #TempData
SELECT 'InsertedJobsinErrror' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM ErrorTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)


INSERT INTO #TempData
SELECT 'SUCCESSFUL POSTED RECORDS' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM Trans_In_Acct WITH (NOLOCK)
WHERE tran_id_index IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)
AND ATID = 51




DECLARE @Inserted INT, @Posted INT

SELECT @Inserted = Recordcount FROM #TempData WHERE FieldValue = 'TotalInsertedRecords' 
SELECT @Posted = Recordcount FROM #TempData WHERE FieldValue = 'SUCCESSFUL POSTED RECORDS'

IF(@Inserted - @Posted <> 0)
BEGIN
	SELECT 'ISSUE IN PROCESSING RECORDS OR JOBS ARE IN PROCESS' [RESPONSE MESSAGE]
END
ELSE
BEGIN 
	SELECT 'ALL RECORDS POSTED SUCCESSFULLY' [RESPONSE MESSAGE]
END

SELECT * FROM #TempData

