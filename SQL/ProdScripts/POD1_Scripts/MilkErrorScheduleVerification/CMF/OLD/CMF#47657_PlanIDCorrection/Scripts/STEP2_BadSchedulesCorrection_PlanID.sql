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
	AND PlanUUID IN
	(
	'cc04cfc0-8376-4924-8fe4-ad88863f9416',
	'4a036d67-eae7-44b5-9ffc-adbc7be17b6a',
	'd0d137b4-5f6b-4434-b3ed-c2ff20b10d36',
	'60e4f462-ce86-4604-a1cf-6d62c998c84a'
	)
	GROUP BY PlanUUID

END
ELSE
BEGIN 
	PRINT 'TEMP_PlanToMove table does not exist, please execute the Supporting table script.'
END