/*

use master
EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_JAZZ_JAZZ_TEST'
,@BACKUP_FILE= N' \\BPLDEVDB01\Prasoon_Parashar\MDF\BackUp\ReageIssue_CI.bak'
,@MDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\MDF\MDF'
,@LDF_LOCATION = N'\\BPLDEVDB01\Prasoon_Parashar\MDF\LDF'

*/

use master 
--select 'USE '+name from sys.databases where name like '%CL'
select top 100 hostname, sysprocesses.program_name,	sysprocesses.spid,	sys.databases.name 
from sysprocesses
JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
where name = 'PP_TEST'

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name = 'PP_TEST') AND SPId <> @@SPId

PRINT @SQL
EXEC(@SQL)

	
use master

--JAZZ / PP_JAZZ_TEST
--DECLARE 
--	@MDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF'
--,	@LDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF'


--EXEC SP_RESTOREDB_Enhanced
--@DB_NAME = N'PP_JAZZ_TEST'
--,@BACKUP_FILE= N'\\bplqadb01\Ankit_Kumar\Cards-294190_Afterfix_Final\CI.bak'
--,@MDF_LOCATION = @MDF
--,@LDF_LOCATION = @LDF



--use master

----PLAT / PP_TEST
DECLARE 
	@MDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\MDF'
,	@LDF NVARCHAR(MAX) = N'\\BPLDEVDB01\Prasoon_Parashar\LDF'

EXEC SP_RESTOREDB_Enhanced
@DB_NAME = N'PP_TEST'
,@BACKUP_FILE= N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Issue\CI.bak'
,@MDF_LOCATION = @MDF
,@LDF_LOCATION = @LDF


--EXEC SP_RESTOREDB_Enhanced
--@DB_NAME = N'PP_TEST_Secondary'
--,@BACKUP_FILE= N'\\vmpradhumnp\D\backups\New folder\CI_Secondary.bak'
--,@MDF_LOCATION = @MDF
--,@LDF_LOCATION = @LDF


--EXEC xp_readerrorlog 0, 1, '823';