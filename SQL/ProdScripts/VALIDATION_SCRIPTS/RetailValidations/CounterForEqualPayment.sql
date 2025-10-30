SET NOCOUNT ON

--DROP TABLE IF EXISTS #TempCounterCorrection
--DROP TABLE IF EXISTS #TempTotalPlans


--CREATE TABLE #TempCounterCorrection
--(PlanID DECIMAL(19, 0), StatementDate DATETIME, StatementID DECIMAL(19, 0), LoanDate DATETIME, 
--LoanEndDate DATETIME, CounterForEqualPayment INT, CalculatedCounter INT, CurrentDue MONEY, 
--CurrentBalance MONEY, ScheduleID DECIMAL(19, 0), JobStatus INT)


--SELECT PlanID, 0 ProcessedStatus
--INTO #TempTotalPlans
--FROM BKP_ILPScheduleDetailSummary_20201022 WITH (NOLOCK)
--GROUP BY PlanID

DECLARE @PlanCount INT = 100

DROP TABLE IF EXISTS #PlansToCorrect

SELECT TOP(@PlanCount)* INTO #PlansToCorrect FROM #TempTotalPlans WHERE ProcessedStatus = 0

WHILE((SELECT COUNT(1) FROM #PlansToCorrect WHERE ProcessedStatus = 0) > 0)
BEGIN 
	
	DECLARE @PlanID DECIMAL(19, 0) --= 6551893 --6551893

	SELECT TOP(1) @PlanID = PlanID FROM #PlansToCorrect WHERE ProcessedStatus = 0

	IF(@PlanID IS NOT NULL AND @PlanID > 0)
	BEGIN 
		DECLARE @StatementDate DATETIME, @LoanEndDate DATETIME, @Period_time DATETIME, @ScheduleID DECIMAL(19,0), @LoanDate DATETIME

		DROP TABLE IF EXISTS #TempData
		DROP TABLE IF EXISTS #TempILPRecords


		SELECT PlanID, ScheduleID, LoanDate, LoanEndDate, LastStatementDate, GETDATE() AS StatementDate
		INTO #TempILPRecords
		FROM ILPScheduleDetailSummary WITH (NOLOCK)
		WHERE PlanID = @PlanID

		DECLARE PT_Cursor CURSOR FOR
		SELECT ScheduleID, LoanDate FROM #TempILPRecords

		OPEN PT_Cursor
		FETCH NEXT FROM PT_Cursor INTO @ScheduleID, @LoanDate

		WHILE @@FETCH_STATUS = 0
		BEGIN 
			SELECT TOP (1) @Period_time = period_time 
			FROM periodtable WITH (NOLOCK)
			WHERE period_name='MTD' AND period_time >= @LoanDate
			ORDER BY period_time ASC

			UPDATE #TempILPRecords SET StatementDate = @Period_time WHERE ScheduleID = @ScheduleID
			--SELECT @Period_time, * FROM #TempILPRecords WHERE ScheduleID = @ScheduleID

			FETCH NEXT FROM PT_Cursor INTO @ScheduleID, @LoanDate
		END

		--SELECT * FROM #TempILPRecords

		CLOSE PT_Cursor
		DEALLOCATE PT_Cursor

		SELECT 
			SH.acctId PlanID, SH.StatementDate, SH.StatementID, SHCC.CurrentDue, SH.CurrentBalance, SH.CounterForEqualPayment, ILP.ScheduleID, ILP.LoanDate,ILP.LoanEndDate, SHCC.MaturityDate
		INTO #TempData
		FROM SummaryHeader SH WITH (NOLOCK)
		JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SHCC.acctId = SH.acctId AND SHCC.StatementID = SH.StatementID)
		LEFT JOIN #TempILPRecords ILP WITH (NOLOCK) ON (ILP.PlanId = SH.acctId AND SH.StatementDate = ILP.StatementDate)
		WHERE SH.acctId = @PlanID

		WHILE((SELECT COUNT(1) FROM #TempData WHERE LoanEndDate IS NULL) > 0)
		BEGIN
			SELECT TOP 1 @StatementDate = StatementDate, @LoanEndDate = LoanEndDate FROM #TempData WHERE LoanEndDate IS NULL

			SELECT TOP 1 @LoanEndDate = LoanEndDate FROM #TempData WHERE LoanEndDate IS NOT NULL AND StatementDate < @StatementDate ORDER BY StatementDate DESC

			UPDATE #TempData SET LoanEndDate = @LoanEndDate WHERE StatementDate = @StatementDate
		END

		--SELECT * FROM #TempData

		INSERT INTO #TempCounterCorrection
		SELECT PlanID, StatementDate, StatementID, LoanDate, LoanEndDate, CounterForEqualPayment, DATEDIFF(MM, StatementDate, LoanEndDate) CalculatedCounter, CurrentDue, CurrentBalance, ScheduleID, 0
		FROM #TempData
		WHERE CounterForEqualPayment <> DATEDIFF(MM, StatementDate, LoanEndDate)

		UPDATE #PlansToCorrect SET ProcessedStatus = 1 WHERE PlanID = @PlanID
		UPDATE #TempTotalPlans SET ProcessedStatus = 1 WHERE PlanID = @PlanID
	END

	
END

SELECT COUNT(1) FROM #TempCounterCorrection

SELECT ProcessedStatus, COUNT(1) FROM #TempTotalPlans GROUP BY ProcessedStatus