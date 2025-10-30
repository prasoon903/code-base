
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 172292, '1100011101681256', 228.06, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 425888, '1100011104217017', 1134.07, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 527610, '1100011105234235', 6835.61, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 543800, '1100011105396133', 3960.19, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 566611, '1100011105624245', 4201.75, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 820885, '1100011108167580', 7721.10, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 1204314, '1100011112004472', 639.36, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 1219803, '1100011112159367', 281.72, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2042305, '1100011120349133', 4402.57, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2248451, '1100011122430790', 2951.52, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2331983, '1100011123276911', 265.80, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2339688, '1100011123367264', 86.76, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2501729, '1100011125063473', 351.84, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 2766582, '1100011127790404', 2468.50, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 3623439, '1100011131998670', 755.58, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 3866943, '1100011132550710', 445.29, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 3960640, '1100011132823687', 2635.33, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 4364241, '1100011134598691', 3750.00, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 4829986, '1100011138252733', 621.19, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 5823487, '1100011139565158', 226.35, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 7699989, '1100011141358170', 3398.99, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 7701126, '1100011141380547', 3269.00, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 9747559, '1100011146285873', 1107.23, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 11495776, '1100011149152443', 3240.55, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 12746216, '1100011154562353', 2029.60, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 13712378, '1100011161968254', 130.35, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 14077862, '1100011163039237', 1050.66, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 15324169, '1100011167339849', 2149.69, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 15466053, '1100011167920226', 2331.45, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 16987853, '1100011173483235', 550.03, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 17296227, '1100011175102791', 799.22, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 17324915, '1100011175651300', 1776.26, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 17704956, '1100011178468652', 1072.86, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 17724024, '1100011178833624', 1328.03, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 18005613, '1100011180592168', 1522.77, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 18522603, '1100011185106485', 715.54, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 20286714, '1100011193295155', 2283.20, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 20426104, '1100011194555029', 1689.72, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 20975226, '1100011196688083', 1924.59, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 21139557, '1100011197558053', 329.18, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 21166100, '1100011198060356', 2144.16, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 21572018, '1100011202039396', 1054.07, '49', '4933')
INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   VALUES ('COOKIE-271301', 21808232, '1100011204890481', 56.88, '49', '4933')