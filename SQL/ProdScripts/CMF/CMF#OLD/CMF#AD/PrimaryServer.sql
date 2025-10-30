-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 24.57 WHERE acctId = 4505751
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 24.57, RunningMinimumDue = RunningMinimumDue + 24.57, 
	RemainingMinimumDue = RemainingMinimumDue + 24.57 WHERE acctId = 4505751

	DELETE FROM CurrentBalanceAudit WHERE AID = 4505751 AND ATID = 51 AND IdentityField = 828127240



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 15668794

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 15668794 AND ATID = 52 AND IdentityField = 1337122350



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 6833367
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.03, AmtOfPayXDLate = AmtOfPayXDLate - 9.03, RunningMinimumDue = RunningMinimumDue - 9.03, 
	RemainingMinimumDue = RemainingMinimumDue - 9.03, DaysDelinquent = 0, NoPayDaysDelinquent = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 6833367

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 9.03, AmtOfPayXDLate = AmtOfPayXDLate - 9.03 WHERE acctId = 31526418

	--UPDATE TOP(1) StatementHeader SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 9.03, AmtOfPayXDLate = AmtOfPayXDLate - 9.03, 
	--DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 6833367 AND StatementDate = '2020-10-31 23:59:57.000'

	--UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 9.03 WHERE acctId = 31526418 AND StatementID = 44124182
	--UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 9.03 WHERE acctId = 31526418 AND StatementID = 44124182

	DELETE FROM CurrentBalanceAudit WHERE AID = 6833367 AND ATID = 51 AND IdentityField = 800440912
	DELETE FROM CurrentBalanceAudit WHERE AID = 6833367 AND ATID = 51 AND IdentityField = 800440913

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 31526418 AND ATID = 52 AND IdentityField = 1292265785




	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.18 WHERE acctId = 9867427
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.18, RunningMinimumDue = RunningMinimumDue - 11.18, 
	RemainingMinimumDue = RemainingMinimumDue - 11.18, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9867427

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.52, AmountOfTotalDue = AmountOfTotalDue - 10.52 WHERE acctId = 24632322

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32292651074, '2020-11-17 09:23:23.000', 51, 9867427, 115, '1', '0'),
	(32292651074, '2020-11-17 09:23:23.000', 51, 9867427, 200, '11.18', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 24632322 AND ATID = 52 AND IdentityField = 1361846251
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32292651074, '2020-11-17 09:23:23.000', 52, 9867427, 115, '1', '0')



COMMIT TRANSACTION
--ROLLBACK TRANSACTION