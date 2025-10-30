DECLARE
		@AccountNumber VARCHAR(19),
		@TranId DECIMAL,
		@TranIdAccount DECIMAL,
		@currentSeq DECIMAL, 
		@StepSize INT,
		@Reserve INT,
		@AmountOfTotalDueBS MONEY,
		@CPSID INT,
		@LoopCount INT = 0,
		@InstitutionID INT,
		@RecordExistCount INT,
		@LastStatementDate DATETIME,
		@TranTime DATETIME,
		@CurrentTime DATETIME,
		@RMATranUUID VARCHAR(64),
		@Skey DECIMAL(19,0)


DROP TABLE IF EXISTS #TempCPSDetails
CREATE TABLE #TempCPSDetails
(TranID DECIMAL(19,0), parent02AID INT, acctId INT, RMATranUUID VARCHAR(64), InvoiceNumber VARCHAR(20))

DROP TABLE IF EXISTS TempJobs
CREATE TABLE TempJobs
(
	SKey DECIMAL(19,0) IDENTITY(1, 1),
	AccountID INT,
	PlanID INT,
	RMATranUUID VARCHAR(64), 
	InvoiceNumber VARCHAR(20),
	CreditPlanMaster INT,
	TransactionAmount MONEY,
	TransactionType VARCHAR(8),
	TranID DECIMAL(19,0),
	JobStatus INT DEFAULT 0
)

UPDATE TJ
SET
	RMATranUUID = CPCC.PlanUUID,
	InvoiceNumber = CPA.InvoiceNumber,
	CreditPlanMaster = CPA.parent01AID
FROM TempJobs TJ
JOIN CPSgmentAccounts CPA ON (TJ.PlanID = CPA.acctId)
JOIN CPSgmentCreditCard CPCC ON (CPA.acctId = CPCC.acctId)

SET @Reserve = 5
SELECT @Reserve = COUNT(1) + 5 FROM TempJobs WITH (NOLOCK) WHERE JobStatus = 0

EXEC USP_GetSET_PostValues_SF_SQL    
		@procedureID =@@procid,    
		@pid =@@spid,    @NameKey ='TranID',    
		@hostname ='',    
		@ReserveCount = @Reserve,    
		@SequenceID=@currentSeq OUTPUT ,    
		@PostValue_StepSize=@StepSize OUTPUT


DECLARE db_Cursor CURSOR FOR
SELECT Skey FROM TempJobs WITH (NOLOCK) WHERE JobStatus = 0

OPEN db_Cursor
FETCH NEXT FROM db_cursor INTO @Skey


WHILE @@FETCH_STATUS = 0 
BEGIN
	SET @LoopCount = @LoopCount + 1
	UPDATE TempJobs SET TranID = @currentSeq + @LoopCount WHERE SKey = @Skey

	FETCH NEXT FROM db_cursor INTO @Skey

END

CLOSE db_Cursor
DEALLOCATE db_Cursor

SET @TranId = @currentSeq + 1
SET @CurrentTime = dbo.GetCurrentTime(51)


INSERT INTO CreateNewSingleTransactionData
(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, TransactionStatus)
VALUES
(@TranId, @CurrentTime, @CurrentTime, 14551526, '16','1601 = REWARDS REVERSAL CHARGE',
'17151',10,'1100001000001599','Transaction posted successfully','lclUnitedStates',
'2','91',13768,51,1, 1)

WAITFOR DELAY '00:00:01' 

-- RETAIL TRANSACTIONS
SET @TranId = @currentSeq + 2
SET @CurrentTime = dbo.GetCurrentTime(51)

SET @RMATranUUID = '82d07b3c-9e91-44b9-b771-9ae04a199bf9'
INSERT INTO #TempCPSDetails(TranID, parent02AID, RMATranUUID) VALUES (@TranId, 14551526, @RMATranUUID)


INSERT INTO CreateNewSingleTransactionData
(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, RMATranUUID, TransactionStatus)
VALUES
(@TranId, @CurrentTime, @CurrentTime, 14551526, '48','F4804 =  MANUAL ADJUSTMENT TO MATCH PARTNER RETAIL',
'19129',100,'1100001000001599','Transaction posted successfully','lclUnitedStates',
'2','91',13776,51,0,@RMATranUUID, 1)

UPDATE TT
SET 
	acctId = CPA.acctId,
	InvoiceNumber = CPA.InvoiceNumber
FROM #TempCPSDetails TT
JOIN CPSgmentCreditCard CPCC ON (TT.RMATranUUID = CPCC.PlanUUID)
JOIN CPSgmentAccounts CPA ON (CPCC.acctId = CPA.acctId)

WAITFOR DELAY '00:00:01' 


SET @TranId = @currentSeq + 3
SET @CurrentTime = dbo.GetCurrentTime(51)


INSERT INTO CreateNewSingleTransactionData
(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, TransactionStatus)
VALUES
(@TranId, @CurrentTime, @CurrentTime, 14551526, '49','4901 = MANUAL ADJUSTMENT TO MATCH NETWORK',
'17175',110,'1100001000001599','Transaction posted successfully','lclUnitedStates',
'2','91',13744,51,0, 1)


--TRUNCATE TABLE CreateNewSingleTransactionData

SELECT TransactionStatus, * FROM CreateNewSingleTransactionData

BEGIN TRY

	BEGIN TRANSACTION
		EXEC USP_CreateNewSingleTransaction

		UPDATE CS
		SET InvoiceNumber = TT.InvoiceNumber
		FROM CCard_Secondary CS
		JOIN #TempCPSDetails TT ON (CS.TranID = TT.TranID)
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT Error_number(), Error_message(), ERROR_LINE()
END CATCH
 

--UPDATE CCard_Secondary SET InvoiceNumber = '18020613092097464' WHERE TranId = 56321491686719490

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId > 0


--SELECT * FROM #TempCPSDetails