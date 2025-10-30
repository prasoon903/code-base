-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


SELECT SRBWithInstallmentDue, AmtOfPayCurrDue FROM StatementHeader WITH (NOLOCK) WHERE acctId = 8171272 AND StatementDate = '2020-10-31 23:59:57.000'

	