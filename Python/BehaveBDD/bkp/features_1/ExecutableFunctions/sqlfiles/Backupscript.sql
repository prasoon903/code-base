USE MASTER
BACKUP DATABASE PP_CAuth TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CAuth-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CI] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CI.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CI-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CI_Secondary] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CI_Secondary-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CL] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CL.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CL-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CoreCredit] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CoreCredit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CoreApp] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CoreApp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
BACKUP DATABASE [PP_CC] TO  DISK = N'\\Xeon-s8\dfs\Prasoon Parashar\backup\BehaveBDD_CC.bak' WITH NOFORMAT, INIT,  NAME = N'PP_CC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
