-- TO BE RUN ON PRIMARY SERVER ONLY

SELECT 'BSegment',
	CycleDueDTD, SystemStatus, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.acctId = 5037

SELECT 'CPSgment',
	CycleDueDTD, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM CPSgmentCreditCard WITH (NOLOCK)
WHERE acctId = 5078

SELECT 'StatementHeader',
	CycleDueDTD, SystemStatus, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM StatementHeader WITH (NOLOCK)
WHERE acctId = 5037 AND StatementDate = '2018-03-31 23:59:57.000'

SELECT 'SummaryHeader',
	CycleDueDTD, CurrentDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.acctId = 5078 AND SH.StatementID = 5001

SELECT 'AccountInfoForReport',
	CycleDueDTD, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSacctId = 5037 AND Businessday = '2018-03-31 23:59:57.000'

SELECT 'PlanInfoForReport',
	CycleDueDTD, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue
FROM PlanInfoForReport WITH (NOLOCK)
WHERE CPSacctId = 5078 AND Businessday = '2018-03-31 23:59:57.000'


BEGIN TRANSACTION

	-- UPDATE TOP(1) WILL BE 1 ROW EACH

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 5037
	UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 83.33, AmountOfTotalDue = AmountOfTotalDue - 83.33, 
	SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33,
	RunningMinimumDue = RunningMinimumDue - 83.33, RemainingMinimumDue = RemainingMinimumDue - 83.33 WHERE acctId = 5037

	UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 83.33, AmountOfTotalDue = AmountOfTotalDue - 83.33, CycleDueDTD = 1,
	SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33 WHERE acctId = 5078

	--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '2' WHERE AID = 5037 AND ATID = 51 AND IdentityField = 719608203
	--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1' WHERE AID = 5037 AND ATID = 51 AND IdentityField = 719608205
	--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '64.49' WHERE AID = 5037 AND ATID = 51 AND IdentityField = 719608208
	--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '64.49' WHERE AID = 5037 AND ATID = 51 AND IdentityField = 719608210
	--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '64.49' WHERE AID = 5037 AND ATID = 51 AND IdentityField = 719608212

	--UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0' WHERE AID = 5078 AND ATID = 52 AND IdentityField = 1157382314

	UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayXDLate = AmtOfPayXDLate - 83.33, AmountOfTotalDue = AmountOfTotalDue - 83.33, 
	SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33 
	WHERE acctId = 5037 AND StatementDate = '2018-03-31 23:59:57.000'

	UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 83.33,
	SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33 
	WHERE acctId = 5078 AND StatementID = 5001
	UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 83.33 WHERE acctId = 5078 AND StatementID = 5001

	
	UPDATE AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayXDLate = AmtOfPayXDLate - 83.33, 
	AmountOfTotalDue = AmountOfTotalDue - 83.33, SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33,
	RunningMinimumDue = RunningMinimumDue - 83.33, RemainingMinimumDue = RemainingMinimumDue - 83.33 WHERE 
	BSacctId = 5037 AND Businessday = '2018-03-31 23:59:57.000'

	UPDATE PlanInfoForReport SET AmtOfPayXDLate = AmtOfPayXDLate - 83.33, AmountOfTotalDue = AmountOfTotalDue - 83.33,
	CycleDueDTD = 1, SBWithInstallmentDue = SBWithInstallmentDue - 83.33, SRBWithInstallmentDue = SRBWithInstallmentDue - 83.33 WHERE 
	CPSacctId = 5078 AND Businessday = '2018-03-31 23:59:57.000'


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION