-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 25, SystemStatus = 2 WHERE 
	BSacctid = 2153560 AND Businessday = '2020-05-14 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmtOfPayCurrDue, CycleDueDTD, AmtOfPayXDLate, SystemStatus
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (2153560) AND 
Businessday = '2020-05-14 23:59:57.000' 

*/