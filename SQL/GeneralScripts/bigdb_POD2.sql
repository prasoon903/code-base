use master 
--select 'USE '+name from sys.databases where name like '%CL'
select top 100 hostname, sysprocesses.program_name,	sysprocesses.spid,	sys.databases.name 
from sysprocesses
JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
where name like 'PP_POD2%'

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name like 'PP_POD2%') AND SPId <> @@SPId

PRINT @SQL
EXEC(@SQL)

--IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
--BEGIN

--	SELECT 'Start restoring' Status

--	use master
--	--exec SP_RestoreDb 'PARASHAR_TEST','\\xeon-s9\DFS\PuspendraMaurya\Backup\RetailPlanoneachAccount( 500)\Before Statement\CI.bak'
--	exec SP_RestoreDb 'PP_POD2_CC','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CC.bak'
--	exec SP_RestoreDb 'PP_POD2_CoreCredit','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CoreCredit.bak'
--	exec SP_RestoreDb 'PP_POD2_CoreApp','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI.bak'
--	exec SP_RestoreDb 'PP_POD2_CI','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI.bak'
--	exec SP_RestoreDb 'PP_POD2_CL','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CL.bak'
--	exec SP_RestoreDb 'PP_POD2_CAuth','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CAuth.bak'
--	exec SP_RestoreDb 'PP_POD2_CI_Secondary','\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI_Secondary.bak'

--	SELECT 'DB restored' Status

--END
--ELSE
--SELECT 'Change server'



use master

DECLARE 
	@MDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\MDF'
,	@LDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\LDF'
,	@DBLocation NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_'

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CC'
,@BACKUP_FILE= N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CC.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CC -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CAUTH'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CAuth.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CAUTH -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CoreApp'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CoreApp.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CoreApp -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CL'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CL.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CL -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CI'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CI -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CI_Secondary'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI_Secondary.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CI_Secondary -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_POD2_CoreCredit'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CoreCredit.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_POD2_CoreCredit -- RESTORED' MESSAGE

