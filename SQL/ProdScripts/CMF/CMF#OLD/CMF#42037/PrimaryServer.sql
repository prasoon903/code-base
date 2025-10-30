-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH statement 

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.38 WHERE acctId = 373547
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.38, RunningMinimumDue = RunningMinimumDue - 2.38,
	 RemainingMinimumDue = RemainingMinimumDue - 2.38, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 373547

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30222432118, '2020-09-03 14:26:01.000', 51, 373547, 115, '1', '0'),
	(30222432118, '2020-09-03 14:26:01.000', 51, 373547, 200, '2.38', '0.00')



COMMIT TRANSACTION
--ROLLBACK TRANSACTION