-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO



SELECT CycleDueDTD, AmtOfPayCurrDue, AmountOfTotalDue, RunningMinimumDue FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctId = 11208697 AND BusinessDay = '2020-11-03 23:59:57'
