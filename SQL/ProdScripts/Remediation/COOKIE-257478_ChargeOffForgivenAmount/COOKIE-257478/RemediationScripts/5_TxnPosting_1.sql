
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (TxnAcctID, AccountNumber, CMTTranType, ActualTranCode, TransactionAmount, JiraID)
SELECT acctID, AccountNumber, '49', '4933', ForgivenAmount, 'COOKIE-257478' FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK) WHERE JobStatus = 0