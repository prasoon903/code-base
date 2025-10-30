-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.95, AmountOfTotalDue = AmountOfTotalDue - 25.95, RunningMinimumDue = RunningMinimumDue - 25.95, 
	RemainingMinimumDue = RemainingMinimumDue - 25.95, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 9257169 AND BusinessDay = '2020-10-28 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.63, AmountOfTotalDue = AmountOfTotalDue - 21.63 WHERE 
	CPSacctId = 22589327 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 32.84, AmountOfTotalDue = AmountOfTotalDue + 32.84 WHERE 
	BSacctId = 748318 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 50.01, AmountOfTotalDue = AmountOfTotalDue - 50.01, RunningMinimumDue = RunningMinimumDue - 50.01, 
	RemainingMinimumDue = RemainingMinimumDue - 50.01, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 2872118 AND BusinessDay = '2020-10-28 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 27.72, AmountOfTotalDue = AmountOfTotalDue - 27.72 WHERE 
	CPSacctId = 3070268 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.63, AmountOfTotalDue = AmountOfTotalDue - 11.63, RunningMinimumDue = RunningMinimumDue - 11.63, 
	RemainingMinimumDue = RemainingMinimumDue - 11.63 WHERE 
	BSacctId = 7006183 AND BusinessDay = '2020-10-28 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.70, AmountOfTotalDue = AmountOfTotalDue - 10.70 WHERE 
	CPSacctId = 16952341 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.83, AmountOfTotalDue = AmountOfTotalDue - 24.83 WHERE 
	CPSacctId = 2588287 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.72, AmountOfTotalDue = AmountOfTotalDue - 11.72, RunningMinimumDue = RunningMinimumDue - 11.72, 
	RemainingMinimumDue = RemainingMinimumDue - 11.72, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 10817065 AND BusinessDay = '2020-10-28 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.27, AmountOfTotalDue = AmountOfTotalDue - 10.27 WHERE 
	CPSacctId = 27504077 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.33, AmountOfTotalDue = AmountOfTotalDue - 18.33 WHERE 
	CPSacctId = 8169843 AND BusinessDay = '2020-10-28 23:59:57'


	UPDATE AccountInfoForReport SET DaysDelinquent = 0 WHERE BSacctId = 1212020 AND BusinessDay >= '2020-10-22 23:59:57.000'
	-- 7 rows
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION