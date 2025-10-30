-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.65 WHERE acctId = 5533964
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.65, RunningMinimumDue = RunningMinimumDue - 23.65, 
	RemainingMinimumDue = RemainingMinimumDue - 23.65, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 5533964

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.10, AmountOfTotalDue = AmountOfTotalDue - 14.10 WHERE acctId = 12634122

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094497554, '2020-10-05 16:28:00.000', 51, 5533964, 200, '23.65', '0.00'),
	(31094497554, '2020-10-05 16:28:00.000', 51, 5533964, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 12634122 AND ATID = 52 AND IdentityField = 1179654736
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094497554, '2020-10-05 16:28:00.000', 52, 12634122, 115, '1', '0')



	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.16, AmountOfTotalDue = AmountOfTotalDue - 24.16 WHERE acctId = 2846560

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31144361542, '2020-10-05 20:41:19.000', 52, 2846560, 200, '24.16', '0.00'),
	(31144361542, '2020-10-05 20:41:19.000', 52, 2846560, 115, '1', '0')



	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.30, AmountOfTotalDue = AmountOfTotalDue - 1.30 WHERE acctId = 22565116

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094497075, '2020-10-05 13:27:02.000', 52, 22565116, 200, '1.30', '0.00'),
	(31094497075, '2020-10-05 13:27:02.000', 52, 22565116, 115, '2', '0')



	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.81 WHERE acctId = 10460903
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.81, RunningMinimumDue = RunningMinimumDue - 20.81, 
	RemainingMinimumDue = RemainingMinimumDue - 20.81 WHERE acctId = 10460903

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.43, AmountOfTotalDue = AmountOfTotalDue - 11.43 WHERE acctId = 26423898

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094784989, '2020-10-05 18:03:29.000', 51, 10460903, 200, '49.89', '29.08')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 26423898 AND ATID = 52 AND IdentityField = 1179726346
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094784989, '2020-10-05 18:03:29.000', 52, 26423898, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 33.83 WHERE acctId = 9311055
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.83, RunningMinimumDue = RunningMinimumDue - 33.83, 
	RemainingMinimumDue = RemainingMinimumDue - 33.83, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9311055

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31095759010, '2020-10-05 17:40:32.000', 51, 9311055, 200, '33.83', '0.00'),
	(31095759010, '2020-10-05 17:40:32.000', 51, 9311055, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION