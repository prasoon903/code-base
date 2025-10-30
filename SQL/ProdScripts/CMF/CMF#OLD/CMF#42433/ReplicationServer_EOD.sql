-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET RemainingMinimumDue = RemainingMinimumDue + 40 WHERE BSacctId = 1380572 AND BusinessDay >= '2020-09-09 23:59:57'
	-- 5 rows

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.76, AmountOfTotalDue = AmountOfTotalDue - 13.76, 
	RunningMinimumDue = RunningMinimumDue - 43.29, RemainingMinimumDue = RemainingMinimumDue - 43.29,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 1380572 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.95, AmountOfTotalDue = AmountOfTotalDue - 22.95, 
	RunningMinimumDue = RunningMinimumDue - 22.95, RemainingMinimumDue = RemainingMinimumDue - 22.95,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 8366629 AND BusinessDay = '2020-09-13 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.18,
	AmountOfTotalDue = AmountOfTotalDue - 10.18	 WHERE CPSacctId = 20092787 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.95, AmountOfTotalDue = AmountOfTotalDue - 22.95, 
	RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9862748 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 3.04, AmountOfTotalDue = AmountOfTotalDue - 3.04, 
	RunningMinimumDue = RunningMinimumDue - 32.68, RemainingMinimumDue = RemainingMinimumDue - 32.68,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 8415190 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.69, AmountOfTotalDue = AmountOfTotalDue - 14.69, 
	RunningMinimumDue = RunningMinimumDue - 14.69, RemainingMinimumDue = RemainingMinimumDue - 14.69,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 7010916 AND BusinessDay = '2020-09-13 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.98,
	AmountOfTotalDue = AmountOfTotalDue - 0.98	 WHERE CPSacctId = 16961074 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.48, AmountOfTotalDue = AmountOfTotalDue - 17.48, 
	RunningMinimumDue = RunningMinimumDue - 17.48, RemainingMinimumDue = RemainingMinimumDue - 17.48,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 1417430 AND BusinessDay = '2020-09-13 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.10,
	AmountOfTotalDue = AmountOfTotalDue - 17.10	 WHERE CPSacctId = 1429850 AND BusinessDay = '2020-09-13 23:59:57'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.53, AmountOfTotalDue = AmountOfTotalDue - 5.53, 
	RunningMinimumDue = RunningMinimumDue - 5.53, RemainingMinimumDue = RemainingMinimumDue - 5.53,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 4956766 AND BusinessDay = '2020-09-13 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION