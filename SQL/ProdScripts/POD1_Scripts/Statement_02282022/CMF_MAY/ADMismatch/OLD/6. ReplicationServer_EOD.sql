-- TO BE RUN ON PRIMARY SERVER ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


--USE CCGS_CoreIssue
--GO


UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 53511881 AND BusinessDay = '2021-05-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 53525762 AND BusinessDay = '2021-05-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 53566038 AND BusinessDay = '2021-05-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 53517848 AND BusinessDay = '2021-05-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 53543938 AND BusinessDay = '2021-05-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayCurrDue = AmtOfPayCurrDue + 175.40,
RunningMinimumDue = RunningMinimumDue + 175.40, RemainingMinimumDue = RemainingMinimumDue + 175.40 WHERE BSacctId = 1742986 AND BusinessDay = '2021-05-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 19.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.97,
RunningMinimumDue = RunningMinimumDue + 19.97, RemainingMinimumDue = RemainingMinimumDue + 19.97,
DateOfDelinquency = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE BSacctId = 3211712 AND BusinessDay = '2021-05-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 59, AmtOfPayXDLate = AmtOfPayXDLate + 37.31, AmountOfPayment30DLate = AmountOfPayment30DLate + 21.69, 
CycleDueDTD = 3, SystemStatus = 15991, RunningMinimumDue = RunningMinimumDue + 59, RemainingMinimumDue = RemainingMinimumDue + 59,
DateOfDelinquency = '2021-04-30 23:59:57', DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', DaysDelinquent = 32, TotalDaysDelinquent = 32 WHERE BSacctId = 311669 AND BusinessDay = '2021-05-31 23:59:57.000'





UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 80.04, AmtOfPayCurrDue = AmtOfPayCurrDue + 80.04,RunningMinimumDue = RunningMinimumDue + 80.04, 
RemainingMinimumDue = RemainingMinimumDue + 80.04,DateOfDelinquency = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57', 
DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 13004403 AND BusinessDay = '2021-05-31 23:59:57.000'


UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 58.73, AmountOfTotalDue = AmountOfTotalDue + 58.73 WHERE CPSacctId = 10449489 AND BusinessDay = '2021-05-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 430.09, AmtOfPayCurrDue = AmtOfPayCurrDue + 430.09, CycleDueDTD = 1,
RemainingMinimumDue = RemainingMinimumDue + 430.09, DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57' WHERE BSacctId = 7493132 AND BusinessDay = '2021-05-31 23:59:57.000'






-- STATEMENT DATA



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53511881 AND StatementID = 74035522



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayCurrDue = AmtOfPayCurrDue + 175.40, 
MinimumPaymentDue = MinimumPaymentDue + 175.40 WHERE acctId = 1742986 AND StatementID = 74718801



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53525762 AND StatementID = 74783992


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53566038 AND StatementID = 75348058



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 19.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.97, 
MinimumPaymentDue = MinimumPaymentDue + 19.97, DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE acctId = 3211712 AND StatementID = 75824222



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 59, AmtOfPayXDLate = AmtOfPayXDLate + 37.31, AmountOfPayment30DLate = AmountOfPayment30DLate + 21.69, 
CycleDueDTD = 3, SystemStatus = 15991, MinimumPaymentDue = MinimumPaymentDue + 59, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57' WHERE acctId = 311669 AND StatementID = 73372548



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53517848 AND StatementID = 76231846



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53543938 AND StatementID = 77062380



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 80.04, AmtOfPayCurrDue = AmtOfPayCurrDue + 80.04, 
MinimumPaymentDue = MinimumPaymentDue + 80.04, DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE acctId = 13004403 AND StatementID = 77426950




UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 58.73 WHERE acctId = 10449489 AND StatementID = 76431663



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 430.09, AmtOfPayCurrDue = AmtOfPayCurrDue + 430.09, CycleDueDTD = 1, 
MinimumPaymentDue = MinimumPaymentDue + 430.09, DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57' WHERE acctId = 7493132 AND StatementID = 76656646


update accountinfoforreport  set  LastStatementdate = '2021-05-31 23:59:57.000', DateofNextStmt = '2021-06-30 23:59:57.000' 
 where  bsacctid = 17346311 and  businessday = '2021-05-31 23:59:57.000'