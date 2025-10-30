-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.57, AmountOfTotalDue = AmountOfTotalDue - 23.57, RunningMinimumDue = RunningMinimumDue - 23.57, 
	RemainingMinimumDue = RemainingMinimumDue - 23.57, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 10268407 AND BusinessDay = '2020-10-13 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.14, AmountOfTotalDue = AmountOfTotalDue - 0.14 WHERE CPSacctId = 25937302 AND BusinessDay = '2020-10-13 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION