-- CREATING THE SUPPORTING TABLES

IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'PaidOutDate_Populator') AND TYPE = 'U') 
BEGIN

	CREATE TABLE PaidOutDate_Populator 
	(
		Skey DECIMAL(19,0) IDENTITY(1,1),
		acctID INT,
		parent02AID INT,
		CurrentBalance MONEY,
		PaidOutDate DATETIME,
		JobStatus INT DEFAULT(0)
	)

	DROP INDEX IF EXISTS IX_PaidOutDate_Populator_Skey ON PaidOutDate_Populator

	CREATE CLUSTERED INDEX IX_PaidOutDate_Populator_Skey ON PaidOutDate_Populator 
	(
		Skey
	) 

	DROP INDEX IF EXISTS IDX_PaidOutDate_Populator_JobStatus ON PaidOutDate_Populator

	CREATE NONCLUSTERED INDEX IDX_PaidOutDate_Populator_JobStatus ON PaidOutDate_Populator
	(
		JobStatus
	)

END