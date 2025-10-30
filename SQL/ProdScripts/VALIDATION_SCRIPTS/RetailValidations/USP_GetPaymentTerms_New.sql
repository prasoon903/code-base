DECLARE
	@AccountID					INT = 5554 ,   
	@PlanID							INT = 6519919,   
	@CurrentTime				DATETIME = GETDATE(),   
	@LastStatementDate	DATETIME = '2020-06-30 23:59:57.000',   
	@ScheduleID					DECIMAL(19,0) = 900719,   
	@ScheduleIndicator		INT = 2
 
BEGIN 
	-- Author	 :: PRASOON PARASHAR
	-- Purpose	 :: Retail Implementation
  
	SET NOCOUNT ON 
	 
	DROP TABLE IF EXISTS #TempPlan  
	DROP TABLE IF EXISTS #TempBilledTerms  
	DROP TABLE IF EXISTS #TempUnbilledTerms  
	DROP TABLE IF EXISTS #tempmergedschedule  
	DROP TABLE IF EXISTS #TempILPSchedule
	DROP TABLE IF EXISTS #tempCurrentunbilledterms  
	DROP TABLE IF EXISTS #TempJobID  
	DROP TABLE IF EXISTS #tempTermsOnPaymentApplied  
  
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
			@DistributionAmount					MONEY

	SELECT 
		@DateOfNextStmt		= DateOfNextStmt,
		@dateofTotalDue		= BCC.DateOfTotalDue
	FROM BSegment_Primary  B WITH (NOLOCK)  
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (B.acctid = BCC.acctId) 
	WHERE B.acctId = @AccountID 

	SELECT 
		@LoanTerm				= LoanTerm,   
		@RevisedLoanTerm		= RevisedLoanTerm,
		@LoanEndDate			= LoanEndDate,
		@OriginalLoanEndDate	= OriginalLoanEndDate,
		@MaturityDate			= MaturityDate,
		@LastTermDate			= LastTermDate--,
		--@OutstandingLoanAmount	= CurrentBalance
	FROM   ILPScheduleDetailSummary WITH(NOLOCK)   
	WHERE  ScheduleID = @ScheduleID  

	SELECT
		@OriginalMonthlyPayment			= FirstMonthPayment,
		@OriginalLastMonthPayment		= LastMonthPayment,
		@OriginalLoanAmount				= OriginalLoanAmount
	FROM ILPScheduleDetailSummary WITH(NOLOCK) 
	WHERE parent02AID = @AccountID AND PlanID = @PlanID AND Activity = 1

   
	CREATE TABLE #TempILPSchedule   
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
 
		CREATE TABLE #TempPlan   
		(   
			PlanId			INT,
			AmountPaid		MONEY,
			OutstandingLoanAmount MONEY
		)  
  
		IF(@PlanID IS NULL OR  @PlanID = 0)   
		BEGIN   
			INSERT INTO #TempPlan   
				SELECT 
					CPA.acctId,
					0 AS AmountPaid,
					0 AS OutstandingLoanAmount
				FROM CPSgmentAccounts CPA WITH (nolock) 
				JOIN CPSgmentCreditCard CPCC with(nolock) on CPA.acctId = CPCC.acctId  
				WHERE  CPA.parent02aid = @AccountID --AND CPA.CurrentBalance + CPCC.CurrentBalanceCO > 0  
		END   
		ELSE   
		--BEGIN   
			--IF((
			--		SELECT CurrentBalance + CurrentBalanceCO 
			--		FROM   CPSgmentAccounts CPA WITH (nolock) 
			--		JOIN CPSgmentCreditCard CPCC with(nolock) ON (CPA.acctId = CPCC.acctId) 
			--		WHERE CPA.acctId = @PlanID
			--	) > 0)
			BEGIN
				INSERT INTO #TempPlan VALUES   
				(   
					@PlanID ,
					0,
					0
				)  
			END 
		--END

		IF(( SELECT COUNT(1) FROM #TempPlan ) > 0)  
		BEGIN   
			CREATE TABLE #TempBilledTerms   
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
			CREATE TABLE #TempUnbilledTerms   
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
			CREATE TABLE #tempCurrentunbilledterms   
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
			CREATE TABLE #tempTermsOnPaymentApplied   
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
			CREATE TABLE #tempmergedschedule   
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
			CREATE TABLE #TempJobID
			(
				PlanId								INT,
				StatementDate						DATETIME,
				DateOfTotalDue						DATETIME,
				StmtHeader_UUID						VARCHAR(64),
				AmountOfTotalDue					MONEY,
				CurrentDue							MONEY,
				CreditBalanceMovement				MONEY,
				CSHCurrentBalance					MONEY
			)

			INSERT INTO #TempJobID
				SELECT  
					SCC.acctId,
					SH.StatementDate,
					SCC.DateOfTotalDue,
					StmtHeader_UUID,
					SH.AmountOfTotalDue,
					SCC.CurrentDue,
					SCC.CreditBalanceMovement,
					CSH.CurrentBalance
				FROM SummaryHeaderCreditCard SCC WITH (NOLOCK)
				JOIN SummaryHeader SH WITH (nolock) ON (SH.acctid = SCC.acctid AND SH.StatementID = SCC.StatementID) 
				JOIN CurrentSummaryHeader CSH WITH (nolock) ON (SH.acctid = CSH.acctid AND SH.StatementID = CSH.StatementID) 
				JOIN #TempPlan TP ON (TP.planid = SCC.acctid)

				--SELECT * FROM #TempJobID 

			INSERT INTO #TempBilledTerms   
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
					CASE WHEN ISNULL(S.WaiveMinDue, 0) = 1 OR (TJI.CurrentDue <= 0 AND ISNULL(TJI.CreditBalanceMovement, 0) <= 0 AND ISNULL(TJI.CSHCurrentBalance, 0) < 0) /*OR ISNULL(ILP.IsDeferCycle,0) = 1*/ THEN 1 ELSE 0 END AS SkipSchedule,
					0 AS AmountPaid,
					CASE	WHEN ILP.DateOfTotalDue = CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalLastMonthPayment
								WHEN ILP.DateOfTotalDue < CASE WHEN @LastTermDate > @OriginalLoanEndDate THEN @LastTermDate ELSE @OriginalLoanEndDate END THEN @OriginalMonthlyPayment
								ELSE 0 
					END 
					AS OriginalDue, --ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
					ILP.LastStatementDate AS ActualStatementdate
				FROM   SummaryHeaderCreditCard SCC WITH (nolock) 
				JOIN SummaryHeader SH WITH (nolock) ON (SH.acctid = SCC.acctid AND SH.StatementID = SCC.StatementID) 
				JOIN StatementHeader S WITH (NOLOCK) ON (S.acctId = SH.parent02AID AND SH.StatementID = S.StatementID)
				LEFT JOIN #TempJobID TJI ON (TJI.PlanId = SCC.acctId AND TJI.DateOfTotalDue = SH.StatementDate)
				JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = SCC.acctId AND ILP.DateOfNextStmt = SH.StatementDate)
				JOIN #TempPlan TP ON (TP.planid = SCC.acctid)

			--SELECT * FROM #TempBilledTerms

			IF (@ScheduleIndicator = 2) 
			BEGIN
				INSERT INTO #tempCurrentunbilledterms  
					SELECT     
						CP.acctid,
						0 AS TermNumber ,   
						0 AS LoanTerm ,   
						'840' AS CurrencyCode ,   
						--CASE WHEN @dateofTotalDue <> ILPR.DateOfTotalDue THEN 0 ELSE CASE WHEN CPCC.currentbalanceco > 0 THEN CPCC.AmountOfTotalDue ELSE ILPR.RegularPaymentAmountForIteration END - ISNULL(CPCC.AmountOfCreditsAsPmtCTD - CP.AmountOfreturnsCTD - CP.AmountOfCreditsRevCTD, 0) END AS RegularPaymentAmountForIteration,
						CASE WHEN CPCC.currentbalanceco > 0 THEN CPCC.AmountOfTotalDue ELSE ILPR.RegularPaymentAmountForIteration END - ISNULL(CP.AmountOfPaymentsCTD, 0) AS RegularPaymentAmountForIteration,  
						ISNULL(CP.AmountOfPaymentsCTD, 0) AS Paid, --ISNULL(CP.AmountOfPaymentsCTD - CP.AmountOfReturnsCTD, 0) AS Paid,  
						ILPR.DateOfTotalDue AS Due ,   
						@DateOfNextStmt,
						TJI.StmtHeader_UUID AS StatementUUID,
						TJI.CurrentDue AS OriginalAmountDue, --ILP.RegularPaymentAmountForIteration AS OriginalAmountDue,
						0 AS AmountAppliedTowardsMonth,
						CASE 
							WHEN	((@dateofTotalDue <> ILPR.DateOfTotalDue OR (TJI.CurrentDue <= 0 AND ISNULL(TJI.CreditBalanceMovement, 0) <= 0 AND ISNULL(TJI.CSHCurrentBalance, 0) < 0)
												) AND @LastTermDate > @OriginalLoanEndDate) 
												/*OR ISNULL(ILPR.IsDeferCycle, 0) = 1*/ THEN 1 
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
					LEFT JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = ILPR.acctId AND ILP.DateOfNextStmt = ILPR.DateOfNextStmt) 
					LEFT JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPCC.acctId = ILPR.acctId)
					LEFT JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (CPCC.acctId = CP.acctId)  
					LEFT JOIN #TempJobID TJI ON (TJI.PlanId = CPCC.acctId AND TJI.DateOfTotalDue = ILPR.DateOfTotalDue)
					JOIN #TempPlan TT ON (ILPR.acctid = TT.planid)   
					WHERE 
					@CurrentTime > ILPR.LastStatementDate
					AND CASE WHEN @CurrentTime > CPCC.FirstDueDate THEN @CurrentTime ELSE CPCC.FirstDueDate END <= ILPR.DateOfNextStmt 
					AND ILPR.LastStatementDate IS NOT NULL
					AND ILPR.scheduleid = @ScheduleID 

					--SELECT * FROM #tempCurrentunbilledterms

					INSERT INTO #TempUnbilledTerms 
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
							--CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) = 1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS SkipSchedule,
							0 AS AmountPaid,
							CASE	WHEN ILPR.DateOfTotalDue = @LoanEndDate THEN @OriginalLastMonthPayment
										WHEN ILPR.DateOfTotalDue < @LoanEndDate THEN @OriginalMonthlyPayment
										ELSE 0 
							END 
							AS OriginalDue, 
							--ISNULL(ILP.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ISNULL(ILPR.LastStatementDate,ILP.LastStatementDate) AS ActualStatementdate	
						FROM ILPScheduleDetailsRevised ILPR WITH (NOLOCK) 
						LEFT JOIN ILPScheduleDetails ILP WITH (NOLOCK) ON ( ILP.acctId = ILPR.acctId AND ILP.DateOfNextStmt = ILPR.DateOfNextStmt)
						JOIN #TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE @DateOfNextStmt < ILPR.DateOfNextStmt AND ILPR.scheduleid = @ScheduleID AND ILPR.LoanTerm > 0

					--SELECT * FROM #TempUnbilledTerms

				END
			ELSE
				BEGIN
					INSERT INTO #tempCurrentunbilledterms  
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
							--CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) =1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS SkipSchedule,
							0 AS AmountPaid,
							ISNULL(ILPR.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ILPR.LastStatementDate AS ActualStatementdate
						FROM ILPScheduleDetails ILPR WITH (NOLOCK) 
						LEFT JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPCC.acctId = ILPR.acctId)
						LEFT JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (CPCC.acctId = CP.acctId)  
						LEFT JOIN #TempJobID TJI ON (TJI.PlanId = CPCC.acctId AND TJI.DateOfTotalDue = ILPR.DateOfTotalDue)
						JOIN #TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE 
						@CurrentTime > ILPR.LastStatementDate
						AND CASE WHEN @CurrentTime > CPCC.FirstDueDate THEN @CurrentTime ELSE CPCC.FirstDueDate END <= ILPR.DateOfNextStmt
						AND ILPR.LastStatementDate IS NOT NULL 
						AND ILPR.scheduleid = @ScheduleID

					--SELECT * FROM #tempCurrentunbilledterms
	
					INSERT INTO #TempUnbilledTerms 
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
							--CASE WHEN ISNULL(ILPR.IsDeferCycle, 0) = 1 THEN 1 ELSE 0 END AS SkipSchedule,
							0 AS SkipSchedule,
							0 AS AmountPaid,
							ISNULL(ILPR.RegularPaymentAmountForIteration, 0) AS OriginalDue,
							ILPR.LastStatementDate AS ActualStatementdate				
						FROM ILPScheduleDetails ILPR WITH (NOLOCK)
						JOIN #TempPlan TT ON (ILPR.acctid = TT.planid)   
						WHERE @DateOfNextStmt < ILPR.DateOfNextStmt AND ILPR.scheduleid = @ScheduleID AND ILPR.LoanTerm > 0

					--SELECT * FROM #TempUnbilledTerms
				END

			DECLARE @UnBilledAmount TABLE
			(
				PlanID				INT,
				UnBilledAmount		MONEY
			)

			INSERT INTO @UnBilledAmount
				SELECT PlanID, SUM(AmountAppliedTowardsMonth) 
			FROM  #TempUnbilledTerms
			GROUP BY PlanID

			--SELECT CC.OriginalPurchaseAmount - (CC.currentbalanceco + CPS.CurrentBalance  ) - TU.UnBilledAmount, TU.UnBilledAmount
			--FROM #TempPlan TT
			--JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (TT.PlanId = CC.acctId)
			--JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPS.acctId = CC.acctId)
			--LEFT JOIN @UnBilledAmount TU ON (TU.PlanID = TT.PlanId)
			
			UPDATE TT
				SET 
					TT.AmountPaid = CC.OriginalPurchaseAmount - (CC.currentbalanceco + CPS.CurrentBalance) - TU.UnBilledAmount,
					TT.OutstandingLoanAmount = CPS.CurrentBalance + CC.currentbalanceco
				FROM #TempPlan TT
				JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (TT.PlanId = CC.acctId)
				JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (CPS.acctId = CC.acctId)
				LEFT JOIN @UnBilledAmount TU ON (TU.PlanID = TT.PlanId)

			--SELECT * FROM #TempPlan

			SELECT TOP 1 @OutstandingLoanAmount = OutstandingLoanAmount FROM #TempPlan

			INSERT INTO #tempmergedschedule 
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
				FROM #TempBilledTerms TB
				JOIN #TempPlan TT ON (TB.PlanID = TT.PlanId)
				WHERE Ranking = 1 AND stmtRanking > 1 AND SkipSchedule = 0
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
				FROM #tempCurrentunbilledterms 	TB			
				JOIN #TempPlan TT ON (TB.PlanID = TT.PlanId)
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
				FROM #TempUnbilledTerms WHERE SkipSchedule = 0

				--SELECT * FROM #tempmergedschedule

			IF(@RevisedLoanTerm > @LoanTerm)   
				SET @LoanTerm = @RevisedLoanTerm 

			IF(@OriginalLoanEndDate > @LoanEndDate)
				SET @LoanEndDate = @OriginalLoanEndDate

				INSERT INTO #tempTermsOnPaymentApplied
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
				FROM #tempmergedschedule

				--SELECT * FROM #tempTermsOnPaymentApplied

			INSERT INTO #TempILPSchedule
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
								WHEN AmountPaid - OriginalDue*(TermNumber - 1) >= OriginalDue THEN OriginalDue
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
				FROM #tempTermsOnPaymentApplied WITH(nolock) 
				WHERE Due <= @LastTermDate

			--SELECT * FROM #TempILPSchedule

			SELECT @CalculatedLoanTerm = MAX(TermNumber) FROM #TempILPSchedule

			IF(@CalculatedLoanTerm > @LoanTerm)
			BEGIN

				DECLARE		@SUM_ExtraAmount		MONEY,
							@ExtraAmountApplied		MONEY,
							@ExtraTerms				INT

				SET @ExtraTerms = @CalculatedLoanTerm - @LoanTerm

				SELECT @SUM_ExtraAmount = @OriginalLoanAmount - (SUM(AmountAppliedTowardsMonth) + @OutstandingLoanAmount) FROM #TempILPSchedule

				--SELECT SUM(AmountAppliedTowardsMonth) , SUM(RegularPaymentAmountForIteration) FROM #TempILPSchedule

				WHILE(@ExtraTerms > 0 AND @SUM_ExtraAmount > 0)
				BEGIN
					-- SET @ExtraAmountApplied = @SUM_ExtraAmount - @OriginalMonthlyPayment * (@ExtraTerms - 1)

					SET @DistributionAmount = CASE WHEN @ExtraTerms = @CalculatedLoanTerm - @LoanTerm THEN @OriginalLastMonthPayment ELSE @OriginalMonthlyPayment END

					SET @ExtraAmountApplied = CASE WHEN @DistributionAmount < @SUM_ExtraAmount THEN @DistributionAmount ELSE @SUM_ExtraAmount END

					IF(@SUM_ExtraAmount > 0)
					BEGIN
						UPDATE #TempILPSchedule
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

	SELECT  
		TermNumber,
		@CalculatedLoanTerm AS LoanTerm,
		CurrencyCode,
		CASE WHEN termnumber = 0 THEN 0 ELSE regularpaymentamountforiteration END AS regularpaymentamountforiteration,
		Paid,
		Due,
		StatementUUID,
		CASE WHEN termnumber = 0 THEN 0 ELSE OriginalAmountDue END AS OriginalAmountDue,
		CASE WHEN termnumber = 0 THEN 0 ELSE AmountAppliedTowardsMonth END AS AmountAppliedTowardsMonth,
		StatementDate,
		InstallmentCharged
	FROM #TempILPSchedule 
	--WHERE TermNumber <= @LoanTerm AND TermNumber <> 0
END