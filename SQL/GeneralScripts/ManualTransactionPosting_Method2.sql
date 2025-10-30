DROP TABLE IF EXISTS TempJobs
CREATE TABLE TempJobs
(
	SKey DECIMAL(19,0) IDENTITY(1, 1),
	AccountID INT,
	AccountNumber VARCHAR(19),
	PlanID INT,
	RMATranUUID VARCHAR(64), 
	InvoiceNumber VARCHAR(20),
	CreditPlanMaster INT,
	TransactionAmount MONEY,
	TransactionType VARCHAR(8),
	TranID DECIMAL(19,0),
	JobStatus INT DEFAULT 0
)


INSERT INTO TempJobs (AccountID, AccountNumber, PlanID, TransactionAmount, TransactionType)
VALUES
(14551526, '1100001000001599', 40755606, 10, '16'),
(14551526, '1100001000001599', 40755607, 100, '48'),
(14551526, '1100001000001599', 40755598, 110, '49')


DECLARE
		@AccountNumber VARCHAR(19),
		@TranId DECIMAL,
		@currentSeq DECIMAL, 
		@StepSize INT,
		@Reserve INT,
		@CPSID INT,
		@LoopCount INT = 0,
		@InstitutionID INT,
		@TranTime DATETIME,
		@CurrentTime DATETIME,
		@RMATranUUID VARCHAR(64),
		@Skey DECIMAL(19,0),
		@TransactionType VARCHAR(8),
		@BSAcctId INT,
		@CPM INT,
		@TransactionAmount MONEY


UPDATE TJ
SET
	RMATranUUID = CPCC.PlanUUID,
	InvoiceNumber = CPA.InvoiceNumber,
	CreditPlanMaster = CPA.parent01AID
FROM TempJobs TJ
JOIN CPSgmentAccounts CPA ON (TJ.PlanID = CPA.acctId)
JOIN CPSgmentCreditCard CPCC ON (CPA.acctId = CPCC.acctId)


SELECT TOP 1 @InstitutionID =  InstitutionID FROM Institutions WITH (NOLOCK) WHERE SysOrgID = 51  
  
SELECT @CurrentTime = CAST(CONVERT(VARCHAR, ProcDayEnd, 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)  
FROM ARSystemAccounts AR WITH (NOLOCK)   
JOIN Org_Balances OB WITH (NOLOCK) ON (AR.acctId = OB.ARSystemAcctId)  
WHERE OB.acctId = @InstitutionID


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
	SET @TranID = @currentSeq + @LoopCount

	SET @CurrentTime = DATEADD(SECOND, @LoopCount, @CurrentTime)

	SELECT 
		@TransactionType = TransactionType,
		@BSAcctId = AccountID,
		@CPSID = PlanID,
		@CPM = CreditPlanMaster,
		@RMATranUUID = RMATranUUID,
		@AccountNumber = AccountNumber,
		@TransactionAmount = TransactionAmount
	FROM TempJobs 
	WHERE Skey = @Skey

	IF(@TransactionType = '16')
	BEGIN
		INSERT INTO CreateNewSingleTransactionData
		(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
		TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
		TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, TransactionStatus)
		VALUES
		(@TranId, @CurrentTime, @CurrentTime, @BSAcctId, '16','1601 = REWARDS REVERSAL CHARGE',
		'17151',@TransactionAmount,@AccountNumber,'Transaction posted successfully','lclUnitedStates',
		'2','91',@CPM,51,1, 1)
	END
	ELSE IF(@TransactionType = '48')
	BEGIN
		INSERT INTO CreateNewSingleTransactionData
		(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
		TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
		TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, RMATranUUID, TransactionStatus)
		VALUES
		(@TranId, @CurrentTime, @CurrentTime, @BSAcctId, '48','F4804 =  MANUAL ADJUSTMENT TO MATCH PARTNER RETAIL',
		'19129',@TransactionAmount,@AccountNumber,'Transaction posted successfully','lclUnitedStates',
		'2','91',@CPM,51,0,@RMATranUUID, 1)
	END
	ELSE IF(@TransactionType = '49')
	BEGIN
		INSERT INTO CreateNewSingleTransactionData
		(TranId, TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
		TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
		TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority, TransactionStatus)
		VALUES
		(@TranId, @CurrentTime, @CurrentTime, @BSAcctId, '49','4901 = MANUAL ADJUSTMENT TO MATCH NETWORK',
		'17175',@TransactionAmount,@AccountNumber,'Transaction posted successfully','lclUnitedStates',
		'2','91',@CPM,51,0, 1)
	END

	UPDATE TempJobs SET TranID = @TranID, JobStatus = 1 WHERE SKey = @Skey

	--WAITFOR DELAY '00:00:01' 

	FETCH NEXT FROM db_cursor INTO @Skey

END

CLOSE db_Cursor
DEALLOCATE db_Cursor


--TRUNCATE TABLE CreateNewSingleTransactionData

SELECT TransactionStatus, * FROM CreateNewSingleTransactionData

BEGIN TRY

	BEGIN TRANSACTION
		EXEC USP_CreateNewSingleTransaction

		UPDATE CS
		SET InvoiceNumber = TT.InvoiceNumber
		FROM CCard_Secondary CS
		JOIN TempJobs TT ON (CS.TranID = TT.TranID)
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT Error_number(), Error_message(), ERROR_LINE()
END CATCH
 

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId > 0


--SELECT * FROM TempJobs