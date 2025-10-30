DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

SELECT BP.acctId, SystemStatus, CycleDueDTD, CurrentBalance, BCC.AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate
INTO #TempBSegment
FROM BSegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BillingCycle = '31' 
AND SystemStatus <> 14
AND PaymentLevel IS NULL

SELECT CPC.acctId, CPS.parent02AID, CreditPlanType, CPC.CycleDueDTD, CPS.CurrentBalance, CPC.AmountOfTotalDue, CPC.amtofpaycurrdue,CPC.AmtOfPayXDLate,CPC.AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
CPC.AmountOfPayment90DLate, CPC.AmountOfPayment120DLate, CPC.AmountOfPayment150DLate, CPC.AmountOfPayment180DLate 
INTO #TempCPSgment
FROM CPSgmentCreditCard CPC WITH (NOLOCK)
INNER JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPS.acctid = CPC.acctId)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.acctId = CPS.parent02AID)


SELECT parent02AID, SUM(ISNULL(CurrentBalance, 0)) CurrentBalance, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue, SUM(ISNULL(amtofpaycurrdue, 0)) amtofpaycurrdue,SUM(ISNULL(AmtOfPayXDLate, 0)) AmtOfPayXDLate,
SUM(ISNULL(AmountOfPayment30DLate, 0)) AmountOfPayment30DLate, SUM(ISNULL(AmountOfPayment60DLate, 0)) AmountOfPayment60DLate, SUM(ISNULL(AmountOfPayment90DLate, 0)) AmountOfPayment90DLate, 
SUM(ISNULL(AmountOfPayment120DLate, 0)) AmountOfPayment120DLate, SUM(ISNULL(AmountOfPayment150DLate, 0)) AmountOfPayment150DLate, SUM(ISNULL(AmountOfPayment180DLate, 0)) AmountOfPayment180DLate
INTO #TempCPSgmentDue
FROM #TempCPSgment
GROUP BY parent02AID

SELECT * FROM #TempCPSgmentDue


SELECT TB.AmountOfTotalDue, TC.AmountOfTotalDue, * 
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


/*****************************************  EOD TABLE VALIDATION  ************************************************************************/

DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

DECLARE @BusinessDay DATETIME = '2022-02-10 23:59:57'
SELECT BSacctId, SystemStatus, CycleDueDTD, CurrentBalance, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate
INTO #TempBSegment
FROM AccountInfoForReport BCC WITH (NOLOCK)
WHERE BusinessDay = @BusinessDay
AND SystemStatus <> 14

DECLARE @BusinessDay DATETIME = '2022-02-10 23:59:57'
SELECT CPC.CPSacctId, CPC.BSacctId, CreditPlanType, CPC.CycleDueDTD, CPC.CurrentBalance, CPC.AmountOfTotalDue, CPC.amtofpaycurrdue,CPC.AmtOfPayXDLate,CPC.AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
CPC.AmountOfPayment90DLate, CPC.AmountOfPayment120DLate, CPC.AmountOfPayment150DLate, CPC.AmountOfPayment180DLate 
INTO #TempCPSgment
FROM PlanInfoForReport CPC WITH (NOLOCK)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = CPC.BSacctId)
WHERE BusinessDay = @BusinessDay


SELECT BSacctId, SUM(ISNULL(CurrentBalance, 0)) CurrentBalance, MAX(ISNULL(CycleDueDTD, 0)) CycleDueDTD, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue, SUM(ISNULL(amtofpaycurrdue, 0)) amtofpaycurrdue,SUM(ISNULL(AmtOfPayXDLate, 0)) AmtOfPayXDLate,
SUM(ISNULL(AmountOfPayment30DLate, 0)) AmountOfPayment30DLate, SUM(ISNULL(AmountOfPayment60DLate, 0)) AmountOfPayment60DLate, SUM(ISNULL(AmountOfPayment90DLate, 0)) AmountOfPayment90DLate, 
SUM(ISNULL(AmountOfPayment120DLate, 0)) AmountOfPayment120DLate, SUM(ISNULL(AmountOfPayment150DLate, 0)) AmountOfPayment150DLate, SUM(ISNULL(AmountOfPayment180DLate, 0)) AmountOfPayment180DLate
INTO #TempCPSgmentDue
FROM #TempCPSgment
GROUP BY BSacctId

SELECT * FROM #TempCPSgmentDue


SELECT TB.AmountOfTotalDue, TC.AmountOfTotalDue, * 
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.BSacctId = TC.BSacctId)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


SELECT TB.BSacctId, TB.SystemStatus,
	TB.AmountOfTotalDue, TC.AmountOfTotalDue,
	TB.CycleDueDTD, TC.CycleDueDTD,
	TB.amtofpaycurrdue, TC.amtofpaycurrdue,
	TB.AmtOfPayXDLate, TC.AmtOfPayXDLate,
	TB.AmountOfPayment30DLate, TC.AmountOfPayment30DLate, 
	TB.AmountOfPayment60DLate, TC.AmountOfPayment60DLate, 
	TB.AmountOfPayment90DLate, TC.AmountOfPayment90DLate, 
	TB.AmountOfPayment120DLate, TC.AmountOfPayment120DLate, 
	TB.AmountOfPayment150DLate, TC.AmountOfPayment150DLate, 
	TB.AmountOfPayment180DLate, TC.AmountOfPayment180DLate
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.BSacctId = TC.BSacctId)
WHERE (TB.AmountOfTotalDue <> TC.AmountOfTotalDue
OR TB.CycleDueDTD <> TC.CycleDueDTD
OR TB.amtofpaycurrdue <> TC.amtofpaycurrdue
OR TB.AmtOfPayXDLate <> TC.AmtOfPayXDLate
OR TB.AmountOfPayment30DLate <> TC.AmountOfPayment30DLate
OR TB.AmountOfPayment60DLate <> TC.AmountOfPayment60DLate
OR TB.AmountOfPayment90DLate <> TC.AmountOfPayment90DLate
OR TB.AmountOfPayment120DLate <> TC.AmountOfPayment120DLate
OR TB.AmountOfPayment150DLate <> TC.AmountOfPayment150DLate
OR TB.AmountOfPayment180DLate <> TC.AmountOfPayment180DLate)
AND TB.SystemStatus <> 14
