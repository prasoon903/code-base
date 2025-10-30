-- STEP 1

USE CCGS_CoreIssue
GO

EXEC USP_UpdateScheduleTypeOfBadSchedule 'amortization_schedule_error_feed_20200827.csv', '202008280301211'
