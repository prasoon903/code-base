

DROP TABLE IF EXISTS #CorrectionAccounts
CREATE TABLE #CorrectionAccounts (AccountID INT)

INSERT INTO #CorrectionAccounts VALUES 
(17543409),(13592733),(17643501),(12882682),(3230968),(10343487),(654914),(18072885),(1108127),(1549088),(679012),(17674647),(19075941),(11536995),(782101),(10561001),(2188937)

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
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN #CorrectionAccounts CA ON (BP.acctId = CA.AccountID)


DROP TABLE IF EXISTS #BSegmentCreditCard
SELECT acctId, amountoftotaldue, runningminimumdue,remainingminimumdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, daysdelinquent,nopaydaysdelinquent,
firstduedate,dateoforiginalpaymentduedtd, DtOfLastDelinqCTD
INTO #BSegmentCreditCard
FROM BSegmentCreditCard BC WITH (NOLOCK)
JOIN #CorrectionAccounts CA ON (BC.acctId = CA.AccountID)




DROP TABLE IF EXISTS #CPSgmentCreditCard
SELECT acctId, CycleDueDTD, amountoftotaldue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, EstimatedDue, RollOverDue
INTO #CPSgmentCreditCard
FROM CPSgmentCreditCard CC WITH (NOLOCK)
JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)


--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--STEP:2:::::::::::::::: SELECT QUERIES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*
SELECT * FROM #CorrectionAccounts ORDER BY AccountID

SELECT * FROM #CorrectionPlans

SELECT acctId, AccountNumber, SystemStatus, ccinhparent125AID, CurrentBalance, Principal, CycleDueDTD, AmtOfPayCurrDue, DeAcctActivityDate 
FROM #BSegment_Primary BP WITH (NOLOCK)
JOIN #CorrectionAccounts CA ON (BP.acctId = CA.AccountID)

SELECT acctId, amountoftotaldue, runningminimumdue,remainingminimumdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, daysdelinquent,nopaydaysdelinquent,
firstduedate,dateoforiginalpaymentduedtd, DtOfLastDelinqCTD
FROM #BSegmentCreditCard BC WITH (NOLOCK)
JOIN #CorrectionAccounts CA ON (BC.acctId = CA.AccountID)

SELECT acctId, CycleDueDTD, amountoftotaldue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, srbwithinstallmentdue, EstimatedDue, RollOverDue
FROM #CPSgmentCreditCard CC WITH (NOLOCK)
JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID)
*/


;WITH AccountDue AS (SELECT acctId, AmountOfTotalDue FROM #BSegmentCreditCard)
,PlanWiseDue AS (SELECT AccountID, AmountOfTotalDue FROM #CPSgmentCreditCard CC JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID))
,PlanDue AS (SELECT AccountID, SUM(AmountOfTotalDue) AmountOfTotalDue FROM PlanWiseDue GROUP BY AccountID)
,CollectedData AS (
SELECT AD.acctID, AD.AmountOfTotalDue AD_Account, PD.AmountOfTotalDue AD_Plan, AD.AmountOfTotalDue-PD.AmountOfTotalDue DIFF 
FROM AccountDue AD 
JOIN PlanDue PD ON (AD.acctId = PD.AccountID))
SELECT 'VALIDATION#1' ValidationNumber,* FROM CollectedData WHERE DIFF <> 0


;WITH BSDue AS (
SELECT BP.acctID, AmountOfTotalDue, 
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
FROM #BSegment_Primary BP WITH (NOLOCK)
JOIN #BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId))
SELECT 'VALIDATION#2' ValidationNumber, *, AmountOfTotalDue - CalculatedAD DIFF FROM BSDue WHERE AmountOfTotalDue - CalculatedAD <> 0

;WITH CPSDue AS (
SELECT acctID, AmountOfTotalDue, 
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD
FROM #CPSgmentCreditCard CC)
SELECT 'VALIDATION#3' ValidationNumber, *, AmountOfTotalDue - CalculatedAD DIFF FROM CPSDue WHERE AmountOfTotalDue - CalculatedAD <> 0


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
SELECT 'VALIDATION#4' ValidationNumber, * 
FROM CollectedData
WHERE CycleDueDTD_DIFF <> 0 OR AD_DIFF <> 0 OR CD_DIFF <> 0 OR CPD1_DIFF <> 0 OR CPD2_DIFF <> 0 OR CPD3_DIFF <> 0 
OR CPD4_DIFF <> 0 OR CPD5_DIFF <> 0 OR CPD6_DIFF <> 0 OR CPD7_DIFF <> 0 OR CPD8_DIFF <> 0



------------------------------------------ GENERAL VALIDATION SCRIPTS ACCOUNT WISE ----------------------------------------------------------------------

--17543409
--13592733
--17643501
--12882682
--3230968
--10343487
--654914
--18072885
--1108127--
--1549088
--679012

--17674647
--19075941
--11536995
/*
DECLARE @BSacctId INT , @LastSatementDate DATETIME, @Businessday DATETIME, @CPSAcctID INT, @CCARD INT = 0, @EOD INT = 0, @Statement INT = 0

SET @BSacctId = 1108127	 
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011178177881'
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '2c1d795a-f876-4519-9af5-02e930a6dfee'
SET @LastSatementDate = '2021-07-31 23:59:57.000'
SET @Businessday = '2021-07-31 23:59:57.000'
SET @CCARD = 1
SET @EOD = 0
SET @Statement = 1

SELECT *
FROM #BSegment_Primary BP
JOIN #BSegmentCreditCard BC ON (BP.acctId = BC.acctID)
WHERE BP.acctId = @BSacctId

SELECT * 
FROM #CPSgmentCreditCard CC
JOIN #CorrectionPlans CP ON (CC.acctId = CP.PlanID) 
WHERE CP.AccountID = @BSacctId
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------


--STEP:3::::::::::::::::::::::::::::: PLACE CORRECTION SCRIPTS HERE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 10.75 WHERE acctId = 17543409

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RemainingMinimumDue = RemainingMinimumDue - 10.75,
--NoPayDaysDelinquent = 0, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 17543409




--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 13592733

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.01, AmtOfPayXDLate = AmtOfPayXDLate + 5.01, RemainingMinimumDue = RemainingMinimumDue + 5.01,
--RunningMinimumDue = RunningMinimumDue + 5.01, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
--DaysDelinquent = 4, NoPayDaysDelinquent = 4 WHERE acctId = 13592733


--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 21.16 WHERE acctId = 17643501

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.16, RemainingMinimumDue = RemainingMinimumDue - 21.16,
--RunningMinimumDue = RunningMinimumDue - 21.16, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 17643501


--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 0.19 WHERE acctId = 12882682

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.19, RemainingMinimumDue = RemainingMinimumDue - 0.19,
--RunningMinimumDue = RunningMinimumDue - 0.19, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 12882682


--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 3230968

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 31.92, AmtOfPayXDLate = AmtOfPayXDLate + 31.92, RemainingMinimumDue = RemainingMinimumDue + 31.92,
--RunningMinimumDue = RunningMinimumDue + 31.92, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
--DaysDelinquent = 11, NoPayDaysDelinquent = 11 WHERE acctId = 3230968



--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.03 WHERE acctId = 10343487

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.03, RemainingMinimumDue = RemainingMinimumDue - 1.03,
--RunningMinimumDue = RunningMinimumDue - 1.03, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 10343487




--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 0.49 WHERE acctId = 654914

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.49, RemainingMinimumDue = RemainingMinimumDue - 0.49,
--RunningMinimumDue = RunningMinimumDue - 0.49, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 654914




--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 18072885

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 49.95, AmtOfPayXDLate = AmtOfPayXDLate + 49.95, RemainingMinimumDue = RemainingMinimumDue + 49.95,
--RunningMinimumDue = RunningMinimumDue + 49.95, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
--DaysDelinquent = 6, NoPayDaysDelinquent = 6 WHERE acctId = 18072885


--UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.66, AmtofPayCurrDue = AmtofPayCurrDue + 1.66, EstimatedDue = EstimatedDue + 1.66, 
--RollOverDue = RollOverDue - 1.66, CycleDueDTD = 1 WHERE acctId = 58971976




--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.13 WHERE acctId = 1549088

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.13, RemainingMinimumDue = RemainingMinimumDue - 1.13,
--RunningMinimumDue = RunningMinimumDue - 1.13, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 1549088




--UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.62, AmountOfPayment30DLate = AmountOfPayment30DLate - 2.62, CycleDueDTD = 0 WHERE acctId = 37183396






--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3 WHERE acctId = 17674647

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 75, AmtOfPayXDLate = AmtOfPayXDLate + 75, RemainingMinimumDue = RemainingMinimumDue + 75,
--RunningMinimumDue = RunningMinimumDue + 75, FirstDueDate = '2021-07-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000', DtOfLastDelinqCTD = '2021-07-31 23:59:57.000',
--DaysDelinquent = 17, NoPayDaysDelinquent = 17 WHERE acctId = 17674647

--UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 22.60, AmtOfPayXDLate = AmtOfPayXDLate + 22.60, CycleDueDTD = 2 WHERE acctId = 53665519


--UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.77, AmtofPayCurrDue = AmtofPayCurrDue - 24.77, CycleDueDTD = 0 WHERE acctId = 794511

--UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.93, AmtofPayCurrDue = AmtofPayCurrDue - 21.93, CycleDueDTD = 0 WHERE acctId = 26760013



--UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 1.89 WHERE acctId = 2188937

--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.89, RemainingMinimumDue = RemainingMinimumDue - 1.89,
--RunningMinimumDue = RunningMinimumDue - 1.89, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 2188937



--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

