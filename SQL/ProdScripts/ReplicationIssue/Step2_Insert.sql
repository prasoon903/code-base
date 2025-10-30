--SELECT * FROM Staging_RPT_DB.dbo.BSCBRIndicatorDetail
--SELECT * FROM Staging_RPT_DB.dbo.BSegmentCBscore
--SELECT * FROM Staging_RPT_DB.dbo.BSegmentFees
--SELECT * FROM Staging_RPT_DB.dbo.BSegmentInsurance
--SELECT * FROM Staging_RPT_DB.dbo.CCardLookUp
--SELECT * FROM Staging_RPT_DB.dbo.ReagedAccounts


SELECT 'BSCBRIndicatorDetail' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.BSCBRIndicatorDetail
SELECT 'BSegmentCBscore' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.BSegmentCBscore
SELECT 'BSegmentFees' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.BSegmentFees
SELECT 'BSegmentInsurance' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.BSegmentInsurance
SELECT 'CCardLookUp' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.CCardLookUp
SELECT 'ReagedAccounts' [Table], COUNT(1) RecordCount FROM Staging_RPT_DB.dbo.ReagedAccounts


/*

SELECT T1.*
INTO Staging_RPT_DB.dbo.BSCBRIndicatorDetail
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSCBRIndicatorDetail T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSCBRIndicatorDetail T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL



SELECT T1.*
INTO Staging_RPT_DB.dbo.BSegmentCBscore
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentCBscore T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentCBscore T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT T1.*
INTO Staging_RPT_DB.dbo.BSegmentFees
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentFees T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentFees T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT T1.*
INTO Staging_RPT_DB.dbo.BSegmentInsurance
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentInsurance T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentInsurance T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT T1.*
INTO Staging_RPT_DB.dbo.CCardLookUp
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCardLookUp T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCardLookUp T2 WITH (NOLOCK) ON (T1.LutId = T2.LutId AND T1.LutCode = T2.LutCode AND T1.LutLanguage = T2.LutLanguage AND T1.Module = T2.Module)
WHERE T2.LutCode IS NULL

SELECT T1.*
INTO Staging_RPT_DB.dbo.ReagedAccounts
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.ReagedAccounts T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ReagedAccounts T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T2.acctId IS NULL



SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetails
from  (SELECT acctId, ScheduleID, Skey 
FROM ILPScheduleDetails T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT acctId, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetails T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 
JOIN ILPScheduleDetails T2 WITH (NOLOCK) ON (S.acctId = T2.acctId AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)



SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetailsRevised
from  (SELECT acctId, ScheduleID, Skey 
FROM ILPScheduleDetailsRevised T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT acctId, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailsRevised T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 
JOIN ILPScheduleDetailsRevised T2 WITH (NOLOCK) ON (S.acctId = T2.acctId AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)

SELECT T2.*
INTO Staging_RPT_DB.dbo.ILPScheduleDetailSummary_new
from  (SELECT PlanID, ScheduleID, Skey
FROM ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT PlanID, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailSummary T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 
JOIN ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (S.PlanID = T2.PlanID AND S.ScheduleID = T2.ScheduleID AND S.Skey = T2.Skey)




*/