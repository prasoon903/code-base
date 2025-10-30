-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
GO

BEGIN TRAN

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 24.45, AmtOfPayCurrDue = AmtOfPayCurrDue - 24.45, CycleDueDTD = 0 WHERE 
	CPSAcctID = 752378 AND BusinessDay = '2020-06-09 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayCurrDue
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 752378 AND BusinessDay = '2020-06-09 23:59:57.000' 

*/