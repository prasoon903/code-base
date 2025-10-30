/*
Updating the CPS data
*/

SET XACT_ABORT ON
SET NOCOUNT ON

--DECLARE		@AccountID INT,
--			@AccountNumber VARCHAR(19), 
--			@AccountCreationTime DATETIME,
--			@ProcessTime DATETIME

DECLARE @ExecutionCount INT, @IterationLoop INT = 0

SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM ##TEMP_HighBalance_Processing

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 1000,
			@Iteration			INT			= 50

DROP TABLE IF EXISTS #TEMP_HighBalance_JobTable
CREATE TABLE #TEMP_HighBalance_JobTable 
(
	SN DECIMAL(19,0),
	BSacctID INT,
	AccountNumber VARCHAR(19),
	Acquisitiondate DATETIME, 
	CBRAmountOfCurrentBalance MONEY, 
	CBRAmountOfHighBalance MONEY,
	LastStatementDate DATETIME,
	ProcessTime DATETIME,
	JobStatus INT DEFAULT(0)
)

--DROP TABLE IF EXISTS ##TEMP_HighBalance_Processing
--CREATE TABLE ##TEMP_HighBalance_Processing 
--(
--	SN DECIMAL(19,0) IDENTITY(1, 1),
--	Iteration INT,
--	Activity VARCHAR(100),
--	RecordCount INT
--)

SELECT @RecordCount = COUNT(1) FROM ##Accounts WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			SET @IterationLoop = @IterationLoop + 1

			INSERT INTO #TEMP_HighBalance_JobTable (SN, BSacctId, AccountNumber, Acquisitiondate, CBRAmountOfCurrentBalance, CBRAmountOfHighBalance, LastStatementDate, ProcessTime, JobStatus)
			SELECT TOP(@BatchCount)
				SN, BSacctId, AccountNumber, Acquisitiondate, CBRAmountOfCurrentBalance, CBRAmountOfHighBalance, LastStatementDate, DateAcctOpened, JobStatus
			FROM ##Accounts WITH (NOLOCK)
			WHERE JobStatus = 0

			INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT)

			BEGIN TRY
				
					--SET @ProcessTime = @AccountCreationTime

					;WITH CTE
					AS
					(
						SELECT T.BSAcctID, CurrentBalance + CurrentBalanceCO CurrentBalance, AmtOfAcctHighBalLTD, StatementDate,
						RANK() OVER(PARTITION BY S.acctID ORDER BY StatementDate) RowCounter
						FROM StatementHeader S WITH (NOLOCK)
						JOIN #TEMP_HighBalance_JobTable T ON (S.acctID = T.BSAcctID AND S.StatementDate > T.Acquisitiondate)
						WHERE T.Acquisitiondate IS NOT NULL
					)
					UPDATE T
					SET CBRAmountOfCurrentBalance = C.CurrentBalance, CBRAmountOfHighBalance = AmtOfAcctHighBalLTD, ProcessTime = StatementDate
					FROM #TEMP_HighBalance_JobTable T
					JOIN CTE C ON (T.BSAcctID = C.BSAcctID AND C.RowCounter = 1)
	   	
					DROP TABLE IF EXISTS #TempData
					SELECT --ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) RowCounter,
					CP.AccountNumber, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionAmount,CP.TranId,CP.TranRef,
					CP.RevTgt, Trantime,CP.PostTime, CP.TxnSource, CP.NoBlobIndicator,Transactionidentifier,
					CASE WHEN CP.TranRef IS NULL THEN 1 ELSE 5 END Priority,  --PLAT-125950 
					CP.DateTimeLocalTransaction,
					CP.Artxntype  --PLAT-99400
					,CP.TxnAcctID
					INTO #TempData
					--FROM LS_P1MARPRODDB01.CCGS_COREISSUE.DBO.CCard_Primary CP WITH (NOLOCK)
					FROM CCard_Primary CP WITH (NOLOCK)
					JOIN #TEMP_HighBalance_JobTable T ON (CP.AccountNumber = T.AccountNumber)
					--WHERE CP.AccountNumber IN (@AccountNumber) 
					AND CP.CMTTRANTYPE IN ('02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',  
											'17','18','19','21','22','23','24','25','26','28','29','30','31','32','33',  
											'35','37','38','40','41','42','43','45','48','49','50',/*'51','52',*/'53',/*'54', */  --PLAT-92882
											'55','56','57','58','60','61','62','63','64','65','66','67','68','69','70',  
											'71','72','73','74','75','76','77','78','79','80','81','82','83','84','85',  
											'86','87','90','91','92','93','94','95','96','97','98',
											'110','111','1111','115','116','117','118')
					--AND CP.PostTime > @ProcessTime
					AND CP.PostTime > T.ProcessTime

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'CCARD TABLE FILLED', @@ROWCOUNT)

					INSERT INTO #TempData (TranId, CMTTRANTYPE, AccountNumber, TransactionAmount, Trantime, PostTime, Priority)
					SELECT 0, '00', AccountNumber, CBRAmountOfCurrentBalance, ProcessTime, ProcessTime, 0 FROM #TEMP_HighBalance_JobTable

					

					DELETE T1
					FROM #TempData T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.AccountNumber = T2.AccountNumber)
					WHERE T2.Acquisitiondate IS NOT NULL
					AND T1.TranTime < T2.ProcessTime

	

					DROP TABLE IF EXISTS #Plans
					CREATE TABLE #Plans (acctID INT, BSAcctID INT)

					INSERT INTO #Plans
					SELECT acctId, T.BSAcctID
					FROM CPSgmentAccounts C WITH (NOLOCK)
					JOIN #TEMP_HighBalance_JobTable T ON (C.parent02AID = T.BSAcctID)
					--WHERE parent02AID = @AccountID

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'PLAN DETAILS FILLED', @@ROWCOUNT)

					INSERT INTO #TempData (TranId, TxnAcctID, AccountNumber, CMTTranType, TransactionAmount, Trantime, PostTime, Priority)
					SELECT 0, P.acctID, T.AccountNumber, 
					CASE 
						WHEN CS.AmtOfInterestCTD > 0 
						THEN '03' 
						ELSE '02' 
					END, 
					ABS(CS.AmtOfInterestCTD), CS.StatementDate, CS.StatementDate, 2
					FROM CurrentSummaryHeader CS WITH (NOLOCK)
					JOIN #Plans P ON (CS.acctID = P.acctID)
					JOIN #TEMP_HighBalance_JobTable T ON (P.BSAcctID = T.BSAcctID)
					--AND CS.StatementDate > @ProcessTime
					WHERE CS.StatementDate > T.ProcessTime

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'INTEREST DETAILS FILLED', @@ROWCOUNT)

					INSERT INTO #TempData (TranId, AccountNumber, CMTTranType, TransactionAmount, Trantime, PostTime, Priority)
					SELECT 0, T.AccountNumber, '08', TransactionAmount, JobDate, PostTime, 2 --Plat-109380(Added JobDate As HighBalance Was Calculate Wrong In Case Of Payment Reversal)
					FROM LateFeeDeterminant L WITH (NOLOCK)
					JOIN #TEMP_HighBalance_JobTable T ON (L.acctID = T.BSAcctID)
					--WHERE acctId = @AccountID
					AND LateFeeDeterminantFlag = 1
					--AND JobDate > @ProcessTime   --PLAT-122024
					AND JobDate > T.ProcessTime

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'LATEFEE DETAILS FILLED', @@ROWCOUNT)

					DELETE FROM #TempData WHERE CMTTranType IN('03','02') AND TxnSource = '4' AND NoBlobIndicator = '9' --PLAT-105058(Added '02')
					DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND Transactionidentifier = 'TCAP' --PLAT-136407
					DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND RevTgt IS NOT NULL --PLAT-144199
					DELETE FROM #TempData WHERE CMTTranType = '08' AND TranRef IS NOT NULL --PLAT-144199 
					DELETE FROM #TempData WHERE CMTTranType = '09' AND RevTgt IS NOT NULL --PLAT-144199 

					;WITH CTE  
					AS  
					(  
						SELECT *  
						FROM #TempData  
						WHERE RevTgt IS NOT NULL  
					)  
					UPDATE T1  
					SET TransactionAmount = CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN T1.TransactionAmount - C.TransactionAmount END
					FROM #TempData T1  
					JOIN CTE C ON (T1.TranID = C.RevTgt) 
					
					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'REVERSAL DETAILS PROCESSED', @@ROWCOUNT) 
  
					;WITH CTE  
					AS  
					(  
						SELECT *  
						FROM #TempData  
						WHERE CMTTranType = '03'  
					)  
					UPDATE T1  
					SET TransactionAmount = CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN T1.TransactionAmount - C.TransactionAmount END
					FROM #TempData T1  
					JOIN CTE C ON (T1.TranTime = C.TranTime AND T1.TxnAcctID = C.TxnAcctID AND T1.CMTTranType = '02') 

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'INTEREST DETAILS PROCESSED', @@ROWCOUNT) 
	

					DELETE FROM #TempData WHERE RevTgt IS NOT NULL 
					DELETE FROM #TempData WHERE CMTTranType = '03' AND TranID = 0

					DELETE FROM #TempData WHERE TransactionAmount = 0 AND Priority > 0 --PLAT-91601 
					DELETE FROM #TempData WHERE Artxntype  IN ('99','104')  --PLAT-99400 (Added Artxntype '95' for PLAT-92882)
					DELETE FROM #TempData WHERE Artxntype  = '95' AND CMTTranType <> '61' 

					DROP TABLE IF EXISTS #TempRecords
					;WITH CTE
					AS
					(
						SELECT ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY TranTime) RowCounter, 
						AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID,
						SUM(CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 1 THEN TransactionAmount*-1 ELSE TransactionAmount END) 
						OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) CurrentBalance
						FROM #TempData
					)
					SELECT RowCounter, AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID, CurrentBalance,
					CASE WHEN RowCounter = 1 Then 0
					ELSE MAX(CASE WHEN CurrentBalance > 0 THEN CurrentBalance ELSE 0 END) OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) END HighBalance
					--MAX(CurrentBalance) OVER (PARTITION BY NULL ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) HighBalance
					INTO #TempRecords
					FROM CTE

					DROP TABLE IF EXISTS #CalculatedHB
					;WITH CTE
					AS
					(
						SELECT AccountNumber, HighBalance, CurrentBalance, ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY RowCounter DESC) RowCounter
						FROM #TempRecords
					)
					SELECT * INTO #CalculatedHB FROM CTE WHERE RowCounter = 1

					DROP TABLE IF EXISTS #CalculatedHB_STMT
					;WITH CTE
					AS
					(
						SELECT T1.AccountNumber, HighBalance, CurrentBalance, PostTime, LastStatementDate, ROW_NUMBER() OVER (PARTITION BY T1.AccountNumber ORDER BY RowCounter DESC) RowCounter
						FROM #TempRecords T1
						JOIN #TEMP_HighBalance_JobTable T2 ON (T1.AccountNumber = T2.AccountNumber)
						WHERE LastStatementDate IS NOT NULL
						AND PostTime <= LastStatementDate
					)
					SELECT * INTO #CalculatedHB_STMT FROM CTE WHERE RowCounter = 1

					--SELECT * FROM #CalculatedHB_STMT

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'HIGH BALANCE CALCULATED', @@ROWCOUNT) 

					UPDATE A
						SET CalcHighBalance = HighBalance, CalcCurrentBalance = CurrentBalance, JobStatus = 1
					FROM ##Accounts A
					JOIN #CalculatedHB C ON (A.AccountNumber = C.AccountNumber)

					UPDATE A
						SET CBRAmountOfHighBalance_STMT = HighBalance, CBRAmountOfCurrentBalance_STMT = CurrentBalance
					FROM ##Accounts A
					JOIN #CalculatedHB_STMT C ON (A.AccountNumber = C.AccountNumber)

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'ACCOUNTS TABLE UPDATED WITH VALUES', @@ROWCOUNT) 

					UPDATE A
						SET JobStatus = -1
					FROM ##Accounts A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)
					WHERE A.JobStatus NOT IN (1, -1)

					INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'DATA NOT CALCULATED', @@ROWCOUNT) 

				
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_HighBalance_JobTable
			SET @Iteration = @Iteration - 1 
			--WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	BEGIN 
		SELECT @RecordCount = COUNT(1) FROM ##Accounts WITH (NOLOCK) WHERE JobStatus = 0
		IF(@RecordCount > 0)
		BEGIN
			SELECT 'ITERATION COMPLETE, PLEASE RUN THIS STEP AGAIN UNTIL IT IS FINISHED' [Result]
		END
		ELSE
		BEGIN 
			SELECT 'UPDATED SUCESSFULLY' [Result]
		END
	END
END
Else
Begin 
	SELECT 'NO RECORD TO UPDATE' [Result]
End
