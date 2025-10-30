USE CCGS_CoreIssue
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_ILPDetails') AND TYPE = 'U') 
BEGIN

	-- TEMP DATA Tables

	--TRUNCATE TABLE TEMP_ILPDetails

	UPDATE TEMP_ILPDetails SET Jobstatus = -4 WHERE JobStatus = 1
	--24 rows

	UPDATE TEMP_ILPDetails SET Jobstatus = -10 WHERE JobStatus = 0
	--17652 rows

	--SELECT * FROM TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus = 1

	;WITH CTE 
	AS 
	(
	SELECT RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder) AS Ranking, *
	FROM ILPScheduleDetailSummary WITH (NOLOCK)
	WHERE LastMonthPayment > EqualPaymentAmountCalc AND LastMonthPayment - EqualPaymentAmountCalc > 1
	AND PlanID > 0
	)
	, FirstPlans 
	AS 
	(
	SELECT C.PlanID, C.PlanUUID, C.ScheduleID, C.ActivityOrder
	FROM CTE C
	WHERE Ranking = 1 AND Activity = 21
	)
	, OriginalSchedule
	AS
	(
	SELECT ILP.PlanID, ILP.LastMonthPayment
	FROM FirstPlans FP 
	JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (FP.PlanID = ILP.PlanID)
	WHERE ILP.ActivityOrder = 1
	)
	INSERT INTO TEMP_ILPDetails
	SELECT 
		ILP.parent02AID, ILP.PlanID, ILP.PlanUUID, ILP.ActivityOrder, ILP.ScheduleID,
		OS.LastMonthPayment, ILP.LastMonthPayment, 
		RANK() OVER (PARTITION BY ILP.PlanID ORDER BY ILP.ActivityOrder) AS Ranking, ILP.Skey, 
		0 AS JobStatus
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN FirstPlans FP ON (ILP.PlanID = FP.PlanID)
	JOIN OriginalSchedule OS ON (OS.PlanID = FP.PlanID)
	WHERE ILP.ActivityOrder >= FP.ActivityOrder


END
ELSE
BEGIN 
	PRINT 'TEMP_ILPDetails table does not exist, please execute the Supporting table script.'
END
