DROP TABLE IF EXISTS ##TSDBOHBConversion
CREATE TABLE ##TSDBOHBConversion
(
	SN DECIMAL(19, 0) IDENTITY(1, 1),
	acctID INT,
	AccountNumber VARCHAR(19),
	CreatedTime DATETIME,
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY,
	HBRecalcStatus INT,
	JobStatus INT DEFAULT 0 -- (0-New, 1-Calculated, 2-Validated, 3-Updated, -1-Error)
)

DROP TABLE IF EXISTS ##TSDBOHBConversion_MetaData
CREATE TABLE ##TSDBOHBConversion_MetaData
(
	SN DECIMAL(19, 0),
	acctID INT,
	AccountNumber VARCHAR(19),
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY,
	StatementDate DATETIME
)

DROP TABLE IF EXISTS ##TSDBOHBConversion_Account
CREATE TABLE ##TSDBOHBConversion_Account
(
	SN DECIMAL(19, 0),
	acctID INT,
	AccountNumber VARCHAR(19),
	CurrentBalance MONEY,
	AmtOfAcctHighBalLTD MONEY
)