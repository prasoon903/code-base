-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

--Extra Purge while Transaction is posted - 
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42818218634 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42817442495 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42817442524 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42817443149 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42817443171 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42817443193 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42843647267 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42847971180 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42847971937 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42861741907 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42861804609 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42862690640 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42862690794 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42866390493 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42895852748 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42897899396 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42897899407 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42982036840 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225467 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225484 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225501 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225832 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225846 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43030225860 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43056229262 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43056322352 AND ArTxnType = '93'

--Purge Created For dispute Txns
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 38698484800 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42485413675 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42705603960 AND ArTxnType = '93'
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 42938498004 AND ArTxnType = '93'

--Extra Mini To be excluded
UPDATE TOP(1) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 43146508667