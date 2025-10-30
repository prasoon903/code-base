-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 23.97, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.97 WHERE 
	CPSacctId = 1857079 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 14.26, AmountOfTotalDue = AmountOfTotalDue - 14.26, RunningMinimumDue = RunningMinimumDue - 14.26, 
	RemainingMinimumDue = RemainingMinimumDue - 14.26 WHERE 
	BSacctId = 1730001 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.80, AmountOfTotalDue = AmountOfTotalDue - 13.80 WHERE 
	CPSacctId = 1746461 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.45, AmountOfTotalDue = AmountOfTotalDue - 8.45, RunningMinimumDue = RunningMinimumDue - 8.45, 
	RemainingMinimumDue = RemainingMinimumDue - 8.45, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 1376719 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.76, AmountOfTotalDue = AmountOfTotalDue - 29.76, RunningMinimumDue = RunningMinimumDue - 29.76, 
	RemainingMinimumDue = RemainingMinimumDue - 29.76, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 609301 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.20, AmountOfTotalDue = AmountOfTotalDue - 18.20 WHERE 
	CPSacctId = 621521 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.73, AmountOfTotalDue = AmountOfTotalDue - 26.73, RunningMinimumDue = RunningMinimumDue - 33.25, 
	RemainingMinimumDue = RemainingMinimumDue - 33.25, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 1298440 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue + 25, AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE 
	CPSacctId = 760728 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.46, AmountOfTotalDue = AmountOfTotalDue - 23.46, RunningMinimumDue = RunningMinimumDue - 23.46, 
	RemainingMinimumDue = RemainingMinimumDue - 23.46, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 9856510 AND BusinessDay = '2020-10-26 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 15.75, AmountOfTotalDue = AmountOfTotalDue - 15.75 WHERE 
	CPSacctId = 24160668 AND BusinessDay = '2020-10-26 23:59:57'
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION