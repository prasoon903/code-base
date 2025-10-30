-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 24.57, AmountOfTotalDue = AmountOfTotalDue + 24.57, RunningMinimumDue = RunningMinimumDue + 24.57, 
	RemainingMinimumDue = RemainingMinimumDue + 24.57 WHERE 
	BSacctId = 4505751 AND BusinessDay >= '2020-11-11 23:59:57'

	UPDATE PlanInfoForReport SET
	CurrentBalanceCO = CurrentBalanceCO - 0.71,
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71,
	AmountOfTotalDue = AmountOfTotalDue - 0.71,
	AmtOfPayCurrDue = AmtOfPayCurrDue - 0.71
	WHERE CPSacctId = 12766333  AND Businessday >= '2020-11-01 23:59:57.000' AND Businessday <= '2020-11-04 23:59:57.000'


	UPDATE PlanInfoForReport SET CycleDueDTD = 0 WHERE CPSacctId = 15668794  AND Businessday >= '2020-11-17 23:59:57.000'


	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 9.03, AmtOfPayXDLate = AmtOfPayXDLate - 9.03, RunningMinimumDue = RunningMinimumDue - 9.03, 
	RemainingMinimumDue = RemainingMinimumDue - 9.03, DaysDelinquent = 0, TotalDaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 4505751 AND BusinessDay >= '2020-10-31 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 9.03, AmtOfPayXDLate = AmtOfPayXDLate - 9.03 WHERE CPSacctId = 31526418 AND Businessday >= '2020-10-31 23:59:57.000'
	

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.18, AmountOfTotalDue = AmountOfTotalDue - 11.18, RunningMinimumDue = RunningMinimumDue - 11.18, 
	RemainingMinimumDue = RemainingMinimumDue - 11.18, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 9867427 AND BusinessDay >= '2020-11-17 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.52, AmountOfTotalDue = AmountOfTotalDue - 10.52 WHERE CPSacctId = 24632322 AND Businessday >= '2020-11-17 23:59:57.000'
	

COMMIT TRANSACTION
--ROLLBACK TRANSACTION


--SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
--daysdelinquent, AmountOfPayment60DLate, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
--DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
--FROM AccountInfoForReport A WITH (NOLOCK) 
--WHERE BSAcctid = 4505751  AND A.BusinessDay = '2020-11-11 23:59:57.000'
--order by A.businessday desc


--SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
--daysdelinquent, AmountOfPayment60DLate, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
--DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
--FROM AccountInfoForReport A WITH (NOLOCK) 
--WHERE BSAcctid = 1875442  AND A.BusinessDay >= '2020-10-31 23:59:57.000'
--order by A.businessday desc

--SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, CurrentBalanceCO, SRBWithInstallmentDue, SBWithInstallmentDue, * 
--FROM PlanInfoForReport WITH (NOLOCK) 
--WHERE CPSAcctID = 12766333 AND Businessday >= '2020-11-01 23:59:57.000' AND Businessday <= '2020-11-04 23:59:57.000'
--order by businessday desc