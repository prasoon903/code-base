/*
1. DisputeAmount = 0 remove
2. Update ClearingDate by  TRANSACTION_DATE where ClearingDate is null --not required
3. UPdate PCDate with Getdate where it is null
4. Use Disputeamount instead of TransactionAmount

1. Clearing date and PC date falls in same cycle -- Check if PC amount is less than the dispute amount then PC date extends to current date
2. SRB -- SRB-DisputeAmt < AD then Diff amount

*/

DROP TABLE IF EXISTS #TempAllRecords
SELECT DISTINCT * INTO #TempAllRecords FROM ##TempRawData 

--SELECT COUNT(1) FROM ##TempRawData
--SELECT COUNT(1) FROM #TempAllRecords

--SELECT * FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0
--SELECT * FROM #TempAllRecords WHERE TRANSACTIONDATE =  '1900-01-01 00:00:00.000' OR TRANSACTIONDATE IS NULL
--SELECT * FROM #TempAllRecords WHERE ClearingDate =  '1900-01-01 00:00:00.000' OR ClearingDate IS NULL
--SELECT * FROM #TempAllRecords WHERE PCDate =  '1900-01-01 00:00:00.000' OR PCDate IS NULL

--1.
DROP TABLE IF EXISTS #NoDisputeAmount
SELECT * INTO #NoDisputeAmount FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0

DELETE FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0

--3. 
UPDATE #TempAllRecords SET PCDate = GETDATE() WHERE PCDate = '1900-01-01 00:00:00.000' OR PCDate IS NULL

--SELECT * FROM #TempAllRecords

--1. Clearing date and PC date falls in same cycle -- Check if PC amount is less than the dispute amount then PC date extends to current date
;WITH CTE
AS
(
SELECT *, DisputeAmount-PCAmount Delta,
DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, ClearingDate))))  ClearingLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, ClearingDate))))  ClearingNextStatement,
DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, PCDate))))  PCLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, PCDate))))  PCNextStatement
FROM #TempAllRecords
--WHERE Account_UUID IN ('eecceb66-b93b-498a-af20-180957a0d3cf')
)
--DELETE T
--SELECT C.Delta, T.*
UPDATE T
--SET DisputeAmount = C.Delta, PCDate = CASE WHEN C.Delta > 0 THEN GETDATE() ELSE T.PCDate END
SET PCDate = GETDATE()
FROM #TempAllRecords T
JOIN CTE  C ON (T.DisputeID = C.DisputeID)
WHERE ClearingLastStatement = PCLastStatement
AND C.Delta > 0

DELETE FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0


DROP TABLE IF EXISTS #TempRecords
;WITH CTE
AS
(
SELECT *, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, ClearingDate))))  ClearingLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, ClearingDate))))  ClearingNextStatement,
DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, PCDate))))  PCLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, PCDate))))  PCNextStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 1, PCDate))))  PCExtraStatement
FROM #TempAllRecords
--WHERE Account_UUID IN ('d6a2d800-a4ba-4973-a8a2-9544259ad690')
), Disputes
AS
(
SELECT AccountUUID, ClearingLastStatement, PCNextStatement, PCExtraStatement, MIN(ClearingDate) MinTxnDate, SUM(ISNULL(DisputeAmount, 0)) TransactionAmount
FROM CTE C
GROUP BY AccountUUID, ClearingLastStatement, PCNextStatement, PCExtraStatement
)
SELECT BP.acctID, ROW_NUMBER() OVER(PARTITION BY BP.acctID ORDER BY ClearingLastStatement) RN, RTRIM(BP.AccountNumber) AccountNumber, CreatedTime, SystemStatus, D.*
INTO #TempRecords
FROM Disputes D
JOIN BSegment_Primary BP WITH (NOLOCK) ON (D.AccountUUID = BP.universalUniqueID)

--SELECT * FROM #TempRecords WHERE AccountUUID = '0b15185d-6903-42e9-9a60-e2a64f69ee20'

--SELECT * FROM #TempRecords WHERE acctID = 200783
--SELECT * FROM #TempAllRecords WHERE Account_UUID = '0b15185d-6903-42e9-9a60-e2a64f69ee20'


;WITH CTE
AS
(
SELECT AccountNumber, ClearingLastStatement, MIN(MinTxnDate)  MinTxnDate
FROM #TempRecords
GROUP BY AccountNumber, ClearingLastStatement
)
UPDATE T
SET MinTxnDate = CASE WHEN C.MinTxnDate > T.ClearingLastStatement THEN C.MinTxnDate ELSE T.ClearingLastStatement END
FROM #TempRecords T
JOIN CTE C ON (T.AccountNumber = C.AccountNumber AND T.ClearingLastStatement = C.ClearingLastStatement)

DROP TABLE IF EXISTS #StatementData
;WITH CTE
AS
(
SELECT acctID, MIN(ClearingLastStatement)  ClearingLastStatement, MAX(PCNextStatement) PCNextStatement, MAX(PCExtraStatement) PCExtraStatement
FROM #TempRecords
--WHERE acctID = 504312
GROUP BY acctID
)
SELECT ROW_NUMBER() OVER(PARTITION BY C.acctID ORDER BY StatementDate) RN, C.*, StatementDate, COALESCE(LastStatementDate, DateAcctOpened) LastStatementDate, 
APR, TRY_CAST(0 AS MONEY) InterestAtCycle, Currentbalance+CurrentBalanceCO CurrentBalance, SRBWithInstallmentDue,
CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, AmountOfPaymentsCTD, TRY_CAST(0 AS MONEY) AmountOfInterestCTD
INTO #StatementData
FROM CTE C
JOIN StatementHeader SH WITH (NOLOCK) ON (SH.acctid = C.acctID)
--WHERE SH.StatementDate BETWEEN C.ClearingLastStatement AND C.PCNextStatement
WHERE SH.StatementDate BETWEEN C.ClearingLastStatement AND C.PCExtraStatement

--SELECT * FROM #StatementData WHERE acctID = 504312
--SELECT * FROM #TempRecords WHERE acctID = 47073

DROP TABLE IF EXISTS #TempInt1
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, S.LastStatementDate, --T.TransactionAmount, 
CASE WHEN T.MinTxnDate >= S.StatementDate THEN T.TransactionAmount ELSE 0 END TransactionAmount,
CASE WHEN MinTxnDate > S.LastStatementDate THEN MinTxnDate ELSE S.LastStatementDate END  MinTxnDate,
CASE WHEN YEAR(S.StatementDate) IN (2020, 2024) THEN 366 ELSE 365 END YearBase
FROM #StatementData S
JOIN #TempRecords T ON (T.acctID = S.acctID)
WHERE S.StatementDate >= T.ClearingLastStatement
--AND S.acctID = 504312
),
TxnData
AS
(
SELECT acctID, StatementDate, LastStatementDate, 
CASE WHEN MinTxnDate > LastStatementDate THEN MinTxnDate ELSE LastStatementDate END MinTxnDate, 
YearBase,
SUM(CASE WHEN MinTxnDate >= StatementDate THEN TransactionAmount ELSE 0 END) OVER(PARTITION BY acctID ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) TransactionAmount,
ROW_NUMBER() OVER(PARTITION BY acctID, StatementDate ORDER BY StatementDate DESC) RN
FROM CTE
)
SELECT acctID, StatementDate, LastStatementDate, MinTxnDate, YearBase, TransactionAmount
INTO #TempInt1
FROM TxnData
WHERE RN = 1


--SELECT * FROM #TempInt1 WHERE acctID = 504312
--SELECT * FROM #TempInterest WHERE acctID = 504312
DROP TABLE IF EXISTS #TempInterest
;WITH CTE
AS
(
SELECT acctID, StatementDate, LastStatementDate, MIN(MinTxnDate) MinTxnDate, MIN(YearBase) YearBase, TransactionAmount, 
ROW_NUMBER() OVER(PARTITION BY acctID ORDER BY StatementDate) RN
FROM #TempInt1
WHERE StatementDate > MinTxnDate
GROUP BY acctID, StatementDate, LastStatementDate, TransactionAmount
),
GetAPR
AS
(
SELECT SH.parent02AID, SH.StatementDate, MAX(ISNULL(APR, 0)) APR, SUM(ISNULL(InterestAtCycle, 0)) InterestAtCycle
FROM CTE A
JOIN SummaryHeader SH WITH (NOLOCK) ON (A.acctID = SH.parent02AID AND A.StatementDate = SH.StatementDate)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate)
WHERE SH.CreditPlanType = '0'
GROUP BY SH.parent02AID, SH.StatementDate
)
SELECT ROW_NUMBER() OVER(PARTITION BY A.acctID ORDER BY A.StatementDate) IntCount, A.*, InterestAtCycle, G.APR, 
DATEDIFF(DAY, CASE WHEN RN = 1 THEN MinTxnDate ELSE A.LastStatementDate END, A.StatementDate)+CASE WHEN RN = 1 THEN 1 ELSE 0 END DaysInCycle,
TRY_CAST(0 AS MONEY) CalcInterest
INTO #TempInterest
FROM GetAPR G
JOIN CTE A ON (A.acctID = G.parent02AID AND A.StatementDate = G.StatementDate)


--SELECT * FROM #TempInterest WHERE acctID = 200783 ORDER BY StatementDate

;WITH CTE
AS
(
SELECT * ,
ROUND((TransactionAmount * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) * 
(ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - TransactionAmount),2) IntAmount
FROM #TempInterest
--WHERE acctID = 47073
)
UPDATE T
SET CalcInterest = CASE WHEN C.IntAmount <= T.InterestAtCycle THEN C.IntAmount ELSE T.InterestAtCycle END
FROM #TempInterest T
JOIN CTE C ON (T.acctID = C.acctID AND T.StatementDate = C.StatementDate)
AND T.IntCount = 1


DROP TABLE IF EXISTS ##TempIntJobs
CREATE TABLE ##TempIntJobs (JobID DECIMAL(19, 0) IDENTITY(1,1), acctID INT, MaxRecords INT, JobsUpdated INT)

INSERT INTO ##TempIntJobs
SELECT acctID, MAX(IntCount) MaxRecords, TRY_CAST(0 AS INT) JobsUpdated
FROM #TempInterest
--WHERE acctID = 47073
GROUP BY acctID



DECLARE @MaxLoop INT = 0, @loopCount INT = 0

SELECT @MaxLoop = MAX(MaxRecords) FROM ##TempIntJobs
SET @loopCount = 0

WHILE(@MaxLoop > @loopCount)
BEGIN

	DROP TABLE IF EXISTS #TempIntTxn
	SELECT T1.acctID, T1.CalcInterest
	INTO #TempIntTxn
	FROM #TempInterest T1
	JOIN ##TempIntJobs T2 ON (T1.acctID = T2.acctID) 
	WHERE T1.IntCount =  @loopCount + 1


	UPDATE T1
		SET CalcInterest = CASE 
						WHEN 
						ROUND(((TransactionAmount+T2.CalcInterest) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.CalcInterest)),2) <= InterestAtCycle 
						THEN 
						ROUND(((TransactionAmount+T2.CalcInterest) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.CalcInterest)),2)
						ELSE
						InterestAtCycle
						END
	FROM #TempInterest T1 
	JOIN #TempIntTxn T2 ON (t1.acctID = T2.acctID)
	WHERE T1.IntCount =  @loopCount + 2
/*
	SELECT T1.*,
	ROUND(((T1.TransactionAmount+T2.CalcInterest) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) * (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (T1.TransactionAmount+T2.CalcInterest)),2)
	FROM #TempInterest T1 
	JOIN #TempIntTxn T2 ON (t1.acctID = T2.acctID)
	WHERE T1.IntCount =  0 + 2
*/

	SET @loopCount = @loopCount + 1
END



UPDATE S
SET AmountOfInterestCTD = T.CalcInterest, APR = T.APR, InterestAtCycle = T.InterestAtCycle
FROM #StatementData S
JOIN #TempInterest T ON (T.acctID = S.acctID AND T.StatementDate = S.StatementDate)
--WHERE S.acctID = 47073

--SELECT * FROM #StatementData WHERE acctID = 200783
--SELECT * FROM #TempInterest WHERE acctID = 200783 ORDeR BY StatementDate
--SELECT * FROM #TempInt1 WHERE acctID = 200783



DROP TABLE IF EXISTS #TempData
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, T.TransactionAmount --, *
FROM #StatementData S
JOIN #TempInt1 T ON (T.acctID = S.acctID)
WHERE S.StatementDate = T.StatementDate
--AND T.acctID = 200783
),
Amounts
AS
(
SELECT acctID, StatementDate, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount
FROM CTE 
GROUP BY acctID, StatementDate
)
SELECT S.*, A.TransactionAmount, ROUND(0.01*A.TransactionAmount+S.AmountOfInterestCTD, 2) TotalAmountToApply,
TRY_CAST(0 AS MONEY) AmountApplied, TRY_CAST(0 AS MONEY) AmountAppliedDueToSRB, 
CASE WHEN S.StatementDate < S.PCNextStatement THEN S.CurrentBalance-A.TransactionAmount-S.AmountOfInterestCTD ELSE S.CurrentBalance END CurrentBalance_Calc,
CASE WHEN S.StatementDate < S.PCNextStatement THEN S.SRBWithInstallmentDue-A.TransactionAmount-S.AmountOfInterestCTD ELSE S.SRBWithInstallmentDue END SRB_Calc
INTO #TempData
FROM #StatementData S
LEFT JOIN #StatementData S2 ON (S.acctID = S2.acctID AND S.StatementDate = S2.LastStatementDate)
JOIN Amounts A ON (S.acctID = A.acctID AND S.StatementDate = A.StatementDate)

UPDATE #TempData 
SET AmountAppliedDueToSRB = CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END,
TotalAmountToApply = TotalAmountToApply + CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END 
WHERE RN = 1
--AND StatementDate < PCNextStatement

--SELECT * FROM #TempData WHERE acctID = 200783
--SELECT * FROM #StatementData WHERE acctID = 200783

DROP TABLE IF EXISTS #TempDataProcessed
SELECT * INTO #TempDataProcessed FROM #TempData WHERE RN = 1 --AND acctID = 183150

--SELECT * FROM #TempDataProcessed WHERE acctID = 200783


DROP TABLE IF EXISTS ##TempJobs1
CREATE TABLE ##TempJobs1 (JobID DECIMAL(19, 0) IDENTITY(1,1), acctID INT, MaxRecords INT, JobsUpdated INT)

INSERT INTO ##TempJobs1
SELECT acctID, MAX(RN) MaxRecords, TRY_CAST(0 AS INT) JobsUpdated
FROM #TempData
--WHERE acctID = 183150
GROUP BY acctID

--SELECT * FROM ##TempJobs1

--DROP TABLE IF EXISTS #TempJobToProcess
--SELECT TOP 1 T1.*
--INTO #TempJobToProcess
--FROM #TempDataProcessed T1
--JOIN ##TempJobs T2 ON (T1.acctID = T2.acctID)
--WHERE T1.RN = T2.JobsUpdated+1

--SELECT *
--FROM #TempJobToProcess

SET NOCOUNT ON;

--SELECT MAX(MaxRecords) FROM ##TempJobs1



DECLARE @MaxLoopCount INT, @LoopCounter INT
SELECT @MaxLoopCount = MAX(MaxRecords) FROM ##TempJobs1
SET @LoopCounter = 0

WHILE(@MaxLoopCount > @LoopCounter)
BEGIN
	DROP TABLE IF EXISTS #TempJobToProcess
	SELECT T1.*
	INTO #TempJobToProcess
	FROM #TempDataProcessed T1
	JOIN ##TempJobs1 T2 ON (T1.acctID = T2.acctID)
	WHERE T1.RN = @LoopCounter+1

	DROP TABLE IF EXISTS #TempOriginalData
	SELECT * INTO #TempOriginalData FROM #TempJobToProcess

	UPDATE #TempJobToProcess SET 
	AmountOfPayment210DLate = CASE WHEN AmountOfPayment210DLate > TotalAmountToApply THEN AmountOfPayment210DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment210DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment210DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment180DLate = CASE WHEN AmountOfPayment180DLate > TotalAmountToApply THEN AmountOfPayment180DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment180DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment180DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment150DLate = CASE WHEN AmountOfPayment150DLate > TotalAmountToApply THEN AmountOfPayment150DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment150DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment150DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment120DLate = CASE WHEN AmountOfPayment120DLate > TotalAmountToApply THEN AmountOfPayment120DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment120DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment120DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment90DLate = CASE WHEN AmountOfPayment90DLate > TotalAmountToApply THEN AmountOfPayment90DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment90DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment90DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment60DLate = CASE WHEN AmountOfPayment60DLate > TotalAmountToApply THEN AmountOfPayment60DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment60DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment60DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmountOfPayment30DLate = CASE WHEN AmountOfPayment30DLate > TotalAmountToApply THEN AmountOfPayment30DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment30DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment30DLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmtOfPayXDLate = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN AmtOfPayXDLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayXDLate END  
	FROM #TempJobToProcess WHERE RN > 1
	UPDATE #TempJobToProcess SET 
	AmtOfPayCurrDue = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN AmtOfPayCurrDue - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayCurrDue END  
	FROM #TempJobToProcess WHERE RN > 1

	UPDATE #TempJobToProcess 
		SET --AmountApplied = TotalAmountToApply - @1PCTApply,
		AmountOfTotalDue = AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue,
		CycleDueDTD = 
		CASE	
			WHEN AmountOfPayment210DLate > 0 THEN 9
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > 0 THEN 8
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate > 0 THEN 7
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > 0 THEN 6
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > 0 THEN 5
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > 0 THEN 4
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > 0 THEN 3
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > 0 THEN 2
			WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > 0 THEN 1
		ELSE 0
		END
	WHERE RN > 1

	--UPDATE #TempJobToProcess SET
	--AmountAppliedDueToSRB = CASE WHEN CurrentBalance_Calc - AmountOfTotalDue < 0 THEN ABS(CurrentBalance_Calc - AmountOfTotalDue) ELSE 0 END, 
	--TotalAmountToApply = TotalAmountToApply + CASE WHEN CurrentBalance_Calc - AmountOfTotalDue < 0 THEN ABS(CurrentBalance_Calc - AmountOfTotalDue) ELSE 0 END

	INSERT INTO #TempDataProcessed
	SELECT T2.RN, T1.acctID, T1.ClearingLastStatement, T1.PCNextStatement, T1.PCExtraStatement, T2.StatementDate, T2.LastStatementDate, T2.APR, T2.InterestAtCycle, 
	T2.CurrentBalance, T2.SRBWithInstallmentDue,

	CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END, 

	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 2 THEN CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 3 THEN CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 4 THEN CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 5 THEN CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 6 THEN CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 7 THEN CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 8 THEN CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END+
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 9 THEN CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END,
	
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END,
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 2 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 2 THEN T2.AmtOfPayXDLate ELSE CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END END ELSE 0 END,	
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 3 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 3 THEN T2.AmountOfPayment30DLate ELSE CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END END ELSE 0 END,	 
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 4 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 4 THEN T2.AmountOfPayment60DLate ELSE CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END END ELSE 0 END,	   
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 5 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 5 THEN T2.AmountOfPayment90DLate ELSE CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END END ELSE 0 END,	  
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 6 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 6 THEN T2.AmountOfPayment120DLate ELSE CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END END ELSE 0 END,	 
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 7 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 7 THEN T2.AmountOfPayment150DLate ELSE CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END END ELSE 0 END,	 
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 8 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 8 THEN T2.AmountOfPayment180DLate ELSE CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END END ELSE 0 END,	  
	CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 9 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 9 THEN T2.AmountOfPayment210DLate ELSE CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END END ELSE 0 END,	 
	T2.AmountOfPaymentsCTD, T2.AmountOfInterestCTD, T2.TransactionAmount, T2.TotalAmountToApply, T2.AmountApplied, T2.AmountAppliedDueToSRB, T2.CurrentBalance_Calc, T2.SRB_Calc
	FROM #TempJobToProcess T1
	JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE #TempDataProcessed
	SET
		CycleDueDTD = 0, AmountOfTotalDue = 0,
		AmtOfPayCurrDue = 0,
		AmtOfPayXDLate = 0,
		AmountOfPayment30DLate = 0,
		AmountOfPayment60DLate = 0,
		AmountOfPayment90DLate = 0,
		AmountOfPayment120DLate = 0,
		AmountOfPayment150DLate = 0,
		AmountOfPayment180DLate = 0,
		AmountOfPayment210DLate = 0 
	WHERE SRB_Calc <= 0
	AND RN = @LoopCounter + 2

	UPDATE #TempDataProcessed 
	SET AmountAppliedDueToSRB = CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END,
	TotalAmountToApply = TotalAmountToApply + CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END 
	WHERE RN = @LoopCounter + 2

	--SELECT * FROM #TempDataProcessed WHERE RN = @LoopCounter + 1
	--SELECT * FROM #TempDataProcessed

	SET @LoopCounter = @LoopCounter + 1

END


/*
;WITH CTE
AS
(
SELECT DISTINCT T1.acctID
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
WHERE T1.CycleDueDTD > T2.CycleDueDTD
)
SELECT COUNT(1)
FROM CTE
*/

DROP TABLE IF EXISTS #AccountData
;WITH CTE
AS
(
SELECT AccountUUID, MIN(ClearingDate)  MinClearingDate, MAX(PCDate) MaxPCDate
FROM #TempAllRecords
GROUP BY AccountUUID
)
SELECT BP.acctID, RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, MinClearingDate, MaxPCDate
INTO #AccountData
FROM CTE C
JOIN BSegment_Primary BP WITH (NOLOCK) ON (C.AccountUUID = BP.UniversalUniqueID)


DROP TABLE IF EXISTS #ImpactedAccounts
;WITH CTE
AS
(
SELECT DISTINCT T1.acctID
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
WHERE T1.CycleDueDTD > T2.CycleDueDTD
AND T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement
)
SELECT BP.acctID, RTRIM(BP.AccountNumber) AccountNumber, AccountUUID, MinClearingDate, MaxPCDate
INTO #ImpactedAccounts
FROM CTE C
JOIN #AccountData BP WITH (NOLOCK) ON (BP.acctID = C.acctID)
--WHERE BP.acctID = 365059


DROP TABLE IF EXISTS #FinalImpacted_Summary
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD >= 3 AND T2.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END AmountOfInterestCTD, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB, 
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ
INTO #FinalImpacted_Summary
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #ImpactedAccounts I ON (T1.acctID = I.acctId)
--WHERE T1.RN > 1
ORDER BY T1.acctID, T1.RN
--12963

DROP TABLE IF EXISTS #FinalImpacted_All
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD >= 3 AND T2.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END AmountOfInterestCTD, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB, 
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ,
T1.AmountOfTotalDue AmountOfTotalDue_Original,T2.AmountOfTotalDue AmountOfTotalDue_Calc,
T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,
T1.AmtOfPayXDLate AmtOfPayXDLate_Original,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,
T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,
T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,
T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc
INTO #FinalImpacted_All
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #ImpactedAccounts I ON (T1.acctID = I.acctId)
--WHERE T1.RN > 1
--WHERE T1.acctID = 173595 
ORDER BY T1.acctID, T1.RN


DROP TABLE IF EXISTS #Final_AllAccounts
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD >= 3 AND T2.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END AmountOfInterestCTD, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB, 
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, T1.CycleDueDTD OriginalDQ, 
T2.CycleDueDTD CalculatedDQ,
T1.AmountOfTotalDue AmountOfTotalDue_Original,T2.AmountOfTotalDue AmountOfTotalDue_Calc,
T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,
T1.AmtOfPayXDLate AmtOfPayXDLate_Original,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,
T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,
T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,
T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc
INTO #Final_AllAccounts
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #AccountData I WITH (NOLOCK) ON (I.acctID = T2.acctID)
--WHERE T1.RN > 1
ORDER BY T1.acctID, T1.RN


/*
SELECT * FROM #FinalImpacted_Summary ORDER BY acctID, RecordNumber
SELECT * FROM #FinalImpacted_All ORDER BY acctID, RecordNumber
SELECT * FROM #Final_AllAccounts ORDER BY acctID, RecordNumber

SELECT * FROM #FinalImpacted_Summary WHERE acctID = 200783 ORDER BY acctID, RecordNumber
SELECT * FROM #FinalImpacted_All WHERE acctID = 21929358 ORDER BY acctID, RecordNumber
SELECT * FROM #Final_AllAccounts WHERE acctID = 21929358 ORDER BY acctID, RecordNumber

SELECT COUNT(1) FROM #Final_AllAccounts WHERE CurrentBalance < AmountOfTotalDue_Original
SELECT COUNT(1) FROM #FinalImpacted_All WHERE SRB_Calc+AmountAppliedDueToSRB < AmountOfTotalDue_Calc AND SRB_Calc > 0

SELECT TOP 100 * FROM #FinalImpacted_All WHERE SRB_Calc < AmountOfTotalDue_Calc AND SRB_Calc > 0


SELECT * FROM #TempRecords WHERE AccountUUID = '0b15185d-6903-42e9-9a60-e2a64f69ee20'

SELECT * FROM #TempInterest WHERE acctID = 504312
SELECT * FROM #TempDataProcessed WHERE acctID = 177823
SELECT * FROM #StatementData WHERE acctID = 200783

SELECT COUNT(1) ImpactedAccounts FROM #ImpactedAccounts
SELECT COUNT(1) ImpactedStatement FROM #FinalImpacted_All WHERE ImpactedStatement = 'YES'
SELECT COUNT(1) PHPImpactedStatement FROM #FinalImpacted_All WHERE PHPImpact = 'YES'

--0b15185d-6903-42e9-9a60-e2a64f69ee20

--DROP TABLE IF EXISTS #FinalImpacted_All
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
CASE WHEN T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.CycleDueDTD >= 3 AND T2.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, 
--I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCLastStatement PCNextStatement, 
CASE WHEN T1.RN > 1 THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.RN > 1 THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, T2.AmountOfInterestCTD, 
CASE WHEN T1.RN > 1 THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,  T2.AmountAppliedDueToSRB,
T1.RN StatementOrder, T1.StatementDate, T1.CurrentBalance, T1.AmountOfPaymentsCTD, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ,
--T1.AmountOfTotalDue AmountOfTotalDue_Original,
T2.AmountOfTotalDue AmountOfTotalDue_Calc,
--T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,
T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,
--T1.AmtOfPayXDLate AmtOfPayXDLate_Original,
T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,
--T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,
T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,
--T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,
T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,
--T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,
T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,
--T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,
T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,
--T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,
T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,
--T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,
T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,
--T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,
T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc
--INTO #FinalImpacted_All
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #AccountData I ON (T1.acctID = I.acctId)
WHERE T1.acctID = 183150 
ORDER BY T1.acctID, T1.RN


*/



