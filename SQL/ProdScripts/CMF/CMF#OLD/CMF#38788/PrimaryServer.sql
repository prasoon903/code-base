-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.45, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.45, CycleDueDTD = 0 WHERE acctId = 752378 
	-- 1 row update

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(27994747246, '2020-06-09 22:02:50', 52, 752378, 115, '1', '0'),
	(27994747246, '2020-06-09 22:02:50', 52, 752378, 200, '24.45', '0.00')
	-- 2 row inserted


	


--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT AmountOfTotalDue,AmtOfPayCurrDue, CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 752378




*/