-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE TOP(1) each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 4.03, AmtOfPayCurrDue = AmtOfPayCurrDue - 196.13 WHERE 
	BSacctId = 10656913 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue + 39.02, AmtOfPayXDLate = AmtOfPayXDLate + 39.02 WHERE 
	BSacctId = 11208697 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1097.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 1097.58, SBWithInstallmentDue = SBWithInstallmentDue + 1097.58, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 1097.58 WHERE 
	CPSacctId = 33148313 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue + 6.71, AmtOfPayXDLate = AmtOfPayXDLate + 6.71 WHERE 
	CPSacctId = 23544712 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 4.03, AmtOfPayXDLate = AmtOfPayXDLate + 8.06 WHERE 
	CPSacctId = 27151925 AND Businessday = '2020-10-31 23:59:57.000'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT CycleDueDTD, SystemStatus, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM AccountInfoForReport WITH (NOLOCK)
--WHERE BSacctId = 11208697 AND BusinessDay = '2020-10-31 23:59:57'

--SELECT CycleDueDTD, CurrentBalance, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 27151925 AND BusinessDay = '2020-10-31 23:59:57'



--SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
--daysdelinquent, AmountOfPayment60DLate, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
--DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
--FROM AccountInfoForReport A WITH (NOLOCK) 
--WHERE BSAcctid = 10656913  AND A.BusinessDay = '2020-10-31 23:59:57.000'
--order by A.businessday desc