WITH ScheduleType
AS
(
	SELECT ILPD.PlanUUID, ILPS.ScheduleID, Activity, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.Skey DESC) AS Ranking
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
)
, FirstActivity
AS
(
	SELECT Activity, COUNT(1) AS RecordCount
	FROM ScheduleType ST WITH (NOLOCK)
	WHERE Ranking = 1
	GROUP BY Activity
)
, Activity
AS
(
	SELECT RTRIM(CL.LutDescription) AS ActivityType, FA.RecordCount
	FROM FirstActivity FA WITH (NOLOCK)
	LEFT OUTER JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (CAST(FA.Activity AS VARCHAR) = CL.LutCode)
	WHERE CL.LUTid = 'EPPReasonCode'
)
SELECT ActivityType, SUM(RecordCount) AS TotalRecordCount
FROM Activity WITH (NOLOCK)
GROUP BY ActivityType
ORDER BY TotalRecordCount DESC