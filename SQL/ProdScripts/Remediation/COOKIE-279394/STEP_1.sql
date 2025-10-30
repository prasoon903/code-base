
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 425888, '1100011104217017', 11.00, '49', '4933', 'd4e3743b-34c7-4b43-8169-5f8cb4f36ac0')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 1111603, '1100011111076463', 347.84, '49', '4933', '4e10bbcd-bf97-4d22-abcd-44d40f8b2095')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 1233023, '1100011112292465', 271.39, '49', '4933', '7711bc70-334e-4974-8869-aab06aad6a25')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 2028728, '1100011120207265', 1685.99, '49', '4933', '639b9f0f-1e03-4aed-bf4d-3b91eb0a5976')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 3623439, '1100011131998670', 103.49, '49', '4933', '94816896-91c4-4b3e-859e-e1b1333e7b6d')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 3866943, '1100011132550710', 1700.00, '49', '4933', 'c62f5d89-3ac8-4bf6-8062-092014a586a4')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 3960640, '1100011132823687', 48.01, '49', '4933', '4f3ddd4c-c676-41ab-b4f3-4a4a3f13c6a6')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 4364241, '1100011134598691', 177.58, '49', '4933', '28448d7c-9557-47b6-b184-0e0a2cf2e1ba')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 4671746, '1100011135820748', 5050.51, '49', '4933', '10fdbee6-8551-4a39-a752-3824a4750e48')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 11495776, '1100011149152443', 36.75, '49', '4933', '37b2cc44-d9db-492f-ad91-cd7ff2ce4f57')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 11928400, '1100011150743023', 257.13, '49', '4933', '9e7d3bfb-3c8d-46ac-8453-dd8cbe1e00f7')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 13712378, '1100011161968254', 100.00, '49', '4933', 'fb9b36f7-f760-4788-9a4f-de321bcf34d4')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 17724024, '1100011178833624', 46.32, '49', '4933', 'f561c0b9-6879-4a51-bc2d-1d411c92b3de')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 18522603, '1100011185106485', 76.10, '49', '4933', '6a91b9a0-032d-438d-9082-d36f740351ed')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-279394', 20426104, '1100011194555029', 30.13, '49', '4933', '1d2ed53c-b384-4bcc-9685-5ab904c7fd2b')