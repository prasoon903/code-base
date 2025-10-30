DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue
DROP TABLE IF EXISTS #BSRecords_CO
DROP TABLE IF EXISTS #BSRecords

SELECT ActivityCode FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 303850
SELECT ActivityCodePayment FROM BSegmentCreditCard WITH (NOLOCK) WHERE acctId = 303850

SELECT * FROM #BSRecords_CO
DROP TABLE IF EXISTS #BSRecords_CO
SELECT BP.acctId
--, ActivityCode, ActivityCodePayment, NoPayDaysDelinquent, daysdelinquent, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
--RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid
INTO #BSRecords_CO
FROM BSegment_Primary BP WITH (NOLOCK)
--JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BB.acctId = BCC.acctId)
WHERE SystemStatus = 14 AND BillingCycle <> 'LTD'
--AND ChargeOffDate > LastStatementDate
AND ActivityCode = 0 AND ActivityCodePayment = 0 AND CurrentBalance+CurrentBalanceCO > 0
AND bp.acctId IN (303850
, 444373
, 1326848
, 1703246
, 1048681
, 2788428
, 4117808
, 8349434
, 11507426
, 1767305
, 2192395
, 2485689
, 2783371
, 3660544
, 4797589
, 5633640
, 8147951
, 12339777
, 1110368
, 1205185
, 1963366
, 2149502
, 2171113
, 2623642
, 2673233
, 2747365
, 2798718
, 2945515
, 10302041
, 10304548
, 1147190
, 1753890
, 2232368)


---- CHECK DUE

DROP TABLE IF EXISTS #TempBSegment
SELECT BSacctId, SystemStatus, CycleDueDTD, CurrentBalance+CurrentBalanceCO CurrentBalance, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
INTO #TempBSegment
FROM AccountInfoForReport AI WITH (NOLOCK)
JOIN #BSRecords_CO BS ON (AI.BSAcctId = BS.acctId)
WHERE BusinessDay = '2021-12-30 23:59:57'


DROP TABLE IF EXISTS #TempCPSgment
SELECT CPC.CPSacctId, CPC.BSacctId, CreditPlanType, CPC.CycleDueDTD, CPC.CurrentBalance+CPC.CurrentBalanceCO CurrentBalance, CPC.AmountOfTotalDue, SRBWithInstallMentDue, CPC.amtofpaycurrdue,
CPC.AmtOfPayXDLate,CPC.AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
CPC.AmountOfPayment90DLate, CPC.AmountOfPayment120DLate, CPC.AmountOfPayment150DLate, CPC.AmountOfPayment180DLate, CPC.AmountOfPayment210DLate
INTO #TempCPSgment
FROM PlanInfoForReport CPC WITH (NOLOCK)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = CPC.BSacctId)
WHERE BusinessDay = '2021-12-30 23:59:57'


DROP TABLE IF EXISTS #TempCPSgmentDue
SELECT BSacctId, SUM(ISNULL(CurrentBalance, 0)) CurrentBalance, MAX(ISNULL(CycleDueDTD, 0)) CycleDueDTD, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue, SUM(ISNULL(amtofpaycurrdue, 0)) amtofpaycurrdue,SUM(ISNULL(AmtOfPayXDLate, 0)) AmtOfPayXDLate,
SUM(ISNULL(AmountOfPayment30DLate, 0)) AmountOfPayment30DLate, SUM(ISNULL(AmountOfPayment60DLate, 0)) AmountOfPayment60DLate, SUM(ISNULL(AmountOfPayment90DLate, 0)) AmountOfPayment90DLate, 
SUM(ISNULL(AmountOfPayment120DLate, 0)) AmountOfPayment120DLate, SUM(ISNULL(AmountOfPayment150DLate, 0)) AmountOfPayment150DLate, SUM(ISNULL(AmountOfPayment180DLate, 0)) AmountOfPayment180DLate
INTO #TempCPSgmentDue
FROM #TempCPSgment
GROUP BY BSacctId



SELECT TB.AmountOfTotalDue, TC.AmountOfTotalDue, * 
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.BSacctId = TC.BSacctId)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue
--AND TB.BSAcctid NOT IN (20195, 16836, 888490, 2105008, 21571891, 13047225, 20156734, 2021886, 6842737, 12445926)
--AND TB.SystemStatus <> 14

DROP TABLE IF EXISTS ##BSRecordsDue
SELECT TB.BSAcctid acctId 
INTO ##BSRecordsDue
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


---- CHECK SRB ISSUE

DROP TABLE IF EXISTS #BSRecords
SELECT  
BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid, 
CAST(0 AS MONEY) DueAdjusted_BS, CAST('CASE12345' AS VARCHAR(10)) IssueType
INTO #BSRecords
FROM .AccountInfoForReport AI WITH (NOLOCK) 
JOIN #BSRecords_CO BS ON (AI.BSAcctId = BS.acctId)
WHERE BusinessDay = '2021-12-29 23:59:57'
--AND SYstemStatus <> 14
AND (SRBWithInstallmentDue < AmountOfTotalDue)

SELECT * FROM #BSRecords