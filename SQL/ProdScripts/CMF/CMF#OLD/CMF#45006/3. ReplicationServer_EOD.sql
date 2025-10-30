-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 39.02, AmtOfPayXDLate = AmtOfPayXDLate - 39.02 WHERE 
	BSacctId = 11208697 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 1097.58, AmtOfPayCurrDue = AmtOfPayCurrDue - 1097.58, SBWithInstallmentDue = SBWithInstallmentDue - 1097.58, 
	SRBWithInstallmentDue = SRBWithInstallmentDue - 1097.58 WHERE 
	CPSacctId = 33148313 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 6.71, AmtOfPayXDLate = AmtOfPayXDLate - 6.71 WHERE 
	CPSacctId = 23544712 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.03, AmtOfPayXDLate = AmtOfPayXDLate - 8.06 WHERE 
	CPSacctId = 27151925 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 6.71 WHERE acctId = 23544712 AND StatementID = 44217231


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION