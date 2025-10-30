
DECLARE @BSacctId INT , @LastSatementDate DATETIME, @Businessday DATETIME, @CPSAcctID INT, @CCARD INT = 0, @EOD INT = 0, @Statement INT = 0
--Q16 - 11518718
SET @BSacctId = 11537492
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011198782785'
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = 'ac986980-2fea-45d9-a102-4f0752afe520'
--941c5286-1254-4130-84bc-c6feec7b3b31
--f18cc98a-0aaa-4b5e-bec7-de0f5f290378
SET @LastSatementDate = '2023-03-31 23:59:57.000'
SET @Businessday = '2023-01-31 23:59:57.000'
SET @CCARD =0
SET @EOD = 0
SET @Statement = 1

PRINT 'BS'
SELECT 'BS====>', BP.acctId, FamilyAccount, AutoInitialChargeOffReason, LastStatementDate, DateAcctOpened, ChargeOffDate, ChargeOffDateParam, BillingCycle, DisputesAmtNS,
MergeInProcessPH, BP.DeAcctActivityDate, amountoftotaldue, sbwithinstallmentdue, srbwithinstallmentdue, StatementRemainingBalance,
BP.SystemStatus, runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate, DateAcctClosed, 
CurrentBalance, CurrentBalanceCO, Principal, PrincipalCO,cycleduedtd, amountofpaymentsctd,
amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent, DPDFreezeDays,BS.firstduedate,dateoforiginalpaymentduedtd, BS.DtOfLastDelinqCTD, BeginningBalance
,Statementremainingbalance, amountofcreditsctd, AmountOfPaymentsCTD,BP.SYSTEMSTATUS,BP.CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC, ManualInitialChargeOffReason, AutoInitialChargeOffReason, LastStatementDate, 
	NAD, LAD, LAPD, MergeCycle, AmtOfAcctHighBalLTD, UniversalUniqueID
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_balances BB WITH(NOLOCK) ON (BP.ACCTID = BB.ACCTID)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_Secondary B2 WITH(NOLOCK) ON (BB.ACCTID = B2.ACCTID)
WHERE  bp.acctid = @BSacctId 

--SELECT 'BS_AUTH====>', DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID, * FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE acctId = @BSacctId

--SELECT 'MergeAccountJob====>', SrcRemainingMinDue, DESTRemainingMinDue, * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) WHERE DestBSacctId = @BSacctId OR SrcBSacctId = @BSacctId 

PRINT 'CPS'
SELECT 'CPS====>', CPS.ACCTID,creditplantype, PlanUUID, Parent01AID, CPC.OriginalPurchaseAmount,CPC.cycleduedtd, DisputesAmtNS,CPC.amountoftotaldue,sbwithinstallmentdue,srbwithinstallmentdue, 
CurrentBalance, CurrentBalanceCO, AmountOfCreditsLTD, AmountOfCreditsRevLTD,
cps.decurrentbalance_trantime_ps, CPS.Principal, PrincipalCO, EqualPaymentAmt, intbillednotpaid, amountofpaymentsctd,
CPC.amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent,AMOUNTOFCREDITSCTD,
gracedaysstatus,accountgracestatus,INTERESTRATE1,BEGINNINGBALANCE,CURRENTBALANCE,CURRENTBALANCECO,PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC,PRINCIPAL + PRINCIPALCO,NEWTRANSACTIONSBSFC + REVOLVINGBSFC + AfterCycleRevolvBSFC, CPC.PlanUUID,
EstimatedDue, RollOverDue, plansegcreateDate, MergeDate, MergeIndicator
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
WHERE cps.PARENT02AID = @BSacctId 
--AND CurrentBalance > 0	



IF(@Statement = 1)
BEGIN
PRINT 'Statement'
	SELECT TOP 100 'Statement====>', acctId, SystemStatus, AutoInitialChargeOffReason,CurrentbalanceCo, tempcreditlimit, CycleDueDTD, SH.StatementID, StatementDate, DateofTotalDue, DateOfNextStmt, LastStatementDate, Principal, MinimumPaymentDue, AmountOFPaymentsCTD, SBWithInstallmentDue, SRBWithInstallmentDue, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
	AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
	SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID, BeginningBalance, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason, WaiveMinDue,
	amountofdebitsctd,amountofcreditsctd, amountofdebitsrevctd, amountofcreditsrevctd
	FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
	WHERE SH.acctID = @BSacctId AND StatementDate = @LastSatementDate
	ORDER BY StatementDate DESC


	SELECT 'Summary====>',SH.acctId, APR, SH.StatementID, BeginningBalance, CreditBalanceMovement, SH.decurrentbalance_trantime_ps, SH.StatementDate, CreditPlanType, DisputesAmtNS, SHCC.CycleDueDTD, SH.CurrentBalance, CurrentBalanceCO,Principal, PrincipalCO, OriginalPurchaseAmount, 
	SH.AmountOfCreditsLTD, SHCC.AmountOfCreditsRevLTD, srbwithinstallmentdue, SHCC.sbwithinstallmentdue,
	SH.AmountOfTotalDue, shcc.CurrentDue,SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, SHCC.AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
	(CurrentDue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD, 
	CreditBalanceMovement, EqualPaymentAmt, PayOffDate, LoanEndDate, PayOffDate
	FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
	WHERE SH.parent02AID = @BSacctId AND SH.StatementDate = @LastSatementDate
	ORDER BY StatementDate DESC
END

--IF(@CCARD = 1)
--BEGIN
--PRINT 'CCARD'
--	SELECT 'CCARD====>', BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, 
--	EqualPayments, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
--	CP.MemoIndicator,CP.RevTgt, TransactionDescription
--	FROM CCard_Primary CP WITH (NOLOCK)
--	LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
--	LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId AND CP.TxnSource = 29 AND CP.CMTTRANTYPE = '40')
--	WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = @BSacctId) 
--	AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
--	AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR', 'MMRMD', 'ReageTot'))
--	AND CP.TxnSource NOT IN ('4','10')
--	AND CP.MemoIndicator IS NULL
--	AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
--	AND CP.PostTime >= @LastSatementDate
--	--AND CMTTranType = '110'
--	ORDER BY CP.POSTTIME DESC

--END


IF(@EOD = 1)
BEGIN
PRINT 'EOD'
	SELECT 'AIR====>', 
	BusinessDay, BSAcctId, AmtOfPayCurrDue, AutoInitialChargeOffReason, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment90DLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, 
	SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
	RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, 
	DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid, TotalDaysDelinquent, DaysDelinquent
	FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport WITH (NOLOCK) 
	WHERE BusinessDay = @BusinessDay
	AND BSAcctId = @BSAcctId

	DECLARE db_Cursor CURSOR FOR
	SELECT acctId FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = @BSAcctId

	OPEN db_Cursor
	FETCH NEXT FROM db_cursor INTO @CPSAcctID


	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SELECT 'PIR====>',
		BusinessDay, BSAcctId, CPSAcctId, CreditPlanType, CurrentBalance, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfTotalDue, 
		CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, IntBilledNotPaid
		FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.PlanInfoForReport WITH (NOLOCK) 
		WHERE BusinessDay = @BusinessDay
		AND CPSAcctId = @CPSAcctID

		FETCH NEXT FROM db_cursor INTO @CPSAcctID
	END


	CLOSE db_Cursor
	DEALLOCATE db_Cursor
END
