-- TO BE RUN ON PRIMARY SERVER ONLY



USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 24.92 WHERE acctId = 3751544

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 39.93, RunningMinimumDue = RunningMinimumDue - 39.93, RemainingMinimumDue = RemainingMinimumDue - 39.93,
AmtOfPayXDLate = AmtOfPayXDLate - 15.01, DaysDelinquent = 0, NoPayDaysDelinquent = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 3751544

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 3751544 AND ATID = 51 AND IdentityField = 1733170935
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43041386401, '2021-07-24 09:14:39.000', 51, 3751544, 115, '2', '0'),
(43041386401, '2021-07-24 09:14:39.000', 51, 3751544, 112, '3', '2')


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 39.93, AmtofPayCurrDue = AmtofPayCurrDue - 24.92, AmtOfPayXDLate = AmtOfPayXDLate - 15.01,
CycleDueDTD = 0 WHERE acctId = 4663694

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 4663694 AND ATID = 52 AND IdentityField = 2925856034
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43041386401, '2021-07-24 09:14:39.000', 52, 4663694, 115, '2', '0')