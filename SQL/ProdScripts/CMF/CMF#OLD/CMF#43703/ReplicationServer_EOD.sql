-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 42.95, AmountOfTotalDue = AmountOfTotalDue - 42.95, RunningMinimumDue = RunningMinimumDue - 42.95, 
	RemainingMinimumDue = RemainingMinimumDue - 42.95, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 2785613 AND BusinessDay = '2020-10-12 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.79, AmountOfTotalDue = AmountOfTotalDue - 17.79 WHERE CPSacctId = 2961483 AND BusinessDay = '2020-10-12 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION