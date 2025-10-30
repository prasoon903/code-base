SELECT OBJECT_NAME(OBJECT_ID), *
FROM sys.columns WHERE name = 'OriginalPurchaseAmount'

SELECT AccountNumber, acctID FROM BSegment_Primary WITH (NOLOCK) WHERE acctID IN (9414961,21382331)

--acctID	parent02AID
--30299811	9414961		--	1100011145319897   
--67203856	21382331	--	1100011198995841   

DROP TABLE IF EXISTS #TempPlans
select CP.acctID, CP.parent02AID, PlanUUID, CurrentBalance, CurrentBalanceCO, CycleDueDTD, AmountOfTotalDue , OriginalPurchaseAmount
INTO #TempPlans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE parent02AID > 0
AND CreditPlanType = '16'
AND AmountOfTotalDue > OriginalPurchaseAmount

SELECT * FROM #TempPlans