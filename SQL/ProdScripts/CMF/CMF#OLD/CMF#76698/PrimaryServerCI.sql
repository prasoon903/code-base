BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN



UPDATE TOP(1) CCard_Primary SET 
	PostingRef = 'Transaction Posted Successfully',
	ArTxnType = 91,
	AccountNumber = '1100011203982511',
	BSAcctID = 21674093,
	ClientID = '00b0bb88-0bf7-4647-a56f-715ff120cc3a',
	EmbAcctId = 29704587
WHERE TranID = 70872068373


UPDATE TOP(1) CCard_Primary SET 
	AccountNumber = '1100011203982511'
WHERE TranID = 71625041275