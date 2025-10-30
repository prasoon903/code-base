/*
Fill the temp job table with the bad schedules having DRP with CB = 0
*/

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_BadSchedulesCorrection') AND TYPE = 'U') 
BEGIN

	;WITH DRPPlans
	AS
	(
		SELECT 
			ILPD.PlanUUID, ILPS.PlanID
		FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
		JOIN ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
		WHERE ILPS.Activity = 21 
		AND ILPS.Principal = 0
		GROUP BY ILPD.PlanUUID, ILPS.PlanID
	)
	INSERT INTO TEMP_BadSchedulesCorrection
	SELECT 
		ILPS.PlanUUID, ILPS.PlanID, ILPS.ScheduleID, 0 AS JobStatus
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN DRPPlans DRP ON (DRP.PlanUUID = ILPS.PlanUUID)
	WHERE ILPS.Activity = 21
	AND ILPS.Principal = 0
	ORDER BY ILPS.PlanID

END
ELSE
BEGIN 
	PRINT 'TEMP_BadSchedulesCorrection table does not exist, please execute the Supporting table script.'
END

