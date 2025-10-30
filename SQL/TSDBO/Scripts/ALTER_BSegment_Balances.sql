/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.BSegment_Balances') AND name = 'HBRecalcStatus')
BEGIN
	ALTER TABLE [dbo].BSegment_Balances ADD [HBRecalcStatus] INT NULL
END

IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.BSegment_Balances') AND name = 'HBRecalcRequired')
BEGIN
	ALTER TABLE [dbo].BSegment_Balances ADD [HBRecalcRequired] INT NULL
END

IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.BSegment_Balances') AND name = 'TSDBOActive')
BEGIN
	ALTER TABLE [dbo].BSegment_Balances ADD [TSDBOActive] VARCHAR(2) NULL
END

IF NOT EXISTS (SELECT 1  FROM SYS.COLUMNS WHERE  
OBJECT_ID = OBJECT_ID(N'dbo.BSegment_Balances') AND name = 'TSDBOActiveDate')
BEGIN
	ALTER TABLE [dbo].BSegment_Balances ADD [TSDBOActiveDate] DATETIME NULL
END

