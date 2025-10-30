-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 253444
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1752869
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 3296391
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4346379
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4364500
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 5896732
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12474507
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 18312304
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 21886228

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 253444
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1752869
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 3296391
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4346379
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4364500
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 5896732
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12474507
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 18312304
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 21886228


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 265514
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1769329
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 3894541
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 6776529
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 7366650
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 14428890
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 33651960
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 56864535
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 68307323


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 39.87 WHERE acctID = 2534316
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 39.87, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 39.87, RemainingMinimumDue = 39.87, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2534316


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2633626






DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 265514 AND ATID = 52 AND IdentityField = 4193204700
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1769329 AND ATID = 52 AND IdentityField = 4198278834
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2633626 AND ATID = 52 AND IdentityField = 4198346895
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 3894541 AND ATID = 52 AND IdentityField = 4198268947
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 6776529 AND ATID = 52 AND IdentityField = 4198267809
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 14428890 AND ATID = 52 AND IdentityField = 4198252000
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 33651960 AND ATID = 52 AND IdentityField = 4198280010
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56864535 AND ATID = 52 AND IdentityField = 4198247921
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 68307323 AND ATID = 52 AND IdentityField = 4193220902


UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 7366650 AND ATID = 52 AND IdentityField = 4198329582


DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 265514 AND ATID = 52 AND IdentityField = 4193204701
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1769329 AND ATID = 52 AND IdentityField = 4198278835
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 3894541 AND ATID = 52 AND IdentityField = 4198268948
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 6776529 AND ATID = 52 AND IdentityField = 4198267810
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 14428890 AND ATID = 52 AND IdentityField = 4198252001
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 33651960 AND ATID = 52 AND IdentityField = 4198280011
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56864535 AND ATID = 52 AND IdentityField = 4198247922
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 68307323 AND ATID = 52 AND IdentityField = 4193220903


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 253444 AND ATID = 51 AND IdentityField = 2449075450
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1752869 AND ATID = 51 AND IdentityField = 2451762722

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3296391 AND ATID = 51 AND IdentityField = 2451756413
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 4346379 AND ATID = 51 AND IdentityField = 2451755673
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4364500 AND ATID = 51 AND IdentityField = 2451795040
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 5896732 AND ATID = 51 AND IdentityField = 2451745954
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12474507 AND ATID = 51 AND IdentityField = 2451763502
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18312304 AND ATID = 51 AND IdentityField = 2451743484
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21886228 AND ATID = 51 AND IdentityField = 2449085617


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 253444 AND ATID = 51 AND IdentityField = 2449075449
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1752869 AND ATID = 51 AND IdentityField = 2451762721

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3296391 AND ATID = 51 AND IdentityField = 2451756412
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 4346379 AND ATID = 51 AND IdentityField = 2451755672
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (51927300772, '2021-12-13 16:17:04', 51, 4364500, 115, '1', '0')
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 5896732 AND ATID = 51 AND IdentityField = 2451745953
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12474507 AND ATID = 51 AND IdentityField = 2451763501
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 18312304 AND ATID = 51 AND IdentityField = 2451743483
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 21886228 AND ATID = 51 AND IdentityField = 2449085616