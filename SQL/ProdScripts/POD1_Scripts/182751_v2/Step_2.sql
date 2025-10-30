/*
Fill the temp job table with the bad schedules having DRP with CB = 0
*/

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_BadSchedulesCorrection') AND TYPE = 'U') 
BEGIN
	
	DROP TABLE IF EXISTS #TempSchedules
	SELECT ILPS.PlanUUID, PlanID, ILPS.Parent02AID, ILPS.ScheduleID, ILPS.TranID, 0 AS MergeSrcAcct 
	INTO #TempSchedules
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK) 
	WHERE (ILPS.Activity = 25 OR ILPS.Activity = 26) 
	AND ILPS.ScheduleType <> -99 

	UPDATE T
	SET MergeSrcAcct = 1 
	FROM #TempSchedules T 
	JOIN MergeAccountJob M WITH(NOLOCK) ON(T.Parent02AID = M.SrcBSAcctID)
	WHERE M.JobStatus = 'DONE'
	
	;WITH DebitSchedules AS
	(SELECT PlanUUID, PlanID, Parent02AID, ScheduleID, TranID FROM #TempSchedules WHERE MergeSrcAcct = 0)
	, PD AS
	(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranID AND CP.CMTTRanType NOT IN ('48', '49') ))
	, AllSchedules AS
	(SELECT * FROM PD )
	INSERT INTO TEMP_BadSchedulesCorrection
	SELECT PlanUUID, PlanID, ScheduleID, 0 AS JobStatus 
	FROM AllSchedules

END
ELSE
BEGIN 
	PRINT 'TEMP_BadSchedulesCorrection table does not exist, please execute the Supporting table script.'
END

