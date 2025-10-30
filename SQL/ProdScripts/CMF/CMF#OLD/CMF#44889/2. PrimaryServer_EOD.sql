-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	--UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE 
	--CPSacctId = 2010472 AND BusinessDay = '2020-11-10 23:59:57'

	--UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.84, AmountOfTotalDue = AmountOfTotalDue - 8.84, RunningMinimumDue = RunningMinimumDue - 25.31, 
	--RemainingMinimumDue = RemainingMinimumDue - 25.31, DateOfOriginalPaymentDueDTD = NULL WHERE 
	--BSacctId = 9855752 AND BusinessDay = '2020-11-10 23:59:57'

	--UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 20.16, AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE 
	--CPSacctId = 25457484 AND BusinessDay = '2020-10-31 23:59:57'

	--UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 25 WHERE 
	--CPSacctId = 589856 AND BusinessDay = '2020-10-31 23:59:57'

	UPDATE TOP(1) AccountInfoForReport SET DateOfDelinquency = NULL, DaysDelinquent = 0 WHERE 
	BSacctId = 9855752 AND BusinessDay = '2020-11-10 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION


--SELECT CycleDueDTD, AmtOfPayXDLate, AmountOfTotalDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 23782402 AND BusinessDay = '2020-10-31 23:59:57'


--SELECT CycleDueDTD, AmtOfPayXDLate, AmountOfTotalDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 25457484 AND BusinessDay = '2020-10-31 23:59:57' 


--SELECT CycleDueDTD, AmtOfPayXDLate, AmountOfTotalDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 589856 AND BusinessDay = '2020-10-31 23:59:57' 