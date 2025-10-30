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
WHERE BP.acctId IN
(4328900, 2668665, 311347, 2665826, 2982434, 1203217, 2251046, 2993992, 1985770, 3478936, 1194961, 41792, 1377960, 2728589, 3517903, 4433519, 1211196, 1724494, 2740345, 6625265
, 1199731, 3865838, 2601154, 9231868, 307553, 1193105, 1220246, 1220699, 5628787, 2693535, 2543531, 513409, 374413, 2426911, 1110536, 2593267, 2009770, 2017975, 249745, 1876310, 4793103
, 6367718, 7426779, 11500294, 11536110, 2237791, 9853255, 1182158, 1221551, 213330, 10658547, 2093416, 4271607, 4124848, 11080434, 8837021, 2699157, 4953585, 1109098, 2832866, 8791646, 1985074
, 2998493, 2352857, 3499198, 1183620, 4359257, 1192303, 2508500, 1209167, 1211708, 1223362, 2927602, 2405796, 2942233, 2558871, 4253609, 424041, 5547996, 6458711, 1198517, 1054339, 2081058
, 1154453, 1217241, 1218043, 1754179, 10646582, 4125746, 1225339, 1108460, 2114584, 1201643, 4584629, 4342132, 1727823, 3630322, 4355601, 1883403, 1220792, 1222966, 1227009, 1840358, 389332
, 57796, 2734183, 1145945, 6833367, 2077707, 10270972, 1964624, 2059502, 1202653, 2391252, 2796538, 1183040, 10886424, 2715974, 3712506, 6051598, 5586635, 246699, 563820, 9045227, 2312209, 3629278
, 8181721, 4351747, 1194027, 8981018, 1845529, 2969427, 1705364, 4666370, 2190235, 4576984)


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

-- 136 rows