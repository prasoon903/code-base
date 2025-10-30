/*
VALIDATION# 1 - Due-BS/CPS
VALIDATION# 2 - BS Due sum of all buckets
VALIDATION# 3 - CPS Due sum of all buckets
VALIDATION# 4 - BS/CPS buckets
VALIDATION# 5 - AD/RMD
VALIDATION# 6 - AD/SRB
VALIDATION# 7 - CycleDueDTD/DateOfDelinquencies
VALIDATION# 7 - Due=0 and CycleDueDTD>0 on CPS
*/



DECLARE @DataPopulation INT = 0, @DataCorrection INT = 0, @Validation INT = 0, @Flag INT = 0

--SET @DataPopulation = 0
--SET @DataCorrection = 0
--SET @Validation = 1

SET @Flag = 3	-- 1-DataPopulation/ 2-DataCorrection/ 3-Validation

DROP TABLE IF EXISTS #CorrectionAccounts
CREATE TABLE #CorrectionAccounts (AccountID INT)

--4733586, 12887, 3783604, 10772, 284978, 3748505, 2259429, 4640763, 275808, 4337624, 10667


IF @Flag = 1
BEGIN

	DECLARE @StatementDate DATETIME = '2021-11-30 23:59:57'

	--INSERT INTO #CorrectionAccounts VALUES 
	--(4733586), (12887), (3783604), (10772), (284978), (3748505), (2259429), (4640763), (275808), (4337624), (10667)

	--INSERT INTO #CorrectionAccounts
	--SELECT SV.acctId 
	--FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
	--JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = @StatementDate)
	--WHERE SV.StatementDate = @StatementDate AND ValidationFail = 'Q10'
	--AND BS.SystemStatus <> 14

	--INSERT INTO #CorrectionAccounts
	--SELECT acctId FROM PastDueAgingReportData WITH (NOLOCK)
	--WHERE ReportDate = '2021-11-02 23:59:57.000'
	--AND CurrentDue + PastDueBalance > AmountOfTotalDue

	--INSERT INTO #CorrectionAccounts
	--SELECT BSAcctID FROM ##BSRecords

	INSERT INTO #CorrectionAccounts
	SELECT acctId FROM BSegment_Primary WITH (NOLOCK) WHERE acctID IN
	(12930750)

	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--STEP:1 :::::::::::::::::::::::: DATA POPULATION ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	DROP TABLE IF EXISTS #CorrectionPlans
	CREATE TABLE #CorrectionPlans (PlanID INT, AccountID INT)

	INSERT INTO #CorrectionPlans
	SELECT acctID, Parent02AID FROM CPSgmentAccounts CP WITH (NOLOCK) JOIN #CorrectionAccounts CA ON (CP.Parent02AID = CA.AccountID)

	DROP TABLE IF EXISTS #BSegment_Primary
	SELECT acctId, ltrim(rtrim(AccountNumber)) AS AccountNumber, SystemStatus, ccinhparent125AID, CurrentBalance, Principal, CycleDueDTD, AmtOfPayCurrDue, DeAcctActivityDate 
	INTO #BSegment_Primary
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary BP WITH (NOLOCK)
	JOIN #CorrectionAccounts CA ON (BP.acctId = CA.AccountID)


	DROP TABLE IF EXISTS #BSegmentCreditCard
	SELECT acctId, amountoftotaldue, runningminimumdue,remainingminimumdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, SBWithInstallmentDue, daysdelinquent,nopaydaysdelinquent,
	firstduedate,dateoforiginalpaymentduedtd, DtOfLastDelinqCTD
	INTO #BSegmentCreditCard
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegmentCreditCard BC WITH (NOLOCK)
	JOIN #CorrectionAccounts CA ON (BC.acctId = CA.AccountID)


	DROP TABLE IF EXISTS #CPSgmentCreditCard
	SELECT acctId, CycleDueDTD, amountoftotaldue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, SBWithInstallmentDue, EstimatedDue, RollOverDue
	INTO #CPSgmentCreditCard
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CPSgmentCreditCard CC WITH (NOLOCK)
	JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)
END


IF @Flag = 3
BEGIN

	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--STEP:2:::::::::::::::: SELECT QUERIES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


	;WITH AccountDue AS (SELECT acctId, AmountOfTotalDue FROM #BSegmentCreditCard)
	,PlanWiseDue AS (SELECT AccountID, AmountOfTotalDue FROM #CPSgmentCreditCard CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID))
	,PlanDue AS (SELECT AccountID, SUM(AmountOfTotalDue) AmountOfTotalDue FROM PlanWiseDue GROUP BY AccountID)
	,CollectedData AS (
	SELECT AD.acctID, AD.AmountOfTotalDue AD_Account, PD.AmountOfTotalDue AD_Plan, AD.AmountOfTotalDue-PD.AmountOfTotalDue DIFF 
	FROM AccountDue AD 
	JOIN PlanDue PD ON (AD.acctId = PD.AccountID))
	SELECT 'VALIDATION# 1' ValidationNumber, 'Due-BS/CPS' Validation,* FROM CollectedData WHERE DIFF <> 0


	;WITH BSDue AS (
	SELECT BP.acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #BSegment_Primary BP WITH (NOLOCK)
	JOIN #BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId))
	SELECT 'VALIDATION# 2' ValidationNumber, 'BS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM BSDue WHERE AmountOfTotalDue - CalculatedAD <> 0

	;WITH CPSDue AS (
	SELECT acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #CPSgmentCreditCard CC)
	SELECT 'VALIDATION# 3' ValidationNumber, 'CPS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM CPSDue WHERE AmountOfTotalDue - CalculatedAD <> 0


	;WITH AccountDue AS 
	(
		SELECT BP.acctID, CycleDueDTD, AmountOfTotalDue, 
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #BSegment_Primary BP WITH (NOLOCK)
		JOIN #BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	)
	,PlanWiseDue AS 
	(
		SELECT AccountID, CycleDueDTD, AmountOfTotalDue,
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #CPSgmentCreditCard CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)
	)
	,PlanDue AS 
	(
		SELECT AccountID, MAX(CycleDueDTD) CycleDueDTD, SUM(AmountOfTotalDue) AmountOfTotalDue, SUM(amtofpaycurrdue) amtofpaycurrdue,SUM(AmtOfPayXDLate) AmtOfPayXDLate,
		SUM(AmountOfPayment30DLate) AmountOfPayment30DLate, SUM(AmountOfPayment60DLate) AmountOfPayment60DLate, 
		SUM(AmountOfPayment90DLate) AmountOfPayment90DLate, SUM(AmountOfPayment120DLate) AmountOfPayment120DLate, 
		SUM(AmountOfPayment150DLate) AmountOfPayment150DLate, SUM(AmountOfPayment180DLate) AmountOfPayment180DLate, SUM(AmountOfPayment210DLate) AmountOfPayment210DLate
		FROM PlanWiseDue GROUP BY AccountID
	)
	, CollectedData AS
	(
	SELECT AD.acctID, 
	AD.CycleDueDTD CycleDueDTD_Account, PD.CycleDueDTD CycleDueDTD_Plan,AD.CycleDueDTD - PD.CycleDueDTD CycleDueDTD_DIFF,
	AD.AmountOfTotalDue AD_Account, PD.AmountOfTotalDue AD_Plan, AD.AmountOfTotalDue-PD.AmountOfTotalDue AD_DIFF,
	AD.amtofpaycurrdue CD_Account, PD.amtofpaycurrdue CD_Plan, AD.amtofpaycurrdue-PD.amtofpaycurrdue CD_DIFF,
	AD.AmtOfPayXDLate CPD1_Account, PD.AmtOfPayXDLate CPD1_Plan, AD.AmtOfPayXDLate-PD.AmtOfPayXDLate CPD1_DIFF,
	AD.AmountOfPayment30DLate CPD2_Account, PD.AmountOfPayment30DLate CPD2_Plan, AD.AmountOfPayment30DLate-PD.AmountOfPayment30DLate CPD2_DIFF,
	AD.AmountOfPayment60DLate CPD3_Account, PD.AmountOfPayment60DLate CPD3_Plan, AD.AmountOfPayment60DLate-PD.AmountOfPayment60DLate CPD3_DIFF,
	AD.AmountOfPayment90DLate CPD4_Account, PD.AmountOfPayment90DLate CPD4_Plan, AD.AmountOfPayment90DLate-PD.AmountOfPayment90DLate CPD4_DIFF,
	AD.AmountOfPayment120DLate CPD5_Account, PD.AmountOfPayment120DLate CPD5_Plan, AD.AmountOfPayment120DLate-PD.AmountOfPayment120DLate CPD5_DIFF,
	AD.AmountOfPayment150DLate CPD6_Account, PD.AmountOfPayment150DLate CPD6_Plan, AD.AmountOfPayment150DLate-PD.AmountOfPayment150DLate CPD6_DIFF,
	AD.AmountOfPayment180DLate CPD7_Account, PD.AmountOfPayment180DLate CPD7_Plan, AD.AmountOfPayment180DLate-PD.AmountOfPayment180DLate CPD7_DIFF,
	AD.AmountOfPayment210DLate CPD8_Account, PD.AmountOfPayment210DLate CPD8_Plan, AD.AmountOfPayment210DLate-PD.AmountOfPayment210DLate CPD8_DIFF
	FROM AccountDue AD 
	JOIN PlanDue PD ON (AD.acctId = PD.AccountID)
	)
	SELECT 'VALIDATION# 4' ValidationNumber, 'BS/CPS buckets' Validation, * 
	FROM CollectedData
	WHERE CycleDueDTD_DIFF <> 0 OR AD_DIFF <> 0 OR CD_DIFF <> 0 OR CPD1_DIFF <> 0 OR CPD2_DIFF <> 0 OR CPD3_DIFF <> 0 
	OR CPD4_DIFF <> 0 OR CPD5_DIFF <> 0 OR CPD6_DIFF <> 0 OR CPD7_DIFF <> 0 OR CPD8_DIFF <> 0



	SELECT 'VALIDATION# 5' ValidationNumber, 'AD/RMD' Validation, acctId, AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue 
	FROM #BSegmentCreditCard
	WHERE AmountOfTotalDue <> RunningMinimumDue OR AmountOfTotalDue <> RemainingMinimumDue OR RunningMinimumDue <> RemainingMinimumDue

	SELECT 'VALIDATION# 6' ValidationNumber, 'AD/SRB' Validation, acctId, AmountOfTotalDue, SRBWithInstallmentDue
	FROM #BSegmentCreditCard
	WHERE AmountOfTotalDue > SRBWithInstallmentDue

	SELECT 'VALIDATION# 7' ValidationNumber, 'CycleDueDTD/DateOfDelinquencies' Validation, BP.acctId, CycleDueDTD, DateOfOriginalPaymentDueDTD, DtOfLastDelinqCTD
	FROM #BSegmentCreditCard BCC
	JOIN #BSegment_Primary BP ON (BCC.acctId = BP.acctId)
	WHERE (CycleDueDTD = 0 AND DateOfOriginalPaymentDueDTD IS NOT NULL)
	OR (CycleDueDTD >= 1 AND DateOfOriginalPaymentDueDTD IS NULL)
	OR (CycleDueDTD >= 2 AND DtOfLastDelinqCTD IS NULL)

	
	SELECT 'VALIDATION# 8' ValidationNumber, 'Due=0 and CycleDueDTD>0 on CPS' Validation, AccountID, CC.acctId PlanID, CycleDueDTD, AmountOfTotalDue,
	amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
	AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
	FROM #CPSgmentCreditCard CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)
	WHERE CC.AmountOfTotalDue <= 0 AND CycleDueDTD > 0

END

IF @Flag = 2
BEGIN

UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 19.12 WHERE acctID = 12930750
UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 19.12, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  
RunningMinimumDue = 19.12, RemainingMinimumDue = 19.12  WHERE acctID = 12930750

--UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 66143240


END