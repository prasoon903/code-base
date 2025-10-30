-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.98 WHERE acctId = 1848639

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.98, RemainingMinimumDue = RemainingMinimumDue - 0.98,
RunningMinimumDue = RunningMinimumDue - 0.98 WHERE acctId = 1848639

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.98, AmtofPayCurrDue = AmtofPayCurrDue - 0.98, CycleDueDTD = 0 WHERE acctId = 4868438

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '101.40' WHERE AID = 1848639 AND ATID = 51 AND IdentityField = 2036479100

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46800939262, '2021-09-28 22:53:38.000', 52, 4868438, 115, '1', '0'),
(46800939262, '2021-09-28 22:53:38.000', 52, 4868438, 200, '0.98', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 1.34 WHERE acctId = 2246218

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.34, RemainingMinimumDue = RemainingMinimumDue - 1.34,
RunningMinimumDue = RunningMinimumDue - 1.34 WHERE acctId = 2246218

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.34, AmtofPayCurrDue = AmtofPayCurrDue - 1.34, CycleDueDTD = 0 WHERE acctId = 15799136

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '76.48' WHERE AID = 2246218 AND ATID = 51 AND IdentityField = 2035291315

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46784689371, '2021-09-28 19:23:57.000', 52, 15799136, 115, '1', '0'),
(46784689371, '2021-09-28 19:23:57.000', 52, 15799136, 200, '1.34', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.27, CycleDueDTD = 0 WHERE acctId = 2354434

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.27, RemainingMinimumDue = RemainingMinimumDue - 0.27,
RunningMinimumDue = RunningMinimumDue - 0.27, NopayDaysDelinquent = 0, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2354434

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.27, AmtofPayCurrDue = AmtofPayCurrDue - 0.27, CycleDueDTD = 0 WHERE acctId = 2411434

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 2354434 AND ATID = 51 AND IdentityField = 1968818633
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0' WHERE AID = 2354434 AND ATID = 51 AND IdentityField = 1968818632

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2411434 AND ATID = 52 AND IdentityField = 3337995454
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0' WHERE AID = 2411434 AND ATID = 52 AND IdentityField = 3337995455




UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.54, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.54, RemainingMinimumDue = RemainingMinimumDue - 0.56,
RunningMinimumDue = RunningMinimumDue - 0.56 WHERE acctId = 2408770

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.54, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.54, CycleDueDTD = 0 WHERE acctId = 13345032

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1181.81' WHERE AID = 2408770 AND ATID = 51 AND IdentityField = 1980842016

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46067164057, '2021-09-13 18:06:00.000', 52, 13345032, 115, '1', '0'),
(46067164057, '2021-09-13 18:06:00.000', 52, 13345032, 200, '0.54', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.07, CycleDueDTD = 0 WHERE acctId = 7902164

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.07, RemainingMinimumDue = RemainingMinimumDue - 0.07,
RunningMinimumDue = RunningMinimumDue - 0.07, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 7902164

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.07, AmtofPayCurrDue = AmtofPayCurrDue - 0.07, CycleDueDTD = 0 WHERE acctId = 62034990

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 7902164 AND ATID = 51 AND IdentityField = 1942750980

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45558020064, '2021-09-03 14:16:49.000', 51, 7902164, 115, '1', '0')

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45558020064, '2021-09-03 14:16:49.000', 52, 62034990, 115, '1', '0'),
(45558020064, '2021-09-03 14:16:49.000', 52, 62034990, 200, '0.07', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 11.69, CycleDueDTD = 0 WHERE acctId = 9045922

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.69, RemainingMinimumDue = RemainingMinimumDue - 57,
RunningMinimumDue = RunningMinimumDue - 57, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 9045922

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.69, AmtofPayCurrDue = AmtofPayCurrDue - 11.69, CycleDueDTD = 0 WHERE acctId = 53273096

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9045922 AND ATID = 51 AND IdentityField = 1995331136

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46257690655, '2021-09-17 16:58:53.000', 51, 9045922, 115, '1', '0')

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46257690655, '2021-09-17 16:58:53.000', 52, 53273096, 115, '1', '0'),
(46257690655, '2021-09-17 16:58:53.000', 52, 53273096, 200, '11.69', '0.00')



UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, CycleDueDTD = 0 WHERE acctId = 13528768

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.26, AmtofPayXDLate = AmtofPayXDLate - 6.26, RemainingMinimumDue = RemainingMinimumDue - 6.26,
RunningMinimumDue = RunningMinimumDue - 6.26, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 13528768

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.26, AmtofPayXDLate = AmtofPayXDLate - 6.26, CycleDueDTD = 0 WHERE acctId = 56742047

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 13528768 AND ATID = 51 AND IdentityField = 2012347501

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46494319538, '2021-09-22 16:05:02.000', 51, 13528768, 115, '2', '0'),
(46494319538, '2021-09-22 16:05:02.000', 51, 13528768, 112, '3', '2')

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(46494319538, '2021-09-22 16:05:02.000', 52, 56742047, 115, '2', '0'),
(46494319538, '2021-09-22 16:05:02.000', 52, 56742047, 200, '6.26', '0.00')
