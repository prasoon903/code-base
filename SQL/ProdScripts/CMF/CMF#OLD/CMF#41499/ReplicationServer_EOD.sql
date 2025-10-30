-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 28.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 28.29, CycleDueDTD = 1 WHERE CPSacctId = 12711146 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.29, CycleDueDTD = 1 WHERE CPSacctId = 12711147 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.29, CycleDueDTD = 1 WHERE CPSacctId = 17634552 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 32.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.20 WHERE CPSacctId = 17634551 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 32.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.20 WHERE CPSacctId = 23419518 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 26.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 26.50, CycleDueDTD = 1 WHERE CPSacctId = 23485181 AND BusinessDay = '2020-08-20 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 7.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.63 WHERE CPSacctId = 11091474 AND BusinessDay = '2020-08-20 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.44 WHERE CPSacctId = 10036149 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.44 WHERE CPSacctId = 10052434 AND BusinessDay = '2020-08-20 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.58 WHERE CPSacctId = 18897419 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.58 WHERE CPSacctId = 18897420 AND BusinessDay = '2020-08-20 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE CPSacctId = 23200402 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 6.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 6.50, CycleDueDTD = 1 WHERE CPSacctId = 23200403 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 14.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 14.91, CycleDueDTD = 1 WHERE CPSacctId = 23200732 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 10.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, CycleDueDTD = 1 WHERE CPSacctId = 23228421 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE CPSacctId = 23228423 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE CPSacctId = 23228424 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE CPSacctId = 23230437 AND BusinessDay = '2020-08-20 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 10.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, CycleDueDTD = 1 WHERE CPSacctId = 23230439 AND BusinessDay = '2020-08-20 23:59:57'


COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSacctId = 12711146 AND BusinessDay = '2020-08-06 23:59:57'
SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSacctId = 12711147 AND BusinessDay = '2020-08-06 23:59:57'

*/