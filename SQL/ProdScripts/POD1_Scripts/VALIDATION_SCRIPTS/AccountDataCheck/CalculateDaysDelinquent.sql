SET NOCOUNT ON
DECLARE @acctId INT, @DateOfOriginalPaymentDueDTD DATETIME, @Counter INT

DROP TABLE IF EXISTS #TempDDFromStatement
DROp TABLE IF EXISTS #Temp_bsegment_DelinqDays
--DROp TABLE IF EXISTS ##Temp_bsegment_DelinqDays

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
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
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
			--ISNULL(DATEDIFF(DAY, ActualDRPStartDate, StatementDate), 0) AS DD
			ISNULL(DATEDIFF(DAY, LastStatementDate, StatementDate), 0) AS DD
		FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
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
	NoPayDaysDelinquent_Original,
	ActualDRPStartDate
--INTO ##Temp_bsegment_DelinqDays
FROM  #Temp_bsegment_DelinqDays
--WHERE acctId = 6745786
--WHERE CAST(DateOfOriginalPaymentDueDTD AS DATE) > CAST(DtOfLastDelinqCTD AS DATE)
--WHERE DaysDelinquent_Original > NoPayDaysDelinquent
--WHERE NoPayDaysDelinquent <= 0

--SELECT * FROM ##Temp_bsegment_DelinqDays

--SELECT * FROM #TempDDFromStatement WHERE acctId = 6745786
/*
DECLARE @Businessday VARCHAR(50) = '2021-10-31 23:59:57.000'
SELECT --*,
'UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = ' + TRY_CAST(NoPayDaysDelinquent AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard,
--'UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary,
'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = ' + TRY_CAST(NoPayDaysDelinquent AS VARCHAR) + ' WHERE BSacctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_AccountInfoForReport,
'UPDATE StatementHeader SET NoPayDaysDelinquent = ' + TRY_CAST(NoPayDaysDelinquent AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_StatementHeader
FROM #Temp_bsegment_DelinqDays
--WHERE acctId NOT IN (9745940, 1147830)
WHERE NoPayDaysDelinquent > 0


--DECLARE @Businessday VARCHAR(50) = '2021-10-31 23:59:57.000'
SELECT --*,
'UPDATE TOP(1) BSegmentCreditCard SET DateOfOriginalPaymentDueDTD = ''' + TRY_CONVERT(VARCHAR, DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH, 1 - CycleDueDTD, DateOfOriginalPaymentDueDTD)) AS DATETIME)), 20)+ ''', NoPayDaysDelinquent = ' + TRY_CAST(DATEDIFF(DAY, DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH, 1 - CycleDueDTD, DateOfOriginalPaymentDueDTD)) AS DATETIME)), DeAcctActivityDate) + 1 AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard--,
--'UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary,
--'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = ' + TRY_CAST(NoPayDaysDelinquent AS VARCHAR) + ' WHERE BSacctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_AccountInfoForReport--,
--'UPDATE StatementHeader SET ManualInitialChargeOffReason = ''' + RTRIM(ManualInitialChargeOffReason) + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @LastStatementDateVARCHAR + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_StatementHeader
FROM #Temp_bsegment_DelinqDays
--WHERE acctId NOT IN (9745940, 1147830)
WHERE NoPayDaysDelinquent <= 0
*/
--SELECT DATEDIFF(DAY, DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH, 1 - CycleDueDTD, DateOfOriginalPaymentDueDTD)) AS DATETIME)), DeAcctActivityDate) + 1,
--DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH, 1 - CycleDueDTD, DateOfOriginalPaymentDueDTD)) AS DATETIME)),  *
--FROM #Temp_bsegment_DelinqDays
--WHERE NoPayDaysDelinquent <= 0

--DATEADD(SECOND, 86397, CAST(EOMONTH(DATEADD(MONTH, 1 - CycleDueDTD, DateOfOriginalPaymentDueDTD)) AS DATETIME))




--SELECT ActualDRPStartDate, CCInhParent125AID, LastStatementDate, ISNULL(DATEDIFF(DAY, LastStatementDate, ActualDRPStartDate), 0) AS DD
--FROM StatementHeader SH WITH (NOLOCK)
--WHERE acctId = 1680697
----AND CAST(StatementDate AS DATE) > '2020-03-31 00:00:00.000'
--AND CCInhParent125AID IN (15996, 16000)

--;WITH StatementData
--AS
--(
--	SELECT 
--		ActualDRPStartDate, StatementDate, CCInhParent125AID, LastStatementDate, ISNULL(DATEDIFF(DAY, ActualDRPStartDate, StatementDate), 0) AS DD1, 
--		ISNULL(DATEDIFF(DAY, LastStatementDate, StatementDate), 0) AS DD
--	FROM StatementHeader SH WITH (NOLOCK)
--	WHERE acctId = 2864111
--	AND StatementDate > '2021-02-28 23:59:57.000'
--	AND CCInhParent125AID IN (15996, 16000)
--)
--SELECT 2864111, ISNULL(SUM(DD), 0) AS TDD
--FROM StatementData


--DECLARE @Businessday VARCHAR(50) = '2021-02-01 23:59:57.000'
--SELECT --*,
--'UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ', DateOfOriginalPaymentDueDTD = ''2021-01-31'' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegmentCreditCard,
----'UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR) UPDATE_BSegment_Primary,
--'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ', DateOfOriginalPaymentDueDTD = ''2021-01-31'' WHERE BSacctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_AccountInfoForReport--,
----'UPDATE StatementHeader SET ManualInitialChargeOffReason = ''' + RTRIM(ManualInitialChargeOffReason) + ''' WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)  + ' AND BusinessDay = ''' + @LastStatementDateVARCHAR + '''   -- AccountID: ' + TRY_CAST(acctId AS VARCHAR) UPDATE_StatementHeader
--FROM #Temp_bsegment_DelinqDays
----WHERE acctId NOT IN (9745940, 1147830)
--WHERE NoPayDaysDelinquent <= 0


/*

select TotalDaysDelinquent,daysdelinquent,* from AccountInfoForReport WHERE BSacctId = 1035017 AND BusinessDay = '2021-11-01 23:59:57.000'   -- AccountID: 277948
select TotalDaysDelinquent,daysdelinquent,* from AccountInfoForReport WHERE BSacctId = 1035017 AND BusinessDay = '2021-10-31 23:59:57.000' 
select daysdelinquent,* from statementheaderex with(nolock) where acctId = 1035017 AND statementdate = '2021-10-31 23:59:57.000' 
SELECT TotalDaysDelinquent,bp.NoPayDaysDelinquent,bd.NoPayDaysDelinquent,bp.daysdelinquent,bd.daysdelinquent,bp.DtOfLastDelinqCTD,bd.DtOfLastDelinqCTD,bd.NoPayDaysDelinquent,
bp.DateOfOriginalPaymentDueDTD,bd.DateOfOriginalPaymentDueDTD,* 

FROM #Temp_bsegment_DelinqDays bd  join BsegmentCreditCard bp on bd.acctid=bp.acctid 
 join AccountInfoForReport ar on ar.BSacctId=bp.acctid and ar.BusinessDay='2021-10-31 23:59:57.000'where bd.NoPayDaysDelinquent>0 --and daysdelinquent=NoPayDaysDelinquent
and  bp.acctid in (277948,1035017,1140904,1156616,1992621,2080569,2116841,2215724,2639620,4853815,4909611,4913824,6408687,7895161,7909910,
10234517,10890281,11862323,13543464,13947697,15945625,17323865,17743380,17996163)
--\\10.42.2.73\Common\Prasoon\Statement_10312021\CMF\StatementFix

*/