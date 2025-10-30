

---------------------------- TO BE EXECUTED ON THE PRIMARY SERVER -------------------------------


BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) StatementHeaderEX SET DateAcctClosed = NULL WHERE AcctID = 16927854 AND StatementDate = '2025-01-31 23:59:57'


---------------------------- TO BE EXECUTED ON THE REPLICATION SERVER -------------------------------



BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) AccountInfoForReport SET DateAcctClosed = NULL WHERE BSAcctID = 16927854 AND Businessday = '2025-01-31 23:59:57'
UPDATE TOP(1) StatementHeaderEX SET DateAcctClosed = NULL WHERE AcctID = 16927854 AND StatementDate = '2025-01-31 23:59:57'




--SELECT DateAcctClosed FROM StatementHeaderEX WITH (NOLOCK) WHERE AcctID = 16927854 AND StatementDate = '2025-01-31 23:59:57'

--SELECT DateAcctClosed FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID = 16927854 AND Businessday = '2025-01-31 23:59:57'



-- VALIDATION

--SELECT DateAcctClosed, ccinhparent125AID, HostMachineName, * 
--FROM StatementHeader SH WITh (NOLOCK)
--JOIN StatementHeaderEX SE WITH (NOLOCK)  ON (SH.acctId = SE.acctID AND SH.StatementDate = SE.StatementDate)
--WHERE SH.acctID = 16927854 AND SE.StatementDate = '2025-01-31 23:59:57'

--SELECT StatusDescription, CBRStatusGroup,* FROM AstatusAccounts WITH (NOLOCK) WHERE acctID = 16010
--SELECT ccinhparent125AID,* FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = 16927854
--SELECT * FROM BSegment_MStatuses WITH (NOLOCK) WHERE acctID = 16927854 