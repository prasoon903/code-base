
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-253203', 1687407, '1100011116904701', 7.01, '49', '4907')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-253203', 166442, '1100011101622755', 0.33, '21', '2118')


--SELECT TransactionAmount, TransactionDescription, AccountNumber,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 89096187868
--SELECT TransactionAmount, TransactionDescription, AccountNumber,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 89096280776