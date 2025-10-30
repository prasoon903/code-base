BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

INSERT INTO CBRStatementOverride (acctID, StatementDate, SystemStatus)
SELECT acctID, StatementDate, SystemStatus FROM StatementHeader WITH (NOLOCK) WHERE acctID = 16996133 AND SystemStatus = 14

--2 rows