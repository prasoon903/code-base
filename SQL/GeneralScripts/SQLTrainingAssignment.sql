/********************************D A Y  2**********************************/

DECLARE @PlanWiseBalance TABLE
(
	AccountID			INT,
	PlanID				INT,
	PlanType			VARCHAR(10),
	PlanWiseBalance		MONEY
)

INSERT INTO @PlanWiseBalance
	SELECT
		parent02AID,
		acctId, 
		CASE	WHEN creditplantype = '0' THEN 'Revolving'
				WHEN creditplantype = '10' THEN 'RRC'
				WHEN creditplantype = '16' THEN 'Retail'
				ELSE 'NA'
		END, 
		SUM(ISNULL(CurrentBalance, 0)) 
	FROM  CPSgmentAccounts WITH (NOLOCK)
	GROUP BY parent02AID, acctId, creditplantype
	ORDER BY parent02AID


SELECT * FROM @PlanWiseBalance


-- USING TEMP TABLE

DROP TABLE IF EXISTS #PlanWiseBalance
GO
CREATE TABLE #PlanWiseBalance
(
	AccountID			INT,
	PlanID				INT,
	PlanType			VARCHAR(10),
	PlanWiseBalance		MONEY
)

INSERT INTO #PlanWiseBalance
	SELECT
		parent02AID,
		acctId, 
		CASE	WHEN creditplantype = '0' THEN 'Revolving'
				WHEN creditplantype = '10' THEN 'RRC'
				WHEN creditplantype = '16' THEN 'Retail'
				ELSE 'NA'
		END, 
		SUM(ISNULL(CurrentBalance, 0)) 
	FROM  CPSgmentAccounts WITH (NOLOCK)
	GROUP BY parent02AID, acctId, creditplantype
	ORDER BY parent02AID


SELECT * FROM #PlanWiseBalance


/********************************D A Y  1**********************************/


SELECT 
	BP.*
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (BP.acctId = CPA.parent02AID)
WHERE BP.acctId = 5037

SELECT 
	BP.acctId, CPA.acctId, BP.AccountNumber, CPA.creditplantype
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (BP.acctId = CPA.parent02AID)
ORDER BY BP.acctId

SELECT TOP 10
	BP.acctId, BP.AccountNumber, CPA.creditplantype
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (BP.acctId = CPA.parent02AID)
ORDER BY BP.acctId

SELECT DISTINCT
	BP.acctId, BP.AccountNumber, CPA.creditplantype
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (BP.acctId = CPA.parent02AID)

SELECT 
	BP.ccinhparent125AID, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
GROUP BY BP.ccinhparent125AID

SELECT 
	BP.ccinhparent125AID, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
GROUP BY BP.ccinhparent125AID
HAVING BP.ccinhparent125AID = 2

SELECT 
	BP.ccinhparent125AID, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
WHERE BP.ccinhparent125AID = 2
GROUP BY BP.ccinhparent125AID

SELECT 
	BP.ccinhparent125AID, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
GROUP BY BP.ccinhparent125AID
HAVING COUNT(1) > 2

SELECT 
	BP.ccinhparent125AID, CL.LutDescription ManualStatus, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CAST(BP.ccinhparent125AID AS VARCHAR) = CL.LUTCode AND CL.LUTid = 'AsstPlan' AND CL.LutLanguage = 'dbb')
GROUP BY BP.ccinhparent125AID, CL.LutDescription