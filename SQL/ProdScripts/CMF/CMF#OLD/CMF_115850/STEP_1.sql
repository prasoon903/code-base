
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-275535', 1256833, '1100011112531466', 263.70, '49', '4933')


--SELECT AccountNumber, UniversalUniqueID,* FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = 1256833
