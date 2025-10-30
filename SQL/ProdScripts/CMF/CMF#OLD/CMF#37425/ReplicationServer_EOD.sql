-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
GO

BEGIN TRAN

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.98, CycleDueDTD = 1 WHERE CPSAcctID = 566406 AND BusinessDay >= '2020-05-01 23:59:57'
	-- 4 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, * 
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 566406 AND BusinessDay >= '2020-05-01 23:59:57'
order by businessday desc


*/