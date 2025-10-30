-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) CCard_Primary SET TranRef = NULL WHERE TranID = 43373027449


UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 605914 -- BSAcctId = 593694

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 795462

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1993729

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2273994

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 6146787

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1729696

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10205156

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 36775347





UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.61, AmtOfPayXDLate = AmtOfPayXDLate + 2.61, RunningMinimumDue = RunningMinimumDue + 2.61, 
RemainingMinimumDue = RemainingMinimumDue + 2.61 WHERE acctId = 2251171



UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 100.08, AmtOfPayXDLate = AmtOfPayXDLate + 43.50, 
AmountOfPayment30DLate = AmountOfPayment30DLate + 56.58, RunningMinimumDue = RunningMinimumDue + 100.08, 
RemainingMinimumDue = RemainingMinimumDue + 100.08 WHERE acctId = 4323407




UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 326.32, AmtOfPayXDLate = AmtOfPayXDLate + 91.61,
AmountOfPayment30DLate = AmountOfPayment30DLate + 91.49, AmountOfPayment60DLate = AmountOfPayment60DLate + 91.49, AmountOfPayment90DLate = AmountOfPayment90DLate + 51.73,
RunningMinimumDue = RunningMinimumDue + 326.32, RemainingMinimumDue = RemainingMinimumDue + 326.32 WHERE acctId = 7603336




UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 29.17, AmtOfPayXDLate = AmtOfPayXDLate + 18.35, RunningMinimumDue = RunningMinimumDue + 29.17, 
RemainingMinimumDue = RemainingMinimumDue + 29.17 WHERE acctId = 9812311






