IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start backup' Status

	USE MASTER
	BACKUP DATABASE PP_CAuth TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CI_Secondary] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CI_Secondary-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CL] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CL.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CoreCredit] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CoreApp] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_CC] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\SCRA_2_CC.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

	SELECT 'Backup finished' Status

END
ELSE
SELECT 'Change server'





--BACKUP DATABASE [PP_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\233628_FINAL_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

--BACKUP DATABASE [CCGS_CoreIssue] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\CCGS_CoreIssue.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [CCGS_RPT_CoreIssue] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\CCGS_RPT_CoreIssue.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
 
--BACKUP DATABASE [VP_CP_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\BackUp_VP_CP_CI_CI.bak' WITH NOFORMAT, INIT,  NAME = N'VP_CP_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10


--use master

--BACKUP DATABASE Rohit_CAuth TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CI.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CL] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CL.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CoreCredit] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CoreApp] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CC] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\Collateral_CC.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10



--BACKUP DATABASE [AmanGupta_Ci] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ProdFix_CI.bak' WITH NOFORMAT, INIT,  NAME = N'AmanGupta_Ci-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10