
--DROP TABLE IF EXISTS TransactionCreationTempData
--CREATE TABLE TransactionCreationTempData (SN INT IDENTITY(1, 1), TxnAcctId INT, AccountNumber VARCHAR(19), TransactionAmount MONEY, CMTTranType VARCHAR(10), ActualTranCode VARCHAR(20), TranTime DATETIME, JobStatus INT DEFAULT(0))

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (1886573, '1100011137677625', 6.7, '49', '4907', '2022-07-03 00:00:00.000')
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2174792, '1100011137677625', 25.15, '49', '4907', '2022-07-02 00:00:00.000')
