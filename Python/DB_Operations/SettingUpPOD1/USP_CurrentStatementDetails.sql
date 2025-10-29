--EXEC USP_CurrentStatementDetails @BSacctId = 2829633, @GetStatement = 3, @PlanID = 0, @LinkServer = 'XEON-S8', @DB = 'PP_CI', @FromDate = '2020-07-31 23:59:57.000', @ToDate = '2020-09-30 23:59:57.000'
USE PP_CI
GO

CREATE OR ALTER PROCEDURE USP_CurrentStatementDetails
	@BSacctId INT = 0,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@PlanID INT = 0,	
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL,
	@GetStatement INT = 1,
	@LinkServer VARCHAR(50),
	@DB VARCHAR(30),
	@DB_Sec VARCHAR(30) = NULL
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

		IF(@GetStatement <> 1 AND @GetStatement <> 2)
		BEGIN
			SELECT 'Please Provide the valid value for GetStatement (1- For AccountLevel\2- For PlanLevel)' AS ErrorMessage
			RETURN
		END

		IF(@GetStatement = 1)
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

		IF(@FromDate IS NULL OR @FromDate = '')
		BEGIN
			SELECT 'FromDate cannot be blank' ErrorMessage
			RETURN
		END
			
		IF(@ToDate IS NULL OR @ToDate = '')
		BEGIN
			SET @ToDate = dbo.PR_ISOGetBusinessTime()
		END
		
		IF(DATEDIFF(MONTH, @FromDate, @ToDate) > 2)
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
			   			   	
		IF(@GetStatement = 1)
		BEGIN
			SET @ColumnNames = N'acctId,BeginningBalance,CurrentBalance,StatementDate,ccinhparent101AID,LateChargesCTD,DateOfOriginalPaymentDueDTD,
								AmountOfTotalDue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,AmountOfPayment90DLate,
								AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfPaymentsDTD,
								ReageStatus,AmountOfPayments_InCycle,PaymentDuringReageCTD,TCAPStatusNew,AmtOfCrAdjSRBCTD,AmtOfCrAdjMSBCTD,
								ProgramStatus,IntWaiveForSCRA,IsAcctSCRA,CBRAmountOfCurrentBalance,CBRAmountOfHighBalance'
	
			SET @SQL = N'SELECT ''CurrentStatementHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CurrentStatementHeader SH WITH(NOLOCK)
			WHERE  SH.acctID = @ID 
			AND SH.StatementDate BETWEEN @FromDate AND @ToDate
			ORDER BY SH.StatementDate DESC'

			PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate

		END

		IF(@GetStatement = 2)
		BEGIN
			IF(@PlanID IS NULL OR @PlanID <= 0)
			BEGIN
				SELECT 'PlanID must be provided to fetch the summary of specific plan' ErrorMessage
				RETURN
			END

			SET @ID = TRY_CAST(@PlanID AS NVARCHAR)

			SET @ColumnNames = N'acctId,StatementID,AmtOfInterestCTD,StatementDate,BeginningBalance,CurrentBalance,Principal,latefeesbnp,NSFFeesBilledNotPaid,
								insurancefeesbnp,servicefeesbnp,MembershipFeesBNP,recoveryfeesbnp,collectionfeesbnp,overlimitbnp,IntBilledNotPaid,
								BeginningBalanceUpdate,HoldWaivedInterest,ChargedInterestRevolving,ChargedNewTxnInterest,HoldNewTxnInterest,
								AmountOfTotalDue,CurrentDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,AmountOfPayment90DLate,
								AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfPaymentsCTD,
								AmountOfCreditsCTD,BackDatedPayments,BackCredit1CPDAmt,PurchaseReversalFlag,InterestAtCycle,MIChargedBucket,
								WaivedInterestCredit,GraceCutoffDate,PrevCycleFCCredit,GraceDaysStatus,AccountGraceStatus,NewTransactionsAgg,
								RevolvingAgg,TrailingInterestDate'
	
			SET @SQL = N'SELECT ''CurrentSummaryHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CurrentSummaryHeader SH WITH(NOLOCK)
			WHERE  SH.acctId = @ID 
			AND SH.StatementDate BETWEEN @FromDate AND @ToDate'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @FromDate DATETIME, @ToDate DATETIME', @ID=@ID, @FromDate=@FromDate,@ToDate=@ToDate
		END


	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END