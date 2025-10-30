-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.57 WHERE acctId = 10268407
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.57, RunningMinimumDue = RunningMinimumDue - 23.57, 
	RemainingMinimumDue = RemainingMinimumDue - 23.57, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10268407

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.14, AmountOfTotalDue = AmountOfTotalDue - 0.14 WHERE acctId = 25937302

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31206432664, '2020-10-12 12:21:02.000', 51, 10268407, 115, '1', '0'),
	(31206432664, '2020-10-12 12:21:02.000', 51, 10268407, 200, '23.57', '0.00')

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31206432664, '2020-10-12 12:21:02.000', 52, 25937302, 115, '1', '0'),
	(31206432664, '2020-10-12 12:21:02.000', 52, 25937302, 115, '0.14', '0.00')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION