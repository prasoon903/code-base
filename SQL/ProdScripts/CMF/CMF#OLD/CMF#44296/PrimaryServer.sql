-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 23.97, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.97 WHERE acctId = 1857079

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31521299665, '2020-10-21 05:36:22.000', 52, 1857079, 200, '23.97', '0.00'),
	(31521299665, '2020-10-21 05:36:22.000', 52, 1857079, 115, '1', '0')

	

	UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 14.26 WHERE acctId = 1730001
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 14.26, RunningMinimumDue = RunningMinimumDue - 14.26, 
	RemainingMinimumDue = RemainingMinimumDue - 14.26, FirstDueDate = '2020-10-31 23:59:57.000'  WHERE acctId = 1730001

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 13.80, AmountOfTotalDue = AmountOfTotalDue - 13.80 WHERE acctId = 1746461

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31357944573, '2020-10-20 17:22:33.000', 51, 1730001, 200, '60.05', '45.79')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 1746461 AND ATID = 52 AND IdentityField = 1230713366
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31357944573, '2020-10-20 17:22:33.000', 52, 1746461, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.45 WHERE acctId = 1376719
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.45, RunningMinimumDue = RunningMinimumDue - 8.45, 
	RemainingMinimumDue = RemainingMinimumDue - 8.45, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 1376719

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31358501362, '2020-10-20 02:56:43.000', 51, 1376719, 115, '1', '0'),
	(31358501362, '2020-10-20 02:56:43.000', 51, 1376719, 200, '8.45', '0.00')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.76 WHERE acctId = 609301
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 29.76, RunningMinimumDue = RunningMinimumDue - 29.76, 
	RemainingMinimumDue = RemainingMinimumDue - 29.76, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 609301

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.20, AmountOfTotalDue = AmountOfTotalDue - 18.20 WHERE acctId = 621521

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31358501705, '2020-10-20 04:35:19.000', 51, 609301, 115, '1', '0'),
	(31358501705, '2020-10-20 04:35:19.000', 51, 609301, 200, '29.76', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 621521 AND ATID = 52 AND IdentityField = 1228207549
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31358501705, '2020-10-20 04:35:19.000', 52, 621521, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 26.73 WHERE acctId = 1298440
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.73, RunningMinimumDue = RunningMinimumDue - 33.25, 
	RemainingMinimumDue = RemainingMinimumDue - 33.25, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL  WHERE acctId = 1298440

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31615243897, '2020-10-24 16:38:18.000', 51, 1298440, 115, '1', '0'),
	(31615243897, '2020-10-24 16:38:18.000', 51, 1298440, 200, '26.73', '0.00')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue + 25, AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE acctId = 760728

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 760728 AND ATID = 52 AND IdentityField = 1245373232
	DELETE FROM CurrentBalanceAuditPS WHERE AID = 760728 AND ATID = 52 AND IdentityField = 1245373233



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.46 WHERE acctId = 9856510
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.46, RunningMinimumDue = RunningMinimumDue - 23.46, 
	RemainingMinimumDue = RemainingMinimumDue - 23.46, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9856510

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 15.75, AmountOfTotalDue = AmountOfTotalDue - 15.75 WHERE acctId = 24160668

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31554260093, '2020-10-26 17:44:24.000', 51, 9856510, 115, '1', '0'),
	(31554260093, '2020-10-26 17:44:24.000', 51, 9856510, 200, '29.76', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 24160668 AND ATID = 52 AND IdentityField = 1252685731
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31554260093, '2020-10-26 17:44:24.000', 52, 24160668, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION