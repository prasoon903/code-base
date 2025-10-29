--EXEC USP_DelinquencyRecordsDetails @TranID = 9062, @GetRecords = 2, @LinkServer = 'XEON-S8', @DB = 'PP_CI'
USE PP_CI
GO
CREATE OR ALTER PROCEDURE USP_DelinquencyRecordsDetails
	@TranID DECIMAL(19,0) = 0,
	@GetRecords INT = 0,
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

		

		IF(@TranID IS NULL OR @TranID <= 0)
		BEGIN
			SELECT 'INVALID TranID' ErrorMessage
			RETURN
		END
		ELSE
		BEGIN
			SET @TID = TRY_CAST(@TranID AS NVARCHAR(100))
					   
			IF(@GetRecords = 0 OR @GetRecords = 2)
			BEGIN
				SET @ColumnNames = N'TranId,AmountOfTotalDue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
									AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,
									AmountOfPayment210DLate,NumberOfPaymentPastDue,NumberOfPayment30DLate,NumberOfPayment60DLate,NumberOfPayment90DLate,
									NumberOfPayment120DLate,NumberOfPayment150DLate,NumberOfPayment180DLate,NumberOfPayment210DLate,JobDate,
									ReversalFlag,TransactionAmount,TranTime,AccountNumber,daysdelinquent,acctId'
	
				SET @SQL = N'SELECT ''DelinquencyRecord'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB + '.dbo.DelinquencyRecord P WITH(NOLOCK)
				WHERE P.TranId = @TID'

				--PRINT(@SQL)
	
				EXECUTE SP_EXECUTESQL @SQL, N'@TID NVARCHAR(100)', @TID=@TID
			END

			IF(@GetRecords = 1 OR @GetRecords = 2)
			BEGIN
				SET @ColumnNames = N'acctId,parent02AID,TranId,TranRef,TransactionAmount,AmountOfTotalDue,AmtOfPayCurrDue,ReversalFlag,
									JobDate,TranTime,AccountNumber,NoBlobIndicator,LastStatementDate,AmtOfPayXDLate,AmountOfPayment30DLate,
									AmountOfPayment60DLate,AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,
									AmountOfPayment210DLate,NumberOfPaymentPastDue,NumberOfPayment30DLate,NumberOfPayment60DLate,NumberOfPayment90DLate,
									NumberOfPayment120DLate,NumberOfPayment150DLate,NumberOfPayment180DLate,NumberOfPayment210DLate,TypeOfReage,
									AutoReagePlan,RedistributionFlag'
	
				SET @SQL = N'SELECT ''PlanDelinquencyRecord'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB + '.dbo.PlanDelinquencyRecord P WITH(NOLOCK)
				WHERE P.TranRef = @TID'

				--PRINT(@SQL)
	
				EXECUTE SP_EXECUTESQL @SQL, N'@TID NVARCHAR(100)', @TID=@TID
			END
		END

	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END