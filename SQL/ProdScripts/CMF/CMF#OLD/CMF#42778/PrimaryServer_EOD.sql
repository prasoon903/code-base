-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row update each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.90, AmountOfTotalDue = AmountOfTotalDue - 11.90, 
	RunningMinimumDue = RunningMinimumDue - 11.90, RemainingMinimumDue = RemainingMinimumDue - 11.90,
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 4678410 AND BusinessDay = '2020-09-20 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.69,
	AmountOfTotalDue = AmountOfTotalDue - 9.69	 WHERE CPSacctId = 9712568 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 44.00, AmtOfPayXDLate = AmtOfPayXDLate - 44.00, 
	RunningMinimumDue = RunningMinimumDue - 44.00,DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 2623784 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 19.51,AmountOfTotalDue = AmountOfTotalDue - 19.51, 
	RunningMinimumDue = RunningMinimumDue - 19.51, RemainingMinimumDue = RemainingMinimumDue - 19.51, 
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 8300540 AND BusinessDay = '2020-09-20 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75,
	AmountOfTotalDue = AmountOfTotalDue - 10.75	 WHERE CPSacctId = 20026698 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue - 62.33, AmountOfTotalDue = AmountOfTotalDue - 63.97, AmtOfPayXDLate = AmtOfPayXDLate - 1.64, 
	DateOfOriginalPaymentDueDTD = NULL, DateOfDelinquency = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 9859231 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.79, AmountOfTotalDue = AmountOfTotalDue - 7.79, RunningMinimumDue = RunningMinimumDue - 7.79, 
	RemainingMinimumDue = RemainingMinimumDue - 7.79, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 8486795 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.72, AmountOfTotalDue = AmountOfTotalDue - 5.72, RunningMinimumDue = RunningMinimumDue - 5.72, 
	RemainingMinimumDue = RemainingMinimumDue - 5.72, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 6963163 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.42, AmountOfTotalDue = AmountOfTotalDue - 29.42, RunningMinimumDue = RunningMinimumDue - 29.42, 
	RemainingMinimumDue = RemainingMinimumDue - 29.42, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 4354882 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.08,AmountOfTotalDue = AmountOfTotalDue - 26.08, 
	RunningMinimumDue = RunningMinimumDue - 26.08, RemainingMinimumDue = RemainingMinimumDue - 26.08, 
	DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9850697 AND BusinessDay = '2020-09-20 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.61,
	AmountOfTotalDue = AmountOfTotalDue - 25.61	 WHERE CPSacctId = 24154855 AND BusinessDay = '2020-09-20 23:59:57'

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 464.48, AmountOfPayment90DLate = AmountOfPayment90DLate + 464.48 WHERE BSacctId = 1897844 AND BusinessDay = '2020-09-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfPayment90DLate = AmountOfPayment90DLate - 121.66, AmountOfTotalDue = AmountOfTotalDue - 121.66	 WHERE CPSacctId = 12022991 AND BusinessDay = '2020-09-20 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION