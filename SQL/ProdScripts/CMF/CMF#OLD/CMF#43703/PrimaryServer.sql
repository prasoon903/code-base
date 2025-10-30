-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 42.95 WHERE acctId = 2785613
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.95, RunningMinimumDue = RunningMinimumDue - 42.95, 
	RemainingMinimumDue = RemainingMinimumDue - 42.95, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 2785613

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.79, AmountOfTotalDue = AmountOfTotalDue - 17.79 WHERE acctId = 2961483

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31207074995, '2020-10-12 14:25:15.000', 51, 2785613, 115, '1', '0'),
	(31207074995, '2020-10-12 14:25:15.000', 51, 2785613, 200, '42.95', '0.00')

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2961483 AND ATID = 52 AND IdentityField = 1202696280
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31207074995, '2020-10-12 14:25:15.000', 52, 2961483, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION