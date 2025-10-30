DROP TABLE IF EXISTS #Scripts
CREATE TABLE #Scripts (Data VARCHAR(MAX))

DECLARE @ReageTranID DECIMAL(19, 0), @AccountNumber VARCHAR(19), @BSAcctId INT


DECLARE db_Cursor CURSOR FOR
SELECT Column2 FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeRecords WITH (NOLOCK) WHERE FileID = 100

OPEN db_Cursor
FETCH NEXT FROM db_cursor INTO @AccountNumber 

--SET @AccountNumber = '1100011119509440'

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT TOP(1) @ReageTranID = TranID, @BSAcctId = BSAcctId FROM CCArd_Primary WITH (NOLOCK) WHERE AccountNumber = @AccountNumber AND CMTTranTYPE = 'ReageTot' AND MemoIndicator IS NULL

	INSERT INTO #Scripts
	SELECT 'UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = ' + TRY_CAST(TranId AS VARCHAR) + ' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.DelinquencyRecord WITH (NOLOCK) WHERE TranId = @ReageTranID

	INSERT INTO #Scripts
	SELECT 'UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = ' + TRY_CAST(TranId AS VARCHAR) + ' AND TranID = ' + TRY_CAST(TranId AS VARCHAR) + ' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.PlanDelinquencyRecord WITH (NOLOCK) WHERE TranRef = @ReageTranID AND AmountOfTotalDue > 0

	INSERT INTO #Scripts
	SELECT 'UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = ' + TRY_CAST(TranId AS VARCHAR) + ' AND AccountNumber = ''' + @AccountNumber + ''' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID = @ReageTranID 

	INSERT INTO #Scripts
	SELECT 
		'UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = ' + TRY_CAST(BP.acctId AS VARCHAR) + ' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK)
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	WHERE AccountNumber = @AccountNumber AND AmountOfTotalDue > 0

	INSERT INTO #Scripts
	SELECT  
		'UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = ' + TRY_CAST(BP.acctId AS VARCHAR) + ' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) 
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	WHERE AccountNumber = @AccountNumber AND AmountOfTotalDue > 0

	INSERT INTO #Scripts
	SELECT 
		'UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = ' + TRY_CAST(CPCC.acctId AS VARCHAR) + ' -- AccountNumber = ' + @AccountNumber
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentCreditCard CPCC WITH (NOLOCK)
	JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentAccounts CPS with (NOLOCK)  ON (CPS.acctId = CPCC.acctId)
	WHERE parent02AID = @BSAcctId AND AmountOfTotalDue > 0

	FETCH NEXT FROM db_cursor INTO @AccountNumber 

END

CLOSE db_Cursor
DEALLOCATE db_Cursor


SELECT * FROM #Scripts