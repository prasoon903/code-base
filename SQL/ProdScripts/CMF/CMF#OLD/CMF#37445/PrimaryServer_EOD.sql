-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE 
	BSacctid IN (411784,822659,2567348,3206212,660076,774627,2526050) AND Businessday = '2020-05-05 23:59:57.000'
	-- 7 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT SystemStatus,ManualInitialChargeOffReason,* 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (411784,822659,2567348,3206212,660076,774627,2526050) AND 
Businessday = '2020-05-05 23:59:57.000'  
AND ManualInitialChargeOffReason = '0'

SELECT SystemStatus,ManualInitialChargeOffReason,* 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (774627) AND 
Businessday >= '2020-05-01 23:59:57.000'  
--AND ManualInitialChargeOffReason = '0'

*/