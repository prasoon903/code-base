use master 

--select name from sys.databases where name like 'satyam_credit%'

select top 100 
	hostname,
	sysprocesses.program_name,
	sysprocesses.spid,
	sys.databases.name
from sysprocesses 
JOIN sys.databases ON(sys.databases.database_id=sysprocesses.dbid)
where dbid in(	select database_id 
	from sys.databases where name like 'Ritik%')

DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';
' + CAST(0xA as VARCHAR(1))
FROM MASTER..SysProcesses
WHERE DBId in (select database_id from sys.databases where name like 'Ritik%') AND SPId <> @@SPId

PRINT @SQL
EXEC(@SQL)

select * FROM MASTER..SysProcesses WHERE DBId in (select database_id from sys.databases where name like 'Ritik%') AND SPId <> @@SPId

