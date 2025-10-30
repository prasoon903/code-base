-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH statement 

	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 4879059
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42, AmountOfPayment60DLate = AmountOfPayment60DLate - 42, RunningMinimumDue = RunningMinimumDue - 42,
	 RemainingMinimumDue = RemainingMinimumDue - 42, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL,
	  NoPayDaysDelinquent = 0  WHERE acctId = 4879059

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 4879059 AND ATID = 51 AND IdentityField = 648959111
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4879059 AND ATID = 51 AND IdentityField = 648959112



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.37 WHERE acctId = 7922350
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.37, RunningMinimumDue = RunningMinimumDue - 11.37, RemainingMinimumDue = RemainingMinimumDue - 11.37,
	 DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 7922350

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.99, AmountOfTotalDue = AmountOfTotalDue - 1.99 WHERE acctId = 19350508

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29970898267, '2020-09-01 12:45:08.000', 51, 7922350, 115, '1', '0'),
	(29970898267, '2020-09-01 12:45:08.000', 51, 7922350, 200, '11.37', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0' WHERE AID = 19350508 AND ATID = 52 AND IdentityField = 1041531089
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29970898267, '2020-09-01 12:45:08.000', 52, 19350508, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2651783
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, AmountOfPayment60DLate = AmountOfPayment60DLate - 25,
	 RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL,
	  DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 2651783

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 2651783 AND ATID = 51 AND IdentityField = 648948406
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 2651783 AND ATID = 51 AND IdentityField = 648948408



	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.38 WHERE acctId = 389157
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.38, RunningMinimumDue = RunningMinimumDue - 38.38, 
	RemainingMinimumDue = RemainingMinimumDue - 38.38, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = '2020-09-30 23:59:57.000'  WHERE acctId = 389157

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.86, AmountOfTotalDue = AmountOfTotalDue - 29.86 WHERE acctId = 401377

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29965502079, '2020-09-01 19:13:02.000', 51, 389157, 200, '163.29', '124.91')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 401377 AND ATID = 52 AND IdentityField = 1043731394
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29965502079, '2020-09-01 19:13:02.000', 52, 401377, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 9452918
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 113.16, AmountOfPayment60DLate = AmountOfPayment60DLate - 113.16,
	 RunningMinimumDue = RunningMinimumDue - 113.16, RemainingMinimumDue = RemainingMinimumDue - 113.16,
	  DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000',
	   FirstDueDate = '2020-09-30 23:59:57.000', NoPayDaysDelinquent = 0  WHERE acctId = 9452918

	UPDATE CurrentBalanceAudit SET NewValue = '1' WHERE AID = 9452918 AND ATID = 51 AND IdentityField = 648952192
	UPDATE CurrentBalanceAudit SET NewValue = '78.60' WHERE AID = 9452918 AND ATID = 51 AND IdentityField = 648952193



	UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 8980362
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 144.74, AmountOfPayment60DLate = AmountOfPayment60DLate - 144.74,
	 RunningMinimumDue = RunningMinimumDue - 144.74, RemainingMinimumDue = RemainingMinimumDue - 144.74, DaysDelinquent = 0,
	  DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000', FirstDueDate = '2020-09-30 23:59:57.000', NoPayDaysDelinquent = 0  WHERE acctId = 8980362

	UPDATE CurrentBalanceAudit SET NewValue = '1' WHERE AID = 8980362 AND ATID = 51 AND IdentityField = 648959479
	UPDATE CurrentBalanceAudit SET NewValue = '89.09' WHERE AID = 8980362 AND ATID = 51 AND IdentityField = 648959481



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2331990
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 48, AmountOfPayment60DLate = AmountOfPayment60DLate - 48,
	 RunningMinimumDue = RunningMinimumDue - 48, RemainingMinimumDue = RemainingMinimumDue - 48, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL,
	  DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 2331990

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 2331990 AND ATID = 51 AND IdentityField = 648948553
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 2331990 AND ATID = 51 AND IdentityField = 648948554



	UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 9749132
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.99, AmountOfPayment60DLate = AmountOfPayment60DLate - 2.99, 
	RunningMinimumDue = RunningMinimumDue - 2.99, RemainingMinimumDue = RemainingMinimumDue - 2.99, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL,
	 DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000', FirstDueDate = '2020-09-30 23:59:57.000', NoPayDaysDelinquent = 0  WHERE acctId = 9749132

	UPDATE CurrentBalanceAudit SET NewValue = '1' WHERE AID = 9749132 AND ATID = 51 AND IdentityField = 648956052
	UPDATE CurrentBalanceAudit SET NewValue = '25.00' WHERE AID = 9749132 AND ATID = 51 AND IdentityField = 648956054



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 34.04 WHERE acctId = 248746
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 34.04, RunningMinimumDue = RunningMinimumDue - 34.04, 
	RemainingMinimumDue = RemainingMinimumDue - 34.04, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 248746

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.37, AmountOfTotalDue = AmountOfTotalDue - 14.37 WHERE acctId = 260816

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29966690355, '2020-09-02 13:12:37.000', 51, 248746, 115, '1', '0'),
	(29966690355, '2020-09-02 13:12:37.000', 51, 248746, 200, '34.04', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 260816 AND ATID = 52 AND IdentityField = 1047590872
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29966690355, '2020-09-02 13:12:37.000', 52, 260816, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 9407183
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.25, AmountOfPayment60DLate = AmountOfPayment60DLate - 58.25,
	 RunningMinimumDue = RunningMinimumDue - 58.25, RemainingMinimumDue = RemainingMinimumDue - 58.25, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, 
	 DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 9407183

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 9407183 AND ATID = 51 AND IdentityField = 648957549
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9407183 AND ATID = 51 AND IdentityField = 648957551
	DELETE FROM CurrentBalanceAudit WHERE AID = 9407183 AND ATID = 51 AND IdentityField = 653116718



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 9596679
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 52.33, AmountOfPayment60DLate = AmountOfPayment60DLate - 52.33, 
	RunningMinimumDue = RunningMinimumDue - 52.33, RemainingMinimumDue = RemainingMinimumDue - 52.33, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, 
	DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 9596679

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 9596679 AND ATID = 51 AND IdentityField = 648957549
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 9596679 AND ATID = 51 AND IdentityField = 649222591
	DELETE FROM CurrentBalanceAudit WHERE AID = 9596679 AND ATID = 51 AND IdentityField = 649252412
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30183148556, '2020-09-01 10:05:16.000', 51, 9596679, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 31.67 WHERE acctId = 9608821
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 31.67, RunningMinimumDue = RunningMinimumDue - 31.67,
	 RemainingMinimumDue = RemainingMinimumDue - 31.67, DateOfOriginalPaymentDueDTD = NULL  WHERE acctId = 9608821

	UPDATE CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.82, AmountOfTotalDue = AmountOfTotalDue - 21.82 WHERE acctId = 23700979

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29964944837, '2020-09-01 08:38:35.000', 51, 9608821, 115, '1', '0'),
	(29964944837, '2020-09-01 08:38:35.000', 51, 9608821, 200, '31.67', '0.00')

	UPDATE CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 23700979 AND ATID = 52 AND IdentityField = 1040806724
	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29964944837, '2020-09-01 08:38:35.000', 52, 23700979, 115, '1', '0')



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 4617276
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, AmountOfPayment60DLate = AmountOfPayment60DLate - 25.00, 
	RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00, DaysDelinquent = 0, 
	DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 4617276

	UPDATE CurrentBalanceAudit SET NewValue = '0' WHERE AID = 4617276 AND ATID = 51 AND IdentityField = 648957052
	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4617276 AND ATID = 51 AND IdentityField = 648957053



	UPDATE BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 4191664
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, AmountOfPayment60DLate = AmountOfPayment60DLate - 25.00, 
	RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL, 
	DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, NoPayDaysDelinquent = 0  WHERE acctId = 4191664

	UPDATE CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 4191664 AND ATID = 51 AND IdentityField = 653092964
	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(30222920300, '2020-09-02 12:55:38.000', 51, 4191664, 115, '1', '0')

COMMIT TRANSACTION
--ROLLBACK TRANSACTION