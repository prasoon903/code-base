-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 10.75 WHERE acctId = 17543409

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RemainingMinimumDue = RemainingMinimumDue - 10.75,
NoPayDaysDelinquent = 0, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 17543409


UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 17543409 AND ATID = 51 AND IdentityField = 1861750154
UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0' WHERE AID = 17543409 AND ATID = 51 AND IdentityField = 1861750153



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 13592733

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.01, AmtOfPayXDLate = AmtOfPayXDLate + 5.01, RemainingMinimumDue = RemainingMinimumDue + 5.01,
RunningMinimumDue = RunningMinimumDue + 5.01, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
DaysDelinquent = 4, NoPayDaysDelinquent = 4 WHERE acctId = 13592733

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43897822630, '2021-08-05 02:23:21.000', 51, 13592733, 115, '1', '2'),
(43897822630, '2021-08-05 02:23:21.000', 51, 13592733, 200, '0.00', '5.01'),
(43897822630, '2021-08-05 02:23:21.000', 51, 13592733, 112, '2', '3')


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 21.16 WHERE acctId = 17643501

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.16, RemainingMinimumDue = RemainingMinimumDue - 21.16,
RunningMinimumDue = RunningMinimumDue - 21.16, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 17643501

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44445920290, '2021-08-16 19:24:50.000', 51, 17643501, 115, '1', '0'),
(44445920290, '2021-08-16 19:24:50.000', 51, 17643501, 200, '21.16', '0.00')


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 0.19 WHERE acctId = 12882682

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.19, RemainingMinimumDue = RemainingMinimumDue - 0.19,
RunningMinimumDue = RunningMinimumDue - 0.19, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 12882682

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 12882682 AND ATID = 51 AND IdentityField = 1835904843
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44284602006, '2021-08-13 08:35:10.000', 51, 12882682, 115, '1', '0')


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 3230968

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 31.92, AmtOfPayXDLate = AmtOfPayXDLate + 31.92, RemainingMinimumDue = RemainingMinimumDue + 31.92,
RunningMinimumDue = RunningMinimumDue + 31.92, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
DaysDelinquent = 11, NoPayDaysDelinquent = 11 WHERE acctId = 3230968

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3230968 AND ATID = 51 AND IdentityField = 1797021659
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3230968 AND ATID = 51 AND IdentityField = 1797021661
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3230968 AND ATID = 51 AND IdentityField = 1797021662



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.03 WHERE acctId = 10343487

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.03, RemainingMinimumDue = RemainingMinimumDue - 1.03,
RunningMinimumDue = RunningMinimumDue - 1.03, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 10343487

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 10343487 AND ATID = 51 AND IdentityField = 1794978738
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(43744841011, '2021-08-02 11:21:40.000', 51, 10343487, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 0.49 WHERE acctId = 654914

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.49, RemainingMinimumDue = RemainingMinimumDue - 0.49,
RunningMinimumDue = RunningMinimumDue - 0.49, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 654914

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 654914 AND ATID = 51 AND IdentityField = 1819182424
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44047982085, '2021-08-08 19:55:17.000', 51, 654914, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 18072885

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 49.95, AmtOfPayXDLate = AmtOfPayXDLate + 49.95, RemainingMinimumDue = RemainingMinimumDue + 49.95,
RunningMinimumDue = RunningMinimumDue + 49.95, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
DaysDelinquent = 6, NoPayDaysDelinquent = 6 WHERE acctId = 18072885

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44038998243, '2021-08-07 15:06:22.000', 51, 18072885, 115, '0', '2'),
(44038998243, '2021-08-07 15:06:22.000', 51, 18072885, 200, '0.00', '49.95'),
(44038998243, '2021-08-07 15:06:22.000', 51, 18072885, 112, '2', '3')


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.66, AmtofPayCurrDue = AmtofPayCurrDue + 1.66, EstimatedDue = EstimatedDue + 1.66, 
RollOverDue = RollOverDue - 1.66, CycleDueDTD = 1 WHERE acctId = 58971976

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 58971976 AND ATID = 52 AND IdentityField = 3118934352
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 58971976 AND ATID = 52 AND IdentityField = 3118934353



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.13 WHERE acctId = 1549088

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.13, RemainingMinimumDue = RemainingMinimumDue - 1.13,
RunningMinimumDue = RunningMinimumDue - 1.13, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 1549088

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 1549088 AND ATID = 51 AND IdentityField = 1835563390
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44282045930, '2021-08-13 05:17:02.000', 51, 1549088, 115, '1', '0')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.62, AmountOfPayment30DLate = AmountOfPayment30DLate - 2.62, CycleDueDTD = 0 WHERE acctId = 37183396

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44281451230, '2021-08-13 05:12:33.000', 52, 37183396, 115, '3', '0'),
(44281451230, '2021-08-13 05:12:33.000', 52, 37183396, 200, '2.62', '0.00')




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 17674647

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 75, AmtOfPayXDLate = AmtOfPayXDLate + 75, RemainingMinimumDue = RemainingMinimumDue + 75,
RunningMinimumDue = RunningMinimumDue + 75, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
DaysDelinquent = 17, NoPayDaysDelinquent = 17 WHERE acctId = 17674647

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 22.60, AmtOfPayXDLate = AmtOfPayXDLate + 22.60, CycleDueDTD = 2 WHERE acctId = 53665519


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17674647 AND ATID = 51 AND IdentityField = 1854792384
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17674647 AND ATID = 51 AND IdentityField = 1854792386
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 17674647 AND ATID = 51 AND IdentityField = 1854792387



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.77, AmtofPayCurrDue = AmtofPayCurrDue - 24.77, CycleDueDTD = 0 WHERE acctId = 794511

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44580009905, '2021-08-19 22:09:16.000', 52, 794511, 115, '1', '0'),
(44580009905, '2021-08-19 22:09:16.000', 52, 794511, 200, '24.77', '0.00')


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.93, AmtofPayCurrDue = AmtofPayCurrDue - 21.93, CycleDueDTD = 0 WHERE acctId = 26760013

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44595795883, '2021-08-20 07:18:34.000', 52, 26760013, 115, '1', '0'),
(44595795883, '2021-08-20 07:18:34.000', 52, 26760013, 200, '21.93', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.89 WHERE acctId = 2188937

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.89, RemainingMinimumDue = RemainingMinimumDue - 1.89,
RunningMinimumDue = RunningMinimumDue - 1.89, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2188937

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 2188937 AND ATID = 51 AND IdentityField = 1865285393
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(44673713394, '2021-08-22 02:57:45.000', 51, 2188937, 115, '1', '0')


