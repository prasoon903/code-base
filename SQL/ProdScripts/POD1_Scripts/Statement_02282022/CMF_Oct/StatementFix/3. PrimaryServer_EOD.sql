-- TO BE RUN ON PRIMARY SERVER ONLY


USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.59, AmountOfTotalDue = AmountOfTotalDue - 2.59 WHERE CPSacctId = 14715 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.30, AmountOfTotalDue = AmountOfTotalDue - 24.30 WHERE CPSacctId = 15984 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE CPSacctId = 16587 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 21.03, AmountOfTotalDue = AmountOfTotalDue - 21.03 WHERE CPSacctId = 55603609 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.34, AmountOfTotalDue = AmountOfTotalDue - 24.34 WHERE CPSacctId = 56291 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.69, AmountOfTotalDue = AmountOfTotalDue - 24.69 WHERE CPSacctId = 120236 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SYstemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 42.88, AmtOfPayXDLate = AmtOfPayXDLate - 42.88,
RunningMinimumDue = RunningMinimumDue - 42.88, RemainingMinimumDue = RemainingMinimumDue - 42.88 WHERE BSacctId = 122810 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 244248 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, CycleDueDTD = 0 WHERE CPSacctId = 20590875 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 52.30, AmtOfPayXDLate = AmtOfPayXDLate - 26.15, 
AmountOfPayment30DLate = AmountOfPayment30DLate - 26.15, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL,
SRBWithInstallmentDue = SRBWithInstallmentDue - 52.30 ,
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 417786 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 7.78, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.78 WHERE CPSacctId = 430006  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 3.41, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 3.41 WHERE CPSacctId = 6277877  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 57775975  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 57775976  AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 588281 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 600501 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 659234 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66215965 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66810225 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 883659 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66742392 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET RunningMinimumDue = RunningMinimumDue - 172.89, RemainingMinimumDue = RemainingMinimumDue - 172.89, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1845697 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67385604 AND BusinessDay = '2021-10-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1240951 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66478297 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66478298 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmountOfPayment30DLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1255358 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 44752305 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 45639853 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1344799 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 1357219 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1378174 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67069091 AND BusinessDay = '2021-10-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1356278 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 8350272 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1508643 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 41925982 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1722050 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 13449029 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 1841625 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 16149698 AND BusinessDay = '2021-10-31 23:59:57.000'


--UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 54.64, CycleDueDTD = 1, SystemStatus = 2, AmtOfPayXDLate = AmtOfPayXDLate - 54.64, SRBWithInstallmentDue = SRBWithInstallmentDue + 94.33, 
--DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
-- DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 2706267 AND BusinessDay = '2021-10-31 23:59:57.000'

--UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1124.01, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 1124.01, 
--SRBWithInstallmentDue = SRBWithInstallmentDue + 1124.01 WHERE CPSacctId = 69562449 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 13079736 AND BusinessDay = '2021-10-31 23:59:57.000'

--UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
-- DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 2724147 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 2872157 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 36114861 AND BusinessDay = '2021-10-31 23:59:57.000'

--UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.31, AmtOfPayXDLate = AmtOfPayXDLate - 1.31, SRBWithInstallmentDue = SRBWithInstallmentDue + 22.04, 
--DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
-- DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 2837196 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 9699839 AND BusinessDay = '2021-10-31 23:59:57.000'
--UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 239.50, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 239.50, 
--SRBWithInstallmentDue = SRBWithInstallmentDue + 239.50 WHERE CPSacctId = 36114861 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 3996361 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 11109111 AND BusinessDay = '2021-10-31 23:59:57.000'



--UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 41.62, AmtOfPayXDLate = AmtOfPayXDLate - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue + 41.62, 
--DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
-- DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 7853217 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67249738 AND BusinessDay = '2021-10-31 23:59:57.000'
--UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 20.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.98 WHERE CPSacctId = 19159375 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 8940606 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33326406 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 9806096 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 24106254  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33539153  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33539154  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712715  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712824  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712825  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 53701058  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67224884  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67225007  AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 10655987 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 28870326 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 11089488 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 35504324 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 36850490 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 11520974 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67551672 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13071394 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66851331 AND BusinessDay = '2021-10-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13572797 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67141268 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13611044 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 40157009 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 18041996 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66124027 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 18390195 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 57295800 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66432453 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 20602937 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 65591084 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1 WHERE CPSacctId = 2136728 AND BusinessDay = '2021-10-31 23:59:57.000'

--NEW

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 3.23, AmtOfPayXDLate = AmtOfPayXDLate - 3.23,
SRBWithInstallmentDue = SRBWithInstallmentDue + 30.44, 
CycleDueDTD = 1, SystemStatus = 2 WHERE BSacctId = 14886219 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0 WHERE CPSacctId = 45925730 AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 154.94, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 154.94, SRBWithInstallmentDue = SRBWithInstallmentDue + 154.94
 WHERE CPSacctId = 63292415 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE BSacctId = 16564141 AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 88.16, AmtOfPayXDLate = AmtOfPayXDLate - 88.16,
SRBWithInstallmentDue = SRBWithInstallmentDue - 88.16 
 WHERE BSacctId = 18074751 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67273308  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67273309  AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 22.04, AmtOfPayXDLate = AmtOfPayXDLate - 22.04,
SRBWithInstallmentDue = SRBWithInstallmentDue - 22.04, CycleDueDTD = 1, SystemStatus = 2 WHERE BSacctId = 18310493 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67431627  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 16.35, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 16.35 WHERE CPSacctId = 68410214  AND BusinessDay = '2021-10-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.03, AmtOfPayXDLate = AmtOfPayXDLate - 0.03,
SRBWithInstallmentDue = SRBWithInstallmentDue + 32.04, CycleDueDTD = 1, SystemStatus = 2 WHERE BSacctId = 18533310 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 57747124  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 672.86, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 672.86, SRBWithInstallmentDue = SRBWithInstallmentDue + 672.86 WHERE CPSacctId = 58404925  AND BusinessDay = '2021-10-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 146.41, AmtOfPayXDLate = AmtOfPayXDLate - 146.41, SRBWithInstallmentDue = SRBWithInstallmentDue - 146.41, CycleDueDTD = 1, SystemStatus = 2 WHERE BSacctId = 21398959 AND BusinessDay = '2021-10-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67325735  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67325734  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67325733  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 49.94, AmtOfPayCurrDue = AmtOfPayCurrDue + 49.94, CycleDueDTD = 1 WHERE CPSacctId = 67074334  AND BusinessDay = '2021-10-31 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 133.47, AmtOfPayCurrDue = AmtOfPayCurrDue + 133.47 WHERE CPSacctId = 66617613  AND BusinessDay = '2021-10-31 23:59:57.000'



update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 108.25,
	 amtofpayxdlate = amtofpayxdlate  - 108.25  , cycleduedtd  = cycleduedtd  - 2  where  CPSacctId   = 66251264 and  businessday  = '2021-10-31 23:59:57.000'

	 
update  top(1) planinfoforreport  set       amountoftotaldue  = amountoftotaldue  - -38.97,AmtOfPayCurrDue = AmtOfPayCurrDue  - -38.97   , cycleduedtd  = cycleduedtd  + 1  
where  cpsacctid   = 67937761 and  businessday   = '2021-10-31 23:59:57.000'


	
	update  top(1) planinfoforreport  set  amountoftotaldue  = amountoftotaldue  + 8.08 ,
	 AmtOfPayCurrDue = AmtOfPayCurrDue  + 8.08    where  cpsacctid   = 61130944 and  businessday   = '2021-10-31 23:59:57.000'

	 update  top(1) accountinfoforreport  set  
	 srbwithinstallmentdue = srbwithinstallmentdue  - 108.25  , sbwithinstallmentdue = sbwithinstallmentdue  - 108.25 
	  , amtofpaycurrdue = amtofpaycurrdue  - -108.25  , amtofpayxdlate = amtofpayxdlate  - 108.25 
	   where  bsacctid   = 19628952 and  businessday  = '2021-10-31 23:59:57.000'


	  
update  top(1) planinfoforreport  set    amountoftotaldue  = amountoftotaldue  - -1.01, AmtOfPayCurrDue = AmtOfPayCurrDue  - -1.01  where  cpsacctid   = 63449589 and  businessday   = '2021-10-31 23:59:57.000'



update  top(1) planinfoforreport  set      amountoftotaldue  = amountoftotaldue  - 41.62,srbwithinstallmentdue = srbwithinstallmentdue  - 41.62  , sbwithinstallmentdue = sbwithinstallmentdue  - 41.62 
 , AmtOfPayCurrDue = AmtOfPayCurrDue  - 41.62  , cycleduedtd  = cycleduedtd  - 2  where  cpsacctid   = 66820565 and  businessday   = '2021-10-31 23:59:57.000'



 
 	update  top(1) planinfoforreport  set    amountoftotaldue  = amountoftotaldue  - -7.38 , srbwithinstallmentdue = srbwithinstallmentdue  - -7.38  
	, sbwithinstallmentdue = sbwithinstallmentdue  - -7.38  , AmtOfPayCurrDue = AmtOfPayCurrDue  - -7.38
	where  cpsacctid   = 69347016 and  businessday  = '2021-10-31 23:59:57.000'



	update  top(1) accountinfoforreport  set   srbwithinstallmentdue = srbwithinstallmentdue  - 37.54  , sbwithinstallmentdue = sbwithinstallmentdue  - 37.54 
	 , amtofpaycurrdue = amtofpaycurrdue  - -38.32  , amtofpayxdlate = amtofpayxdlate  - 41.62  , cycleduedtd  = cycleduedtd  - 1 , systemstatus =2 
	 , DateOfOriginalPaymentDueDTD = null, daysDelinquent = 0, TotalDaysDelinquent = 0  where  bsacctid   = 19628952 and  businessday   = '2021-10-31 23:59:57.000'

	  

	  
	update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 33.70,
	 amtofpayxdlate = amtofpayxdlate  - 33.70  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  - 33.70  , sbwithinstallmentdue = sbwithinstallmentdue  - 33.70  
	  where  cpsacctid   = 67656519 and  businessday   = '2021-10-31 23:59:57.000'



	  

	  
	update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 8.29 ,
	 amtofpayxdlate = amtofpayxdlate  - 8.29  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  - 8.29  , sbwithinstallmentdue = sbwithinstallmentdue  - 8.29 
	  where  cpsacctid   = 67656520 and  businessday   = '2021-10-31 23:59:57.000'



	  
	  
	update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 32.36,
	 amtofpayxdlate = amtofpayxdlate  - 32.36  , cycleduedtd  = cycleduedtd  +1  	  where  cpsacctid   = 68406221 and  businessday   = '2021-10-31 23:59:57.000'


	 
	 update  top(1) accountinfoforreport  set  
	 srbwithinstallmentdue = srbwithinstallmentdue - 41.99  , sbwithinstallmentdue = sbwithinstallmentdue -  41.99 
	  , amtofpaycurrdue = amtofpaycurrdue  + 41.99  , amtofpayxdlate = amtofpayxdlate  - 41.99
	  , cycleduedtd  = cycleduedtd  - 1, systemstatus =2, DateOfOriginalPaymentDueDTD = null, daysDelinquent = 0, TotalDaysDelinquent = 0   where  bsacctid   = 21091933 and  businessday   = '2021-10-31 23:59:57.000'

	  --------


	  
	  
	update  top(1) planinfoforreport  set    amountoftotaldue  = amountoftotaldue  + 1088.91,
	 AmtOfPayCurrDue = AmtOfPayCurrDue  + 1088.91  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  + 1088.91  , sbwithinstallmentdue = sbwithinstallmentdue + 1088.91
	  where cpsacctid   = 69880756 and  businessday  = 110034466



	  
	 
	update  top(1) planinfoforreport  set    amountoftotaldue  = amountoftotaldue  - 25,
	 amtofpayxdlate = amtofpayxdlate  - 25 , cycleduedtd  = cycleduedtd  -2  	  where  cpsacctid   = 66584366 and  businessday  = 110034466


	 
	 update  top(1) accountinfoforreport  set 
	 srbwithinstallmentdue = srbwithinstallmentdue  +45.37 , sbwithinstallmentdue = sbwithinstallmentdue  +45.37
	  , amtofpaycurrdue = amtofpaycurrdue +25 , amtofpayxdlate = amtofpayxdlate  - 25
	  , cycleduedtd  = cycleduedtd  - 1, systemstatus =2, DateOfOriginalPaymentDueDTD = null , daysDelinquent = 0, TotalDaysDelinquent = 0  where bsacctid   = 21365712 and  businessday  = 110034466
