-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- 1 row UPDATE TOP(1) each statement unless specified



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 58.61, AmountOfTotalDue = AmountOfTotalDue - 58.61, 
RunningMinimumDue = RunningMinimumDue - 58.61, RemainingMinimumDue = RemainingMinimumDue - 58.61, 
DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 546418 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 31.52, AmountOfTotalDue = AmountOfTotalDue - 31.52, 
RunningMinimumDue = RunningMinimumDue - 31.52, RemainingMinimumDue = RemainingMinimumDue - 31.52, 
DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 602255 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 2, SystemStatus = 3, AmountOfTotalDue = AmountOfTotalDue + 0.93, AmtOfPayXDLate = AmtOfPayXDLate + 0.93, 
RunningMinimumDue = RunningMinimumDue + 0.93, RemainingMinimumDue = RemainingMinimumDue + 0.93, DateOfOriginalPaymentDueDTD = '2020-11-30 23:59:57', 
DateOfDelinquency = '2020-11-30 23:59:57', DaysDelinquent = 16, TotalDaysDelinquent = 16  WHERE BSacctId = 2464147 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.26, AmountOfTotalDue = AmountOfTotalDue - 2.26, RunningMinimumDue = RunningMinimumDue - 2.26, 
RemainingMinimumDue = RemainingMinimumDue - 2.26, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 13569174 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.52, AmountOfTotalDue = AmountOfTotalDue - 6.52 WHERE 
CPSacctId = 2694098 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.60, AmountOfTotalDue = AmountOfTotalDue - 23.60 WHERE 
CPSacctId = 2176631 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayXDLate = AmtOfPayXDLate + 0.76, AmountOfTotalDue = AmountOfTotalDue + 0.76, RunningMinimumDue = RunningMinimumDue + 0.76, 
RemainingMinimumDue = RemainingMinimumDue + 0.76, DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 5620100 AND BusinessDay = '2020-12-17 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayXDLate = AmtOfPayXDLate + 0.38, AmountOfTotalDue = AmountOfTotalDue + 0.38 WHERE CPSacctId = 13108258 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.08, AmountOfTotalDue = AmountOfTotalDue - 23.08 WHERE 
CPSacctId = 1597063 AND BusinessDay = '2020-12-17 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.36, AmountOfTotalDue = AmountOfTotalDue - 1.36, 
RunningMinimumDue = RunningMinimumDue - 1.36, RemainingMinimumDue = RemainingMinimumDue - 1.36, 
DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 4255337 AND BusinessDay = '2020-12-17 23:59:57.000'

