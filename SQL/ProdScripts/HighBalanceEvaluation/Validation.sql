
SELECT TOP 10 * FROM SPExecutionLog WITH (NOLOCK) ORDER BY Skey DESC

SELECT JobStatus, COUNT(1)
FROM ##Accounts
GROUP BY JobStatus 

--SELECT * FROM ##TEMP_HighBalance_Processing

;WITH Execution AS
(SELECT ISNULL(MAX(ExecutionCount), 0) ExecutionCount FROM ##TEMP_HighBalance_Processing)
, Iteration AS
(SELECT E.ExecutionCount, ISNULL(MAX(Iteration), 0) Iteration 
FROM ##TEMP_HighBalance_Processing T
JOIN Execution E ON (T.ExecutionCount = E.ExecutionCount)
GROUP BY E.ExecutionCount)
SELECT T.*
FROM ##TEMP_HighBalance_Processing T
JOIN Iteration C ON (T.ExecutionCount = C.ExecutionCount AND T.Iteration = C.Iteration)


;WITH Execution AS
(SELECT ISNULL(MAX(ExecutionCount), 0) ExecutionCount FROM ##TEMP_HighBalance_Update)
, Iteration AS
(SELECT E.ExecutionCount, ISNULL(MAX(Iteration), 0) Iteration 
FROM ##TEMP_HighBalance_Update T
JOIN Execution E ON (T.ExecutionCount = E.ExecutionCount)
GROUP BY E.ExecutionCount)
SELECT T.*
FROM ##TEMP_HighBalance_Update T
JOIN Iteration C ON (T.ExecutionCount = C.ExecutionCount AND T.Iteration = C.Iteration)


--UPDATE ##Accounts SET JobStatus = 0 WHERE JobStatus = 1

SELECT * FROM ##Accounts WHERE JobStatus = 1 

SELECT A.*, B.CurrentBalance, B.AmtOfAcctHighBalLTD
FROM ##Accounts A
JOIN BSegment_Primary B WITH (NOLOCK) ON (A.BSAcctID = B.acctID)
WHERE JobStatus = 1
AND CalcHighBalance <> AmtOfAcctHighBalLTD


SELECT A.*, B.SystemStatus, B.CurrentBalance, B.AmtOfAcctHighBalLTD, CalcHighBalance - AmtOfAcctHighBalLTD HBDelta, CalcCurrentBalance - CurrentBalance CBDelta
FROM ##Accounts A
JOIN BSegment_Primary B WITH (NOLOCK) ON (A.BSAcctID = B.acctID)
WHERE JobStatus = 1
AND CalcCurrentBalance <> CurrentBalance
AND SystemStatus <> 14

--1919800