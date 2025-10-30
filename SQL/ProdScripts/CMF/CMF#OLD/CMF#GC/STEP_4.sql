-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.48, AmtofPayCurrDue = AmtofPayCurrDue - 3.48, CycleDueDTD = 0 WHERE acctId = 1276881

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46591867708, '2021-09-24 10:05:35.000', 52, 1276881, 115, '1', '0'),
(46591867708, '2021-09-24 10:05:35.000', 52, 1276881, 200, '3.48', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtofPayCurrDue = AmtofPayCurrDue + 26.16 WHERE acctId = 232236

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 26.16, RemainingMinimumDue = RemainingMinimumDue + 26.16,
RunningMinimumDue = RunningMinimumDue + 26.16, FirstDueDate = '2021-09-30 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 232236

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46429598832, '2021-09-21 16:34:53.000', 51, 232236, 115, '0', '1'),
(46429598832, '2021-09-21 16:34:53.000', 51, 232236, 200, '0.00', '26.16')

