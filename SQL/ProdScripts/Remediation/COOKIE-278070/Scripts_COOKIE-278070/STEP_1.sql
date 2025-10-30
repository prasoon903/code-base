
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 425888, '1100011104217017', 11.00, '50', '5001', 'd4e3743b-34c7-4b43-8169-5f8cb4f36ac0')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 1111603, '1100011111076463', 347.84, '50', '5001', '4e10bbcd-bf97-4d22-abcd-44d40f8b2095')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 1233023, '1100011112292465', 271.39, '50', '5001', '7711bc70-334e-4974-8869-aab06aad6a25')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 2028728, '1100011120207265', 1685.99, '50', '5001', '639b9f0f-1e03-4aed-bf4d-3b91eb0a5976')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 2263879, '1100011122395290', 115.94, '50', '5001', '13212c4c-af05-4dfd-9d67-662e46b414fb')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 3623439, '1100011131998670', 103.49, '50', '5001', '94816896-91c4-4b3e-859e-e1b1333e7b6d')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 3866943, '1100011132550710', 1700.00, '50', '5001', 'c62f5d89-3ac8-4bf6-8062-092014a586a4')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 3877599, '1100011132663273', 299.82, '50', '5001', '099537e6-df19-4fdf-a78f-3fd5618a234b')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 3960640, '1100011132823687', 51.99, '50', '5001', '4f3ddd4c-c676-41ab-b4f3-4a4a3f13c6a6')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 4364241, '1100011134598691', 177.58, '50', '5001', '28448d7c-9557-47b6-b184-0e0a2cf2e1ba')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 4671746, '1100011135820748', 5050.51, '50', '5001', '10fdbee6-8551-4a39-a752-3824a4750e48')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 11495776, '1100011149152443', 36.75, '50', '5001', '37b2cc44-d9db-492f-ad91-cd7ff2ce4f57')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 11928400, '1100011150743023', 257.13, '50', '5001', '9e7d3bfb-3c8d-46ac-8453-dd8cbe1e00f7')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 13712378, '1100011161968254', 230.35, '50', '5001', 'fb9b36f7-f760-4788-9a4f-de321bcf34d4')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 17724024, '1100011178833624', 46.32, '50', '5001', 'f561c0b9-6879-4a51-bc2d-1d411c92b3de')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 18237416, '1100011182565840', 247.95, '50', '5001', 'e6bafffb-be44-4cd8-a682-cd4e3eb5ab73')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 18522603, '1100011185106485', 76.10, '50', '5001', '6a91b9a0-032d-438d-9082-d36f740351ed')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 20426104, '1100011194555029', 30.13, '50', '5001', '1d2ed53c-b384-4bcc-9685-5ab904c7fd2b')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID)    VALUES ('COOKIE-278070', 21808232, '1100011204890481', 56.88, '50', '5001', 'a79c03a6-1268-49e3-872d-3485c55a8d1e')