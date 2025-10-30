-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1, SystemStatus = 2 WHERE acctid = 2153560
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE acctid = 2153560
	-- 1 rows update

	UPDATE CurrentBalanceAudit SET newvalue = '1' WHERE aid = 2153560 AND IdentityField = 412217618
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 2153560
SELECT AmtOfPayXDLate FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 2153560


*/