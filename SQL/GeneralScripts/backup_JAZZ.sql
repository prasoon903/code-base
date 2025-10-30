IF EXISTS(SELECT 1 FROM SYS.Servers where server_id = 0 and name = 'BPLDEVDB01')
BEGIN

	SELECT 'Start backup' Status

	use master
	BACKUP DATABASE PP_JAZZ_CAuth TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CI] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CI_Secondary] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CI_Secondary-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CL] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CL.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CoreCredit] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CoreApp] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
	BACKUP DATABASE [PP_JAZZ_CC] TO  DISK = N'\\BPLDEVDB01\Prasoon_Parashar\JazzDB\Backup\SoldAccounts_BaseDB_CC.bak' WITH NOFORMAT, INIT,  NAME = N'PP_JAZZ_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

	SELECT 'Backup finished' Status

END
ELSE
SELECT 'Change server'

