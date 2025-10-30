-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT


	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.52 WHERE acctId = 5574257
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.52, RunningMinimumDue = RunningMinimumDue - 10.52, 
	RemainingMinimumDue = RemainingMinimumDue - 10.52, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 5574257

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.22, AmountOfTotalDue = AmountOfTotalDue - 9.22 WHERE acctId = 12674415

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30513240228, '2020-09-24 15:34:05.000', 51, 5574257, 200, '10.52', '0.00'),
	(30513240228, '2020-09-24 15:34:05.000', 51, 5574257, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 12674415 AND ATID = 52 AND IdentityField = 1117704388
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30513240228, '2020-09-24 15:34:05.000', 52, 12674415, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.31 WHERE acctId = 8939474
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.31, RunningMinimumDue = RunningMinimumDue - 18.31, 
	RemainingMinimumDue = RemainingMinimumDue - 18.31, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8939474

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.04, AmountOfTotalDue = AmountOfTotalDue - 13.04 WHERE acctId = 21647632

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395493018, '2020-09-24 18:05:14.000', 51, 8939474, 200, '18.31', '0.00'),
	(30395493018, '2020-09-24 18:05:14.000', 51, 8939474, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 21647632 AND ATID = 52 AND IdentityField = 1117834414
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395493018, '2020-09-24 18:05:14.000', 52, 21647632, 115, '1', '0')



	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.98 WHERE acctId = 8451232
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.98, RunningMinimumDue = RunningMinimumDue - 9.98, 
	RemainingMinimumDue = RemainingMinimumDue - 9.98  WHERE acctId = 8451232

	UPDATE CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.99, AmountOfTotalDue = AmountOfTotalDue - 2.99 WHERE acctId = 28645662

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30722188601, '2020-09-24 20:50:15.000', 51, 8451232, 200, '40.48', '35.49'),
	(30722188809, '2020-09-24 20:50:17.000', 51, 8451232, 200, '35.49', '30.50')

	UPDATE CurrentBalanceAuditPS SET NewValue = '40.48' WHERE AID = 28645662 AND ATID = 52 AND IdentityField = 1117417626
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30722188601, '2020-09-24 20:50:15.000', 52, 28645662, 200, '40.48', '35.49'),
	(30722188809, '2020-09-24 20:50:17.000', 52, 28645662, 200, '35.49', '30.50')



	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.80, AmountOfTotalDue = AmountOfTotalDue - 12.80 WHERE acctId = 645535



	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.81, AmountOfTotalDue = AmountOfTotalDue - 24.81 WHERE acctId = 746729

	UPDATE ILPScheduleDetailSummary SET LoanStartDate = '2020-02-29 23:59:57.000' WHERE ScheduleID = 120613


COMMIT TRANSACTION
--ROLLBACK TRANSACTION