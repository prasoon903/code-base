-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 13550780
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 42.90, AmtOfPayXDLate = AmtOfPayXDLate + 42.90, RunningMinimumDue = RunningMinimumDue + 42.90, 
RemainingMinimumDue = RemainingMinimumDue + 42.90, DateOfOriginalPaymentDueDTD = '2020-12-31 23:59:57', DaysDelinquent = 11, NoPayDaysDelinquent = 11,
FirstDueDate = '2020-12-31 23:59:57', DtOfLastDelinqCTD = '2020-12-31 23:59:57'  WHERE acctId = 13550780

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13550780 AND ATID = 51 AND IdentityField = 1005921173
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13550780 AND ATID = 51 AND IdentityField = 1005921175
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '52.89' WHERE AID = 13550780 AND ATID = 51 AND IdentityField = 1005921176
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(34454506081, '2021-01-11 06:05:05.000', 51, 13550780, 200, '52.89', '42.90')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 18.72, AmountOfTotalDue = AmountOfTotalDue + 18.72 WHERE acctId = 36883710

UPDATE  TOP(1) CurrentBalanceAuditPS SET NewValue = '18.72' WHERE AID = 36883710 AND ATID = 52 AND IdentityField = 1664394958
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 36883710 AND ATID = 52 AND IdentityField = 1664394959




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 8942680
UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 180.66, AmountOfTotalDue = AmountOfTotalDue + 180.66, RunningMinimumDue = RunningMinimumDue + 180.66, 
RemainingMinimumDue = RemainingMinimumDue + 180.66, DateOfOriginalPaymentDueDTD = '2020-12-31 23:59:57', DaysDelinquent = 10, NoPayDaysDelinquent = 10,
FirstDueDate = '2020-12-31 23:59:57', DtOfLastDelinqCTD = '2020-12-31 23:59:57'  WHERE acctId = 8942680

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(34274945874, '2021-01-06 10:03:11.000', 51, 8942680, 115, '0', '2'),
(34274945874, '2021-01-06 10:03:11.000', 51, 8942680, 200, '0.00', '180.66')

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 21652838

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 21652838 AND ATID = 52 AND IdentityField = 1645543310



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 5.80 WHERE acctId = 2208372
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.80, RunningMinimumDue = RunningMinimumDue + 73.95, 
RemainingMinimumDue = RemainingMinimumDue + 5.80  WHERE acctId = 2208372

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2208372 AND ATID = 51 AND IdentityField = 1012945766



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 4866741
UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 60.33, AmountOfTotalDue = AmountOfTotalDue - 60.33, 
RemainingMinimumDue = RemainingMinimumDue - 60.33, DateOfOriginalPaymentDueDTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0,
FirstDueDate = NULL, DtOfLastDelinqCTD = NULL  WHERE acctId = 4866741


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4866741 AND ATID = 51 AND IdentityField = 1008416214
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(34364347376, '2021-01-07 20:05:05.000', 51, 4866741, 115, '2', '0')



UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 9.99, AmountOfTotalDue = AmountOfTotalDue + 9.99 WHERE acctId = 40577751

UPDATE  TOP(1) CurrentBalanceAuditPS SET NewValue = '21.83' WHERE AID = 40577751 AND ATID = 52 AND IdentityField = 1673224486