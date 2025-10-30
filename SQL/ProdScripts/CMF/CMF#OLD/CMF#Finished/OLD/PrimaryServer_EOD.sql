-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.10, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.10, SystemStatus = 2, RemainingMinimumDue = RemainingMinimumDue + 2.10 WHERE 
	BSacctid = 1148046 AND Businessday = '2020-06-07 23:59:57.000'
	-- 1 rows update

	UPDATE PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.10, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.10 WHERE 
	CPSAcctID = 1160466 AND BusinessDay = '2020-06-07 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 25, SystemStatus = 2 WHERE 
	BSacctid = 1150358 AND Businessday = '2020-06-07 23:59:57.000'
	-- 1 rows update

	UPDATE PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE 
	CPSAcctID = 1162778 AND BusinessDay = '2020-06-07 23:59:57.000'
	-- 1 rows update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 10.33, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.33 WHERE 
	CPSAcctID = 2694105 AND BusinessDay = '2020-06-07 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayCurrDue, RemainingMinimumDue, RemainingMinimumDue
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (4301354) AND 
Businessday = '2020-05-30 23:59:57.000' 

*/