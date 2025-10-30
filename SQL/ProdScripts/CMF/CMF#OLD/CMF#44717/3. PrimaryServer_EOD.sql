-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0 WHERE BSacctId = 11208697 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 30.00, AmountOfTotalDue = AmountOfTotalDue - 30.00, RunningMinimumDue = RunningMinimumDue - 30.00, 
	RemainingMinimumDue = RemainingMinimumDue - 30.00, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 2210876 AND BusinessDay = '2020-11-03 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.01, AmountOfTotalDue = AmountOfTotalDue + 0.01 WHERE 
	CPSacctId = 2246746 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.91, AmountOfTotalDue = AmountOfTotalDue - 18.91 WHERE 
	CPSacctId = 873391 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 20.16, AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE 
	CPSacctId = 25457484 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 196.13, AmountOfTotalDue = AmountOfTotalDue - 196.13, RunningMinimumDue = RunningMinimumDue - 192.10, 
	RemainingMinimumDue = RemainingMinimumDue - 192.10, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 10656913 AND BusinessDay = '2020-11-03 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.03, AmtOfPayXDLate = AmtOfPayXDLate - 8.06 WHERE 
	CPSacctId = 27151925 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 17.73, AmountOfTotalDue = AmountOfTotalDue - 17.73 WHERE 
	CPSacctId = 1901088 AND BusinessDay = '2020-11-03 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 1058.49, AmountOfTotalDue = AmountOfTotalDue + 1058.49, 
	SBWithInstallmentDue = SBWithInstallmentDue + 1058.49, SRBWithInstallmentDue = SRBWithInstallmentDue + 1058.49 WHERE 
	CPSacctId = 33101004 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 6.71, AmountOfTotalDue = AmountOfTotalDue - 6.71 WHERE 
	CPSacctId = 23544712 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, AmountOfTotalDue = AmountOfTotalDue - 38.86, AmtOfPayXDLate = AmtOfPayXDLate - 13.86, RunningMinimumDue = RunningMinimumDue - 38.86, 
	RemainingMinimumDue = RemainingMinimumDue - 38.86, DateOfOriginalPaymentDueDTD = NULL  WHERE BSacctId = 9745940 AND BusinessDay = '2020-11-03 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, AmtOfPayXDLate = AmtOfPayXDLate - 5.54,
	AmountOfTotalDue = AmountOfTotalDue - 30.54, CycleDueDTD = 0 WHERE 
	CPSacctId = 23990098 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 45 WHERE BSacctId = 2537120 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 73 WHERE BSacctId = 4407747 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.76, AmountOfTotalDue = AmountOfTotalDue - 24.76 WHERE CPSacctId = 2408587 AND BusinessDay = '2020-11-03 23:59:57'


	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.34, AmountOfTotalDue = AmountOfTotalDue - 22.34 WHERE CPSacctId = 606491 AND BusinessDay = '2020-11-03 23:59:57'


	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION