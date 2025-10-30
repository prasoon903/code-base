SELECT COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)


SELECT ErrorReason, ErrorMessage, COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
GROUP BY ErrorReason, ErrorMessage
ORDER BY ErrorReason, ErrorMessage

SELECT RTRIM(ErrorReason) ErrorReason, COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
GROUP BY ErrorReason
ORDER BY ErrorReason


SELECT ErrorMessage,*
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE ErrorReason = 'CRS_COMPUTATION_ERROR'
AND ErrorMessage IS NOT NULL
ORDER BY Skey

SELECT ErrorMessage, ScheduleID, acctID,*
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE ErrorReason = 'CRS_MDR_OUTPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
ORDER BY Skey

SELECT ErrorMessage, ScheduleID, acctID, FieldPath,*
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE ErrorReason = 'INPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
AND ErrorMessage LIKE 'Missing required month'
ORDER BY Skey

SELECT ErrorMessage, IB.ScheduleID, IB.acctID, FieldPath,ILP.ActivityOrder, ILP.LoanDate, IB.BusinessDate, IB.BatchTimeStamp, IB.ReportDate
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD IB WITH (NOLOCK)
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (IB.acctId = ILP.PlanID AND IB.ScheduleID = ILP.ScheduleID)
WHERE IB.ErrorReason = 'INPUT_VALIDATION_ERROR'
AND IB.ErrorMessage IS NOT NULL
AND IB.ErrorMessage = 'LastComputedMDRMonth can only be true for a single month'
ORDER BY IB.acctID--, IB.Skey DESC


SELECT RTRIM(ErrorMessage) ErrorMessage, COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE ErrorReason = 'INPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
GROUP BY ErrorMessage
ORDER BY COUNT(1) DESC

SELECT Activity, LutDescription, COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD t1 WITH (NOLOCK)
JOIN ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (T1.ScheduleID = T2.ScheduleID AND T1.acctID = T2.PlanID)
LEFT JOIN CCardLookUp C WITH (NOLOCK) ON (T2.Activity = TRY_CAST(C.LutCode AS INT) AND C.LutId = 'EPPReasonCode')
WHERE ErrorReason = 'INPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
GROUP BY Activity, C.LutDescription
ORDER BY COUNT(1) DESC


SELECT Activity, LutDescription, COUNT(1)
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD t1 WITH (NOLOCK)
JOIN ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (T1.ScheduleID = T2.ScheduleID AND T1.acctID = T2.PlanID)
LEFT JOIN CCardLookUp C WITH (NOLOCK) ON (T2.Activity = TRY_CAST(C.LutCode AS INT) AND C.LutId = 'EPPReasonCode')
WHERE ErrorReason = 'CRS_MDR_OUTPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
GROUP BY Activity, C.LutDescription
ORDER BY COUNT(1) DESC


SELECT ErrorMessage, T1.ScheduleID, T1.acctID, T1.*
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD t1 WITH (NOLOCK)
JOIN ILPScheduleDetailSummary T2 WITH (NOLOCK) ON (T1.ScheduleID = T2.ScheduleID AND T1.acctID = T2.PlanID)
LEFT JOIN CCardLookUp C WITH (NOLOCK) ON (T2.Activity = TRY_CAST(C.LutCode AS INT) AND C.LutId = 'EPPReasonCode')
WHERE ErrorReason = 'CRS_MDR_OUTPUT_VALIDATION_ERROR'
AND ErrorMessage IS NOT NULL
AND Activity = 21


SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD_Archive t1 WITH (NOLOCK) WHERE Schedule_ID = 0 AND acctID = 0
