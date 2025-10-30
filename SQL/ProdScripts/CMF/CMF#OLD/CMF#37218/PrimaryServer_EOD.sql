-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN 
		
	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-02-29 00:00:00' WHERE BSAcctid = 1212683 AND BusinessDay >= '2020-04-28 23:59:57.000'
	-- 2 row update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, RunningMinimumDue, RemainingMinimumDue, daysdelinquent, SystemStatus, CCInhParent125AID,AmountOfPayment60DLate 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSAcctid = 2658517 AND BusinessDay >= '2020-04-14 23:59:57'
order by businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 12784488 AND BusinessDay >= '2020-04-14 23:59:57'
order by businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, RunningMinimumDue, RemainingMinimumDue, daysdelinquent, SystemStatus, CCInhParent125AID,DateOfDelinquency 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BSAcctid = 4078987 AND BusinessDay >= '2020-04-25 23:59:57.000' AND BusinessDay <= '2020-04-27 23:59:57.000'
order by businessday desc

*/