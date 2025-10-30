-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.65, AmountOfTotalDue = AmountOfTotalDue - 23.65, RunningMinimumDue = RunningMinimumDue - 23.65, 
	RemainingMinimumDue = RemainingMinimumDue - 23.65, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 5533964 AND BusinessDay = '2020-10-05 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.10, AmountOfTotalDue = AmountOfTotalDue - 14.10 WHERE CPSacctId = 12634122 AND BusinessDay = '2020-10-05 23:59:57'


	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.16, AmountOfTotalDue = AmountOfTotalDue - 24.16 WHERE CPSacctId = 2846560 AND BusinessDay = '2020-10-05 23:59:57'


	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.30, AmountOfTotalDue = AmountOfTotalDue - 1.30 WHERE CPSacctId = 22565116 AND BusinessDay = '2020-10-05 23:59:57'


	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.81, AmountOfTotalDue = AmountOfTotalDue - 20.81, RunningMinimumDue = RunningMinimumDue - 20.81, 
	RemainingMinimumDue = RemainingMinimumDue - 20.81 WHERE BSacctId = 10460903 AND BusinessDay = '2020-10-05 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.43, AmountOfTotalDue = AmountOfTotalDue - 11.43 WHERE CPSacctId = 26423898 AND BusinessDay = '2020-10-05 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 33.83, AmountOfTotalDue = AmountOfTotalDue - 33.83, RunningMinimumDue = RunningMinimumDue - 33.83, 
	RemainingMinimumDue = RemainingMinimumDue - 33.83, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9311055 AND BusinessDay = '2020-10-05 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION