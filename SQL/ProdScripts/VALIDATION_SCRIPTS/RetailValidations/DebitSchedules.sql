
;WITH BADPlans AS  (
SELECT DISTINCT acctId 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK) )
, DebitSchedules AS
(SELECT Parent02AID, PlanID, PlanUUID, ILPS.ScheduleID, ILPS.TranID 
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK) JOIN BADPlans BP ON (ILPS.PlanID = BP.acctId AND ILPS.Activity = 25))
, P9001 AS
(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranID AND CP.CMTTRanType = 'P9001'))
, R8001 AS
(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranRef AND CP.CMTTRanType = 'R8001'))
, AllSchedules AS
(SELECT * FROM P9001 UNION SELECT * FROM R8001 )
SELECT * FROM AllSchedules 
--GROUP BY Parent02AID
----ORDER BY PlanID

SELECT COUNT(1) RecordCount FROM AllSchedules 
--GROUP BY CMTTRanType

SELECT ScheduleType,* 
FROM ILPScheduleDetailSummary WITH (NOLOCK)
WHERE LoanDate > '2021-12-01'
AND Activity = 25


	
SELECT ILPS.ActivityOrder, ILPS.LoanTerm, ILPS.RevisedLoanTerm, LoanStartDate, ILPS.LasttermDate, ILPS.PlanUUID, BP.AccountNumber, JobStatus,ILPS.ActivityAmount,CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.CreditPlanMaster, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, FileDueToError, LoanStartDate, LastTermDate, waiveminduecycle, CorrectionDate, ILPS.PaidOffDate,
ILPS.ClientId, ScheduleType, MergeIndicator
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011147990216'
--AND ILPS.parent02AID = 2147149 
--AND BP.UniversalUniqueID = '1c5bf29d-6e57-4504-970b-6f5255553f7e'
AND ILPS.PlanID IN (43737014) -- 54793620, 54776612
--AND ILPS.PlanUUID = '90486527-319a-416c-9600-c2605a2c4ed2'
--AND ActivityOrder = 1
--AND ILPS.ScheduleID = 9680782
ORDER BY ILPS.LoanDate

SELECT *
FROM RetailSchedulesCorrected AS ILPS WITH (NOLOCK)
--WHERE acctId = 43737014
WHERE PlanUUID = '608e50b4-e0c1-4f04-9b6d-29e5a544d3ab'


SELECT RS.CorrectionDate, RS.*
FROM RetailSchedulesCorrected AS RS WITH (NOLOCK)
JOIN BSegment_Primary BS WITH (NOLOCK) ON (RS.parent02AID = BS.acctId)
--WHERE acctId = 43737014
--WHERE PlanUUID = '608e50b4-e0c1-4f04-9b6d-29e5a544d3ab'
WHERE MergeInProcessPH IS NOT NULL 
--AND RS.CorrectionDate > '2022-01-11'
ORDER BY RS.CorrectionDate DESC

SELECT TRY_CAST(CorrectionDate AS DATE), COUNT(1) 
FROM RetailSchedulesCorrected RS WITH (NOLOCK) 
GROUP BY TRY_CAST(CorrectionDate AS DATE)
ORDER BY TRY_CAST(CorrectionDate AS DATE) DESC



SELECT *
FROM RetailSchedulesCorrected RS WITH (NOLOCK) 

--DELETE TOP(2) FROM RetailSchedulesCorrected WHERE Skey IN (261875, 256115)

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.sysarticle

SELECT BS.acctId, ILPS.*
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.TEMP_PlanToMove AS ILPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (ILPS.PlanUUID = CPCC.PlanUUID)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (CPCC.acctId = CPA.acctid)
JOIN BSegment_Primary BS WITH (NOLOCK) ON (CPA.parent02AID = BS.acctId)
WHERE MergeInProcessPH IS NOT NULL


SELECT *
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.ILPScheduleDetailsBAD_Archive AS ILPS WITH (NOLOCK)
WHERE acctId = 43737014

SELECT COUNT(1)
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.ILPScheduleDetailsBAD_Archive AS ILPS WITH (NOLOCK)

--47917202






SELECT *
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
WHERE Activity = 25


SELECT COUNT(1)
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
WHERE Activity = 25

--10429


SELECT ILPS.ScheduleType, ILPS.*
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranID AND CP.CmtTranType = 'P9001')
WHERE Activity = 25 
--2247

SELECT ILPS.ScheduleType, ILPS.*
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranRef AND CP.CmtTranType = 'R8001')
WHERE Activity = 25
--7548


SELECT ScheduleID
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
WHERE Activity = 25
EXCEPT
(
SELECT ScheduleID
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranID AND CP.CmtTranType = 'P9001')
WHERE Activity = 25
UNION
SELECT ScheduleID
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranRef AND CP.CmtTranType = 'R8001')
WHERE Activity = 25
)
--9008

SELECT COUNT(1)
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranID AND CP.CmtTranType = 'P9001')
WHERE Activity = 25
GROUP BY PlanID
 
--2297,,, 2141

SELECT COUNT(1)
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON (ILPS.TranID = CP.TranRef AND CP.CmtTranType = 'R8001')
WHERE Activity = 25
GROUP BY PlanID
--7998,,, 7113

SELECT 7113 + 2141



;WITH BADPlans AS  (
	SELECT DISTINCT acctId 
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK) )
	, DebitSchedules AS
	(SELECT PlanID, PlanUUID, ILPS.ScheduleID, ILPS.TranID 
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK) JOIN BADPlans BP ON (ILPS.PlanID = BP.acctId AND ILPS.Activity = 25))
	, P9001 AS
	(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranID AND CP.CMTTRanType = 'P9001'))
	, R8001 AS
	(SELECT DS.*, CP.CMTTRanType FROM DebitSchedules DS JOIN CCard_Primary CP WITH (NOLOCK) ON (DS.TranID = CP.TranRef AND CP.CMTTRanType = 'R8001'))
	, AllSchedules AS
	(SELECT * FROM P9001 UNION SELECT * FROM R8001 )
	--INSERT INTO TEMP_BadSchedulesCorrection
	SELECT PlanUUID, PlanID, ScheduleID, 0 AS JobStatus 
	FROM AllSchedules