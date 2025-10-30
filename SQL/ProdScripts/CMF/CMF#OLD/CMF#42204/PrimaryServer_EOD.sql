-- TO BE RUN ON PRIMARY SERVER ONLY
---  1 row update each statement 
USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 33.75, AmountOfTotalDue = AmountOfTotalDue - 33.75, 
	RunningMinimumDue = RunningMinimumDue - 33.75, RemainingMinimumDue = RemainingMinimumDue - 33.75,
	 DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 974882 AND BusinessDay = '2020-09-08 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.84, AmountOfTotalDue = AmountOfTotalDue - 24.84 WHERE CPSacctId = 987302 AND BusinessDay = '2020-09-08 23:59:57'

COMMIT TRANSACTION
--ROLLBACK TRANSACTION