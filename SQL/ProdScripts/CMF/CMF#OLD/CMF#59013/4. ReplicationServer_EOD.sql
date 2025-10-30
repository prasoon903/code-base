-- TO BE RUN ON REPLICATION SERVER ONLY


USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(2) AccountInfoForReport SET DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 5623450 AND BusinessDay > '2021-10-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0, SRBWithInstallmentDue = 0 WHERE BSacctId = 21398996 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66461063 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66461064 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66617650 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 46.67, AmountOfTotalDue = 46.67, AmtOfPayXDLate = 0, RunningMinimumDue = 46.67, RemainingMinimumDue = 46.67, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0, SRBWithInstallmentDue = 46.67 WHERE BSacctId = 21644933 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67677141 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67677142 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67677143 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 46.67, CycleDueDTD = 1, AmtOfPayCurrDue = 46.67 WHERE CPSacctId = 67677141 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.65, AmountOfTotalDue = 16.65, AmtOfPayXDLate = 0, RunningMinimumDue = 16.65, RemainingMinimumDue = 16.65, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0, SRBWithInstallmentDue = 16.65 WHERE BSacctId = 18310493 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67431627 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 16.65, CycleDueDTD = 1, AmtOfPayCurrDue = 16.65 WHERE CPSacctId = 68410214 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 39.05, SRBWithInstallmentDue = SRBWithInstallmentDue - 108.25, AmtOfPayXDLate = AmtOfPayXDLate - 108.25, 
RunningMinimumDue = 47.05, RemainingMinimumDue = 47.05 WHERE BSacctId = 19628952 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66251264 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.08, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.08 WHERE CPSacctId = 61130944 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 38.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 38.97 WHERE CPSacctId = 67937761 AND BusinessDay = '2021-11-02 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = 36.52, AmtOfPayXDLate = 36.52, RunningMinimumDue = 36.52, RemainingMinimumDue = 36.52, 
SRBWithInstallmentDue = 36.52 WHERE BSacctId = 18074751 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67273308 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67273309 AND BusinessDay = '2021-11-02 23:59:57.000'




UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 8940606 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33326406 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, CycleDueDTD = 0 WHERE CPSacctId = 67249738 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 20.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.98 WHERE CPSacctId = 19159375  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.97, SRBWithInstallmentDue = SRBWithInstallmentDue - 41.62, AmtOfPayXDLate = 0, 
DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, RunningMinimumDue = 10.97, RemainingMinimumDue = 10.97,
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctID = 7853217  AND BusinessDay = '2021-11-02 23:59:57.000'


 UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 20602937 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 65591084 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 11520974 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67551672 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 3996361 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 11109111 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 18041996 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66124027 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 18390195 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 57295800 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66432453 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 2724147 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 2872157 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 36114861 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 11089488 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 35504324 AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 36850490 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 10655987 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 28870326 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13572797 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67141268 AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13611044 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 40157009 AND BusinessDay = '2021-11-02 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 9806096 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 24106254  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33539153  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 33539154  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712715  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712824  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 37712825  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 53701058  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67224884  AND BusinessDay = '2021-11-02 23:59:57.000'
UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 67225007  AND BusinessDay = '2021-11-02 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
 DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 13071394 AND BusinessDay = '2021-11-02 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0 WHERE CPSacctId = 66851331 AND BusinessDay = '2021-11-02 23:59:57.000'
