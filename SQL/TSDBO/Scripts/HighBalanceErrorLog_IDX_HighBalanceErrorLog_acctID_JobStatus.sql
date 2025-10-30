/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/


IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes WHERE Name = 'IDX_HighBalanceErrorLog_acctID_JobStatus')
BEGIN
	CREATE NONCLUSTERED INDEX IDX_HighBalanceErrorLog_acctID_JobStatus ON [dbo].[HighBalanceErrorLog]
	(
		[acctId],
		[JobStatus]
	)
	WITH( ONLINE=ON, MAXDOP=2)
END