DROP TABLE IF EXISTS COOKIE_257478_ChargeOffAccount
CREATE TABLE COOKIE_257478_ChargeOffAccount
(
	Skey DECIMAL(19, 0) IDENTITY(1, 1),
	acctId INT,
	AccountNumber VARCHAR(19),
	AccountUUID VARCHAR(64),
	ForgivenAmount MONEY,
	TotalAmountCO_Before MONEY,
	TotalAmountCO_After MONEY,
	TotalPrincipalCO_Before MONEY,
	TotalPrincipalCO_After MONEY,
	RCLSDateOnAccount DATETIME,
	RCLSDateToSet DATETIME,
	JobStatus INT DEFAULT(0)
)

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.tables WHERE name = 'TransactionCreationTempData')
BEGIN
	CREATE TABLE [dbo].[TransactionCreationTempData](
		[SN] [int] IDENTITY(1,1) NOT NULL,
		[TxnAcctId] [int] NULL,
		[AccountNumber] [varchar](19) NULL,
		[TransactionAmount] [money] NULL,
		[CMTTranType] [varchar](10) NULL,
		[ActualTranCode] [varchar](20) NULL,
		[TranTime] [datetime] NULL,
		[JobStatus] [int] DEFAULT (0) NULL,
		[RevTgt] [decimal](19, 0) NULL,
		[JiraID] [varchar](20) NULL
	)
END