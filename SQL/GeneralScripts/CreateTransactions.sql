INSERT INTO CreateNewSingleTransactionData
(TxnAcctId, CMTTranType, TransactionAmount, ActualTrancode, AccountNumber, TxnSource, creditplanmaster, RMATranUUID)
VALUES
(14551526, '16', 10, '1601', '1100001000001599', '2', 13768, NULL),
(14551526, '48', 100, 'F4804', '1100001000001599', '2', 13776, '82d07b3c-9e91-44b9-b771-9ae04a199bf9'),
(14551526, '49', 110, '4901', '1100001000001599', '2', 13744, NULL)

--INSERT INTO CreateNewSingleTransactionData
--(TxnAcctId, CMTTranType, TransactionAmount, ActualTrancode, AccountNumber, TxnSource, creditplanmaster, RMATranUUID)
--VALUES
--(14551526, '48', 100, 'F4804', '1100001000001599', '2', 13776, '82d07b3c-9e91-44b9-b771-9ae04a199bf9')

--INSERT INTO CreateNewSingleTransactionData
--(TxnAcctId, CMTTranType, TransactionAmount, ActualTrancode, AccountNumber, TxnSource, creditplanmaster, RMATranUUID)
--VALUES
--(14551526, '49', 110, '4901', '1100001000001599', '2', 13744, NULL)

EXEC USP_CreateNewSingleTransactionData 53, 6969, 3

EXEC USP_CreateNewSingleTransaction
UPDATE CCard_Secondary SET InvoiceNumber = '18020613092097464' WHERE TranId = 56321491834175491

SELECT TranID, * FROM CreateNewSingleTransactionData

--TRUNCATE TABLE CreateNewSingleTransactionData


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId > 0