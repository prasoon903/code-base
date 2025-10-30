-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN 

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 23.64, AmtofpayCurrDue = AmtofpayCurrDue - 23.64, CycleDueDTD = 0 WHERE BSAcctid = 790482 AND BusinessDay = '2020-04-27 23:59:57.000'
	-- 1 row update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 23.64, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.64, CycleDueDTD = 0 WHERE CPSAcctID = 802892 AND BusinessDay = '2020-04-27 23:59:57.000'
	-- 1 row update

	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-02-29 00:00:00' WHERE BSAcctid = 1185600 AND BusinessDay = '2020-04-27 23:59:57.000'
	-- 1 row update
		
	UPDATE AccountInfoForReport SET DateOfDelinquency = NULL WHERE BSAcctid = 1212683 AND BusinessDay >= '2020-04-26 23:59:57.000'
	-- 2 row update

	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-02-29 00:00:00' WHERE BSAcctid = 1218755 AND BusinessDay = '2020-04-27 23:59:57.000'
	-- 1 row update

	UPDATE AccountInfoForReport SET DateOfDelinquency = '2020-02-29 00:00:00' WHERE BSAcctid = 3866773 AND BusinessDay >= '2020-04-21 23:59:57.000'
	-- 7 row update

	UPDATE AccountInfoForReport SET DateOfDelinquency = NULL WHERE BSAcctid = 4078987 AND BusinessDay >= '2020-04-25 23:59:57.000' AND BusinessDay <= '2020-04-27 23:59:57.000'
	-- 3 row update

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 2.25, RunningMinimumDue = RunningMinimumDue - 2.25, RemainingMinimumDue = RemainingMinimumDue - 2.25, 
			AmtofpayCurrDue = AmtofpayCurrDue - 2.25, CycleDueDTD = 0 WHERE BSAcctid = 540227 AND BusinessDay = '2020-04-27 23:59:57'
	-- 1 row update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 2.25, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.25, CycleDueDTD = 0 WHERE CPSAcctID = 2477564 AND BusinessDay = '2020-04-27 23:59:57'
	-- 1 row update

	UPDATE AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.40, RunningMinimumDue = RunningMinimumDue - 0.40, RemainingMinimumDue = RemainingMinimumDue - 0.40, 
			AmtofpayCurrDue = AmtofpayCurrDue - 0.40, CycleDueDTD = 0 WHERE BSAcctid = 2658517 AND BusinessDay >= '2020-04-17 23:59:57'
	-- 11 row update

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.40, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.40, CycleDueDTD = 0 WHERE CPSAcctID = 12784488 AND BusinessDay >= '2020-04-17 23:59:57'
	-- 11 row update

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