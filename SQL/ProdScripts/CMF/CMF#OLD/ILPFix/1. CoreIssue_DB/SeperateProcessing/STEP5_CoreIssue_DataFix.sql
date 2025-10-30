BEGIN TRANSACTION
	
	
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-01-31 23:59:57.000' WHERE PlanID = 9161345 AND ActivityOrder = 4  -- Previous: 2022-01-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-03-31 23:59:57.000' WHERE PlanID = 11778559 AND ActivityOrder = 4  -- Previous: 2022-03-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-04-30 23:59:57.000' WHERE PlanID = 12177211 AND ActivityOrder = 4  -- Previous: 2022-04-30 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2021-07-31 23:59:57.000' WHERE PlanID = 22003263 AND ActivityOrder = 1  -- Previous: 2021-07-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-01-31 23:59:57.000' WHERE PlanID = 9161344 AND ActivityOrder = 5  -- Previous: 2022-01-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-01-31 23:59:57.000' WHERE PlanID = 9175370 AND ActivityOrder = 4  -- Previous: 2022-01-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-01-31 23:59:57.000' WHERE PlanID = 9175371 AND ActivityOrder = 4  -- Previous: 2022-01-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-02-28 23:59:57.000' WHERE PlanID = 11111118 AND ActivityOrder = 4  -- Previous: 2022-02-28 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-03-31 23:59:57.000' WHERE PlanID = 11786661 AND ActivityOrder = 4  -- Previous: 2022-03-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-03-31 23:59:57.000' WHERE PlanID = 12886716 AND ActivityOrder = 5  -- Previous: 2022-03-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2022-03-31 23:59:57.000' WHERE PlanID = 12912197 AND ActivityOrder = 3  -- Previous: 2022-03-31 23:59:57.000
	UPDATE ILPScheduleDetailSummary SET LoanEndDate = '2021-01-31 23:59:57.000' WHERE PlanID = 21941006 AND ActivityOrder = 1  -- Previous: 2021-01-31 23:59:57.000

COMMIT 
--ROLLBACK 