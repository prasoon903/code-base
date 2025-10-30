-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctid = 4680519
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.64, AmtOfPayXDLate = AmtOfPayXDLate - 13.64 WHERE acctid = 4680519
	-- 1 rows update

	DELETE FROM CurrentBalanceAudit WHERE aid = 4680519 AND IdentityField IN (428148037, 428148038)
	-- 2 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 4680519
SELECT AmountOfTotalDue, AmtOfPayXDLate FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 4680519


*/