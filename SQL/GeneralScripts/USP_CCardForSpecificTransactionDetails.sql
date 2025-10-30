--EXEC USP_CCardForSpecificTransactionDetails @AccountNumber = '1100001000000153', @GetDataFrom = 2, @TranRef = 11049, @LinkServer = 'XEON-S8', @DB = 'PP_CI'

CREATE OR ALTER PROCEDURE USP_CCardForSpecificTransactionDetails
	@BSacctId INT = NULL,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@TranID DECIMAL(19,0) = NULL,
	@TranRef DECIMAL(19,0) = NULL,
	@GetDataFrom INT = 0,
	@LinkServer VARCHAR(50),
	@DB VARCHAR(30),
	@DB_Sec VARCHAR(30) = NULL
AS
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	SET XACT_ABORT ON;


	DECLARE @SQL NVARCHAR(MAX), @ColumnNames NVARCHAR(MAX), @ID NVARCHAR(100), @TID NVARCHAR(100)

	
	BEGIN TRY
		IF (@LinkServer IS NULL OR @LinkServer = '')
		BEGIN

			SELECT 'LINKSERVER CAN NOT BE NULL' AS ErrorMessage
			RETURN
		END
		ELSE IF (@LinkServer IS NOT NULL AND @LinkServer <> '')
		BEGIN

			IF NOT EXISTS (SELECT TOP 1 1 FROM Sys.servers WITH(NOLOCK) WHERE NAME =  @LinkServer)
			BEGIN 
				SELECT 'Please Provide Correct LINKSERVER == '+ @LinkServer AS ErrorMessage
				RETURN
			END
		END

		SET @LINKSERVER = QUOTENAME(@LINKSERVER)
		SET @DB = QUOTENAME(@DB)
		SET @DB_Sec = QUOTENAME(@DB_Sec)

		IF(@GetDataFrom <> 0 AND @GetDataFrom <> 1)
		BEGIN
			SELECT 'Please Provide the valid value for GetDataFrom (0- Via TranID\1- Via TranRef)' AS ErrorMessage
			RETURN
		END

		IF(@AccountNumber IS NOT NULL AND @AccountNumber <> '')
		BEGIN
			SET @AccountNumber = @AccountNumber
		END
		ELSE IF(@BSacctId IS NOT NULL AND @BSacctId > 0)
		BEGIN
			SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			SET @SQL = 'SELECT @AccountNumber = AccountNumber FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE acctID =  @ID'
			--PRINT @SQL
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @AccountNumber VARCHAR(19) OUTPUT', @ID=@ID, @AccountNumber = @AccountNumber OUTPUT
			SET @AccountNumber = @AccountNumber
		END
		ELSE IF(@AccountUUID IS NOT NULL AND @AccountUUID <> '')
		BEGIN
			SET @ID = TRY_CAST(@AccountUUID AS NVARCHAR(64))
			--PRINT @ID
			SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID =  @ID'
			--PRINT @SQL
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @AccountNumber VARCHAR(19) OUTPUT', @ID=@ID, @AccountNumber = @AccountNumber OUTPUT
			SET @AccountNumber = @AccountNumber
		END
		ELSE
		BEGIN
			SELECT 'AccountID, AccountNumber or  AccountUUID MUST BE PASSED' ErrorMessage
			RETURN
		END

		IF(@AccountNumber IS NULL OR @AccountNumber = '')
		BEGIN
			SELECT 'INVALID ACCOUNT IDENTIFIER' ErrorMessage
			RETURN
		END

		SET @ID = TRY_CAST(@AccountNumber AS NVARCHAR(19))

		SET @ColumnNames = N'BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, CP.creditplanmaster, 
			CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
			CP.MemoIndicator,CP.RevTgt, TransactionDescription, NoblobIndicator, NoblobIndicatorGEN, CP.DateTimeLocalTransaction'

		IF(@GetDataFrom = 0)
		BEGIN
			IF(@TranID IS NULL OR @TranID <= 0)
			BEGIN
				SELECT 'INVALID TranID WHILE FETCHING DATA VIA TranID' ErrorMessage
				RETURN
			END

			SET @TID = TRY_CAST(@TranID AS NVARCHAR(100))


			SET @SQL = N'SELECT ''CCard'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Primary CP WITH(NOLOCK)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
			WHERE  CP.AccountNumber = @ID 
			AND CP.TranID = @TID
			ORDER BY CP.PostTime DESC'
		END

		IF(@GetDataFrom = 1)
		BEGIN
			IF(@TranRef IS NULL OR @TranRef <= 0)
			BEGIN
				SELECT 'INVALID TranRef WHILE FETCHING DATA VIA TranRef' ErrorMessage
				RETURN
			END

			SET @TID = TRY_CAST(@TranRef AS NVARCHAR(100))


			SET @SQL = N'SELECT ''CCard'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Primary CP WITH(NOLOCK)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
			WHERE  CP.AccountNumber = @ID 
			AND CP.TranRef = @TID
			ORDER BY CP.PostTime DESC'
		END
		

		--PRINT(@SQL)

	
		EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @TID NVARCHAR(100)', @ID=@ID, @TID=@TID
		


	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END