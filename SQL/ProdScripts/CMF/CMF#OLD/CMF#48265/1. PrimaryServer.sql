-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 2307284
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 32.33, AmtOfPayXDLate = AmtOfPayXDLate + 32.33, RunningMinimumDue = RunningMinimumDue + 32.33, 
RemainingMinimumDue = RemainingMinimumDue + 32.33, DateOfOriginalPaymentDueDTD = '2021-01-31 23:59:57', DaysDelinquent = 9, NoPayDaysDelinquent = 9,
FirstDueDate = '2021-01-31 23:59:57', DtOfLastDelinqCTD = '2021-01-31 23:59:57'  WHERE acctId = 2307284

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(34993276847, '2021-02-03 15:26:54.000', 51, 2307284, 200, '0.00', '32.33'),
(34993276847, '2021-02-03 15:26:54.000', 51, 2307284, 115, '0', '2')




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 55.27 WHERE acctId = 964655
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 55.27, RemainingMinimumDue = RemainingMinimumDue - 55.27, 
DateOfOriginalPaymentDueDTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0,
FirstDueDate = NULL, DtOfLastDelinqCTD = NULL  WHERE acctId = 964655

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0' WHERE AID = 964655 AND ATID = 51 AND IdentityField = 1101112760
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 964655 AND ATID = 51 AND IdentityField = 1101112761

