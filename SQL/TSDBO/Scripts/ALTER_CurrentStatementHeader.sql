/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.CurrentStatementHeader') AND name = 'AdjustedCurrentBalance')
BEGIN
	ALTER TABLE [dbo].CurrentStatementHeader ADD [AdjustedCurrentBalance] MONEY NULL
END


IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.CurrentStatementHeader') AND name = 'AdjustedHighBalance')
BEGIN
	ALTER TABLE [dbo].CurrentStatementHeader ADD [AdjustedHighBalance] MONEY NULL
END


IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.CurrentStatementHeader') AND name = 'AdjustedTransactionAmount')
BEGIN
	ALTER TABLE [dbo].CurrentStatementHeader ADD [AdjustedTransactionAmount] MONEY NULL
END