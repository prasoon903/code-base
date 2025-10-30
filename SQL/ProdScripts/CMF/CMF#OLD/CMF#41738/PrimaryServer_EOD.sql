-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 row each

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.56, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.56 WHERE CPSacctId = 23230545 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 758374
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.56, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.56 WHERE CPSacctId = 23190458 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 758374
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 19117218 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 19117219 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 19119220 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 19119221 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 23828941 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE CPSacctId = 23828942 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 1728411
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.05 WHERE CPSacctId = 23212742 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 2263476
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.30 WHERE CPSacctId = 22629289 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.30 WHERE CPSacctId = 22629290 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 6.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 6.20, CycleDueDTD = 1 WHERE CPSacctId = 10948807 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 4959473
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 26.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 26.20, CycleDueDTD = 1 WHERE CPSacctId = 10948808 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 4959473
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.09, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.09 WHERE CPSacctId = 22797294 AND BusinessDay = '2020-08-26 23:59:57.000'   -- AccountID: 9155985

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711146 AND BusinessDay = '2020-08-06 23:59:57'
SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711147 AND BusinessDay = '2020-08-06 23:59:57'

*/