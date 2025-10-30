-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, AmtOfPayXDLate = AmtOfPayXDLate - 33.68, 
	AmountOfTotalDue = AmountOfTotalDue - 22.93 WHERE 
	BSacctId = 9747038 AND Businessday = '2020-10-31 23:59:57.000'

	--UPDATE PlanInfoForReport SET SBWithInstallmentDue = SBWithInstallmentDue + 0.69, SRBWithInstallmentDue = SRBWithInstallmentDue + 0.69 WHERE 
	--CPSacctId = 24045196 AND Businessday = '2020-10-31 23:59:57.000'

	
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT CycleDueDTD, SystemStatus, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM AccountInfoForReport WITH (NOLOCK)
--WHERE BSacctId = 9747038 AND BusinessDay = '2020-10-31 23:59:57'

--SELECT CycleDueDTD, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, SBWithInstallmentDue, SRBWithInstallmentDue,* FROM PlanInfoForReport WITH (NOLOCK)
--WHERE CPSacctId = 24045196 AND BusinessDay = '2020-10-31 23:59:57'