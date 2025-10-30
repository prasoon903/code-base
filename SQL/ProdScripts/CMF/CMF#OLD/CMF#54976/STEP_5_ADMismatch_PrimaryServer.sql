-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43317576718 AND ArTxnType = '93'


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtofPayCurrDue = AmtofPayCurrDue - 30.30 WHERE acctId = 15709599

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 61.10, AmtOfPayXDLate = AmtOfPayXDLate - 30.80, RemainingMinimumDue = RemainingMinimumDue - 61.10,
RunningMinimumDue = RunningMinimumDue - 61.10, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 15709599

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1748695935
UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1748695934
UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '2' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1748695932



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.95, AmtofPayCurrDue = AmtofPayCurrDue - 16.95, CycleDueDTD = 0 WHERE acctId = 52574837

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43300986481, '2021-07-29 21:24:30.000', 52, 52574837, 115, '1', '0'),
(43300986481, '2021-07-29 21:24:30.000', 52, 52574837, 200, '16.95', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 1.07, CycleDueDTD = 0 WHERE acctId = 600259

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.07, RunningMinimumDue = RunningMinimumDue - 1.07, 
RemainingMinimumDue = RemainingMinimumDue - 1.07, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 600259

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 600259 AND ATID = 51 AND IdentityField = 1756461378
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43342483188, '2021-07-30 12:40:20.000', 51, 600259, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 3.25, CycleDueDTD = 0 WHERE acctId = 4892550

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.25, RunningMinimumDue = RunningMinimumDue - 3.25, 
RemainingMinimumDue = RemainingMinimumDue - 3.25, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4892550

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 4892550 AND ATID = 51 AND IdentityField = 1750474281
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43272717559, '2021-07-29 12:29:18.000', 51, 4892550, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.02, CycleDueDTD = 0 WHERE acctId = 4920376

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.02, RunningMinimumDue = RunningMinimumDue - 0.02, 
RemainingMinimumDue = RemainingMinimumDue - 0.02, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 4920376

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 4920376 AND ATID = 51 AND IdentityField = 1750379863
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43271281727, '2021-07-29 11:15:13.000', 51, 4920376, 115, '1', '0')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 10.75, CycleDueDTD = 0 WHERE acctId = 2604330

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RunningMinimumDue = RunningMinimumDue - 10.75, 
RemainingMinimumDue = RemainingMinimumDue - 10.75, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2604330

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2604330 AND ATID = 51 AND IdentityField = 1753485922
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2604330 AND ATID = 51 AND IdentityField = 1753485921



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 0.64, CycleDueDTD = 0 WHERE acctId = 2563655

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.64, RunningMinimumDue = RunningMinimumDue - 0.64, 
RemainingMinimumDue = RemainingMinimumDue - 0.64, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2563655

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 2563655 AND ATID = 51 AND IdentityField = 1753844105
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43315043678, '2021-07-30 06:05:06.000', 51, 2563655, 115, '1', '0')
