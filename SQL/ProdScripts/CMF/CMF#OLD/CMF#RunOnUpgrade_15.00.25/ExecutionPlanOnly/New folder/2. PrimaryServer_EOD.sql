-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- 1 row UPDATE TOP(1) each statement unless specified

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.5, AmountOfTotalDue = AmountOfTotalDue - 7.5, RunningMinimumDue = RunningMinimumDue - 7.5,
RemainingMinimumDue = RemainingMinimumDue - 7.5 WHERE BSacctId = 7912164 AND BusinessDay = '2020-12-02 23:59:57.000'


--UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 6.82, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.82 WHERE 
--CPSacctId = 14687714 AND BusinessDay = '2020-12-01 23:59:57.000'


--UPDATE AccountInfoForReport SET SystemStatus = 2, CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25, RunningMinimumDue = RunningMinimumDue - 25,
--RemainingMinimumDue = RemainingMinimumDue - 25, DateOfDelinquency = NULL WHERE BSacctId = 3771532 AND BusinessDay >= '2020-11-30 23:59:57.000'

--UPDATE PlanInfoForReport SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 24.24 WHERE 
--CPSacctId = 4691682 AND BusinessDay >= '2020-11-30 23:59:57.000'

--UPDATE PlanInfoForReport SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 0.76 WHERE 
--CPSacctId = 11030594 AND BusinessDay >= '2020-11-30 23:59:57.000'

