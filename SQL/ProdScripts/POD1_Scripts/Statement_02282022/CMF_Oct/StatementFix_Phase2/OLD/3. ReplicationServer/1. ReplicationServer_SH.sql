-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 64.72 WHERE acctId = 68406221 AND StatementID = 109961293



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue - 4.2, MinimumPaymentDue = MinimumPaymentDue - 4.2, AmtOfPayCurrDue = AmtOfPayCurrDue + 37.42, AmtOfPayXDLate = AmtOfPayXDLate - 41.62,
AmtOfPayPastDue = AmtOfPayPastDue - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue - 37.54, 
SBWithInstallmentDue = SBWithInstallmentDue - 37.54, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 20591141 AND StatementID = 109881012

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66820565 AND StatementID = 109881012
