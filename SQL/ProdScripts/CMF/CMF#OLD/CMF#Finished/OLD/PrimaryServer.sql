-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.10, CycleDueDTD = 1, SystemStatus = 2 WHERE acctid = 1148046
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 2.10, RemainingMinimumDue = RemainingMinimumDue + 2.10 WHERE acctid = 1148046
	-- 1 rows update

	UPDATE CurrentBalanceAudit SET NewValue = '1' WHERE aid = 4711734 AND IdentityField = 455261367
	-- 1 rows update

	UPDATE CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 2.10, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.10, CycleDueDTD = 1 WHERE acctId = 1160466 
	-- 1 row update

	UPDATE CurrentBalanceAuditPS SET NewValue = '1' WHERE aid = 1160466 AND IdentityField = 729440293
	-- 1 rows update


	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1, SystemStatus = 2 WHERE acctid = 1150358
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE acctid = 1150358
	-- 1 rows update

	UPDATE CurrentBalanceAudit SET NewValue = '1' WHERE aid = 1150358 AND IdentityField = 456850638
	-- 1 rows update

	UPDATE CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25, AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1 WHERE acctId = 1162778 
	-- 1 row update

	UPDATE CurrentBalanceAuditPS SET NewValue = '1' WHERE aid = 1162778 AND IdentityField = 732072959
	-- 1 rows update


	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 10.33, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.33 WHERE acctId = 2694105 
	-- 1 row update

	UPDATE CurrentBalanceAuditPS SET NewValue = '52.26' WHERE aid = 2694105 AND IdentityField = 732775669
	-- 1 rows update


	UPDATE BsegmentCreditCard SET StatementRemainingBalance = StatementRemainingBalance + 1945 WHERE acctid = 2805178
	-- 1 rows update

	UPDATE CPSgmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue + 19.45 WHERE acctId = 9634150 
	-- 1 row update

	UPDATE CPSgmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue + 1925.55 WHERE acctId = 2986678 
	-- 1 row update




--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD, SystemStatus FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 1148046
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 1148046

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 1150358
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 1150358

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 2805178
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue, StatementRemainingBalance, StatementRemainingBalance + 1945 
FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 2805178

SELECT SRBWithInstallmentDue,* FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 9634150
SELECT SRBWithInstallmentDue,* FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 2986678




*/