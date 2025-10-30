-- TO BE RUN ON PRIMARY SERVER ONLY



USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, CycleDueDTD = 1 WHERE acctId = 4919331
UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 49.13, AmountOfTotalDue = AmountOfTotalDue - 49.13,
DtOfLastDelinqCTD = NULL, DaysDelinquent = 0 WHERE acctId = 4919331


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 53.93, AmtOfPayCurrDue = AmtOfPayCurrDue + 53.93 WHERE acctId = 10449489


UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 4.8, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.8, 
MinimumPaymentDue = MinimumPaymentDue + 4.8 WHERE acctId = 4919331 AND StatementID = 76431663


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '58.73' WHERE AID = 4919331 AND ATID = 51 AND IdentityField = 1519068896

UPDATE TOP(1) CurrentBalanceAudit SET OldValue = '58.73', NewValue = '53.93' WHERE AID = 4919331 AND ATID = 51 AND IdentityField = 1527639122

DELETE TOP(1) CurrentBalanceAudit WHERE AID = 4919331 AND ATID = 51 AND IdentityField = 1527639116
DELETE TOP(1) CurrentBalanceAudit WHERE AID = 4919331 AND ATID = 51 AND IdentityField = 1527639119


UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 370915
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 2172341
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 2189937
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 2199023
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 2478772
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 2948431
UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = '2021-05-31 23:59:57', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, NopayDaysDelinquent = 1 WHERE acctId = 12622798