-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1927940
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 9425546
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1927940
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 9425546

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1957560
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 22847704

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 55.42 WHERE acctID = 383401
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 110.61 WHERE acctID = 4363245
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 49.95 WHERE acctID = 15325624

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 55.42, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 55.42, RemainingMinimumDue = 55.42, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 383401
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 110.61, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 110.61, RemainingMinimumDue = 110.61, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 4363245
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 49.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 49.95, RemainingMinimumDue = 49.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 15325624

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 20642887
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 46662941

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 22.18, AmtOfPayCurrDue = 22.18 WHERE acctID = 395621

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 29521

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1957560 AND ATID = 52 AND IdentityField = 5140653524
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 46662941 AND ATID = 52 AND IdentityField = 4999081764

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1957560 AND ATID = 52 AND IdentityField = 5140653525

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1927940 AND ATID = 51 AND IdentityField = 2978444344
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '112.32' WHERE AID = 4363245 AND ATID = 51 AND IdentityField = 2981255972
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1927940 AND ATID = 51 AND IdentityField = 2978444343

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58528318786, '2022-03-30 21:06:00', 52, 29521, 200, '22.87', '0.00')
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58528318786, '2022-03-30 21:06:00', 52, 29521, 115, '1', '0')

update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 61.25 where  acctid  =  67271386
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 76.38 where  acctid  =  74521985