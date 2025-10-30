
BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) CPSgmentCreditCard SET sbwithinstallmentdue = 137.22, srbwithinstallmentdue = 137.22 WHERE Acctid = 67327257
UPDATE TOP(1) CPSgmentCreditCard SET sbwithinstallmentdue = 37.20, srbwithinstallmentdue = 37.20 WHERE Acctid = 67327258
UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 174.42, SRBWithInstallmentDue = SRBWithInstallmentDue + 174.42 WHERE Acctid = 21569149


UPDATE TOP(1) CPSgmentCreditCard SET sbwithinstallmentdue = 26.32, srbwithinstallmentdue = 26.32 WHERE Acctid = 68407360
UPDATE TOP(1) CPSgmentCreditCard SET sbwithinstallmentdue = 149.60, srbwithinstallmentdue = 149.60 WHERE Acctid = 68407361
UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 175.92, SRBWithInstallmentDue = SRBWithInstallmentDue+ 175.92 WHERE Acctid = 21909907

UPDATE TOP(1) CPSgmentCreditCard SET sbwithinstallmentdue = 119.60, srbwithinstallmentdue = 119.60 WHERE Acctid = 72111427
UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 119.60, SRBWithInstallmentDue = SRBWithInstallmentDue + 119.60 WHERE Acctid = 21966654

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4262192
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12838278
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 21471284

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4262192
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12838278
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 21471284

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 40083093
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 107867194

UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.42 WHERE acctID = 2798101
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = 27.65 WHERE acctID = 14073877
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 44.29 WHERE acctID = 18310733

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.42, RunningMinimumDue = RunningMinimumDue - 2.42, RemainingMinimumDue = RemainingMinimumDue - 2.42  WHERE acctID = 2798101
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 27.65, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 27.65, RemainingMinimumDue = 27.65, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2023-07-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2023-07-31 23:59:57'  WHERE acctID = 14073877
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 44.29, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 44.29, RemainingMinimumDue = 44.29, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2023-07-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2023-07-31 23:59:57'  WHERE acctID = 18310733

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 22.15, AmtOfPayCurrDue = 22.15 WHERE acctID = 42056767

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9606448

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9606448


UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 519.07, SRBWithInstallmentDue = SRBWithInstallmentDue - 519.07 WHERE Acctid = 11954332
UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 767.34, SRBWithInstallmentDue = SRBWithInstallmentDue - 767.34 WHERE Acctid = 603621
UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 111.21, SRBWithInstallmentDue = SRBWithInstallmentDue - 111.21 WHERE Acctid = 17739797


UPDATE TOP(1) BSegment_Primary SET  AmtOfPayCurrDue = 12.55 WHERE acctID = 21778069
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 12.55,   RunningMinimumDue = 12.55, RemainingMinimumDue = 12.55  WHERE acctID = 21778069

UPDATE TOP(1) CPSgmentCreditCard SET  AmountOfTotalDue = 12.55, AmtOfPayCurrDue = 12.55 WHERE acctID = 68096210



