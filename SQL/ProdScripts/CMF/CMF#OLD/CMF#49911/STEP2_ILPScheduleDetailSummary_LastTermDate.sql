/*
Fill the job table to move the schedules to Corrected schedules table as well marking them correct in ILPScheduleDetailSummary table
*/
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_ILPScheduleDetailSummary_LastTermDate') AND TYPE = 'U') 
BEGIN

	TRUNCATE TABLE TEMP_ILPScheduleDetailSummary_LastTermDate

	; WITH MaxLastTermDate
	AS
	(
		SELECT MAX(LastTermDate) LastTermDate, PlanID FROM ILPScheduleDetailSummary WITH (NOLOCK) GROUP BY PlanID
	)
	, LatestLastTermDate
	AS
	(
		SELECT RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder DESC) RankSchedule, Skey, PlanID, parent02AID, LastTermDate, LoanDate, Activity 
		FROM ILPScheduleDetailSummary WITH (NOLOCK)
	)
	INSERT INTO TEMP_ILPScheduleDetailSummary_LastTermDate
	(SkeyOnILP, parent02AID, PlanID, LastTermDateOld, LastTermDate)
	SELECT C1.Skey, C1.parent02AID, C1.PlanID, C1.LastTermDate, C2.LastTermDate
	FROM LatestLastTermDate C1
	JOIN MaxLastTermDate C2 ON (C1.PlanID = C2.PlanID AND C1.RankSchedule = 1)
	WHERE C1.LastTermDate < C2.LastTermDate
	--ORDER BY LoanDate DESC

END
ELSE
BEGIN 
	PRINT 'TEMP_ILPScheduleDetailSummary_LastTermDate table does not exist, please execute the Supporting table script.'
END