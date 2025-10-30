DECLARE @Statement DATETIME = '2019-07-31 23:59:57.000'

--DECLARE @AccountID INT = 14551648

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
		JOIN CTE A ON (S.parent02AID = A.acctID)
		WHERE StatementDate = DATEADD(MONTH, -1, @Statement)
		EXCEPT
		SELECT S.acctID, S.parent02AID
		FROM SummaryHeader S WITH (NOLOCK)
		JOIN CTE A ON (S.parent02AID = A.acctID)
		WHERE StatementDate = @Statement
	)
	SELECT parent02AID, acctId, @Statement StatementDate, DATEADD(MONTH, -1, @Statement) PreviousStatementDate INTO #TempData FROM CTE
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
			SELECT * FROM #PreviousSHData

			INSERT INTO SummaryHeaderCreditCard
			SELECT * FROM #PreviousSHCCData

			INSERT INTO CurrentSummaryHeader
			SELECT * FROM #PreviousCSHData

			UPDATE AccountsOfPlanToReLink SET JobStatus = 2 WHERE JobStatus = 1

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION 
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH

END