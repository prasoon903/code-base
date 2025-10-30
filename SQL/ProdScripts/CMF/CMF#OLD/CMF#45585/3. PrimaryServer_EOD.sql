-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE TOP(1) each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET
	CurrentBalanceCO = CurrentBalanceCO - 0.71,
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71
	WHERE BSacctId = 1875442  AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) AccountInfoForReport SET
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71
	WHERE BSacctId = 1875442  AND Businessday = '2020-11-29 23:59:57.000'

	UPDATE TOP(1) PlanInfoForReport SET
	AmtOfPayCurrDue = AmtOfPayCurrDue - 1.31
	WHERE CPSacctId = 12766333  AND Businessday = '2020-10-31 23:59:57.000'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.95, AmountOfTotalDue = AmountOfTotalDue - 18.95, RunningMinimumDue = RunningMinimumDue - 18.95, 
	RemainingMinimumDue = RemainingMinimumDue - 18.95, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 828675 AND BusinessDay = '2020-11-29 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.70, AmountOfTotalDue = AmountOfTotalDue - 17.70 WHERE CPSacctId = 841085 AND BusinessDay = '2020-11-29 23:59:57'
	

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.64, AmountOfTotalDue = AmountOfTotalDue - 18.64, RunningMinimumDue = RunningMinimumDue - 18.64, 
	RemainingMinimumDue = RemainingMinimumDue - 18.64 WHERE 
	BSacctId = 6079526 AND BusinessDay = '2020-11-29 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.71, AmountOfTotalDue = AmountOfTotalDue - 12.71 WHERE CPSacctId = 14731684 AND BusinessDay = '2020-11-29 23:59:57'


	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.05, AmountOfTotalDue = AmountOfTotalDue - 18.05, RunningMinimumDue = RunningMinimumDue - 18.05, 
	RemainingMinimumDue = RemainingMinimumDue - 18.05, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 10822607 AND BusinessDay = '2020-11-29 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.17, AmountOfTotalDue = AmountOfTotalDue - 14.17 WHERE CPSacctId = 27578354 AND BusinessDay = '2020-11-29 23:59:57'
	

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.47, AmountOfTotalDue = AmountOfTotalDue - 7.47, RunningMinimumDue = RunningMinimumDue - 7.47, 
	RemainingMinimumDue = RemainingMinimumDue - 7.47, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 9254534 AND BusinessDay = '2020-11-29 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.98, AmountOfTotalDue = AmountOfTotalDue - 0.98 WHERE CPSacctId = 22586692 AND BusinessDay = '2020-11-29 23:59:57'
	

	UPDATE TOP(1) AccountInfoForReport SET daysdelinquent = 0, TotalDaysDelinquent = 203, DateOfDelinquency = NULL WHERE 
	BSacctId = 1590918 AND BusinessDay = '2020-11-29 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmountOfPayment30DLate = AmountOfPayment30DLate + 0.29 WHERE CPSacctId = 6487953 AND Businessday = '2020-11-29 23:59:57.000'


	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 33 WHERE CPSacctId = 448797  AND Businessday = '2020-11-29 23:59:57.000' -- 436577



	UPDATE TOP(1) PlanInfoForReport SET AmountOfPayment60DLate = AmountOfPayment60DLate + 33.61, AmountOfPayment90DLate = AmountOfPayment90DLate - 33.61, 
	AmountOfPayment150DLate = AmountOfPayment150DLate + 29.07, AmountOfPayment180DLate = AmountOfPayment180DLate - 29.07 WHERE CPSacctId = 4447066  AND Businessday = '2020-11-29 23:59:57.000' -- 783069

	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 3, 
		AmtOfPayXDLate = AmtOfPayXDLate + 6, 
		AmountOfPayment30DLate = AmountOfPayment30DLate + 23, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 48.61, 
		AmountOfPayment90DLate = AmountOfPayment90DLate - 71.39, 
		AmountOfPayment120DLate = AmountOfPayment120DLate + 6.86, 
		AmountOfPayment150DLate = AmountOfPayment150DLate - 6.86 WHERE CPSacctId = 795479  AND Businessday = '2020-11-29 23:59:57.000' -- 783069



	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayXDLate, 
		AmtOfPayXDLate = AmountOfPayment30DLate, 
		AmountOfPayment30DLate = AmountOfPayment60DLate, 
		AmountOfPayment60DLate = AmountOfPayment90DLate, 
		AmountOfPayment90DLate = AmountOfPayment120DLate, 
		AmountOfPayment120DLate = AmountOfPayment150DLate, 
		AmountOfPayment150DLate = AmountOfPayment180DLate,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 5.72 WHERE CPSacctId = 831443  AND Businessday = '2020-11-29 23:59:57.000' -- 819033


	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, 
		AmtOfPayXDLate = AmtOfPayXDLate + 0.01, 
		AmountOfPayment30DLate = AmountOfPayment30DLate + 0, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 0.01,  
		AmountOfPayment150DLate = AmountOfPayment150DLate + 9.94,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 10.03 WHERE CPSacctId = 913911  AND Businessday = '2020-11-29 23:59:57.000' -- 901491



	UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 145, AmtOfPayCurrDue = AmtOfPayCurrDue - 145, CycleDueDTD = 0 WHERE CPSacctId = 1150680  AND Businessday = '2020-11-29 23:59:57.000' -- 1138260



	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 7.00, 
		AmtOfPayXDLate = AmtOfPayXDLate + 1, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 128, 
		AmountOfPayment60DLate = AmountOfPayment60DLate + 1, 
		AmountOfPayment90DLate = AmountOfPayment90DLate - 89,  
		AmountOfPayment150DLate = AmountOfPayment150DLate + 88.53,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 113.53 WHERE CPSacctId = 913911  AND Businessday = '2020-11-29 23:59:57.000' -- 901491



	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue + 0.06,   
		AmountOfPayment150DLate = AmountOfPayment150DLate - 0.06 WHERE CPSacctId = 2128398  AND Businessday = '2020-11-29 23:59:57.000' -- 2096678



	UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.05 WHERE CPSacctId = 8222497  AND Businessday = '2020-11-29 23:59:57.000' -- 2244607


	UPDATE TOP(1) PlanInfoForReport SET 
		AmountOfPayment150DLate = AmountOfPayment150DLate + 1.14,   
		AmountOfPayment180DLate = AmountOfPayment180DLate - 1.16 WHERE CPSacctId = 2848549  AND Businessday = '2020-11-29 23:59:57.000' -- 2700629



	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 7.00, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 3.00, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 7.00,  
		AmountOfPayment120DLate = AmountOfPayment120DLate - 114.00, 
		AmountOfPayment180DLate = AmountOfPayment180DLate - 60.00 WHERE CPSacctId = 5641639  AND Businessday = '2020-11-29 23:59:57.000' -- 4067489



	UPDATE TOP(1) PlanInfoForReport SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 2.00, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 1.00, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 2.00, 
		AmountOfPayment90DLate = AmountOfPayment90DLate + 1.00, 
		AmountOfPayment120DLate = AmountOfPayment120DLate - 39.00,  
		AmountOfPayment180DLate = AmountOfPayment180DLate - 41.00 WHERE CPSacctId = 6333782  AND Businessday = '2020-11-29 23:59:57.000' -- 4243632
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION


--SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
--daysdelinquent, AmountOfPayment60DLate, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
--DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
--FROM AccountInfoForReport A WITH (NOLOCK) 
--WHERE BSAcctid = 4505751  AND A.BusinessDay = '2020-11-11 23:59:57.000'
--order by A.businessday desc


--SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,SRBWithInstallmentDue, SBWithInstallmentDue, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
--daysdelinquent, AmountOfPayment60DLate, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
--DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
--FROM AccountInfoForReport A WITH (NOLOCK) 
--WHERE BSAcctid = 1875442  AND A.BusinessDay >= '2020-10-31 23:59:57.000'
--order by A.businessday desc

--SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, CurrentBalanceCO, SRBWithInstallmentDue, SBWithInstallmentDue, * 
--FROM PlanInfoForReport WITH (NOLOCK) 
--WHERE CPSAcctID = 12766333 AND BusinessDay >= '2020-10-31 23:59:57.000'
--order by businessday desc