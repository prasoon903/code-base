-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
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
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 752378 AND BusinessDay = '2020-06-09 23:59:57.000' 

*/