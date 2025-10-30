-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE top (1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.12 WHERE acctId = 4735919
	UPDATE  top (1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.12, RunningMinimumDue = RunningMinimumDue + 1.12, 
	RemainingMinimumDue = RemainingMinimumDue + 1.12, DateOfOriginalPaymentDueDTD = '2020-10-31 23:59:57', FirstDueDate = '2020-10-31 23:59:57'  WHERE acctId = 4735919

	UPDATE top (1) CurrentBalanceAudit SET NewValue = '1.12' WHERE AID = 4735919 AND ATID = 51 AND IdentityField = 740824177
	UPDATE top (1) CurrentBalanceAudit SET NewValue = '1' WHERE AID = 4735919 AND ATID = 51 AND IdentityField = 740824176



	UPDATE top (1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.85 WHERE acctId = 9586213
	UPDATE top (1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.85, RunningMinimumDue = RunningMinimumDue - 8.85, 
	RemainingMinimumDue = RemainingMinimumDue - 8.85, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 9586213

	UPDATE top (1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9586213 AND ATID = 51 AND IdentityField = 740658287
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES	
	(31211001870, '2020-10-09 13:04:05.000', 51, 9586213, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION