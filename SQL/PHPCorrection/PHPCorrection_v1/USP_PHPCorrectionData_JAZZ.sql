--EXEC USP_PHPCorrectionData_JAZZ

CREATE OR ALTER PROCEDURE USP_PHPCorrectionData_JAZZ
AS
BEGIN

	--AUTHOR :: PRASOON PARASHAR

	SET NOCOUNT ON
	SET QUOTED_IDENTIFIER ON
	SET ARITHABORT ON

	DECLARE 
		@ReportingCuttOffDay VARCHAR(20), 
		@ValidationTime DATETIME = GETDATE(),
		@RowsInserted DECIMAL(19, 0) = 0,
		@Description VARCHAR(MAX),
		@ErrorFlag TINYINT = 1

	--SET @ValidationTime = dbo.PR_ISOGetBusinessTime()

	IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WITH (NOLOCK) WHERE Environment_Name LIKE '%LOCAL%')
	BEGIN
		SET @ValidationTime = dbo.PR_ISOGetBusinessTime()
	END

	--SET @ValidationTime = '2021-05-20 21:50:17.000'

	SET @ReportingCuttOffDay = 'Monday'

	SET @ReportingCuttOffDay = UPPER(@ReportingCuttOffDay)
	--SELECT @ReportingCuttOffDay

	DECLARE @StartOfWeek INT

	SELECT @StartOfWeek = 
		CASE
			WHEN @ReportingCuttOffDay = 'MONDAY' THEN 1
			WHEN @ReportingCuttOffDay = 'TUESDAY' THEN 2
			WHEN @ReportingCuttOffDay = 'WEDNESDAY' THEN 3
			WHEN @ReportingCuttOffDay = 'THURSDAY' THEN 4
			WHEN @ReportingCuttOffDay = 'FRIDAY' THEN 5
			WHEN @ReportingCuttOffDay = 'SATURDAY' THEN 6
			WHEN @ReportingCuttOffDay = 'SUNDAY' THEN 7
		END
	SELECT @StartOfWeek = CASE WHEN @StartOfWeek - 1 = 0 THEN 7 ELSE @StartOfWeek - 1 END
	--SELECT @StartOfWeek

	DECLARE @StartDate DATETIME, @EndDate DATETIME
	DECLARE @BillingFrom INT, @BillingTo INT
	SET DATEFIRST @StartOfWeek
	SET @EndDate = DATEADD(SECOND, 86397, TRY_CAST(DATEADD(DAY, 1 - DATEPART(WEEKDAY,@ValidationTime), CAST(@ValidationTime AS DATE)) AS DATETIME))
	SET @StartDate = DATEADD(DAY, -7, @EndDate)
	SET @BillingFrom = TRY_CAST(DAY(@StartDate) AS INT) + 1
	SET @BillingTo = TRY_CAST(DAY(@EndDate) AS INT)

	SET @EndDate = @ValidationTime

	--SELECT @ValidationTime, @StartDate, @EndDate, @BillingFrom, @BillingTo

	DROP TABLE IF EXISTS #TempAccounts
	SELECT BP.acctID, BP.AccountNumber, BP.SystemStatus, DateAcctOpened, BP.BillingCycle, COALESCE(BB.StatementDateCC2, DateAcctOpened) DateFrom, @EndDate DateTo, BP.LastStatementDate --BP.LastStatementDate DateTo
	INTO #TempAccounts
	FROM BSegment_Primary BP WITH (NOLOCK)
	JOIN BSegment_Balances BB WITH (NOLOCK) ON (BP.acctID = BB.acctID)
	WHERE BillingCycle <> 'LTD'
	--AND TRY_CAST(BillingCycle AS INT) BETWEEN @BillingFrom AND @BillingTo
	AND BP.LastStatementDate BETWEEN @StartDate AND @EndDate
	AND BP.LastStatementDate IS NOT NULL

	--SELECT * FROM #TempAccounts WHERE DateFrom IS NULL

	DROP TABLE IF EXISTS #Pmt1
	SELECT BSAcctID, CP.AccountNumber, TranID, TransactionAmount, TranTime, CP.PostTime, Txnsource, TransactionDescription, PostingRef, T1.SystemStatus, T1.BillingCycle, DateFrom, DateTo, LastStatementDate,
	CASE WHEN DAY(TranTime) <= TRY_CAST(BillingCycle AS INT) THEN DATEADD(SS, 86397, TRY_CAST(TRY_CAST(YEAR(TranTime) AS VARCHAR)+'-'+TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+BillingCycle AS DATETIME)) 
	WHEN MONTH(TranTime) < 12 THEN DATEADD(SS, 86397, TRY_CAST(TRY_CAST(YEAR(TranTime) AS VARCHAR)+'-'+TRY_CAST(MONTH(TranTime)+1 AS VARCHAR)+'-'+BillingCycle AS DATETIME)) 
	ELSE DATEADD(SS, 86397, TRY_CAST(TRY_CAST(YEAR(TranTime)+1 AS VARCHAR)+'-'+TRY_CAST(1 AS VARCHAR)+'-'+BillingCycle AS DATETIME)) 
	END
	AS StmtDateTxnTime
	INTO #Pmt1
	FROM CCard_Primary CP WITH (NOLOCK)
	JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (CP.TranID = TIA.Tran_Id_Index)
	JOIN #TempAccounts T1 ON (CP.AccountNumber = T1.AccountNumber)
	WHERE CMTTRANTYPE = '21'
	AND TIA.ATID = 51
	AND CP.PostTime BETWEEN DateFrom AND DateTo
	--AND CP.TranTime < DateFrom

	DROP TABLE IF EXISTS #Pmt
	SELECT *
	INTO #Pmt
	FROM #Pmt1 CP
	WHERE CP.PostTime BETWEEN DateFrom AND DateTo
	--AND CP.TranTime < DateFrom
	AND CP.TranTime < CASE WHEN CP.PostTime > LastStatementDate THEN LastStatementDate ELSE DateFrom END

	--SELECT * FROM #Pmt

	;WITH CTE
	AS
	(
	SELECT CP.RevTgt
	FROM CCard_Primary cP WITH (NOLOCK)
	JOIN #Pmt P ON (CP.RevTgt = P.TranID)
	)
	DELETE P
	FROM #Pmt P
	JOIN CTE C ON (P.TranID = C.RevTgt)
			

	DROP TABLE IF EXISTS #byMO
	SELECT SUM(TransactionAmount) Amt,BSAcctID,TRY_CAST(month(StmtDateTxnTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(StmtDateTxnTime) AS VARCHAR) MO 
	INTO #byMO 
	FROM #Pmt 
	GROUP BY BSAcctID,TRY_CAST(month(StmtDateTxnTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(StmtDateTxnTime) AS VARCHAR)

	UPDATE P 
	SET TransactionAmount = Amt 
	FROM #Pmt P 
	JOIN #byMO B ON (B.BSAcctID = P.BSAcctiD and b.MO = TRY_CAST(month(StmtDateTxnTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(StmtDateTxnTime) AS VARCHAR))

	
	DROP TABLE IF EXISTS #Pmtfinal
	;WITH CTE
	AS
	(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY BSAcctID,TRY_CAST(MONTH(StmtDateTxnTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(StmtDateTxnTime) AS VARCHAR) order by BSAcctID,TRY_CAST(MONTH(StmtDateTxnTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(StmtDateTxnTime) AS VARCHAR)) RN
	FROM #Pmt
	)
	SELECT *
	INTO #Pmtfinal
	FROM CTE
	WHERE RN = 1
				
				
	DROP tABLE IF EXISTS #Stmt
	selecT P.*,acctid,statementdate,chargeoffdate,cycleduedtd,ccinhparent125aid,currentbalance,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,
	AmountOfPayment30DLate,AmountOfPayment60DLate,
	AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate
	INTO #Stmt
	FROM StatementHeader SH with(nolock) 
	JOIN #Pmtfinal P ON (P.BSAcctid = SH.acctId)
	WHERE SH.StatementDate > P.TranTime

	DROP TABLE IF EXISTS #stmt30DPD
	SELECT *
	INTO #stmt30DPD 
	FROM #Stmt
	WHERE BSAcctID IN 
	(
	SELECT BSAcctID FROM #stmt GROUP BY BSAcctID HAVING MAX(CycleDueDTD) > 2
	)
	AND statementdate < posttime order by acctid,statementdate
				
	--DECLARE @LinkServer VARCHAR(50)
	--SELECT @LinkServer = ''
				
	--SELeCT * FROM sys.servers
				
	--;WITH CTE--AS
	--(
	--SELECT B.TranID,B.acctId--FROM #stmt30dpd S 
	--JOIN LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.BSCBRPHPHistory B with(nolock) on (B.acctId = S.BSAcctID)
	--)
	--UPDATE SECOND--SET AccountNumber = 'NotRequired'
	--FROM #stmt30DPD SECOND--JOIN CTE C ON (S.TranID = C.TranID)
				
				
	DROP TABLE IF EXISTS #temp30dpd
	SELECT * 
	INTO #temp30dpd 
	FROM #stmt30DPD
	WHERE accountnumber <> 'NotRequired'
				
				
				
	DROP TABLE IF EXISTS #Multi
	SELECT BSAcctID, TranID, COUNT(1) MonthCount INTO #Multi FROM #temp30dpd GROUP BY BSAcctID, TranID HAVING COUNT(1) > 1
				
	DROP TABLE IF EXISTS #TempCompute
	SELECT *
	INTO #TempCompute
	FROM #temp30dpd
	WHERE BSAcctID NOT IN (SELECT BSAcctID FROM #Multi)
				
				
	DROP TABLE IF EXISTS #TempComputedData1Cycle
	SELECT * ,
	CASE	WHEN AmountOfPayment210DLate > TransactionAmount THEN 9
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > TransactionAmount THEN 8
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate > TransactionAmount THEN 7
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > TransactionAmount THEN 6
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > TransactionAmount THEN 5
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > TransactionAmount THEN 4
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > TransactionAmount THEN 3
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > TransactionAmount THEN 2
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > TransactionAmount THEN 1
	ELSE 0
	END
	AS ComputedCycleDueDTD
	INTO #TempComputedData1Cycle
	FROM #TempCompute

	UPDATE M
	SET ComputedCycleDueDTD =  CASE WHEN ComputedCycleDueDTD = 0 THEN ComputedCycleDueDTD + 1 ELSE ComputedCycleDueDTD END 
	FROM #TempComputedData1Cycle M
	WHERE CurrentBalance > TransactionAmount


	DROP TABLE IF EXISTS #MultiCycle
	SELECT T1.*, RANK() OVER(PARTITION BY T1.BSAcctID, T1.TranID ORDER BY T1.statementDate) [Rank], TRY_CAST(0 AS INT) AdjustedCycle
	INTO #MultiCycle
	FROM #temp30dpd T1 
	JOIN #Multi M ON (T1.BSAcctId = M.BSAcctID AND T1.TranID = M.TranID)
																										
																										
	UPDATE M
	SET AdjustedCycle = 
	CycleDueDTD - 
	CASE
		WHEN AmountOfPayment210DLate > TransactionAmount THEN 9
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > TransactionAmount THEN 8
		WHEN AmountOfPayment210DLate+AmountOfPayment180dLate+AmountOfPayment150DLate > TransactionAmount THEN 7
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > TransactionAmount THEN 6
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > TransactionAmount THEN 5
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > TransactionAmount THEN 4
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > TransactionAmount THEN 3
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > TransactionAmount THEN 2
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfpayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > TransactionAmount THEN 1
	ELSE 0
	END
	FROM #MultiCycle M
	WHERE [Rank] = 1

	UPDATE M
	SET AdjustedCycle =  CASE WHEN CycleDueDTD-AdjustedCycle = 0 THEN AdjustedCycle - 1 ELSE AdjustedCycle END
	FROM #MultiCycle M
	WHERE [Rank] = 1
	AND CurrentBalance > TransactionAmount


	UPDATE M2
	SET M2.AdjustedCycle = M1.AdjustedCycle
	FROM #MultiCycle M1
	JOIN #MultiCycle M2 ON (M1.BSAcctID = M2.BSAcctId AND M1.TranID = M2.TranID AND M1.[Rank] = 1 AND M2.[Rank] > 1)
																																														
	--SELECT CASE WHEN CycleDueDTD-AdjustedCycle > 0 THEN CycleDueDTD-AdjustedCycle ELSE 0 END ComputedCycleDueDTD, CycleDueDTD, AdjustedCycle, * 
	--FROM #MultiCycle
																																														
	DROP TABLE IF EXISTS #TempComputedDataMultiCycle
	SELECT *, CASE WHEN CycleDueDTD-AdjustedCycle > 0 THEN CycleDueDTD-AdjustedCycle ELSE 0 END ComputedCycleDueDTD
	INTO #TempComputedDataMultiCycle
	FROM #MultiCycle
																																														
	DROP TaBLE IF EXISTS #TempComputedData1CycleCBRCorrected
	SELECT CSH.CurrentBalance CSH_CB, CASE WHEN T1.CurrentBalance-CSH.CurrentBalance <=0 THEN 1 ELSE 0 END ReportingCorrected,T1.* 
	INTO #TempComputedData1CycleCBRCorrected
	FROM #TempComputedData1Cycle  T1
	JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (T1.BSAcctID = CsH.acctId AND T1.STatementDate = CSH.STatementDate)
	ORDER BY T1.BSacctId, T1.StatementDate
																																														
	DROP TABLE IF EXISTS #TempComputedDataMultiCycleCBRCorrected
	SELECT CSH.CurrentBalance CSH_CB, CASE WHEN T1.CurrentBalance-CSH.CurrentBalance <=0 THEN 1 ELSE 0 END ReportingCorrected,T1.* 
	INTO #TempComputedDataMultiCycleCBRCorrected
	FROM #TempComputedDataMultiCycle  T1
	JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (T1.BSAcctID = CSH.acctId AND T1.STatementDate = CSH.STatementDate)
	ORDER BY T1.BSacctId, T1.StatementDate
																																														
	DROP TABLE IF EXISTS #Combined
	SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected
	INTO #Combined
	FROM #TempComputedData1CycleCBRCorrected
	WHERE CycleDueDTD > ComputedCycleDueDTD 
	AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NUlL)
	AND CycleDueDTD > 2
	INSERT INTO #Combined
	SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected
	FROM #TempComputedDataMultiCycleCBRCorrected
	WHERE CycleDueDTD > ComputedCycleDueDTD 
	AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
	AND CycleDueDTD > 2
																																														
	--SELECT *, ROW_NUMBER() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK] 
	--FROM #Combined--WHERE BSAcctID = 13566680
	--ORDER BY BSAcctId, STatementDate

	--PLAT

	--DROP TABLE IF EXISTS #CombinedUnique
	--;WITH CTE--AS
	--AS
	--(
	--SELECT *, ROW_NUMBER() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK]
	--FROM #Combined
	--)
	--SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected,
	--CASE WHEN ComputedCycleDueDTD-1 > 0 THEN ComputedCycleDueDTD-1 ELSE 0 END PHPValue, DATEDIFF(MM,StatementDate,GETDATE())  CtrToUpdate
	--INTO #CombinedUnique
	--FROM CTE WHERE [Rank] = 1

	--JAZZ

	DROP TABLE IF EXISTS #CombinedUnique
	;WITH CTE
	AS
	(
	SELECT *, RANK() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK]
	FROM #Combined
	)
	SELECT BSAcctID, BP.AccountNumber, C.TranID, C.TransactionAmount, C.TranTime, C.PostTime, C.StatementDate, C.SystemStatus, C.CurrentBalance, 
	C.CSH_CB, C.CycleDueDTD, C.ComputedCycleDueDTD, C.ReportingCorrected,
	CASE WHEN ComputedCycleDueDTD-1 > 0 THEN ComputedCycleDueDTD-1 ELSE 0 END PHPValue, DATEDIFF(MM,C.StatementDate,BP.LastStatementDate) + 1 CtrToUpdate
	INTO #CombinedUnique
	FROM CTE C
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (C.BSAcctID = BP.acctID)
	WHERE [Rank] = 1
																																														
	--SELECT * FROM #CombinedUnique ORDER BY STatementDate
	--DROP TABLE IF eXISTS #PHPValues
	--CREATE TABLE #PHPValues(BSAcctID InT, StatementDate DATETIME, [Response] VARCHAR(MAX))
																																														
	--;WITH CTE
	--AS
	--(
	--SELECT BSAcctID, StatementDate,
	--CASEWHEN CtrToUpdate < 10 THEN 'ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR)
	--		WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR)
	--END Counter,
	--PHPValue--FROM #CombinedUnique--)
	--SELECT C.*,
	--ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
	--ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
	--ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
	--ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24
	--FROM CTE CASE--JOIN BSegment_Balances B WITH (NOLOCK) ON (C.BSAcctid = B.acctId)
																																														
	DROP TABLE IF EXISTS #TempPHPData
	;WITH CTE
	AS
	(
	SELECT BSAcctID, StatementDate, AccountNumber,
	CASE
		WHEN CtrToUpdate < 10 THEN 'ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR)
		WHEN CtrToUpdate >= 10 AnD CtrToUpdate <= 24 THEN 'ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR)
	END Counter,
	PHPValue
	FROM #CombinedUnique
	),
	PHPCounters
	AS
	(
	SELECT C.*,
	CASE Counter	
			WHEN 'ReportHistoryCtrCC01' THEN B.ReportHistoryCtrCC01	
			WHEN 'ReportHistoryCtrCC02' THEN B.ReportHistoryCtrCC02	
			WHEN 'ReportHistoryCtrCC03' THEN B.ReportHistoryCtrCC03	
			WHEN 'ReportHistoryCtrCC04' THEN B.ReportHistoryCtrCC04	
			WHEN 'ReportHistoryCtrCC05' THEN B.ReportHistoryCtrCC05	
			WHEN 'ReportHistoryCtrCC06' THEN B.ReportHistoryCtrCC06	
			WHEN 'ReportHistoryCtrCC07' THEN B.ReportHistoryCtrCC07	
			WHEN 'ReportHistoryCtrCC08' THEN B.ReportHistoryCtrCC08	
			WHEN 'ReportHistoryCtrCC09' THEN B.ReportHistoryCtrCC09	
			WHEN 'ReportHistoryCtrCC10' THEN B.ReportHistoryCtrCC10	
			WHEN 'ReportHistoryCtrCC11' THEN B.ReportHistoryCtrCC11	
			WHEN 'ReportHistoryCtrCC12' THEN B.ReportHistoryCtrCC12	
			WHEN 'ReportHistoryCtrCC13' THEN B.ReportHistoryCtrCC13	
			WHEN 'ReportHistoryCtrCC14' THEN B.ReportHistoryCtrCC14	
			WHEN 'ReportHistoryCtrCC15' THEN B.ReportHistoryCtrCC15	
			WHEN 'ReportHistoryCtrCC16' THEN B.ReportHistoryCtrCC16	
			WHEN 'ReportHistoryCtrCC17' THEN B.ReportHistoryCtrCC17	
			WHEN 'ReportHistoryCtrCC18' THEN B.ReportHistoryCtrCC18	
			WHEN 'ReportHistoryCtrCC19' THEN B.ReportHistoryCtrCC19	
			WHEN 'ReportHistoryCtrCC20' THEN B.ReportHistoryCtrCC20	
			WHEN 'ReportHistoryCtrCC21' THEN B.ReportHistoryCtrCC21	
			WHEN 'ReportHistoryCtrCC22' THEN B.ReportHistoryCtrCC22	
			WHEN 'ReportHistoryCtrCC23' THEN B.ReportHistoryCtrCC23	
			WHEN 'ReportHistoryCtrCC24' THEN B.ReportHistoryCtrCC24
	END AS CurrentPHPBit
	FROM CTE C
	JOIN BSegment_Balances B WITH (NOLOCK) ON (C.BSAcctid = B.acctId)
	)
	SELECT *--,
	--'UPDATE TOP(1) BSegment_Balances SET ' + Counter + ' = ' + TRY_CAST(PHPValue AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR) + '' [UpdateCommand]
	INTO #TempPHPData
	FROM PHPCounters
	WHERE PHPValue < CurrentPHPBit

	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PHPCorrectionData (AccountNumber, acctID, StatementDate, PHPCounter, CurrentCounterValue, UpdatedCounterValue)
			SELECT 
				T.AccountNumber, BSAcctID, T.StatementDate, Counter, CurrentPHPBit, PHPValue
			FROM #TempPHPData T
			LEFT JOIN PHPCorrectionData P ON (T.BSacctID = P.acctID AND T.Counter = P.PHPCounter AND P.JobStatus = 'NEW')
			WHERE P.acctID IS NULL

			SET @RowsInserted = @@ROWCOUNT
			SET @ErrorFlag = 0

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @RowsInserted = 0
		SET @ErrorFlag = 1
		ROLLBACK TRANSACTION
		SET @Description = @Description + 'ERROR LINE ( ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' ) DESCRIPTION : ' + ERROR_MESSAGE() + CHAR(10)
	END CATCH

	IF @ErrorFlag = 0
		SELECT 'SUCCESS|' + TRY_CAST(@RowsInserted AS VARCHAR) AS 'RESULT'
	ELSE
		SELECT 'ERROR|' + @Description AS 'RESULT'
	
END