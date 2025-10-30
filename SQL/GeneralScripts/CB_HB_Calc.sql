DECLARE 
	@AccountID INT = 14551525, --
	@CMTTranType VARCHAR(10), 
	@CurrentBalance MONEY = 0, -- 
	@HighBalance MONEY = 0, --
	@RowCounter INT = 0, 
	@TransactionAmount MONEY = 0, --
	@TransactionTime DATETIME, --
	@ProcessTime DATETIME, --
	@AccountCreationTime DATETIME, --
	@BreakPoint1 DATETIME, --
	@BreakPoint2 DATETIME, -- 
	@BreakPoint3 DATETIME, --
	@BreakPoint4 DATETIME, --
	@CB_BP_1 MONEY = 0, --
	@CB_BP_2 MONEY = 0,	--
	@CB_BP_3 MONEY = 0,	--
	@CB_BP_4 MONEY = 0,	--
	@HB_BP_1 MONEY = 0,	--
	@HB_BP_2 MONEY = 0,	--
	@HB_BP_3 MONEY = 0,	--
	@HB_BP_4 MONEY = 0,	--
	@Year VARCHAR(10), 
	@Month VARCHAR(15), 
	@Day VARCHAR(5), 
	@Time VARCHAR(15)



SET @TransactionTime = dbo.PR_ISOGetBusinessTime()




--Logic for calculating break points

SELECT @Year = TRY_CAST(YEAR(@TransactionTime) AS VARCHAR)
SELECT @Month = TRY_CAST((DATEPART(QUARTER,@TransactionTime)-1)*3 AS VARCHAR)
SELECT @Day = TRY_CAST(DAY(EOMONTH(TRY_CAST(@Year+'-'+TRY_CAST(TRY_CAST(@Month AS INT)*3 AS VARCHAR)+'-1' AS DATETIME))) AS VARCHAR)
SET @Time = '23:59:57'

SELECT @BreakPoint1 = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(TRY_CAST(@Year+'-'+@Month+'-'+@Day AS DATETIME)) AS DATETIME))
SET @BreakPoint2 = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -3, @BreakPoint1)) AS DATETIME))
SET @BreakPoint3 = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -3, @BreakPoint2)) AS DATETIME))
SET @BreakPoint4 = DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -3, @BreakPoint3)) AS DATETIME))

--SELECT @TransactionTime CurrentDate, @BreakPoint1 BreakPoint1, @BreakPoint2 BreakPoint2, @BreakPoint3 BreakPoint3, @BreakPoint4 BreakPoint4



SELECT @AccountCreationTime = DateAcctOpened FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = @AccountID

IF(@TransactionTime > @BreakPoint1 AND @HB_BP_1 > 0)
BEGIN
	SET @CurrentBalance = @CB_BP_1
	SET @HighBalance = @HB_BP_1
	SET @ProcessTime = @BreakPoint1
END
ELSE IF(@TransactionTime > @BreakPoint2 AND @HB_BP_2 > 0)
BEGIN
	SET @CurrentBalance = @CB_BP_2
	SET @HighBalance = @HB_BP_2
	SET @ProcessTime = @BreakPoint2
END
ELSE IF(@TransactionTime > @BreakPoint3 AND @HB_BP_3 > 0)
BEGIN
	SET @CurrentBalance = @CB_BP_3
	SET @HighBalance = @HB_BP_3
	SET @ProcessTime = @BreakPoint3
END
ELSE IF(@TransactionTime > @BreakPoint4 AND @HB_BP_4 > 0)
BEGIN
	SET @CurrentBalance = @CB_BP_4
	SET @HighBalance = @HB_BP_4
	SET @ProcessTime = @BreakPoint4
END
ELSE
BEGIN
	SET @CurrentBalance = 0
	SET @HighBalance = 0
	SET @ProcessTime = @AccountCreationTime
END


PRINT @TransactionTime

--DROP TABLE IF EXISTS #TempData
--SELECT ROW_NUMBER() OVER (PARTITION BY CP.AccountNumber ORDER BY PostTime) RowCounter, CP.AccountNumber, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,
--CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.RevTgt,
--Trantime,CP.PostTime, TRY_CAST(0 AS MONEY) CurrentBalance, TRY_CAST(0 AS MONEY) HighBalance
--INTO #TempData
--FROM CCard_Primary CP WITH (NOLOCK)
--WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = @AccountID) 
--AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
--AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 /*OR CP.CMTTRANTYPE IN ('QNA')*/)
----AND CP.TxnSource NOT IN ('4','10')
--AND CP.MemoIndicator IS NULL
--AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
--AND CP.PostTime > @ProcessTime

DROP TABLE IF EXISTS #TempData
SELECT ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY PostTime) RowCounter, CP.AccountNumber, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE
, CP.TransactionDescription, CP.ARTxnType,
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.RevTgt,
Trantime,CP.PostTime, TRY_CAST(0 AS MONEY) CurrentBalance, TRY_CAST(0 AS MONEY) HighBalance
INTO #TempData
FROM CCard_Primary CP WITH (NOLOCK)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = @AccountID) 
AND CP.CMTTRANTYPE IN ('02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',  
						'17','18','19','21','22','23','24','25','26','28','29','30','31','32','33',  
						'35','37','38','40','41','42','43','45','48','49','50','51','52','53','54',  
						'55','56','57','58','60','61','62','63','64','65','66','67','68','69','70',  
						'71','72','73','74','75','76','77','78','79','80','81','82','83','84','85',  
						'86','87','90','91','92','93','94','95','96','97','98',
						'110','111','1111','115','116','117','118')
AND CP.PostTime > @ProcessTime

--SELECT * FROM #TempData

;WITH CTE
AS
(
	SELECT *
	FROM #TempData
	WHERE RevTgt IS NOT NULL
)
UPDATE T1
SET TransactionAmount = T1.TransactionAmount - C.TransactionAmount
FROM #TempData T1
JOIN CTE C ON (T1.TranID = C.RevTgt)

DELETE FROM #TempData WHERE RevTgt IS NOT NULL 


DECLARE db_cursor CURSOR FOR
SELECT 
	RowCounter, CMTTranType, TransactionAmount
FROM #tempData
Order By RowCounter

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @RowCounter, @CMTTranType, @TransactionAmount

--PRINT @@FETCH_STATUS

WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF(TRY_CAST(@CMTTranType AS INT)%2 = 1)
	BEGIN
		SET @CurrentBalance = @CurrentBalance - @TransactionAmount
	END
	ELSE
	BEGIN
		SET @CurrentBalance = @CurrentBalance + @TransactionAmount
	END

	IF(@CurrentBalance > @HighBalance)
	BEGIN
		SET @HighBalance = @CurrentBalance
	END

	UPDATE #TempData SET CurrentBalance = @CurrentBalance, HighBalance = @HighBalance WHERE RowCounter = @RowCounter
	
	FETCH NEXT FROM db_cursor INTO @RowCounter, @CMTTranType, @TransactionAmount
END

CLOSE db_cursor
DEALLOCATE db_cursor

SELECT * FROM #TempData

SELECT TOP 1 @CurrentBalance = CurrentBalance, @HighBalance = HighBalance FROM #TempData ORDER BY RowCounter DESC
SELECT TOP 1 @CB_BP_1 = CurrentBalance, @HB_BP_1 = HighBalance FROM #TempData WHERE PostTime <= @BreakPoint1 AND PostTime >= @BreakPoint2 ORDER BY RowCounter DESC
SELECT TOP 1 @CB_BP_2 = CurrentBalance, @HB_BP_2 = HighBalance FROM #TempData WHERE PostTime <= @BreakPoint2 AND PostTime >= @BreakPoint3 ORDER BY RowCounter DESC
SELECT TOP 1 @CB_BP_3 = CurrentBalance, @HB_BP_3 = HighBalance FROM #TempData WHERE PostTime <= @BreakPoint3 AND PostTime >= @BreakPoint4 ORDER BY RowCounter DESC
SELECT TOP 1 @CB_BP_4 = CurrentBalance, @HB_BP_4 = HighBalance FROM #TempData WHERE PostTime <= @BreakPoint4 ORDER BY RowCounter DESC

--SELECT TOP 1 CurrentBalance, HighBalance FROM #TempData ORDER BY RowCounter DESC
--SELECT TOP 1 CurrentBalance, HighBalance FROM #TempData WHERE PostTime <= @BreakPoint1 AND PostTime >= @BreakPoint2 ORDER BY RowCounter DESC
--SELECT TOP 1 CurrentBalance, HighBalance FROM #TempData WHERE PostTime <= @BreakPoint2 AND PostTime >= @BreakPoint3 ORDER BY RowCounter DESC
--SELECT TOP 1 CurrentBalance, HighBalance FROM #TempData WHERE PostTime <= @BreakPoint3 AND PostTime >= @BreakPoint4 ORDER BY RowCounter DESC
--SELECT TOP 1 CurrentBalance, HighBalance FROM #TempData WHERE PostTime <= @BreakPoint4 ORDER BY RowCounter DESC

--SELECT * FROM #TempData WHERE PostTime <= '2018-03-31 23:59:57.000' ORDER BY RowCounter DESC

SELECT 
	@TransactionTime TransactionTime,
	@CurrentBalance CurrentBalance, 
	@HighBalance HighBalance,
	@BreakPoint1 BreakPoint1,
	CASE WHEN @TransactionTime > @BreakPoint1 THEN @CB_BP_1 ELSE 0 END CB_BP_1, 
	CASE WHEN @TransactionTime > @BreakPoint1 THEN @HB_BP_1 ELSE 0 END HB_BP_1,
	@BreakPoint2 BreakPoint2,
	CASE WHEN @TransactionTime > @BreakPoint2 THEN @CB_BP_2 ELSE 0 END CB_BP_2, 
	CASE WHEN @TransactionTime > @BreakPoint2 THEN @HB_BP_2 ELSE 0 END HB_BP_2, 
	@BreakPoint3 BreakPoint3,
	CASE WHEN @TransactionTime > @BreakPoint3 THEN @CB_BP_3 ELSE 0 END CB_BP_3, 
	CASE WHEN @TransactionTime > @BreakPoint3 THEN @HB_BP_3 ELSE 0 END HB_BP_3,
	@BreakPoint4 BreakPoint4,
	CASE WHEN @TransactionTime > @BreakPoint4 THEN @CB_BP_4 ELSE 0 END CB_BP_4, 
	CASE WHEN @TransactionTime > @BreakPoint4 THEN @HB_BP_4 ELSE 0 END HB_BP_4

