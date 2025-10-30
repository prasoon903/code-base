--STEP 1

--SELECT * FROM #ImpactedActivePlans WHERE BSAcctId = 20447784


DROP TABLE IF EXISTS #ImpactedPlans
SELECT BSacctId, CPSAcctId, CreditPlanType, CurrentBalance+CurrentBalanceCO CurrentBalance, AmountOfTotalDue, SRBWithInstallmentDue, CycleDueDTD
INTO #ImpactedPlans
FROM PLanInfoForREport WITH (NOLOCK)
WHERE BusinessDay = '2022-09-29 23:59:57'
AND ((CurrentBalance+CurrentBalanceCO < AmountOfTotalDue AND AmountOfTotalDue > 0 AND (CurrentBalance+CurrentBalanceCO) <= 0) OR (CurrentBalance+CurrentBalanceCO <= 0 AND CycleDueDTD > 0))
--AND BSAcctId = 11412924

SELECT * FROM #ImpactedActivePlans



DROP TABLE IF EXISTS #ImpactedActivePlans
SELECT I.*, ccinhParent125AID, SystemStatus 
INTO #ImpactedActivePlans
FROM #ImpactedPlans I
JOIN AccountInfoForReport A WITH (NOLOCK) ON (I.BSacctId = A.BSAcctID AND A.BusinessDay = '2022-09-29 23:59:57')
WHERE A.SystemStatus <> 14


DROP TABLE IF EXISTS #AllCPS
SELECT DISTINCT CPS.acctId CPSacctId, I.ccinhParent125AID, I.SystemStatus
INTO #AllCPS
FROM #ImpactedActivePlans I
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (I.BSacctId = CPS.parent02AID)


DROP TABLE IF EXISTS #ImpactedActiveAllPlans
SELECT P.BSacctId, P.CPSAcctId, P.CreditPlanType, P.CurrentBalance, P.AmountOfTotalDue, P.SRBWithInstallmentDue, P.CycleDueDTD, CPS.ccinhParent125AID, CPS.SystemStatus
INTO #ImpactedActiveAllPlans
FROM PLanInfoForREport P WITH (NOLOCK)
JOIN #AllCPS CPS WITH (NOLOCK) ON (P.CPSAcctId = CPS.CPSacctId)
WHERE P.BusinessDay = '2022-09-29 23:59:57'

SELECT * FROM #ImpactedActiveAllPlans


UPDATE T1
SET AmountOfTotalDue = 0, CycleDueDTD = 0, SRBWithInstallmentDue = 0
FROM #ImpactedActiveAllPlans T1 
JOIN #ImpactedActivePlans T2 ON (T1.CPSacctId = T2.CPSacctId)

UPDATE #ImpactedActiveAllPlans SET AmountOfTotalDue = CurrentBalance+AmountOfTotalDue, SRBWithInstallmentDue = CurrentBalance+SRBWithInstallmentDue WHERE CreditPlanType = '16' AND AmountOfTotalDue < 0

UPDATE #ImpactedActiveAllPlans SET AmountOfTotalDue = 0, CycleDueDTD = 0 WHERE CPSAcctID = 2033260

--69562449
--58404925
--69880756

------UPDATE #ImpactedActiveAllPlans SET AmountOfTotalDue = 0 WHERE CreditPlanType <> '16' AND SRBWithInstallmentDue <= 0

DROP TABLE IF EXISTS #Accounts
SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, MAX(SystemStatus) SystemStatus, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB
INTO #Accounts
FROM #ImpactedActiveAllPlans
GROUP BY BSAcctId

SELECT * FROM #Accounts

;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue
	FROM #ImpactedActiveAllPlans I 
	WHERE CreditPlanType <> 16
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_NoNRetail = I.SRBWithInstallmentDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue
	FROM #ImpactedActiveAllPlans I 
	WHERE CreditPlanType = 16
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts SET TotalSRB = SRB_Retail + SRB_NoNRetail



SELECT * FROm #Accounts WHERE CycleDueDTD = 1 AND TotalSRB = 0

SELECT * FROM #ImpactedActiveAllPlans WHERE BSAcctId = 2003030

SELECT * FROM #ImpactedActiveAllPlans WHERE CreditPlanType = '16' AND AmountOfTotalDue < 0


DROP TABLE IF EXISTS #CTD0
DROP TABLE IF EXISTS #CTD1

SELECT * FROM #Accounts WHERE CycleDueDTD = 0

DROP TABLE IF EXISTS ##BSRecords
SELECT BSAcctID INTO ##BSRecords FROM #Accounts WHERE CycleDueDTD = 0

SELECT * FROM #Accounts WHERE CycleDueDTD > 0

SELECT * INTO ##Accounts FROM #Accounts

--UPDATE #CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctID = 2033260

--UPDATE #CPSgmentCreditCard SET AmountOfTotalDue = 94.33, AmtOfPayCurrDue = 94.33, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0, SRBWithInstallmentDue = 94.33 WHERE acctID = 69562449
--UPDATE #CPSgmentCreditCard SET AmountOfTotalDue = 32.04, AmtOfPayCurrDue = 32.04, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0, SRBWithInstallmentDue = 32.04 WHERE acctID = 58404925
--UPDATE #CPSgmentCreditCard SET AmountOfTotalDue = 45.37, AmtOfPayCurrDue = 45.37, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0, SRBWithInstallmentDue = 45.37 WHERE acctID = 69880756


SELECT A.*, 
'UPDATE #BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE #BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0, 
AmountOfPayment90DLate = 0, AmountOfPayment120DLate = 0,AmountOfPayment150DLate = 0, AmountOfPayment180DLate = 0, AmountOfPayment210DLate = 0,
RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
DateOfOriginalPaymentDueDTD = ''' + TRY_CONVERT(VARCHAR(20), ChargeOffDate, 20) + ''', DtOfLastDelinqCTD = ''' + TRY_CONVERT(VARCHAR(20), ChargeOffDate, 20) + ''', FirstDueDate = NULL
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts A
JOIN BSegmentCreditCard B WITH (NOLOCK) ON (A.BSAcctID = B.acctId)
WHERE CycleDueDTD = 0
ORDER BY BSAcctID

SELECT *, 
'UPDATE #BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE #BSegmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + 
', SRBWithInstallmentDue = ' + TRY_CAST(TotalSRB AS VARCHAR) + ', DaysDelinquent = 0, TotalDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts
WHERE CycleDueDTD = 1
ORDER BY BSAcctID


SELECT * ,
'UPDATE #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0, 
AmountOfPayment90DLate = 0, AmountOfPayment120DLate = 0,AmountOfPayment150DLate = 0, AmountOfPayment180DLate = 0, AmountOfPayment210DLate = 0,
SRBWithInstallmentDue = 0 WHERE acctID = ' + TRY_CAST(CPSAcctID AS VARCHAR) CPSgmentCreditCard
FROM #ImpactedActivePlans
ORDER BY CPSAcctID

SELECT * ,
'UPDATE TOP(1) BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary
FROM #Accounts WHERE CycleDueDTD IN (0, 1) AND SystemStatus = 3

SELECT * FROM #Accounts WHERE BSAcctId = 353329
SELECT * FROM #ImpactedActiveAllPlans WHERE BSAcctId = 353329
SELECT * FROM #ImpactedActivePlans WHERE BSAcctId = 353329

SELECT * ,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''0.00'' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
from #ImpactedActivePlans I
JOIN CurrentBalanceAuditPS C WITH (NOLOCK) ON (I.CPSacctId = C.AID AND C.ATID = 52)
WHERE C.BusinessDay > '2021-10-31 23:59:57'
AND C.Dename = 200
AND TRY_CAST(I.AmountOfTotalDue AS VARCHAR) = C.NewValue AND C.OldValue = '0.00'
AND I.CreditPlanType = '16'



SELECT * ,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''0'' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
from #ImpactedActivePlans I
JOIN CurrentBalanceAuditPS C WITH (NOLOCK) ON (I.CPSacctId = C.AID AND C.ATID = 52)
WHERE C.BusinessDay > '2021-10-31 23:59:57'
AND C.Dename = 115
--AND I.CycleDueDTD = 0 
AND C.OldValue = '0' 
AND C.NewValue = '1'
--AND I.CreditPlanType = '16'

;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #Accounts A ON (C.AID = A.BSAcctId AND C.ATID = 51)
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 200
)
SELECT *,
--'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
AND OldValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)


;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #Accounts A ON (C.AID = A.BSAcctId AND C.ATID = 51)
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 115
)
SELECT *,
--'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(CycleDueDTD AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
AND OldValue <> TRY_CAST(CycleDueDTD AS VARCHAR)
AND NewValue <> TRY_CAST(CycleDueDTD AS VARCHAR)



;WITH CTE 
AS
(
	SELECT C.*, A.*, BP.SystemStatus SystemStatusBS, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #Accounts A ON (C.AID = A.BSAcctId AND C.ATID = 51)
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = A.BSAcctId)
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 112
)
SELECT *,
--'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(SystemStatusBS AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
AND OldValue <> TRY_CAST(SystemStatusBS AS VARCHAR)
AND NewValue <> TRY_CAST(SystemStatusBS AS VARCHAR)




SELECT * FROM #Accounts WHERE BSAcctId = 1330631

SELECT RTRIM(AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID
--SELECT 1 TypeOfManualReage, RTRIM(AccountNumber) AccountNumber, CASE WHEN CycleDueDTD = 2 THEN AmountOfTotalDue - AmtOfPayXDLate ELSE AmountOfTotalDue - AmtOfPayCurrDue END TotalDueMethod
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN ##Accounts A ON (BP.acctId = A.BSAcctId)
WHERE A.CycleDueDTD IN (0, 1) AND A.SystemStatus = 3

-----------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #ImpactedPlans
SELECT BSacctId, CPSAcctId, CreditPlanType, CurrentBalance, AmountOfTotalDue, CycleDueDTD
INTO #ImpactedPlans
FROM PLanInfoForREport WITH (NOLOCK)
WHERE BusinessDay = '2021-11-11 23:59:57'
AND (CurrentBalance = 0 AND AmountOfTotalDue > 0)

DROP TABLE IF EXISTS #ImpactedPlans
SELECT BSacctId, CPSAcctId, CreditPlanType, CurrentBalance, AmountOfTotalDue, CycleDueDTD
INTO #ImpactedPlans
FROM PLanInfoForREport WITH (NOLOCK)
WHERE BusinessDay = '2021-11-11 23:59:57'
AND ((CurrentBalance < AmountOfTotalDue AND AmountOfTotalDue > 0) OR (CurrentBalance <= 0 AND CycleDueDTD > 0))

SELECT * FROM #ImpactedPlans

SELECT DISTINCT BSacctId FROM #ImpactedPlans

SELECT CreditPlanType, COUNT(1) RecordCount 
FROM #ImpactedPlans
GROUP BY CreditPlanType

DROP TABLE IF EXISTS #ImpactedActivePlans
SELECT I.*, ccinhParent125AID 
INTO #ImpactedActivePlans
FROM #ImpactedPlans I
JOIN AccountInfoForReport A WITH (NOLOCK) ON (I.BSacctId = A.BSAcctID AND A.BusinessDay = '2021-11-11 23:59:57')
WHERE A.SystemStatus <> 14

DROP TABLE IF EXISTS #ImpactedCOPlans
SELECT I.*, ccinhParent125AID
INTO #ImpactedCOPlans
FROM #ImpactedPlans I
JOIN AccountInfoForReport A WITH (NOLOCK) ON (I.BSacctId = A.BSAcctID AND A.BusinessDay = '2021-11-11 23:59:57')
WHERE A.SystemStatus = 14



DROP TABLE IF EXISTS #AllCPS
SELECT DISTINCT CPS.acctId CPSacctId, I.ccinhParent125AID
INTO #AllCPS
FROM #ImpactedActivePlans I
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (I.BSacctId = CPS.parent02AID)

SELECT * FROM #AllCPS

SELECT * FROM PLanInfoForREport P WITH (NOLOCK) WHERE CPSAcctId = 66594740 AND BusinessDay = '2021-11-11 23:59:57'


DROP TABLE IF EXISTS #ImpactedActiveAllPlans
SELECT P.BSacctId, P.CPSAcctId, P.CreditPlanType, P.CurrentBalance, P.AmountOfTotalDue, P.CycleDueDTD, CPS.ccinhParent125AID
INTO #ImpactedActiveAllPlans
FROM PLanInfoForREport P WITH (NOLOCK)
JOIN #AllCPS CPS WITH (NOLOCK) ON (P.CPSAcctId = CPS.CPSacctId)
WHERE P.BusinessDay = '2021-11-11 23:59:57'

SELECT DISTINCT * FROM #ImpactedActiveAllPlans


SELECT * FROM #ImpactedActivePlans WHERE ccinhParent125AID = 16324

SELECT *
FROM #ImpactedActiveAllPlans T1 
JOIN #ImpactedActivePlans T2 ON (T1.CPSacctId = T2.CPSacctId AND T1.BSAcctID = T2.BSAcctID)


UPDATE T1
SET AmountOfTotalDue = 0, CycleDueDTD = 0
FROM #ImpactedActiveAllPlans T1 
JOIN #ImpactedActivePlans T2 ON (T1.CPSacctId = T2.CPSacctId)


WITH CTE 
AS
(
	SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD
	FROM #ImpactedActiveAllPlans
	GROUP BY BSAcctId
)

SELECT CycleDueDTD, COUNT(1) RecordCount 
FROM CTE
GROUP BY CycleDueDTD 



;WITH CTE 
AS
(
	SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD
	FROM #ImpactedActiveAllPlans
	GROUP BY BSAcctId
)

SELECT * 
FROM CTE
WHERE CycleDueDTD = 0 


--

SELECT * FROM #ImpactedActiveAllPlans WHERE CycleDueDTD = 2


SELECT CreditPlanType, COUNT(1) RecordCount 
FROM #ImpactedActivePlans
GROUP BY CreditPlanType

SELECT DISTINCT BSacctId FROM #ImpactedActivePlans

SELECT DISTINCT BSacctId FROM #ImpactedCOPlans