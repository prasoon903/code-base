-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.47, CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 4.47, 
	RemainingMinimumDue = RemainingMinimumDue - 4.47, RunningMinimumDue = RunningMinimumDue - 4.47 WHERE 
	BSacctid = 4301354 AND Businessday >= '2020-05-29 23:59:57.000'
	-- 2 rows update

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 18.17, AmountOfTotalDue = AmountOfTotalDue + 18.17, 
	RemainingMinimumDue = RemainingMinimumDue + 18.17, RunningMinimumDue = RunningMinimumDue + 18.17 WHERE 
	BSacctid = 3791584 AND Businessday >= '2020-05-29 23:59:57.000'
	-- 2 rows update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 8.42, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.42 WHERE 
	CPSAcctID = 4711734 AND BusinessDay >= '2020-05-29 23:59:57'
	-- 2 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayCurrDue, RemainingMinimumDue, RemainingMinimumDue
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (4301354) AND 
Businessday = '2020-05-30 23:59:57.000' 

*/