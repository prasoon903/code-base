-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT 

	UPDATE BSegmentCreditCard SET RemainingMinimumDue = RemainingMinimumDue + 40 WHERE acctId = 4175721

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.76 WHERE acctId = 1380572
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.76, RunningMinimumDue = RunningMinimumDue - 43.29, RemainingMinimumDue = RemainingMinimumDue - 43.29,
	 DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 1380572

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 1380572 AND ATID = 51 AND IdentityField = 667537184
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395483947, '2020-09-10 18:00:20.000', 51, 1380572, 115, '1', '0')
	


	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.95 WHERE acctId = 8366629
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.95, RunningMinimumDue = RunningMinimumDue - 22.95, 
	RemainingMinimumDue = RemainingMinimumDue - 22.95, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8366629

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.18, AmountOfTotalDue = AmountOfTotalDue - 10.18 WHERE acctId = 20092787

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30400262975, '2020-09-11 19:19:09.000', 51, 8366629, 200, '22.95', '0.00'),
	(30400262975, '2020-09-11 19:19:09.000', 51, 8366629, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 20092787 AND ATID = 52 AND IdentityField = 1076293749
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30400262975, '2020-09-11 19:19:09.000', 52, 20092787, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.95 WHERE acctId = 9862748
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.95, RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00,
	 DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9862748

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9862748 AND ATID = 51 AND IdentityField = 669434290
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30427181791, '2020-09-11 18:16:11.000', 51, 9862748, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 3.04 WHERE acctId = 8415190
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.04, RunningMinimumDue = RunningMinimumDue - 32.68, RemainingMinimumDue = RemainingMinimumDue - 32.68,
	 DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8415190

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 8415190 AND ATID = 51 AND IdentityField = 669247007
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30400022594, '2020-09-11 12:34:58.000', 51, 8415190, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.69 WHERE acctId = 7010916
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 14.69, RunningMinimumDue = RunningMinimumDue - 14.69, 
	RemainingMinimumDue = RemainingMinimumDue - 14.69, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 7010916

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.98, AmountOfTotalDue = AmountOfTotalDue - 0.98 WHERE acctId = 16961074

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390599412, '2020-09-12 13:09:56.000', 51, 7010916, 200, '14.69', '0.00'),
	(30390599412, '2020-09-12 13:09:56.000', 51, 7010916, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 16961074 AND ATID = 52 AND IdentityField = 1079094556
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390599412, '2020-09-12 13:09:56.000', 52, 16961074, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.48 WHERE acctId = 1417430
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.48, RunningMinimumDue = RunningMinimumDue - 17.48, 
	RemainingMinimumDue = RemainingMinimumDue - 17.48, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 1417430

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.10, AmountOfTotalDue = AmountOfTotalDue - 17.10 WHERE acctId = 1429850

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395483528, '2020-09-10 15:27:06.000', 51, 1417430, 200, '17.48', '0.00'),
	(30395483528, '2020-09-10 15:27:06.000', 51, 1417430, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 1429850 AND ATID = 52 AND IdentityField = 1072877715
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395483528, '2020-09-10 15:27:06.000', 52, 1429850, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.53 WHERE acctId = 4956766
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.53, RunningMinimumDue = RunningMinimumDue - 5.53, RemainingMinimumDue = RemainingMinimumDue - 5.53,
	 DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 4956766

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395878385, '2020-09-11 16:09:59.000', 51, 4956766, 115, '1', '0'),
	(30395878385, '2020-09-11 16:09:59.000', 51, 4956766, 200, '5.53', '0.00')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION