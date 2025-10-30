-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue + 5.12, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.12 WHERE acctId = 417861

	UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '5.12' WHERE AID = 417861 AND ATID = 52 AND IdentityField = 1227993413
	DELETE FROM CurrentBalanceAuditPS WHERE AID = 417861 AND ATID = 52 AND IdentityField = 1227993414



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.08, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.08 WHERE acctId = 1938186

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31465791527, '2020-10-19 07:37:34.000', 52, 1938186, 200, '22.08', '0.00'),
	(31465791527, '2020-10-19 07:37:34.000', 52, 1938186, 115, '1', '0')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 24.27, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.27 WHERE acctId = 4320769

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31489119383, '2020-10-19 20:35:25.000', 52, 4320769, 200, '24.27', '0.00'),
	(31489119383, '2020-10-19 20:35:25.000', 52, 4320769, 115, '1', '0')



	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 22.83, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.83 WHERE acctId = 362315

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(31465088144, '2020-10-19 07:37:34.000', 52, 362315, 200, '22.83', '0.00'),
	(31465088144, '2020-10-19 07:37:34.000', 52, 362315, 115, '1', '0')


COMMIT TRANSACTION
--ROLLBACK TRANSACTION