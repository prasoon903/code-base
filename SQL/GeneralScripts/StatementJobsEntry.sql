SET NOCOUNT ON

--BEGIN TRAN
--	UPDATE BSegment_Secondary SET ClientId = '123' WHERE acctId = 5000
--	UPDATE BSegment_Secondary SET ClientId = '123' WHERE acctId = 5001
--COMMIT TRAN


DECLARE @JobID DECIMAL(19,0),
@ErrorInTranID INT,
@Count INT,
@AccountID BIGINT,
@BSegment_UUID VARCHAR(64),
@StmtHeader_UUID VARCHAR(64),
@AccountNumber VARCHAR(19),
@parent05AID INT,
@ProductID INT,
@LastStatementDate DATETIME,
@ClientId VARCHAR(50),
@StatementDate DATETIME,
@RecordCount INT

DROP TABLE IF EXISTS #TempStmtJobs
DROP TABLE IF EXISTS #TempAccountID

CREATE TABLE #TempStmtJobs
(
	JobID DECIMAL(19,0)
	,acctId INT
	,parent05AID INT
	,StatementDate DATETIME
	,Status CHAR(20)
	,RequestDate DATETIME
	,ProcessedDate DATETIME
	,StmtProdFlag INT
	,AccountNumber VARCHAR(19)
	,ProductID INT
	,ClientId VARCHAR(50)
	,LastStatementDate DATETIME
	,BSegment_UUID VARCHAR(64)
	,StmtHeader_UUID VARCHAR(64)
)

CREATE TABLE #TempAccountID
(acctid BIGINT)

INSERT INTO #TempAccountID (acctid) VALUES (5000), (5001)

SELECT @Count = COUNT(1) FROM #TempAccountID

BEGIN TRY 
	BEGIN TRAN 
		SELECT @JobID = seq + 2 
		FROM   postvalues WITH(updlock)  WHERE  NAME = 'jobid' 
			
		UPDATE postvalues 
		SET    seq = seq +  Isnull(@Count, 0) + 2  WHERE  NAME = 'jobid'
	COMMIT TRAN 
END TRY
BEGIN catch 
	SET @ErrorInTranID =1 
END catch

WHILE(@Count > 0)
BEGIN
	SELECT TOP 1 @AccountID = acctid FROM #TempAccountID

	SELECT	@BSegment_UUID = BP.UniversalUniqueID, 
					@AccountNumber = BP.AccountNumber,
					@parent05AID = BP.parent05AID,
					@ProductID = BP.parent02AID,
					@LastStatementDate = BP.LastStatementDate,
					@ClientId = BS.ClientId
	FROM BSegment_Primary BP WITH (NOLOCK)
	JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
	WHERE BP.acctId = @AccountID

	SET @RecordCount = @@rowcount

	SELECT TOP 1 @StmtHeader_UUID = UniversalUniqueID, @StatementDate = StatementDate 
	FROM StatementHeader WITH (NOLOCK)
	WHERE acctId = @AccountID

	IF(@RecordCount > 0)
	BEGIN
		INSERT INTO #TempStmtJobs (JobID,acctId,parent05AID,StatementDate,Status,RequestDate,StmtProdFlag,AccountNumber,ProductID,ClientId,LastStatementDate,BSegment_UUID,StmtHeader_UUID)
		VALUES(@JobID, @AccountID, @parent05AID, @StatementDate, 'NEW', @StatementDate, 0, @AccountNumber, @ProductID, @ClientId, @LastStatementDate, @BSegment_UUID, @StmtHeader_UUID)
	END

	DELETE FROM #TempAccountID WHERE acctid = @AccountID
	SELECT @Count = COUNT(1) FROM #TempAccountID

	SET @JobID = @JobID + 1

END

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		INSERT INTO StatementJobs
		SELECT * FROM #TempStmtJobs

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_LINE() 
	END CATCH
END