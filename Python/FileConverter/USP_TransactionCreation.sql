CREATE OR ALTER PROCEDURE USP_TransactionCreation
	@Type VARCHAR(50),
	@BackDated INT,
	@CMTTRanType VARCHAR(5),
	@ActualTranCode VARCHAR(20)
AS
BEGIN

	--SELECT COUNT(1) FROM RemediationData WITH (NOLOCK)

	DROP TABLE IF EXISTS #TempRecords
	SELECT BP.acctId, BP.AccountNumber, BS.ClientID, BP.MergeInProcessPH, T.*
	INTO #TempRecords
	FROM RemediationData T
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
	JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)
	WHERE MergeInProcessPH IS NOT NULL

	DROP TABLE IF EXISTS #TempDataALL
	SELECT AccountNumber, acctId, Amount TransactionAmount, TranTime TransactionTime INTO #TempDataALL FROM #TempRecords

	IF(@BackDated = 1)
	BEGIN
		DROP TABLE IF EXISTS #TempDataCombined
		SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount, MIN(TransactionTime) TransactionTime
		INTO #TempDataCombined
		FROM #TempDataALL
		GROUP BY AccountNumber, acctID
	END
	ELSE
	BEGIN
		DROP TABLE IF EXISTS #TempDataCombined
		SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount, NULL TransactionTime
		INTO #TempDataCombined
		FROM #TempDataALL
		GROUP BY AccountNumber, acctID
	END

	INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime)
	SELECT acctID, AccountNumber, TransactionAmount, @CMTTRanType, @ActualTranCode, TransactionTime
	FROM #TempDataALL


END