
DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

DECLARE @BusinessDay DATETIME = '2021-12-19 23:59:57'
SELECT BSacctId, SystemStatus, CycleDueDTD, CurrentBalance, DisputesAmtNS, SRBWithInstallmentDue, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
INTO #TempBSegment
FROM AccountInfoForReport BCC WITH (NOLOCK)
WHERE BusinessDay = @BusinessDay
AND SystemStatus <> 14

DECLARE @BusinessDay DATETIME = '2021-12-19 23:59:57'
SELECT CPC.CPSacctId, CPC.BSacctId, CreditPlanType, CPC.CycleDueDTD, CPC.CurrentBalance, CPC.SRBWithInstallmentDue, CPC.AmountOfTotalDue, CPC.amtofpaycurrdue,CPC.AmtOfPayXDLate,CPC.AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
CPC.AmountOfPayment90DLate, CPC.AmountOfPayment120DLate, CPC.AmountOfPayment150DLate, CPC.AmountOfPayment180DLate, CPC.AmountOfPayment210DLate 
INTO #TempCPSgment
FROM PlanInfoForReport CPC WITH (NOLOCK)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = CPC.BSacctId)
WHERE BusinessDay = @BusinessDay


SELECT * FROM #TempCPSgment where AmountOfTotalDue IS NULL


DROP TABLE IF EXISTS #Accounts
SELECT BSAcctID, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue, MAX(ISNULL(CycleDueDTD, 0)) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
INTO #Accounts
FROM #TempCPSgment
GROUP BY BSAcctId


;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(ISNULL(SRBWithInstallmentDue, 0)) < 0 THEN 0 ELSE SUM(ISNULL(SRBWithInstallmentDue, 0)) END SRBWithInstallmentDue, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue
	FROM #TempCPSgment I 
	WHERE CreditPlanType <> '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_NoNRetail = I.SRBWithInstallmentDue, Due_NoNRetail = I.AmountOfTotalDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(ISNULL(SRBWithInstallmentDue, 0)) < 0 THEN 0 ELSE SUM(ISNULL(SRBWithInstallmentDue, 0)) END SRBWithInstallmentDue, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue
	FROM #TempCPSgment I 
	WHERE CreditPlanType = '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail


SELECT A.*, B.CurrentBalance, B.DisputesAmtNS, B.AmountOfTotalDue
FROM #Accounts A
JOIN #TempBSegment B ON (A.BSAcctid = B.BSAcctid)
WHERE B.CurrentBalance <= 0 AND B.DisputesAmtNS > 0 AND A.Due_Retail > 0



----------------- STATEMENT -------------------------



DROP TABLE IF EXISTS #TempBSegment
DROP TABLE IF EXISTS #TempCPSgment
DROP TABLE IF EXISTS #TempCPSgmentDue

DECLARE @StatementDate DATETIME = '2021-11-30 23:59:57'
SELECT acctId BSacctId, StatementID, SystemStatus, CycleDueDTD, CurrentBalance, DisputesAmtNS, SRBWithInstallmentDue, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
INTO #TempBSegment
FROM StatementHeader SH WITH (NOLOCK)
WHERE StatementDate = @StatementDate
AND SystemStatus <> 14

SELECT TOP 10 * FROM #TempBSegment

DECLARE @StatementDate DATETIME = '2021-11-30 23:59:57'
SELECT S.acctId CPSacctId, TB.BSacctId, CreditPlanType, SHCC.CycleDueDTD, S.CurrentBalance, SHCC.DisputesAmtNS, SHCC.SRBWithInstallmentDue, S.AmountOfTotalDue, SHCC.CurrentDue amtofpaycurrdue,
SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, 
SHCC.AmountOfPayment90DLate, SHCC.AmountOfPayment120DLate, SHCC.AmountOfPayment150DLate, SHCC.AmountOfPayment180DLate, SHCC.AmountOfPayment210DLate 
INTO #TempCPSgment
FROM SummaryHeader S WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (S.acctId = SHCC.acctId AND S.StatementID = SHCC.StatementID)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = S.parent02AID AND TB.StatementID = S.StatementID)
WHERE S.StatementDate = @StatementDate

DECLARE @StatementDate DATETIME = '2021-11-30 23:59:57'
SELECT S.acctId CPSacctId, TB.BSacctId, S.StatementID, CreditPlanType, SHCC.CycleDueDTD, S.CurrentBalance, SHCC.DisputesAmtNS, SHCC.SRBWithInstallmentDue, S.AmountOfTotalDue, SHCC.CurrentDue amtofpaycurrdue,
SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, 
SHCC.AmountOfPayment90DLate, SHCC.AmountOfPayment120DLate, SHCC.AmountOfPayment150DLate, SHCC.AmountOfPayment180DLate, SHCC.AmountOfPayment210DLate 
--INTO #TempCPSgment
FROM SummaryHeader S WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (S.acctId = SHCC.acctId AND S.StatementID = SHCC.StatementID)
JOIN #TempBSegment TB WITH (NOLOCK) ON (TB.BSacctId = S.parent02AID AND TB.StatementID = S.StatementID)
WHERE S.StatementDate = @StatementDate AND TB.BSacctId = 77120