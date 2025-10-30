-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT


	Update TOP(1) Bsegment_Primary SET AmtOfDispRelFromOTB = (AmtOfDispRelFromOTB - 22.99) where acctid=4639245


	
	UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 0.71, SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71 WHERE acctId = 1875442



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.95 WHERE acctId = 828675
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.95, RunningMinimumDue = RunningMinimumDue - 18.95, 
	RemainingMinimumDue = RemainingMinimumDue - 18.95, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 828675

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 17.70, AmountOfTotalDue = AmountOfTotalDue - 17.70 WHERE acctId = 841085

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293157330, '2020-11-18 04:16:27.000', 51, 828675, 115, '1', '0'),
	(32293157330, '2020-11-18 04:16:27.000', 51, 828675, 200, '18.95', '0.00')

	UPDATE  TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 841085 AND ATID = 52 AND IdentityField = 1363286721
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293157330, '2020-11-18 04:16:27.000', 52, 841085, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.64 WHERE acctId = 6079526
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.64, RunningMinimumDue = RunningMinimumDue - 18.64, 
	RemainingMinimumDue = RemainingMinimumDue - 18.64  WHERE acctId = 6079526

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 12.71, AmountOfTotalDue = AmountOfTotalDue - 12.71 WHERE acctId = 14731684

	DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 6079526 AND ATID = 51 AND IdentityField = 841663878
	DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 6079526 AND ATID = 51 AND IdentityField = 841663877

	DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 6079526 AND ATID = 52 AND IdentityField = 1365183402
	DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 6079526 AND ATID = 52 AND IdentityField = 1365183403



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 18.05 WHERE acctId = 10822607
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.05, RunningMinimumDue = RunningMinimumDue - 18.05, 
	RemainingMinimumDue = RemainingMinimumDue - 18.05, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 10822607

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.17, AmountOfTotalDue = AmountOfTotalDue - 14.17 WHERE acctId = 27578354

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 10822607 AND ATID = 51 AND IdentityField = 842942423
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293114288, '2020-11-19 07:42:31.000', 51, 10822607, 115, '1', '0')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 27578354 AND ATID = 52 AND IdentityField = 1367458634
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293114288, '2020-11-19 07:42:31.000', 52, 27578354, 115, '1', '0')



	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 7.47 WHERE acctId = 9254534
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.47, RunningMinimumDue = RunningMinimumDue - 7.47, 
	RemainingMinimumDue = RemainingMinimumDue - 7.47, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9254534

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.98, AmountOfTotalDue = AmountOfTotalDue - 0.98 WHERE acctId = 22586692

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293074536, '2020-11-18 12:36:42.000', 51, 9254534, 115, '1', '0'),
	(32293074536, '2020-11-18 12:36:42.000', 51, 9254534, 200, '7.47', '0.00')

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 22586692 AND ATID = 52 AND IdentityField = 1365299033
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(32293074536, '2020-11-18 12:36:42.000', 52, 22586692, 115, '1', '0')



	UPDATE TOP(1) BSegmentCreditCard SET daysdelinquent = 0, NoPayDaysDelinquent = 203, DtOfLastDelinqCTD = NULL WHERE acctId = 1590918



	UPDATE TOP(1) CPSgmentCreditCard SET AmountOfPayment30DLate = AmountOfPayment30DLate + 0.29 WHERE acctId = 6487953



	-- Charge-Off accounts due-mismatch

	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 33 WHERE acctId = 448797  -- 436577



	UPDATE TOP(1) CPSgmentCreditCard SET AmountOfPayment60DLate = AmountOfPayment60DLate + 33.61, AmountOfPayment90DLate = AmountOfPayment90DLate - 33.61, 
	AmountOfPayment150DLate = AmountOfPayment150DLate + 29.07, AmountOfPayment180DLate = AmountOfPayment180DLate - 29.07 WHERE acctId = 4447066  -- 783069

	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 3, 
		AmtOfPayXDLate = AmtOfPayXDLate + 6, 
		AmountOfPayment30DLate = AmountOfPayment30DLate + 23, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 48.61, 
		AmountOfPayment90DLate = AmountOfPayment90DLate - 71.39, 
		AmountOfPayment120DLate = AmountOfPayment120DLate + 6.86, 
		AmountOfPayment150DLate = AmountOfPayment150DLate - 6.86 WHERE acctId = 795479  -- 783069



	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayXDLate, 
		AmtOfPayXDLate = AmountOfPayment30DLate, 
		AmountOfPayment30DLate = AmountOfPayment60DLate, 
		AmountOfPayment60DLate = AmountOfPayment90DLate, 
		AmountOfPayment90DLate = AmountOfPayment120DLate, 
		AmountOfPayment120DLate = AmountOfPayment150DLate, 
		AmountOfPayment150DLate = AmountOfPayment180DLate,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 5.72 WHERE acctId = 831443  -- 819033


	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, 
		AmtOfPayXDLate = AmtOfPayXDLate + 0.01, 
		AmountOfPayment30DLate = AmountOfPayment30DLate + 0, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 0.01,  
		AmountOfPayment150DLate = AmountOfPayment150DLate + 9.94,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 10.03 WHERE acctId = 913911  -- 901491



	UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 145, AmtOfPayCurrDue = AmtOfPayCurrDue - 145, CycleDueDTD = 0 WHERE acctId = 1150680  -- 1138260



	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 7.00, 
		AmtOfPayXDLate = AmtOfPayXDLate + 1, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 128, 
		AmountOfPayment60DLate = AmountOfPayment60DLate + 1, 
		AmountOfPayment90DLate = AmountOfPayment90DLate - 89,  
		AmountOfPayment150DLate = AmountOfPayment150DLate + 88.53,
		AmountOfPayment180DLate = AmountOfPayment180DLate - 113.53 WHERE acctId = 913911  -- 901491



	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue + 0.06,   
		AmountOfPayment150DLate = AmountOfPayment150DLate - 0.06 WHERE acctId = 2128398  -- 2096678



	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.05 WHERE acctId = 8222497  -- 2244607


	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmountOfPayment150DLate = AmountOfPayment150DLate + 1.14,   
		AmountOfPayment180DLate = AmountOfPayment180DLate - 1.16 WHERE acctId = 2848549  -- 2700629



	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 7.00, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 3.00, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 7.00,  
		AmountOfPayment120DLate = AmountOfPayment120DLate - 114.00, 
		AmountOfPayment180DLate = AmountOfPayment180DLate - 60.00 WHERE acctId = 5641639  -- 4067489



	UPDATE TOP(1) CPSgmentCreditCard SET 
		AmtOfPayCurrDue = AmtOfPayCurrDue - 2.00, 
		AmountOfPayment30DLate = AmountOfPayment30DLate - 1.00, 
		AmountOfPayment60DLate = AmountOfPayment60DLate - 2.00, 
		AmountOfPayment90DLate = AmountOfPayment90DLate + 1.00, 
		AmountOfPayment120DLate = AmountOfPayment120DLate - 39.00,  
		AmountOfPayment180DLate = AmountOfPayment180DLate - 41.00 WHERE acctId = 6333782  -- 4243632




COMMIT TRANSACTION
--ROLLBACK TRANSACTION