
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

	--SELECT DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -2, TRY_CAST(EOMONTH(GETDATE()) AS DATETIME))) AS DATETIME))

	DROP TABLE IF EXISTS #Pmt
	SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, TxnSource, TransactionDescription, PostingRef, DATEDIFF(MONTH,TranTime,PostTime) DIFFCycle
	INTO #Pmt
	FROM CCard_Primary CP WITH (NOLOCK)
	JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (CP.TranID = TIA.Tran_Id_Index)
	WHERE CMTTRANTYPE = '21'
	AND TIA.ATID = 51
	AND DATEDIFF(MONTH,TranTime,PostTime) > 0
	--AND PostTime > DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -2, TRY_CAST(EOMONTH(@ValidationTime) AS DATETIME))) AS DATETIME))
	--AND PostTime <= DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, TRY_CAST(EOMONTH(@ValidationTime) AS DATETIME))) AS DATETIME))

	;WITH CTE
	AS
	(
		SELECT CP.RevTgt
		FROM CCard_Primary CP WITH (NOLOCK)
		JOIN #Pmt P ON (CP.RevTgt = P.TranID)
	)
	DELETE P
	FROM #Pmt P
	JOIN CTE C ON (P.TranID = C.RevTgt)

	DROP TABLE IF EXISTS #byMO
	SELECT SUM(TransactionAmount) Amt,BSAcctID, TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(TranTime) AS VARCHAR) MO
	INTO #byMO 
	from #Pmt 
	GROUP BY BSAcctID, TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(TranTime) AS VARCHAR)

	UPDATE P 
		SET TransactionAmount = Amt 
	FROM #Pmt P 
	JOIN #byMO B ON (B.BSAcctID = P.BSAcctID and B.MO = TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(TranTime) AS VARCHAR))

	DROP TABLE IF EXISTS #Pmtfinal
	;WITH CTE
	AS
	(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY BSAcctID,TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(TranTime) AS VARCHAR) order by BSAcctID,TRY_CAST(MONTH(TranTime) AS VARCHAR)+'-'+TRY_CAST(YEAR(TranTime) AS VARCHAR)) RN
	FROM #Pmt
	)
	SELECT *
	INTO #Pmtfinal
	FROM CTE
	WHERE RN = 1


	DROP TABLE IF EXISTS #Stmt
	selecT P.*,acctid,statementdate,chargeoffdate,cycleduedtd,ccinhparent125aid,systemstatus,currentbalance,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
	AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate
	INTO #Stmt
	FROM StatementHeader SH with(nolock) 
	JOIN #Pmtfinal P ON (P.BSAcctid = SH.acctId)
	WHERE SH.StatementDate > P.TranTime

	DROP TABLE IF EXISTS #stmt30DPD
	SELECT *
	INTO #stmt30DPD 
	FROM #stmt
	WHERE BSAcctID IN (
	SELECT BSAcctID FROM #stmt GROUP BY BSAcctID HAVING MAX(CycleDueDTD) > 2
	)
	AND statementdate < posttime order by acctid,statementdate


	--DECLARE @LinkServer VARCHAR(50)
	--SELECT @LinkServer = ''

	--SELECT * FROM sys.servers

	--;WITH CTE
	--AS
	--(
	--SELECT B.TranID,B.acctID
	--FROM #stmt30dpd S 
	--JOIN LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.BSCBRPHPHistory B with(nolock) on (B.acctId = S.BSAcctID)
	--)
	--UPDATE S
	--SET AccountNumber = 'NotRequired'
	--FROM #stmt30DPD S
	--JOIN CTE C ON (S.TranID = C.TranID)


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
	SELECT T1.*, RANK() OVER(PARTITION BY T1.BSAcctID, T1.TranID ORDER BY T1.StatementDate) [Rank], TRY_CAST(0 AS INT) AdjustedCycle
	INTO #MultiCycle
	FROM #temp30dpd T1 
	JOIN #Multi M ON (T1.BSAcctId = M.BSAcctID AND T1.TranID = M.TranID)


	UPDATE M
	SET AdjustedCycle = 
	CycleDueDTD - 
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


	DROP TABLE IF EXISTS #TempComputedData1CycleCBRCorrected
	SELECT CSH.CurrentBalance CSH_CB, CASE WHEN T1.CurrentBalance-CSH.CurrentBalance <=0 THEN 1 ELSE 0 END ReportingCorrected,T1.* 
	INTO #TempComputedData1CycleCBRCorrected
	FROM #TempComputedData1Cycle  T1
	JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (T1.BSAcctID = CSH.acctId AND T1.STatementDate = CSH.STatementDate)
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
	AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
	AND CycleDueDTD > 2
	INSERT INTO #Combined
	SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected
	FROM #TempComputedDataMultiCycleCBRCorrected
	WHERE CycleDueDTD > ComputedCycleDueDTD 
	AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
	AND CycleDueDTD > 2

	--SELECT *, ROW_NUMBER() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK] 
	--FROM #Combined
	--WHERE BSAcctID = 13566680
	--ORDER BY BSAcctId, StatementDate

	DROP TABLE IF EXISTS #CombinedUnique
	;WITH CTE
	AS
	(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK]
	FROM #Combined
	)
	SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected,
	CASE WHEN ComputedCycleDueDTD-1 > 0 THEN ComputedCycleDueDTD-1 ELSE 0 END PHPValue, DATEDIFF(MM,StatementDate,@ValidationTime)  CtrToUpdate
	INTO #CombinedUnique
	FROM CTE WHERE [Rank] = 1

	DROP TABLE IF EXISTS #TempPHPData
	;WITH CTE
	AS
	(
	SELECT *,
	CASE	WHEN CtrToUpdate < 10 THEN 'ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR)
			WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR)
	END Counter
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

	SELECT * FROM #TempPHPData
