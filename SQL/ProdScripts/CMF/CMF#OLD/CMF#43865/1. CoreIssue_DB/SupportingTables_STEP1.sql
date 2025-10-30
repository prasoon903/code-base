-- CREATING THE SUPPORTING TABLES

USE CCGS_CoreIssue
GO

IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.Temp_bsegment_DateDelinq') AND TYPE = 'U') 
BEGIN

	CREATE TABLE Temp_bsegment_DateDelinq
	(
		Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
		acctId INT,
		AccountNumber VARCHAR(19),
		UniversalUniqueID VARCHAR(64),
		CycleDueDTD INT,
		DtOfLastDelinqCTD DATETIME, 
		DateOfOriginalPaymentDueDTD DATETIME,
		JobStatus INT ,
		ProcessTime DATETIME
	)

	DROP INDEX IF EXISTS IX_Temp_bsegment_DateDelinq_Skey ON Temp_bsegment_DateDelinq
	CREATE CLUSTERED INDEX IX_Temp_bsegment_DateDelinq_Skey ON Temp_bsegment_DateDelinq (Skey)  
	  

	DROP INDEX IF EXISTS IDX_Temp_bsegment_DateDelinq_JobStatus ON Temp_bsegment_DateDelinq

	CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DateDelinq_JobStatus ON Temp_bsegment_DateDelinq
	(
		JobStatus
	)

END

IF NOT EXISTS (SELECT 1 FROM SYS.COLUMNS WHERE OBJECT_ID = OBJECT_ID(N'dbo.Temp_bsegment_DateDelinq') AND NAME = 'ProcessTime') 
BEGIN
	ALTER TABLE Temp_bsegment_DateDelinq ADD ProcessTime DATETIME
END

