

SELECT 'ILPSummary==>', COUNT(1) FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailSummary WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'
SELECT 'ILPSummary_Activity==>', COUNT(1) FROM CCGS_RPT_CoreIssue.dbo.ILPScheduleDetailSummary_Activity WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'

SELECT 'ILPDetails==>', COUNT(1) FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetails WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'
SELECT 'ILPDetails_Activity==>', COUNT(1) FROM CCGS_RPT_CoreIssue.dbo.ILPScheduleDetails_Activity WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'

SELECT 'ILPRevised==>', COUNT(1) FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailsRevised WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'
SELECT 'ILPRevised_Activity==>', COUNT(1) FROM CCGS_RPT_CoreIssue.dbo.ILPScheduleDetailsRevised_Activity WITH (NOLOCK) WHERE LoanDate < '2022-10-07 23:59:58'


/*



SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetails_Activity
from  (SELECT acctId, ScheduleID, Skey 
FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetails T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58'
except
SELECT acctId, ScheduleID, Skey
FROM CCGS_RPT_CoreIssue.dbo.ILPScheduleDetails_Activity T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58') s 
JOIN CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetails T2 WITH (NOLOCK) ON (S.acctId = T2.acctId AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)



SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetailsRevised_Activity
from  (SELECT acctId, ScheduleID, Skey 
FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailsRevised T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58'
except
SELECT acctId, ScheduleID, Skey
FROM CCGS_RPT_CoreIssue.dbo.ILPScheduleDetailsRevised_Activity T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58') s 
JOIN CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailsRevised T2 WITH (NOLOCK) ON (S.acctId = T2.acctId AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)

SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetailSummary_Activity
from  (SELECT PlanID, ScheduleID, Skey
FROM CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58'
except
SELECT PlanID, ScheduleID, Skey
FROM CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailSummary_Activity T1 WITH (NOLOCK) 
WHERE T1.LoanDate < '2022-10-07 23:59:58') s 
JOIN CoreIssue_Snapshot_Snap_221001.dbo.ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (S.PlanID = T2.PlanID AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)





*/