SELECT * from BSegment_Primary WITH (NOLOCK) WHERE acctID = 1362749

SELECT * FROM APIQueue WITH (NOLOCK) WHERE parent02AID = 1362749

SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE DestBSAcctID = 1362749
SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE SrcBSAcctID = 18725448

--98435764, 105887291


SELECT * 
FROM CPSgmentAccounts Cp WITH (NOLOCK)
JOIN CPsgmentCreditCard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE parent02AID = 1362749

SELECT ScheduleID, ScheduleIndicator, *
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
WHERE parent02AID = 1362749
AND PlanID = 105887291

SELECT *
FROM ILPScheduleDetails ILPS WITH (NOLOCK)
WHERE acctID = 166543140
AND ScheduleID = 34608715
ORDER BY LoanTerm


SELECT *
FROM ILPScheduleDetailsRevised ILPS WITH (NOLOCK)
WHERE acctID = 166543140
AND ScheduleID = 34608715
ORDER BY LoanTerm

--166543140	34608715

;WITH AllPlans
AS
(
SELECT CP.acctID , CP.CurrentBalance+CPC.CurrentBalanceCO CurrentBalance, MergeDate
FROM CPSgmentAccounts Cp WITH (NOLOCK)
JOIN CPsgmentCreditCard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE parent02AID = 1362749
AND CreditPlanType = '16'
)
, CTE
AS
(
SELECT PlanID, ScheduleID, ScheduleIndicator, RevisedLoanTerm
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN AllPlans A ON (ILPS.PlanID = A.acctID)
--WHERE parent02AID = 1362749
--AND PlanID = 166543140
),
ILP As
(
SELECT  C.PlanID, C.ScheduleID, C.RevisedLoanTerm, C.ScheduleIndicator, CASE WHEN C.ScheduleID IS NOT NULL THEN COUNT(1) ELSE 0 END RecordCount
FROM ILPScheduleDetails ILP WITH (NOLOCK)
RIGHT JOIN CTE C ON (ILP.acctId = C.PlanID AND ILP.ScheduleID = C.ScheduleID)
WHERE C.ScheduleIndicator IN (0, 1) OR C.ScheduleIndicator IS NULL
GROUP BY C.PlanID, C.ScheduleID, C.RevisedLoanTerm, C.ScheduleIndicator
),
ILPR As
(
SELECT  C.PlanID, C.ScheduleID, C.RevisedLoanTerm, C.ScheduleIndicator, CASE WHEN C.ScheduleID IS NOT NULL THEN COUNT(1) ELSE 0 END RecordCount
FROM ILPScheduleDetailsrevised ILP WITH (NOLOCK)
RIGHT JOIN CTE C ON (ILP.acctId = C.PlanID AND ILP.ScheduleID = C.ScheduleID)
WHERE C.ScheduleIndicator = 2 OR C.ScheduleIndicator IS NULL
GROUP BY C.PlanID, C.ScheduleID, C.RevisedLoanTerm, C.ScheduleIndicator
), AllSchedules
AS
(
SELECT * FROM ILP
UNION
SELECT * FROM ILPR
)
SELECT * FROM AllSchedules




SELECT * FROM BSegment_Primary WITH (NOLOCK) WHERE acctID IN (12814854, 12135156, 4958320, 1362749, 11518718, 1457169, 17706632, 441551, 1102178)

SELECT AccountNumber, BP.acctID BSAcctID, BP.LastStatementDate, CP.acctID, OriginalPurchaseAmount, CP.DisputesAmtNS, CP.CurrentBalance+CPC.CurrentbalanceCO CurrentBalance, CPC.PaidOutDate 
FROM CPSgmentAccounts CP with (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
WHERE CP.parent02AID IN (12814854, 12135156, 4958320, 1362749, 11518718, 1457169, 17706632, 441551, 1102178)
AND CPC.PaidOutDate IS NOT NULL
AND CP.CreditPlanType = '16'
ORDER BY CP.parent02AID


SELECT AccountNumber, BP.acctID BSAcctID, BP.LastStatementDate, CP.acctID, OriginalPurchaseAmount, CP.SingleSaleTranID, CPC.MergeDate, CP.DisputesAmtNS, CP.CurrentBalance+CPC.CurrentbalanceCO CurrentBalance, CPC.PaidOutDate 
FROM CPSgmentAccounts CP with (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
WHERE CP.parent02AID IN (1362749)
AND CP.acctID IN (98435764, 105887291)
AND CPC.PaidOutDate IS NOT NULL
AND CP.CreditPlanType = '16'
ORDER BY CP.parent02AID

SELECT * 
FROM SummaryHeader SH WITH (NOLOCK)
LEFT JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (SH.acctID = CP.acctID)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE CP.parent02AID = 1362749 
AND SH.StatementDate = '2024-08-31 23:59:57.000' 
AND CP.CreditPlanType = '16'
AND CPC.PaidOutDate IS NOT NULL

SELECT * FROM APIQueue WITH (NOLOCK) WHERE parent02AID = 1362749

--98435764
--105887291


;WITH CTE 
AS
(
SELECT AccountNumber, BP.acctID BSAcctID, BP.LastStatementDate, CP.acctID, OriginalPurchaseAmount, CP.SingleSaleTranID, CPC.MergeDate, CP.DisputesAmtNS, CP.CurrentBalance+CPC.CurrentbalanceCO CurrentBalance, CPC.PaidOutDate 
FROM CPSgmentAccounts CP with (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
WHERE CP.parent02AID IN (1362749)
AND CPC.PaidOutDate IS NOT NULL
AND CP.CreditPlanType = '16'
--ORDER BY CP.parent02AID
)
SELECT CP.*
FROM CTE C 
JOIN CCArd_Primary CP WITH (NOLOCK) ON (CP.AccountNumber = C.AccountNumber AND CP.TranID = C.SingleSaleTranID)


SELECT X.*, T.acctID
FROM XRefTable X WITH (NOLOCK)
RIGHT JOIN CPSgmentAccounts T WITH (NOLOCK) ON (X.ParentATID = 51 AND X.parentAID = T.parent02AID AND ChildATID = 52 AND X.ChildAID = T.acctID)
WHERE T.parent02AID IN (1362749)
AND T.acctID IN (98435764, 105887291)
AND X.ChildAID IS NULL



--Need to check - 1362749 (98435764, 105887291), 11518718 (103774753)




DROP TABLE IF EXISTS #PlansToDelink
CREATE TABLE #PlansToDelink (AccountNumber VARCHAR(19), BSAcctID INT, LastStatementDate DATETIME, acctID INT, DisputesAmtNS MONEY, CurrentBalance MONEY, PaidOutDate DATETIME)
INSERT INTO #PlansToDelink VALUES ('1100011154853166', 12814854, '2024-08-31 23:59:57.000', 166543140, 0, 0, '2024-08-29 09:12:34.000') -- MergeIssue
INSERT INTO #PlansToDelink VALUES ('1100011154853166', 12814854, '2024-08-31 23:59:57.000', 166543141, 0, 0, '2024-08-29 09:12:35.000') --MergeIssue
INSERT INTO #PlansToDelink VALUES ('1100011151708322', 12135156, '2024-08-31 23:59:57.000', 77922796, 0, 0, '2022-03-31 06:36:41.000') -- 0.01 Purchase
INSERT INTO #PlansToDelink VALUES ('1100011138170489', 4958320, '2024-08-31 23:59:57.000', 10721730, 0, 0, '2020-01-16 15:55:04.000') -- Same TranID for 2 plans
INSERT INTO #PlansToDelink VALUES ('1100011114535622', 1457169, '2024-08-31 23:59:57.000', 45447540, 0, 0, '2021-04-02 05:41:17.000') -- 0.05 Purchase
INSERT INTO #PlansToDelink VALUES ('1100011178501106', 17706632, '2024-08-31 23:59:57.000', 54805752, 0, 0, '2021-07-03 14:06:15.000') -- 0.01 Purchase
INSERT INTO #PlansToDelink VALUES ('1100011149426433', 11518718, '2024-08-31 23:59:57.000', 103774753, 0, 0, '2022-11-29 04:32:02.000') -- Xref not present
INSERT INTO #PlansToDelink VALUES ('1100011113591527', 1362749, '2024-08-31 23:59:57.000', 98435764, 0, 0, '2023-08-02 13:32:26.000') -- Schedule not present
INSERT INTO #PlansToDelink VALUES ('1100011113591527', 1362749, '2024-08-31 23:59:57.000', 105887291, 0, 0, '2023-08-02 13:32:26.000') -- Schedule not present

