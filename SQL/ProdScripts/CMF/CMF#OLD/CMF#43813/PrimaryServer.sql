-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2045512
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfPayment60DLate = AmountOfPayment60DLate - 40, DateOfOriginalPaymentDueDTD = NULL,
	daysdelinquent = 0, NoPayDaysDelinquent = 0, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctId = 2045512

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0' WHERE AID = 2045512 AND ATID = 51 AND IdentityField = 724232163


COMMIT TRANSACTION
--ROLLBACK TRANSACTION