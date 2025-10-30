-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE CreateNewSingleTransactionData SET TransactionStatus = -98 WHERE TransactionStatus = 1 AND TranID IS NULL

--SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK) WHERE TransactionStatus = 1 AND TranID IS NULL 


