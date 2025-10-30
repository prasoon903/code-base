-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH statement 

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 33.75 WHERE acctId = 974882
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.75, RunningMinimumDue = RunningMinimumDue - 33.75,
	 RemainingMinimumDue = RemainingMinimumDue - 33.75, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 974882

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 24.84, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.84 WHERE acctId = 987302

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30260150569, '2020-09-08 19:15:33.000', 51, 974882, 115, '1', '0'),
	(30260150569, '2020-09-08 19:15:33.000', 51, 974882, 200, '33.75', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 987302 AND ATID = 52 AND IdentityField = 1066939350
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30260150569, '2020-09-08 19:15:33.000', 52, 987302, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION