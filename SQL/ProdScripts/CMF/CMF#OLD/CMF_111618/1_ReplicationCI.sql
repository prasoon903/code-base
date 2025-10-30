BEGIN TRAN
--COMMIT
--ROLLBACK

--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 1473.35 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 2014976
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 4954.57 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 2123276
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 3412.37 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 11089688
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 5262.21 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 11523152
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 913.40 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 18213265
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 0.00 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 21160568
--UPDATE TOP(1) AccountInfoForReport SET currentbalanceco = 1836.52 WHERE businessday = '2024-02-29 23:59:57' AND BSAcctID = 21169802

UPDATE AI 
SET CurrentBalanceCo = S.CurrentBalanceCo
FROM AccountInfoForreport AI 
JOIN StatementHeader S WITH (NOLOCK) ON (S.acctID = AI.BSAcctID AND S.StatementDate = AI.BusinessDay)
WHERE S.StatementDate = '2024-02-29 23:59:57.000'
AND BSAcctID IN (4343404, 21861440, 13599521, 1208076, 21589262, 21406215, 1195225, 121124190, 11944256, 9046258, 11115208, 21847757)