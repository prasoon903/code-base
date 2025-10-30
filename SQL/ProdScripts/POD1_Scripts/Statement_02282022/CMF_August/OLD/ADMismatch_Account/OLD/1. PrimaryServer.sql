-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE LoyaltyPointsLog SET NewValue = cast(NewValue as money) - 687.00 , OldValue = cast(OldValue  as money ) - 687.00 Where AcctId = 114162964 AND Skey > 2468070310
--11 rows


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1236490

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0,
RunningMinimumDue = 0, RemainingMinimumDue = 0, FirstDueDate = NULL, 
DateOfOriginalPaymentDueDTD = NULL, DTOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1236490


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = 0, AmountOfTotalDue = 0 WHERE acctId = 1248910 -- BSAcctId = 1236490



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 878557

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0,AmountOfPayment90DLate = 0,
RunningMinimumDue = 0, RemainingMinimumDue = 0, FirstDueDate = NULL, 
DateOfOriginalPaymentDueDTD = NULL, DTOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 878557


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = 0, AmountOfTotalDue = 0 WHERE acctId = 56748018 -- BSAcctId = 878557




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 54.68 WHERE acctId = 7819098

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 54.22, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46,
RunningMinimumDue = RunningMinimumDue + 54.22, RemainingMinimumDue = RemainingMinimumDue + 54.22, FirstDueDate = NULL, 
DateOfOriginalPaymentDueDTD = NULL, DTOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 7819098


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46, AmountOfTotalDue = AmountOfTotalDue - 0.46 WHERE acctId = 56005302 -- BSAcctId = 7819098



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.94, AmountOfTotalDue = AmountOfTotalDue + 7.94 WHERE acctId = 3475109 -- BSAcctId = 2986959


UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25, DTOfLastDelinqCTD = NULL, DaysDelinquent = 0 WHERE acctId = 12125607

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE acctId = 32487735 -- BSAcctId = 12125607



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 4346940

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.14, AmtOfPayXDLate = AmtOfPayXDLate - 0.14,
RunningMinimumDue = RunningMinimumDue - 0.14, RemainingMinimumDue = RemainingMinimumDue - 0.14, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 4346940



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 6404696

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.08, AmtOfPayXDLate = AmtOfPayXDLate - 0.08,
RunningMinimumDue = RunningMinimumDue - 0.08, RemainingMinimumDue = RemainingMinimumDue - 0.08, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 6404696



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 12400964

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.06, AmtOfPayXDLate = AmtOfPayXDLate - 1.06,
RunningMinimumDue = RunningMinimumDue - 1.06, RemainingMinimumDue = RemainingMinimumDue - 1.06, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 12400964


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18251859

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25,
RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 18251859



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18683978

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25,
RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 18683978



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 19385355

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, FirstDueDate = NULL, 
DateOfOriginalPaymentDueDTD = NULL, DTOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 19385355

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 60063347 -- BSAcctId = 19385355