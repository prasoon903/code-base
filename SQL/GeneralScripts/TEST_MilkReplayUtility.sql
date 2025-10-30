--1. USP_ValidateRetailReplaySchedules
--2. USP_UpdateScheduleTypeOfBadSchedule


--DROP TABLE ILPScheduleDetailsBAD
--DROP TABLE RetailSchedulesCorrected

SELECT
0 AS ErrorFlag,
COUNT(1) AS RecordErrorCount,
JobStatus,
ValidationMessage
FROM ILPScheduleDetailsBAD_Archive WITH (NOLOCK)
--WHERE FileName = '111' AND FileID = '000'
GROUP BY JobStatus, ValidationMessage

SELECT SHCC.DisputesAmtNS, SHCC.DisputeAmtNSCC1,SHCC.SRBWithInstallmentDue,statementdate,* FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 5039 AND SH.acctId = 5099


DECLARE @StartDate VARCHAR(200) = '2020-01-01 23:59:57.000'

--USP_ValidateRetailReplaySchedules 'Process1', '111'

--SELECT TRY_CONVERT(DATETIME,STUFF(STUFF(STUFF(LTRIM(RTRIM(@StartDate)),13,0,':'),11,0,':'),9,0,' '),112 )
SELECT TRY_CONVERT(DATE,(LTRIM(RTRIM(@StartDate))))
SELECT TRY_CONVERT(DATETIME,(LTRIM(RTRIM(@StartDate))))
SELECT TRY_CONVERT(TIME,(LTRIM(RTRIM(@StartDate))))


--SELECT CONVERT(datetime, 
--               SWITCHOFFSET(CONVERT(datetimeoffset, 
--                                    @StartDate), 
--                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
--       AS ColumnInLocalTime

--UPDATE PARASHAR_CB_CI..ILPScheduleDetailsBAD 
--SET JobStatus = 2, CorrectionDate = GETDATE() 
--WHERE Skey IN (6,7,8,9)

--EXEC USP_RetailMoveCorrectSchedules 1,NULL,0,NULL,0

SELECT * FROM Institutions WITH (NOLOCK) WHERE SysOrgID = 51

EXEC USP_RetailMoveCorrectSchedules 0, 'amortization_schedule_error_feed_20200107.csv', NULL, NULL, 0

SELECT * FROM TEMP_PlanToMove

SELECT 
	Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, 
	Schedule_ID, Institution_ID, Product_ID, Error, [Error_Message], Field_Path, AccountNumber
FROM ILPScheduleDetailsBAD_Archive WITH (NOLOCK)
WHERE FileName = 'amortization_schedule_error_feed_20210419_1.csv'
AND FileID = '202105041944121'
AND JobStatus = 10

SELECT  Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, Product_ID, Error, [Error_Message], Field_Path, AccountNumber 
FROM PP_CI..ILPScheduleDetailsBAD_Archive WITH (NOLOCK)
WHERE FileName = 'amortization_schedule_error_feed_20210419_1.csv'AND FileID = '202105041950041'AND JobStatus = 10

SELECT  FileName, FileID, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, Product_ID, 
AccountNumber, LEN(AccountNumber) , ExceptionFile
--REPLACE(LTRIM(RTRIM(AccountNumber)), '\r', '') AccountNumber, LEN(REPLACE(LTRIM(RTRIM(AccountNumber)), '\r', ''))
--REPLACE(AccountNumber, '\r\n', '') AccountNumber 
--LEN(AccountNumber)
FROM PP_CI..ILPScheduleDetailsBAD_Archive WITH (NOLOCK) 
WHERE FileName = 'EXCP_TestFile_1_POD1.csv' AND FileID = '202109141047121' AND JobStatus = 10

SELECT LEN('1100001000000')

EXEC PP_CI..USP_ValidateRetailReplaySchedules 'EXCP_TestFile_1_POD1_1.csv', '202109141047121', 10000, 1, 1

SELECT AccountNumber, LEN(AccountNumber),* FROM ILPScheduleDetailsBAD_DUMP

SELECT  JobStatus, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, Product_ID, Error, [Error_Message], Field_Path, 
LTRIM(RTRIM(AccountNumber)) AccountNumber FROM PP_CI..ILPScheduleDetailsBAD_Archive WITH (NOLOCK) WHERE FileName = 'TestFile_6.csv' AND FileID = '202109141241171' AND JobStatus = 10

SELECT * 
FROM ILPScheduleDetailsBAD_Archive WITH (NOLOCK)
WHERE ExceptionFile = 'EXCP_TestFile_3_POD1.csv'


SELECT  Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, Schedule_ID, Institution_ID, 
Product_ID, Error, [Error_Message], Field_Path, LTRIM(RTRIM(AccountNumber)) AccountNumber 
FROM PP_CI..ILPScheduleDetailsBAD_Archive WITH (NOLOCK) WHERE 
FileName = 'amortization_schedule_error_feed_20210419_1.csv' AND FileID = '202105041950041' AND JobStatus = 10

SELECT * FROm ILPCorrection

SELECT  * FROM PP_CI..ILPScheduleDetailsBAD_Archive WITH (NOLOCK)

SELECT * FROM ILPScheduleDetailsBAD WITH (NOLOCK) WHERE PlanUUID = '00041535-3b87-4427-a9f5-c7f15f5844e4'

SELECT * FROM ILPScheduleDetailsBAD_DUMP WITH (NOLOCK)

SELECT * FROM ILPScheduleDetailsBAD_DUMP ILP WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = ILP.AccountNumber)

SELECT * FROM BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100001000000054 '

--UPDATE ILPScheduleDetailsBAD_DUMP SET JobStatus = 0

SELECT JobStatus, ValidationMessage, * FROM ILPScheduleDetailsBAD_Archive WITH (NOLOCK)

SELECT * FROM RetailSchedulesCorrected WITH (NOLOCK) WHERE PlanUUID = '45678191'

SELECT * FROM ILPScheduleDetailsBAD WITH (NOLOCK) where PlanUUID = '8641a1f1-df1b-4477-bacb-e095a8bcafeb'
SELECT skey,* FROM ILPScheduleDetailSummary WITH (NOLOCK) where ScheduleType = 1

select parent02AID, PlanID, ActivityOrder, LastTermDate, PaidOffDate, ScheduleType, FileDueToError
from PP_CI..ILPScheduleDetailSummary with ( nolock )
where
((PARASHAR_CB_CI..ILPScheduleDetailSummary.parent02AID = 5007) AND (PARASHAR_CB_CI..ILPScheduleDetailSummary.PlanID = 5024))
order by PARASHAR_CB_CI..ILPScheduleDetailSummary.ActivityOrder desc


SELECT skey,JobStatus, ScheduleType,* FROM ILPScheduleDetailSummary WITH (NOLOCK) 

SELECT skey,JobStatus,* FROM ILPScheduleDetailSummary WITH (NOLOCK) where PlanUUID = 'a4474afa-784f-404e-8667-1d8875e7e3bd'

SELECT * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60

--EXEC USP_RetailMoveCorrectSchedules 0,NULL,NULL,'68565e95-ca87-4da4-9925-ddcd96f352de',0

--EXEC USP_RetailMoveCorrectSchedules 1,NULL,NULL,NULL,0

--UPDATE ILPScheduleDetailSummary SET JobStatus = 0 WHERE Skey IN (25025,25026,25027,25028,25029)

--UPDATE ILPScheduleDetailsBAD SET JobStatus = 0 WHERE Skey IN (5,6,7)

--UPDATE ILPScheduleDetailSummary SET ScheduleType = 0, CorrectionDate = Null, FileDueToError = Null WHERE PlanUUID = '68565e95-ca87-4da4-9925-ddcd96f352de'
--UPDATE ILPScheduleDetailSummary SET ScheduleType = 1 WHERE PlanUUID = '68565e95-ca87-4da4-9925-ddcd96f352de'


SELECT * FROM ILPScheduleDetailsBAD WITH (NOLOCK)

SELECT Report_Date, TRY_CONVERT(DATETIME, Report_Date), Business_Date,
		TRY_CONVERT(DATE,Business_Date), Batch_Timestamp, TRY_CONVERT(TIME,(Batch_Timestamp)), Account_UUID, Plan_UUID, Schedule_ID,
		ISNUMERIC(Schedule_ID), Institution_ID, ISNUMERIC(Institution_ID), Product_ID, ISNUMERIC(Product_ID), Error
FROM ILPScheduleDetailsBAD_DUMP TT

SELECT LEN(AccountNumber) LengthOfAC, *
FROM ILPScheduleDetailsBAD_DUMP TT


SELECT * FROM ARSystemAccounts WITH (nolock) 

SELECT * FROM Org_Balances WITH (nolock)

SELECT CAST(CONVERT(VARCHAR, ProcDayEnd, 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME) AS CurrentTime, AR.* 
FROM ARSystemAccounts AR WITH (nolock) 
JOIN Org_Balances OB WITH (NOLOCK) ON (AR.acctId = OB.ARSystemAcctId)
WHERE OB.acctId = 6969

SELECT CAST(CONVERT(VARCHAR, GETDATE(), 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)

SELECT * FROM Institutions WITH (NOLOCK)


DECLARE @InstitutionID		INT = 6969,
		@CurrentTime		DATETIME

SELECT TOP 1 @InstitutionID =  InstitutionID FROM Institutions WITH (NOLOCK)

SELECT @CurrentTime = CAST(CONVERT(VARCHAR, ProcDayEnd, 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)
FROM ARSystemAccounts AR WITH (NOLOCK) 
JOIN Org_Balances OB WITH (NOLOCK) ON (AR.acctId = OB.ARSystemAcctId)
WHERE OB.acctId = @InstitutionID

--SELECT @CurrentTime

DECLARE		@report_date DATETIME = @CurrentTime,
			@business_date DATE = CAST(CONVERT(VARCHAR, @CurrentTime, 23) AS DATE),
			@batch_timestamp TIME = CAST(CONVERT(VARCHAR, @CurrentTime, 14) AS TIME),
			@error VARCHAR(200) = 'CRS_COMPUTATION_ERROR',
			@error_message VARCHAR(200) = 'scheduleId=3 at monthNumber=1 has MDR output that is negative',
			@field_path VARCHAR(200) = 'schedule at month {1}'

SELECT @report_date AS Report_Date, @business_date AS business_date, @batch_timestamp AS batch_timestamp, 
bp.UniversalUniqueID AS account_uuid, ILPS.PlanUUID AS plan_uuid, ILPS.ActivityOrder AS schedule_id, bp.InstitutionID AS institution_id, 
bp.parent02AID AS Product_ID, @error AS error, @error_message AS [error_message], @field_path AS [field_path], LTRIM(RTRIM(BP.AccountNumber)) AccountNumber
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON (ILPS.parent02AID = bp.acctId)
WHERE ILPS.Activity = 1 
--AND BP.acctId = 14551525
--UPDATE ILPScheduleDetailsBAD_DUMP SET JobStatus  = 0

--TRUNCATE TABLE ILPScheduleDetailsBAD 
--TRUNCATE TABLE ILPScheduleDetailsBAD_DUMP 
--TRUNCATE TABLE ILPScheduleDetailsBAD_Archive 
--TRUNCATE TABLE RetailSchedulesCorrected 


AND BP.AccountNumber IN ('1100001000001581','1100001000001599','1100001000001607','1100001000001615','1100001000001623')


SELECT 
	TT.JobStatus, BP.MergeInProcessPH, CASE WHEN BP.MergeInProcessPH IN (4, 14) THEN 7 ELSE 0 END	,
	TT.AccountNumber, BP.AccountNumber,
	TT.parent02AID, BP.acctId,
	ValidationMessage, CASE WHEN BP.MergeInProcessPH IN (4, 14) THEN 'Account already merged' ELSE NULL END
FROM ILPScheduleDetailsBAD_DUMP TT
LEFT OUTER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = TT.Account_UUID)
WHERE TT.JobStatus = 0


SELECT BP.AccountNumber, TT.AccountNumber, *
FROM ##TempUpdateSchedules TT
LEFT OUTER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = TT.AccountNumber)
WHERE TT.JobStatus = 0

SELECT AccountNumber, * FROM BSegment_Primary WHERE AccountNumber = '1100001000001581   '
SELECT AccountNumber, * FROM BSegment_Primary WHERE AccountNumber = '1100001000001581   '