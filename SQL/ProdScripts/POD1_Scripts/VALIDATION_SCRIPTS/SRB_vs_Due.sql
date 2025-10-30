--1 -- FILL DATA

DROP TABLE IF EXISTS #BSRecords
SELECT  
BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid, 
CAST(0 AS MONEY) DueAdjusted_BS, CAST('CASE12345' AS VARCHAR(10)) IssueType
INTO #BSRecords
FROM .AccountInfoForReport WITH (NOLOCK) 
WHERE BusinessDay = '2023-01-29 23:59:57'
AND SYstemStatus <> 14
AND (SRBWithInstallmentDue < AmountOfTotalDue)
--AND BSAcctid NOT IN (25941)

--SELECT * FROM #BSRecords WHERE BSacctId = 7515

UPDATE #BSRecords SET IssueType = 'Issue1' WHERE SRBWithInstallMentDue = 0

UPDATE #BSRecords SET IssueType = 'Issue2' WHERE SRBWithInstallMentDue > 0

DROP TABLE IF EXISTS #PSRecords
SELECT 
PIR.CPSAcctId, PIR.BSAcctID, PIR.CycleDueDTD, PIR.AmountOfTotalDue, PIR.AmtOfPayCurrDue, PIR.AmtOfPayXDLate, PIR.AmountOfPayment30DLate, PIR.SRBWithInstallMentDue, 
PIR.CreditPlanType, CAST(0 AS MONEY) DueAdjusted_PS, BS.IssueType
INTO #PSRecords
FROM .PlanInfoForReport PIR WITH (NOLOCK) 
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (PIR.CPSAcctID = CPS.acctId AND PIR.BusinessDay = '2023-01-29 23:59:57')
JOIN #BSRecords BS WITH (NOLOCK) ON (BS.BSAcctId = CPS.parent02AID)
WHERE PIR.BusinessDay = '2023-01-29 23:59:57'
--AND (PIR.SRBWithInstallmentDue < PIR.AmountOfTotalDue)

-- 2 -- Keeping data to fix into another table

DROP TABLE IF EXISTS ##BSRecords
SELECT * INTO ##BSRecords FROM #BSRecords

DROP TABLE IF EXISTS #PS_BeforeFix
SELECT * INTO #PS_BeforeFix FROM #PSRecords

DROP TABLE IF EXISTS #BS_BeforeFix
SELECT * INTO #BS_BeforeFix FROM #BSRecords

--SELECT * FROM #BSRecords WHERE BSacctId = 19355304

--3 -- 

-- IssueType--1: SRB on account = 0, due should be 0 throughout

--SELECT * FROM #BSRecords WHERE IssueType = 'Issue1'

--SELECT * FROM #PSRecords WHERE IssueType = 'Issue1' AND AmountOfTotalDue > 0

--SELECT * FROM #BSRecords WHERE SRBWithInstallMentDue > 0

UPDATE #PSRecords SET AmountOfTotalDue = 0, CycleDueDTD = 0 WHERE IssueType = 'Issue1' AND AmountOfTotalDue > 0

UPDATE #BSRecords SET AmountOfTotalDue = 0, CycleDueDTD = 0 WHERE IssueType = 'Issue1' AND AmountOfTotalDue > 0



-- IssueType--2: SRB on account > 0, due need to calculate as per SRB

--SELECT * FROM #BSRecords WHERE IssueType = 'Issue2'

--SELECT * FROM #PSRecords WHERE IssueType = 'Issue2'

--SELECT * FROM #BSRecords WHERE IssueType = 'Issue2'

--SELECT * FROM #PSRecords WHERE IssueType = 'Issue2' AND BSacctId = 2001204

UPDATE #PSRecords SET AmountOfTotalDue = 0, CycleDueDTD = 0 WHERE IssueType = 'Issue2' AND SRBWithInstallmentDue <= 0 AND AmountOfTotalDue > 0

UPDATE #PSRecords SET AmountOfTotalDue = SRBWithInstallmentDue WHERE IssueType = 'Issue2' AND SRBWithInstallmentDue > 0 AND SRBWithInstallmentDue < AmountOfTotalDue

DROP TABLE IF EXISTS #Accounts
SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
INTO #Accounts
FROM #PSRecords
WHERE IssueType = 'Issue2'
GROUP BY BSAcctId


;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
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
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType = '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

UPDATE  P
SET AmountOfTotalDue = 0, CycleDueDTD = 0
FROM #PSRecords P 
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail = 0 And P.AmountOfTotalDue > 0

--SELECT *
--FROM #PSRecords P
--JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
--WHERE IssueType = 'Issue2' AND SRB_NoNRetail = 0 And P.AmountOfTotalDue > 0

--SELECT *
--FROM #PSRecords P
--JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
--WHERE IssueType = 'Issue2' AND SRB_NoNRetail < Due_NoNRetail AND P.AmountOfTotalDue > 0


UPDATE  P
SET AmountOfTotalDue = SRB_NoNRetail
FROM #PSRecords P
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail < Due_NoNRetail AND P.AmountOfTotalDue > 0


DROP TABLE IF EXISTS #Accounts_Fixed
SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
INTO #Accounts_Fixed
FROM #PSRecords
WHERE IssueType = 'Issue2'
GROUP BY BSAcctId


;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType <> '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_NoNRetail = I.SRBWithInstallmentDue, Due_NoNRetail = I.AmountOfTotalDue
FROM #Accounts_Fixed A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType = '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
FROM #Accounts_Fixed A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts_Fixed SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

SELECT * FROM #Accounts_Fixed


--------------------------------------- SCRIPTS  ---------------------------------------------------


-- ISSUE 1

SELECT *, 
'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #BSRecords
WHERE IssueType = 'Issue1'
ORDER BY BSAcctID


SELECT * ,
'UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = ' + TRY_CAST(CPSAcctID AS VARCHAR) CPSgmentCreditCard
FROM #PS_BeforeFix
WHERE IssueType = 'Issue1'
AND AmountOfTotalDue > 0
ORDER BY CPSAcctID

--Issue2


-- Scripts


SELECT *, 
'UPDATE	TOP(1)	#BSegment_Primary	SET	CycleDueDTD = 1,	SystemStatus = 2,	AmtOfPayCurrDue =	' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + '	WHERE	acctID =	' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE	TOP(1)	#BSegmentCreditCard	SET	AmountOfTotalDue =	' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ',	AmtOfPayXDLate = 0,	AmountOfPayment30DLate = 0,	AmountOfPayment60DLate = 0,
RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + 
',	DaysDelinquent = 0,	NoPayDaysDelinquent = 0,	
DateOfOriginalPaymentDueDTD = ''2023-01-31 23:59:57'',	DtOfLastDelinqCTD = NULL,	FirstDueDate = ''2023-01-31 23:59:57''	
WHERE acctID =	' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts_Fixed
WHERE CycleDueDTD = 1
ORDER BY BSAcctID


SELECT *, 
'UPDATE	TOP(1)	#BSegment_Primary	SET	CycleDueDTD = 2, SystemStatus = 3, AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE	TOP(1)	#BSegmentCreditCard	SET	AmountOfTotalDue	=	' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ',	AmtOfPayXDLate = 0,	AmountOfPayment30DLate = 0,	AmountOfPayment60DLate = 0,	
RunningMinimumDue =	' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ',	RemainingMinimumDue =	' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ',	DaysDelinquent = 0,	NoPayDaysDelinquent = 0,	
DAteOfOriginalPaymentDueDTD =	''2022-02-28 23:59:57'',	DtOfLastDelinqCTD =	NULL,	FirstDueDate = ''2022-02-28 23:59:57''
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts_Fixed
WHERE CycleDueDTD > 1
ORDER BY BSAcctID


--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 0.69, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0.69, RunningMinimumDue = 0.69, RemainingMinimumDue = 0.69  WHERE acctID = 1025206

--UPDATE TOP(1) #BSegment_Primary SET AmtOfPayCurrDue = 287.82 WHERE acctID = 2001204
--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 518.36, AmtOfPayXDLate = 230.54,  RunningMinimumDue = 518.36, RemainingMinimumDue = 518.36  WHERE acctID = 2001204


--UPDATE TOP(1) #BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.26 WHERE acctID = 4250558
--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.12, AmtOfPayXDLate = AmtOfPayXDLate - 24.86,  
--RunningMinimumDue = RunningMinimumDue - 26.12, RemainingMinimumDue = RemainingMinimumDue - 26.12  WHERE acctID = 4250558


SELECT *
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
--AND P1.AmountOfTotalDue = 0 AND P2.AmountOfTotalDue > 0

SELECT 
'UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P1.AmountOfTotalDue = 0 AND P2.AmountOfTotalDue > 0

SELECT *,
'UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ', AmtOfPayCurrDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard 
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
AND P1.CycleDueDTD = 1

SELECT *,
'UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ', AmountOfPayment30DLate = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard 
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
AND P1.CycleDueDTD = 3


--SELECT * FROm #PSRecords WHERE BSAcctID = 18539988

--SELECT * FROm #PS_BeforeFix WHERE BSAcctID = 18539988

------------- CURRENTBALANCEAUDIT ----------------



;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.CPSAcctId AND C.ATID = 52)
	WHERE C.BusinessDay > '2022-02-28 23:59:57'
	AND DENAME = 200
)
SELECT *,
CASE
	WHEN OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR) 
	THEN 'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
	WHEN OldValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) 
	THEN 'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
	ELSE
		NULL
END
FROM CTE C
WHERE Ranking = 1
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR) -- For DELETE
--AND OldValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) -- For UPDATE
--AND C.BSAcctID NOT IN (18539988)


;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.CPSAcctId AND C.ATID = 52)
	WHERE C.BusinessDay > '2022-02-28 23:59:57'
	AND DENAME = 115
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
AND OldValue = '0' AND NewValue = '1' AND IssueType = 'Issue1'


;WITH CTE 
AS
(
	SELECT C.*, CAST(A.AmountOfTotalDue AS MONEY) AmountOfTotalDue, A.CycleDueDTD, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #BSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51 /*AND IssueType = 'Issue1'*/)
	WHERE C.BusinessDay > '2022-02-28 23:59:57'
	AND DENAME = 200
)
SELECT 
CASE 
WHEN C.OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
WHEN C.OldValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) AND C.NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
ELSE NULL END CBA_Due,
CASE 
WHEN CA.TID IS NOT NULL THEN 
	CASE 
	WHEN CA.OldValue = TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(CA.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(CA.IdentityField AS VARCHAR)
	WHEN CA.OldValue <> TRY_CAST(CycleDueDTD AS VARCHAR) AND CA.NewValue <> TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(CycleDueDTD AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(CA.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(CA.IdentityField AS VARCHAR)
	ELSE NULL END
ELSE CASE 
	WHEN C.AmountofTotalDue = 0 THEN 'INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (' + TRY_CAST(C.TID AS VARCHAR) + ', ''' + TRY_CONVERT(VARCHAR(50), C.businessday, 20) + ''', 51, ' +TRY_CAST(C.AID AS VARCHAR) + ', 115, ''1'', ''0'')'
	ELSE NULL END
END CBA_CycleDueDTD,
*
FROM CTE C
LEFT JOIN CurrentBalanceAudit CA WITH (NOLOCK) ON (C.AID = CA.AID AND C.TID = CA.TID AND CA.ATID = 51 AND CA.DENAME = 115)
WHERE C.Ranking = 1
--AND C.AID NOT IN (1844055)



-------------------------------------------------------------------------------------------------------------------------------------

/*
;WITH CTE 
AS
(
	SELECT C.*, A.AmountOfTotalDue, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #BSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51 AND IssueType = 'Issue1')
	WHERE C.BusinessDay > '2021-12-31 23:59:57'
	AND DENAME = 200
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
AND OldValue = '0.00'
--AND OldValue <> '0.00' AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)





;WITH CTE 
AS
(
	SELECT C.*, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51  AND IssueType = 'Issue1')
	WHERE C.BusinessDay > '2021-12-31 23:59:57'
	AND DENAME = 115
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
AND OldValue = '0' AND NewValue = '1' 
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)










--UPDATE #BSRecords SET IssueType = 'Issue1' WHERE SRBWithInstallMentDue = 0

--UPDATE #BSRecords SET IssueType = 'Issue2' WHERE SRBWithInstallMentDue > 0

SELECT IssueType, COUNT(1) RecordCount
FROm #PSRecords 
GROUP BY IssueType







SELECT *, 
'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #BSRecords
WHERE IssueType = 'Issue1'
ORDER BY BSAcctID


SELECT * ,
'UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = ' + TRY_CAST(CPSAcctID AS VARCHAR) CPSgmentCreditCard
FROM #PSRecords
WHERE IssueType = 'Issue1'
--AND AmountOfTotalDue > 0
ORDER BY CPSAcctID




-- IssueType--2: SRB on account > 0, due need to calculate as per SRB

SELECT * FROM #BSRecords WHERE IssueType = 'Issue2'

SELECT * FROM #PSRecords WHERE IssueType = 'Issue2'

SELECT * FROM #BSRecords WHERE IssueType = 'Issue2'

SELECT * FROM #PSRecords WHERE IssueType = 'Issue2' AND BSacctId = 2001204

UPDATE #PSRecords SET AmountOfTotalDue = 0 WHERE IssueType = 'Issue2' AND SRBWithInstallmentDue <= 0 AND AmountOfTotalDue > 0

UPDATE #PSRecords SET AmountOfTotalDue = SRBWithInstallmentDue WHERE IssueType = 'Issue2' AND SRBWithInstallmentDue > 0 AND SRBWithInstallmentDue < AmountOfTotalDue

DROP TABLE IF EXISTS #Accounts
SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
INTO #Accounts
FROM #PSRecords
WHERE IssueType = 'Issue2'
GROUP BY BSAcctId

SELECT * FROM #Accounts


SELECT * FROM #Accounts_Fixed WHERE   BSacctId = 303735


SELECT * FROM #PSRecords WHERE   BSacctId = 303735



;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
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
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType = '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
FROM #Accounts A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

UPDATE  P
SET AmountOfTotalDue = 0 
FROM #PSRecords P 
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail = 0 And P.AmountOfTotalDue > 0

SELECT *
FROM #PSRecords P
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail = 0 And P.AmountOfTotalDue > 0

SELECT *
FROM #PSRecords P
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail < Due_NoNRetail AND P.AmountOfTotalDue > 0


UPDATE  P
SET AmountOfTotalDue = SRB_NoNRetail
FROM #PSRecords P
JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
WHERE IssueType = 'Issue2' AND SRB_NoNRetail < Due_NoNRetail AND P.AmountOfTotalDue > 0

SELECT * FROM #PSRecords WHERE IssueType = 'Issue2' 

SELECT * FROM #Accounts WHERE SRB_NoNRetail = 0

DROP TABLE IF EXISTS #Accounts_Fixed
SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
INTO #Accounts_Fixed
FROM #PSRecords
WHERE IssueType = 'Issue2'
GROUP BY BSAcctId


;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType <> '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_NoNRetail = I.SRBWithInstallmentDue, Due_NoNRetail = I.AmountOfTotalDue
FROM #Accounts_Fixed A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

;WITH CTE
AS
(
	SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
	FROM #PSRecords I 
	WHERE CreditPlanType = '16'
	GROUP BY BSAcctId
)
UPDATE A
SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
FROM #Accounts_Fixed A
JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

UPDATE #Accounts_Fixed SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

SELECT * FROM #Accounts_Fixed


-- Scripts


SELECT *, 
'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + 
', DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = ''2021-10-31 23:59:57'', DtOfLastDelinqCTD = NULL, FirstDueDate = ''2021-10-31 23:59:57''
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts_Fixed
WHERE CycleDueDTD = 1
ORDER BY BSAcctID


SELECT *, 
'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + 
', DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = ''2021-10-31 23:59:57'', DtOfLastDelinqCTD = NULL, FirstDueDate = ''2021-10-31 23:59:57''
WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
FROM #Accounts_Fixed
WHERE CycleDueDTD > 1
ORDER BY BSAcctID


--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 0.69, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0.69, RunningMinimumDue = 0.69, RemainingMinimumDue = 0.69  WHERE acctID = 1025206

--UPDATE TOP(1) #BSegment_Primary SET AmtOfPayCurrDue = 287.82 WHERE acctID = 2001204
--UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 518.36, AmtOfPayXDLate = 230.54,  RunningMinimumDue = 518.36, RemainingMinimumDue = 518.36  WHERE acctID = 2001204


SELECT *
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
--AND P1.AmountOfTotalDue = 0 AND P2.AmountOfTotalDue > 0

SELECT 
'UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P1.AmountOfTotalDue = 0 AND P2.AmountOfTotalDue > 0

SELECT *,
'UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ', AmtOfPayCurrDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard 
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
AND P1.CycleDueDTD = 1

SELECT *,
'UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ', AmountOfPayment30DLate = ' + TRY_CAST(P1.AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(P1.CPSAcctID AS VARCHAR) CPSgmentCreditCard 
FROM #PSRecords P1
JOIN #PS_BeforeFix P2 ON (P1.CPSAcctid = P2.CPSAcctid)
WHERE P1.IssueType = 'Issue2' 
AND P2.AmountOfTotalDue <> P1.AmountOfTotalDue AND P1.AmountOfTotalDue <> 0
AND P1.CycleDueDTD = 3


UPDATE #CPSgmentCreditCard SET AmountOfTotalDue = 0.69, AmountOfPayment30DLate = 0.69 WHERE acctID = 62888271

SELECT * FROm #Accounts_Fixed  WHERE SRB_NoNRetail < Due_NoNRetail



SELECT * FROm #Accounts_Fixed WHERE BSAcctid = 12409337

SELECT * FROm #Accounts WHERE BSAcctid = 12409337


SELECT * FROm #PSRecords WHERE BSAcctid = 12409337


;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.CPSAcctId AND C.ATID = 52)
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 200
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)


;WITH CTE 
AS
(
	SELECT *, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.CPSAcctId AND C.ATID = 52)
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 115
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
AND OldValue = '0' AND NewValue = '1' AND IssueType = 'Issue1'
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)


;WITH CTE 
AS
(
	SELECT C.*, A.AmountOfTotalDue, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #BSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51 AND IssueType = 'Issue1')
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 200
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
--AND CycleDueDTD = 1
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
AND OldValue = '0.00'
--AND OldValue <> '0.00' AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)





;WITH CTE 
AS
(
	SELECT C.*, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
	FROM CurrentBalanceAuditPS C WITH (NOLOCK) JOIN #PSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51  AND IssueType = 'Issue1')
	WHERE C.BusinessDay > '2021-10-31 23:59:57'
	AND DENAME = 115
)
SELECT *,
'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
--'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
FROM CTE C
WHERE Ranking = 1
AND OldValue = '0' AND NewValue = '1' 
--AND OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR)
--AND NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR)





/*
--2

UPDATE #PSRecords SET DueAdjusted_PS = AmountOfTotalDue - CASE WHEN SRBWithInstallmentDue > 0 THEN SRBWithInstallmentDue ELSE 0 END

DROP TABLE IF EXISTS #DueToAdjust
SELECT BSAcctId, SUM(DueAdjusted_PS) DueAdjusted_PS
INTO #DueToAdjust
FROM #PSRecords
GROUP BY BSAcctId

UPDATE BS
SET DueAdjusted_BS = DueAdjusted_PS
FROM #BSRecords BS
JOIN #DueToAdjust DT ON (BS.BSAcctId = DT.BSAcctId)


--3 (CycleDueDTD <= 1)


SELECT *,
'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
', AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
', CycleDueDTD = 0 WHERE acctId = ' + 
TRY_CAST(CPSAcctID AS VARCHAR) + ' -- BS: ' + TRY_CAST(BSAcctID AS VARCHAR) 
FROM #PSRecords WHERE DueAdjusted_PS > 0 AND CycleDueDTD <= 1 AND AmountOfTotalDue - DueAdjusted_PS <= 0


SELECT *,
'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
', AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
' WHERE acctId = ' + 
TRY_CAST(CPSAcctID AS VARCHAR) + ' -- BS: ' + TRY_CAST(BSAcctID AS VARCHAR) 
FROM #PSRecords WHERE DueAdjusted_PS > 0 AND CycleDueDTD <= 1 AND AmountOfTotalDue - DueAdjusted_PS > 0

SELECT *,
'UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) + 
', RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) +
', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) + 
' WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR),
'UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) +  
', CycleDueDTD = 0 WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR) 
FROM #BSRecords 
WHERE DueAdjusted_BS > 0 AND CycleDueDTD <= 1 AND AmountOfTotalDue - DueAdjusted_BS <= 0



SELECT *,
'UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) + 
', RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) +
', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) + 
' WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR),
'UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) +  
' WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR) 
FROM #BSRecords 
WHERE DueAdjusted_BS > 0 AND CycleDueDTD <= 1 AND AmountOfTotalDue - DueAdjusted_BS > 0


--3 (CycleDueDTD > 1) -- Need to update logic

/*
SELECT *,
'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
', AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_PS AS VARCHAR) + 
', CycleDueDTD = <NeedToSet> WHERE acctId = ' + 
TRY_CAST(CPSAcctID AS VARCHAR) + ' -- BS: ' + TRY_CAST(BSAcctID AS VARCHAR) 
FROM #PSRecords WHERE DueAdjusted_PS > 0 AND CycleDueDTD > 1 


SELECT DueAdjusted_BS, *,
'UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) + 
', RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) +
', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue - DueAdjusted_BS AS VARCHAR) + 
' WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR),
'UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + TRY_CAST(DueAdjusted_BS AS VARCHAR) +  
', CycleDueDTD = <NeedToSetManually>, SystemStatus = <NeedToSetManually> WHERE acctId = ' + 
TRY_CAST(BSAcctID AS VARCHAR) 
FROM #BSRecords 
WHERE DueAdjusted_BS > 0 AND CycleDueDTD > 1 
*/


SELECT DueAdjusted_BS, * FROM #BSRecords WHERE DueAdjusted_BS > 0 AND CycleDueDTD <= 1

SELECT DueAdjusted_BS, * FROM #BSRecords WHERE DueAdjusted_BS > 0 AND CycleDueDTD > 1


SELECT DueAdjusted_BS, * FROM #BSRecords WHERE DueAdjusted_BS = 0

SELECT BSAcctId 
FROM #PSRecords 
WHERE DueAdjusted_PS > 0 AND CycleDueDTD > 1 --AND AmountOfTotalDue - DueAdjusted_PS <= 0
GROUP BY BSAcctId


SELECT BSAcctId 
FROM #PSRecords 
WHERE DueAdjusted_PS = 0
GROUP BY BSAcctId





SELECT * FROM #BSRecords 
--WHERE BSAcctId IN (4733586, 12887, 3783604, 10772, 284978, 3748505, 2259429, 4640763, 275808, 4337624, 10667)

SELECT * FROM #PSRecords WHERE SRBWithInstallmentDue > 0

SELECT * FROM #PSRecords WHERE DueAdjusted_PS > 0 AND CycleDueDTD <= 1 AND AmountOfTotalDue - DueAdjusted_PS > 0

--'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + AmtOfPayCurrDue + ', AmountOfTotalDue = AmountOfTotalDue - ' + AmountOfTotalDue + ', CycleDueDTD = 0 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' -- BS: ' + TRY_CAST(@BSAcctID AS VARCHAR)


SELECT * FROM #PSRecords WHERE DueAdjusted_PS > 0 AND CycleDueDTD > 1

DROP TABLE IF EXISTS #DueToAdjust
SELECT BSAcctId, SUM(DueAdjusted_PS) DueAdjusted_PS
INTO #DueToAdjust
FROM #PSRecords
GROUP BY BSAcctId

UPDATE BS
SET DueAdjusted_BS = DueAdjusted_PS
FROM #BSRecords BS
JOIN #DueToAdjust DT ON (BS.BSAcctId = DT.BSAcctId)

--UPDATE #PSRecords SET DueAdjusted_PS = AmountOfTotalDue - CASE WHEN SRBWithInstallmentDue > 0 THEN SRBWithInstallmentDue ELSE 0 END


SELECT  
BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, DueAdjusted_BS, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid
FROM #BSRecords
WHERE SRBWithInstallmentDue < AmountOfTotalDue - DueAdjusted_BS



DROP TABLE IF EXISTS #BSRecords
SELECT  
BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid, CAST(0 AS MONEY) DueAdjusted_BS
INTO #BSRecords
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BusinessDay = '2021-10-28 23:59:57'
AND SYstemStatus <> 14
AND (SRBWithInstallmentDue < AmountOfTotalDue)


SELECT  COUNT(1)
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BusinessDay = '2021-10-28 23:59:57'
AND SYstemStatus <> 14
AND (SRBWithInstallmentDue < AmountOfTotalDue)
--11165



--Due on retail plan > SRB -- need to check

DROP TABLE IF EXISTS #PSRecords
SELECT 
PIR.CPSAcctId, PIR.BSAcctID, PIR.CycleDueDTD, PIR.AmountOfTotalDue, PIR.AmtOfPayCurrDue, PIR.AmtOfPayXDLate, PIR.AmountOfPayment30DLate, PIR.SRBWithInstallMentDue, PIR.CreditPlanType, CAST(0 AS MONEY) DueAdjusted_PS
INTO #PSRecords
FROM PlanInfoForReport PIR WITH (NOLOCK) 
JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (PIR.CPSAcctID = CPS.acctId AND PIR.BusinessDay = '2021-10-28 23:59:57')
JOIN #BSRecords BS WITH (NOLOCK) ON (BS.BSAcctId = CPS.parent02AID)
WHERE PIR.BusinessDay = '2021-10-28 23:59:57'
AND (PIR.SRBWithInstallmentDue < PIR.AmountOfTotalDue)


*/

*/



--;WITH CTE 
--AS
--(
--	SELECT C.*, CAST(A.AmountOfTotalDue AS MONEY) AmountOfTotalDue, A.CycleDueDTD, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
--	FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #BSRecords A ON (C.AID = A.BSAcctId AND C.ATID = 51 /*AND IssueType = 'Issue1'*/)
--	WHERE C.BusinessDay > '2021-12-31 23:59:57'
--	AND DENAME = 200
--)
--SELECT CA.OldValue, CA.NewValue, TRY_CAST(CycleDueDTD AS VARCHAR),
--*
--FROM CTE C
--LEFT JOIN CurrentBalanceAudit CA WITH (NOLOCK) ON (C.AID = CA.AID AND C.TID = CA.TID AND CA.ATID = 51 AND CA.DENAME = 115)
--WHERE C.Ranking = 1