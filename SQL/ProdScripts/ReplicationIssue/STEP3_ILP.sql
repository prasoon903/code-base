
SELECT COUNT(1) FROM
(SELECT * FROM ILPScheduleDetailSummary T1 WITH (NOLOCK) WHERE T1.RowCreatedDate < '2022-09-30 11:59:57'
EXCEPT 
SELECT * FROM #TempILPReplication T1 WITH (NOLOCK)) s


SELECT PlanID, ScheduleID, Skey INTO Staging_RPT_DB.dbo.STEP3_ILPUpdates FROM
(SELECT * FROM ILPScheduleDetailSummary T1 WITH (NOLOCK) WHERE T1.RowCreatedDate < '2022-09-30 11:59:57'
EXCEPT 
SELECT * FROM #TempILPReplication T1 WITH (NOLOCK)) s


SELECT * FROM Staging_RPT_DB.dbo.STEP3_ILPUpdates


DROP TABLE IF EXISTS #TempILPReplication
SELECT * INTO #TempILPReplication FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailSummary T1 WITH (NOLOCK) WHERE T1.RowCreatedDate < '2022-09-30 11:59:57'


SELECT PlanID, ScheduleID, Skey
FROM ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.RowUpdatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'


SELECT T2.*
--INTO Staging_RPT_DB.dbo.ILPScheduleDetailSummary_new
from  (SELECT PlanID, ScheduleID, Skey
FROM ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT PlanID, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 
JOIN ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (S.PlanID = T2.PlanID AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)
