-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 17962443

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 125.75, AmtOfPayXDLate = AmtOfPayXDLate - 125.75, RemainingMinimumDue = RemainingMinimumDue - 125.75, 
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 17962443


UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 17962443 AND ATID = 51 AND IdentityField = 2103584942
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(47554178512, '2021-10-05 23:41:43.000', 51, 17962443, 115, '2', '0'),
(47554178512, '2021-10-05 23:41:43.000', 51, 17962443, 112, '3', '2')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 18.16 WHERE acctId = 11207769

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 18.16, RemainingMinimumDue = RemainingMinimumDue + 18.16,
RunningMinimumDue = RunningMinimumDue + 18.16 WHERE acctId = 11207769

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '174.74' WHERE AID = 11207769 AND ATID = 51 AND IdentityField = 2132296676




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1004246

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.69, AmtOfPayXDLate = AmtOfPayXDLate - 0.69, RemainingMinimumDue = RemainingMinimumDue - 0.69, 
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1004246


INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(47591897624, '2021-10-06 16:05:04.000', 51, 1004246, 200, '0.69', '0.00'),
(47591897624, '2021-10-06 16:05:04.000', 51, 1004246, 115, '2', '0'),
(47591897624, '2021-10-06 16:05:04.000', 51, 1004246, 112, '3', '2')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.95, AmtofPayCurrDue = AmtofPayCurrDue - 24.95, CycleDueDTD = 0 WHERE acctId = 2072182 --BS: 2040912

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(47693525627, '2021-10-08 21:00:17.000', 52, 2072182, 115, '1', '0'),
(47693525627, '2021-10-08 21:00:17.000', 52, 2072182, 200, '24.95', '0.00')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue - 61.12 WHERE acctId = 4704126

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 61.12, RemainingMinimumDue = RemainingMinimumDue - 61.12,
RunningMinimumDue = RunningMinimumDue - 61.12 WHERE acctId = 4704126

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48038820101, '2021-10-16 09:08:49.000', 51, 4704126, 200, '238.11', '176.99')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 25 WHERE acctId = 571769

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, RunningMinimumDue = RunningMinimumDue - 25, 
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 571769

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '0.00' WHERE AID = 571769 AND ATID = 51 AND IdentityField = 2082450933
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(47295957642, '2021-10-01 17:12:10.000', 51, 571769, 115, '1', '0')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 209.12, AmtofPayCurrDue = AmtofPayCurrDue - 175, AmtofPayXDLate = AmtofPayXDLate - 34.12, CycleDueDTD = 0 WHERE acctId = 8317600 --BS: 4499442

UPDATE TOP(1) CurrentBalanceAuditPS SET Newvalue = '0.00' WHERE AID = 8317600 AND ATID = 52 AND IdentityField = 3626773674
UPDATE TOP(1) CurrentBalanceAuditPS SET Newvalue = '0' WHERE AID = 8317600 AND ATID = 52 AND IdentityField = 3626773675



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 24.68 WHERE acctId = 16913155

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 24.68, RemainingMinimumDue = RemainingMinimumDue + 24.68,
RunningMinimumDue = RunningMinimumDue + 24.68 WHERE acctId = 16913155

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 16913155 AND ATID = 51 AND IdentityField = 2150699857




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.59, AmtofPayCurrDue = AmtofPayCurrDue - 24.59, CycleDueDTD = 0 WHERE acctId = 27139945 --BS: 10652933

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48002280936, '2021-10-15 05:21:16.000', 52, 27139945, 115, '1', '0'),
(48002280936, '2021-10-15 05:21:16.000', 52, 27139945, 200, '24.59', '0.00')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.34, AmtofPayCurrDue = AmtofPayCurrDue - 19.34, CycleDueDTD = 0 WHERE acctId = 1786883 --BS: 1770233

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48142766775, '2021-10-18 06:46:09.000', 52, 1786883, 115, '1', '0'),
(48142766775, '2021-10-18 06:46:09.000', 52, 1786883, 200, '19.34', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 8.59 WHERE acctId = 619636

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.59, RemainingMinimumDue = RemainingMinimumDue + 8.59,
RunningMinimumDue = RunningMinimumDue + 8.59 WHERE acctId = 619636


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 7.14, AmtofPayCurrDue = AmtofPayCurrDue + 7.14, CycleDueDTD = 1 WHERE acctId = 631856 --BS: 619636


UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '65.20' WHERE AID = 619636 AND ATID = 51 AND IdentityField = 2151453699

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 631856 AND ATID = 52 AND IdentityField = 3663804617
UPDATE TOP(1) CurrentBalanceAuditPS SET Newvalue = '7.14' WHERE AID = 631856 AND ATID = 52 AND IdentityField = 3663804616



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.18, AmtofPayCurrDue = AmtofPayCurrDue - 24.18, CycleDueDTD = 0 WHERE acctId = 2273438 --BS: 2235648

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48142767378, '2021-10-18 07:02:16.000', 52, 2273438, 115, '1', '0'),
(48142767378, '2021-10-18 07:02:16.000', 52, 2273438, 200, '24.18', '0.00')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.57, AmtofPayCurrDue = AmtofPayCurrDue - 0.57, CycleDueDTD = 0 WHERE acctId = 43090598 --BS: 4324806

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48215207054, '2021-10-19 10:19:46.000', 52, 43090598, 115, '1', '0'),
(48215207054, '2021-10-19 10:19:46.000', 52, 43090598, 200, '0.57', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.30, AmtofPayCurrDue = AmtofPayCurrDue - 2.30, CycleDueDTD = 0 WHERE acctId = 18681835 --BS: 416531

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48221429901, '2021-10-19 11:14:22.000', 52, 18681835, 115, '1', '0'),
(48221429901, '2021-10-19 11:14:22.000', 52, 18681835, 200, '2.30', '0.00')

