--SELECT * FROM sys.servers

DROP TABLE IF EXISTS #TempPlans 
sELECT P1.CPSAcctID, P1.BusinessDay, P1.Principal 
INTO #TempPlans 
FROM PlanInfoForReport P1 WITH (NOLOCK) 
WHERE P1.Principal IS NULL 
AND P1.BusinessDay = '2024-11-19 23:59:57' 

DROP TABLE IF EXISTS #TempRecords 
SELECT T.*, ISNULl(C1.Principal, 0) + ISNULL(C2.PrincipalCO, 0) Principal_UPd 
INTO #tempRecords 
FROM LISTPRODPLAT.CCGS_CoreIssue_Secondary.dbo.CPSgmentAccountspreintermediate C1 WITH (NOlOCK) 
JOIN LISTPRODPLAT.CCGS_CoreIssue_Secondary.dbo.CPSgmentcreditcardpreintermediate C2 WITH (NOLOCK) ON (C1.acctID = C2.acctId) 
JOIN #TempPlans T ON (C2.acctID = T.CPSAcctID)

--SELECT COUNT(1)
--FROM PlanInfoForReport P 
--JOIN #TempRecords T ON (P.CPSAcctID = T.CPSacctID AND P.BusinessDay = T.Businessday) 

BEGIN TRAN 
--COMMIT IRAN 
--ROLLBACK TRAM 

UPDATE P 
SET P.Principal = T.Principal_UPD 
FROM PlanInfoForReport P 
JOIN #TempRecords T ON (P.CPSAcctID = T.CPSacctID AND P.BusinessDay = T.Businessday) 

