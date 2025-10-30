BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE P1
SET AmountOfTotalDue = P2.AmountOfTotalDue,
AmtOfPayCurrDue = P2.AmtOfPayCurrDue,
AmtOfPayXDLate = P2.AmtOfPayXDLate
FROM PlanInfoForreport  P1
JOIN LISTPRODPLAT.CCGS_CoreIssue_Secondary.DBO.STMT_PlanInfoForreport P2 WITH (NOLOCK) ON (P1.CPSAcctID = P2.CPSAcctID AND P1.BusinessDay = P2.BusinessDay)
WHERE P1.BSAcctID IN (11085265, 17126891)
AND P1.BusinessDay  = '2024-12-31 23:59:57'


/*
SELECT P1.BSAcctID, P1.CPSAcctID, P1.AmountOfTotalDue, P1.AmtOfPayCurrDue, P1.AmtOfPayXDLate,
P2.AmountOfTotalDue, P2.AmtOfPayCurrDue, P2.AmtOfPayXDLate
FROM PlanInfoForreport  P1 WITH (NOLOCK)
JOIN LISTPRODPLAT.CCGS_CoreIssue_Secondary.DBO.STMT_PlanInfoForreport P2 WITH (NOLOCK) ON (P1.CPSAcctID = P2.CPSAcctID AND P1.BusinessDay = P2.BusinessDay)
WHERE P1.BSAcctID IN (11085265, 17126891)
AND P1.BusinessDay  = '2024-12-31 23:59:57'
*/