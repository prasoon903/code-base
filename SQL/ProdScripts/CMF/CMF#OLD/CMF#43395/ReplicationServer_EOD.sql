-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18, AmountOfTotalDue = AmountOfTotalDue + 0.66, 
	AmtOfPayXDLate = AmtOfPayXDLate + 0.48, RemainingMinimumDue = RemainingMinimumDue + 0.66, RunningMinimumDue = RunningMinimumDue + 0.66, 
	DateOfDelinquency = '2020-09-30 23:59:57.000', DaysDelinquent = 5 WHERE BSacctId = 1589586 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.81, AmountOfTotalDue = AmountOfTotalDue - 1.81, RunningMinimumDue = RunningMinimumDue - 19.26, 
	RemainingMinimumDue = RemainingMinimumDue - 19.26, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 10227654 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.27, AmountOfTotalDue = AmountOfTotalDue - 22.27, RunningMinimumDue = RunningMinimumDue - 22.27, 
	RemainingMinimumDue = RemainingMinimumDue - 22.27, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 10227654 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.98, AmountOfTotalDue = AmountOfTotalDue - 13.98 WHERE CPSacctId = 5210820 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 73 WHERE BSacctId = 10227654 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.49, AmountOfTotalDue = AmountOfTotalDue - 6.49, RunningMinimumDue = RunningMinimumDue - 6.49, 
	RemainingMinimumDue = RemainingMinimumDue - 6.49, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9867824 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.91, AmountOfTotalDue = AmountOfTotalDue - 23.91, RunningMinimumDue = RunningMinimumDue - 23.91, 
	RemainingMinimumDue = RemainingMinimumDue - 23.91, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 10662351 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.93, AmountOfTotalDue = AmountOfTotalDue - 9.93 WHERE CPSacctId = 27171363 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.86, AmountOfTotalDue = AmountOfTotalDue - 21.86, RunningMinimumDue = RunningMinimumDue - 21.86, 
	RemainingMinimumDue = RemainingMinimumDue - 21.86, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9437860 AND BusinessDay = '2020-10-04 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.03, AmountOfTotalDue = AmountOfTotalDue - 12.03 WHERE CPSacctId = 27171363 AND BusinessDay = '2020-10-04 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION