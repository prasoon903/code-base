BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE RetailSchedulesCorrected SET CorrectionDate = NULL WHERE Skey IN (10, 12)

UPDATE ILPScheduleDetailSummary SET CorrectionDate = NULL, ScheduleType = 1 
WHERE PlanUUID IN ('Day1nba3-bb9b-45ff-9eh9-1b7f8n60Sc6')

INSERT INTO ILPScheduleDetailsBAD
(
	UniversalUniqueID
	, PlanUUID
	, ScheduleID
	, ReportDate
	, BusinessDate
	, BatchTimestamp
	, InstitutionID
	, ProductID
	, ErrorReason
	, FileName
	, FileID
	, parent02AID
	, AccountNumber
	, acctId
	, JobStatus
	, ProcessingDate
	, CorrectionDate
	, Counter
)
SELECT 
	UniversalUniqueID
	, PlanUUID
	, ScheduleID
	, ReportDate
	, BusinessDate
	, BatchTimestamp
	, InstitutionID
	, ProductID
	, ErrorReason
	, FileName
	, FileID
	, parent02AID
	, AccountNumber
	, acctId
	, JobStatus
	, ProcessingDate
	, CorrectionDate
	, Counter
FROM RetailSchedulesCorrected WITH (NOLOCK) WHERE Skey IN (10, 12)


DELETE FROM RetailSchedulesCorrected WHERE Skey IN (10, 12)