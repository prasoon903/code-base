-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 660076 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 774627 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 822659 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 846357 AND Businessday IN ('2020-04-29 23:59:57.000', '2020-04-05 23:59:57.000', '2020-04-07 23:59:57.000')
	-- 3 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 1742844 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 2526050 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 2567348 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE BSacctid = 3206212 AND Businessday = '2020-04-29 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 660076 AND Businessday >= '2020-03-31 23:59:55.000'  AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 774627 AND Businessday >= '2020-03-31 23:59:55.000'  AND ManualInitialChargeOffReason = '0' 
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 822659 AND Businessday >= '2020-03-31 23:59:55.000'	 AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 846357 AND Businessday >= '2020-03-31 23:59:55.000'	 AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 1742844 AND Businessday >= '2020-03-31 23:59:55.000' AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 2526050 AND Businessday >= '2020-03-31 23:59:55.000' AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 2567348 AND Businessday >= '2020-03-31 23:59:55.000' AND ManualInitialChargeOffReason = '0'
SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 3206212 AND Businessday >= '2020-03-31 23:59:55.000' AND ManualInitialChargeOffReason = '0'

*/