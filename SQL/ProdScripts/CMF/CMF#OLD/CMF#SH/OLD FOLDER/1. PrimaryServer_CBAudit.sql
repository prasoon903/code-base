-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE TOP(1) WILL BE 1 ROW EACH


	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '41.58' WHERE AID = 8171272 AND ATID = 51 AND IdentityField = 800800882

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '41.58' WHERE AID = 21938790 AND ATID = 52 AND IdentityField = 1292734535
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '41.58' WHERE AID = 21938790 AND ATID = 52 AND IdentityField = 1292734537
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '41.58' WHERE AID = 21938790 AND ATID = 52 AND IdentityField = 1292734538

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '195.29' WHERE AID = 3634910 AND ATID = 51 AND IdentityField = 797939951
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '195.29' WHERE AID = 3634910 AND ATID = 51 AND IdentityField = 797939956
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '195.29' WHERE AID = 3634910 AND ATID = 51 AND IdentityField = 797939957

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '153.79' WHERE AID = 23782402 AND ATID = 52 AND IdentityField = 1289151791
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '153.79' WHERE AID = 23782402 AND ATID = 52 AND IdentityField = 1289151793
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '153.79' WHERE AID = 23782402 AND ATID = 52 AND IdentityField = 1289151794

	DELETE FROM CurrentBalanceAudit WHERE AID = 8176949 AND ATID = 51 AND IdentityField = 800808989
	DELETE FROM CurrentBalanceAudit WHERE AID = 8176949 AND ATID = 51 AND IdentityField = 800808990
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '102.49' WHERE AID = 8176949 AND ATID = 51 AND IdentityField = 800808993
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '102.49' WHERE AID = 8176949 AND ATID = 51 AND IdentityField = 800808994

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '2.92' WHERE AID = 23420439 AND ATID = 52 AND IdentityField = 1292745608
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '2.92' WHERE AID = 23420439 AND ATID = 52 AND IdentityField = 1292745610
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '2.92' WHERE AID = 23420439 AND ATID = 52 AND IdentityField = 1292745611

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '15.93' WHERE AID = 3922688 AND ATID = 51 AND IdentityField = 798132399

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '15.93' WHERE AID = 9161927 AND ATID = 52 AND IdentityField = 1289374883
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '15.93' WHERE AID = 9161927 AND ATID = 52 AND IdentityField = 1289374885
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '15.93' WHERE AID = 9161927 AND ATID = 52 AND IdentityField = 1289374886

	DELETE FROM CurrentBalanceAudit WHERE AID = 10196589 AND ATID = 51 AND IdentityField = 801771061
	DELETE FROM CurrentBalanceAudit WHERE AID = 10196589 AND ATID = 51 AND IdentityField = 801771062
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '152.16' WHERE AID = 10196589 AND ATID = 51 AND IdentityField = 801771065
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '152.16' WHERE AID = 10196589 AND ATID = 51 AND IdentityField = 801771066

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '4.01' WHERE AID = 33488934 AND ATID = 52 AND IdentityField = 1294253146
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '4.01' WHERE AID = 33488934 AND ATID = 52 AND IdentityField = 1294253148
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '4.01' WHERE AID = 33488934 AND ATID = 52 AND IdentityField = 1294253149

	DELETE FROM CurrentBalanceAudit WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602592
	DELETE FROM CurrentBalanceAudit WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602593
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '50.14' WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602595
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '50.14' WHERE AID = 9841530 AND ATID = 51 AND IdentityField = 801602596

	DELETE FROM CurrentBalanceAuditPS WHERE AID = 24143688 AND ATID = 52 AND IdentityField = 1293981397

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981402
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981404
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.01' WHERE AID = 30127516 AND ATID = 52 AND IdentityField = 1293981405	

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1', oldvalue = '0' WHERE AID = 4638731 AND ATID = 51 AND IdentityField = 799155502
	DELETE FROM CurrentBalanceAudit WHERE AID = 4638731 AND ATID = 51 AND IdentityField = 799155501
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '377.41' WHERE AID = 4638731 AND ATID = 51 AND IdentityField = 799155505
	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '377.41' WHERE AID = 4638731 AND ATID = 51 AND IdentityField = 799155507

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '29.07' WHERE AID = 12235611 AND ATID = 52 AND IdentityField = 1290602277
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '29.07' WHERE AID = 12235611 AND ATID = 52 AND IdentityField = 1290602279
	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '29.07' WHERE AID = 12235611 AND ATID = 52 AND IdentityField = 1290602280	

	UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1', oldvalue = '0' WHERE AID = 1987209 AND ATID = 51 AND IdentityField = 794212324
	UPDATE TOP(1) CurrentBalanceAuditps SET NewValue = '0.00' WHERE AID = 2017279 AND ATID = 52 AND IdentityField = 1284935716
	DELETE FROM CurrentBalanceAudit WHERE AID = 1987209 AND ATID = 51 AND IdentityField = 794212323
	DELETE FROM CurrentBalanceAuditps WHERE AID = 2017279 AND ATID = 52 AND IdentityField = 1284935717

	UPDATE TOP(1) CPSgmentCreditCard SET
	CurrentBalanceCO = CurrentBalanceCO - 0.71,
	SRBWithInstallmentDue = SRBWithInstallmentDue - 0.71,
	SBWithInstallmentDue = SBWithInstallmentDue - 0.71,
	AmountOfTotalDue = AmountOfTotalDue - 0.71,
	AmtOfPayCurrDue = AmtOfPayCurrDue - 0.71
	WHERE acctId = 12766333


	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3, AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75 WHERE acctId = 1667578
	UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 10.75, DtOfLastDelinqCTD = '2020-10-31 23:59:57.000', 
	FirstDueDate = '2020-10-31 23:59:57.000', DaysDelinquent = 22 WHERE acctId = 1667578

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION