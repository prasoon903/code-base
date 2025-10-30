SELECT
		PlanUUID, 0 AS JobStatus
FROM ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE JobStatus = 1
AND PlanUUID IN
(
'ee05d6c7-fdb0-418c-873d-eeb9bcdc81d6',
'7abd7920-0d8e-4f33-8ab7-5d961501620a',
'0bf8baaf-ece1-4431-a6f5-17c3080c4a57',
'9501cfee-7847-44fc-8c02-06951f5dc664',
'626a51db-b901-454a-8a9a-7d15c91d2566',
'469a5a08-a8b4-467e-80b5-ca8aa2250aaf',
'2c37a023-ef60-443b-8963-c07c6720b1b0',
'db88a07d-97f3-4614-8d08-8f5d34b31651',
'8fa507c1-bc45-4e1e-bb0b-7017bc03810a',
'33645d61-28db-43f5-a2c9-c87f19598c40',
'84a20f94-5b51-41b0-b607-121ac44179c9',
'5100d2c9-e64d-4862-adb9-446ebe22dd97',
'958cd9af-d8d3-4bc6-92e2-c12a5f7487c9',
'5bc103fe-0b15-4850-864b-e2474661ee05',
'79efb239-cd23-4eeb-a288-8537afcaaa1a',
'50b8d3f4-6f89-4b43-8ac0-56e00626e6b1',
'd8aec6f0-b42c-4cd1-802e-02b7d63c52c9',
'7bc064b6-6341-4e3e-9724-d42e5cd54a46',
'e2265052-56b8-4fe6-84a4-ecd4bd8939e4',
'db31cc1c-43ac-451d-a1ae-f9ef82e1ea75',
'0d2dc18f-e390-487b-9a89-ca56bcb0d144',
'85377b54-8010-41d7-96b4-6bfecb7b077f'
)
GROUP BY PlanUUID



SELECT JobStatus, COUNT(1) 
FROM TEMP_PlansToCorrect WITH (NOLOCK)
GROUP BY JobStatus


;WITH BADDATA AS (
SELECT * FROM ILPScheduleDetailsBad WITH (NOLOCK) WHERE JobStatus = 0)
SELECT *
FROM ILPScheduleDetailsBad ILPB WITH (NOLOCK) 
JOIN BADDATA BD ON (ILPB.ScheduleID = BD.ScheduleID)

;WITH DUMPDATA AS (
SELECT RANK() OVER(PARTITION BY ScheduleIDOnILP ORDER BY Skey) AS RANKING, * FROM ILPScheduleDetailsBad_DUMP WITH (NOLOCK) WHERE JobStatus = 1 
)
SELECT * FROM DUMPDATA WHERE RANKING > 1

SELECT TT.Skey,
	TT.JobStatus ,  
	TT.Counter ,  
	TT.ValidationMessage 
FROM ILPScheduledetailsBad_DUMP TT  
JOIN ILPScheduleDetailsBAD ILP WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleIDOnILP)  
WHERE ILP.JobStatus IN (0, 1) AND TT.JobStatus = 1

SELECT * FROM ILPScheduleDetailsBad_Archive WHERE JobStatus = 0

SELECT * FROM ILPScheduleDetailsBad_Dump WHERE ScheduleIDOnILP = 1516313




SELECT COUNT(1) 
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
WHERE ILPS.Activity = 25
AND DrCrIndicator_MTC = '-1'


SELECT FileName, COUNT(1) AS TotalRecords, COUNT(1) AS ProcessedRecords, MIN(ProcessingDate) AS StartTime, MAX(ProcessingDate) AS FinishTime
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_Archive WITH (NOLOCK)
GROUP BY FileName, ProcessingDate
ORDER BY FileName



;WITH ScheduleType
AS
(
	SELECT ILPS.PlanID, ILPD.PlanUUID, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder ASC) AS Ranking, ILPS.LoanDate
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.PlanUUID = ILPD.PlanUUID)
)
, FirstSchedule
AS
(
	SELECT PlanUUID, PlanID, LoanDate
	FROM ScheduleType ST WITH (NOLOCK)
	WHERE Ranking = 1 
	
)
SELECT *
FROM FirstSchedule
ORDER BY LoanDate DESC

;WITH ScheduleType
AS
(
	SELECT ILPD.PlanUUID, ILPS.PlanID, ILPS.ScheduleID, Activity, ILPS.ActivityOrder, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder ASC) AS Ranking
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
	--ORDER BY Activity
)
SELECT RTRIM(CL.LutDescription) AS ActivityType, FA.*
FROM FirstActivity FA WITH (NOLOCK)
LEFT OUTER JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (CAST(FA.Activity AS VARCHAR) = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode'
ORDER BY FA.Activity

--missing schedule data to identify the last computed MDR values

;WITH ScheduleType
AS
(
	SELECT ILPD.PlanUUID, ILPS.PlanID, ILPS.ScheduleID, Activity, ILPS.ActivityOrder, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder ASC) AS Ranking, ILPS.LoanDate, 
	ILPD.ErrorMessage, ILPD.FieldPath
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
)
, FirstActivity
AS
(
	SELECT *
	FROM ScheduleType ST WITH (NOLOCK)
	WHERE Ranking = 1
	--GROUP BY Activity
	--ORDER BY Activity
)
SELECT *
FROM FirstActivity
WHERE Activity = 3
ORDER BY LoanDate DESC



;WITH ScheduleType
AS
(
	SELECT ILPD.PlanUUID, ILPS.PlanID, ILPS.ScheduleID, Activity, ILPS.ActivityOrder, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder ASC) AS Ranking, ILPS.LoanDate, 
	ILPD.ErrorMessage, ILPD.FieldPath
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
)
, FirstActivity
AS
(
	SELECT *
	FROM ScheduleType ST WITH (NOLOCK)
	WHERE Ranking = 1
	--GROUP BY Activity
	--ORDER BY Activity
)
SELECT 
	 FieldPath, COUNT(1) RecordCount
FROM FirstActivity
GROUP BY  FieldPath
--WHERE Activity = 6
--ORDER BY Activity ASC

SELECT acctid, COUNT(1) 
FROM ILPScheduleDetailsBAD WITH (NOLOCK)
GROUP BY acctId


SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary WITH (NOLOCK) WHERE PlanUUID = '3e0611ed-ad8d-4dc0-b570-8afe50e0230d'
SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary WITH (NOLOCK) WHERE PlanUUID = '69638621-fc4c-4ea7-bcc2-57953b499b8b'


SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp WITH (NOLOCK) WHERE LUTid = 'EPPReasonCode' ORDER BY DisplayOrdr

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK) WHERE PlanUUID = 'testtransaction'

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK) WHERE acctId = 10798129

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD_DUMP WITH (NOLOCK)

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.RetailSchedulesCorrected WITH (NOLOCK)

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_Archive WITH (NOLOCK) WHERE FileName = 'ErrorPlanIDCorrectionFeed.csv'

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad WITH (NOLOCK) WHERE FileName = 'correction_feed_request_20201222_1.csv'
SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_Archive WITH (NOLOCK) WHERE FileName = 'correction_feed_request_20201222_1.csv'
SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_DUMP WITH (NOLOCK) WHERE FileName = 'correction_feed_request_20201222.csv'
SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.RetailSchedulesCorrected WITH (NOLOCK) WHERE FileName = 'correction_feed_request_20201222.csv'

SELECT * 
FROM ILPScheduleDetailsBad ILPB WITH (NOLOCK)
JOIN ILPScheduleDetailsBad_DUMP ILPD WITH (NOLOCK) ON (ILPB.JobStatus = ILPD.JobStatus AND ILPB.ScheduleID = ILPD.ScheduleIDOnILP)

--SP_HelpText USP_UpdateScheduleTypeOfBadSchedule

--104615

SELECT
	COUNT(1), FileName
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK)
--WHERE JobStatus = 1
GROUP BY FileName
ORDER BY FileName DESC

SELECT
	COUNT(1), FileName, JobStatus
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_DUMP WITH (NOLOCK)
--WHERE JobStatus = 1
GROUP BY FileName, JobStatus
ORDER BY FileName DESC

SELECT
	COUNT(1)
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK)
WHERE JobStatus = 1
GROUP BY PlanUUID

SELECT
	COUNT(1), JobStatus
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.TEMP_PlanToMove WITH (NOLOCK)
--WHERE JobStatus = 1
GROUP BY JobStatus


SELECT COUNT(1) FROM PROD1GSDB01.CCGS_CoreIssue.dbo.RetailSchedulesCorrected WITH (NOLOCK) WHERE FileName = 'ErrorPlanIDCorrectionFeed.csv'


;WITH CTE
AS
(
	SELECT ILPS.ScheduleID, ILPS.Activity
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.RetailSchedulesCorrected TP WITH (NOLOCK)  ON (ILPS.PlanUUID = TP.PlanUUID)
	WHERE FileName = 'ErrorPlanIDCorrectionFeed.csv'
)
, TotalRows
AS
(
SELECT COUNT(1) AS TotalRowsCount
FROM ILPScheduleDetails ILP WITH (NOLOCK)
JOIN CTE C ON (ILP.ScheduleID = C.ScheduleID)
WHERE Activity = 1
UNION ALL
SELECT COUNT(1) AS TotalRowsCount
FROM ILPScheduleDetailsRevised ILPR WITH (NOLOCK)
JOIN CTE C ON (ILPR.ScheduleID = C.ScheduleID)
WHERE Activity <> 1
)
SELECT SUM(TotalRowsCount) AS TotalRowsCount FROM TotalRows

SELECT ValidationMessage, COUNT(1) FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_Archive WITH (NOLOCK) WHERE FileName = 'amortization_schedule_error_feed_20200601.csv'
GROUP BY ValidationMessage



SELECT COUNT(1), acctid, PLANUUID, parent02AID, 0 AS [CheckStatus]
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK)
GROUP BY PLANUUID, acctid, parent02AID
ORDER BY acctid

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD WITH (NOLOCK) WHERE acctId = 37123792

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBad_Archive WITH (NOLOCK) WHERE acctId = 25199492

SELECT COUNT(1) FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary WITH (NOLOCK) WHERE PlanID = 35337522

SELECT ILPS.Skey, BP.UniversalUniqueID, CreditPlanMaster,ILPS.ActivityAmount,LTRIM(RTRIM(CL.LutDescription)) AS ActivityDescription, ILPS.PlanUUID, ILPS.parent02AID, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.CardAcceptorNameLocation, ILPS.ActivityOrder, ILPS.LastTermDate, WaiveMinDueCycle, FileDueToError, CorrectionDate
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
PROD1GSDB01.CCGS_CoreIssue.dbo.BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011117746812'
--AND ILPS.parent02AID = 2353424 
AND ILPS.PlanID IN (37123792) -- 10039174
--AND ILPS.PlanUUID = '66ae582d-69d3-4762-88ea-71b585617827'
--AND BP.UniversalUniqueID = '11c96eb6-fd59-465c-a2fe-6b313457d8e8'
ORDER BY ILPS.LoanDate

SELECT * FROM ILPScheduleDetails WITH (NOLOCK) WHERE ScheduleID = 826589 ORDER BY LoanTerm

/*
18941674
17846927
18901398
18899686 -- PC
18320649
18816045

--

19686631
18776392
*/

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetails WITH(NOLOCK) WHERE ScheduleID = 718479 ORDER BY LoanTerm -- 485762

SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsRevised WITH(NOLOCK) WHERE ScheduleID = 730341 ORDER BY LoanTerm -- 485762
SELECT * FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsRevised WITH(NOLOCK) WHERE ScheduleID = 716704 ORDER BY LoanTerm -- 485762

SELECT BSAcctid, TxnSource,C.TxnAcctId,C.TransactionAmount,C.CreditPlanMaster,C.TranId,C.TranRef,RMATranUUID,C.PostingRef,CMTTRANTYPE,C.TxnCode_Internal, C.TranTime, C.PostTime,
C.TransmissionDateTime,C.CardAcceptNameLocation,txnsource,C.ARTxnType,C.atid,noblobindicator,C.TranRef,C.TranId,txnacctid,C.tranorig,C.TransactionDescription,
C.TxnCode_Internal,C.GroupId,PaymentReferenceId,C.creditplanmaster,MessageReasonCode,TransactionAmount,FeesAcctID,accountnumber,TranId,
UniversalUniqueID,CaseID,PaymentCreditFlag,MessageIdentifier,TranRef,txnacctid
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.CCard_Primary C WITH (NOLOCK) 
WHERE AccountNumber in (SELECT AccountNumber FROM PROD1GSDB01.CCGS_CoreIssue.dbo.BSegment_Primary WITH(NOLOCK) WHERE acctid = 2587943) 
--AND TxnAcctid = 18776392
ORDER BY C.PostTime DESC

SELECT ILPS.ScheduleID,ILPS.* 
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
WHERE ILPS.Activity = 21 
AND ILPS.Principal > 0
ORDER BY ILPS.PlanID

SELECT ILPS.PlanID, ILPS.PlanUUID, COUNT(1)
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
WHERE ILPS.Activity = 3 
--AND ILPS.Principal = 0
GROUP BY ILPS.PlanID, ILPS.PlanUUID

;WITH DRPPlans
AS
(
	SELECT ILPD.PlanUUID, ILPS.PlanID
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
	WHERE ILPS.Activity = 21 
	AND ILPS.Principal = 0
	GROUP BY ILPD.PlanUUID, ILPS.PlanID
	--HAVING COUNT(1) = 2
)
SELECT COUNT(1)
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK)
JOIN DRPPlans DRP ON (DRP.PlanUUID = ILPD.PlanUUID)
--GROUP BY ILPD.PlanUUID

WITH DRPPlans
AS
(
	SELECT --TOP 10
		ILPD.PlanUUID, ILPS.PlanID
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
	WHERE ILPS.Activity = 21 
	AND ILPS.Principal = 0
	AND ILPS.PlanID > 0
	GROUP BY ILPD.PlanUUID, ILPS.PlanID
	--HAVING COUNT(1) = 1
)
SELECT 
	ILPS.PlanUUID, ILPS.PlanID, ILPS.ScheduleID 
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN DRPPlans DRP ON (DRP.PlanUUID = ILPS.PlanUUID)
WHERE ILPS.Activity = 21
AND ILPS.Principal = 0
ORDER BY ILPS.PlanID


WITH DRPPlans_CB_0
AS
(
	SELECT --TOP 10
		ILPD.PlanUUID, ILPS.PlanID
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK) ON (ILPS.ScheduleID = ILPD.ScheduleID)
	WHERE ILPS.Activity = 21 
	AND ILPS.Principal = 0
	GROUP BY ILPD.PlanUUID, ILPS.PlanID
	--HAVING COUNT(1) = 1
)
, RestPlans
AS
(
	SELECT ILPD.PlanUUID, ILPD.ScheduleID 
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailsBAD ILPD WITH (NOLOCK)
	LEFT JOIN DRPPlans_CB_0 DRP ON (ILPD.PlanUUID = DRP.PlanUUID)
	WHERE DRP.PlanUUID IS NULL
)
, RestSchedules
AS
(
	SELECT ILPS.PlanUUID, ILPS.ScheduleID, RTRIM(CL.LutDescription) AS ActivityType, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.ActivityOrder DESC) AS Ranking 
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN RestPlans RP ON (RP.PlanUUID = ILPS.PlanUUID)
	LEFT OUTER JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (CAST(ILPS.Activity AS VARCHAR) = CL.LutCode)
	WHERE CL.LUTid = 'EPPReasonCode'
)
SELECT ActivityType, COUNT(1) AS TotalRecordCount
FROM RestSchedules WITH (NOLOCK)
WHERE Ranking = 1
GROUP BY ActivityType
ORDER BY TotalRecordCount DESC




WITH CTE
AS
( 
    SELECT 
	Skey   
    , FileName  
    , FileID 
	, ScheduleIDOnILP 
    FROM ILPScheduleDetailsBAD_DUMP WITH (NOLOCK)  
    WHERE JobStatus = 1 
)
SELECT C.*, ILPB.FileName, ILPB.FileID, ILPB.JobStatus FROM ILPScheduleDetailsBad ILPB WITH (NOLOCK)
JOIN CTE C ON (C.ScheduleIDOnILP = ILPB.ScheduleID anD ILPB.JobStatus = 0)

SELECT * FROM ILPScheduleDetailsBad WITH (NOLOCK) WHERE JobStatus = 0 
SELECT * FROM ILPScheduleDetailsBAD_DUMP WITH (NOLOCK) WHERE JobStatus = 0 ScheduleIDOnILP = 1369004
JobStatus = 0

SELECT A.JobStatus, B.JobStatus,* FROM ILPScheduleDetailsBad A WITH (NOLOCK) 
join ILPScheduleDetailsBad B WITH (NOLOCK)
ON (A.ScheduleID = B.ScheduleID AND A.JobStatus <> B.JobStatus)
WHERE A.JobStatus = 1


DELETE FROM ILPScheduleDetailsBad WHERE Skey = 256009

UPDATE ILPScheduleDetailsBAD_DUMP SET JobStatus = 7 WHERE ScheduleIDOnILP = 1369004



--SELECT TT.Counter, ILP.Counter
--FROM ILPScheduleDetailsBAD_DUMP TT WITH (NOLOCK)
--JOIN ILPScheduleDetailsBAD ILP WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleIDOnILP)  
--    WHERE ILP.JobStatus = 1















