/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

--EXEC USP_ReCalculateHighBalance_TSDBO @AccountID = 14551608, @AccountNumber = '1100000100200242', @LastStatementDate = '2018-02-28', @ViewOnly = 1

CREATE OR ALTER   PROCEDURE USP_ReCalculateHighBalance_TSDBO
--DECLARE
	@AccountID INT,
	@AccountNumber VARCHAR(19),
	@LastStatementDate DATETIME,
	@TSDBOActiveDate DATETIME = NULL,
	@TxnBuffer VARCHAR(MAX) = NULL,
	@CCRBuffer1 VARCHAR(MAX) = NULL,
	@GenTxnBuffer VARCHAR(MAX) = NULL,
	@AllowedMonths INT = 30,
	@ViewOnly INT = 1

AS
BEGIN
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET NOCOUNT ON

	--Author	- Prasoon Parashar

	--SET @AccountID = 14551608

	--SELECT 
	--	@AccountNumber = BP.AccountNumber,
	--	@LastStatementDate = CreatedTime,
	--	@ViewOnly = 1
	--FROM BSegment_Primary BP WITH (NOLOCK)
	--WHERE BP.acctID = @AccountID

	DECLARE 
		@ProcessTime DATETIME,
		@CBRAmountOfHighBalance MONEY = 0

	-- OUTPUT VARIABLES

	DECLARE
		@StatementDate DATETIME = NULL,
		@ErrorFlag INT = 0,
		@AdjustedCurrentBalance MONEY = NULL,
		@AdjustedHighBalance MONEY = NULL,
		@CurrentBalance MONEY = NULL,
		@Json NVARCHAR(MAX)

	DROP TABLE IF EXISTS #TempData
	CREATE TABLE #TempData
	(
		AccountNumber VARCHAR(19),
		CMTTRANTYPE VARCHAR(10),
		TransactionAmount MONEY,
		TranId DECIMAL(19, 0),
		TranRef DECIMAL(19, 0),
		RevTgt DECIMAL(19, 0),
		Trantime DATETIME,
		PostTime DATETIME,
		TxnSource VARCHAR(5),
		NoBlobIndicator VARCHAR(5),
		Transactionidentifier VARCHAR(5),
		Priority INT,
		DateTimeLocalTransaction DATETIME,
		Artxntype VARCHAR(5),
		TxnAcctID INT,
		TxnIsFor VARCHAR(10),
		TransmissionDateTime DATETIME,
		MemoIndicator VARCHAR(5),
		MergeActivityFlag INT,
		UpdateEffectiveDate INT
	)

	IF(ISNULL(@ViewOnly, 0) = 0)
	BEGIN
		SET @ProcessTime = @LastStatementDate
	END
	ELSE
	BEGIN
		SELECT TOP 1 @ProcessTime = SH.StatementDate
		FROM StatementHeader SH WITH (NOLOCK)
		WHERE SH.StatementDate <= @LastStatementDate

		IF(@ProcessTime IS NULL)
		BEGIN
			SELECT @ProcessTime = CreatedTime FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = @AccountID
		END
	END

	DROP TABLE IF EXISTS #BaselineData
	SELECT 
		SH.acctID, 
		SH.AccountNumber,
		SH.StatementDate, 
		COALESCE(CSH.AdjustedCurrentBalance, SH.CurrentBalance + SH.CurrentBalanceCO - CSH.CurrentBalance) CurrentBalance, 
		COALESCE(CSH.AdjustedHighBalance, SH.AmtOfAcctHighBalLTD) AmtOfAcctHighBalLTD,
		--ISNULL(CSH.AdjustedCurrentBalance, 0) AdjustedCurrentBalance, 
		--ISNULL(CSH.AdjustedHighBalance, 0) AdjustedHighBalance,
		ISNULL(CSH.AdjustedTransactionAmount, 0) AdjustedTransactionAmount
	INTO #BaselineData
	FROM StatementHeader SH WITH (NOLOCK)
	JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate)
	WHERE SH.acctId = @AccountID
	AND SH.StatementDate = @ProcessTime

	--SELECT * FROM #BaselineData

	IF NOT EXISTS (SELECT TOP 1 1 FROM #BaselineData)
	BEGIN
		INSERT INTO #BaselineData VALUES
		(@AccountID, @AccountNumber, @ProcessTime, 0, 0, 0)
	END

	SELECT TOP 1 @CBRAmountOfHighBalance = AmtOfAcctHighBalLTD FROM #BaselineData

	INSERT INTO #TempData
	SELECT 
		CP.AccountNumber 
		, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE 
		, ISNULL(CP.TransactionAmount, 0) TransactionAmount
		, CP.TranId
		, CP.TranRef
		, CP.RevTgt 
		, Trantime
		, CP.PostTime 
		, CP.TxnSource 
		, CP.NoBlobIndicator
		, Transactionidentifier
		, CASE WHEN CP.TranRef IS NULL THEN 1 ELSE 5 END Priority  
		, CP.DateTimeLocalTransaction
		, CP.Artxntype  
		, CP.BSAcctID TxnAcctID
		, CP.TxnIsFor
		, CP.TransmissionDateTime
		, CP.MemoIndicator
		, CP.MergeActivityFlag
		,	CASE 
				WHEN		CP.Trantime < CP.PostTime 
						AND DATEDIFF(MM, CP.Trantime, CP.PostTime) > @AllowedMonths
						AND CP.PostTime > @TSDBOActiveDate
				THEN 1
				ELSE 0
			END UpdateEffectiveDate
	FROM CCard_Primary CP WITH (NOLOCK)
	WHERE CP.AccountNumber IN (@AccountNumber) 
	AND CP.CMTTRANTYPE IN ('02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',  
							'17','18','19','21','22','23','24','25','26','28','29','30','31','32','33',  
							'35','37','38','40','41','42','43','45','48','49','50',/*'51','52',*/'53',/*'54', */  --PLAT-92882
							'55','56','57','58','60','61','62','63','64','65','66','67','68','69','70',  
							'71','72','73','74','75','76','77','78','79','80','81','82','83','84','85',  
							'86','87','90','91','92','93','94','95','96','97','98',
							'110','111','1111','115','116','117','118', 'ADDSCRA', 'ADDBK', 'ECD')
	AND CP.PostTime > @ProcessTime

	--SELECT * FROM #TempData

	DELETE FROM #TempData WHERE Artxntype  = '93'

	DELETE FROM #TempData WHERE MergeActivityFlag IS NOT NULL AND MemoIndicator = 'MEMO'

	DELETE T
	FROM #TempData T
	LEFT JOIN Trans_In_Acct TIA WITH (NOLOCK) ON (T.TxnAcctID = TIA.acctId AND T.TranID = TIA.Tran_Id_Index AND TIA.ATID = 51 AND TIA.Tran_Id_Table = 0)
	WHERE TIA.acctId IS NULL
	AND T.CMTTRANTYPE NOT IN ('ADDSCRA', 'ADDBK', 'ECD')

	UPDATE #TempData SET TranTime = PostTime WHERE UpdateEffectiveDate = 1

	DELETE FROM #TempData WHERE TranTime <= @ProcessTime

	INSERT INTO #TempData (TranId, CMTTRANTYPE, AccountNumber, TransactionAmount, Trantime, PostTime, Priority)
	SELECT 0, '00', AccountNumber, CurrentBalance, StatementDate, StatementDate, 0
	FROM #BaselineData

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



	--SELECT * FROM #TempData


	IF(@TxnBuffer IS NOT NULL AND @TxnBuffer <> '')
	BEGIN
		;WITH XMLData AS (
			SELECT CAST('<r>' + REPLACE(@TxnBuffer, ',', '</r><r>') + '</r>' AS XML) AS DataXML
		)
		INSERT INTO #TempData
		SELECT 
			NULLIF(T.X.value('(r[1])[1]', 'NVARCHAR(MAX)'), '')								AS AccountNumber, 
			NULLIF(T.X.value('(r[2])[1]', 'NVARCHAR(MAX)'), '')								AS CmnTranType,       
			TRY_CAST(NULLIF(T.X.value('(r[3])[1]', 'NVARCHAR(MAX)'), '')	AS MONEY)			AS TransactionAmount,
			TRY_CAST(NULLIF(T.X.value('(r[4])[1]', 'NVARCHAR(MAX)'), '')	AS DECIMAL(19, 0))	AS TranId,
			TRY_CAST(NULLIF(T.X.value('(r[5])[1]', 'NVARCHAR(MAX)'), '0')	AS DECIMAL(19, 0))	AS TranRef,
			TRY_CAST(NULLIF(T.X.value('(r[6])[1]', 'NVARCHAR(MAX)'), '0')	AS DECIMAL(19, 0))	AS RevTgt,
			TRY_CAST(NULLIF(T.X.value('(r[7])[1]', 'NVARCHAR(MAX)'), '')	AS DATETIME)			AS TranTime,
			TRY_CAST(NULLIF(T.X.value('(r[8])[1]', 'NVARCHAR(MAX)'), '')	AS DATETIME)			AS PostTime,
			NULLIF(T.X.value('(r[9])[1]', 'NVARCHAR(MAX)'), '')								AS TxnSource,            
			NULLIF(T.X.value('(r[10])[1]', 'NVARCHAR(MAX)'), '')								AS NoBlobIndicator,      
			NULLIF(T.X.value('(r[11])[1]', 'NVARCHAR(MAX)'), '')								AS TransactionIdentifier,
			TRY_CAST(NULLIF(T.X.value('(r[12])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS Priority,
			TRY_CAST(NULLIF(T.X.value('(r[13])[1]', 'NVARCHAR(MAX)'), '')	AS DATETIME)			AS DateTimeLocalTransaction,
			NULLIF(T.X.value('(r[14])[1]', 'NVARCHAR(MAX)'), '')								AS Artxntype,       
			TRY_CAST(NULLIF(T.X.value('(r[15])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS TxnAcctId,
			NULLIF(T.X.value('(r[16])[1]', 'NVARCHAR(MAX)'), '')								AS TxnIsFor,         
			TRY_CAST(NULLIF(T.X.value('(r[17])[1]', 'NVARCHAR(MAX)'), '')	AS DATETIME)			AS TransmissionDateTime,
			NULLIF(T.X.value('(r[18])[1]', 'NVARCHAR(MAX)'), '')								AS MemoIndicator,
			TRY_CAST(NULLIF(T.X.value('(r[19])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS MergeActivityFlag,
			TRY_CAST(NULLIF(T.X.value('(r[20])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS UpdateEffectiveDate
		FROM XMLData
		CROSS APPLY (SELECT DataXML.query('/r') AS X) T;
	END


	IF(@GenTxnBuffer IS NOT NULL AND @GenTxnBuffer <> '')
	BEGIN
		;WITH XMLData AS (
			SELECT CAST('<r>' + REPLACE(@GenTxnBuffer, ',', '</r><r>') + '</r>' AS XML) AS DataXML
		)
		INSERT INTO #TempData
		SELECT 
			NULLIF(T.X.value('(r[1])[1]', 'NVARCHAR(MAX)'), '')								AS AccountNumber, -- VARCHAR(19)
			NULLIF(T.X.value('(r[2])[1]', 'NVARCHAR(MAX)'), '')								AS CmnTranType,         -- VARCHAR(5)
			TRY_CAST(NULLIF(T.X.value('(r[3])[1]', 'NVARCHAR(MAX)'), '') AS MONEY)				AS TransactionAmount,
			TRY_CAST(NULLIF(T.X.value('(r[4])[1]', 'NVARCHAR(MAX)'), '') AS DECIMAL(19, 0))		AS TranId,
			TRY_CAST(NULLIF(T.X.value('(r[5])[1]', 'NVARCHAR(MAX)'), '0') AS DECIMAL(19, 0))		AS TranRef,
			TRY_CAST(NULLIF(T.X.value('(r[6])[1]', 'NVARCHAR(MAX)'), '0') AS DECIMAL(19, 0))		AS RevTgt,
			TRY_CAST(NULLIF(T.X.value('(r[7])[1]', 'NVARCHAR(MAX)'), '') AS DATETIME)			AS TranTime,
			TRY_CAST(NULLIF(T.X.value('(r[8])[1]', 'NVARCHAR(MAX)'), '') AS DATETIME)			AS PostTime,
			NULLIF(T.X.value('(r[9])[1]', 'NVARCHAR(MAX)'), '')								AS TxnSource,             -- VARCHAR(5)
			NULLIF(T.X.value('(r[10])[1]', 'NVARCHAR(MAX)'), '')								AS NoBlobIndicator,       -- VARCHAR(5)
			NULLIF(T.X.value('(r[11])[1]', 'NVARCHAR(MAX)'), '')								AS TransactionIdentifier, -- VARCHAR(20)
			TRY_CAST(NULLIF(T.X.value('(r[12])[1]', 'NVARCHAR(MAX)'), '') AS INT)				AS Priority,
			TRY_CAST(NULLIF(T.X.value('(r[13])[1]', 'NVARCHAR(MAX)'), '') AS DATETIME)			AS DateTimeLocalTransaction,
			NULLIF(T.X.value('(r[14])[1]', 'NVARCHAR(MAX)'), '')								AS Artxntype,             -- VARCHAR(5)
			TRY_CAST(NULLIF(T.X.value('(r[15])[1]', 'NVARCHAR(MAX)'), '') AS INT)				AS TxnAcctId,
			NULLIF(T.X.value('(r[16])[1]', 'NVARCHAR(MAX)'), '')								AS TxnIsFor,              -- VARCHAR(5)
			TRY_CAST(NULLIF(T.X.value('(r[17])[1]', 'NVARCHAR(MAX)'), '') AS DATETIME)			AS TransmissionDateTime,
			NULLIF(T.X.value('(r[18])[1]', 'NVARCHAR(MAX)'), '')								AS MemoIndicator,
			TRY_CAST(NULLIF(T.X.value('(r[19])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS MergeActivityFlag,
			TRY_CAST(NULLIF(T.X.value('(r[20])[1]', 'NVARCHAR(MAX)'), '')	AS INT)				AS UpdateEffectiveDate
		FROM XMLData
		CROSS APPLY (SELECT DataXML.query('/r') AS X) T;
	END

	DROP TABLE IF EXISTS #CCRBuffer
	CREATE TABLE #CCRBuffer(AccountNumber VARCHAR(19), parent02AID INT, PlanID INT, StatementDate DATETIME, InterestCredits MONEY, TranType VARCHAR(5))

	IF(@CCRBuffer1 IS NOT NULL AND @CCRBuffer1 <> '')
	BEGIN
		;WITH XMLData AS (
		SELECT CAST('<r>' + REPLACE(@CCRBuffer1, '|', '</r><r>') + '</r>' AS XML) AS DataXML
		)
		INSERT INTO #CCRBuffer (PlanID, StatementDate, InterestCredits, TranType)
		SELECT 
			TRY_CONVERT(INT,    SUBSTRING(RowData, 1, pos1 - 1))                      AS ID,
			TRY_CONVERT(DATETIME, SUBSTRING(RowData, pos1 + 1, pos2 - pos1 - 1))     AS [Date],
			TRY_CONVERT(MONEY,  SUBSTRING(RowData, pos2 + 1, pos3 - pos2 - 1))       AS [Value],
			LTRIM(RTRIM(SUBSTRING(RowData, pos3 + 1, LEN(RowData))))                AS [TranType]
		FROM (
			SELECT T.c.value('.', 'NVARCHAR(MAX)') AS RowData
			FROM XMLData
			CROSS APPLY DataXML.nodes('/r') AS T(c)
		) AS ParsedData
		CROSS APPLY (SELECT CHARINDEX(',', RowData) AS pos1) AS FirstComma
		CROSS APPLY (SELECT CHARINDEX(',', RowData, pos1 + 1) AS pos2) AS SecondComma
		CROSS APPLY (SELECT CHARINDEX(',', RowData, pos2 + 1) AS pos3) AS ThirdComma
		WHERE pos1 > 0 AND pos2 > pos1 AND pos3 > pos2;


		UPDATE #CCRBuffer 
		SET 
			StatementDate = DATEADD(SECOND, 86397, StatementDate),
			AccountNumber = @AccountNumber,
			parent02AID = @AccountID
	END

	--SELECT @Json = (SELECT * FROM #TempData FOR JSON PATH, ROOT('TempData1'))
	--PRINT (@Json)

	INSERT INTO #TempData (TranId, CMTTRANTYPE, AccountNumber, TxnAcctID, TransactionAmount, Trantime, PostTime, Priority, DateTimeLocalTransaction, TxnSource, NoblobIndicator)
	SELECT 0, TranType, AccountNumber, parent02AID, InterestCredits, StatementDate, StatementDate, 5, StatementDate, '4', '9'
	FROM #CCRBuffer
	WHERE TranType = '02'



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

	--SELECT * FROM #TempData WHERE CMTTRANTYPE IN ('02', '03')

	-- USE THE BELOW LOGIC WHEN WE HAVE BILLING CYCLE NOT THE MONTH-END, FOR NOW I HAVE USED THE SIMPLER LOGIC TO CALCULATE

	--DROP TABLE IF EXISTS #TCAPIntCredits
	--SELECT  ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY PostTime) RN,AccountNumber, CMTTRANTYPE, TransactionAmount, TranId
	--, Trantime, PostTime, TxnSource, NoBlobIndicator, Transactionidentifier
	--, TRY_CAST(CASE WHEN EOMONTH(@LastStatementDate) = TRY_CAST(@LastStatementDate AS DATE) THEN '31' ELSE DAY(@LastStatementDate) END AS VARCHAR(5)) BillingCycle
	--,
	--TRY_CAST(
	--CASE 
	--	WHEN CASE WHEN EOMONTH(@LastStatementDate) = TRY_CAST(@LastStatementDate AS DATE) THEN '31' ELSE DAY(@LastStatementDate) END = '31'
	--	THEN
	--		CASE 
	--			WHEN MONTH(Trantime) = 2 THEN CASE WHEN YEAR(Trantime)%4 = 0 THEN '29' ELSE '28' END
	--			WHEN MONTH(Trantime) = 4 OR MONTH(Trantime) = 6 OR MONTH(Trantime) = 9 OR MONTH(Trantime) = 11 THEN '30' 
	--			ELSE '31'
	--		END
	--	ELSE CASE WHEN EOMONTH(@LastStatementDate) = TRY_CAST(@LastStatementDate AS DATE) THEN '31' ELSE DAY(@LastStatementDate) END
	--END AS VARCHAR(5)) TempBillingCycle
	--,TRY_CAST(NULL AS DATETIME) CalcDate
	--,TRY_CAST(NULL AS DATETIME) CalcDateToUse
	--INTO #TCAPIntCredits
	--FROM #TempData 
	--WHERE CMTTRANTYPE = '03' AND TransactionIdentifier = 'TCAP'

	----SELECT * FROM #TCAPIntCredits


	--UPDATE #TCAPIntCredits
	--SET CalcDate =
	--TRY_CAST(
	--TRY_CAST(YEAR(Trantime) AS VARCHAR(4)) 
	--+ CASE WHEN MONTH(Trantime) >= 10 THEN '-' ELSE '-0' END + TRY_CAST(MONTH(Trantime) AS VARCHAR(2)) 
	--+ CASE WHEN TRY_CAST(TempBillingCycle AS INT) >= 10 THEN '-' ELSE '-0' END + TempBillingCycle + ' 23:59:57'
	--AS DATETIME)

	--UPDATE #TCAPIntCredits
	--SET CalcDateToUse = 
	--CASE 
	--	WHEN CalcDate <= Trantime 
	--	THEN CalcDate 
	--	ELSE 
	--		CASE 
	--			WHEN BillingCycle = '31' 
	--			THEN DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, CalcDate)) AS DATETIME))
	--			ELSE DATEADD(MONTH, -1, CalcDate) 
	--		END 
	--END

	--UPDATE T
	--SET TranTime = I.CalcDateToUse
	--FROM #TempData T
	--JOIN #TCAPIntCredits I ON (T.TranID = I.TranID)

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
	JOIN ConsolidatedCreditRecords C2 WITH (NOLOCK) ON (C.TxnAcctID = C2.parent02AID)
	WHERE C.CMTTRANTYPE = '03'
	UNION
	SELECT DISTINCT 0, C.AccountNumber, 0 TranRef, parent02AID BSAcctID, InterestCredits TransactionAmount, StatementDate
	FROM #CCRBuffer C
	WHERE TranType = '03'

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

 

	;WITH CTE  
	AS  
	(  
		SELECT AccountNumber, CMTTRANTYPE, RevTgt, SUM(TransactionAmount) TransactionAmount  
		FROM #TempData  
		WHERE RevTgt IS NOT NULL 
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
	CASE WHEN T1.TransactionAmount > C.TransactionAmount THEN C.TransactionAmount ELSE T1.TransactionAmount END InterestCreditToAdjust,
	CASE WHEN T1.TransactionAmount > C.TransactionAmount THEN 0 ELSE C.TransactionAmount - T1.TransactionAmount END InterestCreditLeft
	FROM #TempData T1  
	JOIN CTE C ON (T1.TranTime = C.TranTime AND T1.TxnAcctID = C.TxnAcctID AND T1.CMTTranType = '02')
	)
	UPDATE T
	SET TransactionAmount = CASE WHEN T.CMTTRanType = '02' THEN T.TransactionAmount - InterestCreditToAdjust ELSE InterestCreditLeft END
	FROM #TempData T
	JOIN InterestCalculation I ON (T.TxnAcctID = I.TxnAcctID AND T.TranTime = I.TranTime)
	WHERE T.CMTTRanType IN ('02', '03')
	AND T.TxnSource <> '2' 

	--SELECT @Json = (SELECT * FROM #TempData FOR JSON PATH, ROOT('TempData2'))
	--PRINT (@Json)
	

	DELETE FROM #TempData WHERE RevTgt IS NOT NULL 
	DELETE FROM #TempData WHERE CMTTranType = '03' AND TranID = 0 AND TransactionAmount <= 0

	DELETE FROM #TempData WHERE TransactionAmount = 0 AND Priority > 0 
	DELETE FROM #TempData WHERE Artxntype  IN ('99','104') 
	DELETE FROM #TempData WHERE Artxntype  = '95' AND CMTTranType <> '61' 

	--SELECT * FROM #TempData ORDER BY TranTime
	--SELECT * FROM #BaseLineData 

	--SELECT *
	--FROM #TempData T
	--JOIN #BaseLineData B ON (T.AccountNumber = B.AccountNumber)
	--WHERE T.TranTime <= B.StatementDate
	--AND T.CMTTRANTYPE <> '00'

	DELETE T
	FROM #TempData T
	JOIN #BaseLineData B ON (T.AccountNumber = B.AccountNumber)
	WHERE T.TranTime <= B.StatementDate
	AND T.CMTTRANTYPE <> '00'

	DROP TABLE IF EXISTS #TempRecords
	;WITH CTE
	AS
	(
		SELECT ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority, PostTime) RowCounter, 
		AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID,
		SUM(CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 1 THEN TransactionAmount*-1 ELSE TransactionAmount END) 
		OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority, PostTime ROWS UNBOUNDED PRECEDING) CurrentBalance
		FROM #TempData
	)
	SELECT RowCounter, AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID, CurrentBalance,
	CASE WHEN RowCounter = 1 Then @CBRAmountOfHighBalance
	ELSE MAX(CASE WHEN CurrentBalance > @CBRAmountOfHighBalance THEN CurrentBalance ELSE @CBRAmountOfHighBalance END) OVER (PARTITION BY AccountNumber ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) END HighBalance
	INTO #TempRecords
	FROM CTE

	--SELECT * FROM #TempRecords
	

	IF(ISNULL(@ViewOnly, 0) = 0)
	BEGIN
		DROP TABLE IF EXISTS #TempStatements
		;WITH CTE
		AS
		(
			SELECT AccountNumber, MIN(TranTime) MinTranTime, MAX(TranTime) MaxTranTime
			FROM #TempRecords
			GROUP BY AccountNumber
		)
		SELECT SH.AccountNumber, SH.acctID, SH.CurrentBalance + SH.CurrentBalanceCO - CSH.CurrentBalance CurrentBalance, 
		ISNULL(SH.LastStatementDate, SH.DateAcctOpened) LastStatementDate, SH.StatementDate,
		COALESCE(CSH.IsAcctSCRA, SH.IsAcctSCRA, 0) IsAcctSCRA,
		CASE WHEN T.AccountNumber IS NOT NULL THEN 1 ELSE 0 END IsAcctTCAP,
		CSH.AdjustedTransactionAmount
		INTO #TempStatements
		FROM CTE C
		JOIN StatementHeader SH WITH (NOLOCK) ON (C.AccountNumber = SH.AccountNumber)
		JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate) 
		LEFT JOIN #TCAPCycle T ON (T.AccountNumber = SH.AccountNumber AND T.Trantime = SH.StatementDate)
		WHERE SH.StatementDate >= C.MinTranTime --AND C.MaxTranTime

		--SELECT * FROM #TempRecords

		--SELECT @Json = (SELECT * FROM #TempRecords FOR JSON PATH, ROOT('TempRecords'))
		--PRINT (@Json)


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
			CASE WHEN T1.StatementDate <= MaxTranTime THEN 1 ELSE 0 END InCycleRecord,
			T4.AdjustedTransactionAmount
			FROM #TempStatements T1
			LEFT JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)
			JOIN CutOff T3 ON (T1.AccountNumber = T3.AccountNumber)
			JOIN #BaselineData T4 ON (T1.AccountNumber = T4.AccountNumber)
			WHERE T1.StatementDate >= T2.TranTime
			AND CycleLastRecord = 1
		)
		SELECT *
		INTO #TempRecordsStatement
		FROM Statements
		WHERE RN = 1
	

		UPDATE S
		SET 
			AdjustedCurrentBalance = T.CurrentBalance,
			AdjustedHighBalance = T.HighBalance
		FROM CurrentStatementHeader S
		JOIN #TempRecordsStatement T ON (T.acctID = S.acctID AND T.NextStatement = S.StatementDate)


		SELECT TOP 1 
			@LastStatementDate = T2.LastStatementDate,
			@StatementDate = T2.StatementDate, 
			@AdjustedCurrentBalance = T1.CurrentBalance, 
			@AdjustedHighBalance = T1.HighBalance, 
			@CurrentBalance = T2.CurrentBalance
		FROM #TempRecordsStatement T1
		JOIN #TempStatements T2 ON (T1.acctID = T2.acctID AND T1.NextStatement = T2.StatementDate)
		WHERE T1.CurrentBalance - ISNULL(T1.AdjustedTransactionAmount, 0) <> T2.CurrentBalance
		AND T2.IsAcctSCRA = 0
		AND T2.IsAcctTCAP = 0
		ORDER BY T2.StatementDate


		--SELECT T2.LastStatementDate, T2.StatementDate, T1.CurrentBalance, T1.HighBalance, T2.CurrentBalance, T1.AdjustedTransactionAmount
		--FROM #TempRecordsStatement T1
		--JOIN #TempStatements T2 ON (T1.acctID = T2.acctID AND T1.NextStatement = T2.StatementDate)
		--WHERE T1.CurrentBalance - ISNULL(T1.AdjustedTransactionAmount, 0) <> T2.CurrentBalance 
		--AND T2.IsAcctSCRA = 0
		--AND T2.IsAcctTCAP = 0
		--ORDER BY T2.StatementDate

	
		IF(@StatementDate IS NOT NULL)
		BEGIN
			SET @ErrorFlag = 1
		END
		ELSE
		BEGIN
			SET @ErrorFlag = 0
		END
	


		SELECT TOP 1 
			HighBalance AmtOfAcctHighBal, 
			@LastStatementDate LastStatementDate,
			@StatementDate StatementDate,
			@AdjustedCurrentBalance AdjustedCurrentBalance,
			@AdjustedHighBalance AdjustedHighBalance,
			@CurrentBalance CurrentBalance,
			@ErrorFlag ErrorFlag
		FROM #TempRecords
		ORDER BY RowCounter DESC

	END
	ELSE
	BEGIN
		SELECT 
			RowCounter, 
			CMTTRANTYPE, 
			CASE WHEN CMTTRANTYPE = '00' THEN 'Baseline Record' ELSE CL.LutDescription END TransactionType, 
			TransactionAmount, 
			TranID, 
			TranTime, 
			PostTime, 
			CurrentBalance, 
			HighBalance
		FROM #TempRecords T1
		LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (T1.CMTTRANTYPE = CL.LutCode AND CL.LUTid = 'StmtTranCode')
		ORDER BY RowCounter
	END

END