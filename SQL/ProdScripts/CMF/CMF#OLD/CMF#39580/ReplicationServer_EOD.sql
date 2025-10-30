-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
GO

BEGIN TRAN

	UPDATE AccountInfoForReport Set AmtOfPayCurrDue = AmtOfPayCurrDue - 44, CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 44 Where 
	bsacctid = 612607  and  BusinessDay ='2020-07-01 23:59:57.000' 

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION 
/*

SELECT AmountOfTotalDue, CycleDueDTD, AmtOfPayCurrDue, SystemStatus
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BSacctid IN (612607) AND 
Businessday = '2020-07-01 23:59:57.000' 

*/