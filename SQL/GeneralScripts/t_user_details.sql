--Select * from master.dbo.t_user_details with(nolock) WHERE db_name IN ('PP_CI', 'PP_CI_Secondary', 'PP_CL', 'PP_CAuth', 'PP_CC', 'PP_CoreApp', 'PP_CoreCredit')
--Select * from master.dbo.t_user_details with(nolock) WHERE db_name IN ('PP_POD2_CI', 'PP_POD2_CI_Secondary', 'PP_POD2_CL', 'PP_POD2_CAuth', 'PP_POD2_CC', 'PP_POD2_CoreApp', 'PP_POD2_CoreCredit')
--Select * from master.dbo.t_user_details with(nolock) WHERE db_name IN ('PP_JAZZ_CI', 'PP_JAZZ_CI_Secondary', 'PP_JAZZ_CL', 'PP_JAZZ_CAuth', 'PP_JAZZ_CC', 'PP_JAZZ_CoreApp', 'PP_JAZZ_CoreCredit')

USE master

SET NOCOUNT ON

DROP TABLE IF EXISTS #TempDB
CREATE TABLE #TempDB (SN INT IDENTITY(1,1), DBName VARCHAR(30), Status INT DEFAULT(0))

INSERT INTO #TempDB (DBName) VALUES 
('PP_CI'), ('PP_CI_Secondary'), ('PP_CL'), ('PP_CAuth'), ('PP_CC'), ('PP_CoreApp'), ('PP_CoreCredit'), 
('PP_POD2_CI'), ('PP_POD2_CI_Secondary'), ('PP_POD2_CL'), ('PP_POD2_CAuth'), ('PP_POD2_CC'), ('PP_POD2_CoreApp'), ('PP_POD2_CoreCredit')
, ('PP_JAZZ_CI'), ('PP_JAZZ_CI_Secondary'), ('PP_JAZZ_CL'), ('PP_JAZZ_CAuth'), ('PP_JAZZ_CC'), ('PP_JAZZ_CoreApp'), ('PP_JAZZ_CoreCredit')

DROP TABLE IF EXISTS #TempUsers
CREATE TABLE #TempUsers (SN INT IDENTITY(1,1), Username VARCHAR(500), Status INT DEFAULT(0))

INSERT INTO #TempUsers (Username) VALUES
('NEWVISIONSOFT\development_users'), ('NEWVISIONSOFT\prepaid'), ('NEWVISIONSOFT\configuser')

--SELECT * FROM #TempUsers


DECLARE @Username VARCHAR(500)
DECLARE @DBName VARCHAR(30)

WHILE EXISTS (SELECT TOP 1 1 FROM #TempUsers WHERE Status = 0)
BEGIN
	SELECT TOP 1 @Username = Username FROM #TempUsers WHERE Status = 0
	--PRINT @Username

	UPDATE #TempDB SET Status = 0

	WHILE EXISTS (SELECT TOP 1 1 FROM #TempDB WHERE Status = 0)
	BEGIN
		SELECT TOP 1 @DBName = DBName FROM #TempDB WHERE Status = 0
		--PRINT @DBName

		IF EXISTS (Select 1 from t_user_details with(nolock) WHERE db_name = @DBName AND login_name = @Username)
		BEGIN
			UPDATE t_user_details SET status = 1 WHERE db_name = @DBName AND login_name = @Username
		END
		ELSE
		BEGIN
			INSERT INTO t_user_details (login_name,db_name,status) VALUES (@Username, @DBName, 1)
		END

		UPDATE #TempDB SET Status = 1 WHERE DBName = @DBName
	END

	UPDATE #TempUsers SET Status = 1 WHERE Username = @Username
END



USE msdb ;  
GO  

EXEC dbo.sp_start_job N'BPLDEVDB01_DBOWNER_Permission' ;  
GO 

PRINT 'WAITING FOR BPLDEVDB01_DBOWNER_Permission TO EXECUTE'

WAITFOR DELAY '00:00:02'

--sp_helptext sp_who2 

--sp_who2

--kill 1183          
--kill 1649  
--kill 173  
--kill 124  
--kill 949
--kill 1719
--kill 976


--SELECT * INTO BlockedSessions  FROM sp_who2

