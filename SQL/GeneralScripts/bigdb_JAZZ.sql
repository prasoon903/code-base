--SELECT * FROM SYS.Servers where server_id = 0

---------------------------- POD 1 ---------------------
IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start restoring' Status

	use master
	--exec SP_RestoreDb 'PP_JAZZ_TEST','\\vbaghel\backup\COOKIE-172125\PLAT-105451\23.2.2_CI.bak'
	exec SP_RestoreDb 'PP_JAZZ_CC','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CC.bak'
	exec SP_RestoreDb 'PP_JAZZ_CoreCredit','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CoreCredit.bak'
	exec SP_RestoreDb 'PP_JAZZ_CoreApp','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CoreApp.bak'
	exec SP_RestoreDb 'PP_JAZZ_CI','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CI.bak'
	exec SP_RestoreDb 'PP_JAZZ_CI_Secondary','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CI_Secondary.bak'
	exec SP_RestoreDb 'PP_JAZZ_CL','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CL.bak'
	exec SP_RestoreDb 'PP_JAZZ_CAuth','\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\JAZZErrorTNP_CAuth.bak'
	
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

use PP_JAZZ_CI
Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
    (size * 8.0/1024) as Size,
    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
    From sys.database_files

use PP_JAZZ_CI
DBCC CHECKDB


use PP_JAZZ_CI
Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
    (size * 8.0/1024) as Size,
    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
    From sys.database_files


USE master;
GO
ALTER DATABASE DPUSHPAD_CI 
MODIFY FILE
    (NAME = DJ_BC_CI,
    SIZE = 2000MB);
GO

*/

