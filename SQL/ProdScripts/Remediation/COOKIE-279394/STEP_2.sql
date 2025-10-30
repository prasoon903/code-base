DECLARE @BatchCount INT = 20

DROP TABLE IF EXISTS #Batch
CREATE TABLE #Batch (SN INT, TxnAcctId INT, AccountNumber VARCHAR(19), TransactionAmount MONEY, CMTTranType VARCHAR(10), ActualTranCode VARCHAR(20), TranTime DATETIME, JobStatus INT, RevTgt DECIMAL(19,0), JiraId VARCHAR(20), ClientID VARCHAR(64))

BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO #Batch (SN, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime, JobStatus, RevTgt, JiraId, ClientID)
		SELECT TOP(@BatchCount) SN, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime, JobStatus, RevTgt, JiraId, ClientID
		FROM TransactionCreationTempData
		WHERE JobStatus = 0
		ORDER BY TranTime

		INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime, RevTgt, Reason, ClientID)
		SELECT TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime, RevTgt, JiraId, ClientID
		FROM #Batch

		UPDATE C
		SET JobStatus = 1
		FROM TransactionCreationTempData C
		JOIN #Batch B ON (B.SN = C.SN)

		DROP TABLE IF EXISTS #Batch
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION 
		SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
		RAISERROR('ERROR OCCURED :-', 16, 1);
END CATCH