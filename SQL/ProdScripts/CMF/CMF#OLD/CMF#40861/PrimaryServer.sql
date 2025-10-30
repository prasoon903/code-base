USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.01, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01 WHERE acctId = 819275
	-- 1 row

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT AmountOfTotalDue, AmtOfPayCurrDue FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 819275