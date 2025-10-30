SELECT 'BSegment_Primary_Auth' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.DBO.BSegment_Primary T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreAuth.DBO.BSegment_Primary T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T1.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL


SELECT 'BSegment_Primary' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegment_Primary T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T1.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegment_Secondary' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Secondary T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegment_Secondary T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegmentCreditCard' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentCreditCard T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentCreditCard T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegment_Balances' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Balances T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegment_Balances T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
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

SELECT 'BsegmentLoyality' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BsegmentLoyality T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BsegmentLoyality T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSegmentPP' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegmentPP T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSegmentPP T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'LastUsedRates' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.LastUsedRates T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSegment_Primary T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.LastUsedRates T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.CreatedTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL

SELECT 'BSCBRIndicatorDetail' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BSCBRIndicatorDetail T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BSCBRIndicatorDetail T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T2.acctId IS NULL

select count(1)  from  (SELECT uniqueid 
FROM PaymentHoldDetails T1 WITH (NOLOCK) 
WHERE T1.posttime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
except
SELECT uniqueid
FROM Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.PaymentHoldDetails T1 WITH (NOLOCK) 
WHERE T1.posttime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57') s 


SELECT 'CPSgmentAccounts' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CPSgmentAccounts T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CPSgmentAccounts T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T1.PlanSegCreateDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL



SELECT 'CPSgmentCreditCard' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CPSgmentCreditCard T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CPSgmentAccounts T WITH (NOLOCK) ON (T.acctId = T1.acctid)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CPSgmentCreditCard T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T.PlanSegCreateDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.acctId IS NULL


SELECT 'CCard_Primary' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Primary T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCard_Primary T2 WITH (NOLOCK) ON (T1.TranID = T2.TranID)
WHERE T1.PostTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.TranID IS NULL

SELECT 'CCard_Secondary' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Secondary T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Primary T WITH (NOLOCK) ON (T.TranID = T1.TranID)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCard_Secondary T2 WITH (NOLOCK) ON (T1.TranID = T2.TranID)
WHERE T.PostTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.TranID IS NULL

SELECT 'CCardTransactionMC' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCardTransactionMC T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Primary T WITH (NOLOCK) ON (T.TranID = T1.TranID)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CCardTransactionMC T2 WITH (NOLOCK) ON (T1.TranID = T2.TranID)
WHERE T.PostTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.TranID IS NULL

SELECT 'CANLUpdates' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CANLUpdates T1 WITH (NOLOCK) 
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Primary T WITH (NOLOCK) ON (T.TranID = T1.TranID)
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.CANLUpdates T2 WITH (NOLOCK) ON (T1.TranID = T2.TranID)
WHERE T.PostTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.TranID IS NULL


SELECT 'Trans_In_Acct' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.Trans_In_Acct T1 WITH (NOLOCK)
JOIN PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.CCard_Primary T WITH (NOLOCK) ON (T.TranID = T1.tran_id_index) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.Trans_In_Acct T2 WITH (NOLOCK) ON (T1.tran_id_index = T2.tran_id_index AND T1.acctId = T2.acctId AND T1.ATID = T2.ATID)
WHERE T.PostTime BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57'
AND T2.tran_id_index IS NULL


SELECT 'ReagedAccounts' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.ReagedAccounts T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.ReagedAccounts T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T2.acctId IS NULL


SELECT 'BatchAccounts' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.BatchAccounts T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.BatchAccounts T2 WITH (NOLOCK) ON (T1.acctId = T2.acctId)
WHERE T1.BatchDate BETWEEN '2022-09-29 05:59:57' AND '2022-09-30 11:59:57' 
AND T2.acctId IS NULL


SELECT 'RejectedAccountDetails' [Table], COUNT(1) RecordCount
FROM PROD1GSDB02.CoreIssue_Snapshot_Snap_221001.DBO.RejectedAccountDetails T1 WITH (NOLOCK) 
LEFT JOIN Temp_P1MARPRODDB02.CCGS_RPT_CoreIssue.DBO.RejectedAccountDetails T2 WITH (NOLOCK) ON (T1.Skey = T2.Skey)
WHERE T2.Skey IS NULL