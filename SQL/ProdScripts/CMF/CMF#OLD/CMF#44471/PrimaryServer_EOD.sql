-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.10, AmountOfTotalDue = AmountOfTotalDue - 14.10, RunningMinimumDue = RunningMinimumDue - 14.10, 
	RemainingMinimumDue = RemainingMinimumDue - 14.10, DateOfOriginalPaymentDueDTD = NULL WHERE 
	BSacctId = 8647713 AND BusinessDay = '2020-10-29 23:59:57'
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION