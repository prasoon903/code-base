BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE T
SET PendingOTB = S.PendingOTB
FROM AccountInfoForReport T 
JOIN StatementHeaderEX S WITH (NOLOCK) ON (T.BSAcctID = S.acctID AND T.BusinessDay = S.StatementDate)
WHERE T.BusinessDay = '2025-04-30 23:59:57'
AND T.PendingOTB <> S.PendingOTB


/*
SELECT COUNT(1)
FROM AccountInfoForReport T WITH (NOLOCK)
JOIN StatementHeaderEX S WITH (NOLOCK) ON (T.BSAcctID = S.acctID AND T.BusinessDay = S.StatementDate)
WHERE T.BusinessDay = '2025-04-30 23:59:57'
AND T.PendingOTB <> S.PendingOTB
*/