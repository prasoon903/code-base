DROP TABLE IF EXISTS #TempAccounts
CREATE TABLE #TempAccounts (BSAcctID INT)

INSERT INTO #TempAccounts VALUES 
(14551608)--, 
--(2829597)

DROP TABLE IF EXISTS #TempData
;WITH CTE
AS
(
SELECT BP.acctID BSAcctID, BP.AccountNumber, BP.ccinhparent127AID BillingTable, BP.LastStatementDate, BP.DateOfNextStmt, 
CP.acctID CPSID, CPM.acctID CPMID, CPM.intplanoccurr,
--BT.ccinhparent111AID, BT.ccinhparent112AID, BT.ccinhparent113AID, BT.RatificationMethod1,
CASE
	WHEN CPM.intplanoccurr = 1 THEN BT.ccinhparent111AID
	WHEN CPM.intplanoccurr = 2 THEN BT.ccinhparent112AID
	WHEN CPM.intplanoccurr = 3 THEN BT.ccinhparent113AID
	WHEN CPM.intplanoccurr = 4 THEN BT.ccinhparent114AID
	ELSE 0
END AS InterestPlan,
CASE
	WHEN CPM.intplanoccurr = 1 THEN BT.RatificationMethod1
	WHEN CPM.intplanoccurr = 2 THEN BT.RatificationMethod2
	WHEN CPM.intplanoccurr = 3 THEN BT.RatificationMethod3
	WHEN CPM.intplanoccurr = 4 THEN BT.RatificationMethod4
	ELSE 0
END AS RatificationMethod
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN #TempAccounts T ON (T.BSAcctID = BP.acctID)
JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (BP.acctID = CP.parent02AID)
JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.parent01AID = CPM.acctID)
JOIN BillingTableAccounts BT WITH (NOLOCK) ON (BP.ccinhparent127AID = BT.acctID)
--WHERE BP.acctID = 2830360
),
Interest AS
(
SELECT C.*, CL.LutDescription InterestType, IA.VarIntRateDesc IndexrateParent, MaximumInterestRate, IA.FixedRate1, Variance1, VarInterestRate
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))
JOIN CTE C ON (C.InterestPlan = IA.acctID)
),
IndexRates AS
(
SELECT IT.*, I.DateEffective, I.Value IRate, ROW_NUMBER() OVER(PARTITION BY InterestPlan,IndexRateInterestParent ORDER BY DateEffective DESC) [Row]
FROM Interest IT
JOIN IndexRate I WITH (NOLOCK) ON (I.IndexRateInterestParent = IT.IndexrateParent)
WHERE (I.DateEffective < IT.LastStatementDate OR IT.LastStatementDate IS NULL)
)
SELECT BSAcctID,AccountNumber,BillingTable,LastStatementDate,DateOfNextStmt,
CPSID,CPMID,intplanoccurr,InterestPlan,RatificationMethod,InterestType,
IndexrateParent,MaximumInterestRate,ISNULL(FixedRate1, 0) FixedRate1,Variance1,VarInterestRate,
DateEffective,IRate,
CASE 
	WHEN RatificationMethod = 1 THEN VarInterestRate 
	WHEN RatificationMethod = 2 THEN IRate
END AS IndexRate,
CASE 
	WHEN InterestType = 'Fixed' THEN ISNULL(FixedRate1, 0)
	ELSE Variance1 
END +
CASE 
	WHEN RatificationMethod = 1 THEN VarInterestRate 
	WHEN RatificationMethod = 2 THEN IRate
END AS TotalInterest
INTO #TempData
FROM IndexRates 
WHERE [Row] = 1

SELECT * FROM #TempData


--DROP TABLE IF EXISTS #TempRecords
--SELECT BSAcctID, CPMID, 
--CASE 
--	WHEN intplanoccurr = 1 THEN 'Variance1'
--	ELSE 'Variance1_Plan'+TRY_CAST(RTRIM(intplanoccurr) AS VARCHAR) 
--END AS Variance, 
--'InterestGFatheredPlan'+TRY_CAST(RTRIM(intplanoccurr) AS VARCHAR) InterestGFatheredPlan, 
--TotalInterest
--INTO #TempRecords
--FROM #TempData

--SELECT *,
--'UPDATE TOP(1) LastUsedRates SET ' + Variance + ' = ' + TRY_CAST(TotalInterest AS VARCHAR) + ', ' + 
--InterestGFatheredPlan + ' = ''0'' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR)
--FROM #tempRecords




--;WITH CTE
--AS
--(
--	SELECT T.*, I.DateEffective, I.Value IRate, ROW_NUMBER() OVER(PARTITION BY InterestPlan,IndexRateInterestParent ORDER BY DateEffective DESC) [Row]
--	FROM #TempData T
--	JOIN IndexRate I WITH (NOLOCK) ON (I.IndexRateInterestParent = T.IndexrateParent)
--	WHERE I.DateEffective < T.LastStatementDate
--)
--SELECT *, 
--CASE 
--	WHEN LastStatementDate > DateEffective THEN IRate
--	WHEN DateOfNextStmt > DateEffective THEN VarInterestRate
--END IndexRate
--FROM CTE WHERE [Row] = 1




--SELECT *, ROW_NUMBER() OVER(PARTITION BY IndexRateInterestParent ORDER BY DateEffective DESC) [Row] 
--FROM IndexRate WITH (NOLOCK)
--WHERE IndexRateInterestParent = 2969
--AND DateEffective < '2021-04-15 23:59:57.000'


--SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = 2829597

--SELECT parent02AID FROM CPSgmentAccounts WITH (NOLOCK) GROUP BY parent02AID HAVING COUNT(1) > 2