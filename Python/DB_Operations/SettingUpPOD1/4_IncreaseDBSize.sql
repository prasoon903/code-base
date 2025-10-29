USE master;
GO
ALTER DATABASE PP_CI 
MODIFY FILE
    (NAME = DJ_BC_CI,
    SIZE = 5000MB);
GO


USE master;
GO
ALTER DATABASE PP_CI_Secondary 
MODIFY FILE
    (NAME = MasterDB_New_Secondary_log,
    SIZE = 5000MB);
GO