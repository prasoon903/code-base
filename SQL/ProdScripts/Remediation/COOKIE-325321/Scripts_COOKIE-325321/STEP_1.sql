
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 339817, '1100011103356402', 0.14, '17', '1701', 140302411756)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 339817, '1100011103356402', 0.20, '17', '1701', 140299888361)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 896405, '1100011108922786', 1.56, '17', '1701', 140296942473)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 19364130, '1100011189324241', 0.50, '17', '1701', 140302282169)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 1969289, '1100011119612970', 3.36, '17', '1701', 140299834080)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 18078265, '1100011182049738', 0.01, '17', '1701', 140299838513)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 14274916, '1100011164686101', 1.60, '17', '1701', 140299494917)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 3544494, '1100011131948204', 13.70, '17', '1701', 140439407152)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 15944573, '1100011169645169', 0.60, '17', '1701', 140306522249)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 5612998, '1100011138841261', 0.91, '17', '1701', 140326759160)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 1954948, '1100011119479263', 32.42, '17', '1701', 140306288462)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 7219611, '1100011140991393', 1.20, '17', '1701', 140306298691)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 1281092, '1100011112774959', 0.49, '17', '1701', 140307221581)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 19633417, '1100011191027741', 12.07, '17', '1701', 140307159945)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 1743769, '1100011117505721', 0.22, '17', '1701', 140299834891)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 2835361, '1100011128488594', 9.18, '17', '1701', 140302608424)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 339817, '1100011103356402', 0.15, '17', '1701', 140302411150)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 19590597, '1100011190513766', 0.66, '17', '1701', 140307244671)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 1878843, '1100011118666811', 1.44, '17', '1701', 140302612331)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 767788, '1100011107636619', 0.51, '17', '1701', 140307174010)
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, RevTgt)    VALUES ('COOKIE-325321', 2510819, '1100011125155774', 0.47, '17', '1701', 140306830627)

