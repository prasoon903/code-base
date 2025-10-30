DROP TABLE IF EXISTS Temp_bsegment_DelinqDays
GO

CREATE TABLE Temp_bsegment_DelinqDays
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	FirstDueDate DATETIME,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT,
	JobStatus INT 
)

DROP INDEX IF EXISTS IX_Temp_bsegment_DelinqDays_Skey ON Temp_bsegment_DelinqDays
CREATE CLUSTERED INDEX IX_Temp_bsegment_DelinqDays_Skey  
    ON dbo.Temp_bsegment_DelinqDays (Skey);   
GO  

DROP INDEX IF EXISTS IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays

CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays
(
	JobStatus
)

-- TEMP DATA Tables

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
	DaysDelinquent_Original INT
)

-- Filling Temp table

INSERT INTO #Temp_bsegment_DelinqDays
SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), NoPayDaysDelinquent, 
	DaysDelinquent, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, DaysDelinquent
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'


DECLARE db_cursor CURSOR FOR
SELECT --TOP 5
	acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57') DateOfOriginalPaymentDueDTD
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
	NoPayDaysDelinquent = CASE WHEN CCINHPARENT125AID IN (15996, 16000) THEN DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, ActualDRPStartDate) ELSE DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, DeAcctActivityDate) + 1 END - ISNULL(TDS.TotalDaysDelinquent, 0)
FROM #Temp_bsegment_DelinqDays TBD
LEFT JOIN #TempDDFromStatement TDS ON (TBD.acctId = TDS.acctId)

-- Filling physical table

INSERT INTO Temp_bsegment_DelinqDays
SELECT
	acctId,
	FirstDueDate,
	NoPayDaysDelinquent, 
	DaysDelinquent,
	0
FROM  #Temp_bsegment_DelinqDays

-- 716 rows