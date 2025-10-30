-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 7.52, CycleDueDTD = 0 WHERE acctId = 3646599

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.52, RunningMinimumDue = RunningMinimumDue - 7.52, RemainingMinimumDue = RemainingMinimumDue - 7.52,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 3646599

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(40800025468, '2021-06-07 21:07:23.000', 51, 3646599, 115, '1', '0'),
(40800025468, '2021-06-07 21:07:23.000', 51, 3646599, 200, '7.52', '0.00')





--UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.13, AmtofPayCurrDue = AmtofPayCurrDue - 22.13, CycleDueDTD = 0 WHERE acctId = 30556701

--INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
--VALUES
--(40978799290, '2021-06-12 05:57:01.000', 52, 30556701, 115, '1', '0'),
--(40978799290, '2021-06-12 05:57:01.000', 52, 30556701, 200, '22.13', '0.00')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.47, AmtofPayCurrDue = AmtofPayCurrDue - 24.47, CycleDueDTD = 0 WHERE acctId = 2224967

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(41206409677, '2021-06-17 20:50:16.000', 52, 2224967, 115, '1', '0'),
(41206409677, '2021-06-17 20:50:16.000', 52, 2224967, 200, '22.13', '0.00')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 43.35, CycleDueDTD = 0 WHERE acctId = 497476

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 43.35, RunningMinimumDue = RunningMinimumDue - 43.35, RemainingMinimumDue = RemainingMinimumDue - 43.35,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 497476

UPDATE TOP(1) CurrentBalanceAudit SET newvalue = '0.00' WHERE aid = 497476 AND ATID = 51 AND IdentityField = 1559374843

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(40917094539, '2021-06-10 15:56:57.000', 51, 497476, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 8.26 WHERE acctId = 292376

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.26, RunningMinimumDue = RunningMinimumDue + 8.26, RemainingMinimumDue = RemainingMinimumDue + 8.26 WHERE acctId = 292376

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9, AmtofPayCurrDue = AmtofPayCurrDue - 9 WHERE acctId = 304466

UPDATE TOP(1) CurrentBalanceAudit SET newvalue = '8.50' WHERE aid = 292376 AND ATID = 51 AND IdentityField = 1584748273

UPDATE TOP(1) CurrentBalanceAuditPS SET newvalue = '8.50' WHERE aid = 304466 AND ATID = 52 AND IdentityField = 2662144754



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1711602

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.60, AmtOfPayXDLate = AmtOfPayXDLate - 38.60, RemainingMinimumDue = RemainingMinimumDue - 38.60,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1711602

UPDATE TOP(1) CurrentBalanceAudit SET newvalue = '0.00' WHERE aid = 1711602 AND ATID = 51 AND IdentityField = 1541336991

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(40680425649, '2021-06-04 14:23:53.000', 51, 1711602, 115, '2', '0'),
(40680425649, '2021-06-04 14:23:53.000', 51, 1711602, 112, '3', '2')




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 16937633

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 31.98, AmtOfPayXDLate = AmtOfPayXDLate + 31.98, RemainingMinimumDue = RemainingMinimumDue + 31.98,
RunningMinimumDue = RunningMinimumDue + 31.98, FirstDueDate = '2021-05-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57.000', DtOfLastDelinqCTD = '2021-05-31 23:59:57.000', 
DaysDelinquent = 12, NoPayDaysDelinquent = 12 WHERE acctId = 16937633


UPDATE TOP(1) CurrentBalanceAudit SET newvalue = '44.98' WHERE aid = 16937633 AND ATID = 51 AND IdentityField = 1533369770
DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 16937633 AND ATID = 51 AND IdentityField = 1533369769
DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 16937633 AND ATID = 51 AND IdentityField = 1533369767

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(40680425649, '2021-06-04 14:23:53.000', 51, 16937633, 200, '44.98', '31.98')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 0.08 WHERE acctId = 2784036

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.08, RemainingMinimumDue = RemainingMinimumDue + 0.08, RunningMinimumDue = RunningMinimumDue + 0.08 WHERE acctId = 2784036

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.08, AmtofPayCurrDue = AmtofPayCurrDue - 0.08 WHERE acctId = 48832536

UPDATE TOP(1) CurrentBalanceAudit SET newvalue = '2.04' WHERE aid = 2784036 AND ATID = 51 AND IdentityField = 1603318499

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(41482589841, '2021-06-24 17:02:00.000', 52, 48832536, 200, '2.12', '2.04')


