-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.52, AmtofPayCurrDue = AmtofPayCurrDue - 7.52, CycleDueDTD = 0 WHERE acctId = 7824 --BS: 7334

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(51664898955, '2021-12-09 21:57:27.000', 52, 7824, 115, '1', '0'),
(51664898955, '2021-12-09 21:57:27.000', 52, 7824, 200, '7.52', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 380701
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 411406
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 720298
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 818975
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 853666
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1200502
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1547327
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2520360
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2738743
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 3288340
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 5604633
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 6067541
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9427517
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9455574
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9850249
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 10233982
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 11951108
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12453057
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12805466
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12944147
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 13129633
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 16910733
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 17273603
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 17688467
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 18312312
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 18726083
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 19064876
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 19835143
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 20437221
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 20762909
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 21563703
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 21634667

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 380701
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 411406
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 720298
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 818975
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 853666
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1200502
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1547327
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2520360
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2738743
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 3288340
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 5604633
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 6067541
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9427517
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9455574
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9850249
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 10233982
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 11951108
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12453057
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12805466
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12944147
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 13129633
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 16910733
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 17273603
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 17688467
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 18312312
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 18726083
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 19064876
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 19835143
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 20437221
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 20762909
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 21563703
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 21634667

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 392921
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 423626
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 732708
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 831385
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 866076
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1212922
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1559747
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2618580
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 3886490
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 12902791
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 14719699
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 22851675
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 23299732
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 24154407
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 25754877
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 31681065
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 34480848
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 34545007
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35352974
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 36082176
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 42237788
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 51328676
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 52537186
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 53719064
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 56864545
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 58170792
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 59071787
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 61568660
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 63029669
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 63965357
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 67170733
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 67588420

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 83.53 WHERE acctID = 705914
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 14.95 WHERE acctID = 1505318
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 132.86 WHERE acctID = 1692857
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 53.95 WHERE acctID = 1769655
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 41.99 WHERE acctID = 1973722
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 45.79 WHERE acctID = 2060241
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 2.90 WHERE acctID = 2286425
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 95.50 WHERE acctID = 2303397
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 49.95 WHERE acctID = 2998540
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 17.87 WHERE acctID = 3612797
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.56 WHERE acctID = 4104599
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 211.58 WHERE acctID = 4115324
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 41.99 WHERE acctID = 4568568
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 346.59 WHERE acctID = 4651372
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 89.82 WHERE acctID = 6448767
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 106.90 WHERE acctID = 12827907
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 18.70 WHERE acctID = 13095374
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 54.08 WHERE acctID = 15301644
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.62 WHERE acctID = 16885407
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 31.20 WHERE acctID = 17989057
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 49.95 WHERE acctID = 18271987
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 49.87 WHERE acctID = 18719517
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 220.49 WHERE acctID = 19074143
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 128.90 WHERE acctID = 21390300

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 83.53, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 83.53, RemainingMinimumDue = 83.53, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 705914
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 14.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 14.95, RemainingMinimumDue = 14.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1505318
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 132.86, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 132.86, RemainingMinimumDue = 132.86, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1692857
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 53.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 53.95, RemainingMinimumDue = 53.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1769655
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 41.99, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 41.99, RemainingMinimumDue = 41.99, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1973722
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 45.79, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 45.79, RemainingMinimumDue = 45.79, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2060241
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 2.90, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 2.90, RemainingMinimumDue = 2.90, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2286425
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 95.50, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 95.50, RemainingMinimumDue = 95.50, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2303397
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 49.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 49.95, RemainingMinimumDue = 49.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2998540
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 17.87, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 17.87, RemainingMinimumDue = 17.87, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 3612797
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 16.56, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 16.56, RemainingMinimumDue = 16.56, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 4104599
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 211.58, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 211.58, RemainingMinimumDue = 211.58, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 4115324
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 41.99, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 41.99, RemainingMinimumDue = 41.99, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 4568568
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 346.59, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 346.59, RemainingMinimumDue = 346.59, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 4651372
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 89.82, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 89.82, RemainingMinimumDue = 89.82, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 6448767
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 106.90, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 106.90, RemainingMinimumDue = 106.90, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 12827907
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 18.70, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 18.70, RemainingMinimumDue = 18.70, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 13095374
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 54.08, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 54.08, RemainingMinimumDue = 54.08, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 15301644
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 16.62, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 16.62, RemainingMinimumDue = 16.62, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 16885407
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 31.20, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 31.20, RemainingMinimumDue = 31.20, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 17989057
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 49.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 49.95, RemainingMinimumDue = 49.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 18271987
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 49.87, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 49.87, RemainingMinimumDue = 49.87, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 18719517
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 220.49, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 220.49, RemainingMinimumDue = 220.49, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 19074143
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 128.90, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 128.90, RemainingMinimumDue = 128.90, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 21390300

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 718324
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 42055323
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 10650385
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1786305
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2003382
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 44844025
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2350697
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 53028362
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 3486690
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 23990568
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 4412947
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 5696749
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 5707474
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 8556726
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 8697530
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 15670925
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 34644466
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35992992
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 46455976
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 72444808
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 55943208
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 56152654
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 58164225
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 72053549
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 71517594



UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 34480848 AND ATID = 52 AND IdentityField = 4175205743

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 423626 AND ATID = 52 AND IdentityField = 4164437575
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 718324 AND ATID = 52 AND IdentityField = 4170833707
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 732708 AND ATID = 52 AND IdentityField = 4184796707
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 831385 AND ATID = 52 AND IdentityField = 4177599451
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 866076 AND ATID = 52 AND IdentityField = 4159686829
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1212922 AND ATID = 52 AND IdentityField = 4181839358
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1559747 AND ATID = 52 AND IdentityField = 4147833810
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1786305 AND ATID = 52 AND IdentityField = 4162134668
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2003382 AND ATID = 52 AND IdentityField = 4161806406
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2350697 AND ATID = 52 AND IdentityField = 4190228243
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2618580 AND ATID = 52 AND IdentityField = 4132778031
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 4412947 AND ATID = 52 AND IdentityField = 4142544253
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 5696749 AND ATID = 52 AND IdentityField = 4181974742
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 5707474 AND ATID = 52 AND IdentityField = 4193100182
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 8556726 AND ATID = 52 AND IdentityField = 4175126538
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 8697530 AND ATID = 52 AND IdentityField = 4142421214
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 12902791 AND ATID = 52 AND IdentityField = 4131174086
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 14719699 AND ATID = 52 AND IdentityField = 4161367399
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 15670925 AND ATID = 52 AND IdentityField = 4165403037
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 22851675 AND ATID = 52 AND IdentityField = 4188793823
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 23299732 AND ATID = 52 AND IdentityField = 4177560731
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 24154407 AND ATID = 52 AND IdentityField = 4176639041
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 25754877 AND ATID = 52 AND IdentityField = 4169976421
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 31681065 AND ATID = 52 AND IdentityField = 4184539437
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 34545007 AND ATID = 52 AND IdentityField = 4137779630
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 34644466 AND ATID = 52 AND IdentityField = 4142412016
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 35992992 AND ATID = 52 AND IdentityField = 4181873273
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 36082176 AND ATID = 52 AND IdentityField = 4188590726
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 42055323 AND ATID = 52 AND IdentityField = 4184630285
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 42237788 AND ATID = 52 AND IdentityField = 4190893367
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 46455976 AND ATID = 52 AND IdentityField = 4157013871
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 51328676 AND ATID = 52 AND IdentityField = 4124458167
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 52537186 AND ATID = 52 AND IdentityField = 4140405649
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 53719064 AND ATID = 52 AND IdentityField = 4170973087
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56864545 AND ATID = 52 AND IdentityField = 4170318218
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 58164225 AND ATID = 52 AND IdentityField = 4175218729
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 58170792 AND ATID = 52 AND IdentityField = 4127060123
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 59071787 AND ATID = 52 AND IdentityField = 4161881680
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 61568660 AND ATID = 52 AND IdentityField = 4137759290
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 63029669 AND ATID = 52 AND IdentityField = 4190974996
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 63965357 AND ATID = 52 AND IdentityField = 4191291627
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 67170733 AND ATID = 52 AND IdentityField = 4186488176
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 67588420 AND ATID = 52 AND IdentityField = 4176638591


DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 423626 AND ATID = 52 AND IdentityField = 4164437576
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 732708 AND ATID = 52 AND IdentityField = 4184796708
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 831385 AND ATID = 52 AND IdentityField = 4177599452
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 866076 AND ATID = 52 AND IdentityField = 4159686830
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1212922 AND ATID = 52 AND IdentityField = 4181839359
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1559747 AND ATID = 52 AND IdentityField = 4147833811
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2618580 AND ATID = 52 AND IdentityField = 4132778032
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 12902791 AND ATID = 52 AND IdentityField = 4131174087
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 14719699 AND ATID = 52 AND IdentityField = 4161367400
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 22851675 AND ATID = 52 AND IdentityField = 4188793824
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 23299732 AND ATID = 52 AND IdentityField = 4177560732
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 24154407 AND ATID = 52 AND IdentityField = 4176639042
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 25754877 AND ATID = 52 AND IdentityField = 4169976422
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 31681065 AND ATID = 52 AND IdentityField = 4184539438
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 34545007 AND ATID = 52 AND IdentityField = 4137779631
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 36082176 AND ATID = 52 AND IdentityField = 4188590727
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 42237788 AND ATID = 52 AND IdentityField = 4190893368
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 51328676 AND ATID = 52 AND IdentityField = 4124458168
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 52537186 AND ATID = 52 AND IdentityField = 4140405650
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 53719064 AND ATID = 52 AND IdentityField = 4170973088
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56864545 AND ATID = 52 AND IdentityField = 4170318219
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 58170792 AND ATID = 52 AND IdentityField = 4127060124
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 59071787 AND ATID = 52 AND IdentityField = 4161881681
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 61568660 AND ATID = 52 AND IdentityField = 4137759291
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 63029669 AND ATID = 52 AND IdentityField = 4190974997
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 63965357 AND ATID = 52 AND IdentityField = 4191291628
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 67170733 AND ATID = 52 AND IdentityField = 4186488177
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 67588420 AND ATID = 52 AND IdentityField = 4176638592



DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 720298 AND ATID = 51 AND IdentityField = 2444608345
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 818975 AND ATID = 51 AND IdentityField = 2440749069
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 853666 AND ATID = 51 AND IdentityField = 2430894788

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1547327 AND ATID = 51 AND IdentityField = 2424409344
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '132.94' WHERE AID = 1692857 AND ATID = 51 AND IdentityField = 2428545834




DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2520360 AND ATID = 51 AND IdentityField = 2416387861
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2738743 AND ATID = 51 AND IdentityField = 2447798522





DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 5604633 AND ATID = 51 AND IdentityField = 2415515393
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 6067541 AND ATID = 51 AND IdentityField = 2431779543

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9427517 AND ATID = 51 AND IdentityField = 2446705971
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9455574 AND ATID = 51 AND IdentityField = 2440724643
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9850249 AND ATID = 51 AND IdentityField = 2440238874
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 10233982 AND ATID = 51 AND IdentityField = 2436623617
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 11951108 AND ATID = 51 AND IdentityField = 2444447397
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 12453057 AND ATID = 51 AND IdentityField = 2439481914
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 12453057 AND ATID = 51 AND IdentityField = 2439481947
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12805466 AND ATID = 51 AND IdentityField = 2419042123


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13129633 AND ATID = 51 AND IdentityField = 2446601602
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 16910733 AND ATID = 51 AND IdentityField = 2411937300
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17273603 AND ATID = 51 AND IdentityField = 2420429534
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17688467 AND ATID = 51 AND IdentityField = 2437201877
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '68.91' WHERE AID = 17989057 AND ATID = 51 AND IdentityField = 2422928657
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18312312 AND ATID = 51 AND IdentityField = 2436835813

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18726083 AND ATID = 51 AND IdentityField = 2413318616
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19064876 AND ATID = 51 AND IdentityField = 2432063649
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '235.16' WHERE AID = 19074143 AND ATID = 51 AND IdentityField = 2433352518
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19835143 AND ATID = 51 AND IdentityField = 2419029223
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 20437221 AND ATID = 51 AND IdentityField = 2447849923
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 20762909 AND ATID = 51 AND IdentityField = 2448051660
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '129.06' WHERE AID = 21390300 AND ATID = 51 AND IdentityField = 2431779783
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21563703 AND ATID = 51 AND IdentityField = 2445501641
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21634667 AND ATID = 51 AND IdentityField = 2440238574

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1200502 AND ATID = 51 AND IdentityField = 2442987218
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 411406 AND ATID = 51 AND IdentityField = 2433524558



DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 720298 AND ATID = 51 AND IdentityField = 2444608344
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 818975 AND ATID = 51 AND IdentityField = 2440749068
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 853666 AND ATID = 51 AND IdentityField = 2430894787

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1547327 AND ATID = 51 AND IdentityField = 2424409343





DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2520360 AND ATID = 51 AND IdentityField = 2416387860
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2738743 AND ATID = 51 AND IdentityField = 2447798521





DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 5604633 AND ATID = 51 AND IdentityField = 2415515392
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 6067541 AND ATID = 51 AND IdentityField = 2431779542

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9427517 AND ATID = 51 AND IdentityField = 2446705970
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9455574 AND ATID = 51 AND IdentityField = 2440724642
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9850249 AND ATID = 51 AND IdentityField = 2440238873
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 10233982 AND ATID = 51 AND IdentityField = 2436623616
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 11951108 AND ATID = 51 AND IdentityField = 2444447396
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (51728825867, '2021-12-10 18:23:47', 51, 12453057, 115, '1', '0')
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (51728825868, '2021-12-10 18:23:47', 51, 12453057, 115, '1', '0')
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12805466 AND ATID = 51 AND IdentityField = 2419042122


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13129633 AND ATID = 51 AND IdentityField = 2446601601
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 16910733 AND ATID = 51 AND IdentityField = 2411937299
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17273603 AND ATID = 51 AND IdentityField = 2420429533
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17688467 AND ATID = 51 AND IdentityField = 2437201876

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18312312 AND ATID = 51 AND IdentityField = 2436835812

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18726083 AND ATID = 51 AND IdentityField = 2413318615
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19064876 AND ATID = 51 AND IdentityField = 2432063648

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19835143 AND ATID = 51 AND IdentityField = 2419029222
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 20437221 AND ATID = 51 AND IdentityField = 2447849922
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 20762909 AND ATID = 51 AND IdentityField = 2448051659

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21563703 AND ATID = 51 AND IdentityField = 2445501640
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21634667 AND ATID = 51 AND IdentityField = 2440238573

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1200502 AND ATID = 51 AND IdentityField = 2442987217
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 411406 AND ATID = 51 AND IdentityField = 2433524557