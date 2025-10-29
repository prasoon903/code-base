--EXEC USP_CBAuditDetails @BSacctId = 5000, @TranID = 0, @LinkServer = 'XEON-S8', @DB = 'PP_CI', @FromDate = '2018-02-06', @ToDate = '2018-02-07'
--EXEC USP_CCardDetails @LinkServer = 'XEON-S8', @DB = 'PP_CI', @FromDate = '2018-02-06', @ToDate = '2018-02-07'
USE PP_POD2_CI
GO
CREATE OR ALTER PROCEDURE USP_CBAuditDetails
	@BSacctId INT = NULL,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@TranID DECIMAL(19,0) = 0,
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL,
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

		IF(@TranID IS NOT NULL AND @TranID > 0)
		BEGIN
			SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			SET @TID = TRY_CAST(@TranID AS NVARCHAR(100))
					   
			SET @ColumnNames = N'IdentityField,tid,businessday,atid,aid,dename,oldvalue,newvalue'
	
			SET @SQL = N'SELECT ''CBAudit'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CurrentBalanceAudit CBA WITH(NOLOCK)
			WHERE CBA.AID = @ID
			AND CBA.TID = @TID
			AND CBA.ATID = 51'

			--PRINT(@SQL)
	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @TID NVARCHAR(100)', @ID=@ID, @TID=@TID
		END
		ELSE
		BEGIN
			IF(@FromDate IS NULL OR @FromDate = '')
			BEGIN
				SELECT 'FromDate cannot be blank' ErrorMessage
				RETURN
			END
			
			IF(@ToDate IS NULL OR @ToDate = '')
			BEGIN
				SET @ToDate = dbo.PR_ISOGetBusinessTime()
			END
		
			IF(DATEDIFF(MONTH, @FromDate, @ToDate) > 3)
			BEGIN
				SELECT 'Maximum 3 month data can be returned' ErrorMessage
				RETURN
			END

			IF(@FromDate >= @ToDate)
			BEGIN
				SELECT 'ToDate must be greater than FromDate' ErrorMessage
				RETURN
			END


			SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)

			--PRINT(@ID)
			--PRINT(@FromDate)
			--PRINT(@ToDate)


			SET @ColumnNames = N'IdentityField,tid,businessday,atid,aid,dename,oldvalue,newvalue'
	
			SET @SQL = N'SELECT ''CBAudit'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CurrentBalanceAudit CBA WITH(NOLOCK)
			WHERE  CBA.AID = @ID
			AND CBA.ATID = 51
			AND CBA.businessday BETWEEN @FromDate AND @ToDate
			ORDER BY CBA.businessday DESC'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate
		
		END

	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END