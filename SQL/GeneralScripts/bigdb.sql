--SELECT * FROM SYS.Servers where server_id = 0

---------------------------- POD 1 ---------------------
IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start restoring' Status

	use master
	--exec SP_RestoreDb 'PP_TEST','\\harshitak\Local_BKP\23.8.4_143994\PLAT-58239_Ci.bak'
	exec SP_RestoreDb 'PP_CC','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CC.bak'
	exec SP_RestoreDb 'PP_CoreCredit','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CoreCredit.bak'
	exec SP_RestoreDb 'PP_CoreApp','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CoreApp.bak'
	exec SP_RestoreDb 'PP_CI','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CI.bak'
	exec SP_RestoreDb 'PP_CI_Secondary','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CI_Secondary.bak'
	exec SP_RestoreDb 'PP_CL','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CL.bak'
	exec SP_RestoreDb 'PP_CAuth','\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CAuth.bak'
	
	SELECT 'DB restored' Status
END
ELSE
SELECT 'Change server'




--exec SP_RestoreDb 'dj_bc_ci','\\harshitak\Backup\Backup4\UAT6defects\new\83359_0401dailydfEOD_CI.bak'

/*

CREATE DATABASE [Rohit_CI]
 CONTAINMENT = NONE
 ON  PRIMARY
( NAME = N'Rohit_CI', FILENAME = N'\\Xeon-s8\dfs\Rohit Soni\mdfldf\Rohit_CI.mdf',SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB ),
--( NAME = N'Rohit_CI_1', FILENAME = N'\\Xeon-s8\dfs\Rohit Soni\mdfldf\Rohit_CI_1.ndf',SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB ),
--( NAME = N'Rohit_CI_2', FILENAME = N'\\Xeon-s8\dfs\Rohit Soni\mdfldf\Rohit_CI_2.ndf' ,SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB )
 LOG ON
( NAME = N'Rohit_CI_log', FILENAME = N'\\Xeon-s8\dfs\Rohit Soni\mdfldf\Rohit_CI_log.ldf',SIZE = 10MB , MAXSIZE = 1GB , FILEGROWTH = 10%)
GO

-- CHECK FREE SPACE

use PP_CI
Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
    (size * 8.0/1024) as Size,
    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
    From sys.database_files

use PP_CI
DBCC CHECKDB

USE master;
GO
ALTER DATABASE PP_CI 
MODIFY FILE
    (NAME = DJ_BC_CI,
    SIZE = 3000MB);
GO

DBCC SHRINKFILE (PP_CIDJ_BC_CI, 3000);
\\BPLDEVDB01\Prasoon_Parashar\MDF\PP_CIDJ_BC_CI.mdf	5000.000000	3644.812500



use PP_CI_Secondary
Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
    (size * 8.0/1024) as Size,
	(FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024) UsedSpace,
    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
    From sys.database_files


USE master;
GO
ALTER DATABASE PP_CI_Secondary 
MODIFY FILE
    (NAME = MasterDB_New_Secondary_log,
    SIZE = 6000MB);
GO



SELECT name, recovery_model_desc 
FROM sys.databases 
WHERE name = 'PP_CI_SecondaryMasterDB_New_Secondary_log';

BACKUP LOG PP_CI_SecondaryMasterDB_New_Secondary_log 
TO DISK = 'D:\PP_CI_SecondaryMasterDB_New_Secondary_log.trn';

DBCC SHRINKFILE (MasterDB_New_Secondary_log, 1024); -- size in MB


\\BPLDEVDB01\Prasoon_Parashar\LDF\PP_CI_SecondaryMasterDB_New_Secondary_log.ldf



*/

