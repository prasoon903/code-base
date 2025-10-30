
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)   VALUES ('COOKIE-253203', 1687407, '1100011116904701', 7.01, '22', '2207', 89096187868)

INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)   VALUES ('COOKIE-253203', 13865157, '1100011162268399',0.60, '22', '2207', 89096280776)
