-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 19.79 WHERE acctId = 2541956

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.79, RemainingMinimumDue = RemainingMinimumDue - 19.79,
RunningMinimumDue = RunningMinimumDue - 19.79, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 2541956

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45502344597, '2021-09-02 15:37:12.000', 51, 2541956, 115, '1', '0'),
(45502344597, '2021-09-02 15:37:12.000', 51, 2541956, 200, '19.79', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 58.29 WHERE acctId = 4335402

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.29, RemainingMinimumDue = RemainingMinimumDue - 58.29, 
DateOfOriginalPaymentDueDTD = NULL, NoPayDaysDelinquent = 0, FirstDueDate = NULL WHERE acctId = 4335402

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 4335402 AND ATID = 51 AND IdentityField = 1943503364
UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0' WHERE AID = 4335402 AND ATID = 51 AND IdentityField = 1943503363



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 3.10 WHERE acctId = 4867106

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.10, RemainingMinimumDue = RemainingMinimumDue - 3.10,
RunningMinimumDue = RunningMinimumDue - 3.10, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 4867106

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45660153207, '2021-09-05 00:00:05.000', 51, 4867106, 115, '1', '0'),
(45660153207, '2021-09-05 00:00:05.000', 51, 4867106, 200, '3.10', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.13 WHERE acctId = 2583520

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.13, RemainingMinimumDue = RemainingMinimumDue - 1.13,
RunningMinimumDue = RunningMinimumDue - 1.13, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 2583520

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45566493045, '2021-09-03 16:46:56.000', 51, 2583520, 115, '1', '0'),
(45566493045, '2021-09-03 16:46:56.000', 51, 2583520, 200, '1.13', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.23, AmtofPayCurrDue = AmtofPayCurrDue - 1.23, CycleDueDTD = 0 WHERE acctId = 20359719

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(45678633717, '2021-09-05 15:11:24.000', 52, 20359719, 115, '1', '0'),
(45678633717, '2021-09-05 15:11:24.000', 52, 20359719, 200, '1.23', '0.00')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.85, AmtofPayCurrDue = AmtofPayCurrDue + 0.85, CycleDueDTD = 1 WHERE acctId = 3790536

UPDATE TOP(1) CurrentBalanceAuditPS SET Newvalue = '0.85' WHERE AID = 3790536 AND ATID = 52 AND IdentityField = 3287582787
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 3790536 AND ATID = 52 AND IdentityField = 3287582788



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtofPayCurrDue = AmtofPayCurrDue + 0.79 WHERE acctId = 2435435

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.79, RemainingMinimumDue = RemainingMinimumDue + 0.79,
RunningMinimumDue = RunningMinimumDue + 0.79, FirstDueDate = '2021-09-30 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 2435435

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.79' WHERE AID = 2435435 AND ATID = 51 AND IdentityField = 1942075666
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2435435 AND ATID = 51 AND IdentityField = 1942075665
