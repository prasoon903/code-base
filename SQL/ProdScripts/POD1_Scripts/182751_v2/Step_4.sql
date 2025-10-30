/*
Fill the job table to move the schedules to Corrected schedules table as well marking them correct in ILPScheduleDetailSummary table
*/
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_PlanToMove') AND TYPE = 'U') 
BEGIN
	

	INSERT INTO TEMP_PlanToMove
	SELECT 
		 C.PlanUUID, 0 AS JobStatus
	FROM TEMP_BadSchedulesCorrection C WITH (NOLOCK)
	JOIN ILPScheduleDetailsBAD B WITH(NOLOCK) ON (B.acctid = C.PlanID)
	WHERE C.JobStatus = 1
	GROUP BY C.PlanUUID

END
ELSE
BEGIN 
	PRINT 'TEMP_PlanToMove table does not exist, please execute the Supporting table script.'
END