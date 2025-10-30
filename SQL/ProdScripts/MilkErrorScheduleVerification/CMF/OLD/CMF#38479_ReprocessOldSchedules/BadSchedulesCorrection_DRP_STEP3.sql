/*
Fill the job table to move the schedules to Corrected schedules table as well marking them correct in ILPScheduleDetailSummary table
*/
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_PlanToMove') AND TYPE = 'U') 
BEGIN

	TRUNCATE TABLE dbo.TEMP_PlanToMove

	;WITH ScheduleType
	AS
	(
		SELECT ILPS.PlanID, ILPD.PlanUUID, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder ASC) AS Ranking, ILPS.LoanDate
		FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
		JOIN ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.PlanUUID = ILPD.PlanUUID)
	)
	, FirstSchedule
	AS
	(
		SELECT PlanUUID, PlanID, LoanDate
		FROM ScheduleType ST WITH (NOLOCK)
		WHERE Ranking = 1 
	
	)
	INSERT INTO TEMP_PlanToMove
	SELECT PlanUUID, 0 AS JobStatus 
	FROM FirstSchedule
	WHERE LoanDate <= '2020-04-29 02:29:00'
	
	-- 18101 rows	
	

END
ELSE
BEGIN 
	PRINT 'TEMP_PlanToMove table does not exist, please execute the Supporting table script.'
END