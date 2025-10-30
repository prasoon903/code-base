-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.69 WHERE acctId = 1737878
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.69, RunningMinimumDue = RunningMinimumDue - 7.69, 
	RemainingMinimumDue = RemainingMinimumDue - 7.69, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 1737878

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.59, AmountOfTotalDue = AmountOfTotalDue - 1.59 WHERE acctId = 1754338

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 1737878 AND ATID = 51 AND IdentityField = 734796728
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31095944979, '2020-10-06 09:35:43.000', 51, 1737878, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 1754338 AND ATID = 52 AND IdentityField = 1182495968
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31095944979, '2020-10-06 09:35:43.000', 52, 1754338, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 40.56 WHERE acctId = 2238870
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 40.56, RunningMinimumDue = RunningMinimumDue - 40.56, 
	RemainingMinimumDue = RemainingMinimumDue - 40.56, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2238870

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.08, AmountOfTotalDue = AmountOfTotalDue - 26.08 WHERE acctId = 2277660

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094785631, '2020-10-06 14:02:38.000', 51, 2238870, 200, '40.56', '0.00'),
	(31094785631, '2020-10-06 14:02:38.000', 51, 2238870, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2277660 AND ATID = 52 AND IdentityField = 1182990419
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31094785631, '2020-10-06 14:02:38.000', 52, 2277660, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.54 WHERE acctId = 1019530
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.54, RunningMinimumDue = RunningMinimumDue - 22.54, 
	RemainingMinimumDue = RemainingMinimumDue - 22.54, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 1019530

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.20, AmountOfTotalDue = AmountOfTotalDue - 13.20 WHERE acctId = 1031950

	DELETE FROM CurrentBalanceAudit WHERE AID = 1019530 AND ATID = 51 AND IdentityField = 735196282
	DELETE FROM CurrentBalanceAudit WHERE AID = 1019530 AND ATID = 51 AND IdentityField = 735196283

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 1031950 AND ATID = 52 AND IdentityField = 1183132443
	DELETE FROM CurrentBalanceAuditPS WHERE AID = 1031950 AND ATID = 52 AND IdentityField = 1183132444


COMMIT TRANSACTION
--ROLLBACK TRANSACTION