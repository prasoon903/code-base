-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH statement 

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.06 WHERE acctId = 4956807
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.06, RunningMinimumDue = RunningMinimumDue - 25.06,
	 RemainingMinimumDue = RemainingMinimumDue - 25.06, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4956807

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30259628964, '2020-09-04 19:06:19.000', 51, 4956807, 115, '1', '0'),
	(30259628964, '2020-09-04 19:06:19.000', 51, 4956807, 200, '25.06', '0.00')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.44 WHERE acctId = 1403641
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.44, RunningMinimumDue = RunningMinimumDue - 10.44,
	 RemainingMinimumDue = RemainingMinimumDue - 10.44, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 1403641

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 5.21, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.21 WHERE acctId = 1416061

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30260149885, '2020-09-04 18:42:20.000', 51, 1403641, 115, '1', '0'),
	(30260149885, '2020-09-04 18:42:20.000', 51, 1403641, 200, '10.44', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 1416061 AND ATID = 52 AND IdentityField = 1054621927
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30260149885, '2020-09-04 18:42:20.000', 52, 1416061, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION