
/*

 UPDATE Org_Balances SET AsynchronousPosting = 1 WHERE acctid <> 1
 update orgaccounts set tpyblob = null, tpynad = null, tpylad = null 

 select * from Org_Balances with(nolock)

 update ARSystemHSAccounts set nadmode = 1 
 update ARSystemAccounts set nadmode = 1 

 SELECT * FROM EOD_AsystemHS WITH(NOLOCK) WHERE OldProcDayEnd = '2018-02-07 23:59:54.000'



 STEP 1 - Create EOD job for Institution 
 STEP 2 - SELECT * FROM EOD_AsystemHS WITH(NOLOCK) WHERE Status = 'NEW'
 STEP 3 - EXEC USP_EOD_AsystemHS_JOB

*/

/*

SELECT institutionID, * FROM CCard_Primary cp WITH(nolock) WHERE CMTTranType = 'EOD'
SELECT * FROM CommonTNP WITH(NOLOCK) WHERE TranID IN (SELECT TranID FROM CCard_Primary cp WITH(nolock) WHERE CMTTranType = 'EOD')
SELECT * FROM CommonTNP ct WITH (NOLOCK) WHERE ATID = 60
SELECT NADMode, * FROM ARSystemAccounts aa WITH (NOLOCK)
SELECT NADMode, * FROM ARSystemHSAccounts aa WITH (NOLOCK)

SELECT * FROM EOD_AsystemHS WITH(NOLOCK)

UPDATE ARSystemHSAccounts SET CutOffPeriod = NULL WHERE acctID = 1553

*/

DECLARE @HSacctId INT
	   ,@ATID INT
	   ,@HSProcDayEnd DATETIME
	   ,@CurrentTime DATETIME
	   ,@CMTTRANTYPE VARCHAR(8)
	   ,@MaxTranTime DATETIME
	   ,@HSCutOffacctId INT
	   ,@InstitutionId INT -- 6971 6973 6975 6977 6969
	   ,@TranId DECIMAL(19, 0)
	   ,@PostValue_StepSize INT
	   ,@varTWid INT
	   ,@Count INT = 0
	   ,@LeastTranTime DATETIME
	   ,@CreatePaymentJob INT = 0


	   	EXEC USP_GetSET_PostValues_SF_SQL @procedureID = @@procid
									 ,@pid = @@spid
									 ,@NameKey = 'TranId'
									 ,@hostname = ''
									 ,@ReserveCount = 5
									 ,@SequenceID = @TranId OUTPUT
									 ,@PostValue_StepSize = @PostValue_StepSize OUTPUT
									 ,@in_TWID = @varTWid OUTPUT

BEGIN TRY
	BEGIN TRANSACTION

	DROP TABLE IF EXISTS #Institutions

	SELECT
		InstitutionID
	   ,'N' Status INTO #Institutions
	FROM ARSystemHSAccounts WITH (NOLOCK)

	--SELECT *
	--FROM #Institutions


	WHILE EXISTS (SELECT TOP 1 1 FROM #Institutions WHERE Status = 'N')
	BEGIN
	--GET CURRENT TIME  
	--SET @DateTimeStamp = DBO.PR_GetBusinessTime(@InstitutionId)  

	SET @ATID = 100
	SET @CMTTRANTYPE = 'EOD'

	SELECT
		@HSacctId = acctId
	   ,@HSProcDayEnd = ProcDayEnd
	   ,@InstitutionID = HS.InstitutionID
	FROM ARSystemHSAccounts HS WITH (NOLOCK)
	JOIN #Institutions I
		ON (HS.InstitutionID = I.InstitutionID)
	WHERE I.Status = 'N'

	SET @HSProcDayEnd = DATEADD(SECOND, -1800, @HSProcDayEnd)


	IF(@CreatePaymentJob = 1)
	BEGIN 
		INSERT INTO CreateNewSingleTransactionData (AccountNumber, CMTTranType, TransactionAmount, EntryReason, TranTime, PostTime, ActualTrancode)
		SELECT AccountNumber, '21', CurrentBalance, NULL, DATEADD(SECOND, -10, @HSProcDayEnd), DATEADD(SECOND, -10, @HSProcDayEnd), '2102'
		FROM BSegment_Primary WITH(NOLOCK)
		WHERE BillingCycle = '31'
		AND InstitutionID = @InstitutionID

		EXEC USP_CreateNewSingleTransactionData @MTCGID = 53, @InsitutionID = 6969, @Batchcount = 1000

		update CreateNewSingleTransactionData set posttime = trantime where TransactionStatus = 1

		DELETE FROM CreateNewSingleTransactionData WHERE TranID IS NULL

		Exec  USP_CreateNewSingleTransaction
	END

	SELECT TOP 1 @LeastTranTime = C.TranTime
	FROM CommonTNP C WITH(nolock) 
	LEFT JOIN CCard_Primary cp WITH(NOLOCK) ON (C.TranId = cp.TranId)
	WHERE C.TranTime < CASE 
							WHEN @CurrentTime < @HSProcDayEnd
							THEN @CurrentTime
							ELSE @HSProcDayEnd
							END
		AND C.ATID = 51 
		AND cp.CMTTRANTYPE NOT IN ('21', '23')
		AND C.TranId > 0  
	ORDER BY C.TranTime 

	IF @LeastTranTime IS NOT NULL
	SET @HSProcDayEnd = DATEADD(SECOND, -1, @LeastTranTime)

	--SELECT @TranId = Seq FROM PostValues WITH(UPDLOCK) WHERE Name = 'TranId'  
	--UPDATE PostValues SET Seq = @TranId + 1 WHERE Name = 'TranId'  



	--SELECT 1 FROM #EODTransaction  
	INSERT INTO CCard_Primary (UniqueID, TranId, TranTime, PostTime, ATID, TxnAcctId, CMTTRANTYPE, TransactionAmount, PostingFlag, TransactionDescription, InstitutionID, TransmissionDateTime)
		SELECT
			@TranId + @Count
		   ,@TranId + @Count
		   ,@HSProcDayEnd
		   ,@HSProcDayEnd
		   ,@ATID
		   ,@HSacctId
		   ,@CMTTRANTYPE
		   ,0.00
		   ,'1'
		   ,'EOD txn will change date of ARSystemHSAccounts'
		   ,@InstitutionID
		   ,GETDATE()

	INSERT INTO CommonTNP (tnpdate, priority, TranTime, TranId, ATID, acctId, ttid, NADandROOFlag, GetAllTNPJobsFlag, Retries, InstitutionID)
	SELECT CAST(@HSProcDayEnd AS DATE), 0, @HSProcDayEnd, @TranId + @Count, @ATID, @HSacctId, 0, 1, 0, 0, @InstitutionID

	UPDATE #Institutions
	SET Status = 'D'
	WHERE InstitutionID = @InstitutionID

	SET @Count = @Count + 1
	END


	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@trancount > 0
		ROLLBACK TRANSACTION
	SELECT
		ERROR_MESSAGE()
	   ,ERROR_LINE()
	   ,ERROR_NUMBER()
	RAISERROR ('ERROR OCCURED :-', 16, 1);
END CATCH
/*
WHILE EXISTS (SELECT TOP 1 1 FROM CommonTNP WITH(NOLOCK) WHERE TranID IN (SELECT TranID FROM CCard_Primary cp WITH(nolock) WHERE CMTTranType = 'EOD'))
BEGIN
	PRINT 'Wait for 5 sec'
	WAITFOR DELAY '00:00:05' 
END
 
WHILE EXISTS (SELECT TOP 1 1 FROM EOD_AsystemHS WITH(NOLOCK) WHERE Status = 'NEW')
BEGIN
	EXEC USP_EOD_AsystemHS_JOB
END
*/

