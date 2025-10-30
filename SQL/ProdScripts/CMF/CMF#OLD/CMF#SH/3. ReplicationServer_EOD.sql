-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, AmtOfPayXDLate = AmtOfPayXDLate - 33.68, 
	AmountOfTotalDue = AmountOfTotalDue - 22.93 WHERE 
	BSacctId = 9747038 AND Businessday = '2020-10-31 23:59:57.000'

	--UPDATE PlanInfoForReport SET SBWithInstallmentDue = SBWithInstallmentDue + 0.69, SRBWithInstallmentDue = SRBWithInstallmentDue + 0.69 WHERE 
	--CPSacctId = 24045196 AND Businessday = '2020-10-31 23:59:57.000'


	UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 4.53 WHERE acctId = 8171272 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 58.07 WHERE acctId = 21938790 AND StatementID = 44219848
		



	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.93, AmtOfPayXDLate = AmtOfPayXDLate - 22.93 WHERE 
	acctId = 9747038 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 22.93 WHERE acctId = 24045196 AND StatementID = 44399362


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION