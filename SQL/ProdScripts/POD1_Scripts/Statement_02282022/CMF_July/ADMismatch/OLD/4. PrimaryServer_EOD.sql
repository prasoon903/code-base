-- TO BE RUN ON PRIMARY SERVER ONLY


USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 605914 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 795462 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1993729 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 2273994 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 6146787 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1729696 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 10205156 AND BusinessDay = '2021-07-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 36775347 AND BusinessDay = '2021-07-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.61, RunningMinimumDue = RunningMinimumDue + 2.61, 
RemainingMinimumDue = RemainingMinimumDue + 2.61, AmountOfTotalDue = AmountOfTotalDue + 2.61 WHERE BSacctId = 2251171 AND BusinessDay = '2021-07-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 100.08, AmountOfTotalDue = AmountOfTotalDue + 100.08,
RunningMinimumDue = RunningMinimumDue + 100.08, RemainingMinimumDue = RemainingMinimumDue + 100.08 WHERE BSacctId = 4323407 AND BusinessDay = '2021-07-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 326.32, 
AmountOfTotalDue = AmountOfTotalDue + 326.32, RunningMinimumDue = RunningMinimumDue + 326.32, 
RemainingMinimumDue = RemainingMinimumDue + 326.32 WHERE BSacctId = 7603336 AND BusinessDay = '2021-07-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 29.17, AmountOfTotalDue = AmountOfTotalDue + 29.17,
RunningMinimumDue = RunningMinimumDue + 29.17, RemainingMinimumDue = RemainingMinimumDue + 29.17 WHERE BSacctId = 7603336 AND BusinessDay = '2021-07-31 23:59:57.000'

