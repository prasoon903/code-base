-- STEP 3

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION   
  
      INSERT INTO ILPScheduleDetailsBAD  
      (  
		UniversalUniqueID , PlanUUID	, ScheduleID, ReportDate, BusinessDate, BatchTimestamp, InstitutionID, ProductID, ErrorReason  
		, FileName, FileID, parent02AID, AccountNumber, acctId, JobStatus , ProcessingDate, Counter, ErrorMessage, FieldPath  
      )  
      SELECT 
		Account_UUID , Plan_UUID, ScheduleIDOnILP, CAST(Report_Date AS DATETIME), CAST(Business_Date AS DATE), CAST(Batch_Timestamp AS TIME), Institution_ID, Product_ID, Error  
		, FileName, FileID, parent02AID, AccountNumber, acctId, 0, ProcessingDate, Counter, [Error_Message], Field_Path  
      FROM ILPScheduleDetailsBAD_DUMP WITH (NOLOCK)  
      WHERE FileName = 'amortization_schedule_error_feed_20200905.csv' AND FileID = '202009060301191' AND JobStatus = 1  
  
      INSERT INTO ILPScheduleDetailsBAD_Archive  
      (  
		Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, Product_ID, Error, FileName  
		, FileID, parent02AID, AccountNumber, acctId, ScheduleIDOnILP, JobStatus, ProcessingDate, CorrectionDate, ValidationMessage, [Error_Message], Field_Path  
      )  
      SELECT  
		ILP.Report_Date, ILP.Business_Date, ILP.Batch_Timestamp, ILP.Account_UUID, ILP.Plan_UUID, ILP.Schedule_ID, ILP.Institution_ID, ILP.Product_ID, ILP.Error, ILP.FileName  
		, ILP.FileID, ILP.parent02AID, ILP.AccountNumber, ILP.acctId, ILP.ScheduleIDOnILP, ILP.JobStatus, ILP.ProcessingDate, ILP.CorrectionDate, ILP.ValidationMessage, ILP.[Error_Message], ILP.Field_Path  
      FROM ILPScheduleDetailsBAD_DUMP ILP WITH (NOLOCK)   
  
      DELETE FROM ILPScheduleDetailsBAD_DUMP    
  
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION