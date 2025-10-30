-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.95 WHERE acctId = 9257169
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.95, RunningMinimumDue = RunningMinimumDue - 25.95, 
	RemainingMinimumDue = RemainingMinimumDue - 25.95, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9257169

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.63, AmountOfTotalDue = AmountOfTotalDue - 21.63 WHERE acctId = 22589327

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553858093, '2020-10-28 10:44:06.000', 51, 9257169, 115, '1', '0'),
	(31553858093, '2020-10-28 10:44:06.000', 51, 9257169, 200, '25.95', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 22589327 AND ATID = 52 AND IdentityField = 1259443122
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553858093, '2020-10-28 10:44:06.000', 52, 22589327, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 32.84 WHERE acctId = 748318
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 32.84 WHERE acctId = 748318

	DELETE FROM CurrentBalanceAudit WHERE AID = 748318 AND ATID = 51 AND IdentityField = 769664373



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 50.01 WHERE acctId = 2872118
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 50.01, RunningMinimumDue = RunningMinimumDue - 50.01, 
	RemainingMinimumDue = RemainingMinimumDue - 50.01, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 2872118

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 27.72, AmountOfTotalDue = AmountOfTotalDue - 27.72 WHERE acctId = 3070268

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553895013, '2020-10-27 17:20:22.000', 51, 2872118, 115, '1', '0'),
	(31553895013, '2020-10-27 17:20:22.000', 51, 2872118, 200, '50.01', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 3070268 AND ATID = 52 AND IdentityField = 1256315766
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553895013, '2020-10-27 17:20:22.000', 52, 3070268, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.63 WHERE acctId = 7006183
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.63, RunningMinimumDue = RunningMinimumDue - 11.63, 
	RemainingMinimumDue = RemainingMinimumDue - 11.63, FirstDueDate = '2020-10-31 23:59:57.000'  WHERE acctId = 7006183

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.70, AmountOfTotalDue = AmountOfTotalDue - 10.70 WHERE acctId = 16952341

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553943235, '2020-10-28 13:21:38.000', 51, 7006183, 200, '99.79', '88.16')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 16952341 AND ATID = 52 AND IdentityField = 1259607206
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31553943235, '2020-10-28 13:21:38.000', 52, 16952341, 115, '1', '0')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 24.83, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.83 WHERE acctId = 2588287

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31713181250, '2020-10-28 10:15:11.000', 52, 2588287, 200, '24.83', '0.00'),
	(31713181250, '2020-10-28 10:15:11.000', 52, 2588287, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.72 WHERE acctId = 10817065
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.72, RunningMinimumDue = RunningMinimumDue - 11.72, 
	RemainingMinimumDue = RemainingMinimumDue - 11.72, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10817065

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.27, AmountOfTotalDue = AmountOfTotalDue - 10.27 WHERE acctId = 27504077

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31554327421, '2020-10-28 13:07:20.000', 51, 10817065, 115, '1', '0'),
	(31554327421, '2020-10-28 13:07:20.000', 51, 10817065, 200, '11.72', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 27504077 AND ATID = 52 AND IdentityField = 1259593305
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31554327421, '2020-10-28 13:07:20.000', 52, 27504077, 115, '1', '0')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 18.33, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.33 WHERE acctId = 8169843

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31682960206, '2020-10-27 08:33:23.000', 52, 8169843, 200, '18.33', '0.00'),
	(31682960206, '2020-10-27 08:33:23.000', 52, 8169843, 115, '1', '0')



	-- DaysDelinquent issue

	UPDATE TOP(1) BSegmentCreditCard SET DaysDelinquent = 0 WHERE acctId = 1212020
	update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 79.50 where  acctid  =  23513751
	update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 434.80 where  acctid  =  23792634
	update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  -33.29 where  acctid  =  27350615

COMMIT TRANSACTION
--ROLLBACK TRANSACTION