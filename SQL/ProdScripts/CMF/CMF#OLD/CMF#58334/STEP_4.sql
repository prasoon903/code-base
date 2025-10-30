-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

-------------------------------- STEP 1 --------------------------------

SELECT  C.*, ROW_NUMBER() OVER (PARTITION BY C.acctId ORDER BY C.TranTime) RowNumber
INTO #TempCommonTNP
FROM  dbo.CommonTNP C WITH (NOLOCK)
JOIN  dbo.CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
AND C.acctId IN (2801034, 2550083, 556395)
ORDER BY C.TranTime

UPDATE #TempCommonTNP SET TranTime = DATEADD(MINUTE, RowNumber*2, GETDATE())

SELECT * FROM #TempCommonTNP ORDER BY trantime desc

-------------------------------- STEP 2 --------------------------------


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE C SET TranTime = TC.TranTime
FROM CommonTNP C 
JOIN #TempCommonTNP TC ON (C.TranID = TC.TranID)



/*
-------------------------------- STEP 1 --------------------------------

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE CreateNewSingleTransactionData SET TransactionStatus = -2 WHERE TransactionStatus = 1 AND TranID IS NULL

-------------------------------- STEP 2 --------------------------------

DROP TABLE IF EXISTS #TempCommonTNP
SELECT  C.*, ROW_NUMBER() OVER (PARTITION BY C.acctId ORDER BY C.TranTime) RowNumber
INTO #TempCommonTNP
FROM CommonTNP C WITH (NOLOCK)
JOIN CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
ORDER BY C.TranTime

UPDATE #TempCommonTNP SET TranTime = DATEADD(SECOND, RowNumber, GETDATE())

--SELECT * FROM #TempCommonTNP ORDER BY TranTime



-------------------------------- STEP 3 --------------------------------


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE C SET TranTime = TC.TranTime
FROM CommonTNP C 
JOIN #TempCommonTNP TC ON (C.TranID = TC.TranID)

*/