EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'PP_CI_Secondary'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE [PP_CI_Secondary] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

GO
USE [master]
GO
DROP DATABASE [PP_CI_Secondary]
GO
