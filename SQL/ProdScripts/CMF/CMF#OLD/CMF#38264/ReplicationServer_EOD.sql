-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 13.64, CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 13.64, SystemStatus = 2 WHERE 
	BSacctid = 4680519 AND Businessday = '2020-05-26 23:59:57.000'
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayXDLate, SystemStatus
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (4680519) AND 
Businessday = '2020-05-26 23:59:57.000' 

*/