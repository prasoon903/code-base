-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7, CycleDueDTD = 0 WHERE acctid = 1559332
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7, RemainingMinimumDue = RemainingMinimumDue - 7, RunningMinimumDue = RunningMinimumDue - 7 WHERE acctid = 1559332
	-- 1 rows update

	DELETE FROM CurrentBalanceAudit WHERE AID = 1559332 AND ATID = 51 AND IdentityField IN (485883840, 485883841)
	-- 2 rows update

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7, AmtOfPayCurrDue = AmtOfPayCurrDue - 7, CycleDueDTD = 0 WHERE acctId = 1571752 
	-- 1 row update

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 1571752 AND ATID = 52 AND IdentityField IN (783731206, 783731207)
	-- 2 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT institutionid,acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD, SystemStatus FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 1559332
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 1559332

SELECT AmountOfTotalDue, AmtOfPayCurrDue,CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 1571752


*/