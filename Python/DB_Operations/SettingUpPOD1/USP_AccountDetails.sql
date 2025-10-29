--EXEC USP_AccountDetails @BSacctId = 0, @LinkServer = 'XEON-S8', @DB = 'PP_CI'
USE PP_CI
GO

CREATE OR ALTER PROCEDURE USP_AccountDetails
	@BSacctId INT,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@LastSatementDate DATETIME = NULL, 
	@Businessday DATETIME = NULL,
	@AccountData INT = 1,
	@CPSData INT = 0,
	@CCARD INT = 0, 
	@EOD_AIR INT = 0, 
	@EOD_PIR INT = 0, 
	@Statement INT = 0,
	@Summary INT = 0,
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
		
		
		/*
		IF(@AccountData IN (0, 1) 
			AND @CPSData IN (0, 1)
			 AND @CCARD IN (0, 1)
			  AND @EOD_AIR IN (0, 1)
			   AND @EOD_PIR IN (0, 1)
			    AND @Statement IN (0, 1)
				 AND @Summary IN (0, 1))
		BEGIN
			PRINT 'NO ERROR IN VALUE'
		END
		ELSE
		BEGIN
			SELECT 'Please Provide the valid value for AccountData\CPSData\CCARD\EOD_AIR\EOD_PIR\Statement\Summary (0- Data not required\1- Data required)' AS ErrorMessage
			RETURN
		END
		*/
		
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

		IF(@Statement = 1 OR @Summary = 1 OR @CCARD = 1)
		BEGIN
			IF(@LastSatementDate IS NULL OR @LastSatementDate = '')
			BEGIN
				SELECT 'LastSatementDate CANNOT BE BLANK WHEN Statement OR CCARD DATA IS REQUIRED' ErrorMessage
				RETURN
			END
		END

		IF(@EOD_AIR = 1 OR @EOD_PIR = 1)
		BEGIN
			IF(@Businessday IS NULL OR @Businessday = '')
			BEGIN
				SELECT 'Businessday CANNOT BE BLANK WHEN EOD DATA IS REQUIRED' ErrorMessage
				RETURN
			END
		END

		SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)


		IF(@AccountData = 1)
		BEGIN
			SET @ColumnNames = N'BP.acctId, LTRIM(RTRIM(AccountNumber)) AccountNumber, LAD, LAPD, NAD, BP.UniversalUniqueID, BP.MergeInProcessPH, BP.DateAcctOpened, BP.BillingCycle, BP.LastStatementDate,
				BP.SystemStatus, BP.CCINHPARENT125AID, BP.CurrentBalance, BC.CurrentBalanceCO, decurrentbalance_trantime_ps, BP.Principal, BC.PrincipalCO, BP.CycleDueDTD, BC.DateOfTotalDue,
				BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate, BC.AmountOfPayment90DLate, 
				BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate, BC.RunningMinimumDue, BC.RemainingMinimumDue, 
				BC.SRBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BB.LateFeePBNP, BC.IntBilledNotPaid, BC.DtOfLastDelinqCTD, BC.DateOfOriginalPaymentDueDTD, BC.daysdelinquent, 
				BC.NoPayDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason, AmtOfAcctHighBalLTD, DisputesAmtNS, AmountofCreditsCTD, AmountOfPaymentsCTD'
	
			SET @SQL = N'SELECT ''BSegment'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.BSEGMENTCREDITCARD BC WITH(NOLOCK) ON (BP.ACCTID = BC.ACCTID)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.BSEGMENT_balances BB WITH(NOLOCK) ON (BC.ACCTID = BB.ACCTID)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.BSEGMENT_Secondary BS WITH(NOLOCK) ON (BB.ACCTID = BS.ACCTID)
			WHERE  BP.acctid = @ID'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END


		IF(@CPSData = 1)
		BEGIN
			SET @ColumnNames = N'CPS.acctId, CPS.parent02AID, CreditPlanType, PlanSegCreateDate, CL.LutDescription PlanType, CPC.PlanUUID, CPC.OriginalPurchaseAmount, EqualPaymentAmt, 
				CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, PrincipalCO, CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				CPC.AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				SRBWithInstallmentDue, EstimatedDue, RolloverDue, CPS.DisputesAmtNS, AmountOfCreditsCTD, AmountOfPaymentsCTD, MergeDate, MergeIndicator, intbillednotpaid'
	
			SET @SQL = N'SELECT ''CPSgment'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPS.creditplantype AND CL.LUTid = ''CPMCrPlanType'')
			WHERE  CPS.parent02AID = @ID'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END

	
		IF(@Statement = 1)
		BEGIN
			SET @ColumnNames = N'acctId, SH.StatementDate, SH.StatementID, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, CycleDueDTD, DateofTotalDue, 
				DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, MinimumPaymentDue, AmountOfTotalDue, AmtOfPayPastDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				DateOfOriginalPaymentDueDTD, BeginningBalance, WaiveMinDue, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD'
	
			SET @SQL = N'SELECT ''StatementHeader'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.StatementHeader SH WITH(NOLOCK)
			WHERE  SH.acctID = @ID 
			AND StatementDate = @Date'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastSatementDate

		END
		
		IF(@Summary = 1)
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
			AND SH.StatementDate = @Date'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastSatementDate
		END


		IF(@CCARD = 1)
		BEGIN
			
			SET @CurrentDate = dbo.PR_ISOGetBusinessTime()
			IF(DATEDIFF(MONTH, @LastSatementDate, @CurrentDate) > 3)
			BEGIN
				SELECT 'Maximum 3 month data can be returned' ErrorMessage
				RETURN
			END
			
			SET @ColumnNames = N'BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, CP.creditplanmaster, 
				EqualPayments, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
				CP.MemoIndicator,CP.RevTgt, TransactionDescription, NoblobIndicator, NoblobIndicatorGEN, CP.DateTimeLocalTransaction'
	
			SET @SQL = N'SELECT ''CCard'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Primary CP WITH(NOLOCK)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CPMAccounts CPM WITH(NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId)
			WHERE  CP.AccountNumber = 
			(SELECT AccountNumber FROM ' + @LINKSERVER + '.' + @DB + '.dbo.BSegment_Primary WITH(NOLOCK) WHERE acctId = @ID) 
			AND  CP.CMTTRANTYPE NOT IN (''HPOTB'',''PPR'',''MMR'') 
			AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN (''QNA'', ''*SCR'', ''MMRMD'', ''ReageTot'')) 
			AND CP.TxnSource NOT IN (''4'',''10'') 
			AND CP.MemoIndicator IS NULL 
			AND (CP.ArTxnType <> ''93'' OR CP.ArTxnType IS NULL)
			AND CP.PostTime >= @Date
			ORDER BY CP.PostTime DESC'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastSatementDate
		END


		IF(@EOD_AIR = 1)
		BEGIN
			SET @ColumnNames = N'BSacctId, BusinessDay, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, Principal, CycleDueDTD, DateofTotalDue, 
				DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				DateOfOriginalPaymentDueDTD, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, TotalDaysDelinquent, DaysDelinquent'
	
			SET @SQL = N'SELECT ''AIR'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.AccountInfoForReport AIR WITH(NOLOCK)
			WHERE  AIR.BSAcctId = @ID 
			AND BusinessDay = @Date'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@Businessday
		END

		IF(@EOD_PIR = 1)
		BEGIN
			SET @ColumnNames = N'BSacctId, CPSAcctID, BusinessDay, CurrentBalance, CurrentBalanceCO, Principal, CycleDueDTD, 
				SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				BeginningBalance, IntBilledNotPaid'
	
			SET @SQL = N'SELECT ''PIR'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.PlanInfoForReport PIR WITH(NOLOCK)
			WHERE  PIR.CPSAcctId IN 
			(SELECT acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CPSgmentAccounts WITH(NOLOCK) WHERE parent02AID = @ID)
			AND BusinessDay = @Date'

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@Businessday
		END


	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END