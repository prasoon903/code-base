-- CALCULATE HB



SET XACT_ABORT ON
SET NOCOUNT ON



DECLARE @ExecutionCount INT, @IterationLoop INT = 0

SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM TEMP_HighBalance_Processing

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 100,
			@Iteration			INT			= 5

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

--DROP TABLE IF EXISTS TEMP_HighBalance_Processing
--CREATE TABLE TEMP_HighBalance_Processing 
--(
--	SN DECIMAL(19,0) IDENTITY(1, 1),
--	Iteration INT,
--	Activity VARCHAR(100),
--	RecordCount INT
--)

SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 1
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

			INSERT INTO #TEMP_HighBalance_JobTable (SN, BSacctId, AccountNumber, CBRAmountOfCurrentBalance, CBRAmountOfHighBalance, LastStatementDate, ProcessTime, JobStatus)
			SELECT TOP(@BatchCount)
				SN, acctId, AccountNumber, 0, 0, LastStatementDate, CreatedTime, JobStatus
			FROM TSDBOHBConversion WITH (NOLOCK)
			WHERE JobStatus = 1

			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT, GETDATE())

			UPDATE T1
			SET
				CurrentBalance = BP.CurrentBalance+BC.CurrentBalanceCO,
				AmtOfAcctHighBalLTD = BP.AmtOfAcctHighBalLTD,
				HBRecalcStatus = BB.HBRecalcStatus,
				JobStatus = CASE WHEN HBRecalcRequired = 1 AND ISNULL(BB.HBRecalcStatus, 0) = 0 THEN T1.JobStatus ELSE -5 END
			FROM TSDBOHBConversion T1
			JOIN #TEMP_HighBalance_JobTable T2 ON (T1.SN = T2.SN)
			JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = T1.acctID)
			JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)
			JOIN BSegment_Balances BB WITH (NOLOCK) ON (BB.acctID = BC.acctID)


			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'REFRESHED ACCOUNT DATA', @@ROWCOUNT, GETDATE())


			DELETE TT
			FROM TSDBOHBConversion A
			JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)
			WHERE A.JobStatus = -5


			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'REMOVED ALREADY UPDATED ACCOUNT', @@ROWCOUNT, GETDATE())
			

			DROP TABLE IF EXISTS #TempData
			SELECT --ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) RowCounter,
			CP.AccountNumber, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, ISNULL(CP.TransactionAmount, 0) TransactionAmount,CP.TranId,CP.TranRef,
			CP.RevTgt, Trantime,CP.PostTime, CP.TxnSource, CP.NoBlobIndicator,Transactionidentifier,
			CASE WHEN CP.TranRef IS NULL THEN 1 ELSE 5 END Priority,  --PLAT-125950 
			CP.DateTimeLocalTransaction,
			CP.Artxntype  --PLAT-99400
			,CP.BSAcctID TxnAcctID
			,CP.TxnIsFor
			,CP.TransmissionDateTime
			,CP.MemoIndicator
			,CP.MergeActivityFlag
			INTO #TempData
			FROM CCard_Primary CP WITH (NOLOCK)
			JOIN #TEMP_HighBalance_JobTable T ON (CP.AccountNumber = T.AccountNumber)
			--WHERE CP.AccountNumber IN (@AccountNumber) 
			WHERE CP.CMTTRANTYPE IN ('02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',  
									'17','18','19','21','22','23','24','25','26','28','29','30','31','32','33',  
									'35','37','38','40','41','42','43','45','48','49','50',/*'51','52',*/'53',/*'54', */  --PLAT-92882
									'55','56','57','58','60','61','62','63','64','65','66','67','68','69','70',  
									'71','72','73','74','75','76','77','78','79','80','81','82','83','84','85',  
									'86','87','90','91','92','93','94','95','96','97','98',
									'110','111','1111','115','116','117','118', 'ADDSCRA', 'ADDBK', 'ECD')
			--AND CP.PostTime > @ProcessTime
			AND CP.PostTime > T.ProcessTime

			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'CCARD TABLE FILLED', @@ROWCOUNT, GETDATE())

			DELETE FROM #TempData WHERE Artxntype  = '93'

			DELETE FROM #TempData WHERE MergeActivityFlag IS NOT NULL AND MemoIndicator = 'MEMO'

			DELETE T
			FROM #TempData T
			LEFT JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (T.TxnAcctID = TIA.acctId AND T.TranID = TIA.Tran_Id_Index AND TIA.ATID = 51 AND TIA.Tran_Id_Table = 0)
			WHERE TIA.acctId IS NULL
			AND T.CMTTRANTYPE NOT IN ('ADDSCRA', 'ADDBK', 'ECD')

			--SELECT T.*
			--FROM #TempData T
			--LEFT JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (T.TxnAcctID = TIA.acctId AND T.TranID = TIA.Tran_Id_Index AND TIA.ATID = 51 AND TIA.Tran_Id_Table = 0)
			--WHERE TIA.acctId IS NULL
			--AND T.CMTTRANTYPE NOT IN ('ADDSCRA', 'ADDBK', 'ECD')

			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'UNPOSTED TRANSACTIONS REMOVED', @@ROWCOUNT, GETDATE())

			INSERT INTO #TempData (TranId, CMTTRANTYPE, AccountNumber, TransactionAmount, Trantime, PostTime, Priority)
			SELECT 0, '00', AccountNumber, CBRAmountOfCurrentBalance, ProcessTime, ProcessTime, 0 FROM #TEMP_HighBalance_JobTable

			--SELECT TOP 1 * FROM #TempData
			--SELECT * FROM Trans_In_Acct TIA WITH (NOLOCK) WHERE acctId = 14014614 AND Tran_Id_Index = 39238029803 AND ATID = 51

			;WITH CTE
			AS
			(
				SELECT AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef,
				RevTgt, Trantime, PostTime, TxnSource, NoBlobIndicator, Transactionidentifier,
				Priority, DateTimeLocalTransaction, Artxntype, TxnAcctID, TxnIsFor, TransmissionDateTime
				FROM #TempData 
				WHERE CMTTRANTYPE = 'ADDBK'
			)
			UPDATE C
			SET TransmissionDateTime = S.EffectiveDate
			FROM CTE C
			JOIN ccard_secondary S WITH (NOLOCK) ON (C.TranRef = S.TranID)

			DELETE FROM #TempData WHERE CMTTRANTYPE = 'ADDBK' AND TransmissionDateTime IS NULL




			;WITH CTE 
			AS
			(
				SELECT AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef,
				RevTgt, Trantime, PostTime, TxnSource, NoBlobIndicator, Transactionidentifier,
				Priority, DateTimeLocalTransaction, Artxntype, TxnAcctID, TxnIsFor, TransmissionDateTime 
				FROM #TempData WHERE CMTTRANTYPE = '03' AND RevTgt IS NOT NULL
			)
			DELETE T
			FROM #TempData T
			JOIN CTE C ON (T.TranID = C.RevTgt)
			WHERE T.CMTTRANTYPE = '02'

			UPDATE #TempData SET TranTime = DateTimeLocalTransaction WHERE CMTTRANTYPE IN ('02', '03') AND TxnSource = '4' AND NoblobIndicator = '9'

			UPDATE T
			SET 
				TranTime = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, TranTime)) AS DATETIME)),
				TxnSource = '4',
				Priority = 5
			FROM #TempData T
			WHERE CMTTRANTYPE = '03' AND TransactionIdentifier = 'TCAP'

			DROP TABLE IF EXISTS #TCAPCycle
			SELECT AccountNumber, TranTime
			INTO #TCAPCycle
			FROM #TempData T
			WHERE CMTTRANTYPE = '03' AND TransactionIdentifier = 'TCAP'

			DELETE FROM #TempData WHERE CMTTRANTYPE = '03' AND RevTgt IS NOT NULL

			DROP TABLE IF EXISTS #ConsolidatedCredits
			SELECT DISTINCT C2.Skey, C.AccountNumber, C2.TranRef TranRef, C2.parent02AID BSAcctID, C2.TransactionAmount, C2.StatementDate
			INTO #ConsolidatedCredits
			FROM #TempData C
			--JOIN LISTPRODPLAT.CCGS_CoreIssue.DBO.ConsolidatedCreditRecords C2 WITH (NOLOCK) ON (C.TxnAcctID = C2.parent02AID)
			JOIN ConsolidatedCreditRecords C2 WITH (NOLOCK) ON (C.TxnAcctID = C2.parent02AID)
			WHERE C.CMTTRANTYPE = '03'
			--AND C.TranRef IS NOT NULL
			--UNION
			--SELECT DISTINCT C.AccountNumber, 0 TranRef, parent02AID BSAcctID, PlanID, InterestCredits TransactionAmount, StatementDate
			--FROM #CCRBuffer C

			
			--DELETE T
			--FROM #TempData T
			--JOIN #ConsolidatedCredits C ON (T.Tranref = C.TranRef)
			--AND T.TransactionAmount = C.TransactionAmount

			;WITH CTE
			AS
			(
				SELECT TranRef, SUM(TransactionAmount) TransactionAmount
				FROM #ConsolidatedCredits 
				GROUP BY TranRef
			)	
			DELETE T
			FROM #TempData T
			JOIN CTE C ON (T.Tranref = C.TranRef)
			AND T.TransactionAmount = C.TransactionAmount


			DROP TABLE IF EXISTS #SCRAIntCredits
			SELECT AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef,
			RevTgt, Trantime, PostTime, TxnSource, NoBlobIndicator, Transactionidentifier,
			Priority, DateTimeLocalTransaction, Artxntype, TxnAcctID, TxnIsFor, TransmissionDateTime 
			INTO #SCRAIntCredits 
			FROM #TempData 
			WHERE TxnIsFor IN ('SCRA', 'BKRUT') 
			AND CMTTRANTYPE = '03'

			--SELECT * FROM #SCRAIntCredits


			DELETE FROM #TempData WHERE TxnIsFor IN ('SCRA', 'BKRUT') AND CMTTRANTYPE = '03'

			DROP TABLE IF EXISTS #ConsolidatedCredits_Combined
			SELECT AccountNumber, BSAcctID, StatementDate, SUM(TransactionAmount) TransactionAmount
			INTO #ConsolidatedCredits_Combined
			FROM #ConsolidatedCredits
			GROUP BY AccountNumber, BSAcctID, StatementDate


			INSERT INTO #TempData (AccountNumber, CMTTRANTYPE, TxnAcctID, TranID, TransactionAmount, TxnSource, Trantime, PostTime, Priority)
			SELECT AccountNumber, '03' CMTTRANTYPE, C.BSAcctID, 0, C.TransactionAmount, '4', C.StatementDate, C.StatementDate,5 Priority
			FROM #ConsolidatedCredits_Combined C

			DELETE C
			FROM #TempData C
			JOIN ConsolidatedCreditRecords C2 WITH (NOLOCK) ON (C.TranRef = C2.TranRef)
			--JOIN LISTPRODPLAT.CCGS_CoreIssue.DBO.ConsolidatedCreditRecords C2 WITH (NOLOCK) ON (C.TranRef = C2.TranRef)
			WHERE C.CMTTRANTYPE = '03'
			AND C.TranRef IS NOT NULL
			--AND Priority = 5

			INSERT INTO #TempData (AccountNumber, CMTTRANTYPE, TxnAcctID, TranID, TxnSource, TransactionAmount, Trantime, PostTime, Priority)
			SELECT AccountNumber, CMTTRANTYPE, TxnAcctID, 0, TxnSource, SUM(TransactionAmount) TransactionAmount, TranTime, TranTime, 6
			FROM #TempData
			WHERE CMTTRANTYPE IN ('02', '03')
			AND TxnSource = '4'
			GROUP BY AccountNumber, CMTTRANTYPE, TranTime, TxnAcctID, TxnSource

			


			DELETE FROM #TempData WHERE CMTTRANTYPE IN ('02', '03') AND TxnSource = '4' AND Priority = 5


			DROP TABLE IF EXISTS #SCRAIntActivity
			SELECT CP.AccountNumber, CP.TxnAcctID, CP.TransmissionDateTime TranTime, CP.TranTime PostTime
			INTO #SCRAIntActivity
			FROM #SCRAIntCredits T1
			JOIN #TempData CP WITH (NOLOCK) ON (T1.AccountNumber = CP.AccountNumber AND T1.TranRef = CP.TranID)

			IF EXISTS (SELECT TOP 1 1 FROM #SCRAIntActivity)
			BEGIN

				
		
				DELETE T
				FROM #SCRAIntActivity C 
				JOIN #TempData T ON (C.AccountNumber = T.AccountNumber AND T.CMTTRANTYPE = '03')
				WHERE T.TranTime BETWEEN C.TranTime AND C.PostTime
				AND T.TxnSource = '4'

				INSERT INTO #TempData (AccountNumber, CMTTRANTYPE, TxnAcctID, TranID, TxnSource, TransactionAmount, Trantime, PostTime, Priority)
				SELECT T.AccountNumber, '03', T.TxnAcctID, T.TranID, T.TxnSource, T.TransactionAmount, T.Trantime, T.PostTime, T.Priority
				FROM #TempData T
				JOIN #SCRAIntActivity S ON (T.AccountNumber = S.AccountNumber)
				WHERE CMTTRANTYPE = '02'
				AND T.PostTime BETWEEN S.TranTime AND S.PostTime

				

				INSERT INTO #TempData (AccountNumber, CMTTRANTYPE, TxnAcctID, TranID, TxnSource, TransactionAmount, Trantime, PostTime, Priority)
				SELECT T.AccountNumber, T.CMTTRANTYPE, T.TxnAcctID, 0, T.TxnSource, SUM(T.TransactionAmount) TransactionAmount, T.TranTime, T.TranTime, 7
				FROM #TempData T
				WHERE T.CMTTRANTYPE IN ('02', '03')
				AND T.TxnSource = '4'
				GROUP BY T.AccountNumber, T.CMTTRANTYPE,T. TranTime, T.TxnAcctID, T.TxnSource

				--DELETE T
				--FROM #TempData T
				--JOIN #SCRAIntActivity S ON (T.AccountNumber = S.AccountNumber) 
				--WHERE T.CMTTRANTYPE IN ('02', '03') 
				--AND T.TxnSource = '4' AND T.Priority = 6

				DELETE FROM #TempData WHERE CMTTRANTYPE IN ('02', '03') AND TxnSource = '4' AND Priority = 6
			END

			DROP TABLE IF EXISTS #IntCredits
			SELECT T1.AccountNumber, T1.CMTTRANTYPE, T1.TransactionAmount, T1.TranId, T1.TranRef,
			T1.RevTgt, T1.Trantime, T1.PostTime, T1.TxnSource, T1.NoBlobIndicator, T1.Transactionidentifier,
			T1.Priority, T1.DateTimeLocalTransaction, T1.Artxntype, T1.TxnAcctID, T1.TxnIsFor, T1.TransmissionDateTime
			INTO #IntCredits
			FROM #TempData T1
			JOIN #TempData T2 ON (T1.AccountNumber = T2.AccountNumber AND T1.TranTime = T2.TranTime)
			WHERE T1.CMTTRANTYPE = '03' 
			AND T2.CMTTRANTYPE = '02' 

			--SELECT * FROM #IntCredits
	
			UPDATE T
			SET T.CMTTRANTYPE = CASE WHEN T.TransactionAmount - C.TransactionAmount >= 0 THEN '02' ELSE '03' END, 
			TransactionAmount = ABS(T.TransactionAmount - C.TransactionAmount),
			Priority = 8
			FROM #TempData T
			JOIN #IntCredits C ON (T.AccountNumber = C.AccountNumber AND T.TranTime = C.TranTime)
			WHERE T.CMTTRANTYPE = '02'

			DELETE T
			FROM #TempData T
			JOIN #IntCredits C ON (T.AccountNumber = C.AccountNumber AND T.TranTime = C.TranTime)
			WHERE T.CMTTRANTYPE = '03' 
			AND T.Priority < 8 



			DELETE FROM #TempData WHERE CMTTranType IN(/*'03','02',*/'09') AND TxnSource = '4' AND NoBlobIndicator = '9' --PLAT-105058(Added '02'), Added '09' regarding CARDS-279884
			--DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND Transactionidentifier = 'TCAP' --PLAT-136407
			--DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND RevTgt IS NOT NULL --PLAT-144199
			DELETE FROM #TempData WHERE CMTTranType = '08' AND TranRef IS NOT NULL --PLAT-144199 
			DELETE FROM #TempData WHERE CMTTranType = '09' AND RevTgt IS NOT NULL --PLAT-144199  

			;WITH CTE  
			AS  
			(  
				SELECT AccountNumber, CMTTRANTYPE, RevTgt, SUM(TransactionAmount) TransactionAmount  
				FROM #TempData  
				WHERE RevTgt IS NOT NULL 
				--AND RevTgt = 80408413888 
				GROUP BY AccountNumber, CMTTRANTYPE, RevTgt
			)  
			UPDATE T1  
			SET TransactionAmount = CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN T1.TransactionAmount - C.TransactionAmount END
			FROM #TempData T1  
			JOIN CTE C ON (T1.TranID = C.RevTgt) 
	
			;WITH CTE  
			AS  
			(  
				SELECT AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef,
				RevTgt, Trantime, PostTime, TxnSource, NoBlobIndicator, Transactionidentifier,
				Priority, DateTimeLocalTransaction, Artxntype, TxnAcctID, TxnIsFor, TransmissionDateTime  
				FROM #TempData  
				WHERE CMTTranType = '03'
				--AND TxnSource <> '2'  
			)
			, InterestCalculation
			AS
			( 
			SELECT T1.TxnAcctID, T1.TranTime, T1.CMTTRanType InterestCharged, C.CMTTranType InterestCredited, 
			--CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN C.TransactionAmount ELSE T1.TransactionAmount - C.TransactionAmount END InterestCreditToAdjust,
			--CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN 0 ELSE C.TransactionAmount - T1.TransactionAmount END InterestCreditLeft
			CASE WHEN T1.TransactionAmount > C.TransactionAmount THEN C.TransactionAmount ELSE T1.TransactionAmount END InterestCreditToAdjust,
			CASE WHEN T1.TransactionAmount > C.TransactionAmount THEN 0 ELSE C.TransactionAmount - T1.TransactionAmount END InterestCreditLeft
			FROM #TempData T1  
			JOIN CTE C ON (T1.TranTime = C.TranTime AND T1.TxnAcctID = C.TxnAcctID AND T1.CMTTranType = '02')
			)
			UPDATE T
			SET TransactionAmount = CASE WHEN T.CMTTRanType = '02' THEN T.TransactionAmount - InterestCreditToAdjust ELSE InterestCreditLeft END
			--SELECT CASE WHEN T.CMTTRanType = '02' THEN T.TransactionAmount - InterestCreditToAdjust ELSE InterestCreditLeft END, T.*
			FROM #TempData T
			JOIN InterestCalculation I ON (T.TxnAcctID = I.TxnAcctID AND T.TranTime = I.TranTime)
			WHERE T.CMTTRanType IN ('02', '03')
			AND T.TxnSource <> '2' 

			
	

			DELETE FROM #TempData WHERE RevTgt IS NOT NULL 
			--DELETE FROM #TempData WHERE CMTTranType = '03' AND TranID = 0
			DELETE FROM #TempData WHERE CMTTranType = '03' AND TranID = 0 AND TransactionAmount <= 0

			DELETE FROM #TempData WHERE TransactionAmount = 0 AND Priority > 0 --PLAT-91601 
			DELETE FROM #TempData WHERE Artxntype  IN ('99','104')  --PLAT-99400 (Added Artxntype '95' for PLAT-92882)
			DELETE FROM #TempData WHERE Artxntype  = '95' AND CMTTranType <> '61' 

			DROP TABLE IF EXISTS #TempRecords
			;WITH CTE
			AS
			(
				SELECT ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority) RowCounter, 
				AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID,
				SUM(CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 1 THEN TransactionAmount*-1 ELSE TransactionAmount END) 
				OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) CurrentBalance
				FROM #TempData
			)
			SELECT RowCounter, AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID, CurrentBalance,
			CASE WHEN RowCounter = 1 Then 0
			--ELSE MAX(CASE WHEN CurrentBalance > @CBRAmountOfHighBalance THEN CurrentBalance ELSE @CBRAmountOfHighBalance END) OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) END HighBalance
			ELSE MAX(CASE WHEN CurrentBalance > 0 THEN CurrentBalance ELSE 0 END) OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) END HighBalance
			--MAX(CurrentBalance) OVER (PARTITION BY NULL ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) HighBalance
			INTO #TempRecords
			FROM CTE

			INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'HIGHBALANCE CALCULATION DONE', @@ROWCOUNT, GETDATE())

			DROP TABLE IF EXISTS #TempStatements
			;WITH CTE
			AS
			(
				SELECT DISTINCT AccountNumber--, MIN(TranTime) MinTranTime, MAX(TranTime) MaxTranTime
				FROM #TempRecords
				--GROUP BY AccountNumber
			)
			SELECT SH.AccountNumber, SH.acctID, SH.CurrentBalance + SH.CurrentBalanceCO - CSH.CurrentBalance CurrentBalance, 
			ISNULL(SH.LastStatementDate, SH.DateAcctOpened) LastStatementDate, SH.StatementDate,
			CASE WHEN T.AccountNumber IS NOT NULL THEN 1 ELSE 0 END IsAcctTCAP
			INTO #TempStatements
			FROM CTE C
			JOIN StatementHeader SH WITH (NOLOCK) ON (C.AccountNumber = SH.AccountNumber)
			JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate) 
			LEFT JOIN #TCAPCycle T ON (T.AccountNumber = SH.AccountNumber AND T.Trantime = SH.StatementDate)
			--WHERE SH.StatementDate BETWEEN C.MinTranTime AND c.MaxTranTime




			DROP TABLE IF EXISTS #TempRecordsStatement
			;WITH CutOff
			AS
			(
				SELECT DISTINCT AccountNumber, DATEADD(SS, 86397, TRY_CAST(EOMONTH(MAX(TranTime)) AS DATETIME)) MaxTranTime
				FROM #TempRecords
				GROUP BY AccountNumber
			)
			, CTE
			AS
			(
				SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber, EOMONTH(TranTime) ORDER BY TranTime DESC, RowCounter DESC) CycleLastRecord
				FROM #TempRecords
			)
			, Statements
			AS
			(
			SELECT T2.*, T1.acctID, T1.CurrentBalance SH_CB, T1.StatementDate NextStatement, 
			ROW_NUMBER() OVER(PARTITION BY T2.AccountNumber, T1.StatementDate ORDER BY T2.TranTime DESC) RN,
			CASE WHEN T1.StatementDate <= MaxTranTime THEN 1 ELSE 0 END InCycleRecord, T1.IsAcctTCAP
			FROM #TempStatements T1
			LEFT JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)
			JOIN CutOff T3 ON (T1.AccountNumber = T3.AccountNumber)
			WHERE T1.StatementDate >= T2.TranTime
			AND CycleLastRecord = 1
			)
			SELECT *
			INTO #TempRecordsStatement
			FROM Statements
			WHERE RN = 1
			--ORDER BY RowCounter

			--SELECT * FROm #TempRecordsStatement WHERE NextStatement IS NOT NULL AND acctID = 4384574

			--SELECT * FROm #TempRecords
	

			BEGIN TRY

				INSERT INTO TSDBOHBConversion_MetaData (SN, acctID, AccountNumber, StatementDate, CurrentBalance, AmtOfAcctHighBalLTD, RecordStatus)
				SELECT T2.SN, T1.acctID, T1.AccountNumber, T1.NextStatement, T1.CurrentBalance, T1.HighBalance,
				CASE WHEN InCycleRecord = 1 AND IsAcctTCAP = 0 THEN 0 ELSE 5 END RecordStatus
				FROM #TempRecordsStatement T1
				JOIN #TEMP_HighBalance_JobTable T2 ON (T1.AccountNumber = T2.AccountNumber)
				WHERE NextStatement IS NOT NULL

				;WITH CTE
				AS
				(
					SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY RowCounter DESC) LastRecord
					FROM #TempRecords
				)
				INSERT INTO TSDBOHBConversion_Account (SN, acctID, AccountNumber, CurrentBalance, AmtOfAcctHighBalLTD)
				SELECT T2.SN, T2.BSacctID, T1.AccountNumber, T1.CurrentBalance, T1.HighBalance
				FROM CTE T1
				JOIN #TEMP_HighBalance_JobTable T2 ON (T1.AccountNumber = T2.AccountNumber)
				WHERE LastRecord = 1



				UPDATE A
					SET JobStatus = 2
				FROM TSDBOHBConversion A
				JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)

				INSERT INTO TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB DONE', @@ROWCOUNT, GETDATE())


				
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
		SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 1
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