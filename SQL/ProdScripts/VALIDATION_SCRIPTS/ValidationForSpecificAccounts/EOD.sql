/*
VALIDATION# 1 - Due-BS/CPS
VALIDATION# 2 - BS Due sum of all buckets
VALIDATION# 3 - CPS Due sum of all buckets
VALIDATION# 4 - BS/CPS buckets
VALIDATION# 5 - AD/RMD
*/

DECLARE @DataPopulation INT = 0, @DataCorrection INT = 0, @Validation INT = 0, @Flag INT = 0

--SET @DataPopulation = 0
--SET @DataCorrection = 0
--SET @Validation = 1

SET @Flag = 3		-- 1-DataPopulation/ 2-DataCorrection/ 3-Validation



IF @Flag = 1
BEGIN

	DECLARE @BusinessDay DATETIME = '2022-04-30 23:59:57'

	DECLARE @StatementDate DATETIME = '2022-04-30 23:59:57'

	DROP TABLE IF EXISTS #CorrectionAccounts
	CREATE TABLE #CorrectionAccounts (AccountID INT)

	--INSERT INTO #CorrectionAccounts VALUES 
	--(17543409),(13592733),(17643501),(12882682),(3230968),(10343487),(654914),(18072885),(1108127),(1549088),(679012),(17674647),(19075941),(11536995),(782101),(10561001),(2188937)

	--INSERT INTO #CorrectionAccounts
	--SELECT SV.acctId 
	--FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
	--JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = @StatementDate)
	--WHERE SV.StatementDate = @StatementDate AND ValidationFail = 'Q10'
	--AND BS.SystemStatus <> 14 
	--AND SV.acctId  IN (12415, 13524, 14117, 47850, 52711, 115716, 122810, 244248, 417786, 588281, 659234, 883659, 1240951, 
	--1255358, 1344799, 1356278, 1378174, 1392139, 1508643, 1722050, 1841625, 1845697, 2105008, 2706267, 2724147, 2837196, 2983913,
	--3996361, 7853217, 8940606, 9806096, 10655987, 11089488, 11520974, 13572797, 13611044, 18041996, 18390195, 13071394, 20602937,
	--14886219, 16564141, 18074751, 18310493, 18533310, 21398959)

	--INSERT INTO #CorrectionAccounts
	--SELECT acctId FROM PastDueAgingReportData WITH (NOLOCK)
	--WHERE ReportDate = '2021-11-02 23:59:57.000'
	--AND CurrentDue + PastDueBalance > AmountOfTotalDue

	INSERT INTO #CorrectionAccounts
	SELECT AcctID FROM ##STMT__04302022__Q10

	INSERT INTO #CorrectionAccounts
	SELECT AcctID FROM ##STMT__04302022__Q29

	--INSERT INTO #CorrectionAccounts
	--SELECT BSacctId 
	--FROM AccountInfoForReport WITH (NOLOCK)
	--WHERE BusinessDay = @BusinessDay AND SystemStatus <> 14 AND BillingCycle = '31'

	SELECT '#CorrectionAccounts FILLED'

	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--STEP:1 :::::::::::::::::::::::: DATA POPULATION ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	DROP TABLE IF EXISTS #CorrectionPlans
	CREATE TABLE #CorrectionPlans (PlanID INT, AccountID INT)

	INSERT INTO #CorrectionPlans
	SELECT acctID, Parent02AID FROM CPSgmentAccounts CP WITH (NOLOCK) JOIN #CorrectionAccounts CA ON (CP.Parent02AID = CA.AccountID)

	SELECT '#CorrectionPlans FILLED'

	DROP TABLE IF EXISTS #AccountInfoForReport
	SELECT BSacctId acctId, ltrim(rtrim(AccountNumber)) AS AccountNumber, SystemStatus, ccinhparent125AID, CurrentBalance, Principal, CycleDueDTD, AmtOfPayCurrDue,
	amountoftotaldue, runningminimumdue,remainingminimumdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, daysdelinquent,TotalDaysDelinquent,
	dateoforiginalpaymentduedtd, DateOfDelinquency
	INTO #AccountInfoForReport
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK)
	JOIN #CorrectionAccounts CA ON (AIR.BSacctId = CA.AccountID AND AIR.BusinessDay = @BusinessDay)

	SELECT '#AccountInfoForReport FILLED'

	DROP TABLE IF EXISTS #PlanInfoForReport
	SELECT CPSacctId acctId, CycleDueDTD, amountoftotaldue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
	AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue
	INTO #PlanInfoForReport
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.dbo.PlanInfoForReport PIR WITH (NOLOCK)
	JOIN #CorrectionPlans CP ON (PIR.CPSacctId = CP.PlanID AND PIR.BusinessDay = @BusinessDay)

	SELECT '#PlanInfoForReport FILLED'

	SELECT 'DATA POPULATION FINISHED'

END

--SElect * FROM #AccountInfoForReport WHERE acctId = 2986959

IF @Flag = 3
BEGIN

	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--STEP:2:::::::::::::::: SELECT QUERIES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


	;WITH AccountDue AS (SELECT acctId, AmountOfTotalDue FROM #AccountInfoForReport)
	,PlanWiseDue AS (SELECT AccountID, AmountOfTotalDue FROM #PlanInfoForReport CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID))
	,PlanDue AS (SELECT AccountID, SUM(AmountOfTotalDue) AmountOfTotalDue FROM PlanWiseDue GROUP BY AccountID)
	,CollectedData AS (
	SELECT AD.acctID, AD.AmountOfTotalDue AD_Account, PD.AmountOfTotalDue AD_Plan, AD.AmountOfTotalDue-PD.AmountOfTotalDue DIFF 
	FROM AccountDue AD 
	JOIN PlanDue PD ON (AD.acctId = PD.AccountID))
	SELECT 'VALIDATION# 1' ValidationNumber, 'Due-BS/CPS' Validation,* FROM CollectedData WHERE DIFF <> 0


	;WITH BSDue AS (
	SELECT BP.acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #AccountInfoForReport BP WITH (NOLOCK))
	SELECT 'VALIDATION# 2' ValidationNumber, 'BS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM BSDue WHERE AmountOfTotalDue - CalculatedAD <> 0

	;WITH CPSDue AS (
	SELECT acctID, AmountOfTotalDue, 
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
	FROM #PlanInfoForReport CC)
	SELECT 'VALIDATION# 3' ValidationNumber, 'CPS Due sum of all buckets' Validation, *, AmountOfTotalDue - CalculatedAD DIFF FROM CPSDue WHERE AmountOfTotalDue - CalculatedAD <> 0


	;WITH AccountDue AS 
	(
		SELECT BP.acctID, CycleDueDTD, AmountOfTotalDue, 
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #AccountInfoForReport BP WITH (NOLOCK)
	)
	,PlanWiseDue AS 
	(
		SELECT AccountID, CycleDueDTD, AmountOfTotalDue,
		amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
		AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
		FROM #PlanInfoForReport CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)
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
	FROM #AccountInfoForReport
	WHERE AmountOfTotalDue <> RunningMinimumDue OR AmountOfTotalDue <> RemainingMinimumDue OR RunningMinimumDue <> RemainingMinimumDue

END

IF @Flag = 2
BEGIN


UPDATE TOP(1) #AccountInfoForReport SET AmountoftotalDue =64.07, RunningMinimumDue = 64.07, AmtOfPayCurrDue = 64.07, RemainingMinimumDue = 64.07 WHERE acctID = 600734 
UPDATE TOP(1) #AccountInfoForReport SET AmountoftotalDue =29.15, RunningMinimumDue = 29.15, AmtOfPayCurrDue = 29.15, RemainingMinimumDue = 29.15 WHERE acctID = 927169 

UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.49, AmountOfTotalDue = 0.49 WHERE acctID = 400354 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.43, AmountOfTotalDue = 0.43 WHERE acctID = 612954 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.13, AmountOfTotalDue = 0.13 WHERE acctID = 665246 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.24, AmountOfTotalDue = 0.24 WHERE acctID = 849004 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.16, AmountOfTotalDue = 0.16 WHERE acctID = 928046 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.41, AmountOfTotalDue = 0.41 WHERE acctID = 939589 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.18, AmountOfTotalDue = 0.18 WHERE acctID = 40178332 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.26, AmountOfTotalDue = 0.26 WHERE acctID = 41773305 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.03, AmountOfTotalDue = 0.03 WHERE acctID = 44555401 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.33, AmountOfTotalDue = 0.33 WHERE acctID = 1873230 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.15, AmountOfTotalDue = 0.15 WHERE acctID = 2436169 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.24, AmountOfTotalDue = 0.24 WHERE acctID = 44500242 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.02, AmountOfTotalDue = 0.02 WHERE acctID = 43872295 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.45, AmountOfTotalDue = 0.45 WHERE acctID = 3485825 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.20, AmountOfTotalDue = 0.20 WHERE acctID = 8571275 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.44, AmountOfTotalDue = 0.44 WHERE acctID = 12411494 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.23, AmountOfTotalDue = 0.23 WHERE acctID = 14757576 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.43, AmountOfTotalDue = 0.43 WHERE acctID = 24048639 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.40, AmountOfTotalDue = 0.40 WHERE acctID = 32622475 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.30, AmountOfTotalDue = 0.30 WHERE acctID = 51201201 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.11, AmountOfTotalDue = 0.11 WHERE acctID = 51368173 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.25, AmountOfTotalDue = 0.25 WHERE acctID = 51393888 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.31, AmountOfTotalDue = 0.31 WHERE acctID = 51446989 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.07, AmountOfTotalDue = 0.07 WHERE acctID = 51452228 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.34, AmountOfTotalDue = 0.34 WHERE acctID = 53187717 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.49, AmountOfTotalDue = 0.49 WHERE acctID = 53648463 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.22, AmountOfTotalDue = 0.22 WHERE acctID = 57535239 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.15, AmountOfTotalDue = 0.15 WHERE acctID = 58707856 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.14, AmountOfTotalDue = 0.14 WHERE acctID = 59165319 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.46, AmountOfTotalDue = 0.46 WHERE acctID = 59779807 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.28, AmountOfTotalDue = 0.28 WHERE acctID = 59821658 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.41, AmountOfTotalDue = 0.41 WHERE acctID = 61890097 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.10, AmountOfTotalDue = 0.10 WHERE acctID = 66711460 
UPDATE TOP(1) #PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = 0.16, AmountOfTotalDue = 0.16 WHERE acctID = 67316691 




END