-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE TOP(1) WILL BE 1 ROW EACH

	UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.53, SBWithInstallmentDue = SBWithInstallmentDue + 41.58, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 41.58 WHERE acctId = 8171272 AND StatementDate = '2020-10-31 23:59:57.000'
	
	UPDATE TOP(1) SummaryHeaderCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue + 41.58, SRBWithInstallmentDue = SRBWithInstallmentDue + 41.58 WHERE acctId = 21938790 AND StatementID = 44219848
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 41.58 WHERE acctId = 21938790 AND StatementID = 44219848
	
	UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 188.93, AmountOfTotalDue = AmountOfTotalDue + 188.93, 
	SBWithInstallmentDue = SBWithInstallmentDue + 153.79, SRBWithInstallmentDue = SRBWithInstallmentDue + 153.79 WHERE acctId = 3634910 AND StatementDate = '2020-10-31 23:59:57.000'
	
	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 2253.04,SBWithInstallmentDue = SBWithInstallmentDue + 2253.04, SRBWithInstallmentDue = SRBWithInstallmentDue + 2253.04 WHERE 
	acctId = 23782402 AND StatementID = 43534156
	UPDATE TOP(1) SummaryHeader SET  AmountOfTotalDue = AmountOfTotalDue + 351.24 WHERE acctId = 23782402 AND StatementID = 43534156
	
	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 6.71, AmtOfPayXDLate = AmtOfPayXDLate - 6.71, 
	SBWithInstallmentDue = SBWithInstallmentDue + 2.92, SRBWithInstallmentDue = SRBWithInstallmentDue + 2.92 WHERE acctId = 8176949 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 122.28, SBWithInstallmentDue = SBWithInstallmentDue + 122.28, SRBWithInstallmentDue = SRBWithInstallmentDue + 122.28 WHERE 
	acctId = 23420439 AND StatementID = 44217231
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 122.28 WHERE acctId = 23420439 AND StatementID = 44217231

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 6.71 WHERE acctId = 23420439 AND StatementID = 44217231
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 6.71 WHERE acctId = 23544712 AND StatementID = 44217231

	UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 14.85, AmountOfTotalDue = AmountOfTotalDue + 14.85, 
	SBWithInstallmentDue = SBWithInstallmentDue + 15.93, SRBWithInstallmentDue = SRBWithInstallmentDue + 15.93 WHERE acctId = 3922688 AND StatementDate = '2020-10-31 23:59:57.000'
	
	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 351.24,SBWithInstallmentDue = SBWithInstallmentDue + 351.24, SRBWithInstallmentDue = SRBWithInstallmentDue + 351.24 WHERE 
	acctId = 9161927 AND StatementID = 43571449
	UPDATE TOP(1) SummaryHeader SET  AmountOfTotalDue = AmountOfTotalDue + 351.24 WHERE acctId = 9161927 AND StatementID = 43571449

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.16, AmtOfPayXDLate = AmtOfPayXDLate - 20.16, 
	SBWithInstallmentDue = SBWithInstallmentDue + 4.01, SRBWithInstallmentDue = SRBWithInstallmentDue + 4.01 WHERE acctId = 10196589 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 149.11, SBWithInstallmentDue = SBWithInstallmentDue + 149.11, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 149.11 WHERE acctId = 33488934 AND StatementID = 44454910
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 149.11 WHERE acctId = 33488934 AND StatementID = 44454910

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 1.3 WHERE acctId = 22565116 AND StatementID = 44177452
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 1.3 WHERE acctId = 22565116 AND StatementID = 44177452

	DELETE FROM CurrentBalanceAudit WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602592
	DELETE FROM CurrentBalanceAudit WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602593
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '50.14' WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602595
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '50.14' WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602596

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 24143688 AND ATID = 52 AND IdentityField = 1293981397

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981402
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981404
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981405

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 12.80, AmountOfPayment30DLate = AmountOfPayment30DLate - 12.80, 
	SBWithInstallmentDue = SBWithInstallmentDue + 21.01, SRBWithInstallmentDue = SRBWithInstallmentDue + 21.01 WHERE acctId = 9841530 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmountOfPayment30DLate = AmountOfPayment30DLate - 12.80 WHERE acctId = 24143688 AND StatementID = 44414172
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 12.80 WHERE acctId = 24143688 AND StatementID = 44414172

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 147.69, SBWithInstallmentDue = SBWithInstallmentDue + 147.69, 
	SRBWithInstallmentDue = SRBWithInstallmentDue + 147.69 WHERE acctId = 30127516 AND StatementID = 44414172
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 147.69 WHERE acctId = 30127516 AND StatementID = 44414172

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 39.02, AmtOfPayXDLate = AmtOfPayXDLate - 39.02, 
	DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 11208697 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 24.68 WHERE acctId = 505549 AND StatementID = 41780711
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.68 WHERE acctId = 505549 AND StatementID = 41780711

	UPDATE TOP(1)  SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 2246746 AND StatementID = 42870524
	UPDATE TOP(1)   SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2246746 AND StatementID = 42870524
	UPDATE TOP(1)  SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 8067635 AND StatementID = 43745433
	UPDATE TOP(1)   SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 8067635 AND StatementID = 43745433
	UPDATE TOP(1)  SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 2987495 AND StatementID = 43336672
	UPDATE TOP(1)   SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2987495 AND StatementID = 43336672
	UPDATE TOP(1)  SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 2154247 AND StatementID = 42802990
	UPDATE TOP(1)   SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2154247 AND StatementID = 42802990	

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue +  16.44, AmtOfPayXDLate = AmtOfPayXDLate - 16.44, 
	SBWithInstallmentDue = SBWithInstallmentDue + 29.07, SRBWithInstallmentDue = SRBWithInstallmentDue + 29.07  WHERE acctId = 4638731 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 16.44 WHERE acctId = 8660889 AND StatementID = 43817459
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 16.44 WHERE acctId = 8660889 AND StatementID = 43817459

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 653.49, SBWithInstallmentDue = SBWithInstallmentDue + 653.49, SRBWithInstallmentDue = SRBWithInstallmentDue+ 653.49 WHERE acctId = 12235611 AND StatementID = 43817459
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 653.49 WHERE acctId = 12235611 AND StatementID = 43817459	

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue +   3.25, AmtOfPayXDLate = AmtOfPayXDLate - 3.25, 
	SBWithInstallmentDue = SBWithInstallmentDue + 27.13, SRBWithInstallmentDue = SRBWithInstallmentDue + 27.13  WHERE acctId = 1987209 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 3.25 WHERE acctId = 2017279 AND StatementID = 42694459
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 3.25 WHERE acctId = 2017279 AND StatementID = 42694459

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 703.91, SBWithInstallmentDue = SBWithInstallmentDue + 703.91, SRBWithInstallmentDue = SRBWithInstallmentDue+ 703.91 WHERE acctId = 32943581 AND StatementID = 42694459
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 703.91 WHERE acctId = 32943581 AND StatementID = 42694459
	
	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 25.00 WHERE acctId = 589856 AND StatementID = 42694459
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 25.00 WHERE acctId = 589856 AND StatementID = 41491646

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 1097.58, SBWithInstallmentDue = SBWithInstallmentDue + 1097.58, SRBWithInstallmentDue = SRBWithInstallmentDue + 1097.58 WHERE 
	acctId = 33148313 AND StatementID = 41491646
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 1097.58 WHERE acctId = 33148313 AND StatementID = 41491646
	
	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayXDLate = AmtOfPayXDLate - 29.87 WHERE acctId = 11368001 AND StatementDate = '2020-10-31 23:59:57.000'
	
	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue +   17.73, AmtOfPayXDLate = AmtOfPayXDLate - 17.73, 
	SBWithInstallmentDue = SBWithInstallmentDue + 25.31, SRBWithInstallmentDue = SRBWithInstallmentDue + 25.31  WHERE acctId = 1878778 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 17.73 WHERE acctId = 1901088 AND StatementID = 42600409
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 17.73 WHERE acctId = 1901088 AND StatementID = 42600409

	UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 1058.49, SBWithInstallmentDue = SBWithInstallmentDue + 1058.49, SRBWithInstallmentDue = SRBWithInstallmentDue+ 1058.49 WHERE acctId = 33101004 AND StatementID = 42600409
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 1058.49 WHERE acctId = 33101004 AND StatementID = 42600409
	
	UPDATE TOP(1) StatementHeader SET
	CurrentBalanceCO = CurrentBalanceCO - 0.71,
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71
	WHERE acctId = 1875442 AND StatementDate = '2020-10-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeader SET
	AmountOfTotalDue = AmountOfTotalDue - 0.71
	WHERE acctId = 12766333 AND StatementId = 42587983

	UPDATE TOP(1) SummaryHeaderCreditCard SET
	CurrentBalanceCO = CurrentBalanceCO - 0.71,
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71,
	CurrentDue = CurrentDue - 2.02
	WHERE acctId = 12766333 AND StatementId = 42587983

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 2, SystemStatus = 3, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75, 
	AmtOfPayXDLate = AmtOfPayXDLate + 10.75 WHERE acctId = 1667578 AND StatementDate = '2020-10-31 23:59:57.000'

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION