
DECLARE
	@AccountID				INT,   
	@PlanID					INT,   
	@CurrentTime			DATETIME,   
	@LastStatementDate		DATETIME,   
	@ScheduleID				DECIMAL(19,0),   
	@ScheduleIndicator		INT,
	@InPWP					INT
   
BEGIN  
	 -- Author	 :: PRASOON PARASHAR
	 -- Purpose	 :: Retail Implementation

	
	SELECT TOP 1
		@AccountID = BP.acctId, 
		@PlanID = ILPS.PlanID, 
		@CurrentTime = dbo.PR_ISOGetBusinessTime(), 
		@LastStatementDate = BP.LastStatementDate, 
		@ScheduleID = ILPS.ScheduleID, 
		@ScheduleIndicator = ILPS.ScheduleIndicator
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (ILPS.parent02AID = BP.acctId)
	WHERE ILPS.PlanID = 40755619
	ORDER BY ILPS.ActivityOrder DESC

	IF 1 = (	SELECT TOP 1 CASE WHEN ReageStatus = 4 THEN 1 ELSE 0 END
				FROM LoanModificationLog WITH(NOLOCK) 
				WHERE ProgramName = 8 AND Acctid = @AccountID 
				ORDER BY TimeStamp DESC
				)
	BEGIN
		SET @InPWP = 1
	END
	ELSE
		SET @InPWP = 0

	PRINT '@AccountID = ' + CAST(@AccountID AS VARCHAR) + 
			' @PlanID = ' + CAST(@PlanID AS VARCHAR) + 
			' @CurrentTime = ' + CONVERT(VARCHAR, @CurrentTime, 20) + 
			' @LastStatementDate = ' + CONVERT(VARCHAR, @LastStatementDate, 20) + 
			' @ScheduleID = ' + CAST(@ScheduleID AS VARCHAR) + 
			' @ScheduleIndicator = ' + CAST(@ScheduleIndicator AS VARCHAR) +
			' @InPWP = ' + CAST(@InPWP AS VARCHAR) 
	
  
	SET NOCOUNT ON 
	SET QUOTED_IDENTIFIER ON
	 
	   
  
	DECLARE @LoanTerm							INT,   
			@RevisedLoanTerm					INT,  
			@ShowSchedule						INT,
			@DateOfNextStmt						DATETIME,
			@dateofTotalDue						DATETIME,
			@LoanEndDate						DATETIME,
			@OriginalLoanEndDate				DATETIME,
			@OriginalMonthlyPayment				MONEY,
			@OriginalLastMonthPayment			MONEY,
			@MaturityDate						DATETIME,
			@LastTermDate						DATETIME,
			@CalculatedLoanTerm					INT,
			@OriginalLoanAmount					MONEY,
			@OutstandingLoanAmount				MONEY,
			@DistributionAmount					MONEY,
			@LoanStartDate						DATETIME,
			@MergeIndicator						INT,
			@PaidOffDate						DATETIME,
			@BillingCycle						VARCHAR(10),
			@LastTermDateOLD					DATETIME,
			@CountArray							INT = 0,
			@CountArray1						INT = 0,
			@MaxLoanTerm						INT = 0,
			@CountExtended						INT = 0,
			@DateofTotalDueExtended				DATETIME,
			@KeepExtendedSchedule				INT = 0
	SELECT 
		@DateOfNextStmt		= DateOfNextStmt,
		@dateofTotalDue		= BCC.DateOfTotalDue,
		@BillingCycle		= BillingCycle
	FROM BSegment_Primary  B WITH (NOLOCK)  
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (B.acctid = BCC.acctId) 
	WHERE B.acctId = @AccountID 

	SELECT 
		@LoanTerm				= LoanTerm,   
		@RevisedLoanTerm		= RevisedLoanTerm,
		@LoanEndDate			= LoanEndDate,
		@OriginalLoanEndDate	= OriginalLoanEndDate,
		@MaturityDate			= MaturityDate,
		@LastTermDate			=  LastTermDate,
		--@OutstandingLoanAmount	= CurrentBalance,
		@PaidOffDate			= PaidOffDate,
		@LoanStartDate			= LoanStartDate
	FROM   ILPScheduleDetailSummary WITH (NOLOCK)   
	WHERE  ScheduleID = @ScheduleID 
	
	--PRINT @PaidOffDate

	--SELECT
	--	@OriginalMonthlyPayment			= EqualPaymentAmountCalc,
	--	@OriginalLastMonthPayment		= LastMonthPayment,
	--	@OriginalLoanAmount				= OriginalLoanAmount,
	--	@MergeIndicator					= ISNULL(MergeIndicator, 0)
	--FROM ILPScheduleDetailSummary WITH (NOLOCK) 
	--WHERE parent02AID = @AccountID AND PlanID = @PlanID AND Activity = 1

	--Optimization required  and Order by required
	IF(@InPWP = 1)
	BEGIN
		SELECT TOP 1
			@OriginalMonthlyPayment			= EqualPaymentAmountCalc,
			@OriginalLastMonthPayment		= LastMonthPayment,
			@OriginalLoanAmount				= OriginalLoanAmount,
			@MergeIndicator					= ISNULL(MergeIndicator, 0)
		FROM ILPScheduleDetailSummary WITH (NOLOCK) 
		WHERE parent02AID = @AccountID AND PlanID = @PlanID AND Activity = 32 AND ISNULL(ReageReversed, 0) = 0
		ORDER BY LoanDate DESC
	END
	ELSE
	BEGIN
		SELECT
			@OriginalMonthlyPayment			= EqualPaymentAmountCalc,
			@OriginalLastMonthPayment		= LastMonthPayment,
			@OriginalLoanAmount				= OriginalLoanAmount,
			@MergeIndicator					= ISNULL(MergeIndicator, 0)
		FROM ILPScheduleDetailSummary WITH (NOLOCK) 
		WHERE parent02AID = @AccountID AND PlanID = @PlanID AND Activity = 1
	END

   
	DECLARE @TempILPSchedule   TABLE
	(   
		TermNumber								INT ,   
		LoanTerm								INT,   
		CurrencyCode							INT ,   
		RegularPaymentAmountForIteration		MONEY,   
		Paid									MONEY,   
		Due										DATETIME,
		StatementUUID							VARCHAR(64),
		OriginalAmountDue						MONEY,
		AmountAppliedTowardsMonth				MONEY,
		Statementdate							DATETIME,
		InstallmentCharged						VARCHAR(10)         
	) 

	IF(@ScheduleID > 0 )  
	BEGIN 
 
		DECLARE  @TempPlan  TABLE 
		(   
			PlanId			INT,
			AmountPaid		MONEY,
			OutstandingLoanAmount MONEY
		)  
  
		IF(@PlanID IS NULL OR  @PlanID = 0)   
		BEGIN   
			INSERT INTO @TempPlan   
				SELECT 
					CPA.acctId,
					0 AS AmountPaid,
					0 AS OutstandingLoanAmount
				FROM CPSgmentAccounts CPA WITH (NOLOCK) 
				JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) on CPA.acctId = CPCC.acctId  
				WHERE  CPA.parent02aid = @AccountID --AND CPA.CurrentBalance + CPCC.CurrentBalanceCO > 0  
		END   
		ELSE   
		--BEGIN   
			--IF((
			--		SELECT CurrentBalance + CurrentBalanceCO 
			--		FROM   CPSgmentAccounts CPA WITH (NOLOCK) 
			--		JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId) 
			--		WHERE CPA.acctId = @PlanID
			--	) > 0)
			BEGIN
				INSERT INTO @TempPlan VALUES   
				(   
					@PlanID ,
					0,
					0
				)  
			END 
		--END

		IF(( SELECT COUNT(1) FROM @TempPlan ) > 0)  
		BEGIN   
			DECLARE  @TempBilledTerms TABLE  
			(   
				PlanID								INT,
				TermNumber							INT ,   
				LoanTerm							INT,   
				CurrencyCode						INT ,   
				RegularPaymentAmountForIteration	MONEY,   
				Paid								MONEY,   
				Due									DATETIME,   
				StatementDate						DATETIME,
				StatementUUID						VARCHAR(64),
				Ranking								INT,
				OriginalAmountDue					MONEY,
				AmountAppliedTowardsMonth			MONEY,
				stmtRanking							INT,
				SkipSchedule						INT,
				AmountPaid							MONEY,
				OriginalDue							MONEY,
				ActualStatementdate					DATETIME		
			) 
			DECLARE  @TempUnbilledTerms  TABLE 
			(   
				PlanID								INT,
				TermNumber							INT ,   
				LoanTerm							INT,   
				CurrencyCode						INT ,   
				RegularPaymentAmountForIteration	MONEY,   
				Paid								MONEY,   
				Due									DATETIME,    
				StatementDate						DATETIME,
				StatementUUID						VARCHAR(64),
				OriginalAmountDue					MONEY,
				AmountAppliedTowardsMonth			MONEY,
				SkipSchedule						INT,
				AmountPaid							MONEY,
				OriginalDue							MONEY,
				ActualStatementdate					DATETIME  
			)  
			DECLARE  @tempCurrentunbilledterms   TABLE
			(   
				PlanID								INT,
				TermNumber							INT,   
				LoanTerm							INT,   
				CurrencyCode						INT,   
				RegularPaymentAmountForIteration	MONEY,   
				Paid								MONEY,   
				Due									DATETIME,    
				StatementDate						DATETIME,
				StatementUUID						VARCHAR(64),
				OriginalAmountDue					MONEY,
				AmountAppliedTowardsMonth			MONEY,
				SkipSchedule						INT,
				AmountPaid							MONEY,
				OriginalDue							MONEY,
				ActualStatementdate					DATETIME  
			) 
			DECLARE  @tempTermsOnPaymentApplied   TABLE
			(   
				PlanID								INT,
				TermNumber							INT,   
				LoanTerm							INT,   
				CurrencyCode						INT,   
				RegularPaymentAmountForIteration	MONEY,   
				Paid								MONEY,   
				Due									DATETIME,    
				StatementDate						DATETIME,
				StatementUUID						VARCHAR(64),
				OriginalAmountDue					MONEY,
				AmountAppliedTowardsMonth			MONEY,
				AmountPaid							MONEY,
				OriginalDue							MONEY,
				ActualStatementdate					DATETIME
			) 
			DECLARE  @tempmergedschedule   TABLE
			(   
				PlanID								INT,
				TermNumber							INT,   
				LoanTerm							INT,   
				CurrencyCode						INT,   
				RegularPaymentAmountForIteration	MONEY,   
				Paid								MONEY,   
				Due									DATETIME,    
				StatementDate						DATETIME,
				StatementUUID						VARCHAR(64),
				OriginalAmountDue					MONEY,
				AmountAppliedTowardsMonth			MONEY,
				AmountPaid							MONEY,
				OriginalDue							MONEY,
				ActualStatementdate					DATETIME  
			) 
			DECLARE  @TempJobID TABLE
			(
				PlanId								INT,
				StatementDate						DATETIME,
				DateOfTotalDue						DATETIME,
				StmtHeader_UUID						VARCHAR(64),
				AmountOfTotalDue					MONEY,
				CurrentDue							MONEY,
				CreditBalanceMovement				MONEY,
				CSHCurrentBalance					MONEY,
				SHCurrentBalance					MONEY,
				DisputesAmtNS						MONEY
			)

			DECLARE  @TempSummaryHeaderRecords TABLE
			(
				acctId								INT,
				StatementID							DECIMAL(19, 0),
				StmtHeader_UUID						VARCHAR(64),
				currentbalanceco					MONEY,
				AmountOfTotalDue					MONEY,
				CurrentDue							MONEY,
				AmountOfPaymentsCTD					MONEY,
				StatementDate						DATETIME,
				WaiveMinDue							INT,
				StatementRank						INT,
				DisputesAmtNS						MONEY,
				CurrentBalance						MONEY,
				MergeCycle							INT
			)

			INSERT INTO @TempSummaryHeaderRecords
			SELECT 
				MSH.acctId, MSH.StatementID, StmtHeader_UUID, MSH.CurrentBalanceCO, MSH.AmountOfTotalDue, MSH.CurrentDue, MSH.AmountOfPaymentsCTD, MSH.StatementDate, ISNULL(MS.WaiveMinDue, 0), 1
				, MSH.DisputesAmtNS, MSH.CurrentBalance, 0
			FROM  MergeSummaryHeader MSH WITH (NOLOCK)
			JOIN @TempPlan TP ON (TP.planid = MSH.acctId)
			JOIN MergeStatementHeader MS WITH (NOLOCK) ON (MS.acctId = MSH.parent02AID AND MSH.StatementID = MS.StatementID)
			--JOIN @TempPlan TP ON (TP.planid = MSH.acctId)

			INSERT INTO @TempSummaryHeaderRecords
			SELECT 
				SH.acctId, SH.StatementID, StmtHeader_UUID, SCC.currentbalanceco, SH.AmountOfTotalDue, SCC.CurrentDue, SH.AmountOfPaymentsCTD, SH.StatementDate, ISNULL(S.WaiveMinDue, 0)
				, CASE WHEN @MergeIndicator = 1 THEN RANK() OVER (PARTITION BY SCC.acctId ORDER BY SH.StatementDate ASC) - 1 ELSE 1 END, SCC.DisputesAmtNS, SH.CurrentBalance, SE.MergeCycle
			FROM   SummaryHeaderCreditCard SCC WITH (NOLOCK) 
			JOIN @TempPlan TP ON (TP.planid = SCC.acctId)
			JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctid = SCC.acctid AND SH.StatementID = SCC.StatementID) 
			JOIN StatementHeader S WITH (NOLOCK) ON (S.acctId = SH.parent02AID AND SH.StatementID = S.StatementID)
			JOIN StatementHeaderEx SE WITH (NOLOCK) ON (S.acctId = SE.acctId AND S.StatementID = SE.StatementID)
			--JOIN @TempPlan TP ON (TP.planid = SCC.acctId)

			--SELECT * FROM @TempSummaryHeaderRecords 

			INSERT INTO @TempJobID
				SELECT  
					SCC.acctId,
					SH.StatementDate,
					SCC.DateOfTotalDue,
					SCC.StmtHeader_UUID,
					SH.AmountOfTotalDue,
					SCC.CurrentDue,
					SCC.CreditBalanceMovement,
					CSH.CurrentBalance,
					SH.CurrentBalance,
					SCC.DisputesAmtNS
				FROM SummaryHeaderCreditCard SCC WITH (NOLOCK)
				JOIN @TempPlan TP ON (TP.planid = SCC.acctid)
				JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctid = SCC.acctid AND SH.StatementID = SCC.StatementID) 
				JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctid = CSH.acctid AND SH.StatementID = CSH.StatementID) 
				--JOIN @TempPlan TP ON (TP.planid = SCC.acctid)

				--SELECT * FROM @TempJobID 

			/*
			INSERT INTO @TempBilledTerms   
				SELECT 
					SH.acctId,
					0 AS TermNumber,   
					0 AS LoanTerm,   
					'840' AS CurrencyCode,   
					CASE WHEN SCC.currentbalanceco > 0 THEN SH.AmountOfTotalDue ELSE SH.AmountOfTotalDue - SCC.CurrentDue END AS RegularPaymentAmountForIteration,
					SH.AmountOfPaymentsCTD, --SH.AmountOfPaymentsCTD - SH.AmountOfReturnsCTD,    
					ILP.DateOfTotalDue,  
					SH.StatementDate,
					TJI.StmtHeader_UUID AS StatementUUID,
					ROW_NUMBER() OVER (PARTITION BY SCC.acctId, ILP.DateOfTotalDue, SH.StatementDate ORDER BY SH.StatementDate ASC) AS Ranking,
					TJI.CurrentDue AS OriginalAmountDue, --ILP.RegularPaymentAmountForIteration AS OriginalAmountDue,
					0 AS AmountAppliedTowardsMonth,
					ROW_NUMBER() OVER (PARTITION BY SCC.acctId ORDER BY SH.StatementDate ASC) AS stmtRanking,
					CASE WHEN (ISNULL(S.WaiveMinDue, 0) = 1 AND @LastTermDate > @OriginalLoanEndDate) OR (TJI.CurrentDue <= 0 AND ISNULL(TJI.CreditBalanceMovement, 0) < 0 AND ISNULL(TJI.CSHCurrentBalance, 0) < 0) OR ISNULL(ILP.IsDeferCycle,0) = 1 THEN 1 ELSE 0 END AS SkipSchedule,
					0 AS AmountPaid,
					CASE	WHEN ILP.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
								WHEN ILP.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
								ELSE 0 
					END 
					AS OriginalDue, --ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
					ILP.LastStatementDate AS ActualStatementdate
				FROM   SummaryHeaderCreditCard SCC WITH (NOLOCK) 
				JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctid = SCC.acctid AND SH.StatementID = SCC.StatementID) 
				JOIN StatementHeader S WITH (NOLOCK) ON (S.acctId = SH.parent02AID AND SH.StatementID = S.StatementID)
				LEFT JOIN @TempJobID TJI ON (TJI.PlanId = SCC.acctId AND TJI.DateOfTotalDue = SH.StatementDate)
				JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = SCC.acctId AND ILP.DateOfNextStmt = SH.StatementDate)
				JOIN @TempPlan TP ON (TP.planid = SCC.acctid)
				AND ILP.DateOfTotalDue >= @LoanStartDate
			*/

			-- Redesigned billed terms to handle the merged plan

			INSERT INTO @TempBilledTerms   
				SELECT 
					TS.acctId,
					0 AS TermNumber,   
					0 AS LoanTerm,   
					'840' AS CurrencyCode,   
					CASE WHEN TS.currentbalanceco > 0 THEN TS.AmountOfTotalDue ELSE TS.AmountOfTotalDue - TS.CurrentDue END AS RegularPaymentAmountForIteration,
					TS.AmountOfPaymentsCTD, --SH.AmountOfPaymentsCTD - SH.AmountOfReturnsCTD,    
					ILP.DateOfTotalDue,  
					TS.StatementDate,
					ISNULL(TJI.StmtHeader_UUID, TS.StmtHeader_UUID) AS StatementUUID,
					ROW_NUMBER() OVER (PARTITION BY TS.acctId, ILP.DateOfTotalDue, TS.StatementDate ORDER BY TS.StatementDate ASC) AS Ranking,
					ISNULL(TJI.CurrentDue, TS.CurrentDue) AS OriginalAmountDue, --ILP.RegularPaymentAmountForIteration AS OriginalAmountDue,
					0 AS AmountAppliedTowardsMonth,
					ROW_NUMBER() OVER (PARTITION BY TS.acctId ORDER BY TS.StatementDate ASC) AS stmtRanking,
					CASE WHEN (ISNULL(TS.WaiveMinDue, 0) = 1 AND @LastTermDate > @OriginalLoanEndDate AND (@PaidOffDate IS NULL OR @PaidOffDate > ILP.LastStatementDate)) 
								OR (TJI.CurrentDue <= 0 AND ISNULL(TJI.CreditBalanceMovement, 0) < 0 AND ISNULL(TJI.CSHCurrentBalance, 0) < 0) 
								OR ISNULL(ILP.IsDeferCycle,0) = 1 
								--OR (ISNULL(TS.CurrentBalance, 0) <= ISNULL(TJI.AmountOfTotalDue, 0) AND ISNULL(TS.DisputesAmtNS, 0) > 0)
								OR (ISNULL(TJI.SHCurrentBalance, 0) = 0 AND ISNULL(TJI.DisputesAmtNS, 0) > 0)
								OR (ISNULL(TS.CurrentBalance, 0) = 0 AND ISNULL(TS.CurrentBalance, 0) <= ISNULL(TJI.AmountOfTotalDue, 0) AND ISNULL(TS.DisputesAmtNS, 0) > 0)
								OR ISNULL(TS.MergeCycle,0) = 1
						 THEN 1 
						 ELSE 0 
					END AS SkipSchedule,
					0 AS AmountPaid,
					CASE	WHEN ILP.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
								WHEN ILP.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
								ELSE 0 
					END 
					AS OriginalDue, --ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
					ILP.LastStatementDate AS ActualStatementdate
				FROM  @TempSummaryHeaderRecords TS 
				JOIN @TempPlan TP ON (TP.planid = TS.acctid)
				LEFT JOIN @TempJobID TJI ON (TJI.PlanId = TS.acctId AND TJI.DateOfTotalDue = TS.StatementDate)
				JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = TS.acctId AND ILP.DateOfNextStmt = TS.StatementDate)
				--JOIN @TempPlan TP ON (TP.planid = TS.acctid)
				AND ILP.DateOfTotalDue >= @LoanStartDate
				AND ILP.LastStatementDate IS NOT NULL AND TS.StatementRank > 0
				AND ILP.DateOfTotalDue <= @LastTermDate
			
			--SELECT * FROM @TempBilledTerms

			IF (@ScheduleIndicator = 2) 
			BEGIN
				INSERT INTO @tempCurrentunbilledterms  
					SELECT     
						CP.acctid,
						0 AS TermNumber ,   
						0 AS LoanTerm ,   
						'840' AS CurrencyCode ,   
						--CASE WHEN @dateofTotalDue <> ILPR.DateOfTotalDue THEN 0 ELSE CASE WHEN CPCC.currentbalanceco > 0 THEN CPCC.AmountOfTotalDue ELSE ILPR.RegularPaymentAmountForIteration END - ISNULL(CPCC.AmountOfCreditsAsPmtCTD - CP.AmountOfreturnsCTD - CP.AmountOfCreditsRevCTD, 0) END AS RegularPaymentAmountForIteration,
						CASE WHEN CPCC.currentbalanceco > 0 THEN CPCC.AmountOfTotalDue ELSE CASE WHEN CPCC.AmtOfPayCurrDue > 0 THEN ILPR.RegularPaymentAmountForIteration ELSE 0 END END - ISNULL(CP.AmountOfPaymentsCTD, 0) AS RegularPaymentAmountForIteration,  
						ISNULL(CP.AmountOfPaymentsCTD, 0) AS Paid, --ISNULL(CP.AmountOfPaymentsCTD - CP.AmountOfReturnsCTD, 0) AS Paid,  
						ILPR.DateOfTotalDue AS Due ,   
						@DateOfNextStmt,
						TJI.StmtHeader_UUID AS StatementUUID,
						TJI.CurrentDue AS OriginalAmountDue, --ILP.RegularPaymentAmountForIteration AS OriginalAmountDue,
						0 AS AmountAppliedTowardsMonth,
						CASE 
							WHEN	(((@dateofTotalDue <> ILPR.DateOfTotalDue AND @PaidOffDate IS NULL) 
										OR (TJI.CurrentDue <= 0 AND ISNULL(TJI.CreditBalanceMovement, 0) < 0 AND ISNULL(TJI.CSHCurrentBalance, 0) < 0)
										) AND @LastTermDate > @OriginalLoanEndDate) 
										OR ISNULL(ILPR.IsDeferCycle, 0) = 1 
										--OR (ISNULL(CP.CurrentBalance, 0) <= ISNULL(TJI.AmountOfTotalDue, 0) AND ISNULL(CP.DisputesAmtNS, 0) > 0)
										OR (ISNULL(TJI.SHCurrentBalance, 0) = 0 AND ISNULL(CPCC.AmountOfTotalDue, 0) = 0 AND ISNULL(TJI.DisputesAmtNS, 0) > 0)
										OR (ISNULL(CP.CurrentBalance, 0) = 0 AND ISNULL(CP.CurrentBalance, 0) <= ISNULL(TJI.AmountOfTotalDue, 0) AND ISNULL(CP.DisputesAmtNS, 0) > 0)
							THEN 1 
							ELSE 0 
						END 
						AS SkipSchedule,
						0 AS AmountPaid,
						CASE	WHEN ILPR.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
									WHEN ILPR.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
									ELSE 0 
						END 
						AS OriginalDue, --ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
						ISNULL(ILPR.LastStatementDate,ILP.LastStatementDate) AS ActualStatementdate
					FROM ILPScheduleDetailsRevised ILPR WITH (NOLOCK)
					JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)
					LEFT JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = ILPR.acctId AND ILP.DateOfNextStmt = ILPR.DateOfNextStmt) 
					LEFT JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPCC.acctId = ILPR.acctId)
					LEFT JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (CPCC.acctId = CP.acctId)  
					LEFT JOIN @TempJobID TJI ON (TJI.PlanId = CPCC.acctId AND TJI.DateOfTotalDue = ILPR.DateOfTotalDue)
					--JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)   
					WHERE 
					@CurrentTime > ILPR.LastStatementDate
					AND CASE WHEN (@CurrentTime > CPCC.FirstDueDate OR CPCC.FirstDueDate IS NULL) THEN @CurrentTime ELSE CPCC.FirstDueDate END
					<= ILPR.DateOfNextStmt 
					AND ILPR.LastStatementDate IS NOT NULL
					AND ILPR.scheduleid = @ScheduleID 
					AND ILPR.DateOfTotalDue >= @LoanStartDate
					AND ILPR.DateOfTotalDue <= @LastTermDate

					--SELECT * FROM @tempCurrentunbilledterms

					INSERT INTO @TempUnbilledTerms 
						SELECT 
							ILPR.acctId,
							ILPR.LoanTerm AS TermNumber , 
							ILPR.LoanTerm AS LoanTerm , 
							'840' AS CurrencyCode , 
							ILPR.RegularPaymentAmountForIteration AS RegularPaymentAmountForIteration,
							0 AS Paid,
							ILPR.DateOfTotalDue AS Due , 
							ILPR.StatementDate,
							NULL AS StatementUUID,
							NULL AS OriginalAmountDue, --ILP.RegularPaymentAmountForIteration AS OriginalAmountDue,
							--ILP.RegularPaymentAmountForIteration - ILPR.RegularPaymentAmountForIteration AS AmountAppliedTowardsMonth,
							CASE WHEN	(CASE	WHEN ILPR.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
																WHEN ILPR.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
																ELSE 0 
													END - ILPR.RegularPaymentAmountForIteration) > 0
										THEN	 CASE	WHEN ILPR.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
																WHEN ILPR.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
																ELSE 0 
													END - ILPR.RegularPaymentAmountForIteration
										ELSE 0
							END
							AS AmountAppliedTowardsMonth,
							CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) = 1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS AmountPaid,
							CASE	WHEN ILPR.DateOfTotalDue = @LoanEndDate THEN @OriginalLastMonthPayment
										WHEN ILPR.DateOfTotalDue < @LoanEndDate THEN @OriginalMonthlyPayment
										ELSE 0 
							END 
							AS OriginalDue, 
							--ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ISNULL(ILPR.LastStatementDate,ILP.LastStatementDate) AS ActualStatementdate	
						FROM ILPScheduleDetailsRevised ILPR WITH (NOLOCK) 
						JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)  
						LEFT JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = ILPR.acctId AND ILP.DateOfNextStmt = ILPR.DateOfNextStmt)
						--JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE @DateOfNextStmt < ILPR.DateOfNextStmt AND ILPR.scheduleid = @ScheduleID AND ILPR.LoanTerm > 0
						AND ILPR.DateOfTotalDue >= @LoanStartDate
						AND ILPR.DateOfTotalDue <= @LastTermDate

					--SELECT * FROM @TempUnbilledTerms

				END
			ELSE
				BEGIN
					INSERT INTO @tempCurrentunbilledterms  
						SELECT 
							CP.acctId,    
							0 AS TermNumber ,   
							0 AS LoanTerm ,   
							'840' AS CurrencyCode ,   
							ILPR.RegularPaymentAmountForIteration - ISNULL(CP.AmountOfPaymentsCTD - CP.AmountOfreturnsCTD, 0) AS RegularPaymentAmountForIteration,  
							ISNULL(CP.AmountOfPaymentsCTD, 0) AS Paid, --ISNULL(CP.AmountOfPaymentsCTD - CP.AmountOfreturnsCTD, 0) AS Paid, 
							ILPR.DateOfTotalDue AS Due ,   
							@DateOfNextStmt,
							TJI.StmtHeader_UUID AS StatementUUID,
							TJI.CurrentDue AS OriginalAmountDue, --ILPR.RegularPaymentAmountForIteration AS OriginalAmountDue,
							0 AS AmountAppliedTowardsMonth,
							CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) =1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS AmountPaid,
							ISNULL(ILPR.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ILPR.LastStatementDate AS ActualStatementdate
						FROM ILPScheduleDetails ILPR WITH (NOLOCK) 
						JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)
						LEFT JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPCC.acctId = ILPR.acctId)
						LEFT JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (CPCC.acctId = CP.acctId)  
						LEFT JOIN @TempJobID TJI ON (TJI.PlanId = CPCC.acctId AND TJI.DateOfTotalDue = ILPR.DateOfTotalDue)
						--JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE 
						@CurrentTime > ILPR.LastStatementDate
						AND CASE WHEN @CurrentTime > CPCC.FirstDueDate THEN @CurrentTime ELSE CPCC.FirstDueDate END <= ILPR.DateOfNextStmt
						AND ILPR.LastStatementDate IS NOT NULL 
						AND ILPR.scheduleid = @ScheduleID
						AND ILPR.DateOfTotalDue >= @LoanStartDate
						AND ILPR.DateOfTotalDue <= @LastTermDate

					--SELECT * FROM @tempCurrentunbilledterms
	
					INSERT INTO @TempUnbilledTerms 
						SELECT 
							ILPR.acctId,
							ILPR.LoanTerm AS TermNumber , 
							ILPR.LoanTerm AS LoanTerm , 
							'840' AS CurrencyCode , 
							ILPR.RegularPaymentAmountForIteration AS RegularPaymentAmountForIteration,
							0 AS Paid,
							ILPR.DateOfTotalDue AS Due , 
							ILPR.StatementDate,
							NULL AS StatementUUID,
							NULL AS OriginalAmountDue, --ILPR.RegularPaymentAmountForIteration AS OriginalAmountDue,
							0 AS AmountAppliedTowardsMonth,
							CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) = 1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS AmountPaid,
							ISNULL(ILPR.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ILPR.LastStatementDate AS ActualStatementdate				
						FROM ILPScheduleDetails ILPR WITH (NOLOCK)
						JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE @DateOfNextStmt < ILPR.DateOfNextStmt AND ILPR.scheduleid = @ScheduleID AND ILPR.LoanTerm > 0
						AND ILPR.DateOfTotalDue >= @LoanStartDate
						AND ILPR.DateOfTotalDue <= @LastTermDate
				END

				--SELECT * FROM @TempUnbilledTerms


			DECLARE @UnBilledAmount TABLE
			(
				PlanID				INT,
				UnBilledAmount		MONEY
			)

			INSERT INTO @UnBilledAmount
				SELECT PlanID, SUM(AmountAppliedTowardsMonth) 
			FROM  @TempUnbilledTerms
			GROUP BY PlanID

			--SELECT CC.OriginalPurchaseAmount - (CC.currentbalanceco + CPS.CurrentBalance  ) - ISNULL(TU.UnBilledAmount, 0), 
			--ISNULL(TU.UnBilledAmount, 0), CC.OriginalPurchaseAmount, CC.currentbalanceco, CPS.CurrentBalance
			--FROM #TempPlan TT
			--JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (TT.PlanId = CC.acctId)
			--JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPS.acctId = CC.acctId)
			--LEFT JOIN @UnBilledAmount TU ON (TU.PlanID = TT.PlanId)
			
			UPDATE TT
				SET 
					TT.AmountPaid = CC.OriginalPurchaseAmount - (CC.currentbalanceco + CPS.CurrentBalance) - ISNULL(TU.UnBilledAmount, 0),
					TT.OutstandingLoanAmount = CPS.CurrentBalance + CC.currentbalanceco
				FROM @TempPlan TT
				JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (TT.PlanId = CC.acctId)
				JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPS.acctId = CC.acctId)
				LEFT JOIN @UnBilledAmount TU ON (TU.PlanID = TT.PlanId)

			--SELECT * FROM @TempPlan

			SELECT TOP 1 @OutstandingLoanAmount = OutstandingLoanAmount FROM @TempPlan
			--print  'before'
			--print  @LastTermDate
 
			SET  @LastTermDateOLD  = @LastTermDate
				
			SELECT @CountArray  = COUNT(1)  FROM @TempBilledTerms WHERE SkipSchedule  = 0 AND Ranking = 1 AND Due <= @LastTermDate
			SELECT @CountArray  = @CountArray + COUNT(1)  FROM @tempCurrentunbilledterms WHERE SkipSchedule  = 0 AND Due <= @LastTermDate
			SELECT @CountArray  = @CountArray + COUNT(1)  FROM @TempUnbilledTerms WHERE SkipSchedule  = 0 AND Due <= @LastTermDate
			
			IF(@CountArray < @LoanTerm)
			BEGIN 
						
				IF(@BillingCycle  = '31')
				BEGIN 
					SET @LastTermDate  =  
					DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@LoanTerm - @CountArray,@LastTermDate)) AS DATETIME))
				END
				ELSE IF (@BillingCycle  = '365')
				BEGIN 
					SET @LastTermDate  =  DATEADD (DAY,@LoanTerm - @CountArray,@LastTermDate)
				END 
				ELSE 
				BEGIN 						   
						   
					;WITH CTEMax
					AS
					(
						SELECT TOP(@LoanTerm - @CountArray)  Period_Time  FROM periodtable WITH (NOLOCK)  
						WHERE period_name = 'STMT.' + @BillingCycle  AND  Period_Time > @LastTermDateOLD  
						ORDER  BY Period_Time
					)

					SELECT  @LastTermDate= MAX(Period_Time) FROM CTEMax

				END 

				UPDATE   U 
				SET  
					AmountAppliedTowardsMonth = 
						CASE	WHEN (	CASE WHEN ILPR.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
										WHEN ILPR.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
										ELSE 0 
										END - U.RegularPaymentAmountForIteration) > 0
								THEN	CASE WHEN ILPR.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
										WHEN ILPR.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
										ELSE 0 
										END - U.RegularPaymentAmountForIteration
								ELSE 0
						END
				FROM @TempUnbilledTerms  U  
				JOIN ILPScheduleDetailsRevised ILPR WITH (NOLOCK) on (U.StatementDate = ILPR.StatementDate AND U.PlanID  = ILPR.acctId  )
				JOIN @TempPlan TT ON (ILPR.acctid = TT.planid)   
				WHERE ILPR.DateOfTotalDue >= @LastTermDateOLD

			END 
			ELSE IF (@CountArray > @LoanTerm)
			BEGIN
			
				SELECT TOP 1 @KeepExtendedSchedule = 1
				FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)  
				WHERE ILPS.parent02AID = @AccountID AND ILPS.PlanID = @PlanID  
				AND ISNULL(ILPS.ReageReversed, 0) = 0 AND (ILPS.Activity = 28 OR ILPS.Activity = 12 OR ILPS.Activity = 32 OR ILPS.Activity = 31)

				IF(@KeepExtendedSchedule = 0)
				BEGIN
					IF(@BillingCycle  = '31')
					BEGIN 
						SET @LastTermDate  =  
						DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@LoanTerm - @CountArray,@LastTermDate)) AS DATETIME))
					END
					ELSE IF (@BillingCycle  = '365')
					BEGIN 
						SET @LastTermDate  =  DATEADD (DAY,@LoanTerm - @CountArray,@LastTermDate)
					END 
					ELSE 
					BEGIN 						   
						   
						;WITH CTEMax
						AS
						(
							SELECT TOP(@CountArray - @LoanTerm)  Period_Time  FROM periodtable WITH (NOLOCK)  
							WHERE period_name = 'STMT.' + @BillingCycle  AND  Period_Time > @LastTermDateOLD  
							ORDER  BY Period_Time
						)

						SELECT  @LastTermDate= MAX(Period_Time) FROM CTEMax

					END
				END
				--SET @LastTermDate  =  DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@LoanTerm - @CountArray,@LastTermDate)) AS DATETIME ))
			END 

			--print  @LastTermDate

			INSERT INTO @tempmergedschedule 
				SELECT 
					TB.PlanID,
					TermNumber, 
					LoanTerm, 
					CurrencyCode, 
					RegularPaymentAmountForIteration, 
					Paid, 
					Due, 
					StatementDate,
					StatementUUID,
					OriginalAmountDue,
					AmountAppliedTowardsMonth,
					TT.AmountPaid,
					OriginalDue,
					ActualStatementdate		
				FROM @TempBilledTerms TB
				JOIN @TempPlan TT ON (TB.PlanID = TT.PlanId)
				WHERE Ranking = 1 /*AND stmtRanking > 1*/ AND SkipSchedule = 0
			UNION 
				SELECT 
					TB.PlanID,
					TermNumber, 
					LoanTerm, 
					CurrencyCode, 
					RegularPaymentAmountForIteration, 
					Paid, 
					Due, 
					StatementDate,
					StatementUUID,
					OriginalAmountDue,
					AmountAppliedTowardsMonth ,
					TT.AmountPaid,
					OriginalDue,
					ActualStatementdate	
				FROM @tempCurrentunbilledterms 	TB			
				JOIN @TempPlan TT ON (TB.PlanID = TT.PlanId)
				WHERE SkipSchedule = 0 
			UNION 
				SELECT
					PlanID, 
					TermNumber, 
					LoanTerm, 
					CurrencyCode, 
					RegularPaymentAmountForIteration, 
					Paid, 
					Due, 
					StatementDate,
					StatementUUID,
					OriginalAmountDue,
					AmountAppliedTowardsMonth,
					AmountPaid,
					OriginalDue,
					ActualStatementdate			
				FROM @TempUnbilledTerms WHERE SkipSchedule = 0

				--SELECT * FROM @tempmergedschedule

			--IF(@RevisedLoanTerm > @LoanTerm)   
			--	SET @LoanTerm = @RevisedLoanTerm 

			IF(@OriginalLoanEndDate > @LoanEndDate)
				SET @LoanEndDate = @OriginalLoanEndDate

				INSERT INTO @tempTermsOnPaymentApplied
					SELECT
					PlanID,
					ROW_NUMBER() OVER (PARTITION BY CurrencyCode ORDER BY StatementDate, due ASC) AS TermNumber, 
					@LoanTerm AS LoanTerm, 
					CurrencyCode, 
					RegularPaymentAmountForIteration, 
					Paid, 
					Due, 
					StatementDate,
					StatementUUID,
					OriginalAmountDue,
					AmountAppliedTowardsMonth,
					AmountPaid,
					OriginalDue,
					ActualStatementdate	
				FROM @tempmergedschedule

				--SELECT * FROM @tempTermsOnPaymentApplied

				SELECT @CountArray1 = COUNT(1) FROM @tempTermsOnPaymentApplied 

				IF (@CountArray1 < @LoanTerm)
				BEGIN
					DECLARE  @tempTermsOnPaymentAppliedExtended   TABLE
					(   
						PlanID								INT,
						TermNumber							INT,   
						LoanTerm							INT,   
						CurrencyCode						INT,   
						RegularPaymentAmountForIteration	MONEY,   
						Paid								MONEY,   
						Due									DATETIME,    
						StatementDate						DATETIME,
						StatementUUID						VARCHAR(64),
						OriginalAmountDue					MONEY,
						AmountAppliedTowardsMonth			MONEY,
						AmountPaid							MONEY,
						OriginalDue							MONEY,
						ActualStatementdate					DATETIME
					)

					SELECT @MaxLoanTerm= MAX(TermNumber) FROM @tempTermsOnPaymentApplied 
					--print @MaxLoanTerm
					 
					SELECT @DateofTotalDueExtended = Due from @tempTermsOnPaymentApplied  T  WHERE TermNumber = @MaxLoanTerm 
					IF(@BillingCycle = '31')
					BEGIN 
						SET  @LasttermDate  = DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@LoanTerm - @CountArray1, @DateofTotalDueExtended)) AS DATETIME ))
					END
					ELSE IF(@BillingCycle = '365')
					BEGIN 
						SET  @LasttermDate  = DATEADD ( DAY,@LoanTerm - @CountArray1, @DateofTotalDueExtended)
					END 
					ELSE 
					BEGIN 
						;WITH CTEMax
						AS
						(
							SELECT  TOP(@LoanTerm - @CountArray1)  Period_Time  FROM periodtable WITH (NOLOCK)  
							WHERE  period_name = 'STMT.' + @BillingCycle  and  Period_Time  > @DateofTotalDueExtended  
							ORDER  BY Period_Time
						)

						SELECT  @LastTermDate= MAX(Period_Time)   from  CTEMax

					END
					
					WHILE(@CountArray1 < @LoanTerm)
					BEGIN 
						
						SET @CountArray1	= @CountArray1 + 1 
						SET @CountExtended  = @CountExtended + 1 


						IF(@CountExtended > 99)
						BEGIN 
							BREAK;
						END 
						--print @OriginalLastMonthPayment
						--print @OriginalMonthlyPayment
						--print @OriginalLoanEndDate
						--print  'lasttermdate'
						--print @LastTermDate

						IF(@BillingCycle = '31')
						BEGIN 
							INSERT INTO  @tempTermsOnPaymentAppliedExtended
							SELECT   
							PlanID,
							TermNumber +@CountExtended ,
							LoanTerm,
							CurrencyCode,
							RegularPaymentAmountForIteration,
							Paid,
							DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,Due)) AS DATETIME )),
							DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,StatementDate)) AS DATETIME )),
							null ,
							OriginalAmountDue, 
							CASE	WHEN	(	CASE	WHEN DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,Due)) AS DATETIME )) =
															CASE	WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
																	WHEN DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,Due)) AS DATETIME )) < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate 
																	ELSE @OriginalLoanEndDate 
															END 
														THEN @OriginalMonthlyPayment
														ELSE 0 
												END - T.RegularPaymentAmountForIteration) > 0
									THEN CASE	WHEN  DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,Due)) AS DATETIME )) = 
													CASE	WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END	THEN @OriginalLastMonthPayment
															WHEN  DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,Due)) AS DATETIME )) < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END
															THEN @OriginalMonthlyPayment
															ELSE 0 
													END - T.RegularPaymentAmountForIteration
									ELSE 0
							END AS AmountAppliedTowardsMonth
							,
							AmountPaid,OriginalDue,
							DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH,@CountExtended,ActualStatementdate)) AS DATETIME ))
							FROM @tempTermsOnPaymentApplied  T
							WHERE TermNumber = @MaxLoanTerm
						END 
						ELSE IF (@BillingCycle = '365')
						BEGIN 
							INSERT INTO  @tempTermsOnPaymentAppliedExtended
							SELECT   
							PlanID,
							TermNumber +@CountExtended ,
							LoanTerm,
							CurrencyCode,
							RegularPaymentAmountForIteration,
							Paid,
							DATEADD ( DAY,@CountExtended,Due),
							DATEADD ( DAY,@CountExtended,StatementDate),
							null ,
							OriginalAmountDue, 
							CASE WHEN	(CASE	WHEN DATEADD ( DAY,@CountExtended,Due) = CASE
								WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
																WHEN   DATEADD ( DAY,@CountExtended,Due) < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END 
																THEN @OriginalMonthlyPayment
																ELSE 0 
													END - T.RegularPaymentAmountForIteration) > 0
										THEN	 CASE	WHEN  DATEADD ( DAY,@CountExtended,Due) = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END
											THEN @OriginalLastMonthPayment
																WHEN  DATEADD ( DAY,@CountExtended,Due) < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END
																	THEN @OriginalMonthlyPayment
																ELSE 0 
													END - T.RegularPaymentAmountForIteration
										ELSE 0
							END as AmountAppliedTowardsMonth,
							AmountPaid,OriginalDue,
							DATEADD ( DAY,@CountExtended,ActualStatementdate)
							from @tempTermsOnPaymentApplied  T
							WHERE TermNumber = @MaxLoanTerm
						End
						ELSE 
						BEGIN 
							
							SET @DateofTotalDueExtended = dbo.UDF_GetPeriodBoundary('STMT.'+ @BillingCycle,@DateofTotalDueExtended,@CountExtended )
						
							INSERT INTO  @tempTermsOnPaymentAppliedExtended
							SELECT   
							PlanID,
							TermNumber +@CountExtended ,
							LoanTerm,
							CurrencyCode,
							RegularPaymentAmountForIteration,
							Paid,
							@DateofTotalDueExtended,
							dbo.UDF_GetPeriodBoundary('STMT.'+ @BillingCycle,StatementDate,@CountExtended ),
							null ,
							OriginalAmountDue, 
							CASE WHEN	(CASE	WHEN @DateofTotalDueExtended = CASE
								WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
																WHEN  @DateofTotalDueExtended < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END 
																THEN @OriginalMonthlyPayment
																ELSE 0 
													END - T.RegularPaymentAmountForIteration) > 0
										THEN	 CASE	WHEN  @DateofTotalDueExtended = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END
											THEN @OriginalLastMonthPayment
																WHEN  @DateofTotalDueExtended < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END
																	THEN @OriginalMonthlyPayment
																ELSE 0 
													END - T.RegularPaymentAmountForIteration
										ELSE 0
							END as AmountAppliedTowardsMonth,
							AmountPaid,OriginalDue,
							dbo.UDF_GetPeriodBoundary('STMT.'+ @BillingCycle,ActualStatementdate,@CountExtended )
							FROM @tempTermsOnPaymentApplied  T
							WHERE TermNumber = @MaxLoanTerm
						END  
					END 

					INSERT INTO @tempTermsOnPaymentApplied
					SELECT  
					TEX.PlanID,
					TermNumber,
					LoanTerm,
					CurrencyCode,
					RegularPaymentAmountForIteration,
					Paid,
					Due,
					TEX.StatementDate,
					TJI.StmtHeader_UUID,--StatementUUID,
					OriginalAmountDue,
					AmountAppliedTowardsMonth,
					AmountPaid,
					OriginalDue,
					ActualStatementdate 
					FROM @tempTermsOnPaymentAppliedExtended TEX
					LEFT JOIN @TempJobID TJI ON (TEX.ActualStatementdate = TJI.StatementDate)
				END

			--SELECT * FROM @tempTermsOnPaymentApplied

			IF(@OriginalMonthlyPayment > 0)
			BEGIN
				INSERT INTO @TempILPSchedule
					SELECT
						TermNumber,
						LoanTerm,
						CurrencyCode,
						CASE WHEN RegularPaymentAmountForIteration > 0 THEN RegularPaymentAmountForIteration ELSE 0 END AS RegularPaymentAmountForIteration,
						Paid,
						Due,
						StatementUUID,
						OriginalAmountDue,
						CASE 
							WHEN AmountPaid > 0 AND CEILING(AmountPaid / @OriginalMonthlyPayment) >= TermNumber THEN
								CASE 
									WHEN ((AmountPaid - OriginalDue*(TermNumber - 1) >= OriginalDue) OR (RegularPaymentAmountForIteration = 0 AND Paid >= OriginalDue)) THEN OriginalDue
									WHEN AmountPaid - OriginalDue*(TermNumber - 1) > 0 THEN AmountPaid - OriginalDue*(TermNumber - 1)
									ELSE 
										CASE 
											WHEN ISNULL(OriginalDue, 0) - CASE WHEN RegularPaymentAmountForIteration > 0 THEN RegularPaymentAmountForIteration ELSE 0 END > 0
											THEN ISNULL(OriginalDue, 0) - CASE WHEN RegularPaymentAmountForIteration > 0 THEN RegularPaymentAmountForIteration ELSE 0 END
											ELSE 0 END
								END
							ELSE 
							CASE 
								WHEN TermNumber > @LoanTerm THEN 0
								ELSE 
									CASE WHEN AmountAppliedTowardsMonth > 0 THEN AmountAppliedTowardsMonth ELSE 0 END
							END
						END
						AS
						AmountAppliedTowardsMonth,
						ActualStatementdate	AS StatementDate,
						CASE WHEN StatementUUID IS NOT NULL AND ISNULL(OriginalAmountDue, 0) > 0 THEN 'True' ELSE 'False' END AS InstallmentCharged
					FROM @tempTermsOnPaymentApplied 
					WHERE Due <= @LastTermDate

				--SELECT * FROM @tempTermsOnPaymentApplied
				--SELECT * FROM @TempILPSchedule

				SELECT @CalculatedLoanTerm = MAX(TermNumber) FROM @TempILPSchedule

				IF(@CalculatedLoanTerm > @LoanTerm)
				BEGIN

					DECLARE		@SUM_ExtraAmount		MONEY,
								@ExtraAmountApplied		MONEY,
								@ExtraTerms				INT

					SET @ExtraTerms = @CalculatedLoanTerm - @LoanTerm

					SELECT @SUM_ExtraAmount = @OriginalLoanAmount - (SUM(AmountAppliedTowardsMonth) + @OutstandingLoanAmount) FROM @TempILPSchedule

					--SELECT SUM(AmountAppliedTowardsMonth) , SUM(RegularPaymentAmountForIteration) FROM @TempILPSchedule

					WHILE(@ExtraTerms > 0 AND @SUM_ExtraAmount > 0)
					BEGIN
						-- SET @ExtraAmountApplied = @SUM_ExtraAmount - @OriginalMonthlyPayment * (@ExtraTerms - 1)

						SET @DistributionAmount = CASE WHEN @ExtraTerms = @CalculatedLoanTerm - @LoanTerm THEN @OriginalLastMonthPayment ELSE @OriginalMonthlyPayment END

						SET @ExtraAmountApplied = CASE WHEN @DistributionAmount < @SUM_ExtraAmount THEN @DistributionAmount ELSE @SUM_ExtraAmount END

						IF(@SUM_ExtraAmount > 0)
						BEGIN
							UPDATE @TempILPSchedule
								SET 
									AmountAppliedTowardsMonth = @ExtraAmountApplied
								WHERE TermNumber = @LoanTerm + @ExtraTerms
							
							SET @SUM_ExtraAmount = @SUM_ExtraAmount - @ExtraAmountApplied
						END
						SET @ExtraTerms = @ExtraTerms - 1
					END
				END
			END		
		END
	END

	SELECT  
		TermNumber,
		@CalculatedLoanTerm AS LoanTerm,
		CurrencyCode,
		CASE WHEN TermNumber = 0 THEN 0 ELSE RegularPaymentAmountForIteration END AS RegularPaymentAmountForIteration,
		Paid,
		Due,
		StatementUUID,
		CASE WHEN termnumber = 0 THEN 0 ELSE OriginalAmountDue END AS OriginalAmountDue,
		CASE WHEN termnumber = 0 THEN 0 ELSE AmountAppliedTowardsMonth END AS AmountAppliedTowardsMonth,
		StatementDate,
		InstallmentCharged
	FROM @TempILPSchedule 
	--WHERE TermNumber <= @LoanTerm AND TermNumber <> 0


	DROP TABLE IF EXISTS #TempPlan  
	DROP TABLE IF EXISTS #TempBilledTerms  
	DROP TABLE IF EXISTS #TempUnbilledTerms  
	DROP TABLE IF EXISTS #tempmergedschedule  
	DROP TABLE IF EXISTS #TempILPSchedule
	DROP TABLE IF EXISTS #tempCurrentunbilledterms  
	DROP TABLE IF EXISTS #TempJobID  
	DROP TABLE IF EXISTS #tempTermsOnPaymentApplied
	DROP TABLE IF EXISTS #tempTermsOnPaymentAppliedExtended  
	DROP TABLE IF EXISTS #TempSummaryHeaderRecords 

	SELECT * INTO #TempPlan FROM @TempPlan
	SELECT * INTO #TempBilledTerms FROM @TempBilledTerms
	SELECT * INTO #TempUnbilledTerms FROM @TempUnbilledTerms
	SELECT * INTO #tempmergedschedule FROM @tempmergedschedule
	SELECT * INTO #TempILPSchedule FROM @TempILPSchedule
	SELECT * INTO #tempCurrentunbilledterms FROM @tempCurrentunbilledterms
	SELECT * INTO #TempJobID FROM @TempJobID
	SELECT * INTO #tempTermsOnPaymentApplied FROM @tempTermsOnPaymentApplied
	SELECT * INTO #tempTermsOnPaymentAppliedExtended FROM @tempTermsOnPaymentAppliedExtended
	SELECT * INTO #TempSummaryHeaderRecords FROM @TempSummaryHeaderRecords

	--SELECT * FROM #TempPlan  
	--SELECT * FROM #TempBilledTerms  
	--SELECT * FROM #TempUnbilledTerms  
	--SELECT * FROM #tempmergedschedule  
	--SELECT * FROM #TempILPSchedule
	--SELECT * FROM #tempCurrentunbilledterms  
	--SELECT * FROM #TempJobID  
	--SELECT * FROM #tempTermsOnPaymentApplied
	--SELECT * FROM #tempTermsOnPaymentAppliedExtended  
	--SELECT * FROM #TempSummaryHeaderRecords 

	


END