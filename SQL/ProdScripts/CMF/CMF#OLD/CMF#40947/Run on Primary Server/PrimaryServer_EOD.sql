USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 2.99, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.99, CycleDueDTD = 1 WHERE CPSacctId = 10770902 AND BusinessDay = '2020-08-06 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.75 WHERE CPSacctId = 2015376 AND BusinessDay = '2020-08-06 23:59:57'

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSacctId = 10770902 AND BusinessDay = '2020-08-06 23:59:57'
SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSacctId = 2015376 AND BusinessDay = '2020-08-06 23:59:57'

*/