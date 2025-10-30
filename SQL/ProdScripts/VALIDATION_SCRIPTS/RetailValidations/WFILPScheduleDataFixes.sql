SELECT * FROM Version with (nolock) order by 1 desc

DROP TABLE IF EXISTS #TEMP_ILPDetails

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
	SELECT 
		ILP.parent02AID, ILP.PlanID, ILP.PlanUUID, ILP.ActivityOrder, ILP.ScheduleID,
		ILP.EqualPaymentAmountCalc, ILP.LastMonthPayment, 
		RANK() OVER (PARTITION BY ILP.PlanID ORDER BY ILP.ActivityOrder) AS Ranking, ILP.Skey, 
		0 AS JobStatus
	INTO #TEMP_ILPDetails
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN FirstPlans FP ON (ILP.PlanID = FP.PlanID)
	WHERE ILP.ActivityOrder >= FP.ActivityOrder

	SELECT TOP 5 * FROM #TEMP_ILPDetails ORDER BY ScheduleID


	SELECT ILP.* 
	--INTO BKP_ILPScheduleDetailSummary_20201022
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN #TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.PlanID AND TT.ScheduleID = ILP.ScheduleID)
	WHERE TT.JobStatus = 0


	SELECT ILP.* 
	--INTO BKP_ILPScheduleDetailsRevised_20201022
	FROM ILPScheduleDetailsRevised ILP WITH (NOLOCK)
	JOIN #TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.acctId AND TT.ScheduleID = ILP.ScheduleID)
	WHERE TT.JobStatus = 0



	SELECT COUNT(1), Ranking, JobStatus FROM #TEMP_ILPDetails WITH (NOLOCK)
	GROUP BY Ranking, JobStatus
	Order by Ranking

	SELECT * FROM #TEMP_ILPDetails WITH (NOLOCK) WHERE Ranking = 1

	SELECT DISTINCT BP.UniversalUniqueID, T1.PlanUUID AS RMATranUUID, BS.ClientID, RTRIM(BP.AccountNumber) AccountNumber, BP.CycleDueDTD
	FROM TEMP_ILPDetails T1 WITH (NOLOCK)
	LEFT JOIN #TEMP_ILPDetails T2 ON (T1.ScheduleID = T2.ScheduleID AND T2.Ranking = 1)
	JOIN  BSegment_Primary BP WITH (NOLOCK) ON (T1.Parent02AID = BP.acctId)
	JOIN  BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
	WHERE T1.JobStatus IN (-3, -4) AND T2.ScheduleID IS NOT NULL
	

	SELECT DISTINCT PlanID from TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus IN (-3, -4)

	SELECT COUNT(1) from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0

	SELECT ILP.PlanID, ABS(ILP.PlanID),* FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
	WHERE TT.JobStatus = 1 AND ILP.JobStatus = 1

	SELECT ILP.PlanID, ABS(ILP.PlanID), RANK() OVER (PARTITION BY ILP.PlanUUID ORDER BY ILP.ActivityOrder) 
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
	WHERE TT.JobStatus = 1 AND ILP.ActivityOrder >= TT.ActivityOrder


	DECLARE @VarAt0 INT = 0, @VarAt30 INT = 0
	SELECT @VarAt0 = COUNT(1) from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0
	WAITFOR DELAY  '00:00:30' 
	SELECT @VarAt30 =  COUNT(1) from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0
	SELECT 'TPS', (@VarAt0 - @VarAt30) /30.0


;with CTEA
as
(
	SELECT ILPS.Skey, 
	RANK() OVER(PARTITION BY ILPS.parent02aid,ILPS.PlanID ORDER BY ILPS.LoanDate) 
	AS ActivityCount , ILPS.ActivityOrder
	FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
	where  ILPS.planid  in (19369686,20672208,13127516)
)
SELECT ILPS.*
	FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
	JOIN CTEA TD ON (TD.Skey = ILPS.Skey)
-- 22 row update


;with CTEA
as
(
	SELECT ILPS.Skey, 
	RANK() OVER(PARTITION BY ILPS.parent02aid,ILPS.PlanID ORDER BY ILPS.LoanDate) 
	AS ActivityCount , ILPS.ActivityOrder
	FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
	where  ILPS.planid  in (SELECT PlanID FROM TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus = 1 AND Ranking = 1)
)
SELECT * FROM CTEA
WHERE ActivityCount <> ActivityOrder

SELECT
ILP.*
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
and  TT.Ranking  = 5 AND TT.JobStatus = 0


SELECT * from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0

SELECT COUNT(1) from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0


select ranking,count(1)  from   TEMP_ILPDetails  with(nolock) where ranking  >1 and jobstatus = 0
and planid  in (select planid   from   TEMP_ILPDetails  with(nolock) where jobstatus  =1 )
group  by ranking 
order by ranking

SELECT * FROM TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus = 0 AND Ranking = 1

SELECT ILP.PlanID, ABS(ILP.PlanID),* FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
WHERE TT.JobStatus = 1 AND ILP.JobStatus = 1

;WITH CTE 
AS
(
	SELECT ILP.PlanID, ABS(ILP.PlanID) CorrectPlanID, RANK() OVER (PARTITION BY ILP.PlanUUID ORDER BY ILP.ActivityOrder) Ranking
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
	WHERE TT.JobStatus = 1 AND ILP.ActivityOrder >= TT.ActivityOrder
)
SELECT * FROM CTE WHERE Ranking = 2

;WITH CTE 
AS
(
	SELECT ILP.PlanID, ABS(ILP.PlanID) CorrectPlanID, RANK() OVER (PARTITION BY ILP.PlanUUID ORDER BY ILP.ActivityOrder) Ranking
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
	WHERE TT.JobStatus = 1 AND ILP.ActivityOrder >= TT.ActivityOrder
)
SELECT * FROM CTE WHERE Ranking >= 2


;WITH CTE
AS
(SELECT PlanID, PlanUUID, ActivityOrder from ILPScheduleDetailSummary WITH (NOLOCK) WHERE JobStatus = 0)
SELECT ILP.PlanID, ABS(ILP.PlanID), RANK() OVER (PARTITION BY ILP.PlanUUID ORDER BY ILP.ActivityOrder) AS Ranking
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN CTE TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
WHERE ILP.ActivityOrder > TT.ActivityOrder








;WITH CTE 
AS
(
	SELECT ILP.PlanID, ABS(ILP.PlanID) CorrectPlanID, ILP.ActivityOrder, RANK() OVER (PARTITION BY ILP.PlanUUID ORDER BY ILP.ActivityOrder) Ranking, ILP.PlanUUID, ILP.Skey
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.PlanUUID = TT.PlanUUID)
	WHERE TT.JobStatus = 1 AND ILP.ActivityOrder >= TT.ActivityOrder
)
SELECT ILP.JobStatus, ILP.PlanID, ABS(ILP.PlanID)
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK) 
JOIN CTE C ON (ILP.Skey = C.Skey)
WHERE Ranking = 2 AND ILP.ActivityOrder = C.ActivityOrder


SELECT JobStatus, COUNT(1) 
FROM TEMP_ILPDetails WITH (NOLOCK)
GROUP BY JobStatus
ORDER BY JobStatus


SELECT * 
FROM TEMP_ILPDetails WITH (NOLOCK)
WHERE PlanID = 21941006

select ranking,count(1)  from   TEMP_ILPDetails  with(nolock) where ranking  >1 
and planid  in (select planid   from   TEMP_ILPDetails  with(nolock) where jobstatus  =1 )
group  by ranking 
order by ranking


--UPDATE ILP
--SET
--	JobStatus = 0,
--	PlanID = ABS(ILP.PlanID)
--FROM ILPScheduleDetailSummary ILP
--JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
--WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
--AND TT.Ranking = 2

SELECT ILP.JobStatus, ILP.LoanStartDate, ILP.LoanEndDate,ILP.*
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
AND TT.Ranking = 2 AND ILP.JobStatus = 1




BEGIN TRANSACTION
	
	
	UPDATE ILP
	SET  ILP.JobStatus = 0,  ILP.PlanID = ABS(ILP.PlanID)
	FROM ILPScheduleDetailSummary ILP
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
	WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
	and  TT.Ranking  = 2 AND TT.JobStatus = 0
	-- 5 rows

COMMIT 
--ROLLBACK 


SELECT
ILP.*
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
and  TT.Ranking  = 2 AND TT.JobStatus = 0







SELECT TT.* ,
'UPDATE ILPScheduleDetailSummary SET LoanEndDate = ''' + CONVERT(VARCHAR(50), EOMONTH(DATEADD(MONTH, -1, ILP.LoanEndDate)), 20) + ' 23:59:57''' + ' WHERE PlanID = ' + TRY_CAST(ILP.PlanID AS VARCHAR) + '	AND ActivityOrder = ' + TRY_CAST(ILP.ActivityOrder - 1 AS VARCHAR) + '  -- Previous: ' + CONVERT(VARCHAR(50), ILP.LoanEndDate, 20)
FROM #TEMP_ILPDetails TT WITH (NOLOCK) 
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (TT.ScheduleID = ILP.ScheduleID)
WHERE Ranking = 1




UPDATE ILPScheduleDetailSummary SET LoanEndDate = '' WHERE PlanID = 9161345 AND ActivityOrder = 4
UPDATE ILPScheduleDetailSummary SET LoanEndDate = '' WHERE PlanID = 11778559 AND ActivityOrder = 4
UPDATE ILPScheduleDetailSummary SET LoanEndDate = '' WHERE PlanID = 12177211 AND ActivityOrder = 4