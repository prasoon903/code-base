-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.15, AmtofPayCurrDue = AmtofPayCurrDue - 24.15, CycleDueDTD = 0 WHERE acctId = 1906730

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42517076194, '2021-07-12 08:25:28.000', 52, 1906730, 115, '1', '0'),
(42517076194, '2021-07-12 08:25:28.000', 52, 1906730, 200, '24.15', '0.00')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 3.03, CycleDueDTD = 0 WHERE acctId = 344654

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.03, RunningMinimumDue = RunningMinimumDue - 3.03, 
RemainingMinimumDue = RemainingMinimumDue - 3.03 WHERE acctId = 344654

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 344654 AND ATID = 51 AND IdentityField = 1727505947
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 344654 AND ATID = 51 AND IdentityField = 1727505948



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3, AmtofPayCurrDue = AmtofPayCurrDue + 24.07 WHERE acctId = 22268

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 44.25, AmtOfPayXDLate = AmtOfPayXDLate + 20.18, RemainingMinimumDue = RemainingMinimumDue + 44.25,
RunningMinimumDue = RunningMinimumDue + 44.25, FirstDueDate = '2021-06-30 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-06-30 23:59:57.000', DtOfLastDelinqCTD = '2021-06-30 23:59:57.000', 
DaysDelinquent = 23, NoPayDaysDelinquent = 23 WHERE acctId = 22268


DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 22268 AND ATID = 51 AND IdentityField = 1730308547
DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 22268 AND ATID = 51 AND IdentityField = 1730308549
DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 22268 AND ATID = 51 AND IdentityField = 1730308550




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.86, AmtofPayCurrDue = AmtofPayCurrDue - 23.86, CycleDueDTD = 0 WHERE acctId = 35864198

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42779082502, '2021-07-18 21:53:42.000', 52, 35864198, 115, '1', '0'),
(42779082502, '2021-07-18 21:53:42.000', 52, 35864198, 200, '23.86', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 24.29 WHERE acctId = 12461269

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 24.29, RemainingMinimumDue = RemainingMinimumDue + 24.29,
RunningMinimumDue = RunningMinimumDue + 44.25 WHERE acctId = 12461269

DELETE TOP(1) FROM CurrentBalanceAudit WHERE aid = 12461269 AND ATID = 51 AND IdentityField = 1738136546



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.05, CycleDueDTD = 0 WHERE acctId = 7795592

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.05, RunningMinimumDue = RunningMinimumDue - 0.05, 
RemainingMinimumDue = RemainingMinimumDue - 0.05 WHERE acctId = 7795592

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 7795592 AND ATID = 51 AND IdentityField = 1717387885
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 7795592 AND ATID = 51 AND IdentityField = 1717387887



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 25, CycleDueDTD = 0 WHERE acctId = 2342916

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, RunningMinimumDue = RunningMinimumDue - 25, 
RemainingMinimumDue = RemainingMinimumDue - 25 WHERE acctId = 2342916

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43073711826, '2021-07-24 17:26:02.000', 51, 2342916, 115, '1', '0'),
(43073711826, '2021-07-24 17:26:02.000', 51, 2342916, 200, '25', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 24.12, CycleDueDTD = 0 WHERE acctId = 2819606

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.12, RunningMinimumDue = RunningMinimumDue - 24.12, RemainingMinimumDue = RemainingMinimumDue - 24.12,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2819606

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42514726946, '2021-07-12 05:10:10.000', 51, 2819606, 115, '1', '0'),
(42514726946, '2021-07-12 05:10:10.000', 51, 2819606, 200, '24.12', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.01, AmtofPayCurrDue = AmtofPayCurrDue - 24.01, CycleDueDTD = 0 WHERE acctId = 2454026

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42737961822, '2021-07-17 10:50:31.000', 52, 2454026, 115, '1', '0'),
(42737961822, '2021-07-17 10:50:31.000', 52, 2454026, 200, '24.01', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 29.87, CycleDueDTD = 0 WHERE acctId = 4283270

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 29.87, RunningMinimumDue = RunningMinimumDue - 69.87, RemainingMinimumDue = RemainingMinimumDue - 29.87,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4283270

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42719476348, '2021-07-16 19:49:00.000', 51, 4283270, 115, '1', '0'),
(42719476348, '2021-07-16 19:49:00.000', 51, 4283270, 200, '29.87', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.89, AmtofPayCurrDue = AmtofPayCurrDue - 24.89, CycleDueDTD = 0 WHERE acctId = 41760213

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42737948495, '2021-07-17 10:50:30.000', 52, 41760213, 115, '1', '0'),
(42737948495, '2021-07-17 10:50:30.000', 52, 41760213, 200, '24.89', '0.00')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.79, CycleDueDTD = 0 WHERE acctId = 8164094

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.79, RunningMinimumDue = RunningMinimumDue - 0.79, 
RemainingMinimumDue = RemainingMinimumDue - 0.79 WHERE acctId = 8164094

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 8164094 AND ATID = 51 AND IdentityField = 1722938021
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42920019952, '2021-07-21 07:12:45.000', 51, 8164094, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 20.79, CycleDueDTD = 0 WHERE acctId = 3518240

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.79, RunningMinimumDue = RunningMinimumDue - 20.79, RemainingMinimumDue = RemainingMinimumDue - 20.79,
FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 3518240

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(42451736456, '2021-07-10 05:59:05.000', 51, 3518240, 115, '1', '0'),
(42451736456, '2021-07-10 05:59:05.000', 51, 3518240, 200, '20.79', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.44, CycleDueDTD = 0 WHERE acctId = 2608604

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.44, RunningMinimumDue = RunningMinimumDue - 0.44, 
RemainingMinimumDue = RemainingMinimumDue - 0.44 WHERE acctId = 2608604

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 2608604 AND ATID = 51 AND IdentityField = 1734025310
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43065325420, '2021-07-24 11:35:23.000', 51, 2608604, 115, '1', '0')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.94, AmtofPayCurrDue = AmtofPayCurrDue - 2.94, CycleDueDTD = 0 WHERE acctId = 35921000

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43180322285, '2021-07-27 09:09:24.000', 52, 35921000, 115, '1', '0'),
(43180322285, '2021-07-27 09:09:24.000', 52, 35921000, 200, '2.94', '0.00')