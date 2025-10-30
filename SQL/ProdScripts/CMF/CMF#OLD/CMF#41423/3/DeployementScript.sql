USE SSISDB
GO

DECLARE @ProjectBinary AS varbinary(max)
DECLARE @operation_id AS bigint
SET @ProjectBinary =
(SELECT * FROM OPENROWSET(BULK '\\prod1gsdb02\DBAFiles\SQL2016_EOD_Tables_Operations_Job.ispac', SINGLE_BLOB) AS BinaryData)

EXEC catalog.deploy_project @folder_name = 'SQL2016_EOD_Tables_Operations_Job',
@project_name = 'SQL2016_EOD_Tables_Operations_Job',
@Project_Stream = @ProjectBinary,
@operation_id = @operation_id out