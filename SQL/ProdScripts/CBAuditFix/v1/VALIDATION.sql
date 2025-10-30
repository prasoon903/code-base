SELECT * FROM ##TempCBA WHERE EODStatus <> 16

SELECT JobStatus, COUNT(1) FROM ##TempCBA GROUP BY JobStatus

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 1047088 AND DENAME = 114 ORDER BY BusinessDay DESC, IdentityField DESC

SELECT StatusDescription,* FROM AStatusAccounts WITH (NOLOCK) WHERE parent01AID IN (16040, 16044, 16104) 

SELECT SystemStatus, ccinhparent125AID,* FROM AccountInfoForReport_NCPartitioned WITH (NOLOCK) WHERE BSAcctID = 1047088 AND BusinessDAy = '2019-08-10 23:59:57'
SELECT SystemStatus, ccinhparent125AID,* FROM BSegment_Primary WITH (NOLOCK) WHERE AcctID = 1047088 

SELECT SystemStatus, ccinhparent125AID,* FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID = 1047088 AND BusinessDay = '2019-08-10 23:59:57'

SELECT * FROM sys.tables where name like '%AccountInfoForReport%'


SELECT C.*
--INTO ##CurrentBalanceAudit
FROM CurrentBalanceAudit C
JOIN ##TempCBA T ON (C.AID = T.acctId AND C.ATID = 51 AND C.DENAME = 114)
WHERE T.JobStatus = 1


SELECT C.*
FROM ##CurrentBalanceAudit C
JOIN ##TempCBA T ON (C.AID = T.acctId AND C.ATID = 51 AND C.IdentityField = T.IdentityField)
WHERE T.JobStatus = 1