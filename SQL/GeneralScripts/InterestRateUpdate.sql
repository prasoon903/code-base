SELECT * FROM InterestRateUpdateJob
SELECT * FROM InterestRateUpdateLog
SELECT * FROM IndexRate
SELECT * FROM InterestAccounts
SELECT RatificationMethod1, RatificationMethod2,* FROM BillingTableAccounts

SELECT Variance1, Variance1_Plan2, Variance1_Plan3, InterestGFatheredPlan1, InterestGFatheredPlan2, InterestGFatheredPlan3,* 
FROM LastUsedRates WITH (NOLOCK) 
WHERE acctID = 2830360

--UPDATE lastusedrates 
--	SET Variance1 = 0, 
--	Variance1_Plan2 = 0, 
--	Variance1_Plan3 = 0,
--	InterestGFatheredPlan1 = 1, 
--	InterestGFatheredPlan2 = 1, 
--	InterestGFatheredPlan3 = 1 
--WHERE Acctid = 2830360

--UPDATE lastusedrates SET InterestActivePlan1 = 0, InterestActivePlan2 = 0, InterestActivePlan3 = 0 WHERE Acctid = 2830360

SELECT parent01AID,*
FROM CPSgmentAccounts WITH (NOLOCK)
WHERE parent02AID = 2830360

--13750
--13770
--13772



DECLARE @AccountID INT, @CPM INT, @BillingTable INT, @InterestPlan INT, @PlanOccurance INT

SET @AccountID = 2830360
SET @CPM = 13772
--SET @BillingTable = 10384



SELECT @BillingTable = ccinhparent127AID FROM BSegment_Primary BP WITH (NOLOCK) WHERE acctId = @AccountID

SELECT 'BillingTable===> ', @BillingTable

SELECT @PlanOccurance = intplanoccurr FROM CPMAccounts CPM WITH (NOLOCK) WHERE CPM.acctId = @CPM

SELECT 'PlanOccurance===> ', @PlanOccurance

SELECT @InterestPlan =	CASE
							WHEN @PlanOccurance = 1 THEN ccinhparent111AID
							WHEN @PlanOccurance = 2 THEN ccinhparent112AID
							WHEN @PlanOccurance = 3 THEN ccinhparent113AID
							WHEN @PlanOccurance = 4 THEN ccinhparent114AID
							ELSE 0
						END
FROM BillingTableAccounts WITH (NOLOCK) WHERE acctId = @BillingTable

SELECT 'InterestPlan===> ', @InterestPlan


SELECT CL.LutDescription InterestType, IA.FixedRate1, Variance1, VarInterestRate, 
CASE WHEN IA.IntRateType = 0 THEN IA.FixedRate1 ELSE Variance1 + VarInterestRate END TotalInterest 
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))
WHERE IA.acctId = @InterestPlan