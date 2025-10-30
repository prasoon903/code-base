-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE 
	CPSacctId = 2010472 AND BusinessDay = '2020-11-08 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 20.16, AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE 
	CPSacctId = 25457484 AND BusinessDay = '2020-10-31 23:59:57'

	UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 25 WHERE 
	CPSacctId = 589856 AND BusinessDay = '2020-10-31 23:59:57'

	UPDATE TOP(1) SummaryHeader SET  AmountOfTotalDue = AmountOfTotalDue + 1901.8 WHERE acctId = 23782402 AND StatementID = 43534156

	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE acctId = 25457484 AND StatementID = 44454910

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION