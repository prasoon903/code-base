-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 2.59 WHERE acctId = 14715 AND StatementID = 103864609
UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.30 WHERE acctId = 15984 AND StatementID = 103674638
UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.34 WHERE acctId = 56291 AND StatementID = 103665056
UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE acctId = 16587 AND StatementID = 103624673
UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue - 42.88, AmountOfTotalDue = AmountOfTotalDue - 42.88, AmtOfPayXDLate = AmtOfPayXDLate - 42.88,
AmtOfPayPastDue = AmtOfPayPastDue - 42.88, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 122810 AND StatementID = 103905657
UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.69 WHERE acctId = 120236 AND StatementID = 103885350

UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 52.30, AmtOfPayXDLate = AmtOfPayXDLate - 26.15, AmountOfPayment30DLate = AmountOfPayment30DLate - 26.15, 
AmtOfPayPastDue = AmtOfPayPastDue - 52.30, SRBWithInstallmentDue = SRBWithInstallmentDue - 52.30, SBWithInstallmentDue = SBWithInstallmentDue - 52.30, 
CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 417786 AND StatementID = 103690220

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 7.78 WHERE acctId = 430006 AND StatementID = 103690220

UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue - 172.89, AmountOfTotalDue = AmountOfTotalDue - 172.89, AmtOfPayCurrDue = AmtOfPayCurrDue + 52.02, 
AmtOfPayXDLate = AmtOfPayXDLate - 224.91, AmtOfPayPastDue = AmtOfPayPastDue - 224.91, SRBWithInstallmentDue = SRBWithInstallmentDue - 224.91, 
SBWithInstallmentDue = SBWithInstallmentDue - 224.91, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 1845697 AND StatementID = 105286088