DROP TABLE IF EXISTS TSDBOHBConversion
CREATE TABLE TSDBOHBConversion
(
	SN DECIMAL(19, 0) IDENTITY(1, 1),
	acctID INT,
	AccountNumber VARCHAR(19),
	CreatedTime DATETIME,
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY,
	LastStatementDate DATETIME,
	HBRecalcStatus INT DEFAULT 0,
	Category VARCHAR(100),
	JobStatus INT DEFAULT 0 -- (0: New, 1: Calculated, 2: Validated, 3: Updated, -1: Error)
)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_SN ON TSDBOHBConversion
CREATE CLUSTERED INDEX IDX_TSDBOHBConversion_SN ON TSDBOHBConversion (SN)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_JobStatus ON TSDBOHBConversion
CREATE NONCLUSTERED INDEX IDX_TSDBOHBConversion_JobStatus ON TSDBOHBConversion (JobStatus)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_acctID ON TSDBOHBConversion
CREATE NONCLUSTERED INDEX IDX_TSDBOHBConversion_acctID ON TSDBOHBConversion (acctID)




DROP TABLE IF EXISTS TSDBOHBConversion_MetaData
CREATE TABLE TSDBOHBConversion_MetaData
(
	SN DECIMAL(19, 0),
	acctID INT,
	AccountNumber VARCHAR(19),
	StatementDate DATETIME,
	StmtCurrentBalance MONEY,
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY,
	RecordStatus INT DEFAULT 0
)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_MetaData_SN ON TSDBOHBConversion_MetaData
CREATE CLUSTERED INDEX IDX_TSDBOHBConversion_MetaData_SN ON TSDBOHBConversion_MetaData (SN)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_MetaData_acctID_StatementDate ON TSDBOHBConversion_MetaData
CREATE NONCLUSTERED INDEX IDX_TSDBOHBConversion_MetaData_acctID_StatementDate ON TSDBOHBConversion_MetaData (acctID, StatementDate)



DROP TABLE IF EXISTS TSDBOHBConversion_Account
CREATE TABLE TSDBOHBConversion_Account
(
	SN DECIMAL(19, 0),
	acctID INT,
	AccountNumber VARCHAR(19),
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY,
	RecordStatus INT DEFAULT 0
)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_Account_SN ON TSDBOHBConversion_Account
CREATE CLUSTERED INDEX IDX_TSDBOHBConversion_Account_SN ON TSDBOHBConversion_Account (SN)

DROP INDEX IF EXISTS IDX_TSDBOHBConversion_Account_acctID ON TSDBOHBConversion_Account
CREATE NONCLUSTERED INDEX IDX_TSDBOHBConversion_Account_acctID ON TSDBOHBConversion_Account (acctID)



--LOGGING


DROP TABLE IF EXISTS TEMP_HighBalance_Processing
CREATE TABLE TEMP_HighBalance_Processing 
(
	SN DECIMAL(19,0) IDENTITY(1, 1),
	ExecutionCount INT,
	BatchCount INT,
	Iteration INT,
	Activity VARCHAR(100),
	RecordCount INT,
	LogTime DATETIME DEFAULT GETDATE()
)

DROP TABLE IF EXISTS TEMP_HighBalance_Validation
CREATE TABLE TEMP_HighBalance_Validation 
(
	SN DECIMAL(19,0) IDENTITY(1, 1),
	ExecutionCount INT,
	BatchCount INT,
	Iteration INT,
	Activity VARCHAR(100),
	RecordCount INT,
	LogTime DATETIME DEFAULT GETDATE()
)

DROP TABLE IF EXISTS TEMP_HighBalance_Update
CREATE TABLE TEMP_HighBalance_Update 
(
	SN DECIMAL(19,0) IDENTITY(1, 1),
	ExecutionCount INT,
	BatchCount INT,
	Iteration INT,
	Activity VARCHAR(100),
	RecordCount INT,
	LogTime DATETIME DEFAULT GETDATE()
)