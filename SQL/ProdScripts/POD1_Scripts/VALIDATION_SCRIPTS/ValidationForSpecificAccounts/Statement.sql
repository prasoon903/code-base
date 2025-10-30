/*
VALIDATION# 1 - Due-BS/CPS
VALIDATION# 2 - BS Due sum of all buckets
VALIDATION# 3 - CPS Due sum of all buckets
VALIDATION# 4 - BS/CPS buckets
VALIDATION# 5 - AD/MinPmtDue
VALIDATION# 6 - Past Due/ sum of all PastDue buckets
*/

DECLARE @DataPopulation INT = 0, @DataCorrection INT = 0, @Validation INT = 0, @Flag INT = 0

--SET @DataPopulation = 0
--SET @DataCorrection = 0
--SET @Validation = 1

SET @Flag = 1		-- 1-DataPopulation/ 2-DataCorrection/ 3-Validation

IF @Flag = 1
BEGIN
	DECLARE @StatementDate DATETIME = '2022-04-30 23:59:57'

	DROP TABLE IF EXISTS #CorrectionAccounts
	CREATE TABLE #CorrectionAccounts (AccountID INT)

	INSERT INTO #CorrectionAccounts VALUES 
	(16820165)

	--INSERT INTO #CorrectionAccounts
	--SELECT SV.acctId 
	--FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
	--JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = @StatementDate)
	--WHERE SV.StatementDate = @StatementDate AND ValidationFail = 'Q10'
	--AND BS.SystemStatus <> 14 
	--AND SV.acctId  IN (12415, 13524, 14117, 47850, 52711, 115716, 122810, 244248, 417786, 588281, 659234, 883659, 1240951, 
	--1255358, 1344799, 1356278, 1378174, 1392139, 1508643, 1722050, 1841625, 1845697, 2105008, 2706267, 2724147, 2837196, 2983913,
	--3996361, 7853217, 8940606, 9806096, 10655987, 11089488, 11520974, 13572797, 13611044, 18041996, 18390195, 13071394, 20602937,
	--14886219, 16564141, 18074751, 18310493, 18533310)

	

	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--STEP:1 :::::::::::::::::::::::: DATA POPULATION ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	DROP TABLE IF EXISTS #CorrectionPlans
	CREATE TABLE #CorrectionPlans (PlanID INT, AccountID INT)

	INSERT INTO #CorrectionPlans
	SELECT acctID, Parent02AID FROM CPSgmentAccounts CP WITH (NOLOCK) JOIN #CorrectionAccounts CA ON (CP.Parent02AID = CA.AccountID)

	DROP TABLE IF EXISTS #StatementHeader
	SELECT acctId, SH.StatementID, SH.StatementDate, ltrim(rtrim(AccountNumber)) AS AccountNumber, SystemStatus, ccinhparent125AID, CurrentBalance, Principal, CycleDueDTD, MinimumPaymentDue, AmtOfPayCurrDue,
	amountoftotaldue, AmtOfPayPastDue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, SBWithInstallmentDue,dateoforiginalpaymentduedtd 
	INTO #StatementHeader
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.dbo.StatementHeader SH WITH (NOLOCK)
	JOIN #CorrectionAccounts CA ON (SH.acctId = CA.AccountID AND SH.StatementDate = @StatementDate)



	DROP TABLE IF EXISTS #SummaryHeader
	SELECT acctId, SH.StatementID, SH.StatementDate, amountoftotaldue
	INTO #SummaryHeader
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.dbo.SummaryHeader SH WITH (NOLOCK)
	JOIN #CorrectionPlans CP ON (SH.acctId = CP.PlanID AND SH.StatementDate = @StatementDate)

	DROP TABLE IF EXISTS #SummaryHeaderCreditCard
	SELECT SHCC.acctId, SH.StatementID, CycleDueDTD, CurrentDue AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, SBWithInstallmentDue
	INTO #SummaryHeaderCreditCard
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK)
	JOIN #SummaryHeader SH ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
	JOIN #CorrectionPlans CP ON (SH.acctId = CP.PlanID AND SH.StatementDate = @StatementDate)
END


IF @Flag = 3
BEGIN

--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--STEP:2:::::::::::::::: SELECT QUERIES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


	;WITH AccountDue AS (SELECT acctId, AmountOfTotalDue FROM #StatementHeader)
	,PlanWiseDue AS (SELECT AccountID, AmountOfTotalDue FROM #SummaryHeader CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID))
	,PlanDue AS (SELECT AccountID, SUM(AmountOfTotalDue) AmountOfTotalDue FROM PlanWiseDue GROUP BY AccountID)
	,CollectedData AS (
	SELECT AD.acctID, AD.AmountOfTotalDue AD_Account, PD.AmountOfTotalDue AD_Plan, AD.AmountOfTotalDue-PD.AmountOfTotalDue DIFF 
	FROM AccountDue AD 
	JOIN PlanDue PD ON (AD.acctId = PD.AccountID))
	SELECT 'VALIDATION# 1' ValidationNumber, 'Due-BS/CPS' Validation,* FROM CollectedData WHERE DIFF <> 0


	;WITH BSDue AS (
	SELECT BP.acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #StatementHeader BP WITH (NOLOCK))
	SELECT 'VALIDATION# 2' ValidationNumber, 'BS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM BSDue WHERE AmountOfTotalDue - CalculatedAD <> 0

	;WITH CPSDue AS (
	SELECT SH.acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #SummaryHeader SH JOIN #SummaryHeaderCreditCard SHCC ON (SH.acctId = SHCC.acctId))
	SELECT 'VALIDATION# 3' ValidationNumber, 'CPS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM CPSDue WHERE AmountOfTotalDue - CalculatedAD <> 0

	--SELECT * FROM #SummaryHeader WHERE acctId = 59121967
	--SELECT * FROM #SummaryHeaderCreditCard WHERE acctId = 59121967

	;WITH AccountDue AS 
	(
		SELECT BP.acctID, CycleDueDTD, AmountOfTotalDue, 
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #StatementHeader BP WITH (NOLOCK)
	)
	,PlanWiseDue AS 
	(
		SELECT AccountID, CycleDueDTD, AmountOfTotalDue,
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #SummaryHeader SH JOIN #SummaryHeaderCreditCard SHCC ON (SH.acctId = SHCC.acctId) JOIN #CorrectionPlans CP ON (SH.acctId = CP.PlanID)
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


	SELECT 'VALIDATION# 5' ValidationNumber, 'AD/MinPmtDue' Validation, * 
	FROM #StatementHeader
	WHERE AmountOfTotalDue <> MinimumPaymentDue

	;WITH BSDue AS (
	SELECT BP.acctID, AmtOfPayPastDue, 
	(AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedPD
	FROM #StatementHeader BP WITH (NOLOCK))
	SELECT 'VALIDATION# 6' ValidationNumber, 'Past Due/ sum of all PastDue buckets' Validation, *, AmtOfPayPastDue - CalculatedPD DIFF FROM BSDue WHERE AmtOfPayPastDue - CalculatedPD <> 0

END

--IF @Flag = 2
--BEGIN



--END