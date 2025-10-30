-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.08, CycleDueDTD = 0 WHERE acctId = 9429605
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.08, RunningMinimumDue = RunningMinimumDue - 25.08, RemainingMinimumDue = RemainingMinimumDue - 25.08 WHERE acctId = 9429605

	DELETE FROM CurrentBalanceAudit WHERE AID = 9429605 AND ATID = 51 AND IdentityField = 624149646
	DELETE FROM CurrentBalanceAudit WHERE AID = 9429605 AND ATID = 51 AND IdentityField = 624149647



	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 56.18, CycleDueDTD = 0 WHERE acctId = 2993761
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 56.18, RunningMinimumDue = RunningMinimumDue - 56.18, RemainingMinimumDue = RemainingMinimumDue - 56.18 WHERE acctId = 2993761

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 2993761 AND ATID = 51 AND IdentityField = 628648742
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (29764964142, '2020-08-29 23:05:37.000', 51, 2993761, 115, '1', '0')

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*
SELECT CycleDueDTD, AmtOfPayCurrDue FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 9429605
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BSegmentCreditCard WITH (NOLOCK) WHERE acctId = 9429605

SELECT CycleDueDTD, AmtOfPayCurrDue FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 2993761
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BSegmentCreditCard WITH (NOLOCK) WHERE acctId = 2993761
*/