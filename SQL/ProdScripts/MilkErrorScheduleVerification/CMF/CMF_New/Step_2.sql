/*
Fill the temp job table with the bad schedules having DRP with CB = 0
*/

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_BadSchedulesCorrection') AND TYPE = 'U') 
BEGIN

	
	;WITH BADPlans AS  (
	SELECT DISTINCT acctId 
	FROM ILPScheduleDetailsBAD WITH (NOLOCK) )
	, DebitSchedules AS
	(SELECT PlanID, PlanUUID, ILPS.ScheduleID, ILPS.TranID 
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK) JOIN BADPlans BP ON (ILPS.PlanID = BP.acctId AND ILPS.Activity = 25))
	, P9001 AS
	(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranID AND CP.CMTTRanType = 'P9001'))
	, R8001 AS
	(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranRef AND CP.CMTTRanType = 'R8001'))
	, AllSchedules AS
	(SELECT * FROM P9001 UNION SELECT * FROM R8001 )
	--INSERT INTO TEMP_BadSchedulesCorrection
	SELECT PlanUUID, PlanID, ScheduleID, 0 AS JobStatus 
	FROM AllSchedules

END
ELSE
BEGIN 
	PRINT 'TEMP_BadSchedulesCorrection table does not exist, please execute the Supporting table script.'
END

