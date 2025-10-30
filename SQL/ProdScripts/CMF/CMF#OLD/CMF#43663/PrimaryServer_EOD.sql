-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE top (1) AccountInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.12, AmountOfTotalDue = AmountOfTotalDue + 1.12, RunningMinimumDue = RunningMinimumDue + 1.12, 
	RemainingMinimumDue = RemainingMinimumDue + 1.12, DateOfOriginalPaymentDueDTD = '2020-10-31 23:59:57' WHERE BSacctId = 4735919 AND BusinessDay = '2020-10-11 23:59:57'

	UPDATE top (1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 33.88, AmountOfTotalDue = AmountOfTotalDue + 33.88 WHERE CPSacctId = 9912077 AND BusinessDay = '2020-10-11 23:59:57'


	UPDATE  top (1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.85, AmountOfTotalDue = AmountOfTotalDue - 8.85, RunningMinimumDue = RunningMinimumDue - 8.85, 
	RemainingMinimumDue = RemainingMinimumDue - 8.85, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9586213 AND BusinessDay = '2020-10-11 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION