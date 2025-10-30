-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 7, AmtOfPayCurrDue = AmtOfPayCurrDue - 7, CycleDueDTD = 0, 
	RemainingMinimumDue = RemainingMinimumDue - 7, RunningMinimumDue = RunningMinimumDue - 7 WHERE 
	BSacctid = 1559332 AND Businessday = '2020-06-26 23:59:57.000'
	-- 1 rows update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 7, AmtOfPayCurrDue = AmtOfPayCurrDue - 7, CycleDueDTD = 0 WHERE 
	CPSAcctID = 1571752 AND BusinessDay = '2020-06-26 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayCurrDue, RemainingMinimumDue, RemainingMinimumDue
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (1559332) AND 
Businessday = '2020-06-26 23:59:57.000' 

*/