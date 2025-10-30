-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 1.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.98, CycleDueDTD = 1 WHERE CPSAcctID = 566406 AND BusinessDay >= '2020-05-01 23:59:57'
	-- 4 rows update
	
	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-04-30 00:00:00' WHERE BSAcctid = 1150358 AND BusinessDay = '2020-05-04 23:59:57.000'
	-- 1 row update

	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-04-30 00:00:00' WHERE BSAcctid = 4680519 AND BusinessDay = '2020-05-04 23:59:57.000'
	-- 1 row update

	--UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 943160 AND Businessday = '2020-05-04 23:59:57.000'
	---- 1 rows update

	--UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 2047305 AND Businessday = '2020-05-04 23:59:57.000'
	---- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, * 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 566406 AND BusinessDay >= '2020-05-01 23:59:57'
order by businessday desc

SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 660076 AND Businessday >= '2020-03-31 23:59:55.000'  AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 774627 AND Businessday >= '2020-03-31 23:59:55.000'  AND ManualInitialChargeOffReason = '0' 

*/