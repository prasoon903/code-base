--SELECT TOP 10 * FROM Trans_In_Acct WITH (NOLOCK) ORDER BY BusinessDay DESC


SELECT 'BSCBRIndicatorDetail' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSCBRIndicatorDetail T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSCBRIndicatorDetail T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL


SELECT 'BSegmentCBscore' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentCBscore T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentCBscore T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegmentFees' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentFees T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentFees T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegmentInsurance' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentInsurance T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentInsurance T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'CCardLookUp' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCardLookUp T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCardLookUp T2 WITH (NOLOCK) ON (T1.LutId = T2.LutId AND T1.LutCode = T2.LutCode AND T1.LutLanguage = T2.LutLanguage AND T1.Module = T2.Module)
WHERE T2.LutCode IS NULL

SELECT 'ReagedAccounts' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.ReagedAccounts T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ReagedAccounts T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T2.acctId IS NULL

SELECT 'TpyTable' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.TpyTable T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.TpyTable T2 WITH (NOLOCK) ON (T1.tpyID = T2.tpyID)
WHERE T1.tpyModifiedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.tpyID IS NULL



SELECT 'CCardLookUp' [Table],T1.*
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCardLookUp T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCardLookUp T2 WITH (NOLOCK) ON (T1.LutId = T2.LutId AND T1.LutCode = T2.LutCode AND T1.LutLanguage = T2.LutLanguage AND T1.Module = T2.Module)
WHERE T2.LutCode IS NULL


select count(1)  from  (SELECT acctId, ScheduleID, Skey 
FROM ILPScheduleDetails T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT acctId, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetails T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 

select count(1)  from  (SELECT acctId, ScheduleID, Skey 
FROM ILPScheduleDetailsRevised T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT acctId, ScheduleID, Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ILPScheduleDetailsRevised T1 WITH (NOLOCK) 
WHERE T1.RowCreatedDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 

--149750


select count(1)  from  (SELECT Skey 
FROM retailSchedulesCorrected T1 WITH (NOLOCK) 
WHERE T1.CorrectionDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT Skey
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.retailSchedulesCorrected T1 WITH (NOLOCK) 
WHERE T1.CorrectionDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 



--acctId, ScheduleID, Skey