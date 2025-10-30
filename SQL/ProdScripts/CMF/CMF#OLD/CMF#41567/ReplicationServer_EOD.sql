-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION


	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.46, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.46 WHERE CPSacctId = 14318355 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.46, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.46 WHERE CPSacctId = 20512033 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 61.37, AmtOfPayCurrDue = AmtOfPayCurrDue + 61.37 WHERE CPSacctId = 23513875 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 17.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 17.91, CycleDueDTD = 1 WHERE CPSacctId = 23513876 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.80, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.80 WHERE CPSacctId = 11692232 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.80, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.80 WHERE CPSacctId = 11658233 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.16, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.16 WHERE CPSacctId = 10040032 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 9.42, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.42 WHERE CPSacctId = 23785707 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE CPSacctId = 10431534 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.10, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.10 WHERE CPSacctId = 23246523 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.54, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.54 WHERE CPSacctId = 20515927 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.15, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.15 WHERE CPSacctId = 13129208 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.15, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.15 WHERE CPSacctId = 13129209 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE CPSacctId = 13129092 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE CPSacctId = 13129093 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE CPSacctId = 23226760 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE CPSacctId = 23226761 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.44 WHERE CPSacctId = 9206342 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.10, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.10 WHERE CPSacctId = 23788958 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18 WHERE CPSacctId = 10017683 AND BusinessDay = '2020-08-23 23:59:57'
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18 WHERE CPSacctId = 10018724 AND BusinessDay = '2020-08-23 23:59:57'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.55, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.55 WHERE CPSacctId = 23237980 AND BusinessDay = '2020-08-23 23:59:57'


COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711146 AND BusinessDay = '2020-08-06 23:59:57'
SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711147 AND BusinessDay = '2020-08-06 23:59:57'

*/