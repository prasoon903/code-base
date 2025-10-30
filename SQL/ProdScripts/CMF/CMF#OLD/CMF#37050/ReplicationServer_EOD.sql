-- TO BE RUN ON REPLICATION SERVER ONLY
USE CCGS_RPT_CoreIssue
GO

BEGIN TRAN 

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.37, RunningMinimumDue = RunningMinimumDue - 0.37, RemainingMinimumDue = RemainingMinimumDue - 0.37, 
			AmtofpayCurrDue = AmtofpayCurrDue - 0.37, CycleDueDTD = 0 WHERE BSAcctid = 2518807 AND BusinessDay >= '2020-04-14 23:59:57'
	-- 10 row update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.37, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.37, CycleDueDTD = 0 WHERE CPSAcctID = 6239664 AND BusinessDay >= '2020-04-14 23:59:57'
	-- 10 row update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, RunningMinimumDue, RemainingMinimumDue, daysdelinquent, SystemStatus, CCInhParent125AID,AmountOfPayment60DLate 
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BSAcctid = 2518807 AND BusinessDay >= '2020-04-14 23:59:57'
order by businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 6239664 AND BusinessDay >= '2020-04-14 23:59:57'
order by businessday desc

*/