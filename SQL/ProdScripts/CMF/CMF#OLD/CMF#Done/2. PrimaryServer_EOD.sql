-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE 
	CPSacctId = 2010472 AND BusinessDay = '2020-11-08 23:59:57'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION