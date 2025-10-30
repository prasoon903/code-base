--EXEC USP_PurchaseReversalRecordDetails @BSacctId = 14551610, @TranRef = 0, @LinkServer = 'XEON-S8', @DB = 'PP_TEST'


CREATE OR ALTER PROCEDURE USP_PurchaseReversalRecordDetails
	@BSacctId INT = NULL,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@TranID DECIMAL(19,0) = 0,
	@TranRef DECIMAL(19,0) = 0,
	@LinkServer VARCHAR(50),
	@DB VARCHAR(30),
	@DB_Sec VARCHAR(30) = NULL
AS
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	SET XACT_ABORT ON;


	DECLARE @SQL NVARCHAR(MAX), @ColumnNames NVARCHAR(MAX), @ID NVARCHAR(100), @TID NVARCHAR(100), @CurrentDate DATETIME

	
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

		IF((@TranID IS NULL OR @TranID <= 0) AND (@TranRef IS NULL OR @TranRef <= 0))
		BEGIN
			IF(@BSacctId IS NOT NULL AND @BSacctId <> 0)
			BEGIN
				SET @BSacctId = @BSacctId
			END
			ELSE IF(@AccountNumber IS NOT NULL AND @AccountNumber <> '')
			BEGIN
				SET @ID = TRY_CAST(@AccountNumber AS NVARCHAR(19))
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @BSacctId OUTPUT
				SET @BSacctId = @BSacctId
			END
			ELSE IF(@AccountUUID IS NOT NULL AND @AccountUUID <> '')
			BEGIN
				SET @ID = TRY_CAST(@AccountUUID AS NVARCHAR(64))
				--PRINT @ID
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @BSacctId OUTPUT
				SET @BSacctId = @BSacctId
			END
			ELSE
			BEGIN
				SELECT 'AccountID, AccountNumber or  AccountUUID MUST BE PASSED' ErrorMessage
				RETURN
			END

			IF(@BSacctId IS NULL OR @BSacctId = 0)
			BEGIN
				SELECT 'INVALID ACCOUNT IDENTIFIER' ErrorMessage
				RETURN
			END
		END

		IF(@TranID IS NOT NULL AND @TranID > 0)
		BEGIN
			--SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			SET @TID = TRY_CAST(@TranID AS NVARCHAR(100))
					   
			SET @ColumnNames = N'acctId,parent02AID,TranId,TranRef,TransactionAmount,ReversalFlag,CMTTRANTYPE,SKEY,
								InvoiceNo,tranorig,OriginalTranref,CaseID,ReferenceTranID,ClaimID'
	
			SET @SQL = N'SELECT ''PurchaseReversalRecord'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.PurchaseReversalRecord P WITH(NOLOCK)
			WHERE P.TranID = @TID'

			PRINT(@SQL)
	
			EXECUTE SP_EXECUTESQL @SQL, N'@TID NVARCHAR(100)', @TID=@TID
		END
		ELSE IF(@TranRef IS NOT NULL AND @TranRef > 0)
		BEGIN
			--SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			SET @TID = TRY_CAST(@TranRef AS NVARCHAR(100))
					   
			SET @ColumnNames = N'acctId,parent02AID,TranId,TranRef,TransactionAmount,ReversalFlag,CMTTRANTYPE,SKEY,
								InvoiceNo,tranorig,OriginalTranref,CaseID,ReferenceTranID,ClaimID'
	
			SET @SQL = N'SELECT ''PurchaseReversalRecord'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.PurchaseReversalRecord P WITH(NOLOCK)
			WHERE P.TranRef = @TID'

			PRINT(@SQL)
	
			EXECUTE SP_EXECUTESQL @SQL, N'@TID NVARCHAR(100)', @TID=@TID
		END
		ELSE
		BEGIN
			SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			--SET @TID = TRY_CAST(@TranRef AS NVARCHAR(100))
					   
			SET @ColumnNames = N'acctId,parent02AID,TranId,TranRef,TransactionAmount,ReversalFlag,CMTTRANTYPE,SKEY,
								InvoiceNo,tranorig,OriginalTranref,CaseID,ReferenceTranID,ClaimID'
	
			SET @SQL = N'SELECT ''PurchaseReversalRecord'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.PurchaseReversalRecord P WITH(NOLOCK)
			WHERE P.parent02AID = @ID'

			PRINT(@SQL)
	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END

	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END