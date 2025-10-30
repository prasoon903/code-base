/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

DROP TABLE IF EXISTS HighBalanceErrorLog 
GO

CREATE TABLE HighBalanceErrorLog (
 [Skey] decimal(19) NOT NULL,
 [acctId] int NULL,
 [AccountNumber] char (19) NULL,
 [TranId] decimal(19) NULL,
 [TranTime] datetime NULL,
 [PostTime] datetime NULL,
 [TransactionAmount] money NULL,
 [LastStatementDate] datetime NULL,
 [StatementDate] datetime NULL,
 [AdjustedCurrentBalance] money NULL,
 [AdjustedHighBalance] money NULL,
 [CurrentBalance] money NULL,
 [JobStatus] varchar (20) NULL,

 CONSTRAINT csPk_HighBalanceErrorLog PRIMARY KEY CLUSTERED ( 
  [Skey] 
 
) 
  )
