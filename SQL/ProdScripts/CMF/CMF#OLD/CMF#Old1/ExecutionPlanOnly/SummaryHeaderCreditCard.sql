-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


SELECT SBWithInstallmentDue, SRBWithInstallmentDue FROM SummaryHeaderCreditCard WITH (NOLOCK) WHERE acctId = 23782402 AND StatementID = 43534156

	