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
AND PaymentLevel IS NULL  and  bp.acctid in  (select acctid  from  #tempdue)

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

DROP TABLE IF EXISTS ##BSRecords
SELECT tb.acctid BSAcctId
into   ##BSRecords  
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


DROP TABLE IF EXISTS #tempdue
SELECT tb.acctid
into   #tempdue  
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


/*****************************************  EOD TABLE VALIDATION  ************************************************************************/

DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

DECLARE @BusinessDay DATETIME = '2023-01-29 23:59:57'
SELECT BSacctId, SystemStatus, CycleDueDTD, CurrentBalance, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
CASE 
	WHEN BCC.AmountOfPayment210DLate > 0 THEN 9
	WHEN BCC.AmountOfPayment180DLate > 0 THEN 8
	WHEN BCC.AmountOfPayment150DLate > 0 THEN 7
	WHEN BCC.AmountOfPayment120DLate > 0 THEN 6
	WHEN BCC.AmountOfPayment90DLate > 0 THEN 5
	WHEN BCC.AmountOfPayment60DLate > 0 THEN 4
	WHEN BCC.AmountOfPayment30DLate > 0 THEN 3
	WHEN BCC.AmtOfPayXDLate > 0 THEN 2
	WHEN BCC.amtofpaycurrdue > 0 THEN 1
	ELSE 0
END CycleDueDTD_BS_Calculated
INTO #TempBSegment
FROM AccountInfoForReport BCC WITH (NOLOCK)
WHERE BusinessDay = @BusinessDay
AND SystemStatus <> 14

DECLARE @BusinessDay DATETIME = '2023-01-29 23:59:57'
SELECT CPC.CPSacctId, CPC.BSacctId, CreditPlanType, CPC.CycleDueDTD, CPC.CurrentBalance, CPC.AmountOfTotalDue, CPC.amtofpaycurrdue,CPC.AmtOfPayXDLate,CPC.AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
CPC.AmountOfPayment90DLate, CPC.AmountOfPayment120DLate, CPC.AmountOfPayment150DLate, CPC.AmountOfPayment180DLate, CPC.AmountOfPayment210DLate,
CASE 
	WHEN CPC.AmountOfPayment210DLate > 0 THEN 9
	WHEN CPC.AmountOfPayment180DLate > 0 THEN 8
	WHEN CPC.AmountOfPayment150DLate > 0 THEN 7
	WHEN CPC.AmountOfPayment120DLate > 0 THEN 6
	WHEN CPC.AmountOfPayment90DLate > 0 THEN 5
	WHEN CPC.AmountOfPayment60DLate > 0 THEN 4
	WHEN CPC.AmountOfPayment30DLate > 0 THEN 3
	WHEN CPC.AmtOfPayXDLate > 0 THEN 2
	WHEN CPC.amtofpaycurrdue > 0 THEN 1
	ELSE 0
END CycleDueDTD_CPS_Calculated 
INTO #TempCPSgment
FROM PlanInfoForReport CPC WITH (NOLOCK)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = CPC.BSacctId)
WHERE BusinessDay = @BusinessDay





SELECT BSacctId, SUM(ISNULL(CurrentBalance, 0)) CurrentBalance, MAX(ISNULL(CycleDueDTD, 0)) CycleDueDTD, MAX(ISNULL(CycleDueDTD_CPS_Calculated, 0)) CycleDueDTD_CPS_Calculated, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue, SUM(ISNULL(amtofpaycurrdue, 0)) amtofpaycurrdue,SUM(ISNULL(AmtOfPayXDLate, 0)) AmtOfPayXDLate,
SUM(ISNULL(AmountOfPayment30DLate, 0)) AmountOfPayment30DLate, SUM(ISNULL(AmountOfPayment60DLate, 0)) AmountOfPayment60DLate, SUM(ISNULL(AmountOfPayment90DLate, 0)) AmountOfPayment90DLate, 
SUM(ISNULL(AmountOfPayment120DLate, 0)) AmountOfPayment120DLate, SUM(ISNULL(AmountOfPayment150DLate, 0)) AmountOfPayment150DLate, SUM(ISNULL(AmountOfPayment180DLate, 0)) AmountOfPayment180DLate
INTO #TempCPSgmentDue
FROM #TempCPSgment
GROUP BY BSacctId

SELECT * FROM #TempCPSgmentDue


-------------------------- VALIDATIONS -------------------------

--1 -- CyceDueDTD

SELECT TB.BSAcctID, TB.CycleDueDTD, CycleDueDTD_CPS_Calculated, CycleDueDTD_BS_Calculated, *
FROM #TempCPSgmentDue TC
JOIN #TempBSegment TB ON (TB.BSAcctID = TC.BSAcctID)
WHERE TB.CycleDueDTD <> CycleDueDTD_BS_Calculated


SELECT TB.BSAcctID, TB.CycleDueDTD, CycleDueDTD_CPS_Calculated, CycleDueDTD_BS_Calculated, *
FROM #TempCPSgmentDue TC
JOIN #TempBSegment TB ON (TB.BSAcctID = TC.BSAcctID)
WHERE TC.CycleDueDTD <> TC.CycleDueDTD_CPS_Calculated

SELECT TC.BSAcctID, TC.CPSAcctID, TC.CycleDueDTD, CycleDueDTD_CPS_Calculated, *
FROM #TempCPSgment TC
WHERE TC.CycleDueDTD <> TC.CycleDueDTD_CPS_Calculated


SELECT TB.BSAcctID, TB.CycleDueDTD CycleDueDTDOnBS, TC.CycleDueDTD CycleDueDTDOnCPS, CycleDueDTD_CPS_Calculated, CycleDueDTD_BS_Calculated, *
FROM #TempCPSgmentDue TC
JOIN #TempBSegment TB ON (TB.BSAcctID = TC.BSAcctID)
WHERE TB.CycleDueDTD_BS_Calculated <> CycleDueDTD_CPS_Calculated


SELECT CPSAcctID, BSAcctID, CycleDueDTD, CycleDueDTD_CPS_Calculated, *
FROM #TempCPSgment TC
WHERE CycleDueDTD <> CycleDueDTD_CPS_Calculated



SELECT TB.AmountOfTotalDue, TC.AmountOfTotalDue, * 
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.BSacctId = TC.BSacctId)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue
--AND TB.BSAcctid NOT IN (20195, 16836, 888490, 2105008, 21571891, 13047225, 20156734, 2021886, 6842737, 12445926)
AND TB.SystemStatus <> 14


SELECT * FROM ##BSRecords
WHERE BSAcctID NOT IN
(
SELECT TB.BSAcctID 
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.BSacctId = TC.BSacctId)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue
)


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






SELECT TB.BSacctId, TB.SystemStatus,
	TB.AmountOfTotalDue, TC.AmountOfTotalDue,
	TB.CycleDueDTD, TC.CycleDueDTD_CPS_Current,
	CASE 
		WHEN TC.AmountOfPayment180DLate + TC.AmountOfPayment150DLate > 0 THEN 7
		WHEN TC.AmountOfPayment120DLate > 0 THEN 6
		WHEN TC.AmountOfPayment90DLate > 0 THEN 5
		WHEN TC.AmountOfPayment60DLate > 0 THEN 4
		WHEN TC.AmountOfPayment30DLate > 0 THEN 3
		WHEN TC.AmtOfPayXDLate > 0 THEN 2
		WHEN TC.amtofpaycurrdue > 0 THEN 1
		ELSE 0
	END CycleDueDTD_CPS,
	TB.amtofpaycurrdue, TC.amtofpaycurrdue_CPS,
	TB.AmtOfPayXDLate, TC.AmtOfPayXDLate_CPS,
	TB.AmountOfPayment30DLate, TC.AmountOfPayment30DLate_CPS, 
	TB.AmountOfPayment60DLate, TC.AmountOfPayment60DLate_CPS, 
	TB.AmountOfPayment90DLate, TC.AmountOfPayment90DLate_CPS, 
	TB.AmountOfPayment120DLate, TC.AmountOfPayment120DLate_CPS, 
	TB.AmountOfPayment150DLate, TC.AmountOfPayment150DLate_CPS, 
	TB.AmountOfPayment180DLate, TC.AmountOfPayment180DLate_CPS
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
