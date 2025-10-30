-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4607313
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4607313

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 42890655


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 21.74 WHERE acctID = 1559483
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 241.52 WHERE acctID = 11200667
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 24.95 WHERE acctID = 11208615
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 99.91 WHERE acctID = 12268870
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 159.39 WHERE acctID = 18714930
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 105.35 WHERE acctID = 20732344

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 21.74, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 21.74, RemainingMinimumDue = 21.74, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1559483
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 241.52, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 241.52, RemainingMinimumDue = 241.52, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 11200667
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 24.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 24.95, RemainingMinimumDue = 24.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 11208615
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 99.91, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 99.91, RemainingMinimumDue = 99.91, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 12268870
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 159.39, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 159.39, RemainingMinimumDue = 159.39, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 18714930
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 105.35, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 105.35, RemainingMinimumDue = 105.35, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 20732344


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 38834484
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 60940358
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35197538
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 33352845

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 21.74, AmtOfPayCurrDue = 21.74 WHERE acctID = 1571903
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 1.27, AmtOfPayCurrDue = 1.27 WHERE acctID = 63702792



UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 35197538 AND ATID = 52 AND IdentityField = 4202284999
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 60940358 AND ATID = 52 AND IdentityField = 4201326620
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '1.27' WHERE AID = 63702792 AND ATID = 52 AND IdentityField = 4204921239

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4607313 AND ATID = 51 AND IdentityField = 2454165750
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '34.75' WHERE AID = 11208615 AND ATID = 51 AND IdentityField = 2453932721
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '107.21' WHERE AID = 12268870 AND ATID = 51 AND IdentityField = 2453018154

INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (51977299009, '2021-12-14 09:12:48', 51, 4607313, 115, '1', '0')