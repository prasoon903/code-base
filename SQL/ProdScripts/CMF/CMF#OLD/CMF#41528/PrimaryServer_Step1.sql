-- TO BE RUN ON PRIMARY SERVER ONLY

BEGIN TRANSACTION

	UPDATE ILPScheduleDetailsBAD_DUMP 
	SET 
		JOBStatus = 0, Counter = 0, ValidationMessage = NULL, parent02AID = NULL, AccountNumber = NULL, acctId = NULL, ScheduleIDONILP = NULL, ProcessingDate = NULL
	WHERE FileName = 'amortization_schedule_error_feed_20200821.csv' AND FileID = '202008220414371'

	-- 67993

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

/*
--VALIDATION

SELECT COUNT(1) 
FROM ILPScheduleDetailsBAD_DUMP ILPS WITH (NOLOCK)
WHERE FileName = 'amortization_schedule_error_feed_20200821.csv' AND FileID = '202008220414371'

*/