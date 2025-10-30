SELECT DATENAME(MONTH, DATEADD(MM, -1, GETDATE())) + ', ' + DATENAME(YEAR, DATEADD(MM, -1, GETDATE())), EOMONTH(GETDATE(), -1)

SELECT DATEDIFF(MM,GETDATE(),'2021-05-31 23:59:57.000')


DROP TABLE IF EXISTS #Months
CREATE TABLE #Months (Months VARCHAR(50), [Value] DATE, [ROW] INT) 

DECLARE @CurrentTime DATETIME, @Frequency INT, @COUNT INT

SET @COUNT = 10 
SET @Frequency = 0

WHILE(@Frequency < @COUNT)
BEGIN
	SET @Frequency = @Frequency + 1
	INSERT INTO #Months SELECT DATENAME(MONTH, DATEADD(MM, -@Frequency, GETDATE())) + ', ' + DATENAME(YEAR, DATEADD(MM, -@Frequency, GETDATE())), EOMONTH(GETDATE(), -@Frequency), @COUNT-@Frequency+1
END

SELECT * FROM #Months

DROP TABLE IF EXISTS ##Months
SELECT * INTO ##Months FROM #Months


--SELECT * FROM (SELECT * FROM #Months) t
--PIVOT (COUNT(Counts) FOR Months IN (SELECT Months FROM #Months)) AS pivot_table


DROP TABLE IF EXISTS #PHPDetails
SELECT BB.acctId, P.StatementDate, P.AccountNumber, P.AccountUUID,
DATEDIFF(MM,P.StatementDate,GETDATE()) CtrToUpdate,
TRY_CAST(ISNULL(ReportHistoryCtrCC01, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC02, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC03, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC04, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC05, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC06, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC07, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC08, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC09, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC10, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC11, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC12, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC13, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC14, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC15, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC16, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC17, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC18, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC19, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC20, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC21, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC22, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC23, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC24, 0) AS VARCHAR) CurrentPHP,
ReportHistoryCtrCC01,
ReportHistoryCtrCC02,
ReportHistoryCtrCC03,
ReportHistoryCtrCC04,
ReportHistoryCtrCC05,
ReportHistoryCtrCC06,
ReportHistoryCtrCC07,
ReportHistoryCtrCC08,
ReportHistoryCtrCC09,
ReportHistoryCtrCC10,
ReportHistoryCtrCC11,
ReportHistoryCtrCC12,
ReportHistoryCtrCC13,
ReportHistoryCtrCC14,
ReportHistoryCtrCC15,
ReportHistoryCtrCC16,
ReportHistoryCtrCC17,
ReportHistoryCtrCC18,
ReportHistoryCtrCC19,
ReportHistoryCtrCC20,
ReportHistoryCtrCC21,
ReportHistoryCtrCC22,
ReportHistoryCtrCC23,
ReportHistoryCtrCC24
INTO #PHPDetails
FROM BSegment_Balances BB WITH (NOLOCK)
JOIN ##PHPUpdate P ON (BB.acctId = P.acctId)
WHERE P.[Row] = 1
ORDER BY P.StatementDate



SELECT 
'UPDATE #PHPDetails SET ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = 0 WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) + ' AND StatementDate = ''' + TRY_CONVERT(VARCHAR(50), StatementDate, 20) + ''''
,* FROM #PHPDetails

UPDATE #PHPDetails SET ReportHistoryCtrCC03 = 0 WHERE acctId = 762543 AND StatementDate = '2021-09-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC03 = 0 WHERE acctId = 1133683 AND StatementDate = '2021-09-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC07 = 0 WHERE acctId = 1742986 AND StatementDate = '2021-05-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC06 = 0 WHERE acctId = 1742986 AND StatementDate = '2021-06-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC06 = 0 WHERE acctId = 1751764 AND StatementDate = '2021-06-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC04 = 0 WHERE acctId = 2619343 AND StatementDate = '2021-08-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC04 = 0 WHERE acctId = 7603336 AND StatementDate = '2021-08-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC04 = 0 WHERE acctId = 9437465 AND StatementDate = '2021-08-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC04 = 0 WHERE acctId = 10302152 AND StatementDate = '2021-08-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC02 = 0 WHERE acctId = 11198517 AND StatementDate = '2021-10-31 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC01 = 0 WHERE acctId = 11198517 AND StatementDate = '2021-11-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC06 = 0 WHERE acctId = 13004403 AND StatementDate = '2021-06-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC01 = 0 WHERE acctId = 13547515 AND StatementDate = '2021-11-30 23:59:57'
UPDATE #PHPDetails SET ReportHistoryCtrCC01 = 0 WHERE acctId = 14875531 AND StatementDate = '2021-11-30 23:59:57'




SELECT acctId, StatementDate, CtrToUpdate,
TRY_CAST(ISNULL(ReportHistoryCtrCC01, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC02, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC03, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC04, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC05, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC06, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC07, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC08, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC09, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC10, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC11, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC12, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC13, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC14, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC15, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC16, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC17, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC18, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC19, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC20, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC21, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC22, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC23, 0) AS VARCHAR) +
TRY_CAST(ISNULL(ReportHistoryCtrCC24, 0) AS VARCHAR) UpdatedPHP,
CurrentPHP,
ReportHistoryCtrCC01,
ReportHistoryCtrCC02,
ReportHistoryCtrCC03,
ReportHistoryCtrCC04,
ReportHistoryCtrCC05,
ReportHistoryCtrCC06,
ReportHistoryCtrCC07,
ReportHistoryCtrCC08,
ReportHistoryCtrCC09,
ReportHistoryCtrCC10,
ReportHistoryCtrCC11,
ReportHistoryCtrCC12,
ReportHistoryCtrCC13,
ReportHistoryCtrCC14,
ReportHistoryCtrCC15,
ReportHistoryCtrCC16,
ReportHistoryCtrCC17,
ReportHistoryCtrCC18,
ReportHistoryCtrCC19,
ReportHistoryCtrCC20,
ReportHistoryCtrCC21,
ReportHistoryCtrCC22,
ReportHistoryCtrCC23,
ReportHistoryCtrCC24
FROM #PHPDetails
WHERE acctId = 1742986
ORDER BY StatementDate

SELECT paymentHistProfile,* FROm CBReportingDetail WITh (NOLOCk) WHERE acctId = 1742986 ORDER By StatementDate DESC