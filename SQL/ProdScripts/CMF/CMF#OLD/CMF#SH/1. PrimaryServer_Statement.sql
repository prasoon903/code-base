-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE TOP(1) WILL BE 1 ROW EACH


	UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 4.53 WHERE acctId = 8171272 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 99.65, SBWithInstallmentDue = SBWithInstallmentDue + 58.07, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 58.07 WHERE acctId = 21938790 AND StatementID = 44219848
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 58.07 WHERE acctId = 21938790 AND StatementID = 44219848
		



	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.93, AmtOfPayXDLate = AmtOfPayXDLate - 22.93 WHERE 
	acctId = 9747038 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 22.93/*, SBWithInstallmentDue = SBWithInstallmentDue + 0.69, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 0.69*/ WHERE acctId = 24045196 AND StatementID = 44399362
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 22.93 WHERE acctId = 24045196 AND StatementID = 44399362

	

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION