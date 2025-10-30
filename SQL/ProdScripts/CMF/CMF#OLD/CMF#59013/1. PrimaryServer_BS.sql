-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION



DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18074751 AND ATID = 51 AND IdentityField = 2231981078
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21398996 AND ATID = 51 AND IdentityField = 2235111010



UPDATE TOP(1) BSegmentCreditCard SET DaysDelinquent = 1, NoPayDaysDelinquent = 1 WHERE acctId = 5623450


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 21398996

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 21398996

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66461063
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66461064
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66617650


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 46.67 WHERE acctId = 21644933

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 46.67, AmtOfPayXDLate = 0, RunningMinimumDue = 46.67, RemainingMinimumDue = 46.67, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 46.67, SBWithInstallmentDue = 46.67 WHERE acctId = 21644933

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67677141
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67677142
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67677143
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 46.67, CycleDueDTD = 1, AmtOfPayCurrDue = 46.67 WHERE acctId = 67677141


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.65 WHERE acctId = 18310493

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 16.65, AmtOfPayXDLate = 0, RunningMinimumDue = 16.65, RemainingMinimumDue = 16.65, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 16.65, SBWithInstallmentDue = 16.65 WHERE acctId = 18310493

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67431627
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 16.65, CycleDueDTD = 1, AmtOfPayCurrDue = 16.65 WHERE acctId = 68410214



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 39.05 WHERE acctID = 19628952
UPDATE TOP(1) BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 108.25, SBWithInstallmentDue = SBWithInstallmentDue - 108.25, AmtOfPayXDLate = AmtOfPayXDLate - 108.25, 
RunningMinimumDue = 47.05, RemainingMinimumDue = 47.05 WHERE acctID = 19628952
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, CycleDueDTD = 0 WHERE acctId = 66251264
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.08, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.08 WHERE acctId = 61130944
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 38.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 38.97 WHERE acctId = 67937761



UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 36.52, AmtOfPayXDLate = 36.52, RunningMinimumDue = 36.52, RemainingMinimumDue = 36.52, 
SRBWithInstallmentDue = 36.52, SBWithInstallmentDue = 36.52 WHERE acctId = 18074751

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273308
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273309





UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33326406


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, CycleDueDTD = 0 WHERE acctId = 67249738
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 20.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.98 WHERE acctId = 19159375
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.97 WHERE acctID = 7853217
UPDATE TOP(1) BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 41.62, SBWithInstallmentDue = SBWithInstallmentDue - 41.62, AmtOfPayXDLate = 0, 
DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, RunningMinimumDue = 10.97, RemainingMinimumDue = 10.97,
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctID = 7853217


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 20602937

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 20602937

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 65591084


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 11520974

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11520974

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67551672

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 3996361

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 3996361

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11109111


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 18041996

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 18041996

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66124027

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 18390195

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 18390195

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57295800
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66432453


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 2724147

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 2724147

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 2872157
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36114861

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 11089488

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11089488

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 35504324
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36850490


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 10655987

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 10655987

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 28870326


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13572797

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13572797

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67141268


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13611044

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13611044

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 40157009


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33326406


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 9806096

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 9806096

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 24106254
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539153
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539154
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712715
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712824
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712825
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 53701058
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67224884
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67225007


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66851331
