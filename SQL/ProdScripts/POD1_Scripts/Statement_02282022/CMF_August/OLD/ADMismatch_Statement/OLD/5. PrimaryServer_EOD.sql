-- TO BE RUN ON PRIMARY SERVER ONLY


USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


update   top(1) accountinfoforreport   set  dateofnextstmt  = '2021-09-30 23:59:57.000', laststatementdate = '2021-08-31 23:59:57.000'
	 where  bsacctid = 20453980   and businessday  = '2021-08-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, DateOfOriginalPaymentDueDTD = NULL, RunningMinimumDue = 0, 
RemainingMinimumDue = 0, DateOfDelinquency = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE BSacctId = 1236490 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = 0, 
AmountOfTotalDue = 0 WHERE CPSacctId = 56005302 AND BusinessDay = '2021-08-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, DateOfOriginalPaymentDueDTD = NULL, RunningMinimumDue = 0, AmountOfPayment90DLate = 0,
RemainingMinimumDue = 0, DateOfDelinquency = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE BSacctId = 878557 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayXDLate = 0, 
AmountOfTotalDue = 0 WHERE CPSacctId = 56748018 AND BusinessDay = '2021-08-31 23:59:57.000'




UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 54.22, AmtOfPayCurrDue = AmtOfPayCurrDue + 54.68, 
AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46, DateOfOriginalPaymentDueDTD = NULL, RunningMinimumDue = RunningMinimumDue + 54.22, 
RemainingMinimumDue = RemainingMinimumDue + 54.22, DateOfDelinquency = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE BSacctId = 7819098 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46, 
AmountOfTotalDue = AmountOfTotalDue - 0.46 WHERE CPSacctId = 56005302 AND BusinessDay = '2021-08-31 23:59:57.000'



UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.94, AmountOfTotalDue = AmountOfTotalDue + 7.94 WHERE 
CPSacctId = 3475109 AND BusinessDay = '2021-08-31 23:59:57.000' -- BSAcctId = 2986959


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayXDLate = AmtOfPayXDLate - 25, AmountOfTotalDue = AmountOfTotalDue - 25, DateOfDelinquency = NULL, DaysDelinquent = 0 WHERE BSacctId = 12125607 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE CPSacctId = 32487735 AND BusinessDay = '2021-08-31 23:59:57.000' -- BSAcctId = 12125607


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 0.14, AmtOfPayXDLate = AmtOfPayXDLate - 0.14,
RunningMinimumDue = RunningMinimumDue - 0.14, RemainingMinimumDue = RemainingMinimumDue - 0.14, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSacctId = 4346940 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 0.08, AmtOfPayXDLate = AmtOfPayXDLate - 0.08,
RunningMinimumDue = RunningMinimumDue - 0.08, RemainingMinimumDue = RemainingMinimumDue - 0.08, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSacctId = 6404696 AND BusinessDay = '2021-08-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 1.06, AmtOfPayXDLate = AmtOfPayXDLate - 1.06,
RunningMinimumDue = RunningMinimumDue - 1.06, RemainingMinimumDue = RemainingMinimumDue - 1.06, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSacctId = 12400964 AND BusinessDay = '2021-08-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25,
RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSacctId = 18251859 AND BusinessDay = '2021-08-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25,
RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSacctId = 18683978 AND BusinessDay = '2021-08-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0, AmountOfTotalDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, 
RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, DateOfDelinquency = NULL, DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = 19385355 AND BusinessDay = '2021-08-31 23:59:57.000'


UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0 WHERE CPSacctId = 60063347 AND BusinessDay = '2021-08-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10384 WHERE BSacctId = 372891 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10384 WHERE BSacctId = 757968 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10384 WHERE BSacctId = 818060 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10386 WHERE BSacctId = 2730513 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10386 WHERE BSacctId = 13435729 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10386 WHERE BSacctId = 16863456 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10384 WHERE BSacctId = 18545175 AND BusinessDay = '2021-08-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET ccinhparent127AID = 10406 WHERE BSacctId = 20465702 AND BusinessDay = '2021-08-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 9327331 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 9327331

UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 277855 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 277855
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 282409 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 282409
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 344335 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 344335
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 404922 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 404922
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 1140904 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 1140904
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 1156616 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 1156616
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 1440067 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 1440067
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 1992621 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 1992621
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2000702 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2000702
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2502423 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2502423
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2551588 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2551588
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2637636 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2637636
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2639620 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2639620
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2645992 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2645992
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2660880 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2660880
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2676140 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2676140
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 2908817 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 2908817
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 4451408 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 4451408
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 4621064 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 4621064
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 4853815 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 4853815
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 4909611 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 4909611
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 4913824 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 4913824
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 6408687 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 6408687
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 6805783 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 6805783
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 7895161 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 7895161
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 9437465 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 9437465
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 9855690 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 9855690
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 10234517 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 10234517
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 10302152 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 10302152
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 10648648 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 10648648
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 10890281 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 10890281
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 11862323 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 11862323
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 11957840 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 11957840
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 13175282 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 13175282
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 13543464 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 13543464
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 15307427 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 15307427
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 15567575 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 15567575
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 15945625 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 15945625
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 17323865 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 17323865
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 17516388 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 17516388
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 31 WHERE BSacctId = 17996163 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 17996163
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 0 WHERE BSacctId = 19385355 AND BusinessDay = '2021-08-31 23:59:57.000'   -- AccountID: 19385355