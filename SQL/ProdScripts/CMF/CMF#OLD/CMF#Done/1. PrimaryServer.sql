-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE acctId = 2010472

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32131132786, '2020-11-07 05:38:18.000', 52, 2010472, 115, '1', '0'),
	(32131132786, '2020-11-07 05:38:18.000', 52, 2010472, 200, '24.82', '0.00')



	UPDATE TOP(1) SummaryHeader SET  AmountOfTotalDue = AmountOfTotalDue + 1901.8 WHERE acctId = 23782402 AND StatementID = 43534156



	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 20.16 WHERE acctId = 25457484 AND StatementID = 44454910
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE acctId = 25457484 AND StatementID = 44454910



	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 25.00 WHERE acctId = 589856 AND StatementID = 41491646



COMMIT TRANSACTION
--ROLLBACK TRANSACTION