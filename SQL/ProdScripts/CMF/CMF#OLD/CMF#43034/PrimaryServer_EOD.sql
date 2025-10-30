-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.52, AmountOfTotalDue = AmountOfTotalDue - 10.52, 
	RunningMinimumDue = RunningMinimumDue - 10.52, RemainingMinimumDue = RemainingMinimumDue - 10.52,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 5574257 AND BusinessDay = '2020-09-24 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.22,
	AmountOfTotalDue = AmountOfTotalDue - 9.22	 WHERE CPSacctId = 12674415 AND BusinessDay = '2020-09-24 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.31,AmountOfTotalDue = AmountOfTotalDue - 18.31, 
	RunningMinimumDue = RunningMinimumDue - 18.31, RemainingMinimumDue = RemainingMinimumDue - 18.31, 
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 8939474 AND BusinessDay = '2020-09-24 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.04,
	AmountOfTotalDue = AmountOfTotalDue - 13.04	 WHERE CPSacctId = 21647632 AND BusinessDay = '2020-09-24 23:59:57'

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.98,AmountOfTotalDue = AmountOfTotalDue - 9.98, 
	RunningMinimumDue = RunningMinimumDue - 9.98, RemainingMinimumDue = RemainingMinimumDue - 9.98 WHERE BSacctId = 8451232 AND BusinessDay = '2020-09-24 23:59:57'
	UPDATE PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.99,	AmountOfTotalDue = AmountOfTotalDue - 2.99	 WHERE CPSacctId = 28645662 AND BusinessDay = '2020-09-24 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.80, AmountOfTotalDue = AmountOfTotalDue - 12.80	WHERE 
	CPSacctId = 645535 AND BusinessDay = '2020-09-24 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.81, AmountOfTotalDue = AmountOfTotalDue - 24.81	WHERE 
	CPSacctId = 746729 AND BusinessDay = '2020-09-24 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION