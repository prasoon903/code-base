-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

EXEC dbo.USP_UpdateScheduleTypeOfBadSchedule 'amortization_schedule_error_feed_20200820.csv', '202008210331181'

-- NOW RUN STEP 2 THEN BELOW STEP

EXEC dbo.USP_UpdateScheduleTypeOfBadSchedule 'amortization_schedule_error_feed_20200821.csv', '202008220414371'