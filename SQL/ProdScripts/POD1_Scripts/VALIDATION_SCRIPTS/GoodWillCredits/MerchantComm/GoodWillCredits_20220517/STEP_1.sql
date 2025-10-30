-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (12269374, '1100011151855222', 19.95, '49', '4907', '2020-10-31 05:51:39')
INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2370919, '1100011123652285', 52.99, '49', '4907', '2020-11-06 20:43:52')
INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (627051, '1100011106229242', 85.46, '49', '4907', '2021-07-31 12:54:44')
INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2370919, '1100011123652285', 20.98, '49', '4907', '2021-08-15 22:08:00')
INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (19345401, '1100011188965747', 66.71, '49', '4907', '2021-09-13 13:02:27')