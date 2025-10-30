USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE CCard_Primary SET PostingRef = 'Transaction posted successfully', ArTxnType = '91' WHERE TranID = 29391221150
	-- 1 row

	UPDATE LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID = 29391221150 AND ARTxnType = '93'
	-- 1 row

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

/*

SELECT ExcludeFlag,* FROM LogArTxnAddl WITH (NOLOCK) WHERE TranID = 29391221150

SELECT bsacctid, AccountNumber, PostingRef, ArTxnType, * FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 29391221150

*/