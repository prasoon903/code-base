IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start backup' Status

	use master
	BACKUP DATABASE PP_POD2_CAuth TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CI_Secondary] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CI_Secondary-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CL] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CL.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CoreCredit] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CoreApp] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_POD2_CC] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\Backup\ForgivenRem_CC.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

	SELECT 'Backup finished' Status

END
ELSE
SELECT 'Change server'

--BACKUP DATABASE [PP_POD2_CI] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\233628_FINAL_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

--BACKUP DATABASE [CCGS_CoreIssue] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\CCGS_CoreIssue.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [CCGS_RPT_CoreIssue] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\CCGS_RPT_CoreIssue.bak' WITH NOFORMAT, INIT,  NAME = N'PP_POD2_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
 
--BACKUP DATABASE [VP_CP_CI] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\BackUp_VP_CP_CI_CI.bak' WITH NOFORMAT, INIT,  NAME = N'VP_CP_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10


--use master

--BACKUP DATABASE Rohit_CAuth TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CI] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CI.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CL] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CL.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CoreCredit] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CoreApp] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
--BACKUP DATABASE [Rohit_CC] TO  DISK = N'\\XEON-S8\dfs\Prasoon Parashar\backup\Collateral_CC.bak' WITH NOFORMAT, INIT,  NAME = N'Rohit_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10



--BACKUP DATABASE [AmanGupta_Ci] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\ProdFix_CI.bak' WITH NOFORMAT, INIT,  NAME = N'AmanGupta_Ci-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10