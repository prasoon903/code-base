USE master;
GO
ALTER DATABASE PP_JAZZ_CI 
MODIFY FILE
    (NAME = DJ_BC_CI,
    SIZE = 2000MB);
GO


USE master;
GO
ALTER DATABASE PP_JAZZ_CI_Secondary 
MODIFY FILE
    (NAME = ETL_CCGS_JAZZ_CoreIssue_Secondary,
    SIZE = 2000MB);
GO


--use PP_JAZZ_CI_Secondary
--Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
--    (size * 8.0/1024) as Size,
--    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
--    From sys.database_files