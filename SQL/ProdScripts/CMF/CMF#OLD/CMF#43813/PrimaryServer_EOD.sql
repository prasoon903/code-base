-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfPayment60DLate = AmountOfPayment60DLate - 40, DateOfOriginalPaymentDueDTD = NULL,
	daysdelinquent = 0, TotalDaysDelinquent = 0, DateOfDelinquency = NULL WHERE BSacctId = 2045512 AND BusinessDay = '2020-10-14 23:59:57'
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION