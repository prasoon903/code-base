--Statement which we have to create the summary
--DECLARE @Statement DATETIME = '2019-04-30 23:59:57.000' -- First Statement to generate
--DECLARE @Statement DATETIME = '2023-09-30 23:59:57.000' -- Second Statement to generate
--UPDATE AccountsOfPlanToReLink SET JobStatus = 1 WHERE JobStatus = 2

--SELECT * FROM AccountsOfPlanToReLink

--Need to execute scripts for 3 statement from '2023-07-31 23:59:57.000' to '2023-11-30 23:59:57.000'

--Change the FromDate sequentially
--1- '2023-07-31 23:59:57.000'
--2- '2023-08-31 23:59:57.000'
--3- '2023-09-30 23:59:57.000'
--4- '2023-10-31 23:59:57.000'
--5- '2023-11-30 23:59:57.000'

DECLARE @FromStatement DATETIME		 = '2023-07-31 23:59:57.000'
DECLARE @ToStatement DATETIME		 = '2023-11-30 23:59:57.000' -- DO NOT CHANGE THIS VALUE




DECLARE @Statement DATETIME

SET @Statement = @FromStatement

--DECLARE @AccountID INT = 12133817
--WHILE(@Statement <= @ToStatement)
--BEGIN
	PRINT(@Statement)

	IF EXISTS (SELECT TOP 1 1 FROM AccountsOfPlanToReLink WHERE JobStatus = 1)
	BEGIN
		DROP TABLE IF EXISTS #TempData
		;WITH Accounts
		AS
		(
			SELECT DISTINCT acctID FROM AccountsOfPlanToReLink WITH(NOLOCK) WHERE JobStatus = 1
		)
		, CTE
		AS
		(
			SELECT S.acctID, S.parent02AID
			FROM SummaryHeader S WITH (NOLOCK)
			JOIN Accounts A ON (S.parent02AID = A.acctID)
			WHERE StatementDate = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, @Statement)) AS VARCHAR))
			EXCEPT
			SELECT S.acctID, S.parent02AID
			FROM SummaryHeader S WITH (NOLOCK)
			JOIN Accounts A ON (S.parent02AID = A.acctID)
			WHERE StatementDate = @Statement
		)
		SELECT parent02AID, acctId, @Statement StatementDate, DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, @Statement)) AS VARCHAR)) PreviousStatementDate INTO #TempData FROM CTE
		--Print 'In Select';
	END

	IF EXISTS (SELECT TOP 1 1 FROM #TempData)
	BEGIN
		DROP TABLE IF EXISTS #PreviousSHData
		SELECT SH.* 
		INTO #PreviousSHData
		FROM #TempData T
		JOIN SummaryHeader SH WITH (NOLOCK) ON (T.acctID = SH.acctId AND T.PreviousStatementDate = SH.StatementDate)

		DROP TABLE IF EXISTS #PreviousSHCCData
		SELECT SHCC.*
		INTO #PreviousSHCCData
		FROM #PreviousSHData T
		JOIN SummaryHeaderCreditCard SHCC ON (T.acctID = SHCC.acctID AND T.StatementID = SHCC.StatementID)

		DROP TABLE IF EXISTS #PreviousCSHData
		SELECT CSH.*
		INTO #PreviousCSHData
		FROM #PreviousSHData T
		JOIN CurrentSummaryHeader CSH ON (T.acctID = CSH.acctID AND T.StatementID = CSH.StatementID)

		DROP TABLE IF EXISTS #StatementData
		SELECT T.*, SH.StatementID, SH.StatementHID, SH.LAD, SH.LAPD, SH.DateOfTotalDue 
		INTO #StatementData
		FROM #TempData T
		JOIN StatementHeader SH WITH (NOLOCK) ON (T.parent02AID = SH.acctId AND T.StatementDate = SH.StatementDate)

		--SELECT * FROM #PreviousSHData
		--SELECT * FROM #PreviousSHCCData
		--SELECT * FROM #PreviousCSHData
		--SELECT * FROM #StatementData

		UPDATE SH
		SET 
			StatementID = S.StatementID,
			StatementHID = S.StatementHID,
			LAD = S.LAD,
			LAPD = S.LAPD,
			StatementDate = S.StatementDate
		FROM #PreviousSHData SH
		JOIN #StatementData S ON (SH.acctId = S.acctID)

		UPDATE SH
		SET 
			StatementID = S.StatementID
		FROM #PreviousSHCCData SH
		JOIN #StatementData S ON (SH.acctId = S.acctID)

		UPDATE SH
		SET 
			StatementID = S.StatementID,
			StatementDate = S.StatementDate,
			GraceCutoffDate = S.DateOfTotalDue
		FROM #PreviousCSHData SH
		JOIN #StatementData S ON (SH.acctId = S.acctID)


		BEGIN TRY
		
			BEGIN TRANSACTION

				INSERT INTO SummaryHeader
				(StatementPHID
				, StatementHID
				, StatementID
				, acctId
				, ATID
				, rowClassifier
				, grpClassifier
				, LAD
				, LAPD
				, NAD
				, AccountBlob
				, StatementDate
				, parent01ATID
				, parent01AID
				, parent02ATID
				, parent02AID
				, parent03ATID
				, parent03AID
				, parent04ATID
				, parent04AID
				, parent05ATID
				, parent05AID
				, ccinhparent101ATID
				, ccinhparent101AID
				, ccinhparent102ATID
				, ccinhparent102AID
				, ccinhparent103ATID
				, ccinhparent103AID
				, ccinhparent104ATID
				, ccinhparent104AID
				, ccinhparent105ATID
				, ccinhparent105AID
				, ccinhparent106ATID
				, ccinhparent106AID
				, ccinhparent107ATID
				, ccinhparent107AID
				, ccinhparent108ATID
				, ccinhparent108AID
				, ccinhparent109ATID
				, ccinhparent109AID
				, ccinhparent110ATID
				, ccinhparent110AID
				, ccinhparent111ATID
				, ccinhparent111AID
				, ccinhparent116AID
				, ccinhparent116ATID
				, ccinhparent117AID
				, ccinhparent117ATID
				, ccinhparent118AID
				, ccinhparent118ATID
				, ccinhparent119AID
				, ccinhparent119ATID
				, ccinhparent120AID
				, ccinhparent120ATID
				, ccinhparent121AID
				, ccinhparent121ATID
				, ccinhparent122AID
				, ccinhparent122ATID
				, ccinhparent123AID
				, ccinhparent123ATID
				, ccinhparent124AID
				, ccinhparent124ATID
				, ccinhparent125AID
				, ccinhparent125ATID
				, ccinhparent126AID
				, ccinhparent126ATID
				, ccinhparent127AID
				, ccinhparent127ATID
				, ccinhparent128AID
				, ccinhparent128ATID
				, ccinhparent129AID
				, ccinhparent129ATID
				, ccinhparent130AID
				, ccinhparent130ATID
				, OnBSFChargeOf
				, pmtconsplanmaster
				, InterestStartDate
				, plansegcreatedate
				, grandfathereffdate
				, PrimaryCurrencyCode
				, SecondaryCurrencyCode
				, BaseSegmentAid
				, SummaryType
				, StatementFlag
				, lastupdate
				, NumberOfDebitsCTD
				, NumberOfDebitsLTD
				, AmountOfDebitsCTD
				, AmountOfDebitsLTD
				, CashAdvancesNoCTD
				, CashAdvancesNoLTD
				, CashAdvancesAmtCTD
				, CashAdvancesAmtLTD
				, Principal
				, CurrentBalance
				, CashBalance
				, servicefeesbnp
				, ServiceChargeCTD
				, ServiceChargeLTD
				, NumberOfPurchasesCTD
				, NumberOfPurchasesLTD
				, AmountOfPurchasesCTD
				, AmountOfPurchasesLTD
				, NumberOfCreditsCTD
				, NumberOfCreditsLTD
				, AmountOfCreditsCTD
				, AmountOfCreditsLTD
				, NumberOfReturnsCTD
				, NumberOfReturnsLTD
				, AmountOfReturnsCTD
				, AmountOfReturnsLTD
				, BeginningBalance
				, AmountOfTotalDue
				, collectionfeesbnp
				, overlimitbnp
				, recoveryfeesbnp
				, IntBilledNotPaid
				, MembershipFeesBNP
				, insurancefeesbnp
				, planseghighbalctd
				, stmtbegbal
				, internalstmtbegbal
				, NSFFeesBilledNotPaid
				, latefeesbnp
				, AmtOfAcctHighBalLTD
				, NumberOfPaymentsCTD
				, NumberOfPaymentsLTD
				, AmountOfPaymentsCTD
				, AmountOfPaymentsLTD
				, AmtOfInterestCTD
				, AmtOfInterestLTD
				, AmtOfInterestYTD
				, MembershipFeesCTD
				, MembershipFeesLTD
				, MembershipFeesYTD
				, NoOfMembershipFeesCTD
				, NoOfMembershipFeesLTD
				, NoOfMembershipFeesYTD
				, AmtOfOvrLimitFeesCTD
				, AmtOfOvrLimitFeesLTD
				, AmtOfOvrLimitFeesYTD
				, NumberOfOverlimitFeesCTD
				, NumberOfOverlimitFeesLTD
				, NumberOfOverlimitFeesYTD
				, NSFFeesCTD
				, NSFFeesLTD
				, NSFFeesYTD
				, NumberOfNSFFeesCTD
				, NumberOfNSFFeesLTD
				, NumberOfNSFFeesYTD
				, RecoveryFeesCTD
				, RecoveryFeesLTD
				, NumberRecoveryFeesCTD
				, NumberRecoveryFeesLTD
				, NumberSChargesCTD
				, NumberSChargesLTD
				, DtOfAcctHighBalLTD
				, amtcaadvreturnsCTD
				, nocaadvreturnsCTD
				, amtcaadvreturnsLTD
				, nocaadvreturnsLTD
				, amtpsereturnsCTD
				, nopsereturnsCTD
				, amtpsereturnsLTD
				, nopsereturnsLTD
				, CollectionFeesCTD
				, NoOfCollectionFeesCTD
				, CollectionFeesLTD
				, NoOfCollectionFeesLTD
				, CollectionFeesYTD
				, NoOfCollectionFeesYTD
				, AmountOfChecksCTD
				, NumberOfChecksCTD
				, AmountOfChecksLTD
				, NumberOfChecksLTD
				, LateChargesCTD
				, NumberOfLateFeesCTD
				, LateChargesLTD
				, NumberOfLateFeesLTD
				, LateChargesYTD
				, NumberOfLateFeesYTD
				, nodispCTD
				, nodispLTD
				, amtdispCTD
				, amtdispLTD
				, CashAdvanceFeesCTD
				, CashAdvanceFeesLTD
				, NumberCashAdvFeesCTD
				, NumberCashAdvFeesLTD
				, InsuranceCTD
				, InsuranceLTD
				, InsuranceYTD
				, CpsFirstUsageDate
				, SystemStatus
				, PaymentStartDate
				, DaysInCycle
				, ChargeOffDate
				, InvoiceNo
				, DateOfDelinquency
				, AmtInterestCreditsCTD
				, NumberOfDebitsRevCTD
				, AmountOfDebitsRevCTD
				, NumberOfCreditsRevCTD
				, AmountOfCreditsRevCTD
				, DeInterestAdjustment
				, LateFeeAdjustment
				, DeCurrentBalance_TranTime_PS
				, InsuranceAdjustment
				, InvoiceNumber
				, AdditivesBal
				, accessID
				, RLSKey
				, CustomerId
				, typeofcard
				, AccountProperty
				, tpyNAD
				, tpyLAD
				, tpyBlob
				, AmtInterestCreditsCC1
				, AmtInterestCreditsCC2
				, AmtOfInterestCC1
				, AmtOfInterestCC2
				, AmtOfInterestCC3
				, AmtOfInterestCC4
				, AmtOfInterestCC5
				, AmtOfInterestCC6
				, AmtOfInterestCC7
				, AmtOfInterestCC8
				, AmtOfInterestCC9
				, AmtOfInterestCC10
				, DisbursementBal
				, FuelBal
				, MaintenanceBal
				, MiscBal
				, AmountSecDepCredit
				, AmountSecDepCreditLTD
				, AmountSecDepCreditMTD
				, AmountSecDepCreditYTD
				, CountSecDepCredit
				, CountSecDepCreditLTD
				, CountSecDepCreditMTD
				, CountSecDepCreditYTD
				, AmountSecDepDebit
				, AmountSecDepDebitLTD
				, AmountSecDepDebitMTD
				, AmountSecDepDebitYTD
				, CountSecDepDebit
				, CountSecDepDebitLTD
				, CountSecDepDebitMTD
				, CountSecDepDebitYTD
				, APR
				, BSFC
				, BSFCMethod
				, intplanoccurr
				, InterestRate1
				, InterestRate2
				, InterestRate3
				, InterestRate4
				, DeferredAccruedCTD
				, AggBalanceCTD
				, creditplantype
				, cpsinterestplan
				, DeferredIntAtExpCancel
				, SChargesAdjustment
				, ServiceChargeCC1
				, ServiceChargeCC2
				, ServiceChargeCC3
				, AmountOfPaymentsCC1
				, AmountOfPaymentsCC2
				, AmountOfPaymentsCC3
				, AmountOfPaymentsCC4
				, AmountOfPaymentsCC5
				, PaymentAdjustment
				, CreditPlanNumber
				, WaivedInterest
				, CounterForEqualPayment
				, ccinhparent136AID
				, ccinhparent136ATID
				, ccinhparent137AID
				, ccinhparent137ATID
				, ccinhparent138AID
				, ccinhparent138ATID
				, ccinhparent139AID
				, ccinhparent139ATID
				, ccinhparent140AID
				, ccinhparent140ATID
				, ccinhparent141AID
				, ccinhparent141ATID
				, ccinhparent142AID
				, ccinhparent142ATID
				, ccinhparent143AID
				, ccinhparent143ATID
				, ccinhparent144AID
				, ccinhparent144ATID
				, ccinhparent145AID
				, ccinhparent145ATID
				, ccinhparent146AID
				, ccinhparent146ATID
				, ccinhparent147AID
				, ccinhparent147ATID
				, BalanceTransfer_DTD
				, BalanceTransfer_CTD
				, BalanceTransfer_MTD
				, BalanceTransfer_YTD
				, BalanceTransfer_LTD)
				SELECT 
				StatementPHID
				, StatementHID
				, StatementID
				, acctId
				, ATID
				, rowClassifier
				, grpClassifier
				, LAD
				, LAPD
				, NAD
				, AccountBlob
				, StatementDate
				, parent01ATID
				, parent01AID
				, parent02ATID
				, parent02AID
				, parent03ATID
				, parent03AID
				, parent04ATID
				, parent04AID
				, parent05ATID
				, parent05AID
				, ccinhparent101ATID
				, ccinhparent101AID
				, ccinhparent102ATID
				, ccinhparent102AID
				, ccinhparent103ATID
				, ccinhparent103AID
				, ccinhparent104ATID
				, ccinhparent104AID
				, ccinhparent105ATID
				, ccinhparent105AID
				, ccinhparent106ATID
				, ccinhparent106AID
				, ccinhparent107ATID
				, ccinhparent107AID
				, ccinhparent108ATID
				, ccinhparent108AID
				, ccinhparent109ATID
				, ccinhparent109AID
				, ccinhparent110ATID
				, ccinhparent110AID
				, ccinhparent111ATID
				, ccinhparent111AID
				, ccinhparent116AID
				, ccinhparent116ATID
				, ccinhparent117AID
				, ccinhparent117ATID
				, ccinhparent118AID
				, ccinhparent118ATID
				, ccinhparent119AID
				, ccinhparent119ATID
				, ccinhparent120AID
				, ccinhparent120ATID
				, ccinhparent121AID
				, ccinhparent121ATID
				, ccinhparent122AID
				, ccinhparent122ATID
				, ccinhparent123AID
				, ccinhparent123ATID
				, ccinhparent124AID
				, ccinhparent124ATID
				, ccinhparent125AID
				, ccinhparent125ATID
				, ccinhparent126AID
				, ccinhparent126ATID
				, ccinhparent127AID
				, ccinhparent127ATID
				, ccinhparent128AID
				, ccinhparent128ATID
				, ccinhparent129AID
				, ccinhparent129ATID
				, ccinhparent130AID
				, ccinhparent130ATID
				, OnBSFChargeOf
				, pmtconsplanmaster
				, InterestStartDate
				, plansegcreatedate
				, grandfathereffdate
				, PrimaryCurrencyCode
				, SecondaryCurrencyCode
				, BaseSegmentAid
				, SummaryType
				, StatementFlag
				, lastupdate
				, NumberOfDebitsCTD
				, NumberOfDebitsLTD
				, AmountOfDebitsCTD
				, AmountOfDebitsLTD
				, CashAdvancesNoCTD
				, CashAdvancesNoLTD
				, CashAdvancesAmtCTD
				, CashAdvancesAmtLTD
				, Principal
				, CurrentBalance
				, CashBalance
				, servicefeesbnp
				, ServiceChargeCTD
				, ServiceChargeLTD
				, NumberOfPurchasesCTD
				, NumberOfPurchasesLTD
				, AmountOfPurchasesCTD
				, AmountOfPurchasesLTD
				, NumberOfCreditsCTD
				, NumberOfCreditsLTD
				, AmountOfCreditsCTD
				, AmountOfCreditsLTD
				, NumberOfReturnsCTD
				, NumberOfReturnsLTD
				, AmountOfReturnsCTD
				, AmountOfReturnsLTD
				, BeginningBalance
				, AmountOfTotalDue
				, collectionfeesbnp
				, overlimitbnp
				, recoveryfeesbnp
				, IntBilledNotPaid
				, MembershipFeesBNP
				, insurancefeesbnp
				, planseghighbalctd
				, stmtbegbal
				, internalstmtbegbal
				, NSFFeesBilledNotPaid
				, latefeesbnp
				, AmtOfAcctHighBalLTD
				, NumberOfPaymentsCTD
				, NumberOfPaymentsLTD
				, AmountOfPaymentsCTD
				, AmountOfPaymentsLTD
				, AmtOfInterestCTD
				, AmtOfInterestLTD
				, AmtOfInterestYTD
				, MembershipFeesCTD
				, MembershipFeesLTD
				, MembershipFeesYTD
				, NoOfMembershipFeesCTD
				, NoOfMembershipFeesLTD
				, NoOfMembershipFeesYTD
				, AmtOfOvrLimitFeesCTD
				, AmtOfOvrLimitFeesLTD
				, AmtOfOvrLimitFeesYTD
				, NumberOfOverlimitFeesCTD
				, NumberOfOverlimitFeesLTD
				, NumberOfOverlimitFeesYTD
				, NSFFeesCTD
				, NSFFeesLTD
				, NSFFeesYTD
				, NumberOfNSFFeesCTD
				, NumberOfNSFFeesLTD
				, NumberOfNSFFeesYTD
				, RecoveryFeesCTD
				, RecoveryFeesLTD
				, NumberRecoveryFeesCTD
				, NumberRecoveryFeesLTD
				, NumberSChargesCTD
				, NumberSChargesLTD
				, DtOfAcctHighBalLTD
				, amtcaadvreturnsCTD
				, nocaadvreturnsCTD
				, amtcaadvreturnsLTD
				, nocaadvreturnsLTD
				, amtpsereturnsCTD
				, nopsereturnsCTD
				, amtpsereturnsLTD
				, nopsereturnsLTD
				, CollectionFeesCTD
				, NoOfCollectionFeesCTD
				, CollectionFeesLTD
				, NoOfCollectionFeesLTD
				, CollectionFeesYTD
				, NoOfCollectionFeesYTD
				, AmountOfChecksCTD
				, NumberOfChecksCTD
				, AmountOfChecksLTD
				, NumberOfChecksLTD
				, LateChargesCTD
				, NumberOfLateFeesCTD
				, LateChargesLTD
				, NumberOfLateFeesLTD
				, LateChargesYTD
				, NumberOfLateFeesYTD
				, nodispCTD
				, nodispLTD
				, amtdispCTD
				, amtdispLTD
				, CashAdvanceFeesCTD
				, CashAdvanceFeesLTD
				, NumberCashAdvFeesCTD
				, NumberCashAdvFeesLTD
				, InsuranceCTD
				, InsuranceLTD
				, InsuranceYTD
				, CpsFirstUsageDate
				, SystemStatus
				, PaymentStartDate
				, DaysInCycle
				, ChargeOffDate
				, InvoiceNo
				, DateOfDelinquency
				, AmtInterestCreditsCTD
				, NumberOfDebitsRevCTD
				, AmountOfDebitsRevCTD
				, NumberOfCreditsRevCTD
				, AmountOfCreditsRevCTD
				, DeInterestAdjustment
				, LateFeeAdjustment
				, DeCurrentBalance_TranTime_PS
				, InsuranceAdjustment
				, InvoiceNumber
				, AdditivesBal
				, accessID
				, RLSKey
				, CustomerId
				, typeofcard
				, AccountProperty
				, tpyNAD
				, tpyLAD
				, tpyBlob
				, AmtInterestCreditsCC1
				, AmtInterestCreditsCC2
				, AmtOfInterestCC1
				, AmtOfInterestCC2
				, AmtOfInterestCC3
				, AmtOfInterestCC4
				, AmtOfInterestCC5
				, AmtOfInterestCC6
				, AmtOfInterestCC7
				, AmtOfInterestCC8
				, AmtOfInterestCC9
				, AmtOfInterestCC10
				, DisbursementBal
				, FuelBal
				, MaintenanceBal
				, MiscBal
				, AmountSecDepCredit
				, AmountSecDepCreditLTD
				, AmountSecDepCreditMTD
				, AmountSecDepCreditYTD
				, CountSecDepCredit
				, CountSecDepCreditLTD
				, CountSecDepCreditMTD
				, CountSecDepCreditYTD
				, AmountSecDepDebit
				, AmountSecDepDebitLTD
				, AmountSecDepDebitMTD
				, AmountSecDepDebitYTD
				, CountSecDepDebit
				, CountSecDepDebitLTD
				, CountSecDepDebitMTD
				, CountSecDepDebitYTD
				, APR
				, BSFC
				, BSFCMethod
				, intplanoccurr
				, InterestRate1
				, InterestRate2
				, InterestRate3
				, InterestRate4
				, DeferredAccruedCTD
				, AggBalanceCTD
				, creditplantype
				, cpsinterestplan
				, DeferredIntAtExpCancel
				, SChargesAdjustment
				, ServiceChargeCC1
				, ServiceChargeCC2
				, ServiceChargeCC3
				, AmountOfPaymentsCC1
				, AmountOfPaymentsCC2
				, AmountOfPaymentsCC3
				, AmountOfPaymentsCC4
				, AmountOfPaymentsCC5
				, PaymentAdjustment
				, CreditPlanNumber
				, WaivedInterest
				, CounterForEqualPayment
				, ccinhparent136AID
				, ccinhparent136ATID
				, ccinhparent137AID
				, ccinhparent137ATID
				, ccinhparent138AID
				, ccinhparent138ATID
				, ccinhparent139AID
				, ccinhparent139ATID
				, ccinhparent140AID
				, ccinhparent140ATID
				, ccinhparent141AID
				, ccinhparent141ATID
				, ccinhparent142AID
				, ccinhparent142ATID
				, ccinhparent143AID
				, ccinhparent143ATID
				, ccinhparent144AID
				, ccinhparent144ATID
				, ccinhparent145AID
				, ccinhparent145ATID
				, ccinhparent146AID
				, ccinhparent146ATID
				, ccinhparent147AID
				, ccinhparent147ATID
				, BalanceTransfer_DTD
				, BalanceTransfer_CTD
				, BalanceTransfer_MTD
				, BalanceTransfer_YTD
				, BalanceTransfer_LTD 			
				FROM #PreviousSHData

				INSERT INTO SummaryHeaderCreditCard
				(acctId
				, StatementID
				, NewTransactionsBSFC
				, NewTransactionsAccrued
				, NewTransactionsAgg
				, RevolvingBSFC
				, RevolvingAgg
				, AfterCycleRevolvBSFC
				, DeferredAccrued
				, DeferredAccruedCTD
				, CPSChargeOffStatus
				, currentbalanceco
				, totalamountco
				, principalco
				, interestbnpco
				, latefeesbnpco
				, membershipfeesbnpco
				, nsffeesbnpco
				, overlimitfeesbnpco
				, servicefeesbnpco
				, collectionfeesbnpco
				, insurancefeesbnpco
				, recoveryfeesbnpco
				, PrePaidAmount
				, PrepaymentCounter
				, TotalBSFC
				, DateOfTotalDue
				, daysdelinquent
				, NoPayDaysDelinquent
				, DtOfLastDelinqCTD
				, CurrentDue
				, AmtOfPayXDLate
				, AmountOfPayment30DLate
				, AmountOfPayment60DLate
				, AmountOfPayment90DLate
				, AmountOfPayment120DLate
				, AmountOfPayment150DLate
				, AmountOfPayment180DLate
				, AmountOfPayment210DLate
				, CycleDueDTD
				, NumberOfPaymentPastDue
				, NumberOfPayment30DLate
				, NumberOfPayment60DLate
				, NumberOfPayment90DLate
				, NumberOfPayment120DLate
				, NumberOfPayment150DLate
				, NumberOfPayment180DLate
				, NumberOfPayment210DLate
				, VirtualHdOfDelqChain
				, PrincipalDefCTD
				, PrincipalDefCC1
				, PrincipalDefCC2
				, PrincipalDefCC3
				, PrincipalDefAdjustment
				, AmtOfOvrLimitFeesCC1
				, AmtOfOvrLimitFeesCC2
				, AmtOfOvrLimitFeesCC3
				, OverlimitFeeAdjustment
				, AmountOfCreditsAsPmtCTD
				, DeferredAccruedFinal
				, InterestDefermentStatus
				, InterestOnCycCTD
				, LateFeeCreditCTD
				, MemberShipFeeCreditCTD
				, OverLimitFeeCreditCTD
				, RecoveryFeeCreditCTD
				, ServiceChargeCreditCTD
				, NSFCreditCTD
				, InterestFeeCreditCTD
				, InsuranceFeeCreditCTD
				, CollectionFeeCreditCTD
				, HoldWaivedInterest
				, HoldNewTxnInterest
				, ChargedNewTxnInterest
				, ChargedInterestRevolving
				, multiplesales
				, CurePlanCancellationStatus
				, ConsecutivePaymentDate
				, PrevCycleFC
				, PrevCycleFCCredit
				, OverlimitBalance
				, GraceDaysStatus
				, AccountGraceStatus
				, TrailingInterestDate
				, HoldDisputeBSFCCycle1
				, HoldDisputeBSFCCycle2
				, HoldDisputeBSFCEndDateCycle1
				, HoldDisputeBSFCEndDateCycle2
				, InterestChargedCTD
				, AggregateCB
				, PurchaseRevCTD_InCycle
				, PurchaseRevCTD_AcrossCycle
				, PromoStartDate
				, PromoRateEndDate
				, PromoTxnPeriodStartDate
				, PromoTxnPeriodEndDate
				, PromoRateDuration
				, PromoPlanActive
				, BilledPrincipalCTD
				, BilledPrincipalCC1
				, BilledPrincipalCC2
				, BilledPrincipalCC3
				, BilledPrincipalCC4
				, BilledPrincipalCC5
				, BilledPrincipalCC6
				, BilledPrincipalCC7
				, BilledPrincipalCC8
				, ExtraPaymentAmount_LTD
				, SRBWithInstallmentDue
				, SBWithInstallmentDue
				, EqualPaymentAmt
				, DisputesAmtNS
				, OriginalPurchaseAmount
				, DispRCHFavororWriteoff
				, TotalRewardPoints
				, BasePercent
				, RetailAniversaryDate
				, JobID
				, StmtHeader_UUID
				, SingleSaleTranID
				, SRBwithInstallmentDueCC1
				, CardAcceptorNameLocation
				, PlanUUID
				, MaturityDate
				, LoanEndDate
				, DailyCashPercent
				, DailyCashAmount
				, PayOffDate
				, DisputeIndicator
				, AmountOfCreditsRevLTD
				, DisputeAmtNSCC1
				, ManualPurchaseReversal_CTD
				, ManualPurchaseReversal_LTD
				, ClientId
				, CreditBalanceMovement
				, RevolvingAccrued
				, TotalAccruedInterest
				, IntRateType
				, PostMergeDisputeLTD
				, AmountOfCreditsAfterGraceCutoff)
				SELECT 
							acctId
				, StatementID
				, NewTransactionsBSFC
				, NewTransactionsAccrued
				, NewTransactionsAgg
				, RevolvingBSFC
				, RevolvingAgg
				, AfterCycleRevolvBSFC
				, DeferredAccrued
				, DeferredAccruedCTD
				, CPSChargeOffStatus
				, currentbalanceco
				, totalamountco
				, principalco
				, interestbnpco
				, latefeesbnpco
				, membershipfeesbnpco
				, nsffeesbnpco
				, overlimitfeesbnpco
				, servicefeesbnpco
				, collectionfeesbnpco
				, insurancefeesbnpco
				, recoveryfeesbnpco
				, PrePaidAmount
				, PrepaymentCounter
				, TotalBSFC
				, DateOfTotalDue
				, daysdelinquent
				, NoPayDaysDelinquent
				, DtOfLastDelinqCTD
				, CurrentDue
				, AmtOfPayXDLate
				, AmountOfPayment30DLate
				, AmountOfPayment60DLate
				, AmountOfPayment90DLate
				, AmountOfPayment120DLate
				, AmountOfPayment150DLate
				, AmountOfPayment180DLate
				, AmountOfPayment210DLate
				, CycleDueDTD
				, NumberOfPaymentPastDue
				, NumberOfPayment30DLate
				, NumberOfPayment60DLate
				, NumberOfPayment90DLate
				, NumberOfPayment120DLate
				, NumberOfPayment150DLate
				, NumberOfPayment180DLate
				, NumberOfPayment210DLate
				, VirtualHdOfDelqChain
				, PrincipalDefCTD
				, PrincipalDefCC1
				, PrincipalDefCC2
				, PrincipalDefCC3
				, PrincipalDefAdjustment
				, AmtOfOvrLimitFeesCC1
				, AmtOfOvrLimitFeesCC2
				, AmtOfOvrLimitFeesCC3
				, OverlimitFeeAdjustment
				, AmountOfCreditsAsPmtCTD
				, DeferredAccruedFinal
				, InterestDefermentStatus
				, InterestOnCycCTD
				, LateFeeCreditCTD
				, MemberShipFeeCreditCTD
				, OverLimitFeeCreditCTD
				, RecoveryFeeCreditCTD
				, ServiceChargeCreditCTD
				, NSFCreditCTD
				, InterestFeeCreditCTD
				, InsuranceFeeCreditCTD
				, CollectionFeeCreditCTD
				, HoldWaivedInterest
				, HoldNewTxnInterest
				, ChargedNewTxnInterest
				, ChargedInterestRevolving
				, multiplesales
				, CurePlanCancellationStatus
				, ConsecutivePaymentDate
				, PrevCycleFC
				, PrevCycleFCCredit
				, OverlimitBalance
				, GraceDaysStatus
				, AccountGraceStatus
				, TrailingInterestDate
				, HoldDisputeBSFCCycle1
				, HoldDisputeBSFCCycle2
				, HoldDisputeBSFCEndDateCycle1
				, HoldDisputeBSFCEndDateCycle2
				, InterestChargedCTD
				, AggregateCB
				, PurchaseRevCTD_InCycle
				, PurchaseRevCTD_AcrossCycle
				, PromoStartDate
				, PromoRateEndDate
				, PromoTxnPeriodStartDate
				, PromoTxnPeriodEndDate
				, PromoRateDuration
				, PromoPlanActive
				, BilledPrincipalCTD
				, BilledPrincipalCC1
				, BilledPrincipalCC2
				, BilledPrincipalCC3
				, BilledPrincipalCC4
				, BilledPrincipalCC5
				, BilledPrincipalCC6
				, BilledPrincipalCC7
				, BilledPrincipalCC8
				, ExtraPaymentAmount_LTD
				, SRBWithInstallmentDue
				, SBWithInstallmentDue
				, EqualPaymentAmt
				, DisputesAmtNS
				, OriginalPurchaseAmount
				, DispRCHFavororWriteoff
				, TotalRewardPoints
				, BasePercent
				, RetailAniversaryDate
				, JobID
				, StmtHeader_UUID
				, SingleSaleTranID
				, SRBwithInstallmentDueCC1
				, CardAcceptorNameLocation
				, PlanUUID
				, MaturityDate
				, LoanEndDate
				, DailyCashPercent
				, DailyCashAmount
				, PayOffDate
				, DisputeIndicator
				, AmountOfCreditsRevLTD
				, DisputeAmtNSCC1
				, ManualPurchaseReversal_CTD
				, ManualPurchaseReversal_LTD
				, ClientId
				, CreditBalanceMovement
				, RevolvingAccrued
				, TotalAccruedInterest
				, IntRateType
				, PostMergeDisputeLTD
				, AmountOfCreditsAfterGraceCutoff
				 FROM #PreviousSHCCData

				INSERT INTO CurrentSummaryHeader
							 (acctId
				, StatementID
				, AmtOfInterestCTD
				, StatementDate
				, BeginningBalance
				, CurrentBalance
				, Principal
				, latefeesbnp
				, NSFFeesBilledNotPaid
				, insurancefeesbnp
				, servicefeesbnp
				, MembershipFeesBNP
				, recoveryfeesbnp
				, collectionfeesbnp
				, overlimitbnp
				, IntBilledNotPaid
				, BeginningBalanceUpdate
				, HoldWaivedInterest
				, ChargedInterestRevolving
				, ChargedNewTxnInterest
				, HoldNewTxnInterest
				, AmountOfTotalDue
				, CurrentDue
				, AmtOfPayXDLate
				, AmountOfPayment30DLate
				, AmountOfPayment60DLate
				, AmountOfPayment90DLate
				, AmountOfPayment120DLate
				, AmountOfPayment150DLate
				, AmountOfPayment180DLate
				, AmountOfPayment210DLate
				, AmountOfPaymentsCTD
				, AmountOfCreditsCTD
				, BackDatedPayments
				, BackCredit1CPDAmt
				, PurchaseReversalFlag
				, InterestAtCycle
				, MIChargedBucket
				, WaivedInterestCredit
				, GraceCutoffDate
				, PrevCycleFCCredit
				, GraceDaysStatus
				, AccountGraceStatus
				, NewTransactionsAgg
				, RevolvingAgg
				, TrailingInterestDate)
				SELECT 
							 acctId
				, StatementID
				, AmtOfInterestCTD
				, StatementDate
				, BeginningBalance
				, CurrentBalance
				, Principal
				, latefeesbnp
				, NSFFeesBilledNotPaid
				, insurancefeesbnp
				, servicefeesbnp
				, MembershipFeesBNP
				, recoveryfeesbnp
				, collectionfeesbnp
				, overlimitbnp
				, IntBilledNotPaid
				, BeginningBalanceUpdate
				, HoldWaivedInterest
				, ChargedInterestRevolving
				, ChargedNewTxnInterest
				, HoldNewTxnInterest
				, AmountOfTotalDue
				, CurrentDue
				, AmtOfPayXDLate
				, AmountOfPayment30DLate
				, AmountOfPayment60DLate
				, AmountOfPayment90DLate
				, AmountOfPayment120DLate
				, AmountOfPayment150DLate
				, AmountOfPayment180DLate
				, AmountOfPayment210DLate
				, AmountOfPaymentsCTD
				, AmountOfCreditsCTD
				, BackDatedPayments
				, BackCredit1CPDAmt
				, PurchaseReversalFlag
				, InterestAtCycle
				, MIChargedBucket
				, WaivedInterestCredit
				, GraceCutoffDate
				, PrevCycleFCCredit
				, GraceDaysStatus
				, AccountGraceStatus
				, NewTransactionsAgg
				, RevolvingAgg
				, TrailingInterestDate			
				FROM #PreviousCSHData

				IF(@Statement = @ToStatement)
				BEGIN
					UPDATE AccountsOfPlanToReLink SET JobStatus = 2 WHERE JobStatus = 1
				END


				
				--Print 'In Update';

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION 
				UPDATE AccountsOfPlanToReLink SET JobStatus = -1 WHERE JobStatus = 1
				SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
				RAISERROR('ERROR OCCURED :-', 16, 1);
		END CATCH

	END
--END