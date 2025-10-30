/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

CREATE OR ALTER PROCEDURE USP_ParkOlderTransactionDetails_TSDBO
--DECLARE
	@AccountID INT,
	@AccountNumber VARCHAR(19),
	@TranTime DATETIME,
	@TxnBuffer VARCHAR(MAX) = NULL,
	@CCRBuffer1 VARCHAR(MAX) = NULL,
	@GenTxnBuffer VARCHAR(MAX) = NULL

AS
BEGIN
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET NOCOUNT ON

	--Author	- Prasoon Parashar

	--SET @AccountID = 14551608
	--SET @AccountNumber = '1100000100200242'
	--SET @TranTime = '02/21/2018 12:16:13:000'
	--SET @TxnBuffer = '1100001000006697,40,500.0000,1387981946013548546,1387418994485559498,1387418994485559498,04/01/2018 14:36:56:000,04/01/2018 14:36:56:000,13,,,3,,91,40755710,,0'
	--SET @CCRBuffer1 = '40755710,02/28/2018,2.66,03|40755710,03/31/2018,10.45,03'
	--SET @GenTxnBuffer = '1100001000006697,16,5.0000,1387981946013548546,1387418994485559498,1387418994485559498,04/01/2018 14:36:56:000,04/01/2018 14:36:56:000,13,,,3,,91,40755710,,0'
	
	DROP TABLE IF EXISTS #TxnBuffer
	CREATE TABLE #TxnBuffer
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

	DROP TABLE IF EXISTS #GenTxnBuffer
	CREATE TABLE #GenTxnBuffer
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

	DROP TABLE IF EXISTS #CCRBuffer
	CREATE TABLE #CCRBuffer
	(
		AccountNumber VARCHAR(19), 
		parent02AID INT, 
		PlanID INT, 
		StatementDate DATETIME, 
		InterestCredits MONEY, 
		TranType VARCHAR(5)
	)

	DROP TABLE IF EXISTS #CSHData
	SELECT CSH.acctID, CSH.StatementDate, TRY_CAST(0 AS MONEY) AdjustedTransactionAmount, SH.IsAcctSCRA
	INTO #CSHData
	FROM CurrentStatementHeader CSH WITH (NOLOCK)
	JOIN StatementHeader SH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementDate = CSH.StatementDate)
	WHERE CSH.acctID = @AccountID
	AND CSH.StatementDate >= @TranTime

	IF(@TxnBuffer IS NOT NULL AND @TxnBuffer <> '')
	BEGIN
		;WITH XMLData AS (
			SELECT CAST('<r>' + REPLACE(@TxnBuffer, ',', '</r><r>') + '</r>' AS XML) AS DataXML
		)
		INSERT INTO #TxnBuffer
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

		UPDATE #TxnBuffer 
		SET 
			TranTime = @TranTime,
			CMTTRANTYPE = 
						CASE 
							WHEN CMTTRANTYPE IN ('110','1104','114','1141','1143','1146','116','118','120') THEN '01'
							WHEN CMTTRANTYPE IN ('1103','111','1111','1119','113','1131','1133','1147','115','117','119') THEN '00'
							ELSE CMTTRANTYPE
						END

		
	END


	IF(@GenTxnBuffer IS NOT NULL AND @GenTxnBuffer <> '')
	BEGIN
		;WITH XMLData AS (
			SELECT CAST('<r>' + REPLACE(@GenTxnBuffer, ',', '</r><r>') + '</r>' AS XML) AS DataXML
		)
		INSERT INTO #GenTxnBuffer
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

		IF EXISTS (SELECT TOP 1 1 FROM #GenTxnBuffer WHERE TxnIsFor IN ('SCRA', 'BKRUT'))
		BEGIN
			
			;WITH CTE
			AS
			(
				SELECT CP.AccountNumber, CASE WHEN CP.TxnIsFor = 'SCRA' THEN CP.TransmissionDateTime ELSE CS.EffectiveDate END TranTime, 
				CP.PostTime, CP.TxnIsFor, ROW_NUMBER() OVER(PARTITION BY CP.AccountNumber ORDER BY CP.PostTime DESC) RN
				FROM CCard_Primary CP WITH (NOLOCK)
				JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranID = CS.TranID)
				JOIN #GenTxnBuffer T ON (CP.AccountNumber = T.AccountNumber)
				WHERE CP.CMTTRANTYPE IN ('ECD', 'ADDBK')
				AND CP.TranRef IS NULL
			),
			LastStatus
			AS
			(
				SELECT AccountNumber, MAX(PostTime) MaxCutOff
				FROM CTE
				WHERE RN > 1
				GROUP BY AccountNumber
			)
			INSERT INTO #CCRBuffer (PlanID, StatementDate, InterestCredits, TranType)
			SELECT DISTINCT C2.BSAcctID, C2.PostTime, C2.TransactionAmount, '03'
			FROM CTE C1
			JOIN CCard_Primary C2 WITH (NOLOCK) ON (C1.AccountNumber = C2.AccountNumber)
			JOIN LastStatus L ON (L.AccountNumber = C1.AccountNumber)
			WHERE C2.CMTTRANTYPE = '02'
			AND C2.TxnSource = '4'
			AND C2.PostTime BETWEEN C1.TranTime AND C1.PostTime
			AND C2.PostTime > L.MaxCutOff

			--SELECT * FROM #CCRBuffer

			UPDATE #CCRBuffer 
			SET 
				AccountNumber = @AccountNumber,
				parent02AID = @AccountID

			DELETE FROM #GenTxnBuffer

			UPDATE T1
				SET InterestCredits = 0
			FROM #CCRBuffer T1
			JOIN #CSHData T2 ON (T1.parent02AID = T2.acctID AND T1.StatementDate = T2.StatementDate)
			WHERE T2.IsAcctSCRA = 1

		END

	END


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


	--SELECT * FROM #TxnBuffer
	--SELECT * FROM #GenTxnBuffer
	--SELECT * FROM #CCRBuffer

	DROP TABLE IF EXISTS #TempData
	;WITH CTE
	AS
	(
		SELECT 
			AccountNumber, 
			@AccountID AccountID, 
			CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 0 THEN -1*TransactionAmount ELSE TransactionAmount END TransactionAmount, 
			TranTime, 
			PostTime 
		FROM #TxnBuffer 
		UNION ALL
		SELECT 
			AccountNumber, 
			@AccountID AccountID, 
			CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 0 THEN -1*TransactionAmount ELSE TransactionAmount END TransactionAmount, 
			TranTime, 
			PostTime 
		FROM #GenTxnBuffer 
		UNION ALL
		SELECT 
			AccountNumber, 
			@AccountID AccountID, 
			CASE WHEN TRY_CAST(TranType AS INT)%2 = 0 THEN -1*InterestCredits ELSE InterestCredits END TransactionAmount, 
			StatementDate TranTime, 
			StatementDate PostTime 
		FROM #CCRBuffer
	)
	SELECT *
	INTO #TempData
	FROM CTE

	--SELECT * FROM #TempData

	;WITH CTE
	AS
	(
		SELECT T1.*, CASE WHEN TranTime <= StatementDate AND ISNULL(T1.IsAcctSCRA, 0) = 0 THEN T2.TransactionAmount ELSE 0 END TransactionAmount
		FROM #CSHData T1
		JOIN #TempData T2 ON (T1.acctId = T2.AccountID)
		--WHERE StatementDate = '2019-06-30 23:59:57.000'

	)
	, Adjustment
	AS
	(
		SELECT acctID, StatementDate, SUM(TransactionAmount) TransactionAmount
		FROM CTE
		GROUP BY acctID, StatementDate
	)
	UPDATE CSH
	SET AdjustedTransactionAmount = TransactionAmount
	FROM #CSHData CSH
	JOIN Adjustment T ON (CSH.acctId = T.acctId AND CSH.StatementDate = T.StatementDate)


	UPDATE CSH
	SET
		AdjustedTransactionAmount = ISNULL(CSH.AdjustedTransactionAmount, 0) + ISNULL(T.AdjustedTransactionAmount, 0)
	FROM CurrentStatementHeader CSH
	JOIN #CSHData T ON (CSH.acctId = T.acctId AND CSH.StatementDate = T.StatementDate)



END