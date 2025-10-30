--EXECUTE ON PRIMARY

--INSERT INTO ##TSDBOHBConversion (acctID, AccountNumber, CreatedTime, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate, Category)
--SELECT acctID, AccountNumber, CreatedTime, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate, Category
--FROM OPENQUERY(LISTRPTPLAT, 'SELECT * FROM TSDBOHBConversion')

--UPDATE BSegment_Balances SET HBRecalcStatus = NULL WHERE acctID = 14551608



SELECT 
CASE 
	WHEN JobStatus = 0 THEN 'NEW'
	WHEN JobStatus = 1 THEN 'RECALCULATION FLAG UPDATED ON ACCOUNT'
	WHEN JobStatus = 2 THEN 'DATA CALCULATED'
	WHEN JobStatus = 3 THEN 'DATA VALIDATED'
	WHEN JobStatus = 4 THEN 'DATA UPDATED'
	WHEN JobStatus = -1 THEN 'STATEMENT-LEVEL VALIDATION FAILED'
	WHEN JobStatus = -2 THEN 'ACCOUNT-LEVEL VALIDATION FAILED'
	WHEN JobStatus = -5 THEN 'REMOVED ALREADY UPDATED ACCOUNT VIA APPLICATION/CONVERSION BEFORE CALCULATION'
	WHEN JobStatus = -6 THEN 'REMOVED ALREADY UPDATED ACCOUNT VIA APPLICATION AFTER CALCULATION'
	ELSE 'NA'
END ValidationStatus
, JobStatus, COUNT(1) RecordCount
FROM TSDBOHBConversion
GROUP BY JobStatus


--SELECT * FROM TSDBOHBConversion

--SELECT HBRecalcRequired, BC.HBRecalcStatus, T.HBRecalcStatus, *
--FROM BSegment_Balances BC WITH (NOLOCK)
--JOIN TSDBOHBConversion T ON (BC.acctID = T.acctID)

--SELECT * FROM TEMP_HighBalance_Processing

--SELECT * FROM TEMP_HighBalance_Validation

--SELECT COUNT(1) FROM CommonTNP WITH (NOLOCK) WHERE TranTime < GETDATE()

--SELECT * FROM BSegment_Balances WITH (NOLOCK) WHERE acctID = 14551608

--;WITH 
--Execution AS (SELECT ISNULL(MAX(ExecutionCount), 0) ExecutionCount FROM TEMP_HighBalance_Processing), 
--Iteration AS (SELECT E.ExecutionCount, ISNULL(MAX(Iteration), 0) Iteration FROM TEMP_HighBalance_Processing T
--JOIN Execution E ON (T.ExecutionCount = E.ExecutionCount) GROUP BY E.ExecutionCount)
--SELECT T.* FROM TEMP_HighBalance_Processing T
--JOIN Iteration C ON (T.ExecutionCount = C.ExecutionCount AND T.Iteration = C.Iteration)


--;WITH 
--Execution AS (SELECT ISNULL(MAX(ExecutionCount), 0) ExecutionCount FROM TEMP_HighBalance_Processing), 
--Iteration AS (SELECT E.ExecutionCount, ISNULL(MAX(Iteration), 0) Iteration FROM TEMP_HighBalance_Validation T
--JOIN Execution E ON (T.ExecutionCount = E.ExecutionCount) GROUP BY E.ExecutionCount)
--SELECT T.* FROM TEMP_HighBalance_Validation T
--JOIN Iteration C ON (T.ExecutionCount = C.ExecutionCount AND T.Iteration = C.Iteration)



--SELECT Category, COUNT(1)
--FROM TSDBOHBConversion
--GROUP BY Category

--SELECT *
--FROM TSDBOHBConversion
--WHERE Category = 'EligibleStatus'
--AND JobStatus = 2

--SELECT CMTTRANTYPE, TransactionAmount, FeesAcctID, CPMGroup, *
--FROM CCArd_Primary WITH (NOLOCK)
--WHERE AccountNumber = '1100011100504087      '
--ORDER BY PostTime DESC


--SELECT *, StmtCurrentBalance-CurrentBalance DELTA
--FROM TSDBOHBConversion_MetaData
----WHERE SN = 251289
--WHERE acctID = 2084145
--ORDER BY StatementDate

--SELECT T.*, T.StmtCurrentBalance-T.Currentbalance DELTA, CSH.AmtOfInterestCTD
----SH.parent02AID, SH.StatementDate, SH.CreditPlanType, 
----SH.AmtOfInterestCTD, CSH.AmtOfInterestCTD, CSH.InterestAtCycle, SH.AmtOfInterestCTD-CSH.AmtOfInterestCTD TotalInterest
----, SH.CurrentBalance, SH.CurrentBalanceCO, CSH.CurrentBalance 
--FROM SummaryHeader SH WITH (NOLOCK)
--JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementID = CSH.StatementID)
--JOIN ##TSDBOHBConversion_MetaData T ON (SH.parent02AID = T.acctId AND SH.StatementDate = T.StatementDate)
----WHERE SH.parent02AID = 17523369
--WHERE SH.CreditPlanType = '0'
----AND SH.AmtOfInterestCTD+CSH.AmtOfInterestCTD <> 0
----AND SH.StatementDate = '2025-06-30 23:59:57.000'
--AND T.RecordStatus = 1
--AND T.StmtCurrentBalance-T.Currentbalance <> CSH.AmtOfInterestCTD
--AND CSH.AmtOfInterestCTD > 0
----AND T.acctID = 408981
--ORDER BY SH.StatementDate 

--SELECT *
--FROM TSDBOHBConversion_Account
--WHERE acctID = 16807564

--SELECT *
--FROM TSDBOHBConversion
--WHERE acctID = 2084145

--SELECT *
--FROM TSDBOHBConversion
--WHERE JobStatus = -1

--SELECT Category, COUNT(1)
--FROM TSDBOHBConversion
--WHERE JobStatus = 2
--GROUP BY Category

--UPDATE ##TSDBOHBConversion SET JobStatus = 0 WHERE JobStatus = -99

--UPDATE ##TSDBOHBConversion SET JobStatus = 0 WHERE acctID = 14367572

--UPDATE ##TSDBOHBConversion SET JobStatus = -99 WHERE JobStatus = 0
--UPDATE ##TSDBOHBConversion SET JobStatus = 0 WHERE JobStatus  IN (-1, -2)

--UPDATE ##TSDBOHBConversion SET JobStatus = 0 WHERE JobStatus = -99

--/*
--TRUNCATE TABLE ##TSDBOHBConversion_Account
--TRUNCATE TABLE ##TSDBOHBConversion_MetaData
--TRUNCATE TABLE ##TSDBOHBConversion_MetaData
--TRUNCATE TABLE ##TEMP_HighBalance_Validation
--TRUNCATE TABLE ##TEMP_HighBalance_Processing
--*/


