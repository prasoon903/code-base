; WITH CTE AS (
SELECT BS.acctId, SV.StatementID
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-12-31 23:59:57.000')
WHERE SV.StatementDate = '2021-12-31 23:59:57.000' AND ValidationFail = 'Q29')
SELECT BP.acctId,
'UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1 WHERE acctId ' + TRY_CAST(BP.acctId AS VARCHAR) BP,
'UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1 WHERE acctId ' + TRY_CAST(BP.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(C.StatementID AS VARCHAR) SH,
'UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 1 WHERE BSacctId ' + TRY_CAST(BP.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-12-31 23:59:57.000'''  AIR
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN CTE C ON (BCC.acctId = C.acctId)
WHERE AmountOfTotalDue = AmtOfPayCurrDue AND CycleDueDTD = 0 AND AmountOfTotalDue > 0


; WITH CTE_PLAN AS (
SELECT BS.acctId, SV.StatementID
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-12-31 23:59:57.000')
WHERE SV.StatementDate = '2021-12-31 23:59:57.000' AND ValidationFail = 'Q29')
SELECT CPS.acctId, CPS.Parent02AID,
'UPDATE TOP(1) CPSgmentCreditcard SET CycleDueDTD = 1 WHERE acctId ' + TRY_CAST(CPC.acctId AS VARCHAR) CPS,
'UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1 WHERE acctId ' + TRY_CAST(CPC.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(C.StatementID AS VARCHAR) SH,
'UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1 WHERE CPSacctId ' + TRY_CAST(CPC.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-12-31 23:59:57.000'''  PIR
FROM CPSgmentCreditcard CPC WITH (NOLOCK)
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPC.acctId = CPS.acctId)
JOIN CTE_PLAN C ON (C.acctId = CPS.Parent02AID)
WHERE AmountOfTotalDue = AmtOfPayCurrDue AND CycleDueDTD = 0 AND AmountOfTotalDue > 0
ORDER BY CPS.Parent02AID




---------------------------- CYCLEDUEDTD > 1 ------------------------



SELECT BS.SystemStatus, SV.* 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-12-31 23:59:57.000')
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = '2021-12-31 23:59:57.000')
WHERE SV.StatementDate = '2021-12-31 23:59:57.000' AND ValidationFail = 'Q29'

; WITH CTE AS (
SELECT BS.acctId, SV.StatementID
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-12-31 23:59:57.000')
WHERE SV.StatementDate = '2021-12-31 23:59:57.000' AND ValidationFail = 'Q29')
SELECT BP.acctId, 
'UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 8 WHERE acctId ' + TRY_CAST(BP.acctId AS VARCHAR) BP,
'UPDATE TOP(1) StatementHeader SET CycleDueDTD = 8 WHERE acctId ' + TRY_CAST(BP.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(C.StatementID AS VARCHAR) SH,
'UPDATE TOP(1) AccountInfoForReport SET CycleDueDTD = 8 WHERE BSacctId ' + TRY_CAST(BP.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-12-31 23:59:57.000'''  AIR
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN CTE C ON (BCC.acctId = C.acctId)
WHERE CycleDueDTD = 7 AND AmountOfTotalDue > 0 AND AmountOfPayment180DLate > 0


; WITH CTE_PLAN AS (
SELECT BS.acctId, SV.StatementID
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-12-31 23:59:57.000')
WHERE SV.StatementDate = '2021-12-31 23:59:57.000' AND ValidationFail = 'Q29')
SELECT CPS.acctId, CPS.Parent02AID,
'UPDATE TOP(1) CPSgmentCreditcard SET CycleDueDTD = 8 WHERE acctId ' + TRY_CAST(CPC.acctId AS VARCHAR) CPS,
'UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 8 WHERE acctId ' + TRY_CAST(CPC.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(C.StatementID AS VARCHAR) SH,
'UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 8 WHERE CPSacctId ' + TRY_CAST(CPC.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-12-31 23:59:57.000'''  PIR
FROM CPSgmentCreditcard CPC WITH (NOLOCK)
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPC.acctId = CPS.acctId)
JOIN CTE_PLAN C ON (C.acctId = CPS.Parent02AID)
WHERE CPC.CycleDueDTD = 7 AND CPC.AmountOfTotalDue > 0 AND CPC.AmountOfPayment180DLate > 0
ORDER BY CPS.Parent02AID

