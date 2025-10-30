-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 9747613

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.5, AmountOfPayment90DLate = AmountOfPayment90DLate - 4.5, RemainingMinimumDue = RemainingMinimumDue - 4.5, 
RunningMinimumDue = RunningMinimumDue - 4.5, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 9747613


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.5, AmountOfPayment90DLate = AmountOfPayment90DLate - 4.5, CycleDueDTD = 0 WHERE acctId = 23923927 --BS: 9747613

