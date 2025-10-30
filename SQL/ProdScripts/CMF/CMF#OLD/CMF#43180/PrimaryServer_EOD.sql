-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 22.53, AmountOfTotalDue = AmountOfTotalDue - 22.53, RemainingMinimumDue = RemainingMinimumDue - 22.53,
	DateOfOriginalPaymentDueDTD = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0, DateOfDelinquency = NULL WHERE BSacctId = 2333040 AND BusinessDay = '2020-09-29 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION