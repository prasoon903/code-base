
CREATE OR ALTER  
	@BSacctId INT = NULL,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL,
	@LastSatementDate DATETIME = NULL, 
	@Businessday DATETIME = NULL, 
	@CCARD INT = NULL, 
	@EOD INT = NULL, 
	@Statement INT = NULL


SET NOCOUNT ON;
SET XACT_ABORT ON
SET ARITHABORT ON



SET @BSacctId = 2829233
SET @AccountNumber = ''
SET @AccountUUID = ''
SET @LastSatementDate = '2020-09-16 23:59:57.000'
SET @Businessday = '2020-09-16 23:59:57.000'


BEGIN TRY

	IF(@BSacctId IS NOT NULL AND @BSacctId <> 0)
	BEGIN
		SET @BSacctId = @BSacctId
	END
	ELSE IF(@AccountNumber IS NOT NULL AND @AccountNumber <> '')
	BEGIN
		SELECT @BSacctId = acctID FROM dbo.Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber = @AccountNumber
	END
	ELSE IF(@AccountUUID IS NOT NULL AND @AccountUUID <> '')
	BEGIN
		SELECT @BSacctId = acctID FROM dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = @AccountUUID
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

	IF(@Statement = 1 OR @CCARD = 1)
	BEGIN
		IF(@LastSatementDate IS NULL OR @LastSatementDate = '')
		BEGIN
			SELECT 'LastSatementDate CANNOT BE BLANK WHEN Statement OR CCARD DATA IS REQUIRED' ErrorMessage
			RETURN
		END
	END

	IF(@EOD = 1)
	BEGIN
		IF(@Businessday IS NULL OR @Businessday = '')
		BEGIN
			SELECT 'Businessday CANNOT BE BLANK WHEN EOD DATA IS REQUIRED' ErrorMessage
			RETURN
		END
	END

	SELECT 'BSegment' [Table], BP.acctId, LTRIM(RTRIM(AccountNumber)) AccountNumber, BP.UniversalUniqueID, BP.MergeInProcessPH, BP.DateAcctOpened, BP.BillingCycle, BP.LastStatementDate,
			BP.SystemStatus, BP.CCINHPARENT125AID, BP.CurrentBalance, BC.CurrentBalanceCO, decurrentbalance_trantime_ps, BP.Principal, BC.PrincipalCO, BP.CycleDueDTD, BC.DateOfTotalDue,
			BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate, BC.AmountOfPayment90DLate, 
			BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate, BC.RunningMinimumDue, BC.RemainingMinimumDue, 
			BC.SRBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BB.LateFeePBNP, BC.IntBilledNotPaid, BC.DtOfLastDelinqCTD, BC.DateOfOriginalPaymentDueDTD, BC.daysdelinquent, 
			BC.NoPayDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason, AmtOfAcctHighBalLTD, DisputesAmtNS, AmountofCreditsCTD, AmountOfPaymentsCTD
		FROM dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
		JOIN dbo.BSEGMENTCREDITCARD BC WITH(NOLOCK) ON (BP.ACCTID = BC.ACCTID)
		JOIN dbo.BSEGMENT_balances BB WITH(NOLOCK) ON (BC.ACCTID = BB.ACCTID)
		JOIN dbo.BSEGMENT_Secondary BS WITH(NOLOCK) ON (BB.ACCTID = BS.ACCTID)
		WHERE  BP.acctid = @BSacctId

	SELECT 'CPSgment' [Table], CPS.acctId, CPS.parent02AID, CreditPlanType, PlanSegCreateDate, CL.LutDescription PlanType, CPC.PlanUUID, CPC.OriginalPurchaseAmount, EqualPaymentAmt, 
			CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, PrincipalCO, CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
			CPC.AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
			SRBWithInstallmentDue, EstimatedDue, RolloverDue, CPS.DisputesAmtNS, AmountOfCreditsCTD, AmountOfPaymentsCTD, MergeDate, MergeIndicator, intbillednotpaid
		FROM dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
		JOIN dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
		LEFT JOIN dbo.CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPS.creditplantype AND CL.LUTid = 'CPMCrPlanType')
		WHERE  CPS.parent02AID = @BSacctId

	IF(@Statement = 1)
	BEGIN
		SELECT 'StatementHeader' [Table], acctId, SH.StatementDate, SH.StatementID, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, decurrentbalance_trantime_ps, Principal, CycleDueDTD, DateofTotalDue, 
					DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, MinimumPaymentDue, AmountOfTotalDue, AmtOfPayPastDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
					AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
					DateOfOriginalPaymentDueDTD, BeginningBalance, WaiveMinDue, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD
				FROM dbo.StatementHeader SH WITH(NOLOCK)
				WHERE  SH.acctID = @BSacctId 
				AND StatementDate = @LastSatementDate

		SELECT 'SummaryHeader' [Table], SH.acctId, SH.StatementDate, SH.StatementID, CreditPlanType, OriginalPurchaseAmount, EqualPaymentAmt, CurrentBalance, CurrentBalanceCO, 
					decurrentbalance_trantime_ps, Principal, CycleDueDTD, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue AmtOfPayCurrDue, AmtOfPayXDLate,
					AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, 
					AmountOfPayment210DLate, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, AmountOfDebitsRevCTD, AmountOfCreditsRevCTD, CreditBalanceMovement, 
					PayOffDate, LoanEndDate
				FROM dbo.SummaryHeader SH WITH(NOLOCK)
				JOIN dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
				WHERE  SH.parent02AID = @BSacctId 
				AND SH.StatementDate = @LastSatementDate
	END 

	IF(@CCARD = 1)
	BEGIN
		SELECT 'CCard' [Table], BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, 
					EqualPayments, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
					CP.MemoIndicator,CP.RevTgt, TransactionDescription, NoblobIndicator, NoblobIndicatorGEN
				FROM dbo.CCard_Primary CP WITH(NOLOCK)
				LEFT JOIN dbo.CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
				LEFT JOIN dbo.CPMAccounts CPM WITH(NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId)
				WHERE  CP.AccountNumber = 
				(SELECT AccountNumber FROM dbo.BSegment_Primary WITH(NOLOCK) WHERE acctId = @BSacctId) 
				AND  CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR') 
				AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR', 'MMRMD', 'ReageTot')) 
				AND CP.TxnSource NOT IN ('4','10') 
				AND CP.MemoIndicator IS NULL 
				AND (CP.ArTxnType <> '93' OR CP.ArTxnType IS NULL)
				AND CP.PostTime >= @LastSatementDate
	END

	IF(@EOD = 1)
	BEGIN
		SELECT 'AIR' [Table], BSacctId, BusinessDay, SystemStatus, CCINHPARENT125AID, CurrentBalance, CurrentBalanceCO, Principal, CycleDueDTD, DateofTotalDue, 
					DateOfNextStmt, LastStatementDate, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
					AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
					DateOfOriginalPaymentDueDTD, BeginningBalance, AmountOfDebitsCTD,AmountOfCreditsCTD, TotalDaysDelinquent, DaysDelinquent
				FROM dbo.AccountInfoForReport AIR WITH(NOLOCK)
				WHERE  AIR.BSAcctId = @BSacctId 
				AND BusinessDay = @LastSatementDate



		SELECT 'PIR' [Table], BSacctId, CPSAcctID, BusinessDay, CurrentBalance, CurrentBalanceCO, Principal, CycleDueDTD, 
					SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate,AmountOfPayment30DLate, 
					AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
					BeginningBalance, IntBilledNotPaid
				FROM dbo.PlanInfoForReport PIR WITH(NOLOCK)
				WHERE  PIR.CPSAcctId IN 
				(SELECT acctID FROM dbo.CPSgmentAccounts WITH(NOLOCK) WHERE parent02AID = @BSacctId)
				AND BusinessDay = @LastSatementDate
	END
END TRY
BEGIN CATCH
		SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
END CATCH
