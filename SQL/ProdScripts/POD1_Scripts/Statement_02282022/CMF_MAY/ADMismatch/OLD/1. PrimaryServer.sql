-- TO BE RUN ON PRIMARY SERVER ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


USE CCGS_CoreIssue
GO

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53511881 -- BSAcctId = 805445




UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayXDLate = AmtOfPayXDLate - 4.66, AmountOfPayment30DLate = AmountOfPayment30DLate + 4.66, 
RunningMinimumDue = RunningMinimumDue + 175.40, RemainingMinimumDue = RemainingMinimumDue + 175.40 WHERE acctId = 1742986

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 4.66, AmountOfPayment30DLate = AmountOfPayment30DLate + 4.66 WHERE acctId = 26055371 -- BSAcctId = 1742986



UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53525762 -- BSAcctId = 1859269


UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53566038 -- BSAcctId = 2478598



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 19.97 WHERE acctId = 3211712

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 19.97, AmtOfPayXDLate = AmtOfPayXDLate + 19.97, 
RunningMinimumDue = RunningMinimumDue + 19.97, RemainingMinimumDue = RemainingMinimumDue + 19.97, FirstDueDate = '2021-04-30 23:59:57',
DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE acctId = 3211712

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 19.97, AmtOfPayXDLate = AmtOfPayXDLate + 19.97 WHERE acctId = 40565867 -- BSAcctId = 3211712



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 3, SystemStatus = 15991 WHERE acctId = 311669

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 59, AmtOfPayXDLate = AmtOfPayXDLate + 37.31, AmountOfPayment30DLate = AmountOfPayment30DLate + 21.69, 
RunningMinimumDue = RunningMinimumDue + 59, RemainingMinimumDue = RemainingMinimumDue + 59, FirstDueDate = '2021-03-31 23:59:57',
DtOfLastDelinqCTD = '2021-04-30 23:59:57', DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', DaysDelinquent = 32, NoPayDaysDelinquent = 32 WHERE acctId = 311669




UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53517848 -- BSAcctId = 4592772


UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53543938 -- BSAcctId = 10895026




UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 32.19 WHERE acctId = 13004403

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 80.04, AmtOfPayXDLate = AmtOfPayXDLate + 32.19, 
RunningMinimumDue = RunningMinimumDue + 80.04, RemainingMinimumDue = RemainingMinimumDue + 80.04, FirstDueDate = '2021-04-30 23:59:57',
DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57', DaysDelinquent = 1, NoPayDaysDelinquent = 1 WHERE acctId = 13004403

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 32.19, AmtOfPayXDLate = AmtOfPayXDLate + 32.19 WHERE acctId = 37085917 -- BSAcctId = 13004403



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 58.73, AmountOfTotalDue = AmountOfTotalDue + 58.73 WHERE acctId = 10449489 -- BSAcctId = 4919331




UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 430.09, CycleDueDTD = 1 WHERE acctId = 7493132

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 430.09, RunningMinimumDue = RunningMinimumDue + 430.09, 
RemainingMinimumDue = RemainingMinimumDue + 430.09, FirstDueDate = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57' WHERE acctId = 7493132