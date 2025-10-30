
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-280313', 2263879, '1100011122395290', 328.94, '49', '4933', '13212c4c-af05-4dfd-9d67-662e46b414fb')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-280313', 3877599, '1100011132663273', 1526.18, '49', '4933', '099537e6-df19-4fdf-a78f-3fd5618a234b')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-280313', 18237416, '1100011182565840', 291.11, '49', '4933', 'e6bafffb-be44-4cd8-a682-cd4e3eb5ab73')