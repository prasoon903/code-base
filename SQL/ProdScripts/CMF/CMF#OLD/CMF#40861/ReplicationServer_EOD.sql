USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.01, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01 WHERE CPSAcctID = 819275 AND BusinessDay = '2020-08-04 23:59:57'
	-- 1 row

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT AmountOfTotalDue, AmtOfPayCurrDue FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSAcctID = 819275 AND BusinessDay = '2020-08-04 23:59:57'