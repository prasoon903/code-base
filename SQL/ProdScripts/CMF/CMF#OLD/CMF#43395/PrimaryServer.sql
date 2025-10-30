-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT


	UPDATE BSegment_Primary SET CycleDueDTD = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18 WHERE acctId = 1589586
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.66, AmtOfPayXDLate = AmtOfPayXDLate + 0.48, 
	RemainingMinimumDue = RemainingMinimumDue + 0.66, RunningMinimumDue = RunningMinimumDue + 0.66, 
	DtOfLastDelinqCTD = '2020-09-30 23:59:57.000', DaysDelinquent = 5  WHERE acctId = 1589586

	DELETE FROM CurrentBalanceAudit WHERE AID = 1589586 AND ATID = 51 AND IdentityField = 727414864
	UPDATE CurrentBalanceAudit SET NewValue = '0.78'  WHERE AID = 1589586 AND ATID = 51 AND IdentityField = 727414865



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.81 WHERE acctId = 10227654
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.81, RunningMinimumDue = RunningMinimumDue - 19.26, 
	RemainingMinimumDue = RemainingMinimumDue - 19.26, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10227654

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 10227654 AND ATID = 51 AND IdentityField = 722588198
	DELETE FROM CurrentBalanceAudit WHERE AID = 10227654 AND ATID = 51 AND IdentityField = 722625891
	
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30818942428, '2020-10-01 07:18:01.000', 51, 10227654, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.27 WHERE acctId = 3980670
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.27, RunningMinimumDue = RunningMinimumDue - 22.27, 
	RemainingMinimumDue = RemainingMinimumDue - 22.27, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 3980670

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.98, AmountOfTotalDue = AmountOfTotalDue - 13.98 WHERE acctId = 5210820

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 51, 3980670, 200, '22.27', '0.00'),
	(30774560578, '2020-10-01 08:48:02.000', 51, 3980670, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 5210820 AND ATID = 52 AND IdentityField = 1162328937
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 52, 5210820, 115, '1', '0')



	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 73 WHERE acctId = 2768316

	UPDATE CurrentBalanceAudit SET NewValue = '70.00' WHERE AID = 2768316 AND ATID = 51 AND IdentityField = 716781484



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.49 WHERE acctId = 9867824
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.49, RunningMinimumDue = RunningMinimumDue - 6.49, 
	RemainingMinimumDue = RemainingMinimumDue - 6.49, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9867824

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9867824 AND ATID = 51 AND IdentityField = 723139500
	
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30816684642, '2020-10-01 13:14:51.000', 51, 9867824, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.91 WHERE acctId = 10662351
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.91, RunningMinimumDue = RunningMinimumDue - 23.91, 
	RemainingMinimumDue = RemainingMinimumDue - 23.91, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10662351

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.93, AmountOfTotalDue = AmountOfTotalDue - 9.93 WHERE acctId = 27171363

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 51, 10662351, 200, '23.91', '0.00'),
	(30774560578, '2020-10-01 08:48:02.000', 51, 10662351, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 27171363 AND ATID = 52 AND IdentityField = 1161577397
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 52, 27171363, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.86 WHERE acctId = 9437860
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.86, RunningMinimumDue = RunningMinimumDue - 21.86, 
	RemainingMinimumDue = RemainingMinimumDue - 21.86, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9437860

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.03, AmountOfTotalDue = AmountOfTotalDue - 12.03 WHERE acctId = 23278018

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 51, 9437860, 200, '21.86', '0.00'),
	(30774560578, '2020-10-01 08:48:02.000', 51, 9437860, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 27171363 AND ATID = 52 AND IdentityField = 1161554887
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30774560578, '2020-10-01 08:48:02.000', 52, 27171363, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION