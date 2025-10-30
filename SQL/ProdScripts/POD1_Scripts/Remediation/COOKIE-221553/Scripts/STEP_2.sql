DECLARE @BatchCount INT = 200

DROP TABLE IF EXISTS #Batch
CREATE TABLE #Batch (SN INT, TxnAcctId INT, AccountNumber VARCHAR(19), TransactionAmount MONEY, CMTTranType VARCHAR(10), ActualTranCode VARCHAR(20), TranTime DATETIME, JobStatus INT)

BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO #Batch
		SELECT TOP(@BatchCount) TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime 
		FROM TransactionCreationTempData
		WHERE JobStatus = 0
		ORDER BY TranTime

		INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime)
		SELECT TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime
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