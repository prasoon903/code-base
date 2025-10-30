-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE TOP(1) WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 58.61 WHERE acctId = 546418
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.61, RunningMinimumDue = RunningMinimumDue - 58.61, RemainingMinimumDue = RemainingMinimumDue - 58.61, 
DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 546418

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33516197296, '2020-12-17 10:47:34.000', 51, 546418, 115, '1', '0'),
(33516197296, '2020-12-17 10:47:34.000', 51, 546418, 200, '58.61', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 31.52 WHERE acctId = 602255
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 31.52, RunningMinimumDue = RunningMinimumDue - 31.52, 
RemainingMinimumDue = RemainingMinimumDue - 31.52, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 602255

DELETE FROM CurrentBalanceAudit WHERE AID = 602255 AND ATID = 51 AND IdentityField = 926427767
DELETE FROM CurrentBalanceAudit WHERE AID = 602255 AND ATID = 51 AND IdentityField = 928341645	



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 2464147
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.93, AmtOfPayXDLate = AmtOfPayXDLate + 0.93, RunningMinimumDue = RunningMinimumDue + 0.93, 
RemainingMinimumDue = RemainingMinimumDue + 0.93, DateOfOriginalPaymentDueDTD = '2020-11-30 23:59:57', DtOfLastDelinqCTD = '2020-11-30 23:59:57', FirstDueDate = '2020-11-30 23:59:57',
DaysDelinquent = 16, NoPayDaysDelinquent = 16  WHERE acctId = 2464147

DELETE FROM CurrentBalanceAudit WHERE AID = 2464147 AND ATID = 51 AND IdentityField = 915851652
UPDATE CurrentBalanceAudit SET NewValue = '0.93' WHERE AID = 2464147 AND ATID = 51 AND IdentityField = 915851653	



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.26 WHERE acctId = 13569174
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.26, RunningMinimumDue = RunningMinimumDue - 2.26, 
RemainingMinimumDue = RemainingMinimumDue - 2.26, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 13569174

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33527298984, '2020-12-18 01:40:05.000', 51, 13569174, 115, '1', '0'),
(33527298984, '2020-12-18 01:40:05.000', 51, 13569174, 200, '2.26', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.52, AmountOfTotalDue = AmountOfTotalDue - 6.52 WHERE acctId = 2694098

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33514664269, '2020-12-17 10:03:16.000', 52, 2694098, 115, '1', '0'),
(33514664269, '2020-12-17 10:03:16.000', 52, 2694098, 200, '6.52', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.60, AmountOfTotalDue = AmountOfTotalDue - 23.60 WHERE acctId = 2176631

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33514664271, '2020-12-17 10:03:16.000', 52, 2176631, 115, '1', '0'),
(33514664271, '2020-12-17 10:03:16.000', 52, 2176631, 200, '23.60', '0.00')




UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 0.76, AmountOfTotalDue = AmountOfTotalDue + 0.76, RunningMinimumDue = RunningMinimumDue + 0.76, 
RemainingMinimumDue = RemainingMinimumDue + 0.76, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 5620100

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 0.38, AmountOfTotalDue = AmountOfTotalDue + 0.38 WHERE acctId = 13108258

UPDATE CurrentBalanceAudit SET NewValue = '132.53' WHERE AID = 5620100 AND ATID = 51 AND IdentityField = 925450264

UPDATE CurrentBalanceAuditPS SET NewValue = '1.02' WHERE AID = 13108258 AND ATID = 52 AND IdentityField = 1508123266



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.08, AmountOfTotalDue = AmountOfTotalDue - 23.08 WHERE acctId = 1597063

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33339413559, '2020-12-11 20:43:28.000', 52, 1597063, 115, '1', '0'),
(33339413559, '2020-12-11 20:43:28.000', 52, 1597063, 200, '23.08', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.36 WHERE acctId = 4255337
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.36, RunningMinimumDue = RunningMinimumDue - 1.36, RemainingMinimumDue = RemainingMinimumDue - 1.36, 
DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4255337

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(33431340288, '2020-12-14 21:02:53.000', 51, 4255337, 115, '1', '0'),
(33431340288, '2020-12-14 21:02:53.000', 51, 4255337, 200, '1.36', '0.00')