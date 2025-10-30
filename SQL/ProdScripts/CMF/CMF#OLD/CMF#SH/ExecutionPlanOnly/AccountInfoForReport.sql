-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO



SELECT CycleDueDTD, AmtOfPayCurrDue, AmountOfTotalDue, RunningMinimumDue FROM AccountInfoForReport WITH (NOLOCK) WHERE BSacctId = 8171272 AND Businessday = '2020-10-31 23:59:57.000'
