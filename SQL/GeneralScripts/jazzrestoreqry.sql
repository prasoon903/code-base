/*

use master
EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_TEST'
,@BACKUP_FILE= N' \\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CI.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

*/

use master 
--select 'USE '+name from sys.databases where name like '%CL'
select top 100 hostname, sysprocesses.program_name,	sysprocesses.spid,	sys.databases.name 
from sysprocesses
JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
where name like 'PP_JAZZ%'

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name like 'PP_JAZZ%') AND SPId <> @@SPId

--PRINT @SQL
EXEC(@SQL)

	
use master

DECLARE 
	@MDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,	@LDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'
,	@DBLocation NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_'

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CC'
,@BACKUP_FILE= N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CC.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CC -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CAUTH'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CAuth.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CAUTH -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CoreApp'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CoreApp.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CoreApp -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CL'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CL.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CL -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CI'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CI.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CI -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CI_Secondary'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CI_Secondary.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CI_Secondary -- RESTORED' MESSAGE

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_CoreCredit'
,@BACKUP_FILE='\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\CARDS-291327_Bak_1_CoreCredit.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'

SELECT 'PP_JAZZ_CoreCredit -- RESTORED' MESSAGE