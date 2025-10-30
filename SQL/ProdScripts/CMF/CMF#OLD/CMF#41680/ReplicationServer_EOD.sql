-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION


	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.29 WHERE CPSacctId = 23808478 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 368231
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.29 WHERE CPSacctId = 23808479 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 368231
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.33, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.33 WHERE CPSacctId = 16045565 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 730631
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.22, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.22 WHERE CPSacctId = 13121436 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 798618
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.77, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.77 WHERE CPSacctId = 22323906 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 835131
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.77, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.77 WHERE CPSacctId = 22709278 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 835131
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.99, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.99 WHERE CPSacctId = 13125769 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 1391236
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.59, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.59 WHERE CPSacctId = 14222340 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 1597620
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.51, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.51 WHERE CPSacctId = 12709326 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 1915302
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.51, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.51 WHERE CPSacctId = 12709327 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 1915302
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE CPSacctId = 21920937 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2033030
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE CPSacctId = 22721743 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2033030
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE CPSacctId = 23364251 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2033030
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.74, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.74 WHERE CPSacctId = 23365126 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2254076
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.74, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.74 WHERE CPSacctId = 23365127 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2254076
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.05 WHERE CPSacctId = 23212742 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2263476
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.05 WHERE CPSacctId = 23212742 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2263476
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE CPSacctId = 22629289 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE CPSacctId = 22629290 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE CPSacctId = 22629289 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE CPSacctId = 22629290 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2356186
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.63 WHERE CPSacctId = 10040886 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2439106
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.63 WHERE CPSacctId = 10780104 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2439106
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 9.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.50 WHERE CPSacctId = 10432699 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2799196
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 9.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.50 WHERE CPSacctId = 23453046 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 2799196
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.01, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.01 WHERE CPSacctId = 13129894 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 4924436
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE CPSacctId = 13125764 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 5618326
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE CPSacctId = 13125765 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 5618326
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.50 WHERE CPSacctId = 19676336 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 5625165
	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.50 WHERE CPSacctId = 19686334 AND BusinessDay = '2020-08-25 23:59:57.000'   -- AccountID: 5625165


COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711146 AND BusinessDay = '2020-08-06 23:59:57'
SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM PlanInfoForReport WITH (NOLOCK) WHERE CPSCPSacctId = 12711147 AND BusinessDay = '2020-08-06 23:59:57'

*/