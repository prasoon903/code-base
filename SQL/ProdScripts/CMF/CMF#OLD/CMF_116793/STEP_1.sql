
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION



INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-278653', 16839297, '1100011172299855', 1373.17, '49', '4933')
