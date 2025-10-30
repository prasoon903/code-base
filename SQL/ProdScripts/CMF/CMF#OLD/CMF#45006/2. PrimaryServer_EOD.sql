-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 39.02, AmtOfPayXDLate = AmtOfPayXDLate - 39.02 WHERE 
	BSacctId = 11208697 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 1097.58, AmtOfPayCurrDue = AmtOfPayCurrDue - 1097.58, SBWithInstallmentDue = SBWithInstallmentDue - 1097.58, 
	SRBWithInstallmentDue = SRBWithInstallmentDue - 1097.58 WHERE 
	CPSacctId = 33148313 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 6.71, AmtOfPayXDLate = AmtOfPayXDLate - 6.71 WHERE 
	CPSacctId = 23544712 AND Businessday = '2020-10-31 23:59:57.000'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.03, AmtOfPayXDLate = AmtOfPayXDLate - 8.06 WHERE 
	CPSacctId = 27151925 AND Businessday = '2020-10-31 23:59:57.000'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT CycleDueDTD, SystemStatus, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM AccountInfoForReport WITH (NOLOCK)
--WHERE BSacctId = 11208697 AND BusinessDay = '2020-10-31 23:59:57'

--SELECT CycleDueDTD, CurrentBalance, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 34229361 AND BusinessDay = '2020-10-31 23:59:57'