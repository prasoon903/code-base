-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT


	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2333040
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.53, AmtOfPayXDLate = AmtOfPayXDLate - 22.53, 
	RemainingMinimumDue = RemainingMinimumDue - 22.53, DateOfOriginalPaymentDueDTD = NULL,
	DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0  WHERE acctId = 2333040

	DELETE FROM CurrentBalanceAudit WHERE AID = 2333040 AND ATID = 51 AND IdentityField = 701409069
	DELETE FROM CurrentBalanceAudit WHERE AID = 2333040 AND ATID = 51 AND IdentityField = 701409071
	DELETE FROM CurrentBalanceAudit WHERE AID = 2333040 AND ATID = 51 AND IdentityField = 701409072



COMMIT TRANSACTION
--ROLLBACK TRANSACTION