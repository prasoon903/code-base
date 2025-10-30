BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN



UPDATE TOP(1) CCard_Primary SET 
	PostingRef = 'Transaction Posted Successfully',
	ArTxnType = 91,
	AccountNumber = '1100011167780273',
	BSAcctID = 15458466,
	ClientID = '49b9fd69-6689-4303-8173-16d2a5d6dfed',
	EmbAcctId = 21811772
WHERE TranID = 71829029667


UPDATE TOP(1) CCard_Primary SET 
	AccountNumber = '1100011167780273'
WHERE TranID = 72168902894