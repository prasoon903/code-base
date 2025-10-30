-- TO BE RUN ON PRIMARY SERVER ONLY
---  1 row update each statement 
USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.38, AmountOfTotalDue = AmountOfTotalDue - 2.38, 
	RunningMinimumDue = RunningMinimumDue - 2.38, RemainingMinimumDue = RemainingMinimumDue - 2.38,
	 DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 373547 AND BusinessDay = '2020-09-03 23:59:57'

COMMIT TRANSACTION
--ROLLBACK TRANSACTION