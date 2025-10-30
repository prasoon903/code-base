DROP TABLE IF EXISTS #Accounts
SELECT ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY BSacctID) SN, BSacctID, AccountNumber, DateAcctOpened, LastStatementDate,
TRY_CAST(NULL AS DATETIME) Acquisitiondate, TRY_CAST(0 AS MONEY) CBRAmountOfCurrentBalance, TRY_CAST(0 AS MONEY) CBRAmountOfHighBalance, TRY_CAST(0 AS MONEY) CalcCurrentBalance, TRY_CAST(0 AS MONEY) CalcHighBalance,
TRY_CAST(0 AS MONEY) CBRAmountOfCurrentBalance_STMT, TRY_CAST(0 AS MONEY) CBRAmountOfHighBalance_STMT, TRY_CAST(0 AS INT) JobStatus
INTO #Accounts
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2024-03-18 23:59:57'

DROP TABLE IF EXISTS ##Accounts
SELECT *
INTO ##Accounts
FROM #Accounts

/*
DROP TABLE IF EXISTS ##BSegment_Primary
SELECT B.*
INTO ##BSegment_Primary
FROM BSegment_Primary B WITH (NOLOCK)
JOIN ##Accounts A ON (A.BSAcctID = B.acctID)

DROP TABLE IF EXISTS ##BSegment_Balances
SELECT B.*
INTO ##BSegment_Balances
FROM BSegment_Balances B WITH (NOLOCK)
JOIN ##Accounts A ON (A.BSAcctID = B.acctID)

SELECT B.*
INTO ##CurrentStatementHeader
FROM CurrentStatementHeader B WITH (NOLOCK)
JOIN ##Accounts A ON (A.BSAcctID = B.acctID AND A.LastStatementDate = B.StatementDate)
*/

DROP INDEX IF EXISTS IX_SN ON ##Accounts
CREATE CLUSTERED INDEX IX_SN ON ##Accounts 
(
	SN
) 

DROP INDEX IF EXISTS IX_SN ON ##Accounts
CREATE NONCLUSTERED INDEX IX_SN ON ##Accounts 
(
	JobStatus
) 

DROP TABLE IF EXISTS ##TEMP_HighBalance_Processing
CREATE TABLE ##TEMP_HighBalance_Processing 
(
	SN DECIMAL(19,0) IDENTITY(1, 1),
	ExecutionCount INT,
	BatchCount INT,
	Iteration INT,
	Activity VARCHAR(100),
	RecordCount INT
)

DROP TABLE IF EXISTS ##TEMP_HighBalance_Update
CREATE TABLE ##TEMP_HighBalance_Update 
(
	SN DECIMAL(19,0) IDENTITY(1, 1),
	ExecutionCount INT,
	BatchCount INT,
	Iteration INT,
	Activity VARCHAR(100),
	RecordCount INT
)

--SELECT ISNULL(MAX(ExecutionCount), 0)+1 FROM ##TEMP_HighBalance_Processing

--SELECT MAX(ExecutionCount) ExecutionCount FROM ##TEMP_HighBalance_Processing


