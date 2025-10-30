--EXEC USP_AccountDetails @AccountNumber = '1150001100411390', @AccountData = 0, @CPSData = 1
--EXEC USP_AccountDetails @AccountNumber = '1150001100411390'


CREATE OR ALTER PROCEDURE USP_AccountDetails
	@BSacctId INT = 0,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@LastStatementDate DATETIME = NULL, 
	@Businessday DATETIME = NULL,
	@AccountData INT = 1,
	@CPSData INT = 0,
	@CCARD INT = 0, 
	@EOD_AIR INT = 0, 
	@EOD_PIR INT = 0, 
	@Statement INT = 0,
	@Summary INT = 0,
	@LinkServer VARCHAR(50) = '',
	@DB VARCHAR(30) = '',
	@DB_Sec VARCHAR(30) = ''
AS
BEGIN

	--Author :: PRASOON PARASHAR

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	SET XACT_ABORT ON;


	DECLARE @SQL NVARCHAR(MAX), @ColumnNames NVARCHAR(MAX), @ID NVARCHAR(100), @Date NVARCHAR(100), @CurrentDate DATETIME, @LastDate DATETIME

	SET @LinkServer = ''
	SET @DB = ''
	SET @DB_Sec = ''
	


	BEGIN TRY
				
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
		
		SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)


		IF(@AccountData = 1)
		BEGIN
			SET @ColumnNames = N'
					TRY_CONVERT(VARCHAR(100), BP.acctId, 20) acctId, 
					LTRIM(RTRIM(AccountNumber)) AccountNumber, 
					BP.UniversalUniqueID,
					TRY_CONVERT(VARCHAR(100), BP.DateAcctOpened, 20) DateAcctOpened,
					TRY_CONVERT(VARCHAR(100), BP.LastStatementDate, 20) LastStatementDate,
					TRY_CONVERT(VARCHAR(100), BP.SystemStatus, 20) SystemStatus,
					TRY_CONVERT(VARCHAR(100), BP.CCINHPARENT125AID, 20) CCINHPARENT125AID,
					TRY_CONVERT(VARCHAR(100), BP.CurrentBalance, 20) CurrentBalance,
					TRY_CONVERT(VARCHAR(100), BC.CurrentBalanceCO, 20) CurrentBalanceCO,
					TRY_CONVERT(VARCHAR(100), decurrentbalance_trantime_ps, 20),
					TRY_CONVERT(VARCHAR(100), BP.Principal, 20) Principal,
					TRY_CONVERT(VARCHAR(100), BC.PrincipalCO, 20) PrincipalCO,
					TRY_CONVERT(VARCHAR(100), BP.CycleDueDTD, 20) CycleDueDTD,
					TRY_CONVERT(VARCHAR(100), BC.DateOfTotalDue, 20) DateOfTotalDue,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfTotalDue, 20) AmountOfTotalDue,
					TRY_CONVERT(VARCHAR(100), BP.AmtOfPayCurrDue, 20) AmtOfPayCurrDue,
					TRY_CONVERT(VARCHAR(100), BC.AmtOfPayXDLate, 20) AmtOfPayXDLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment30DLate, 20) AmountOfPayment30DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment60DLate, 20) AmountOfPayment60DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment90DLate, 20) AmountOfPayment90DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment120DLate, 20) AmountOfPayment120DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment150DLate, 20) AmountOfPayment150DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment180DLate, 20) AmountOfPayment180DLate,
					TRY_CONVERT(VARCHAR(100), BC.AmountOfPayment210DLate, 20) AmountOfPayment210DLate,
					TRY_CONVERT(VARCHAR(100), BC.RunningMinimumDue, 20) RunningMinimumDue,
					TRY_CONVERT(VARCHAR(100), BC.RemainingMinimumDue, 20) RemainingMinimumDue,
					TRY_CONVERT(VARCHAR(100), BC.SRBWithInstallmentDue, 20) SRBWithInstallmentDue,
					TRY_CONVERT(VARCHAR(100), BB.AmtOfCrAdjMSBCTD, 20) AmtOfCrAdjMSBCTD,
					TRY_CONVERT(VARCHAR(100), BB.LateFeePBNP, 20) LateFeePBNP,
					TRY_CONVERT(VARCHAR(100), BC.IntBilledNotPaid, 20) IntBilledNotPaid,
					TRY_CONVERT(VARCHAR(100), BC.DtOfLastDelinqCTD, 20) DtOfLastDelinqCTD,
					TRY_CONVERT(VARCHAR(100), BC.DateOfOriginalPaymentDueDTD, 20) DateOfOriginalPaymentDueDTD,
					TRY_CONVERT(VARCHAR(100), BC.daysdelinquent, 20) daysdelinquent,
					TRY_CONVERT(VARCHAR(100), BC.NoPayDaysDelinquent, 20) NoPayDaysDelinquent,
					TRY_CONVERT(VARCHAR(100), AmtOfAcctHighBalLTD, 20) AmtOfAcctHighBalLTD,
					TRY_CONVERT(VARCHAR(100), DisputesAmtNS, 20) DisputesAmtNS,
					TRY_CONVERT(VARCHAR(100), AmountofCreditsCTD, 20) AmountofCreditsCTD,
					TRY_CONVERT(VARCHAR(100), AmountOfPaymentsCTD, 20) AmountOfPaymentsCTD'
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
			SET @ColumnNames = N'
			TRY_CONVERT(VARCHAR(100), CPS.acctId, 20) acctId,
			TRY_CONVERT(VARCHAR(100), CPS.parent02AID, 20) parent02AID,
			TRY_CONVERT(VARCHAR(100), CreditPlanType, 20) CreditPlanType,
			TRY_CONVERT(VARCHAR(100), PlanSegCreateDate, 20) PlanSegCreateDate,
			TRY_CONVERT(VARCHAR(100), CL.LutDescription, 20) PlanType,
			TRY_CONVERT(VARCHAR(100), CPC.PlanUUID, 20) PlanUUID,
			TRY_CONVERT(VARCHAR(100), CPC.OriginalPurchaseAmount, 20) OriginalPurchaseAmount,
			TRY_CONVERT(VARCHAR(100), EqualPaymentAmt, 20) EqualPaymentAmt, 
			TRY_CONVERT(VARCHAR(100), CurrentBalance, 20) CurrentBalance,
			TRY_CONVERT(VARCHAR(100), CurrentBalanceCO, 20) CurrentBalanceCO,
			TRY_CONVERT(VARCHAR(100), decurrentbalance_trantime_ps, 20) decurrentbalance_trantime_ps,
			TRY_CONVERT(VARCHAR(100), Principal, 20) Principal,
			TRY_CONVERT(VARCHAR(100), PrincipalCO, 20) PrincipalCO,
			TRY_CONVERT(VARCHAR(100), CycleDueDTD, 20) CycleDueDTD,
			TRY_CONVERT(VARCHAR(100), AmountOfTotalDue, 20) AmountOfTotalDue,
			TRY_CONVERT(VARCHAR(100), AmtOfPayCurrDue, 20) AmtOfPayCurrDue,
			TRY_CONVERT(VARCHAR(100), AmtOfPayXDLate, 20) AmtOfPayXDLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment30DLate, 20) AmountOfPayment30DLate,
			TRY_CONVERT(VARCHAR(100), CPC.AmountOfPayment60DLate, 20) AmountOfPayment60DLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment90DLate, 20) AmountOfPayment90DLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment120DLate, 20) AmountOfPayment120DLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment150DLate, 20) AmountOfPayment150DLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment180DLate, 20) AmountOfPayment180DLate,
			TRY_CONVERT(VARCHAR(100), AmountOfPayment210DLate, 20) AmountOfPayment210DLate,
			TRY_CONVERT(VARCHAR(100), SRBWithInstallmentDue, 20) SRBWithInstallmentDue,
			TRY_CONVERT(VARCHAR(100), EstimatedDue, 20) EstimatedDue,
			TRY_CONVERT(VARCHAR(100), RolloverDue, 20) RolloverDue,
			TRY_CONVERT(VARCHAR(100), CPS.DisputesAmtNS, 20) DisputesAmtNS,
			TRY_CONVERT(VARCHAR(100), AmountOfCreditsCTD, 20) AmountOfCreditsCTD,
			TRY_CONVERT(VARCHAR(100), AmountOfPaymentsCTD, 20) AmountOfPaymentsCTD,
			TRY_CONVERT(VARCHAR(100), MergeDate, 20) MergeDate,
			TRY_CONVERT(VARCHAR(100), MergeIndicator, 20) MergeIndicator,
			TRY_CONVERT(VARCHAR(100), intbillednotpaid, 20) intbillednotpaid'	
			SET @SQL = N'SELECT ''CPSgment'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
			JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
			LEFT JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPS.creditplantype AND CL.LUTid = ''CPMCrPlanType'')
			WHERE  CPS.parent02AID = @ID'

			PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END

	
		IF(@Statement = 1)
		BEGIN
			SET @ColumnNames = N'acctId, SH.StatementDate, SH.StatementID, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, CycleDueDTD, DateofTotalDue, 
				DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, MinimumPaymentDue, AmountOfTotalDue, AmtOfPayPastDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
				AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
				DateOfOriginalPaymentDueDTD, BeginningBalance, WaiveMinDue, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD'
	
			IF(@LastStatementDate IS NOT NULL)
			BEGIN
				SET @SQL = N'SELECT ''StatementHeader'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.StatementHeader SH WITH(NOLOCK)
				WHERE  SH.acctID = @ID 
				AND StatementDate = @Date'
			END
			ELSE
			BEGIN
				SET @SQL = N'SELECT TOP 1 ''StatementHeader'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.StatementHeader SH WITH(NOLOCK)
				WHERE  SH.acctID = @ID
				ORDER BY StatementDate DESC'
			END

			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastStatementDate

		END
		
		IF(@Summary = 1)
		BEGIN
			SET @ColumnNames = N'SH.acctId, SH.StatementDate, SH.StatementID, CreditPlanType, OriginalPurchaseAmount, EqualPaymentAmt, CurrentBalance, CurrentBalanceCO, 
				decurrentbalance_trantime_ps, Principal, CycleDueDTD, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue AmtOfPayCurrDue, AmtOfPayXDLate,
				AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, 
				AmountOfPayment210DLate, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD, CreditBalanceMovement, 
				PayOffDate, LoanEndDate'
	
			IF(@LaststatementDate IS NOT NULL)
			BEGIN
				SET @SQL = N'SELECT ''SummaryHeader'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.SummaryHeader SH WITH(NOLOCK)
				JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
				WHERE  SH.parent02AID = @ID 
				AND SH.StatementDate = @Date'
			END
			ELSE
			BEGIN
				SET @SQL = N'SELECT ''SummaryHeader'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB_Sec + '.dbo.SummaryHeader SH WITH(NOLOCK)
				JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
				WHERE  SH.parent02AID = @ID 
				ORDER BY StatementDate Desc'
			END


			--PRINT(@SQL)

	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastStatementDate
		END


		IF(@CCARD = 1)
		BEGIN
			
			SET @CurrentDate = dbo.PR_ISOGetBusinessTime()
			IF(@LastStatementDate IS NOT NULL)
			BEGIN
				IF(DATEDIFF(MONTH, @LastStatementDate, @CurrentDate) > 3)
				BEGIN
					SELECT 'Maximum 3 month data can be returned' ErrorMessage
					RETURN
				END
			END
			ELSE
			BEGIN	
				select @LastDate = (DATEADD(MONTH, -3, @CurrentDate))
				--print(@LastDate)
				--print(@CurrentDate)
			END

			SET @ColumnNames = N'BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, CP.creditplanmaster, 
				EqualPayments, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
				CP.MemoIndicator,CP.RevTgt, TransactionDescription, NoblobIndicator, NoblobIndicatorGEN, CP.DateTimeLocalTransaction'


			IF(@Laststatementdate IS NOT NULL)
			BEGIN
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

				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date=@LastStatementDate
			END
			ELSE
			BEGIN
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

				EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @Date DATETIME', @ID=@ID, @Date = @LastDate
			END
				

			--PRINT(@SQL)

	
			
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