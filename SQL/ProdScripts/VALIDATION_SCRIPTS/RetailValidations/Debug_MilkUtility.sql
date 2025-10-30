DROP TABLE IF EXISTS #ILPScheduledetailsBad_DUMP
DROP TABLE IF EXISTS #ILPScheduleDetailsBAD
DROP TABLE IF EXISTS #ILPScheduleDetailsBAD_Archive

SELECT * INTO #ILPScheduledetailsBad_DUMP FROM ILPScheduledetailsBad_DUMP WITH (NOLOCK)
SELECT * INTO #ILPScheduleDetailsBAD FROM ILPScheduledetailsBad WITH (NOLOCK)
SELECT * INTO #ILPScheduleDetailsBAD_Archive FROM ILPScheduleDetailsBAD_Archive WITH (NOLOCK)

SELECT COUNT(1) FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.ILPScheduledetailsBad_DUMP WITH (NOLOCK)

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.ILPScheduledetailsBad_DUMP WITH (NOLOCK)

ALTER TABLE #ILPScheduleDetailsBAD ADD  CONSTRAINT [csPk_ILPScheduleDetailsBAD_TEMP1] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC,
	[JobStatus] ASC
)

--SELECT * FROM #ILPScheduleDetailsBAD ORDER BY FileName DESC


--select * from tempdb.dbo.sysobjects where id = OBJECT_ID('tempdb..#ILPScheduleDetailsBAD')



-- STEP 1

--EXEC USP_UpdateScheduleTypeOfBadSchedule 'amortization_schedule_error_feed_20200827.csv', '202008280301211'
DROP TABLE IF EXISTS #TempUpdateSchedules 
CREATE TABLE #TempUpdateSchedules  
(  
	Skey DECIMAL(19,0), UniversalUniqueID VARCHAR(64)  , PlanUUID VARCHAR(64)  , ScheduleID DECIMAL(19,0)  , FileName VARCHAR(300)  
) 

INSERT INTO #TempUpdateSchedules  
SELECT --TOP (@BatchCount)  
    Skey,  
    UniversalUniqueID,  
    PlanUUID,  
    ScheduleID,  
    FileName + '_FileID_' + FileID  
FROM #ILPScheduleDetailsBAD WITH (NOLOCK)  
WHERE JobStatus = 0 AND FileName = 'amortization_schedule_error_feed_20200827.csv' AND FileID = '202008280301211'

UPDATE ILPD  
SET  
JobStatus = 1  
FROM #ILPScheduleDetailsBAD ILPD WITH (NOLOCK)  
JOIN #TempUpdateSchedules TT ON (ILPD.Skey = TT.Skey) 

-- STEP 2

;WITH DumpData
AS
(
	SELECT RANK() OVER(PARTITION BY ScheduleIDOnILP ORDER BY Skey) AS Ranking, Skey,  ScheduleIDOnILP
	FROM #ILPScheduledetailsBad_DUMP WITH (NOLOCK)
	WHERE JobStatus = 1
)
UPDATE ILP
SET JobStatus = 7
FROM #ILPScheduledetailsBad_DUMP ILP
JOIN DumpData DD ON (ILP.Skey = DD.Skey)
WHERE DD.Ranking > 1

-- 5 rows

-- STEP 3

UPDATE TT  
SET  
    TT.JobStatus = 7,  
    TT.Counter = TT.Counter + ILP.Counter,  
    ValidationMessage = 'Duplicate or active record already present for this ScheduleID'  
FROM #ILPScheduledetailsBad_DUMP TT  
JOIN #ILPScheduleDetailsBAD ILP WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleIDOnILP)  
WHERE ILP.JobStatus IN (0, 1) AND TT.JobStatus = 1

-- STEP 4

BEGIN TRANSACTION   
  
      INSERT INTO #ILPScheduleDetailsBAD  
      (  
		UniversalUniqueID , PlanUUID	, ScheduleID, ReportDate, BusinessDate, BatchTimestamp, InstitutionID, ProductID, ErrorReason  
		, FileName, FileID, parent02AID, AccountNumber, acctId, JobStatus , ProcessingDate, Counter, ErrorMessage, FieldPath  
      )  
      SELECT 
		Account_UUID , Plan_UUID, ScheduleIDOnILP, CAST(Report_Date AS DATETIME), CAST(Business_Date AS DATE), CAST(Batch_Timestamp AS TIME), Institution_ID, Product_ID, Error  
		, FileName, FileID, parent02AID, AccountNumber, acctId, 0, ProcessingDate, Counter, [Error_Message], Field_Path  
      FROM #ILPScheduleDetailsBAD_DUMP WITH (NOLOCK)  
      WHERE FileName = 'amortization_schedule_error_feed_20200903.csv' AND FileID = '202009040301201' AND JobStatus = 1  
  
      INSERT INTO #ILPScheduleDetailsBAD_Archive  
      (  
		Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, Product_ID, Error, FileName  
		, FileID, parent02AID, AccountNumber, acctId, ScheduleIDOnILP, JobStatus, ProcessingDate, CorrectionDate, ValidationMessage, [Error_Message], Field_Path  
      )  
      SELECT  
		ILP.Report_Date, ILP.Business_Date, ILP.Batch_Timestamp, ILP.Account_UUID, ILP.Plan_UUID, ILP.Schedule_ID, ILP.Institution_ID, ILP.Product_ID, ILP.Error, ILP.FileName  
		, ILP.FileID, ILP.parent02AID, ILP.AccountNumber, ILP.acctId, ILP.ScheduleIDOnILP, ILP.JobStatus, ILP.ProcessingDate, ILP.CorrectionDate, ILP.ValidationMessage, ILP.[Error_Message], ILP.Field_Path  
      FROM #ILPScheduleDetailsBAD_DUMP ILP WITH (NOLOCK)   
  
      DELETE FROM #ILPScheduleDetailsBAD_DUMP    
  
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

-- STEP 5

--EXEC USP_UpdateScheduleTypeOfBadSchedule 'amortization_schedule_error_feed_20200830.csv', '202008310301191'

DROP TABLE IF EXISTS #TempUpdateSchedules 
CREATE TABLE #TempUpdateSchedules  
(  
	Skey DECIMAL(19,0), UniversalUniqueID VARCHAR(64)  , PlanUUID VARCHAR(64)  , ScheduleID DECIMAL(19,0)  , FileName VARCHAR(300)  
) 

INSERT INTO #TempUpdateSchedules  
SELECT --TOP (@BatchCount)  
    Skey,  
    UniversalUniqueID,  
    PlanUUID,  
    ScheduleID,  
    FileName + '_FileID_' + FileID  
FROM #ILPScheduleDetailsBAD WITH (NOLOCK)  
WHERE JobStatus = 0 AND FileName = 'amortization_schedule_error_feed_20200903.csv' AND FileID = '202009040301201'

BEGIN TRANSACTION  
	
	UPDATE ILPD  
	SET  
	JobStatus = 1  
	FROM #ILPScheduleDetailsBAD ILPD WITH (NOLOCK)  
	JOIN #TempUpdateSchedules TT ON (ILPD.Skey = TT.Skey) 

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

--SELECT ILPB.* 
--FROM #ILPScheduledetailsBad ILPB WITH (NOLOCK)
--JOIN #ILPScheduledetailsBad_DUMP ILPD WITH (NOLOCK) ON (ILPB.ScheduleID = ILPD.ScheduleIDOnILP)
--WHERE ILPD.JobStatus = 1

--SELECT A.* 
--FROM #ILPScheduledetailsBad A WITH (NOLOCK)
--JOIN #ILPScheduledetailsBad B WITH (NOLOCK) ON (A.ScheduleID = B.ScheduleID)
--WHERE A.JobStatus <> B.JobStatus AND A.JobStatus = 1