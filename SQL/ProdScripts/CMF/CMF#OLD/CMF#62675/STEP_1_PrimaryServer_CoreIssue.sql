
-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 79859
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2776023

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 79859
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2776023

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 67.99 WHERE acctID = 4839838
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 67.99, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 67.99, RemainingMinimumDue = 67.99, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 4839838

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 79859 AND ATID = 51 AND IdentityField = 2663401406
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2776023 AND ATID = 51 AND IdentityField = 2667918128
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '67.99' WHERE AID = 4839838 AND ATID = 51 AND IdentityField = 2664590309

INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (54594719228, '2022-01-28 09:41:23', 51, 79859, 115, '1', '0')
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (54650144717, '2022-01-29 09:56:38', 51, 2776023, 115, '1', '0')




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 156786
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 956494
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 971366
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1318358
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1480867
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1530331
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2164390
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2262985
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2266121
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2303288
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2674257
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 3982845
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4505586
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 7793413
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 8203683
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9596471
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 10271208
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 11957008
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12472231
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 13711728
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 15125942
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 16512622
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 18016957
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 18260491

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 156786
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 956494
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 971366
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1318358
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1480867
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1530331
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2164390
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2262985
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2266121
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2303288
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2674257
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 3982845
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4505586
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 7793413
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 8203683
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9596471
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 10271208
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 11957008
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12472231
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 13711728
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 15125942
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 16512622
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 18016957
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 18260491


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 168836
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 968914
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 983786
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1330778
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1542751
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2197960
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2301815
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2304951
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2350588
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2813907
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 5212995
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 8323744
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 18987571
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 19929841
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 23644629
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 25992103
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 32163948
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 33644964
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 37866826
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 42814798
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 46212274
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 50283291
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 54879194
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 56077158



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 391.58 WHERE acctID = 173550
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 281.03 WHERE acctID = 1663221
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 24.95 WHERE acctID = 2773428
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 70.74 WHERE acctID = 4365006
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 52.08 WHERE acctID = 4733454
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 45.79 WHERE acctID = 5639435
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 174.73 WHERE acctID = 6031399
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 27.04 WHERE acctID = 6843369
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 58.24 WHERE acctID = 11505199
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 55.64 WHERE acctID = 13398598
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 17.04 WHERE acctID = 18528238


UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 391.58, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 391.58, RemainingMinimumDue = 391.58, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 173550
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 281.03, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 281.03, RemainingMinimumDue = 281.03, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 1663221
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 24.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 24.95, RemainingMinimumDue = 24.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 2773428
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 70.74, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 70.74, RemainingMinimumDue = 70.74, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 4365006
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 52.08, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 52.08, RemainingMinimumDue = 52.08, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 4733454
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 45.79, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 45.79, RemainingMinimumDue = 45.79, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 5639435
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 174.73, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 174.73, RemainingMinimumDue = 174.73, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 6031399
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 27.04, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 27.04, RemainingMinimumDue = 27.04, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 6843369
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 58.24, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 58.24, RemainingMinimumDue = 58.24, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 11505199
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 55.64, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 55.64, RemainingMinimumDue = 55.64, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 13398598
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 17.04, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 17.04, RemainingMinimumDue = 17.04, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 18528238


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 57736241
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 74151518
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 185620
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 40125076
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 16641527
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 14683557
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 13527593
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 9909612
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 7369156
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2947118


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0.81, AmtOfPayCurrDue = 0.81 WHERE acctID = 65546920
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 5.28, AmtOfPayCurrDue = 5.28 WHERE acctID = 1678051




DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 168836 AND ATID = 52 AND IdentityField = 4598020816
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 968914 AND ATID = 52 AND IdentityField = 4583422538
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 983786 AND ATID = 52 AND IdentityField = 4592207201
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1330778 AND ATID = 52 AND IdentityField = 4590016474
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1542751 AND ATID = 52 AND IdentityField = 4594640282
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2197960 AND ATID = 52 AND IdentityField = 4589050838
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2301815 AND ATID = 52 AND IdentityField = 4590644461
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2304951 AND ATID = 52 AND IdentityField = 4597178123
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2350588 AND ATID = 52 AND IdentityField = 4582664197
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2813907 AND ATID = 52 AND IdentityField = 4582443462
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2947118 AND ATID = 52 AND IdentityField = 4583467027
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 5212995 AND ATID = 52 AND IdentityField = 4576615381
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 7369156 AND ATID = 52 AND IdentityField = 4589722182
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 8323744 AND ATID = 52 AND IdentityField = 4597465468
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 9909612 AND ATID = 52 AND IdentityField = 4584908046
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 13527593 AND ATID = 52 AND IdentityField = 4592526293
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 14683557 AND ATID = 52 AND IdentityField = 4592444994
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 16641527 AND ATID = 52 AND IdentityField = 4592445009
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 18987571 AND ATID = 52 AND IdentityField = 4587317480
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 19929841 AND ATID = 52 AND IdentityField = 4582131717
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 23644629 AND ATID = 52 AND IdentityField = 4597577176
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 25992103 AND ATID = 52 AND IdentityField = 4590557753
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 32163948 AND ATID = 52 AND IdentityField = 4582220543
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 33644964 AND ATID = 52 AND IdentityField = 4594667633
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 37866826 AND ATID = 52 AND IdentityField = 4582572719
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 42814798 AND ATID = 52 AND IdentityField = 4602019220
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 46212274 AND ATID = 52 AND IdentityField = 4587408730
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 50283291 AND ATID = 52 AND IdentityField = 4582988465
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 54879194 AND ATID = 52 AND IdentityField = 4598014836
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56077158 AND ATID = 52 AND IdentityField = 4583061438


DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 168836 AND ATID = 52 AND IdentityField = 4598020817
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 968914 AND ATID = 52 AND IdentityField = 4583422539
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 983786 AND ATID = 52 AND IdentityField = 4592207202
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1330778 AND ATID = 52 AND IdentityField = 4590016475
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1542751 AND ATID = 52 AND IdentityField = 4594640283
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2197960 AND ATID = 52 AND IdentityField = 4589050839
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2301815 AND ATID = 52 AND IdentityField = 4590644462
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2304951 AND ATID = 52 AND IdentityField = 4597178124
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2350588 AND ATID = 52 AND IdentityField = 4582664198
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2813907 AND ATID = 52 AND IdentityField = 4582443463
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 5212995 AND ATID = 52 AND IdentityField = 4576615382
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 8323744 AND ATID = 52 AND IdentityField = 4597465469
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 18987571 AND ATID = 52 AND IdentityField = 4587317481
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 19929841 AND ATID = 52 AND IdentityField = 4582131718
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 23644629 AND ATID = 52 AND IdentityField = 4597577177
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 25992103 AND ATID = 52 AND IdentityField = 4590557754
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 32163948 AND ATID = 52 AND IdentityField = 4582220544
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 33644964 AND ATID = 52 AND IdentityField = 4594667634
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 37866826 AND ATID = 52 AND IdentityField = 4582572720
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 42814798 AND ATID = 52 AND IdentityField = 4602019221
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 46212274 AND ATID = 52 AND IdentityField = 4587408731
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 50283291 AND ATID = 52 AND IdentityField = 4582988466
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 54879194 AND ATID = 52 AND IdentityField = 4598014837
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56077158 AND ATID = 52 AND IdentityField = 4583061439


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 156786 AND ATID = 51 AND IdentityField = 2673111556
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 956494 AND ATID = 51 AND IdentityField = 2665378388
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 971366 AND ATID = 51 AND IdentityField = 2670033764
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1318358 AND ATID = 51 AND IdentityField = 2668834779
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1480867 AND ATID = 51 AND IdentityField = 2675374491
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1530331 AND ATID = 51 AND IdentityField = 2671309453
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2164390 AND ATID = 51 AND IdentityField = 2668313072
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2262985 AND ATID = 51 AND IdentityField = 2669209030
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2266121 AND ATID = 51 AND IdentityField = 2672625287
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2303288 AND ATID = 51 AND IdentityField = 2664914261
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2674257 AND ATID = 51 AND IdentityField = 2664779896

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3982845 AND ATID = 51 AND IdentityField = 2661642733

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 4505586 AND ATID = 51 AND IdentityField = 2672786371
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 7793413 AND ATID = 51 AND IdentityField = 2667415143
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 8203683 AND ATID = 51 AND IdentityField = 2664589728
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9596471 AND ATID = 51 AND IdentityField = 2672850389
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 10271208 AND ATID = 51 AND IdentityField = 2669156709
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 11957008 AND ATID = 51 AND IdentityField = 2664643828
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12472231 AND ATID = 51 AND IdentityField = 2671324515

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13711728 AND ATID = 51 AND IdentityField = 2664858724
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 15125942 AND ATID = 51 AND IdentityField = 2667467771
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 16512622 AND ATID = 51 AND IdentityField = 2665111872
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18016957 AND ATID = 51 AND IdentityField = 2673108035
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18260491 AND ATID = 51 AND IdentityField = 2665157499



DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 156786 AND ATID = 51 AND IdentityField = 2673111555
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 956494 AND ATID = 51 AND IdentityField = 2665378387
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 971366 AND ATID = 51 AND IdentityField = 2670033763
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1318358 AND ATID = 51 AND IdentityField = 2668834778
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1480867 AND ATID = 51 AND IdentityField = 2675374490
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1530331 AND ATID = 51 AND IdentityField = 2671309452
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2164390 AND ATID = 51 AND IdentityField = 2668313071
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2262985 AND ATID = 51 AND IdentityField = 2669209029
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2266121 AND ATID = 51 AND IdentityField = 2672625286
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2303288 AND ATID = 51 AND IdentityField = 2664914260
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2674257 AND ATID = 51 AND IdentityField = 2664779895

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3982845 AND ATID = 51 AND IdentityField = 2661642732

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 4505586 AND ATID = 51 AND IdentityField = 2672786370

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 7793413 AND ATID = 51 AND IdentityField = 2667415142
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 8203683 AND ATID = 51 AND IdentityField = 2664589727
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 9596471 AND ATID = 51 AND IdentityField = 2672850388
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 10271208 AND ATID = 51 AND IdentityField = 2669156708
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 11957008 AND ATID = 51 AND IdentityField = 2664643827
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12472231 AND ATID = 51 AND IdentityField = 2671324514

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13711728 AND ATID = 51 AND IdentityField = 2664858723
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 15125942 AND ATID = 51 AND IdentityField = 2667467770
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 16512622 AND ATID = 51 AND IdentityField = 2665111871
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18016957 AND ATID = 51 AND IdentityField = 2673108034
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18260491 AND ATID = 51 AND IdentityField = 2665157498


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 173.22 where  acctid  =  69514366
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 388.24 where  acctid  =  71814696
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 32.45 where  acctid  =  52740270
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 7.49 where  acctid  =  68341215
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.06 where  acctid  =  68210304
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 37.45 where  acctid  =  35899570
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.54 where  acctid  =  67205958
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 16.58 where  acctid  =  62842686
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 86.66 where  acctid  =  62842687
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 74.25 where  acctid  =  68630079
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  67657822
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.91 where  acctid  =  66173948
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.62 where  acctid  =  43711809
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 26.35 where  acctid  =  67657210
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.99 where  acctid  =  52932571
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  52932572
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  66757715
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 34.54 where  acctid  =  67034796
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 120.15 where  acctid  =  68213816
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.25 where  acctid  =  50396797
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 14.73 where  acctid  =  36111291
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.10 where  acctid  =  59078810
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  59106808
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 35.33 where  acctid  =  73552164
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 30.06 where  acctid  =  71533873
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2499.00 where  acctid  =  69535491
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  67764543
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  41926408
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.23 where  acctid  =  41309776
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 46.62 where  acctid  =  41317012
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 118.82 where  acctid  =  67284616
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.25 where  acctid  =  60439887
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 75.74 where  acctid  =  61026776
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 60.24 where  acctid  =  10949128
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 74.10 where  acctid  =  34736138
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 108.25 where  acctid  =  51071578
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 30.37 where  acctid  =  54462174
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.12 where  acctid  =  54512301
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 14.08 where  acctid  =  71845264
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 124.91 where  acctid  =  71845265
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.29 where  acctid  =  53719495
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.79 where  acctid  =  53719496
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 54.12 where  acctid  =  53406661
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  53406662
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 18.70 where  acctid  =  10728230
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.20 where  acctid  =  10728231
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.29 where  acctid  =  21269727
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 18.70 where  acctid  =  21269728
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.29 where  acctid  =  21469799
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 52.04 where  acctid  =  21469800
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 174.13 where  acctid  =  63294901
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 879.11 where  acctid  =  63294902
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  63300432
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 124.91 where  acctid  =  69891457
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  34711042
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  66807842
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 25.10 where  acctid  =  10064555
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.47 where  acctid  =  10064556
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 16.62 where  acctid  =  53371186
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  53769405
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.03 where  acctid  =  36866130
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 35.37 where  acctid  =  48458473
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 9.12 where  acctid  =  67604789
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 1099.00 where  acctid  =  70828500
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 309.00 where  acctid  =  69884722
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 129.00 where  acctid  =  69884723
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.95 where  acctid  =  19119219
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 52.04 where  acctid  =  10736148
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  10736149
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.16 where  acctid  =  72239900
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.58 where  acctid  =  72239901
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 24.91 where  acctid  =  72239902
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  10728535
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 407.75 where  acctid  =  41871511
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 40.25 where  acctid  =  41871512
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 30.05 where  acctid  =  53797565
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 249.00 where  acctid  =  72928685
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 151.51 where  acctid  =  40590743
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  40590744
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 958.56 where  acctid  =  77131286
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 33.16 where  acctid  =  59859692
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 133.51 where  acctid  =  65435444
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  41010038
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  41010040
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.04 where  acctid  =  41352898
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 153.33 where  acctid  =  74622654
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2.66 where  acctid  =  50395398
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.25 where  acctid  =  67626438
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 53.29 where  acctid  =  68892082
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.35 where  acctid  =  10849499
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.65 where  acctid  =  10849500
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.91 where  acctid  =  41913728
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.25 where  acctid  =  42082198
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.91 where  acctid  =  67746966
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.41 where  acctid  =  69800042
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 5.00 where  acctid  =  62940286
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  62632968
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 61.66 where  acctid  =  62632969
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.79 where  acctid  =  48448318
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 12.45 where  acctid  =  26112609
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 400.00 where  acctid  =  72576378
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 1.93 where  acctid  =  67106727
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.87 where  acctid  =  44621618
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 108.25 where  acctid  =  52750091
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.58 where  acctid  =  70636543
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 54.93 where  acctid  =  30492854
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 214.50 where  acctid  =  52605640
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 339.17 where  acctid  =  71826580
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.82 where  acctid  =  55440261
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 53.00 where  acctid  =  55441949
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.82 where  acctid  =  57728500
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.29 where  acctid  =  34628488
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 36.62 where  acctid  =  34663058
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.20 where  acctid  =  34663122
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  35922039
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 34.54 where  acctid  =  69548915
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  37881127
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  66475045
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 44.92 where  acctid  =  68321941
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 569.00 where  acctid  =  70849868
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 274.82 where  acctid  =  66240214
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 40.84 where  acctid  =  67624714
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 190.71 where  acctid  =  68450777
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 391.96 where  acctid  =  68450778
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 277.89 where  acctid  =  71830552
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 42.22 where  acctid  =  45328801
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 43.00 where  acctid  =  51027847
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 219.75 where  acctid  =  47221824
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.25 where  acctid  =  47221825
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  66719828
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.73 where  acctid  =  70832075
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 110.55 where  acctid  =  49940174
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 59.90 where  acctid  =  51071857
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 30.37 where  acctid  =  72434706
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 23.45 where  acctid  =  51826192
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.41 where  acctid  =  51826193
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 208.99 where  acctid  =  51812903
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.00 where  acctid  =  52280908
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 39.78 where  acctid  =  53769345
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 40.79 where  acctid  =  53769346
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  57543546
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 10.75 where  acctid  =  55651141
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.79 where  acctid  =  53707234
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  53707235
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.11 where  acctid  =  54467352
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 44.43 where  acctid  =  60479914
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 74.91 where  acctid  =  54950107
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.87 where  acctid  =  54465449
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 88.07 where  acctid  =  61197132
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  61197133
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.91 where  acctid  =  61197134
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.91 where  acctid  =  62837533
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 693.79 where  acctid  =  67151393
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  67214480
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  67214654
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.70 where  acctid  =  56851682
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.87 where  acctid  =  68640912
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.29 where  acctid  =  68640913
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 33.16 where  acctid  =  72302505
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 33.16 where  acctid  =  72302644
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.33 where  acctid  =  72303994
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  57069857
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2.04 where  acctid  =  57108490
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 13.70 where  acctid  =  57108491
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 39.36 where  acctid  =  67324714
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 32.68 where  acctid  =  67476318
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 36.76 where  acctid  =  68414687
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 74.25 where  acctid  =  68414688
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 22.61 where  acctid  =  58473545
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 124.50 where  acctid  =  61334675
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.16 where  acctid  =  65961352
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.16 where  acctid  =  66467052
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 34.08 where  acctid  =  67221161
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 31.75 where  acctid  =  64588406
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 418.46 where  acctid  =  66000201
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 53.00 where  acctid  =  66095353
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.79 where  acctid  =  65384997
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 25.74 where  acctid  =  67389356
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 7.95 where  acctid  =  66434181
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.91 where  acctid  =  66462026
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  66462027
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 34.54 where  acctid  =  67041436
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  66996239
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.75 where  acctid  =  68211086
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 19.95 where  acctid  =  69534679
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 23.70 where  acctid  =  68894011
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 34.82 where  acctid  =  68091403
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 48.00 where  acctid  =  71540961
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.87 where  acctid  =  71807966
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.62 where  acctid  =  69548870
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68408282
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68408283


update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =274890
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =606462
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =729929
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =909847
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =1231245
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1918293
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =1978175
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2544976
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =3148805
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =16961752
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =580061
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1050236
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1644888
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1925534
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1962468
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =2150390
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =2548308
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '6' where    acctid  =3153147
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =3520924
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1774271
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =5637861
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =307650
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =10658032
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =4944321



update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =274890
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =606462
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =729929
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =909847
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1231245
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1918293
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1978175
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2544976
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =3148805
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =16961752
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =580061
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1050236
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1644888
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1925534
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1962468
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2150390
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2548308
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =3153147
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =3520924
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1774271
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =5637861
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =307650
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =10658032
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =4944321

