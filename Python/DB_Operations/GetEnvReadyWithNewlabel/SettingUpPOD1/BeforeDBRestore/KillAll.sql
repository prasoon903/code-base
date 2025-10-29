use master 
--select 'USE '+name from sys.databases where name like '%CL'
select top 100 hostname, sysprocesses.program_name,	sysprocesses.spid,	sys.databases.name 
from sysprocesses
JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
where name like 'PP_%'

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name like 'PP_%') AND SPId <> @@SPId

PRINT @SQL
EXEC(@SQL)

--select DB_ID()