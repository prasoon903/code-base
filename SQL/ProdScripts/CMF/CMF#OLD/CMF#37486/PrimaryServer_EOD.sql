-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET ManualInitialChargeOffReason = '6' WHERE 
	BSacctid IN (918954) AND Businessday = '2020-05-06 23:59:57.000'
	-- 1 rows update

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 13.64, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 13.64, SystemStatus = 2 WHERE 
	BSacctid = 4680519 AND Businessday = '2020-05-06 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT SystemStatus,ManualInitialChargeOffReason,* 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (918954) AND 
Businessday = '2020-05-06 23:59:57.000'  
AND ManualInitialChargeOffReason = '0'

SELECT AmtOfPayCurrDue, CycleDueDTD, AmtOfPayXDLate
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (4680519) AND 
Businessday = '2020-05-06 23:59:57.000' 

*/