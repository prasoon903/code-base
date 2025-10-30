CREATE OR ALTER PROCEDURE USP_ChargeOffReasonCorrection
	@AllAccounts INT, -- 1 = ALL, 0 = SPECIFIC
	@AccountNumber VARCHAR(19), -- NEED TO PROVIDE WHEN @AllAccounts = 0
	@BatchCount INT -- BATCH SIZE OF THE UPDATE

AS

BEGIN

	SET NOCOUNT ON
	SET QUOTED_IDENTIFIER ON
	SET XACT_ABORT ON

	DROP TABLE IF EXISTS #TempChargeOffAccounts
	DROP TABLE IF EXISTS #TempChargeOffAccountsJobTable
	DROP TABLE IF EXISTS #TempJobTable
	--DROP TABLE IF EXISTS #BSegment_Primary
	--DROP TABLE IF EXISTS #BSegmentCreditCard

	DECLARE @StartProcessing INT = 1

	IF(@BatchCount <= 0)
	BEGIN
		PRINT 'INVALID BatchCount'
		SET @StartProcessing = 0
	END

	IF(@AllAccounts <> 0 AND @AllAccounts <> 1)
	BEGIN
		PRINT 'INVALID AllAccounts FLAG'
		SET @StartProcessing = 0
	END

	IF(@AllAccounts = 0 AND (@AccountNumber = '' OR @AccountNumber IS NULL))
	BEGIN
		PRINT 'INVALID AccountNumber'
		SET @StartProcessing = 0
	END

	IF @StartProcessing = 1
		BEGIN

		DECLARE 
			@TotalAccounts INT,
			@TotalJobs INT,
			@ValidateCount INT = 0

		CREATE TABLE #TempChargeOffAccounts
		(
			acctId INT, AccountNumber VARCHAR(19), SystemStatus INT, ManualInitialChargeOffReason VARCHAR(5), AutoInitialChargeOffReason VARCHAR(5), ccinhparent125aid INT, Parent05AID INT, Chargeoffdate DATETIME
		)

		CREATE TABLE #TempChargeOffAccountsJobTable
		(
			acctId INT, SystemStatus INT, ccinhparent125aid INT, ManualInitialChargeOffReason VARCHAR(5), JobStatus INT
		)

		CREATE TABLE #TempJobTable
		(
			acctId INT, SystemStatus INT, ccinhparent125aid INT, ManualInitialChargeOffReason VARCHAR(5), JobStatus INT
		)

		IF(@AllAccounts = 1)
		BEGIN

			INSERT INTO #TempChargeOffAccounts
			SELECT BP.acctId, BP.AccountNumber, BP.SystemStatus, BCC.ManualInitialChargeOffReason, BCC.AutoInitialChargeOffReason, BP.ccinhparent125AID, BP.Parent05AID, BCC.Chargeoffdate
			FROM BSegment_Primary BP WITH (NOLOCK)
			JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
			WHERE SystemStatus = 14 and ManualInitialChargeOffReason = '0' AND AutoInitialChargeOffReason = '0'

		END
		ELSE IF(@AllAccounts = 0)
		BEGIN
			IF(@AccountNumber IS NOT NULL AND @AccountNumber <> '')
			BEGIN
				INSERT INTO #TempChargeOffAccounts
				SELECT BP.acctId, BP.AccountNumber, BP.SystemStatus, BCC.ManualInitialChargeOffReason, BCC.AutoInitialChargeOffReason, BP.ccinhparent125AID, BP.Parent05AID, BCC.Chargeoffdate
				FROM BSegment_Primary BP WITH (NOLOCK)
				JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
				WHERE BP.AccountNumber = @AccountNumber AND SystemStatus = 14 and ManualInitialChargeOffReason = '0' AND AutoInitialChargeOffReason = '0'

				IF @@rowcount = 0
				BEGIN
					SELECT 'NO ISSUE WITH THIS ACCOUNT.'
				END
			END
			ELSE
			BEGIN
				SELECT 'ERROR :: ACCOUNTNUMBER IS NOT PROVIDED.'
			END
		END

		SELECT @TotalAccounts = COUNT(1) FROM #TempChargeOffAccounts

		PRINT 'TOTAL ACCOUNTS :: ' + TRY_CAST(@TotalAccounts AS VARCHAR)

		SELECT BP.* 
		INTO #BSegment_Primary
		FROM BSegment_Primary BP WITH (NOLOCK)
		JOIN #TempChargeOffAccounts TT ON (BP.acctId = TT.acctId)

		SELECT BP.* 
		INTO #BSegmentCreditCard
		FROM BSegmentCreditCard BP WITH (NOLOCK)
		JOIN #TempChargeOffAccounts TT ON (BP.acctId = TT.acctId)

		IF(@TotalAccounts > 0)
		BEGIN
			WITH CTE AS
			(
				SELECT 
					TA.acctId, TA.SystemStatus, TA.ccinhparent125AID, MTC.ChargeOffReason, RANK() OVER (PARTITION BY TA.acctId ORDER BY CP.PostTime DESC) Ranking
				FROM #TempChargeOffAccounts TA WITH (NOLOCK)
				JOIN CCard_Primary CP WITH (NOLOCK) ON (TA.AccountNumber = CP.AccountNumber)
				JOIN MonetaryTxnControl MTC WITH (NOLOCK) ON (CP.TxnCode_Internal = MTC.TransactionCode AND CP.CMTTranType = '51')
			)
			INSERT INTO #TempChargeOffAccountsJobTable
			SELECT acctId, SystemStatus, ccinhparent125AID, ISNULL(ChargeOffReason, 1), 0 JobStatus FROM CTE WHERE Ranking = 1

			--UPDATE TJ
			--SET 
			--	ManualInitialChargeOffReason = AST.COReasonCode
			--FROM #TempChargeOffAccounts TA WITH (NOLOCK)
			--JOIN #TempChargeOffAccountsJobTable TJ ON (TA.acctId = TJ.acctId AND TJ.ManualInitialChargeOffReason IS NULL)
			--LEFT JOIN AStatusAccounts AST WITH (NOLOCK) ON (TA.ccInhParent125AID = AST.parent01AID AND TA.parent05AID = AST.MerchantAID)


			SELECT @TotalJobs = COUNT(1) FROM #TempChargeOffAccountsJobTable

			PRINT 'TOTAL JOBS :: ' + TRY_CAST(@TotalJobs AS VARCHAR)

			DECLARE @LoopCount INT = 0

			IF(@TotalJobs > 0)
			BEGIN 
				WHILE(@TotalJobs >= @ValidateCount)
				BEGIN
					BEGIN TRY

						--PRINT 'LOOPCOUNT :: ' + TRY_CAST(@LoopCount AS VARCHAR)

						SET @LoopCount = @LoopCount + 1
				
						SET @ValidateCount = @ValidateCount + @BatchCount

						INSERT INTO #TempJobTable (acctId, SystemStatus, ccinhparent125AID, ManualInitialChargeOffReason, JobStatus)
						SELECT TOP(@BatchCount) acctId, SystemStatus, ccinhparent125AID, ManualInitialChargeOffReason, JobStatus FROM #TempChargeOffAccountsJobTable WHERE JobStatus = 0

						BEGIN TRY
							BEGIN TRANSACTION
								UPDATE BCC
								SET
									ManualInitialChargeOffReason = TJ.ManualInitialChargeOffReason
								FROM #BSegmentCreditCard BCC 
								JOIN #TempJobTable TJ ON (BCC.acctId = TJ.acctId)

								UPDATE BP
								SET
									tpylad = NULL, tpyNad = NULL, tpyBlob = NULL
								FROM #BSegment_Primary BP 
								JOIN #TempJobTable TJ ON (BP.acctId = TJ.acctId)

								UPDATE TAJ
								SET
									JobStatus = 1
								FROM #TempChargeOffAccountsJobTable TAJ
								JOIN #TempJobTable TJ ON (TAJ.acctId = TJ.acctId)
							COMMIT TRANSACTION					
						END TRY
						BEGIN CATCH
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION 
								SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
								RAISERROR('ERROR OCCURED :-', 16, 1);
						END CATCH

						TRUNCATE TABLE #TempJobTable

					END TRY
					BEGIN CATCH
						PRINT 'ERROR IN FILLING JOBTABLE'
					END CATCH
				END
				PRINT 'ALL JOBS DONE'
			END
		END

	END


	--SELECT * FROM #TempChargeOffAccountsJobTable

END