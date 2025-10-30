-- TO BE RUN ON REPLICATION SERVER ONLY
---  1 row update each statement 
USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.06, AmountOfTotalDue = AmountOfTotalDue - 25.06, 
	RunningMinimumDue = RunningMinimumDue - 25.06, RemainingMinimumDue = RemainingMinimumDue - 25.06,
	 DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 4956807 AND BusinessDay = '2020-09-06 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.44, AmountOfTotalDue = AmountOfTotalDue - 10.44, 
	RunningMinimumDue = RunningMinimumDue - 10.44, RemainingMinimumDue = RemainingMinimumDue - 10.44,
	 DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 1403641 AND BusinessDay = '2020-09-06 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.21, AmountOfTotalDue = AmountOfTotalDue - 5.21 WHERE CPSacctId = 1416061 AND BusinessDay = '2020-09-06 23:59:57'

COMMIT TRANSACTION
--ROLLBACK TRANSACTION