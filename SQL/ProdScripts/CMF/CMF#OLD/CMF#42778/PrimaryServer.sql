-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT 


	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.90 WHERE acctId = 4678410
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.90, RunningMinimumDue = RunningMinimumDue - 11.90, 
	RemainingMinimumDue = RemainingMinimumDue - 11.90, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 4678410

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 9.69, AmountOfTotalDue = AmountOfTotalDue - 9.69 WHERE acctId = 9712568

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390603663, '2020-09-17 18:00:09.000', 51, 4678410, 200, '11.90', '0.00'),
	(30390603663, '2020-09-17 18:00:09.000', 51, 4678410, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 9712568 AND ATID = 52 AND IdentityField = 1094558325
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390603663, '2020-09-17 18:00:09.000', 52, 9712568, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2623784
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 44.00, AmtOfPayXDLate = AmtOfPayXDLate - 44.00, RunningMinimumDue = RunningMinimumDue - 44.00,
	DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL  WHERE acctId = 2623784

	DELETE FROM  CurrentBalanceAudit WHERE AID = 2623784 AND ATID = 51 AND IdentityField = 685251417
	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 2623784 AND ATID = 51 AND IdentityField = 680050152
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30564127075, '2020-09-18 02:28:19.000', 51, 2623784, 115, '44.00', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2740964 AND ATID = 52 AND IdentityField = 1095387413
	UPDATE CurrentBalanceAuditPS SET NewValue = '0' WHERE AID = 2740964 AND ATID = 52 AND IdentityField = 1095387414
	DELETE FROM  CurrentBalanceAuditPS WHERE AID = 2740964 AND ATID = 52 AND IdentityField = 1104800966
	DELETE FROM  CurrentBalanceAuditPS WHERE AID = 2740964 AND ATID = 52 AND IdentityField = 1104800967



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 19.51 WHERE acctId = 8300540
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.51, RunningMinimumDue = RunningMinimumDue - 19.51, 
	RemainingMinimumDue = RemainingMinimumDue - 19.51, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8300540

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75, AmountOfTotalDue = AmountOfTotalDue - 10.75 WHERE acctId = 20026698

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390603663, '2020-09-18 10:58:28.000', 51, 8300540, 200, '19.51', '0.00'),
	(30390603663, '2020-09-18 10:58:28.000', 51, 8300540, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 20026698 AND ATID = 52 AND IdentityField = 1097574863
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30390603663, '2020-09-18 10:58:28.000', 52, 20026698, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue - 62.33 WHERE acctId = 9859231
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 63.97, AmtOfPayXDLate = AmtOfPayXDLate - 1.64, 
	DateOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0  WHERE acctId = 9859231
	
	DELETE FROM  CurrentBalanceAudit WHERE AID = 9859231 AND ATID = 51 AND IdentityField = 674006527
	DELETE FROM  CurrentBalanceAudit WHERE AID = 9859231 AND ATID = 51 AND IdentityField = 674006513



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.79 WHERE acctId = 8486795
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.79, RunningMinimumDue = RunningMinimumDue - 7.79, 
	RemainingMinimumDue = RemainingMinimumDue - 7.79, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 8486795

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395489423, '2020-09-18 14:30:01.000', 51, 8486795, 200, '7.79', '0.00'),
	(30395489423, '2020-09-18 14:30:01.000', 51, 8486795, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.72 WHERE acctId = 6963163
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.72, RunningMinimumDue = RunningMinimumDue - 5.72, 
	RemainingMinimumDue = RemainingMinimumDue - 5.72, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 6963163

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 6963163 AND ATID = 51 AND IdentityField = 677781464
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30400265587, '2020-09-16 15:58:36.000', 51, 6963163, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.42 WHERE acctId = 4354882
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 29.42, RunningMinimumDue = RunningMinimumDue - 29.42, 
	RemainingMinimumDue = RemainingMinimumDue - 29.42, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 4354882

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395858610, '2020-09-18 12:09:22.000', 51, 4354882, 200, '29.42', '0.00'),
	(30395858610, '2020-09-18 12:09:22.000', 51, 4354882, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.08 WHERE acctId = 9850697
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.08, RunningMinimumDue = RunningMinimumDue - 26.08, 
	RemainingMinimumDue = RemainingMinimumDue - 26.08, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9850697

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.61, AmountOfTotalDue = AmountOfTotalDue - 25.61 WHERE acctId = 24154855

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395485292, '2020-09-14 07:44:21.000', 51, 9850697, 200, '26.08', '0.00'),
	(30395485292, '2020-09-14 07:44:21.000', 51, 9850697, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 24154855 AND ATID = 52 AND IdentityField = 1081458669
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30395485292, '2020-09-14 07:44:21.000', 52, 24154855, 115, '1', '0')



	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 464.48, AmountOfPayment90DLate = AmountOfPayment90DLate + 464.48 WHERE acctId = 1897844

	UPDATE CPSgmentCreditCard SET AmountOfPayment90DLate = AmountOfPayment90DLate - 121.66, AmountOfTotalDue = AmountOfTotalDue - 121.66 WHERE acctId = 12022991


COMMIT TRANSACTION
--ROLLBACK TRANSACTION