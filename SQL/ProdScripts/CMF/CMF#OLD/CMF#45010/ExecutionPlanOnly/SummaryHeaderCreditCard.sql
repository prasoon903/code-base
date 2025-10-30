-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


SELECT SBWithInstallmentDue, SRBWithInstallmentDue FROM SummaryHeaderCreditCard WITH (NOLOCK) WHERE acctId = 21938790 AND StatementID = 44219848

	