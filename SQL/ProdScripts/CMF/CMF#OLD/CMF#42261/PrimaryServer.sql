-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH statement 

	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 4175721
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 40, AmountOfPayment60DLate = AmountOfPayment60DLate - 40, RunningMinimumDue = RunningMinimumDue - 40,
	 RemainingMinimumDue = RemainingMinimumDue - 40, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL,
	  NoPayDaysDelinquent = 0  WHERE acctId = 4175721

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 4175721 AND ATID = 51 AND IdentityField = 666191410
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4175721 AND ATID = 51 AND IdentityField = 666191411

COMMIT TRANSACTION
--ROLLBACK TRANSACTION