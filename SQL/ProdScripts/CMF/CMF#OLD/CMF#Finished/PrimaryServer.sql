-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE CPSgmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 19.45 WHERE acctId = 9634150 
	-- 1 row update

	UPDATE CPSgmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 1925.55 WHERE acctId = 2986678 
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