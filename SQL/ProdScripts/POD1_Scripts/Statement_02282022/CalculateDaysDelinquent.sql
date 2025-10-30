SET NOCOUNT ON
DECLARE @acctId INT, @DateOfOriginalPaymentDueDTD DATETIME, @Counter INT

DROP TABLE IF EXISTS #TempDDFromStatement
DROp TABLE IF EXISTS #Temp_bsegment_DelinqDays

CREATE TABLE #TempDDFromStatement
(
	acctId INT, TotalDaysDelinquent INT
)

CREATE TABLE #Temp_bsegment_DelinqDays
(
	acctId INT,
	FirstDueDate DATETIME,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT, 
	DtOfLastDelinqCTD DATETIME, 
	DateOfOriginalPaymentDueDTD DATETIME,
	LAD DATETIME,
	DeAcctActivityDate DATETIME,
	ccinhparent125AID INT,
	ActualDRPStartDate DATETIME,
	CycleDueDTD INT,
	SystemStatus INT,
	DaysDelinquent_Original INT,
	NoPayDaysDelinquent_Original INT
)

INSERT INTO #Temp_bsegment_DelinqDays
SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, 
	TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), LAD, DeAcctActivityDate, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus, DaysDelinquent, NoPayDaysDelinquent
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'


DECLARE db_cursor CURSOR FOR
SELECT --TOP 5
	acctId, DateOfOriginalPaymentDueDTD
FROM #Temp_bsegment_DelinqDays
WHERE DateOfOriginalPaymentDueDTD <> DtOfLastDelinqCTD

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @acctId, @DateOfOriginalPaymentDueDTD

--PRINT @@FETCH_STATUS

WHILE @@FETCH_STATUS = 0
BEGIN
	--PRINT @acctId
	--PRINT @DateOfOriginalPaymentDueDTD

	--SET @Counter = @Counter + 1

	;WITH StatementData
	AS
	(
		SELECT 
			ISNULL(DATEDIFF(DAY, ActualDRPStartDate, StatementDate), 0) AS DD
		FROM StatementHeader SH WITH (NOLOCK)
		WHERE acctId = @acctId
		AND StatementDate > @DateOfOriginalPaymentDueDTD
		AND CCInhParent125AID IN (15996, 16000)
	)
	INSERT INTO #TempDDFromStatement
	SELECT @acctId, ISNULL(SUM(DD), 0)
	FROM StatementData
	
	FETCH NEXT FROM db_cursor INTO @acctId, @DateOfOriginalPaymentDueDTD
END

CLOSE db_cursor
DEALLOCATE db_cursor


UPDATE TBD
SET
	NoPayDaysDelinquent = CASE WHEN CCINHPARENT125AID IN (15996, 16000) THEN DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, ActualDRPStartDate) ELSE DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, DeAcctActivityDate) + 1 END - ISNULL(TDS.TotalDaysDelinquent, 0),
	DaysDelinquent = CASE WHEN CCINHPARENT125AID IN (15996, 16000) THEN DATEDIFF(DAY, DtOfLastDelinqCTD, ActualDRPStartDate) ELSE DATEDIFF(DAY, DtOfLastDelinqCTD, DeAcctActivityDate) + 1 END
FROM #Temp_bsegment_DelinqDays TBD
LEFT JOIN #TempDDFromStatement TDS ON (TBD.acctId = TDS.acctId)
--WHERE DateOfOriginalPaymentDueDTD <> DtOfLastDelinqCTD

SELECT
	acctId,
	FirstDueDate,
	NoPayDaysDelinquent, 
	DaysDelinquent,
	CycleDueDTD,
	SystemStatus,
	DtOfLastDelinqCTD,
	DeAcctActivityDate,
	DateOfOriginalPaymentDueDTD,
	DaysDelinquent_Original,
	NoPayDaysDelinquent_Original
FROM  #Temp_bsegment_DelinqDays
--WHERE acctId = 1680697

--SELECT * FROM #TempDDFromStatement WHERE acctId = 1680697




--SELECT ActualDRPStartDate, CCInhParent125AID, LastStatementDate, ISNULL(DATEDIFF(DAY, LastStatementDate, ActualDRPStartDate), 0) AS DD
--FROM StatementHeader SH WITH (NOLOCK)
--WHERE acctId = 1680697
----AND CAST(StatementDate AS DATE) > '2020-03-31 00:00:00.000'
--AND CCInhParent125AID IN (15996, 16000)

--;WITH StatementData
--AS
--(
--	SELECT 
--		ActualDRPStartDate, CCInhParent125AID, LastStatementDate, ISNULL(DATEDIFF(DAY, ActualDRPStartDate, StatementDate), 0) AS DD
--	FROM StatementHeader SH WITH (NOLOCK)
--	WHERE acctId = 538443
--	AND StatementDate > '2020-05-31 23:59:57.000'
--	AND CCInhParent125AID IN (15996, 16000)
--)
--SELECT 538443, SUM(DD) AS TDD
--FROM StatementData