BEGIN TRAN
--COMMIT
--ROLLBACK

DELETE FROM CurrentBalanceAudit WHERE AID = 2653475 AND ATID = 51 AND IdentityField = 6650989241

--UPDATE AI 
--SET CurrentBalanceCo = S.CurrentBalanceCo
--FROM AccountInfoForreport AI 
--JOIN StatementHeader S WITH (NOLOCK) ON (S.acctID = AI.BSAcctID AND S.StatementDate = AI.BusinessDay)
--WHERE S.StatementDate = '2024-02-29 23:59:57.000'
--AND BSAcctID IN (12124190)