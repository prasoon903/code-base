-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
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
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (918954) AND 
Businessday = '2020-05-06 23:59:57.000'  
AND ManualInitialChargeOffReason = '0'

SELECT AmtOfPayCurrDue, CycleDueDTD, AmtOfPayXDLate
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (4680519) AND 
Businessday = '2020-05-06 23:59:57.000' 

*/