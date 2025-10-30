-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.69, AmountOfTotalDue = AmountOfTotalDue - 7.69, RunningMinimumDue = RunningMinimumDue - 7.69, 
	RemainingMinimumDue = RemainingMinimumDue - 7.69, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 1737878 AND BusinessDay = '2020-10-06 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.59, AmountOfTotalDue = AmountOfTotalDue - 1.59 WHERE CPSacctId = 1754338 AND BusinessDay = '2020-10-06 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 40.56, AmountOfTotalDue = AmountOfTotalDue - 40.56, RunningMinimumDue = RunningMinimumDue - 40.56, 
	RemainingMinimumDue = RemainingMinimumDue - 40.56, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 2238870 AND BusinessDay = '2020-10-06 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.08, AmountOfTotalDue = AmountOfTotalDue - 26.08 WHERE CPSacctId = 2277660 AND BusinessDay = '2020-10-06 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.54, AmountOfTotalDue = AmountOfTotalDue - 22.54, RunningMinimumDue = RunningMinimumDue - 22.54, 
	RemainingMinimumDue = RemainingMinimumDue - 22.54, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 1019530 AND BusinessDay = '2020-10-06 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.20, AmountOfTotalDue = AmountOfTotalDue - 13.20 WHERE CPSacctId = 1031950 AND BusinessDay = '2020-10-06 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION