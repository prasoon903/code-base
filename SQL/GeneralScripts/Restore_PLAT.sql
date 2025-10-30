/*

use master
EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_TEST'
,@BACKUP_FILE= N' \\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CI.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

*/

use master 
--select 'USE '+name from sys.databases where name like '%CL'
--select top 100 hostname, sysprocesses.program_name,	sysprocesses.spid,	sys.databases.name 
--from sysprocesses
--JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
--where name like 'PP_%'

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name like 'PP_%') AND SPId <> @@SPId

--PRINT @SQL
EXEC(@SQL)

	
use master

DECLARE 
	@MDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\MDF'
,	@LDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\LDF'
,	@DBLocation NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_'

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CC'
,@BACKUP_FILE= N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CC.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CC -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CAUTH'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CAuth.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CAUTH -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CoreApp'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CoreApp.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CoreApp -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CL'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CL.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CL -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CI'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CI.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CI -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CI_Secondary'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CI_Secondary.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CI_Secondary -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced_V4
@DB_NAME = N'PP_CoreCredit'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\Backup\Sc_1_CoreCredit.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF

SELECT 'PP_CoreCredit -- RESTORED' MESSAGE