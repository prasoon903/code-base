-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue + 5.12, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.12 WHERE 
	CPSacctId = 417861 AND BusinessDay = '2020-10-19 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.08, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.08 WHERE 
	CPSacctId = 1938186 AND BusinessDay = '2020-10-19 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 24.27, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.27 WHERE 
	CPSacctId = 4320769 AND BusinessDay = '2020-10-19 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.83, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.83 WHERE 
	CPSacctId = 362315 AND BusinessDay = '2020-10-19 23:59:57'
	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION