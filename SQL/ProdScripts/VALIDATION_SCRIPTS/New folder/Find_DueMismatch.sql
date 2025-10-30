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



DROP TABLE IF EXISTS #tempdue
SELECT tb.acctid
into   #tempdue  
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


--In last
DROP TABLE IF EXISTS ##BSRecords
SELECT tb.acctid BSAcctId
into   ##BSRecords  
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue



/*****************************************  EOD TABLE VALIDATION  ************************************************************************/
