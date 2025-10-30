-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 30.53 WHERE acctId = 9752151

UPDATE TOP(1) BSegmentCreditCard SET AmountOfPayment30DLate = AmountOfPayment30DLate + 35.22, AmountOfTotalDue = AmountOfTotalDue + 65.75,
RunningMinimumDue = RunningMinimumDue + 65.75, RemainingMinimumDue = RemainingMinimumDue + 65.75 WHERE acctId = 9752151

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 30.53, AmtofPayCurrDue = AmtofPayCurrDue + 30.53, CycleDueDTD = 1 WHERE acctId = 24052309


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '395.91' WHERE AID = 9752151 AND ATID = 51 AND IdentityField = 1313066838


UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '30.53' WHERE AID = 24052309 AND ATID = 52 AND IdentityField = 2181710044

DELETE TOP(1) CurrentBalanceAuditPS WHERE AID = 24052309 AND ATID = 52 AND IdentityField = 2181710045




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 37.25, CycleDueDTD = 0 WHERE acctId = 4959190

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 37.25,RunningMinimumDue = RunningMinimumDue - 37.25, 
RemainingMinimumDue = RemainingMinimumDue - 37.25, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4959190

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(38570235943, '2021-04-26 09:34:04.000', 51, 4959190, 115, '1', '0'),
(38570235943, '2021-04-26 09:34:04.000', 51, 4959190, 200, '37.25', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.41, AmtofPayCurrDue = AmtofPayCurrDue - 24.41, CycleDueDTD = 0 WHERE acctId = 40405900

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(38231613465, '2021-04-15 11:54:50.000', 52, 40405900, 115, '1', '0'),
(38231613465, '2021-04-15 11:54:50.000', 52, 40405900, 200, '24.41', '0.00')



UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, CycleDueDTD = 2 WHERE acctId = 4333349

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 47.77, AmtOfPayXDLate = AmtOfPayXDLate + 47.77,RunningMinimumDue = RunningMinimumDue + 47.77, 
RemainingMinimumDue = RemainingMinimumDue + 47.77, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57.000', FirstDueDate = '2021-03-31 23:59:57.000',
DtOfLastDelinqCTD = '2021-03-31 23:59:57.000', DaysDelinquent = 12, NoPayDaysDelinquent = 12 WHERE acctId = 4333349

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(38154866371, '2021-04-13 06:10:23.000', 51, 4333349, 115, '0', '2'),
(38154866371, '2021-04-13 06:10:23.000', 51, 4333349, 200, '0.00', '47.77')



UPDATE TOP(1) BSegment_Primary SET DateAcctClosed = '2021-03-05 10:32:35.000' WHERE acctId = 11092449