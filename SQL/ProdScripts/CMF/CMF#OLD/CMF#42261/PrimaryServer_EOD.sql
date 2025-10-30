-- TO BE RUN ON PRIMARY SERVER ONLY
---  1 row update each statement 
USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 40, AmountOfPayment60DLate = AmountOfPayment60DLate - 40,
	 RunningMinimumDue = RunningMinimumDue - 40, RemainingMinimumDue = RemainingMinimumDue - 40, DaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
	 TotalDaysDelinquent = 0 WHERE BSacctId = 4175721 AND BusinessDay = '2020-09-09 23:59:57'

COMMIT TRANSACTION
--ROLLBACK TRANSACTION