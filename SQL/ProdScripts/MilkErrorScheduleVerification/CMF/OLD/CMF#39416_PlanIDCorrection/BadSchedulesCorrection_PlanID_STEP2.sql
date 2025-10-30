/*
Fill the job table to move the schedules to Corrected schedules table as well marking them correct in ILPScheduleDetailSummary table
*/
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_PlanToMove') AND TYPE = 'U') 
BEGIN

	TRUNCATE TABLE TEMP_PlanToMove

	INSERT INTO TEMP_PlanToMove
	SELECT
		 PlanUUID, 0 AS JobStatus
	FROM ILPScheduleDetailsBAD WITH (NOLOCK)
	WHERE JobStatus = 1
	GROUP BY PlanUUID

END
ELSE
BEGIN 
	PRINT 'TEMP_PlanToMove table does not exist, please execute the Supporting table script.'
END