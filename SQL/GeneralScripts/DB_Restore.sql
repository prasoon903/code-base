DECLARE 
	@PATH NVARCHAR(MAX), 
	@Label NVARCHAR(MAX), 
	@PathSuffix NVARCHAR(MAX), 
	@PathPrefix NVARCHAR(MAX),
	@CI_DB NVARCHAR(MAX),
	@CAuth_DB NVARCHAR(MAX),
	@CL_DB NVARCHAR(MAX)

SET @Label = 'Plat_16.00.02'
SET @PathPrefix = '\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\'
SET @PathSuffix = '\Application\DB\MasterDB_New\'
SET @PATH = @PathPrefix + @Label + @PathSuffix
SET @CI_DB = @PATH + 'CI.bak'


exec master.dbo.SP_RestoreDb 'PARASHAR_TEST',@CI_DB

EXEC master.dbo.SP_RestoreDb 'PARASHAR_CB_CI', '\\XEON-S8\Labels\BANKCARD\CreditProcessing\Labels\Plat_16.00.02\Application\DB\MasterDB_New\CI.bak'