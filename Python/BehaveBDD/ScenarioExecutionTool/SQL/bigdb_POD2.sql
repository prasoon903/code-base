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

IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start restoring' Status

	use master
	--exec SP_RestoreDb 'PARASHAR_TEST','\\xeon-s9\DFS\PuspendraMaurya\Backup\RetailPlanoneachAccount( 500)\Before Statement\CI.bak'
	exec SP_RestoreDb 'PP_POD2_CC','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CC.bak'
	exec SP_RestoreDb 'PP_POD2_CoreCredit','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CoreCredit.bak'
	exec SP_RestoreDb 'PP_POD2_CoreApp','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CI.bak'
	exec SP_RestoreDb 'PP_POD2_CI','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CI.bak'
	exec SP_RestoreDb 'PP_POD2_CL','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CL.bak'
	exec SP_RestoreDb 'PP_POD2_CAuth','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CAuth.bak'
	exec SP_RestoreDb 'PP_POD2_CI_Secondary','\\BPLDEVDB01\Prasoon_Parashar\Backup\APIJob_CI_Secondary.bak'

	SELECT 'DB restored' Status

END
ELSE
SELECT 'Change server'

