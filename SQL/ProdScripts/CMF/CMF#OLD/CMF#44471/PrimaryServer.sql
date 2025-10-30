-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.10 WHERE acctId = 8647713
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 14.10, RunningMinimumDue = RunningMinimumDue - 14.10, 
	RemainingMinimumDue = RemainingMinimumDue - 14.10, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8647713

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31554328187, '2020-10-29 09:14:38.000', 51, 8647713, 115, '1', '0'),
	(31554328187, '2020-10-29 09:14:38.000', 51, 8647713, 200, '14.10', '0.00')	


	update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 62.44 where  acctid  =  30282997

COMMIT TRANSACTION
--ROLLBACK TRANSACTION