-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0 WHERE acctId = 11208697

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 30.00 WHERE acctId = 2210876
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 30.00, RunningMinimumDue = RunningMinimumDue - 30.00, 
	RemainingMinimumDue = RemainingMinimumDue - 30.00, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 2210876

	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.01, AmountOfTotalDue = AmountOfTotalDue + 0.01 WHERE acctId = 2246746

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31969367614, '2020-11-01 14:16:34.000', 51, 2210876, 115, '1', '0'),
	(31969367614, '2020-11-01 14:16:34.000', 51, 2210876, 200, '30.00', '0.00')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.91, AmountOfTotalDue = AmountOfTotalDue - 18.91 WHERE acctId = 873391

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32020052192, '2020-11-02 21:10:40.000', 52, 873391, 115, '1', '0'),
	(32020052192, '2020-11-02 21:10:40.000', 52, 873391, 200, '18.91', '0.00')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 20.16, AmountOfTotalDue = AmountOfTotalDue - 20.16 WHERE acctId = 25457484



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 196.13 WHERE acctId = 10656913
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 196.13, RunningMinimumDue = RunningMinimumDue - 192.10, 
	RemainingMinimumDue = RemainingMinimumDue - 192.10, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10656913

	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.03, AmtOfPayXDLate = AmtOfPayXDLate - 8.06 WHERE acctId = 27151925

	UPDATE CurrentBalanceAudit SET OldValue = '200.16', NewValue = '0.00' WHERE AID = 10656913 AND ATID = 51 AND IdentityField = 804970804
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31974556960, '2020-11-01 21:24:16.000', 51, 10656913, 115, '1', '0')



	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 17.73, AmountOfTotalDue = AmountOfTotalDue - 17.73 WHERE acctId = 1901088

	UPDATE CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 1058.49, AmountOfTotalDue = AmountOfTotalDue + 1058.49, 
	SBWithInstallmentDue = SBWithInstallmentDue + 1058.49, SRBWithInstallmentDue = SRBWithInstallmentDue + 1058.49 WHERE acctId = 33101004

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 1901088 AND ATID = 52 AND IdentityField = 1284429399
	DELETE FROM CurrentBalanceAuditPS WHERE AID = 1901088 AND ATID = 52 AND IdentityField = 1284429400

	UPDATE CurrentBalanceAuditPS SET NewValue = '25.31' WHERE AID = 33101004 AND ATID = 52 AND IdentityField = 1284429407
	UPDATE CurrentBalanceAuditPS SET NewValue = '25.31' WHERE AID = 33101004 AND ATID = 52 AND IdentityField = 1284429409
	UPDATE CurrentBalanceAuditPS SET NewValue = '25.31' WHERE AID = 33101004 AND ATID = 52 AND IdentityField = 1284429410



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 6.71, AmountOfTotalDue = AmountOfTotalDue - 6.71 WHERE acctId = 23544712

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 23544712 AND ATID = 52 AND IdentityField = 1292745612



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 9745940
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.86, AmtOfPayXDLate = AmtOfPayXDLate - 13.86, RunningMinimumDue = RunningMinimumDue - 38.86, 
	RemainingMinimumDue = RemainingMinimumDue - 38.86, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9745940

	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, AmtOfPayXDLate = AmtOfPayXDLate - 5.54,
	AmountOfTotalDue = AmountOfTotalDue - 30.54, CycleDueDTD = 0 WHERE acctId = 23990098

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32002004575, '2020-11-02 06:57:59.000', 51, 9745940, 115, '2', '0'),
	(32002004575, '2020-11-02 06:57:59.000', 51, 9745940, 200, '75.00', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 23990098 AND ATID = 52 AND IdentityField = 1303299202

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32002004575, '2020-11-02 06:57:59.000', 51, 23990098, 115, '2', '0')



	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45 WHERE acctId = 2537120

	UPDATE CurrentBalanceAudit SET NewValue = '25.00' WHERE AID = 2537120 AND ATID = 51 AND IdentityField = 796145924



	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 73 WHERE acctId = 4407747

	UPDATE CurrentBalanceAudit SET NewValue = '72.00' WHERE AID = 4407747 AND ATID = 51 AND IdentityField = 798855565


	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.76, AmountOfTotalDue = AmountOfTotalDue - 24.76 WHERE acctId = 2408587

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32020048482, '2020-11-02 21:10:43.000', 51, 2408587, 115, '1', '0'),
	(32020048482, '2020-11-02 21:10:43.000', 51, 2408587, 200, '24.76', '0.00')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.34, AmountOfTotalDue = AmountOfTotalDue - 22.34 WHERE acctId = 606491

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32036320775, '2020-11-03 08:44:11.000', 51, 606491, 115, '1', '0'),
	(32036320775, '2020-11-03 08:44:11.000', 51, 606491, 200, '22.34', '0.00')

	



COMMIT TRANSACTION
--ROLLBACK TRANSACTION