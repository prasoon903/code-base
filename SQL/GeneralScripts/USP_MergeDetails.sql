--EXEC USP_StatementDetails @BSacctId = 2829633, @GetStatement = 2, @PlanID = 0, @LinkServer = 'XEON-S8', @DB = 'JAZZSanpreet_CI', @DB_Sec = 'JAZZSanpreet_CI_Sec', @FromDate = '2020-07-31 23:59:57.000', @ToDate = '2020-09-30 23:59:57.000'
--SELECT DATEDIFF(MONTH, '2020-07-31 23:59:57.000', '2020-09-30 23:59:57.000')

CREATE OR ALTER PROCEDURE USP_MergeDetails
	@SrcBSacctId INT = 0,
	@SrcAccountNumber VARCHAR(19) = NULL,
	@SrcAccountUUID VARCHAR(64) = NULL,
	@DestBSacctId INT = 0,
	@DestAccountNumber VARCHAR(19) = NULL,
	@DestAccountUUID VARCHAR(64) = NULL,
	@PlanID INT = 0,	
	@JobID DECIMAL(19,0) = NULL,
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL,
	@GetStatement INT = 0,
	@LinkServer VARCHAR(50),
	@DB VARCHAR(30),
	@DB_Sec VARCHAR(30)
AS
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	SET XACT_ABORT ON;


	DECLARE @SQL NVARCHAR(MAX), @ColumnNames NVARCHAR(MAX), @ID NVARCHAR(100), @Date NVARCHAR(100), @CurrentDate DATETIME
	


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

		IF(@GetStatement = 0 OR @GetStatement = 1 OR @GetStatement = 2)
		BEGIN
			IF(@SrcBSacctId IS NOT NULL AND @SrcBSacctId <> 0)
			BEGIN
				SET @SrcBSacctId = @SrcBSacctId
			END
			ELSE IF(@SrcAccountNumber IS NOT NULL AND @SrcAccountNumber <> '')
			BEGIN
				SET @ID = TRY_CAST(@SrcAccountNumber AS NVARCHAR(19))
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @SrcBSacctId OUTPUT
				SET @SrcBSacctId = @SrcBSacctId
			END
			ELSE IF(@SrcAccountUUID IS NOT NULL AND @SrcAccountUUID <> '')
			BEGIN
				SET @ID = TRY_CAST(@SrcAccountUUID AS NVARCHAR(64))
				--PRINT @ID
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @SrcBSacctId OUTPUT
				SET @SrcBSacctId = @SrcBSacctId
			END
			ELSE
			BEGIN
				SELECT 'AccountID, AccountNumber or  AccountUUID MUST BE PASSED' ErrorMessage
				RETURN
			END

			IF(@SrcBSacctId IS NULL OR @SrcBSacctId = 0)
			BEGIN
				SELECT 'INVALID SOURCE ACCOUNT IDENTIFIER' ErrorMessage
				RETURN
			END

			IF(@DestBSacctId IS NOT NULL AND @DestBSacctId <> 0)
			BEGIN
				SET @DestBSacctId = @DestBSacctId
			END
			ELSE IF(@DestAccountNumber IS NOT NULL AND @DestAccountNumber <> '')
			BEGIN
				SET @ID = TRY_CAST(@DestAccountNumber AS NVARCHAR(19))
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @DestBSacctId OUTPUT
				SET @DestBSacctId = @DestBSacctId
			END
			ELSE IF(@DestAccountUUID IS NOT NULL AND @DestAccountUUID <> '')
			BEGIN
				SET @ID = TRY_CAST(@DestAccountUUID AS NVARCHAR(64))
				--PRINT @ID
				SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID =  @ID'
				--PRINT @SQL
				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @DestBSacctId OUTPUT
				SET @DestBSacctId = @DestBSacctId
			END
			ELSE
			BEGIN
				SELECT 'AccountID, AccountNumber or  AccountUUID MUST BE PASSED' ErrorMessage
				RETURN
			END

			IF(@DestBSacctId IS NULL OR @DestBSacctId = 0)
			BEGIN
				SELECT 'INVALID DESTINATION ACCOUNT IDENTIFIER' ErrorMessage
				RETURN
			END
		END

		--IF(@FromDate IS NULL OR @FromDate = '')
		--BEGIN
		--	SELECT 'FromDate cannot be blank' ErrorMessage
		--	RETURN
		--END
			
		--IF(@ToDate IS NULL OR @ToDate = '')
		--BEGIN
		--	SET @ToDate = dbo.PR_ISOGetBusinessTime()
		--END
		
		--IF(DATEDIFF(MONTH, @FromDate, @ToDate) > 2)
		--BEGIN
		--	SELECT 'Maximum 3 month data can be returned' ErrorMessage
		--	RETURN
		--END

		--IF(@FromDate >= @ToDate)
		--BEGIN
		--	SELECT 'ToDate must be greater than FromDate' ErrorMessage
		--	RETURN
		--END


		SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
			   			   	
		IF(@GetStatement = 0 OR @GetStatement = 2)
		BEGIN
			SET @ColumnNames = N'acctId, SH.StatementDate, SH.StatementID, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, CycleDueDTD, DateofTotalDue, 
				DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, MinimumPaymentDue, AmountOfTotalDue, AmtOfPayPastDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				DateOfOriginalPaymentDueDTD, BeginningBalance, WaiveMinDue, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD'
	
			SET @SQL = N'SELECT ''StatementHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.StatementHeader SH WITH(NOLOCK)
			WHERE  SH.acctID = @ID 
			AND SH.StatementDate BETWEEN @FromDate AND @ToDate
			ORDER BY SH.StatementDate DESC'

			PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate

		END
		
		IF(@GetStatement = 1 OR @GetStatement = 2)
		BEGIN
			SET @ColumnNames = N'SH.acctId, SH.StatementDate, SH.StatementID, CreditPlanType, OriginalPurchaseAmount, EqualPaymentAmt, CurrentBalance, CurrentBalanceCO, 
				decurrentbalance_trantime_ps, Principal, CycleDueDTD, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue AmtOfPayCurrDue, AmtOfPayXDLate,
				AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, 
				AmountOfPayment210DLate, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD, CreditBalanceMovement, 
				PayOffDate, LoanEndDate'
	
			SET @SQL = N'SELECT ''SummaryHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.SummaryHeader SH WITH(NOLOCK)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
			WHERE  SH.parent02AID = @ID 
			AND SH.StatementDate BETWEEN @FromDate AND @ToDate'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate
		END

		IF(@GetStatement = 3)
		BEGIN
			IF(@PlanID IS NULL OR @PlanID <= 0)
			BEGIN
				SELECT 'PlanID must be provided to fetch the summary of specific plan' ErrorMessage
				RETURN
			END

			SET @ID = TRY_CAST(@PlanID AS NVARCHAR)

			SET @ColumnNames = N'SH.acctId, SH.StatementDate, SH.StatementID, CreditPlanType, OriginalPurchaseAmount, EqualPaymentAmt, CurrentBalance, CurrentBalanceCO, 
				decurrentbalance_trantime_ps, Principal, CycleDueDTD, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue AmtOfPayCurrDue, AmtOfPayXDLate,
				AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, 
				AmountOfPayment210DLate, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD, CreditBalanceMovement, 
				PayOffDate, LoanEndDate'
	
			SET @SQL = N'SELECT ''SummaryHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.SummaryHeader SH WITH(NOLOCK)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
			WHERE  SH.parent02AID = @ID 
			AND SH.StatementDate BETWEEN @FromDate AND @ToDate'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate
		END


	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END