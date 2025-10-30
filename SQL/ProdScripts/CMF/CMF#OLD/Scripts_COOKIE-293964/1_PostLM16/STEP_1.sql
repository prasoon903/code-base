
IF EXISTS (SELECT TOP 1 1 FROM TransactionCreationTempData WITH (NOLOCK) WHERE JobStatus = 0)
BEGIN 
	SELECT 'There is already in-process jobs in the table, so cannot be inserted new records'
	RETURN
END


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

DECLARE @PODID INT = 0
SELECT @PODID = PODID FROM CPS_Environment WITH (NOLOCK)

IF @PODID = 1
BEGIN
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 2327663, '1100011123131074', 0.25, '16', '1605')
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 2902805, '1100011129171694', 0.01, '16', '1605')
END

IF @PODID = 2
BEGIN
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 51753171, '1200012002590280', 0.77, '16', '1605')
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 52348986, '1200012006430319', 0.51, '16', '1605')
END

IF @PODID = 4
BEGIN
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 106501122, '1300111087627238', 0.51, '16', '1605')
	INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode)   
	VALUES ('COOKIE-292364', 102704099, '1300111041360546', 1.28, '16', '1605')
END



--1

--2327663 - 1100011123131074 - 0.25
--2902805 - 1100011129171694 - 0.01

--2

--51753171 - 1200012002590280 - 0.77
--52348986 - 1200012006430319 - 0.51

--4

--106501122 - 1300111087627238 - 0.51
--102704099 - 1300111041360546 - 1.28

