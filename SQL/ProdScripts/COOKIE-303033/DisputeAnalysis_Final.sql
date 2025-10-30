/*
1. DisputeAmount = 0 remove
2. Update ClearingDate by  TRANSACTION_DATE where ClearingDate is null --not required
3. UPdate PCDate with Getdate where it is null
4. Use Disputeamount instead of TransactionAmount

1. Clearing date and PC date falls in same cycle -- Check if PC amount is less than the dispute amount then PC date extends to current date
2. SRB -- SRB-DisputeAmt < AD then Diff amount

*/
--12714731

--SELECT * FROM #TempAllRecords WHERE AccountUUID = 'e3a9d4c8-fb7f-4144-a298-e577f92be767' ORDER BY ClearingDate

DROP TABLE IF EXISTS #TempAllRecords
SELECT DISTINCT * INTO #TempAllRecords FROM ##TempRawData 


--SELECT COUNT(1) FROM ##TempRawData
--SELECT COUNT(1) FROM #TempAllRecords

--SELECT * FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0
--SELECT * FROM #TempAllRecords WHERE TRANSACTIONDATE =  '1900-01-01 00:00:00.000' OR TRANSACTIONDATE IS NULL
--SELECT * FROM #TempAllRecords WHERE ClearingDate =  '1900-01-01 00:00:00.000' OR ClearingDate IS NULL
--SELECT * FROM ##TempRawData WHERE PCDate =  '1900-01-01 00:00:00.000' OR PCDate IS NULL

--451 records have disputeAmount = 0
--8416 records have PCDate is NULL
--8416 records have PCAmount is 0/NULL
--43 records have ClearingDate is NULL
--6 records have AccountUUID is NULL


--1.
DROP TABLE IF EXISTS #NoDisputeAmount
SELECT * INTO #NoDisputeAmount FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0

DELETE FROM #TempAllRecords WHERE ISNULL(DisputeAmount, 0) = 0

--2.

UPDATE #TempAllRecords SET ClearingDate = TransactionDate WHERE ClearingDate = '1900-01-01 00:00:00.000' OR ClearingDate IS NULL

--3. 
UPDATE #TempAllRecords SET PCDate = GETDATE() WHERE PCDate = '1900-01-01 00:00:00.000' OR PCDate IS NULL

--SELECT COUNT(1) FROM #TempAllRecords WHERE PCDate = '1900-01-01 00:00:00.000' OR PCDate IS NULL
--SELECT COUNT(1) FROM #TempAllRecords WHERE ClearingDate = '1900-01-01 00:00:00.000' OR ClearingDate IS NULL
--SELECT COUNT(1) FROM #TempAllRecords WHERE ISNULL(PCAmount, 0) = 0

--1. Clearing date and PC date falls in same cycle -- Check if PC amount is less than the dispute amount then PC date extends to current date
;WITH CTE
AS
(
SELECT *, DisputeAmount-ISNULL(PCAmount, 0) Delta,
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

--SELECT * FROM #TempRecords WHERE AccountUUID = 'e3a9d4c8-fb7f-4144-a298-e577f92be767'

--SELECT * FROM #TempRecords WHERE acctID = 12714731
--SELECT * FROM #TempAllRecords WHERE Account_UUID = '0b15185d-6903-42e9-9a60-e2a64f69ee20'

--SELECT * FROM #TempAllRecords WHERE AccountUUID IS NULL

--SELECT AccountNumber, ClearingLastStatement, MIN(MinTxnDate)  MinTxnDate
--FROM #TempRecords
--WHERE AccountNumber = '1100011124056825'
--GROUP BY AccountNumber, ClearingLastStatement

--SELECT * FROM #TempRecords WHERE AccountNumber = '1100011124056825'


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
--WHERE acctID = 1314514
GROUP BY acctID
)
SELECT ROW_NUMBER() OVER(PARTITION BY C.acctID ORDER BY StatementDate) RN, C.*, StatementDate, 
COALESCE(LastStatementDate, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, ClearingLastStatement))))) LastStatementDate, 
APR, TRY_CAST(0 AS MONEY) InterestAtCycle, Currentbalance+CurrentBalanceCO CurrentBalance, SRBWithInstallmentDue,
CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, AmountOfPaymentsCTD, TRY_CAST(0 AS MONEY) AmountOfInterestCTD,
ccinhparent125AID,Systemstatus,TRY_CAST(0 AS MONEY) TotalIntSum
INTO #StatementData
FROM CTE C
JOIN StatementHeader SH WITH (NOLOCK) ON (SH.acctid = C.acctID)
WHERE SH.StatementDate BETWEEN C.ClearingLastStatement AND C.PCNextStatement
--WHERE SH.StatementDate BETWEEN C.ClearingLastStatement AND C.PCExtraStatement
--AND C.acctID IN (2405264, 47073)


;WITH CTE
AS
(
SELECT *
FROM #StatementData
WHERE StatementDate <> ClearingLastStatement
AND RN = 1
)
INSERT INTO #StatementData
SELECT 0,acctID,ClearingLastStatement,PCNextStatement,PCExtraStatement,ClearingLastStatement,DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, ClearingLastStatement)))),
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0 
FROM CTE 

;WITH CTE
AS
(
	SELECT RN, acctID, StatementDate, ROW_NUMBER() OVER(PARTITION BY acctID ORDER BY StatementDate) NewRN FROM #StatementData
)
UPDATE S 
SET RN = newRN
FROM #StatementData S
JOIN CTE C ON (S.acctID = C.acctID AND S.StatementDate = C.StatementDate)



--SELECT * FROM #StatementData WHERE acctID = 20986331
--SELECT * FROM #TempRecords WHERE acctID = 20986331
--SELECT * FROM #TempInt1 WHERE acctID = 20986331
--2405264

--SELECT *
--FROM #StatementData S
--JOIN #TempRecords T ON (T.acctID = S.acctID)
--WHERE S.StatementDate >= T.ClearingLastStatement
--AND S.acctID = 20986331
--ORDER BY S.StatementDate



DROP TABLE IF EXISTS #TempInt1
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, S.LastStatementDate, --T.TransactionAmount, 
CASE WHEN T.MinTxnDate >= S.LastStatementDate AND T.MinTxnDate < S.StatementDate THEN T.TransactionAmount ELSE 0 END TransactionAmount,
CASE WHEN MinTxnDate > S.LastStatementDate AND T.MinTxnDate < S.StatementDate THEN MinTxnDate ELSE S.StatementDate END  MinTxnDate,
CASE WHEN YEAR(S.StatementDate) IN (2020, 2024) THEN 366 ELSE 365 END YearBase, T.ClearingLastStatement
FROM #StatementData S
JOIN #TempRecords T ON (T.acctID = S.acctID)
WHERE S.StatementDate >= T.ClearingLastStatement
--AND S.acctID = 20986331
--ORDER BY T.ClearingLastStatement
)
, Account AS
(
SELECT acctID, StatementDate, LastStatementDate, YearBase, ClearingLastStatement, 
MIN(MinTxnDate) MinTxnDate, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount
FROM CTE
GROUP BY acctID, StatementDate, LastStatementDate, YearBase, ClearingLastStatement
)
, Txns AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY acctID ORDER BY StatementDate)  TxnCount
FROM Account
WHERE TransactionAmount > 0
)
, AccountData AS
(
SELECT A.*, CASE WHEN A.TransactionAmount > 0 THEN TxnCount ELSE 0 END TxnCount
FROM Account A
LEFT JOIN Txns T ON (A.acctID = T.acctID AND A.StatementDate = T.StatementDate)
)
--SELECT * FROM AccountData
, TxnData AS
(
SELECT acctID, StatementDate, LastStatementDate, TxnCount,
--CASE WHEN MinTxnDate > StatementDate THEN MinTxnDate ELSE StatementDate END MinTxnDate, 
CASE WHEN TxnCount = 1 THEN MinTxnDate ELSE StatementDate END MinTxnDate, 
--MIN(CASE WHEN MinTxnDate > LastStatementDate THEN MinTxnDate ELSE StatementDate END) OVER(PARTITION BY acctID, StatementDate ORDER BY CASE WHEN MinTxnDate > StatementDate THEN MinTxnDate ELSE StatementDate END) MinTxnDate,
YearBase,
--SUM(CASE WHEN MinTxnDate >= LastStatementDate THEN TransactionAmount ELSE 0 END) OVER(PARTITION BY acctID ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) TransactionAmount,
SUM(TransactionAmount) OVER(PARTITION BY acctID ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) TransactionAmount,
ROW_NUMBER() OVER(PARTITION BY acctID, StatementDate ORDER BY TxnCount DESC, CASE WHEN TxnCount = 1 THEN MinTxnDate ELSE StatementDate END DESC) RN
FROM AccountData
)
SELECT acctID, StatementDate, LastStatementDate, MinTxnDate, YearBase, TransactionAmount
INTO #TempInt1
FROM TxnData
WHERE RN = 1


--SELECT * FROM #TempInt1 WHERE acctID = 1314514
--SELECT * FROM #TempInterest WHERE acctID = 1314514
DROP TABLE IF EXISTS #TempInterest
;WITH CTE
AS
(
SELECT acctID, StatementDate, LastStatementDate, MIN(MinTxnDate) MinTxnDate, MIN(YearBase) YearBase, TransactionAmount, 
ROW_NUMBER() OVER(PARTITION BY acctID ORDER BY StatementDate) RN
FROM #TempInt1
--WHERE StatementDate > MinTxnDate
--WHERE acctID = 20986331
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
DATEDIFF(DAY, CASE WHEN MinTxnDate < A.StatementDate THEN MinTxnDate ELSE A.LastStatementDate END, A.StatementDate)
+CASE WHEN MinTxnDate <> A.LastStatementDate AND MinTxnDate < A.StatementDate THEN 1 ELSE 0 END DaysInCycle,
TRY_CAST(0 AS MONEY) CalcInterest,TRY_CAST(0 AS MONEY) TotalIntSum
INTO #TempInterest
FROM GetAPR G
JOIN CTE A ON (A.acctID = G.parent02AID AND A.StatementDate = G.StatementDate)


--SELECT * FROM #TempInterest WHERE acctID = 1314514 ORDER BY StatementDate

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
SET CalcInterest = CASE WHEN C.IntAmount <= T.InterestAtCycle THEN C.IntAmount ELSE T.InterestAtCycle END,
TotalIntSum = CASE WHEN C.IntAmount <= T.InterestAtCycle THEN C.IntAmount ELSE T.InterestAtCycle END
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
	SELECT T1.acctID, T1.CalcInterest, T1.TotalIntSum
	INTO #TempIntTxn
	FROM #TempInterest T1
	JOIN ##TempIntJobs T2 ON (T1.acctID = T2.acctID) 
	WHERE T1.IntCount =  @loopCount + 1


	UPDATE T1
		SET CalcInterest = CASE 
						WHEN 
						ROUND(((TransactionAmount+T2.TotalIntSum) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.TotalIntSum)),2) <= InterestAtCycle 
						THEN 
						ROUND(((TransactionAmount+T2.TotalIntSum) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.TotalIntSum)),2)
						ELSE
						InterestAtCycle
						END,
		T1.TotalIntSum = T2.TotalIntSum + CASE 
						WHEN 
						ROUND(((TransactionAmount+T2.TotalIntSum) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.TotalIntSum)),2) <= InterestAtCycle 
						THEN 
						ROUND(((TransactionAmount+T2.TotalIntSum) * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - (TransactionAmount+T2.TotalIntSum)),2)
						ELSE
						InterestAtCycle
						END
	FROM #TempInterest T1 
	JOIN #TempIntTxn T2 ON (t1.acctID = T2.acctID)
	WHERE T1.IntCount =  @loopCount + 2

	--select * FROM #TempInterest T1  where t1.acctid = 20986331
	--JOIN #TempIntTxn T2 ON (t1.acctID = T2.acctID) where t1.acctid = 384538 
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
SET AmountOfInterestCTD = T.CalcInterest, APR = T.APR, InterestAtCycle = T.InterestAtCycle, S.TotalIntSum = T.TotalIntSum
FROM #StatementData S
JOIN #TempInterest T ON (T.acctID = S.acctID AND T.StatementDate = S.StatementDate)
--WHERE S.acctID = 47073

--SELECT * FROM #StatementData WHERE acctID = 20986331
--SELECT * FROM #TempInterest WHERE acctID = 20986331 ORDeR BY StatementDate
--SELECT * FROM #TempInt1 WHERE acctID = 20986331
--SELECT * 
--FROM #StatementData S
--JOIN #TempInterest T ON (T.acctID = S.acctID AND T.StatementDate = S.StatementDate)
--WHERE S.acctID = 20986331



DROP TABLE IF EXISTS #TempData
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, T.TransactionAmount --, *
FROM #StatementData S
JOIN #TempInt1 T ON (T.acctID = S.acctID)
WHERE S.StatementDate = T.StatementDate
--AND T.acctID = 831733
),
Amounts
AS
(
SELECT acctID, StatementDate, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount
FROM CTE 
GROUP BY acctID, StatementDate
)
SELECT DISTINCT S.*, A.TransactionAmount, 
--DD ROUND(0.01*A.TransactionAmount+S.AmountOfInterestCTD, 2) TotalAmountToApply,
ISNULL(S.AmountOfPaymentsCTD, 0) TotalAmountToApply,
--ISNULL(S2.AmountOfPaymentsCTD, 0) TotalAmountToApply,
TRY_CAST(0 AS MONEY) AmountApplied, TRY_CAST(0 AS MONEY) AmountAppliedDueToSRB, TRY_CAST(0 AS MONEY) AmountToAdjustWithDQ,
CASE WHEN S.StatementDate < S.PCNextStatement THEN S.CurrentBalance-A.TransactionAmount-S.TotalIntSum 
	 ELSE S.CurrentBalance END CurrentBalance_Calc,
--CASE WHEN S.StatementDate < S.PCNextStatement AND (S.CurrentBalance-A.TransactionAmount-S.AmountOfInterestCTD)<25 
--	 THEN (S.CurrentBalance-A.TransactionAmount-S.AmountOfInterestCTD)
--	 --WHEN (((S.CurrentBalance-A.TransactionAmount-S.AmountOfInterestCTD)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))<25 
--	 --THEN 25 
--	 --ELSE (((S.CurrentBalance-A.TransactionAmount-S.AmountOfInterestCTD)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))
--	 WHEN (((S.CurrentBalance-A.TransactionAmount-S.TotalIntSum)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))<25 
--	 THEN 25 
--	 ELSE (((S.CurrentBalance-A.TransactionAmount-S.TotalIntSum)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))
--	 END MiniDue_Calc,--DD
CASE 
	WHEN S.StatementDate < S.PCNextStatement
	THEN CASE 
			WHEN (((S.CurrentBalance-A.TransactionAmount-S.TotalIntSum)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))<25 THEN 25
			ELSE (((S.CurrentBalance-A.TransactionAmount-S.TotalIntSum)*0.01)+(S.InterestAtCycle-S.AmountOfInterestCTD))
			END
ELSE S.AmtOfPayCurrDue
END MiniDue_Calc,
CASE WHEN S.StatementDate < S.PCNextStatement THEN S.SRBWithInstallmentDue-A.TransactionAmount-S.TotalIntSum 
	ELSE S.SRBWithInstallmentDue END SRB_Calc
INTO #TempData
FROM #StatementData S
LEFT JOIN #StatementData S2 ON (S.acctID = S2.acctID AND S.StatementDate = S2.LastStatementDate)
JOIN Amounts A ON (S.acctID = A.acctID AND S.StatementDate = A.StatementDate)

/*
UPDATE #TempData 
SET AmountAppliedDueToSRB = CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END,
TotalAmountToApply = TotalAmountToApply + CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END 
WHERE RN = 1
*/

UPDATE #TempData 
SET MiniDue_Calc = 0
WHERE MiniDue_Calc < 0

--where acctid = 2702226
--SELECT * FROM #TempData WHERE acctID = 21929358
--SELECT * FROM #StatementData WHERE acctID = 200783

DROP TABLE IF EXISTS #TempDataProcessed
SELECT * INTO #TempDataProcessed FROM #TempData WHERE RN = 1 --AND acctID = 1113521


DROP TABLE IF EXISTS #ProcessedData
SELECT * INTO #ProcessedData FROM #TempData WHERE RN = 1 --AND acctID = 1113521

DROP TABLE IF EXISTS #TempCalculatedData
SELECT * INTO #TempCalculatedData FROM #TempData WHERE RN = 1

DROP TABLE IF EXISTS #TempProjectedData
SELECT * INTO #TempProjectedData FROM #TempData WHERE RN = 1


--SELECT * FROM #TempDataProcessed WHERE acctID = 200783


DROP TABLE IF EXISTS ##TempJobs1
CREATE TABLE ##TempJobs1 (JobID DECIMAL(19, 0) IDENTITY(1,1), acctID INT, MaxRecords INT, JobsUpdated INT)

INSERT INTO ##TempJobs1
SELECT acctID, MAX(RN) MaxRecords, TRY_CAST(0 AS INT) JobsUpdated
FROM #TempData
--WHERE acctID = 1113521
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
	
	INSERT INTO #TempCalculatedData
	SELECT * FROM #TempJobToProcess WHERE RN > 1

	--Select 'BEFORE PROCESSING',* from #TempCalculatedData WHERE RN = @LoopCounter+1

	--select	'before',*
	--FROM #TempDataProcessed T1
	--where t1.acctid = 2702226 order by acctid,statementdate
	--select 'Before',* from #TempJobToProcess where acctid = 21929358
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
	FROM #TempJobToProcess WHERE RN > 1 AND CycleDueDTD > 1
	UPDATE #TempJobToProcess SET 
	AmtOfPayXDLate = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN AmtOfPayXDLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayXDLate END  
	FROM #TempJobToProcess WHERE RN > 1 AND CycleDueDTD > 1
	--UPDATE #TempJobToProcess SET 
	--AmtOfPayCurrDue = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN AmtOfPayCurrDue - TotalAmountToApply ELSE 0 END ,
	--TotalAmountToApply = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayCurrDue END  
	--FROM #TempJobToProcess WHERE RN > 1 AND CycleDueDTD > 1
	--select * from #TempJobToProcess where acctid = 2702226 and rn = @LoopCounter

	--UPDATE T1
	--SET 
	--	AmtOfPayCurrDue = CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayCurrDue THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayCurrDue END,
	--	AmtOfPayXDLate = CASE WHEN T1.AmtOfPayXDLate < T2.AmtOfPayXDLate THEN T1.AmtOfPayXDLate ELSE T2.AmtOfPayXDLate END,
	--	AmountOfPayment30DLate = CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment30DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment30DLate END,
	--	AmountOfPayment60DLate = CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment60DLate END,
	--	AmountOfPayment90DLate = CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment90DLate END,
	--	AmountOfPayment120DLate = CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment120DLate END,
	--	AmountOfPayment150DLate = CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment150DLate END,
	--	AmountOfPayment180DLate = CASE WHEN T1.AmountOfPayment180DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate ELSE T2.AmountOfPayment180DLate END,
	--	AmountOfPayment210DLate = CASE WHEN T1.AmountOfPayment210DLate < T2.AmountOfPayment210DLate THEN T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment210DLate END
	--FROM #TempJobToProcess T1
	--JOIN #TempOriginalData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)


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



	--UPDATE T1
	--SET 
	--	AmtOfPayCurrDue				= T2.AmtOfPayCurrDue
	--	,AmtOfPayXDLate				= T2.AmtOfPayXDLate
	--	,AmountOfPayment30DLate		= T2.AmountOfPayment30DLate
	--	,AmountOfPayment60DLate		= T2.AmountOfPayment60DLate
	--	,AmountOfPayment90DLate		= T2.AmountOfPayment90DLate
	--	,AmountOfPayment120DLate	= T2.AmountOfPayment120DLate
	--	,AmountOfPayment150DLate	= T2.AmountOfPayment150DLate
	--	,AmountOfPayment180DLate	= T2.AmountOfPayment180DLate
	--	,AmountOfPayment210DLate	= T2.AmountOfPayment210DLate
	--	,CycleDueDTD				= T2.CycleDueDTD
	--FROM #TempDataProcessed T1
	--JOIN #TempJobToProcess T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)


	--UPDATE #TempJobToProcess 
	--SET MiniDue_Calc = CASE WHEN AmountOfTotalDue >= SRB_Calc THEN SRB_Calc - (AmountOfTotalDue - MiniDue_Calc) ELSE MiniDue_Calc END

	--UPDATE #TempJobToProcess SET
	--AmountAppliedDueToSRB = CASE WHEN CurrentBalance_Calc - AmountOfTotalDue < 0 THEN ABS(CurrentBalance_Calc - AmountOfTotalDue) ELSE 0 END, 
	--TotalAmountToApply = TotalAmountToApply + CASE WHEN CurrentBalance_Calc - AmountOfTotalDue < 0 THEN ABS(CurrentBalance_Calc - AmountOfTotalDue) ELSE 0 END

	--select  * from #TempJobToProcess where acctid = 2702226

	--select	t1.rn,t2.rn,t1.statementdate,t2.statementdate,t1.CycleDueDTD,t2.CycleDueDTD,t3.CycleDueDTD,T1.AmountOfTotalDue,T2.AmountOfTotalDue,t1.MiniDue_Calc,t2.MiniDue_Calc,t1.SRB_Calc,t2.SRB_Calc,t1.AmtOfPayCurrDue,
	--t2.AmtOfPayCurrDue,t1.AmtOfPayXDLate,t2.AmtOfPayXDLate,t1.AmountOfPayment30DLate,t2.AmountOfPayment30DLate
	--FROM #TempJobToProcess T1
	--JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
	--JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)
	--where t2.acctid = 21929358

	--INSERT INTO #ProcessedData
	--SELECT * FROM #TempJobToProcess WHERE RN > 1 --AND RN = @LoopCounter + 2

	--Select 'AFTER PROCESSING',* from #TempJobToProcess 

	

	--SELECT 'RAWDATA',*
	--FROM #TempJobToProcess T1
	--JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
	--JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)
	--WHERE T2.RN = 4



	DROP TABLE IF EXISTS #TempIntermediateData
	SELECT T1.*, --CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END NextDQ 
	CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END NextDQ,
	CASE WHEN  T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN 1 ELSE 0 END DQJump
	INTO #TempIntermediateData 
	FROM #TempJobToProcess T1
	JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	--SELECT * FROM #TempIntermediateData

	UPDATE T
	SET
		AmtOfPayCurrDue = CASE WHEN NextDQ > 1 THEN AmtOfPayCurrDue ELSE 0 END,
		AmtOfPayXDLate = CASE WHEN NextDQ > 2 THEN AmtOfPayXDLate ELSE 0 END,
		AmountOfPayment30DLate = CASE WHEN NextDQ > 3 THEN AmountOfPayment30DLate ELSE 0 END,
		AmountOfPayment60DLate = CASE WHEN NextDQ > 4 THEN AmountOfPayment60DLate ELSE 0 END,
		AmountOfPayment90DLate = CASE WHEN NextDQ > 5 THEN AmountOfPayment90DLate ELSE 0 END,
		AmountOfPayment120DLate = CASE WHEN NextDQ > 6 THEN AmountOfPayment120DLate ELSE 0 END,
		AmountOfPayment150DLate = CASE WHEN NextDQ > 7 THEN AmountOfPayment150DLate ELSE 0 END,
		AmountOfPayment180DLate = CASE WHEN NextDQ > 8 THEN AmountOfPayment180DLate ELSE 0 END,
		AmountOfPayment210DLate = CASE WHEN NextDQ > 8 THEN AmountOfPayment210DLate ELSE 0 END
	FROM #TempIntermediateData T

	
	--SELECT * FROM #TempIntermediateData

	--SELECT * FROM #TempJobToProcess
	
	;WITH CTE
	AS
	(
		SELECT T2.*, 
		T1.AmtOfPayCurrDue-T2.AmtOfPayCurrDue CD_Delta,
		T1.AmtOfPayXDLate-T2.AmtOfPayXDLate PD_Delta,
		T1.AmountOfPayment30DLate-T2.AmountOfPayment30DLate CPD1_Delta,
		T1.AmountOfPayment60DLate-T2.AmountOfPayment60DLate CPD2_Delta,
		T1.AmountOfPayment90DLate-T2.AmountOfPayment90DLate CPD3_Delta,
		T1.AmountOfPayment120DLate-T2.AmountOfPayment120DLate CPD4_Delta,
		T1.AmountOfPayment150DLate-T2.AmountOfPayment150DLate CPD5_Delta,
		T1.AmountOfPayment180DLate-T2.AmountOfPayment180DLate CPD6_Delta,
		T1.AmountOfPayment210DLate-T2.AmountOfPayment210DLate CPD7_Delta
		FROM #TempJobToProcess T1
		JOIN #TempIntermediateData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	)
	UPDATE T 
	SET AmountToAdjustWithDQ = CD_Delta+PD_Delta+CPD1_Delta+CPD2_Delta+CPD3_Delta+CPD4_Delta+CPD5_Delta+CPD6_Delta+CPD7_Delta
	FROM #TempIntermediateData T
	JOIN CTE C ON (T.acctID = C.acctID AND T.RN = C.RN)
	
	
	--select 'AFTER PROCESSING',* from #TempJobToProcess 
	--SELECT 'Next Data', * FROM #TempData WHERE RN = @LoopCounter + 2

	INSERT INTO #TempDataProcessed
	SELECT T2.RN, T1.acctID, T1.ClearingLastStatement, T1.PCNextStatement, T1.PCExtraStatement, T2.StatementDate, T2.LastStatementDate
	, T2.APR, T2.InterestAtCycle, 
	T2.CurrentBalance, T2.SRBWithInstallmentDue,

	--CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END, 
	NextDQ,

	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END+
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN CASE WHEN T2.SRB_Calc > 0 AND (T2.MiniDue_Calc+T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate) >= T2.SRB_Calc THEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) ELSE T2.MiniDue_Calc END ELSE 0 END+
	CASE	WHEN NextDQ >= 1 
			THEN 
				CASE	WHEN T2.RN = 2 AND T2.SRB_Calc > 0 AND (T2.MiniDue_Calc+T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate) >= T2.SRB_Calc 
						THEN 
							CASE	WHEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > 0 AND (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) <= T2.AmtOfPayCurrDue
									THEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) 
									WHEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > 0 AND (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > T2.AmtOfPayCurrDue
									THEN T2.AmtOfPayCurrDue
									ELSE 0 
							END
						WHEN T2.RN > 2 AND T2.SRB_Calc > 0 AND (T2.MiniDue_Calc+T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate+T1.AmtOfPayCurrDue) >= T2.SRB_Calc 
						THEN 
							CASE	WHEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 ) > 0 
										 AND 
										 (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
									      ) <= T2.AmtOfPayCurrDue
									THEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 )
									WHEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 ) > 0 
										 AND 
										 (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
									      ) > T2.AmtOfPayCurrDue
									THEN T2.AmtOfPayCurrDue
									ELSE 0 
							END
						ELSE 
							CASE	WHEN T2.MiniDue_Calc < T2.AmtOfPayCurrDue
									THEN T2.MiniDue_Calc
									ELSE T2.AmtOfPayCurrDue
							END						
				END 
			ELSE 0 
	END+
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.MiniDue_Calc ELSE 0 END+
	CASE WHEN NextDQ >= 2 THEN CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END ELSE 0 END+
	CASE WHEN NextDQ >= 3 THEN CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 4 THEN CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 5 THEN CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 6 THEN CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 7 THEN CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 8 THEN CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END+
	CASE WHEN NextDQ >= 9 THEN CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END,
	
	--DD CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END,
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN CASE WHEN (T1.MiniDue_Calc+T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) >= T1.SRB_Calc THEN (T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate)) ELSE T2.MiniDue_Calc END ELSE 0 END,
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN CASE WHEN (T2.MiniDue_Calc+T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate) >= T2.SRB_Calc THEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) ELSE T2.MiniDue_Calc END ELSE 0 END,
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN CASE WHEN T2.AmountOfTotalDue >= T2.SRB_Calc THEN (T2.SRB_Calc - (T2.AmountOfTotalDue - T2.MiniDue_Calc)) ELSE T2.MiniDue_Calc END ELSE 0 END,
	--CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 AND T2.CycleDueDTD - T3.CycleDueDTD <= 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.MiniDue_Calc ELSE 0 END,
	CASE	WHEN NextDQ >= 1 
			THEN 
				CASE	WHEN T2.RN = 2 AND T2.SRB_Calc > 0 AND (T2.MiniDue_Calc+T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate) >= T2.SRB_Calc 
						THEN 
							CASE	WHEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > 0 AND (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) <= T2.AmtOfPayCurrDue
									THEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) 
									WHEN (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > 0 AND (T2.SRB_Calc - (T2.AmountOfPayment210DLate+T2.AmountOfPayment180DLate+T2.AmountOfPayment150DLate+T2.AmountOfPayment120DLate+T2.AmountOfPayment90DLate+T2.AmountOfPayment60DLate+T2.AmountOfPayment30DLate+T2.AmtOfPayXDLate)) > T2.AmtOfPayCurrDue
									THEN T2.AmtOfPayCurrDue
									ELSE 0 
							END
						WHEN T2.RN > 2 AND T2.SRB_Calc > 0 AND (T2.MiniDue_Calc+T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate+T1.AmtOfPayCurrDue) >= T2.SRB_Calc 
						THEN 
							CASE	WHEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 ) > 0 
										 AND 
										 (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
									      ) <= T2.AmtOfPayCurrDue
									THEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 )
									WHEN (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
										 ) > 0 
										 AND 
										 (T2.SRB_Calc - (
															CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END
															+CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END
															+CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END
															+CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END
															+CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END
															+CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END
															+CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END
														)
									      ) > T2.AmtOfPayCurrDue
									THEN T2.AmtOfPayCurrDue
									ELSE 0 
							END
						ELSE 
							CASE	WHEN T2.MiniDue_Calc < T2.AmtOfPayCurrDue
									THEN T2.MiniDue_Calc
									ELSE T2.AmtOfPayCurrDue
							END						
				END 
			ELSE 0 
	END,
	CASE WHEN NextDQ >= 2 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 2 THEN T2.AmtOfPayXDLate ELSE CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END END ELSE 0 END,	
	CASE WHEN NextDQ >= 3 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 3 THEN T2.AmountOfPayment30DLate ELSE CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END END ELSE 0 END,	 
	CASE WHEN NextDQ >= 4 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 4 THEN T2.AmountOfPayment60DLate ELSE CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END END ELSE 0 END,	   
	CASE WHEN NextDQ >= 5 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 5 THEN T2.AmountOfPayment90DLate ELSE CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END END ELSE 0 END,	  
	CASE WHEN NextDQ >= 6 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 6 THEN T2.AmountOfPayment120DLate ELSE CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END END ELSE 0 END,	 
	CASE WHEN NextDQ >= 7 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 7 THEN T2.AmountOfPayment150DLate ELSE CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END END ELSE 0 END,	 
	CASE WHEN NextDQ >= 8 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 8 THEN T2.AmountOfPayment180DLate ELSE CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END END ELSE 0 END,	  
	CASE WHEN NextDQ >= 9 THEN CASE WHEN T2.CycleDueDTD - T3.CycleDueDTD > 1 AND T2.CycleDueDTD = 9 THEN T2.AmountOfPayment210DLate ELSE CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END END ELSE 0 END,	 
	T2.AmountOfPaymentsCTD, T2.AmountOfInterestCTD, T2.ccinhparent125aid,T2.SystemStatus,T2.TotalIntSum,T2.TransactionAmount, 
	T2.TotalAmountToApply, --CASE WHEN T2.TotalAmountToApply - T1.AmountToAdjustWithDQ > 0 THEN T2.TotalAmountToApply - T1.AmountToAdjustWithDQ ELSE 0 END, 
	T2.AmountApplied,T2.AmountAppliedDueToSRB, T1.AmountToAdjustWithDQ, T2.CurrentBalance_Calc,T2.MiniDue_Calc, T2.SRB_Calc
	FROM #TempIntermediateData T1
	JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)
	--select * from #TempDataProcessed  where acctid = 384538

	--select 'TempIntermediateData', * from #TempIntermediateData  where RN = @LoopCounter + 1
	----select 'TempData', * from #TempData  where RN = @LoopCounter + 2
	--select 'New Data', * from #TempDataProcessed  where RN = @LoopCounter + 2

	INSERT INTO #ProcessedData
	SELECT * FROM #TempDataProcessed  where RN = @LoopCounter + 2 --AND RN = @LoopCounter + 2


	--UPDATE T1
	--SET AmtOfPayCurrDue = 
	--CASE 
	--	WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) > 0
	--	THEN
	--		CASE 
	--			WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) <= T2.AmtOfPayCurrDue
	--			THEN 
	--				CASE 
	--					WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) > T1.MiniDue_Calc
	--					THEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate)
	--				ELSE T1.MiniDue_Calc
	--				END
	--			ELSE T2.AmtOfPayCurrDue 
	--		END
	--	ELSE 0 
	--END
	--FROM #TempDataProcessed T1
	--JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	--WHERE T1.RN = @LoopCounter + 2
	--AND T1.RN > 2
	

	--select 'Original Data', * from #TempData  where RN = @LoopCounter + 2
	--select 'Updated Data', * from #TempDataProcessed  where RN = @LoopCounter + 2


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
		SET 
		AmountOfTotalDue = AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue
		WHERE RN =  @LoopCounter + 2
		
		
		--SELECT * FROM #TempData
	
	;WITH CTE
	AS
	(
		SELECT T1.*, 
		--T1.AmtOfPayCurrDue-T2.AmtOfPayCurrDue CD_Delta,
		ABS(T1.AmtOfPayXDLate-T2.AmtOfPayCurrDue) PD_Delta,
		ABS(T1.AmountOfPayment30DLate-T2.AmtOfPayXDLate) CPD1_Delta,
		ABS(T1.AmountOfPayment60DLate-T2.AmountOfPayment30DLate) CPD2_Delta,
		ABS(T1.AmountOfPayment90DLate-T2.AmountOfPayment60DLate) CPD3_Delta,
		ABS(T1.AmountOfPayment120DLate-T2.AmountOfPayment90DLate) CPD4_Delta,
		ABS(T1.AmountOfPayment150DLate-T2.AmountOfPayment120DLate) CPD5_Delta,
		ABS(T1.AmountOfPayment180DLate-T2.AmountOfPayment150DLate) CPD6_Delta,
		ABS(T1.AmountOfPayment210DLate-T2.AmountOfPayment180DLate) CPD7_Delta
		FROM #TempDataProcessed T1
		JOIN #TempIntermediateData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN+1)
	)
	UPDATE T 
	SET AmountToAdjustWithDQ = T.AmountToAdjustWithDQ+PD_Delta+CPD1_Delta+CPD2_Delta+CPD3_Delta+CPD4_Delta+CPD5_Delta+CPD6_Delta+CPD7_Delta,
	TotalAmountToApply = CASE WHEN T.TotalAmountToApply - (T.AmountToAdjustWithDQ+PD_Delta+CPD1_Delta+CPD2_Delta+CPD3_Delta+CPD4_Delta+CPD5_Delta+CPD6_Delta+CPD7_Delta) > 0 
	THEN T.TotalAmountToApply - (T.AmountToAdjustWithDQ+PD_Delta+CPD1_Delta+CPD2_Delta+CPD3_Delta+CPD4_Delta+CPD5_Delta+CPD6_Delta+CPD7_Delta)
	ELSE 0 END
	FROM #TempDataProcessed T
	JOIN CTE C ON (T.acctID = C.acctID AND T.RN = C.RN)

	

	--SELECT 'After AdjustWithDQ',* FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	
	DROP TABLE IF EXISTS #SRBImpact
	SELECT RN, acctID, StatementDate, SRB_Calc SRB, AmountOfTotalDue AD, AmountOfTotalDue-SRB_Calc Delta
	INTO #SRBImpact
	FROM #TempDataProcessed
	WHERE SRB_Calc > 0
	AND SRB_Calc < AmountOfTotalDue
	AND RN = @LoopCounter + 2
	--AND acctID = 1379191

	UPDATE T
	SET AmountAppliedDueToSRB = S.Delta
	, TotalAmountToApply = T.TotalAmountToApply + S.Delta
	FROM #TempDataProcessed T
	JOIN #SRBImpact S ON (T.acctID = S.acctID AND T.RN = S.RN)

	--SELECT * FROM #TempDataProcessed WHERE acctID = 1379191 AND RN = @LoopCounter + 2

	UPDATE #TempDataProcessed SET 
	AmountOfPayment210DLate = CASE WHEN AmountOfPayment210DLate > TotalAmountToApply THEN AmountOfPayment210DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment210DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment210DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment180DLate = CASE WHEN AmountOfPayment180DLate > TotalAmountToApply THEN AmountOfPayment180DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment180DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment180DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment150DLate = CASE WHEN AmountOfPayment150DLate > TotalAmountToApply THEN AmountOfPayment150DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment150DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment150DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment120DLate = CASE WHEN AmountOfPayment120DLate > TotalAmountToApply THEN AmountOfPayment120DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment120DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment120DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment90DLate = CASE WHEN AmountOfPayment90DLate > TotalAmountToApply THEN AmountOfPayment90DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment90DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment90DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment60DLate = CASE WHEN AmountOfPayment60DLate > TotalAmountToApply THEN AmountOfPayment60DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment60DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment60DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmountOfPayment30DLate = CASE WHEN AmountOfPayment30DLate > TotalAmountToApply THEN AmountOfPayment30DLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmountOfPayment30DLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmountOfPayment30DLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	UPDATE #TempDataProcessed SET 
	AmtOfPayXDLate = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN AmtOfPayXDLate - TotalAmountToApply ELSE 0 END ,
	TotalAmountToApply = CASE WHEN AmtOfPayXDLate > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayXDLate END  
	FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	--UPDATE #TempDataProcessed SET 
	--AmtOfPayCurrDue = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN AmtOfPayCurrDue - TotalAmountToApply ELSE 0 END ,
	--TotalAmountToApply = CASE WHEN AmtOfPayCurrDue > TotalAmountToApply THEN 0 ELSE TotalAmountToApply - AmtOfPayCurrDue END  
	--FROM #TempDataProcessed WHERE RN = @LoopCounter + 2

	--UPDATE T1
	--SET AmtOfPayCurrDue = 
	--CASE 
	--	WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) > 0
	--	THEN
	--		CASE 
	--			WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) <= T2.AmtOfPayCurrDue
	--			THEN 
	--				CASE 
	--					WHEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate) > T1.MiniDue_Calc
	--					THEN T1.SRB_Calc - (T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate)
	--				ELSE T1.MiniDue_Calc
	--				END
	--			ELSE T2.AmtOfPayCurrDue 
	--		END
	--	ELSE 0 
	--END
	--FROM #TempDataProcessed T1
	--JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	--WHERE T1.RN = @LoopCounter + 2

	UPDATE T 
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
	FROM #TempDataProcessed T
	WHERE T.RN  = @LoopCounter + 2

	
	--SELECT 'BEFORE', * FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	
	DROP TABLE IF EXISTS #SRBReApply
	SELECT T1.*, CASE WHEN T1.SRB_Calc > T1.AmountOfTotalDue THEN T1.SRB_Calc - T1.AmountOfTotalDue ELSE 0 END SRBDelta
	INTO #SRBReApply
	FROM #TempDataProcessed T1
	JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	WHERE T1.RN = @LoopCounter + 2
	--AND SRB_Calc > AmountOfTotalDue AND SRB_Calc < 25
	AND (T2.SRBWithInstallmentDue = T2.AmountOfTotalDue OR T1.AmountOfTotalDue < 25 OR T1.SRB_Calc - T1.AmountOfTotalDue < 1)

	--SELECT 'SRBReApply', * FROM #SRBReApply --WHERE acctID = 1379191
	
	UPDATE T2
	SET AmtOfPayCurrDue = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmtOfPayCurrDue < T3.AmtOfPayCurrDue AND SRBDelta <= T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue THEN T2.AmtOfPayCurrDue+SRBDelta
		WHEN SRBDelta > 0 AND T2.AmtOfPayCurrDue < T3.AmtOfPayCurrDue AND SRBDelta > T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue THEN T2.AmtOfPayCurrDue+(T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue)
	ELSE T2.AmtOfPayCurrDue
	END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmtOfPayCurrDue < T3.AmtOfPayCurrDue AND SRBDelta <= T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue THEN 0
		WHEN SRBDelta > 0 AND T2.AmtOfPayCurrDue < T3.AmtOfPayCurrDue AND SRBDelta > T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue THEN SRBDelta - (T3.AmtOfPayCurrDue-T2.AmtOfPayCurrDue)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmtOfPayXDLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmtOfPayXDLate < T3.AmtOfPayXDLate AND SRBDelta <= T3.AmtOfPayXDLate-T2.AmtOfPayXDLate THEN T2.SRBDelta+T2.AmtOfPayXDLate
		WHEN SRBDelta > 0 AND T2.AmtOfPayXDLate < T3.AmtOfPayXDLate AND SRBDelta > T3.AmtOfPayXDLate-T2.AmtOfPayXDLate THEN T2.AmtOfPayXDLate+(T3.AmtOfPayXDLate-T2.AmtOfPayXDLate)
	ELSE T2.AmtOfPayXDLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmtOfPayXDLate < T3.AmtOfPayXDLate AND SRBDelta <= T3.AmtOfPayXDLate-T2.AmtOfPayXDLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmtOfPayXDLate < T3.AmtOfPayXDLate AND SRBDelta > T3.AmtOfPayXDLate-T2.AmtOfPayXDLate THEN SRBDelta - (T3.AmtOfPayXDLate-T2.AmtOfPayXDLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment30DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment30DLate < T3.AmountOfPayment30DLate AND SRBDelta <= T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate THEN T2.SRBDelta+T2.AmountOfPayment30DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment30DLate < T3.AmountOfPayment30DLate AND SRBDelta > T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate THEN T2.AmountOfPayment30DLate+(T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate)
	ELSE T2.AmountOfPayment30DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment30DLate < T3.AmountOfPayment30DLate AND SRBDelta <= T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment30DLate < T3.AmountOfPayment30DLate AND SRBDelta > T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate THEN SRBDelta - (T3.AmountOfPayment30DLate-T2.AmountOfPayment30DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment60DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment60DLate < T3.AmountOfPayment60DLate AND SRBDelta <= T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate THEN T2.SRBDelta+T2.AmountOfPayment60DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment60DLate < T3.AmountOfPayment60DLate AND SRBDelta > T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate THEN T2.AmountOfPayment60DLate+(T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate)
	ELSE T2.AmountOfPayment60DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment60DLate < T3.AmountOfPayment60DLate AND SRBDelta <= T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment60DLate < T3.AmountOfPayment60DLate AND SRBDelta > T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate THEN SRBDelta - (T3.AmountOfPayment60DLate-T2.AmountOfPayment60DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment90DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment90DLate < T3.AmountOfPayment90DLate AND SRBDelta <= T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate THEN T2.SRBDelta+T2.AmountOfPayment90DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment90DLate < T3.AmountOfPayment90DLate AND SRBDelta > T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate THEN T2.AmountOfPayment90DLate+(T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate)
	ELSE T2.AmountOfPayment90DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment90DLate < T3.AmountOfPayment90DLate AND SRBDelta <= T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment90DLate < T3.AmountOfPayment90DLate AND SRBDelta > T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate THEN SRBDelta - (T3.AmountOfPayment90DLate-T2.AmountOfPayment90DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment120DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment120DLate < T3.AmountOfPayment120DLate AND SRBDelta <= T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate THEN T2.SRBDelta+T2.AmountOfPayment120DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment120DLate < T3.AmountOfPayment120DLate AND SRBDelta > T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate THEN T2.AmountOfPayment120DLate+(T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate)
	ELSE T2.AmountOfPayment120DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment120DLate < T3.AmountOfPayment120DLate AND SRBDelta <= T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment120DLate < T3.AmountOfPayment120DLate AND SRBDelta > T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate THEN SRBDelta - T3.AmountOfPayment120DLate-T2.AmountOfPayment120DLate
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment150DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment150DLate < T3.AmountOfPayment150DLate AND SRBDelta <= T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate THEN T2.SRBDelta+T2.AmountOfPayment150DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment150DLate < T3.AmountOfPayment150DLate AND SRBDelta > T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate THEN T2.AmountOfPayment150DLate+(T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate)
	ELSE T2.AmountOfPayment150DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment150DLate < T3.AmountOfPayment150DLate AND SRBDelta <= T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment150DLate < T3.AmountOfPayment150DLate AND SRBDelta > T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate THEN SRBDelta - (T3.AmountOfPayment150DLate-T2.AmountOfPayment150DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment180DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment180DLate < T3.AmountOfPayment180DLate AND SRBDelta <= T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate THEN T2.SRBDelta+T2.AmountOfPayment180DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment180DLate < T3.AmountOfPayment180DLate AND SRBDelta > T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate THEN T2.AmountOfPayment180DLate+(T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate)
	ELSE T2.AmountOfPayment180DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment180DLate < T3.AmountOfPayment180DLate AND SRBDelta <= T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment180DLate < T3.AmountOfPayment180DLate AND SRBDelta > T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate THEN SRBDelta - (T3.AmountOfPayment180DLate-T2.AmountOfPayment180DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T2
	SET AmountOfPayment210DLate = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment210DLate < T3.AmountOfPayment210DLate AND SRBDelta <= T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate THEN T2.SRBDelta+T2.AmountOfPayment210DLate
		WHEN SRBDelta > 0 AND T2.AmountOfPayment210DLate < T3.AmountOfPayment210DLate AND SRBDelta > T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate THEN T2.AmountOfPayment210DLate+(T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate)
	ELSE T2.AmountOfPayment210DLate END
	,SRBDelta = 
	CASE 
		WHEN SRBDelta > 0 AND T2.AmountOfPayment210DLate < T3.AmountOfPayment210DLate AND SRBDelta <= T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate THEN 0
		WHEN SRBDelta > 0 AND T2.AmountOfPayment210DLate < T3.AmountOfPayment210DLate AND SRBDelta > T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate THEN SRBDelta - (T3.AmountOfPayment210DLate-T2.AmountOfPayment210DLate)
	ELSE SRBDelta END
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
	JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN)

	UPDATE T1
	SET
		AmtOfPayCurrDue = T2.AmtOfPayCurrDue,
		AmtOfPayXDLate = T2.AmtOfPayXDLate,
		AmountOfPayment30DLate = T2.AmountOfPayment30DLate,
		AmountOfPayment60DLate = T2.AmountOfPayment60DLate,
		AmountOfPayment90DLate = T2.AmountOfPayment90DLate,
		AmountOfPayment120DLate = T2.AmountOfPayment120DLate,
		AmountOfPayment150DLate = T2.AmountOfPayment150DLate,
		AmountOfPayment180DLate = T2.AmountOfPayment180DLate,
		AmountOfPayment210DLate = T2.AmountOfPayment210DLate
	FROM #TempDataProcessed T1
	JOIN #SRBReApply T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)

	--SELECT 'AFTER', * FROM #TempDataProcessed WHERE RN = @LoopCounter + 2

	--SELECT 'Before AdjustWithDQ',* FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	
	
	
	--select * from #TempJobToProcess where acctid = 2702226 and rn = @LoopCounter
	UPDATE T 
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
	FROM #TempDataProcessed T
	WHERE T.RN  = @LoopCounter + 2

	
	--UPDATE #TempDataProcessed 
	--SET MiniDue_Calc = CASE WHEN AmountOfTotalDue >= SRB_Calc THEN SRB_Calc - (AmountOfTotalDue - MiniDue_Calc) ELSE MiniDue_Calc END
	--WHERE RN = @LoopCounter + 2


	/*
	UPDATE #TempDataProcessed 
	SET AmountAppliedDueToSRB = CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue ELSE CASE WHEN SRB_Calc < AmountOfTotalDue 
									 THEN AmountOfTotalDue - SRB_Calc ELSE 0 END END,
	TotalAmountToApply = TotalAmountToApply + CASE WHEN SRB_Calc < 0 THEN AmountOfTotalDue 
												   ELSE CASE WHEN SRB_Calc < AmountOfTotalDue THEN AmountOfTotalDue - SRB_Calc 
															 ELSE 0 END END 
	WHERE RN = @LoopCounter + 2
	*/

	--SELECT 'Final Data',* FROM #TempDataProcessed WHERE RN = @LoopCounter + 2
	--SELECT * FROM #TempDataProcessed

	INSERT INTO #TempProjectedData
	SELECT * FROM #TempDataProcessed WHERE RN = @LoopCounter + 2

	SET @LoopCounter = @LoopCounter + 1

END

--SELECT COUNT(1) FROM #TempData
--SELECT COUNT(1) FROM #TempDataProcessed
--SELECT COUNT(1) FROM #ProcessedData
--SELECT * FROM #TempDataProcessed


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

--SELECT * FROM #ImpactedAccounts

/*
DROP TABLE IF EXISTS #FinalImpacted_Summary
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T4.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD >= 3 AND T4.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END InterestCreditsCTD, 
T2.totalintsum,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountToAdjustWithDQ, 0) ELSE NULL END AmountToAdjustWithDQ, 
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance,T2.CurrentBalance_Calc, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, 
T1.CycleDueDTD OriginalDQ,
T2.CycleDueDTD CalculatedDQ,
T4.CycleDueDTD ProjectedDQ,
T1.AmountOfTotalDue AmountOfTotalDue_Original,T2.AmountOfTotalDue AmountOfTotalDue_Calc, T4.AmountOfTotalDue AmountOfTotalDue_Proj,
T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,T4.AmtOfPayCurrDue AmtOfPayCurrDue_Proj,
T1.AmtOfPayXDLate AmtOfPayXDLate_Original,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,T4.AmtOfPayXDLate AmtOfPayXDLate_Proj,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,T4.AmountOfPayment30DLate AmountOfPayment30DLate_Proj,
T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,T4.AmountOfPayment60DLate AmountOfPayment60DLate_Proj,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,T4.AmountOfPayment90DLate AmountOfPayment90DLate_Proj,
T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,T4.AmountOfPayment120DLate AmountOfPayment120DLate_Proj,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,T4.AmountOfPayment150DLate AmountOfPayment150DLate_Proj,
T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,T4.AmountOfPayment180DLate AmountOfPayment180DLate_Proj,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc,T4.AmountOfPayment210DLate AmountOfPayment210DLate_Proj,
T2.ccinhparent125aid ManualStatus,
T2.SystemStatus,
T2.MiniDue_Calc
INTO #FinalImpacted_Summary
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #ProcessedData T4 ON (T2.acctId = T4.acctID AND T4.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #AccountData I ON (T1.acctID = I.acctId)
--WHERE T1.RN > 1
--WHERE T1.acctID = 173595 
ORDER BY T1.acctID, T1.RN
--12963

DROP TABLE IF EXISTS #FinalImpacted_All
SELECT 
CASE WHEN T1.RN = 1 THEN 'BaseRecord' ELSE 'ImpactedRecords' END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T4.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD >= 3 AND T4.CycleDueDTD <= 2 THEN 'YES' ELSE 'NO' END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END InterestCreditsCTD, 
T2.totalintsum,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountToAdjustWithDQ, 0) ELSE NULL END AmountToAdjustWithDQ,  
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance,T2.CurrentBalance_Calc, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, 
T1.CycleDueDTD OriginalDQ,
T2.CycleDueDTD CalculatedDQ,
T4.CycleDueDTD ProjectedDQ,
T1.AmountOfTotalDue AmountOfTotalDue_Original,T2.AmountOfTotalDue AmountOfTotalDue_Calc, T4.AmountOfTotalDue AmountOfTotalDue_Proj,
T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,T4.AmtOfPayCurrDue AmtOfPayCurrDue_Proj,
T1.AmtOfPayXDLate AmtOfPayXDLate_Original,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,T4.AmtOfPayXDLate AmtOfPayXDLate_Proj,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,T4.AmountOfPayment30DLate AmountOfPayment30DLate_Proj,
T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,T4.AmountOfPayment60DLate AmountOfPayment60DLate_Proj,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,T4.AmountOfPayment90DLate AmountOfPayment90DLate_Proj,
T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,T4.AmountOfPayment120DLate AmountOfPayment120DLate_Proj,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,T4.AmountOfPayment150DLate AmountOfPayment150DLate_Proj,
T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,T4.AmountOfPayment180DLate AmountOfPayment180DLate_Proj,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc,T4.AmountOfPayment210DLate AmountOfPayment210DLate_Proj,
T2.ccinhparent125aid ManualStatus,
T2.SystemStatus,
T2.MiniDue_Calc
INTO #FinalImpacted_All
FROM #TempData T1
JOIN #TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #ProcessedData T4 ON (T2.acctId = T4.acctID AND T4.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
JOIN #AccountData I ON (T1.acctID = I.acctId)
--WHERE T1.RN > 1
--WHERE T1.acctID = 173595 
ORDER BY T1.acctID, T1.RN
*/
--select * from #TempData where acctid = 1368585 order by rn
--select * from #TempDataProcessed where acctid = 1368585 order by rn

DROP TABLE IF EXISTS #Final_AllAccounts
SELECT 
CASE WHEN T1.StatementDate > T1.ClearingLastStatement AND T1.StatementDate < T1.PCNextStatement THEN 'ImpactedRecords' 
WHEN T1.StatementDate = T1.ClearingLastStatement  THEN 'BaseRecord'
WHEN T1.StatementDate > MaxPCDate  THEN 'LastRecord'
ELSE NULL END RecordType,
ROW_NUMBER() OVER(PARTITION BY I.acctID ORDER BY T1.StatementDate) RecordNumber,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement AND T1.CycleDueDTD > T4.CycleDueDTD AND T1.StatementDate <= MaxPCDate THEN 'YES' ELSE 'NO' END ImpactedStatement,
CASE 
	WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement 
		AND T1.CycleDueDTD >= 3 
		--AND T4.CycleDueDTD < 3
		AND T4.CycleDueDTD < T1.CycleDueDTD 
		AND T1.StatementDate <= MaxPCDate 
		--AND (T2.AmountOfPaymentsCTD > 0 OR T2.SRB_Calc <= 0)
	THEN 'YES' 
	ELSE 'NO' 
END PHPImpact, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearingDate, I.MaxPCDate, T1.ClearingLastStatement, T1.PCNextStatement, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T1.TransactionAmount ELSE NULL END DisputeAmountOfCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.APR ELSE NULL END APR, 
T2.InterestAtCycle, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.AmountOfInterestCTD ELSE NULL END InterestCreditsCTD, 
T2.totalintsum,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.TotalAmountToApply, 0) ELSE NULL END AmountApplied,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountAppliedDueToSRB, 0) ELSE NULL END AmountAppliedDueToSRB,
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN ISNULL(T2.AmountToAdjustWithDQ, 0) ELSE NULL END AmountToAdjustWithDQ,  
--T1.RN StatementOrder, 
T1.StatementDate, T1.LastStatementDate ActualImpactedStatement, T1.CurrentBalance,T2.CurrentBalance_Calc, T1.SRBWithInstallmentDue SRB_Original, 
CASE WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement THEN T2.SRB_Calc ELSE NULL END SRB_Calc, 
T1.AmountOfPaymentsCTD, 
T1.CycleDueDTD OriginalDQ,
T2.CycleDueDTD CalculatedDQ,
T4.CycleDueDTD ProjectedDQ,
T1.AmountOfTotalDue AmountOfTotalDue_Original,T2.AmountOfTotalDue AmountOfTotalDue_Calc, T4.AmountOfTotalDue AmountOfTotalDue_Proj,
T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,T4.AmtOfPayCurrDue AmtOfPayCurrDue_Proj,
T1.AmtOfPayXDLate AmtOfPayXDLate_Original,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,T4.AmtOfPayXDLate AmtOfPayXDLate_Proj,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,T4.AmountOfPayment30DLate AmountOfPayment30DLate_Proj,
T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,T4.AmountOfPayment60DLate AmountOfPayment60DLate_Proj,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,T4.AmountOfPayment90DLate AmountOfPayment90DLate_Proj,
T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,T4.AmountOfPayment120DLate AmountOfPayment120DLate_Proj,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,T4.AmountOfPayment150DLate AmountOfPayment150DLate_Proj,
T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,T4.AmountOfPayment180DLate AmountOfPayment180DLate_Proj,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc,T4.AmountOfPayment210DLate AmountOfPayment210DLate_Proj,
T2.ccinhparent125aid ManualStatus,
T2.SystemStatus,
T2.MiniDue_Calc,
CASE 
	WHEN T1.StatementDate BETWEEN T1.ClearingLastStatement AND T1.PCNextStatement 
		AND T1.CycleDueDTD >= 3 
		--AND T4.CycleDueDTD < 3
		AND T4.CycleDueDTD < T1.CycleDueDTD 
		AND (T2.AmountOfPaymentsCTD > 0 OR T4.CycleDueDTD = 0 OR T4.SRB_Calc = T4.AmountOfTotalDue OR T5.CycleDueDTD = 0)
		AND T1.StatementDate <= MaxPCDate
		--AND (T2.AmountOfPaymentsCTD > 0 OR T2.SRB_Calc <= 0)
		--AND T2.SystemStatus <> 14 
		AND T2.ccinhparent125aid NOT IN (15996, 16000, 16326, 16330, 5202, 16010) 
	THEN 'YES' 
	ELSE 'NO' 
END PHPImpactWithStatusCheck,
T5.CycleDueDTD PrevProjDQ
INTO #Final_AllAccounts
FROM #TempData T1
JOIN #ProcessedData T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #TempDataProcessed T4 ON (T2.acctId = T4.acctID AND T4.RN = T2.RN)
LEFT JOIN #TempData T3 ON (T1.acctID = T3.acctID AND T1.RN = T3.RN+1)
LEFT JOIN #TempDataProcessed T5 ON (T1.acctID = T5.acctID AND T1.RN = T5.RN+1)
JOIN #AccountData I WITH (NOLOCK) ON (I.acctID = T2.acctID)
--WHERE T1.RN > 1
--WHERE T1.acctID = 1151924
ORDER BY T1.acctID, T1.RN

--SELECT 'Original', * FROM #TempData WHERE acctID = 304051 AND RN = 7 ORDER BY acctID, RN
--SELECT 'Calc', * FROM #TempDataProcessed WHERE acctID = 304051 ORDER BY acctID, RN
--SELECT 'Proj', * FROM #ProcessedData WHERE acctID = 304051  ORDER BY acctID, RN

--SELECT * FROM #Final_AllAccounts WHERE acctID = 2061059  ORDER BY acctID, RecordNumber

-- --where acctid in (21929358,1718413,1366254,1382259,384538,2702226)

DROP TABLE IF EXISTS ##Final_AllAccounts
SELECT * INTO ##Final_AllAccounts FROM #Final_AllAccounts

--DROP TABLE IF EXISTS ##Final_AllAccounts_new
--select * into ##Final_AllAccounts_new from #Final_AllAccounts

/*

SELECT * FROM #Final_AllAccounts ORDER BY acctID, RecordNumber

DROP TABLE IF EXISTS ##Final_AllAccounts_new
select * into ##Final_AllAccounts_new from #Final_AllAccounts

;WITH CTE
AS
(
SELECT DISTINCT acctID, ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck 
FROM #Final_AllAccounts
WHERE 
ImpactedStatement = 'YES' OR 
PHPImpact = 'YES' OR
PHPImpactWithStatusCheck = 'YES'
)
SELECT ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck , COUNT(1) RecordCount
FROM CTE 
GROUP BY ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck

SELECT T1.RecordNumber, T2.RecordNumber, T1.OriginalDQ, T2.OriginalDQ,*
FROM #Final_AllAccounts T1
JOIN #Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber+1 = T2.RecordNumber)
WHERE T2.OriginalDQ > T1.OriginalDQ + 1
--AND T2.acctID = 11496539
AND T2.RecordType = 'ImpactedRecords'
AND T2.acctID = 11496539


SELECT COUNT(DISTINCT T2.acctid)
FROM #Final_AllAccounts T1
JOIN #Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber+1 = T2.RecordNumber)
WHERE T2.OriginalDQ > T1.OriginalDQ + 1
--AND T2.acctID = 11496539
AND T2.RecordType = 'ImpactedRecords'

select * from #Final_AllAccounts where acctid = 1314514 ORDER BY acctID, RecordNumber

SELECT 'ImpactedStatement' Validation, COUNT(DISTINCT acctID) FROM #Final_AllAccounts WHERE ImpactedStatement = 'YES'
SELECT 'PHPImpact' Validation, COUNT(DISTINCT acctID) FROM #Final_AllAccounts WHERE PHPImpact = 'YES'

SELECT * FROM #FinalImpacted_Summary ORDER BY acctID, RecordNumber
SELECT * FROM #FinalImpacted_All ORDER BY acctID, RecordNumber
SELECT * FROM #Final_AllAccounts ORDER BY acctID, RecordNumber

select * from #tempdata where acctid = 4719650
SELECT * FROM #FinalImpacted_Summary WHERE acctID = 384538 ORDER BY acctID, RecordNumber
SELECT * FROM #FinalImpacted_All WHERE acctID = 138870 ORDER BY acctID, RecordNumber


SELECT PHPImpactWithStatusCheck, SystemStatus, ProjectedDQ, OriginalDQ, PrevProjDQ, SRB_Calc, AmountOfPaymentsCTD, AmountOfTotalDue_Proj,* 
FROM #Final_AllAccounts 
WHERE acctID = 245777 
--AND ProjectedDQ > OriginalDQ
--AND AmountOfPayment210DLate_Proj > AmountOfPayment210DLate_calc
ORDER BY acctID, RecordNumber


*/


--SELECT originalDQ, ProjectedDQ,* FROM ##Final_AllAccounts WHERE SRB_Calc <= 0  AND ProjectedDQ > 2

--SELECT originalDQ, ProjectedDQ,* 
--FROM ##Final_AllAccounts 
--WHERE SRB_Calc > 0  
--AND SRB_Calc > AmountOfTotalDue_Proj
--AND OriginalDQ >= 3
--AND ProjectedDQ < OriginalDQ
--AND AmountOfPaymentsCTD = 0
--AND PHPImpactWithStatusCheck = 'YES'


--SELECT originalDQ, ProjectedDQ,* 
--FROM ##Final_AllAccounts 
--WHERE SRB_Calc > 0  
--AND SRB_Calc > AmountOfTotalDue_Proj
--AND OriginalDQ >= 3
--AND ProjectedDQ < OriginalDQ
--AND AmountOfPaymentsCTD > 0
--AND PHPImpactWithStatusCheck = 'NO'