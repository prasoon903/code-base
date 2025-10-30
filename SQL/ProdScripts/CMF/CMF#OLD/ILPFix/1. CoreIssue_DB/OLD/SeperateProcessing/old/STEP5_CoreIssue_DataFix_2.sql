
BEGIN TRANSACTION
	
	
	UPDATE ILP
	SET  ILP.PlanID = ABS(ILP.PlanID)
	FROM ILPScheduleDetailSummary ILP
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
	WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
	and  TT.Ranking > 8
	-- 12 rows 

	;with CTEA
	as
	(
		SELECT ILPS.Skey, 
		RANK() OVER(PARTITION BY ILPS.parent02aid,ILPS.PlanID ORDER BY ILPS.LoanDate) 
		AS ActivityCount , ILPS.ActivityOrder
		FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
		where  ILPS.planid  in (19369686,20672208,13127516)
	)
	UPDATE ILPS
		SET ILPS.ActivityOrder = ActivityCount
		FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
		JOIN CTEA TD ON (TD.Skey = ILPS.Skey)
	-- 22 row update

	update ILPScheduleDetailSummary  set jobstatus  = 0  where  scheduleid in (  2818149,2815258,2815184)
	---3 rows update 
COMMIT 
--ROLLBACK 