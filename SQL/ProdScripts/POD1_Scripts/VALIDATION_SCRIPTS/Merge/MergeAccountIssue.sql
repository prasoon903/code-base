SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE DestAccountNumber = '1100011111041707'

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE DestBSacctId = 1549088

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE SrcRemainingMinDue > DESTRemainingMinDue

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) ORDER BY Skey DESC

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE AcrossPODMerge = 1


DROP TABLE IF EXISTS #TempSrc
SELECT SrcBsAcctid BSAcctId INTO #TempSrc FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE TransmissionTime > '2021-12-01'


SELECT CycleDueDTD, * FROM StatementHeader WITH (NOLOCK) WHERE StatementDate = '2021-07-31 23:59:57.000' AND acctId IN (
SELECT DestBSacctId FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK)
WHERE SrcRemainingMinDue IS NULL AND DESTRemainingMinDue IS NOT NULL AND DESTRemainingMinDue > 0)
AND CycleDueDTD > 1



SELECT SrcRemainingMinDue, DESTRemainingMinDue, * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK)
WHERE SrcRemainingMinDue IS NULL 
AND DESTRemainingMinDue IS NOT NULL 
AND DESTRemainingMinDue > 0
AND TransmissionTime > '2021-07-31 23:59:57.000'


SELECT SrcRemainingMinDue, DESTRemainingMinDue, BCC.AmountOfTotalDue, * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (MA.DestBSAcctId = BCC.acctId)
WHERE SrcRemainingMinDue IS NULL 
AND DESTRemainingMinDue IS NOT NULL 
AND DESTRemainingMinDue > 0
--AND TransmissionTime > '2021-07-31 23:59:57.000'
AND BCC.AmountOfTotalDue > 0


SELECT SrcRemainingMinDue, DESTRemainingMinDue, SH.AmountOfTotalDue, * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK)
JOIN StatementHeader SH WITH (NOLOCK) ON (MA.DestBSAcctId = SH.acctId AND SH.StatementDate = '2021-07-31 23:59:57.000')
WHERE SrcRemainingMinDue IS NULL 
AND DESTRemainingMinDue IS NOT NULL 
AND DESTRemainingMinDue > 0
AND TransmissionTime > '2021-07-31 23:59:57.000'
AND SH.AmountOfTotalDue > 0



SELECT BP.UniversalUniqueID AccountUUID, RTRIM(BP.Accountnumber) DestinationAccountNumber, TransmissionTime MergeProcessDate, 
DESTRemainingMinDue MinDueBeforeMerge, BCC.AmountOfTotalDue CurrentMinDue, CASE WHEN BCC.AmountOfTotalDue > 0 THEN 'YES' ELSE 'NO' END AS RemediationRequired
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (MA.DestBSAcctId = BP.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (MA.DestBSAcctId = BCC.acctId)
JOIN StatementHeader SH WITH (NOLOCK) ON (MA.DestBSAcctId = SH.acctId AND SH.StatementDate = '2021-07-31 23:59:57.000')
WHERE SrcRemainingMinDue IS NULL 
AND DESTRemainingMinDue IS NOT NULL 
AND DESTRemainingMinDue > 0
--AND TransmissionTime > '2021-07-31 23:59:57.000'
ORDER BY BCC.AmountOfTotalDue




DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

SELECT BP.acctId, SystemStatus, CycleDueDTD, CurrentBalance, BCC.AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate
INTO #TempBSegment
FROM BSegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN #TempSrc T1 ON (BP.acctId = T1.BSAcctId)
WHERE BillingCycle = '31' 
AND SystemStatus <> 14
--AND PaymentLevel IS NULL  --and  bp.acctid in  (select acctid  from  #tempdue)

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

--DROP TABLE IF EXISTS ##BSRecords
SELECT TB.AmountOfTotalDue,tb.acctid BSAcctId
--into   ##BSRecords  
FROM #TempBSegment TB
JOIN #TempCPSgmentDue TC ON (TB.acctId = TC.parent02AID)
WHERE TB.AmountOfTotalDue <> TC.AmountOfTotalDue


--DROP TABLE IF EXISTS ##BSRecords
SELECT TB.AmountOfTotalDue, *
--into   ##BSRecords  
FROM #TempBSegment TB
WHERE AmountOfTotalDue > 0







