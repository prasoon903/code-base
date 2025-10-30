/*
SELECT * FROM ##Cookie_PHP_01012025 
--WHERE Dispute_ID = 2198477
--WHERE Account_UUID IN ('e02c95bc-7234-4a3e-ab92-e4e01f0cad71')
--2198477
--Clearing_date_DFT
--WHERE Transaction_Amount IS NULL
--WHERE PC_Amount_Final IS NULL
--WHERE Clearing_date_DFT =  '1900-01-01 00:00:00.000'
--WHERE ISNULL(Transaction_Amount, 0) <> ISNULL(PC_Amount_Final, 0)
--WHERE DisputeAmount IS NULL
WHERE DisputeAmount = 0
--WHERE TRANSACTION_DATE =  '1900-01-01 00:00:00.000'

1. DisputeAmount = 0 remove
2. Update Clearing_date_DFT by  TRANSACTION_DATE where Clearing_date_DFT is null
3. UPdate PC_Date_Final with Getdate where it is null
4. Use Disputeamount instead of TransactionAmount




SELECT *
FROM ##Cookie_PHP_01012025
ORDER BY PC_Date_Final

--UPDATE ##Cookie_PHP_01012025 SET PC_Date_Final = GETDATE() WHERE PC_Date_Final =  '1900-01-01 00:00:00.000'
*/

DROP TABLE IF EXISTS #TempAllRecords
SELECT * INTO #TempAllRecords FROM ##Cookie_PHP_01012025 

SELECT * FROM #TempAllRecords WHERE DisputeAmount = 0
SELECT * FROM #TempAllRecords WHERE TRANSACTION_DATE =  '1900-01-01 00:00:00.000'
SELECT * FROM #TempAllRecords WHERE Clearing_date_DFT =  '1900-01-01 00:00:00.000'
SELECT * FROM #TempAllRecords WHERE PC_Date_Final =  '1900-01-01 00:00:00.000'

DELETE FROM #TempAllRecords WHERE DisputeAmount = 0
UPDATE #TempAllRecords SET Clearing_date_DFT = TRANSACTION_DATE WHERE Clearing_date_DFT = '1900-01-01 00:00:00.000' AND TRANSACTION_DATE <> '1900-01-01 00:00:00.000'
UPDATE #TempAllRecords SET PC_Date_Final = GETDATE() WHERE PC_Date_Final =  '1900-01-01 00:00:00.000'

DROP TABLE IF EXISTS #TempRecords
;WITH CTE
AS
(
SELECT *, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, Clearing_date_DFT))))  ClearingLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, Clearing_date_DFT))))  ClearingNextStatement,
DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, -1, PC_Date_Final))))  PCLastStatement
, DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, PC_Date_Final))))  PCNextStatement
FROM #TempAllRecords
--WHERE Account_UUID IN ('eecceb66-b93b-498a-af20-180957a0d3cf')
), Disputes
AS
(
SELECT Account_UUID AccountUUID, ClearingLastStatement, PCNextStatement PCLastStatement, MIN(Clearing_date_DFT) MinTxnDate, SUM(ISNULL(DisputeAmount, 0)) TransactionAmount
FROM CTE C
GROUP BY Account_UUID, ClearingLastStatement, PCNextStatement
)
SELECT BP.acctID, ROW_NUMBER() OVER(PARTITION BY BP.acctID ORDER BY ClearingLastStatement) RN, RTRIM(BP.AccountNumber) AccountNumber, CreatedTime, SystemStatus, D.*
INTO #TempRecords
FROM Disputes D
JOIN BSegment_Primary BP WITH (NOLOCK) ON (D.AccountUUID = BP.universalUniqueID)

--SELECT * FROM #TempRecords WHERE acctID = 47073
--SELECT * FROM #TempAllRecords WHERE Account_UUID = 'de54b875-d387-40ac-a431-ebf4ca06d776'
/*
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY ClearingLastStatement DESC) RowCounter FROM #TempRecords
)
SELECT *
FROM CTE 
WHERE RowCounter > 1
*/
;WITH CTE
AS
(
SELECT AccountNumber, MIN(MinTxnDate)  MinTxnDate
FROM #TempRecords
GROUP BY AccountNumber
)
UPDATE T
SET MinTxnDate = CASE WHEN C.MinTxnDate > T.ClearingLastStatement THEN C.MinTxnDate ELSE T.ClearingLastStatement END
FROM #TempRecords T
JOIN CTE C ON (T.AccountNumber = C.AccountNumber)

DROP TABLE IF EXISTS #StatementData
;WITH CTE
AS
(
SELECT acctID, MIN(ClearingLastStatement)  ClearingLastStatement, MAX(PCLastStatement) PCLastStatement
FROM #TempRecords
GROUP BY acctID
)
SELECT ROW_NUMBER() OVER(PARTITION BY C.acctID ORDER BY StatementDate) RN, C.*, StatementDate, LastStatementDate, Currentbalance+CurrentBalanceCO CurrentBalance, CycleDueDTD, 
AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, 
AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate, AmountOfPaymentsCTD, TRY_CAST(0 AS MONEY) AmountOfInterestCTD
INTO #StatementData
FROM CTE C
JOIN StatementHeader SH WITH (NOLOCK) ON (SH.acctid = C.acctID)
WHERE SH.StatementDate BETWEEN C.ClearingLastStatement AND C.PCLastStatement

--SELECT * FROM #StatementData WHERE acctID = 47073
--SELECT * FROM #TempRecords WHERE acctID = 47073

--SELECT T.acctID, S.StatementDate, T.TransactionAmount, T.MinTxnDate
--FROM #StatementData S
--JOIN #TempRecords T ON (T.acctID = S.acctID)
--WHERE S.StatementDate >= T.ClearingLastStatement
--AND S.acctID = 47073

DROP TABLE IF EXISTS #TempInterest
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, S.LastStatementDate, T.TransactionAmount, 
CASE WHEN MinTxnDate > S.LastStatementDate THEN MinTxnDate ELSE S.LastStatementDate END  MinTxnDate,
CASE WHEN YEAR(S.StatementDate) IN (2020, 2024) THEN 366 ELSE 365 END YearBase
FROM #StatementData S
JOIN #TempRecords T ON (T.acctID = S.acctID)
WHERE S.StatementDate >= T.ClearingLastStatement
),
Amounts
AS
(
SELECT acctID, StatementDate, LastStatementDate, MIN(MinTxnDate) MinTxnDate, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount, MIN(YearBase) YearBase
FROM CTE 
GROUP BY acctID, StatementDate, LastStatementDate
),
GetAPR
AS
(
SELECT SH.parent02AID, SH.StatementDate, MAX(ISNULL(APR, 0)) APR, SUM(ISNULL(InterestAtCycle, 0)) InterestAtCycle
FROM Amounts A
JOIN SummaryHeader SH WITH (NOLOCK) ON (A.acctID = SH.parent02AID AND A.StatementDate = SH.StatementDate)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate)
WHERE SH.CreditPlanType = '0'
GROUP BY SH.parent02AID, SH.StatementDate
)
SELECT ROW_NUMBER() OVER(PARTITION BY A.acctID ORDER BY A.StatementDate) IntCount, A.*, InterestAtCycle, G.APR, 
DATEDIFF(DAY, CASE WHEN A.MinTxnDate < A.StatementDate THEN A.MinTxnDate ELSE A.StatementDate END, A.StatementDate) DaysInCycle,
TRY_CAST(0 AS MONEY) CalcInterest
INTO #TempInterest
FROM GetAPR G
JOIN Amounts A ON (A.acctID = G.parent02AID AND A.StatementDate = G.StatementDate)
--WHERE acctID = 47073

--SELECT * FROM #TempInterest WHERE acctID = 47073 ORDER BY StatementDate

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



/*

DECLARE @LastInt MONEY, @JobID DECIMAL(19, 0) = 0
SET @LastInt = 0

WHILE EXISTS (SELECT TOP 1 1 FROM ##TempIntJobs WHERE MaxRecords > JobsUpdated)
BEGIN
	SELECT TOP 1 @JobID = JobID FROM ##TempIntJobs WHERE MaxRecords >= JobsUpdated ORDER BY JobID

	WHILE EXISTS(SELECT TOP 1 1 FROM ##TempIntJobs WHERE JobID = @JobID AND MaxRecords >= JobsUpdated)
	BEGIN

		SELECT TOP 1 @LastInt = T1.CalcInterest
		FROM #TempInterest T1
		JOIN ##TempIntJobs T2 ON (T1.acctID = T2.acctID)
		WHERE T1.IntCount = T2.JobsUpdated+1
		AND T2.JobID = @JobID

		UPDATE T1
		SET CalcInterest = CASE 
						WHEN 
						ROUND((TransactionAmount+@LastInt * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - TransactionAmount+@LastInt),2) <= InterestAtCycle 
						THEN 
						ROUND((TransactionAmount+@LastInt * POWER (1 + (ROUND(CAST (APR AS FLOAT)/CAST(100 AS FLOAT),10)) 
						* (ROUND(CAST (1 AS FLOAT)/CAST(YearBase AS FLOAT),10)),ISNULL(DaysInCycle,0)) - TransactionAmount+@LastInt),2)
						ELSE
						InterestAtCycle
						END
		FROM #TempInterest T1
		JOIN ##TempIntJobs T2 ON (T1.acctID = T2.acctID)
		WHERE T1.IntCount = T2.JobsUpdated+2
		AND T2.JobID = @JobID

		UPDATE ##TempIntJobs SET JobsUpdated = JobsUpdated + 1 WHERE JobID = @JobID
	END
END

*/





--SELECT *
--FROM #StatementData S
--JOIN #TempInterest T ON (T.acctID = S.acctID AND T.StatementDate = S.StatementDate)
--WHERE S.acctID = 47073


UPDATE S
SET AmountOfInterestCTD = T.CalcInterest
FROM #StatementData S
JOIN #TempInterest T ON (T.acctID = S.acctID AND T.StatementDate = S.StatementDate)
--WHERE S.acctID = 47073

--SELECT * FROM #StatementData WHERE acctID = 47073
--SELECT * FROM #TempInterest WHERE acctID = 47073 ORDeR BY StatementDate

/*
;WITH CTE
AS
(
SELECT S.acctID, S.StatementDate, SUM(CASE WHEN CSH.AmtOfInterestCTD > 0 THEN CSH.AmtOfInterestCTD ELSE 0 END) AmtOfInterestCTD
FROM #StatementData S
JOIN SummaryHeader SH WITH (NOLOCK) ON (S.acctID = SH.parent02AID AND S.StatementDate = SH.StatementDate)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND CSH.StatementDate = SH.StatementDate)
WHERE SH.CreditPlanType = '0'
GROUP BY S.acctID, S.StatementDate
)
UPDATE T
SET AmountOfInterestCTD = C.AmtOfInterestCTD
FROM #StatementData T
JOIN CTE C ON (T.acctID = C.acctID AND T.StatementDate = C.StatementDate)
*/




DROP TABLE IF EXISTS ##TempData
;WITH CTE
AS
(
SELECT T.acctID, S.StatementDate, T.TransactionAmount 
FROM #StatementData S
JOIN #TempRecords T ON (T.acctID = S.acctID)
WHERE S.StatementDate >= T.ClearingLastStatement
),
Amounts
AS
(
SELECT acctID, StatementDate, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount
FROM CTE 
GROUP BY acctID, StatementDate
)
SELECT S.*, A.TransactionAmount, ROUND(0.01*A.TransactionAmount+AmountOfInterestCTD, 2) TotalAmountToApply,
TRY_CAST(0 AS MONEY) AmountApplied
INTO ##TempData
FROM #StatementData S
JOIN Amounts A ON (S.acctID = A.acctID AND S.StatementDate = A.StatementDate)

--SELECT * FROM ##TempData WHERE acctID = 47073

DROP TABLE IF EXISTS ##TempDataProcessed
SELECT * INTO ##TempDataProcessed FROM ##TempData WHERE RN = 1

--SELECT * FROM #TempDataProcessed


DROP TABLE IF EXISTS ##TempJobs
CREATE TABLE ##TempJobs (JobID DECIMAL(19, 0) IDENTITY(1,1), acctID INT, MaxRecords INT, JobsUpdated INT)

INSERT INTO ##TempJobs
SELECT acctID, MAX(RN) MaxRecords, TRY_CAST(0 AS INT) JobsUpdated
FROM ##TempData
GROUP BY acctID

--SELECT * FROM ##TempJobs

--DROP TABLE IF EXISTS #TempJobToProcess
--SELECT TOP 1 T1.*
--INTO #TempJobToProcess
--FROM #TempDataProcessed T1
--JOIN ##TempJobs T2 ON (T1.acctID = T2.acctID)
--WHERE T1.RN = T2.JobsUpdated+1

--SELECT *
--FROM #TempJobToProcess

SET NOCOUNT ON;
DECLARE @JobID DECIMAL(19, 0) = 1
DECLARE @AmountToApply MONEY = 0
DECLARE @1PCTApply MONEY = 0
DECLARE @DQBuckets INT = 9
DECLARE @DQCount INT = 0
DECLARE @DQBucketValue MONEY = 0
DECLARE @Due MONEY = 0


WHILE EXISTS(SELECT TOP 1 1 FROM ##TempJobs WHERE MaxRecords >= JobsUpdated)
BEGIN
	SELECT TOP 1 @JobID = JobID FROM ##TempJobs WHERE MaxRecords >= JobsUpdated ORDER BY JobID

	WHILE EXISTS(SELECT TOP 1 1 FROM ##TempJobs WHERE JobID = @JobID AND MaxRecords >= JobsUpdated)
	BEGIN
		DROP TABLE IF EXISTS #TempJobToProcess
		SELECT TOP 1 T1.*
		INTO #TempJobToProcess
		FROM ##TempDataProcessed T1
		JOIN ##TempJobs T2 ON (T1.acctID = T2.acctID)
		WHERE T1.RN = T2.JobsUpdated+1
		AND T2.JobID = @JobID

		--SELECT * FROM #TempJobToProcess

		SELECT @AmountToApply = TotalAmountToApply  FROM #TempJobToProcess
		--SET @1PCTApply = ROUND(0.01*@AmountToApply, 2) 
		SET @1PCTApply =  @AmountToApply

		--DECLARE @DQCount INT = 9
		--DECLARE @1PCTApply MONEY = 10
		--DECLARE @Due MONEY = 0
		--SELECT * FROM #TempJobToProcess
		--SELECT @1PCTApply

		SET @Due = 0
		SET @DQCount = 9

		IF(@DQCount = 9 AND @1PCTApply > 0)
		BEGIN
			--SELECT @DQCount
			--SELECT @1PCTApply
			--SELECT @Due

			SELECT @Due = AmountOfPayment210DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment210DLate = @Due

			--SELECT @1PCTApply
			--SELECT @Due

			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 8 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment180DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment180DLate = @Due

			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 7 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment150DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment150DLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 6 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment120DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment120DLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 5 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment90DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment90DLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 4 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment60DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment60DLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 3 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmountOfPayment30DLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmountOfPayment30DLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 2 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmtOfPayXDLate FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmtOfPayXDLate = @Due
			SET @DQCount = @DQCount - 1
		END
		IF(@DQCount = 1 AND @1PCTApply > 0)
		BEGIN
			SELECT @Due = AmtOfPayCurrDue FROM #TempJobToProcess
			IF(@Due > @1PCTApply)
			BEGIN
				SET @Due = @Due - @1PCTApply
				SET @1PCTApply = 0
			END
			ELSE
			BEGIN
				SET @1PCTApply = @1PCTApply - @Due
				SET @Due = 0
			END
			UPDATE #TempJobToProcess SET AmtOfPayCurrDue = @Due

			SET @DQCount = @DQCount - 1
		END

		UPDATE #TempJobToProcess 
			SET AmountApplied = TotalAmountToApply - @1PCTApply,
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

		UPDATE T1
		SET AmountApplied = T2.AmountApplied
		FROM ##TempDataProcessed T1
		JOIN #TempJobToProcess T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)


		

		/*
		INSERT INTO #TempDataProcessed
		SELECT T2.RN, T1.acctID, T1.ClearingLastStatement, T1.PCLastStatement, T2.StatementDate, T2.CurrentBalance, T1.CycleDueDTD + 1, 
		T1.AmountOfPayment210DLate+T1.AmountOfPayment180DLate+T1.AmountOfPayment150DLate+T1.AmountOfPayment120DLate+T1.AmountOfPayment90DLate+T1.AmountOfPayment60DLate
		+T1.AmountOfPayment30DLate+T1.AmtOfPayXDLate+T1.AmtOfPayCurrDue+T2.AmtOfPayCurrDue,
		T2.AmtOfPayCurrDue,	T1.AmtOfPayCurrDue, T1.AmtOfPayXDLate, T1.AmountOfPayment30DLate, T1.AmountOfPayment60DLate, T1.AmountOfPayment90DLate, 
		T1.AmountOfPayment120DLate, T1.AmountOfPayment150DLate, T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate,
		T2.AmountOfPaymentsCTD, T2.AmountOfInterestCTD, T2.TransactionAmount, T2.TotalAmountToApply, T2.AmountApplied
		FROM #TempJobToProcess T1
		JOIN #TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)
		*/

		INSERT INTO ##TempDataProcessed
		SELECT T2.RN, T1.acctID, T1.ClearingLastStatement, T1.PCLastStatement, T2.StatementDate, T2.LastStatementDate, T2.CurrentBalance, 
		CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END, 
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 2 THEN CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 3 THEN CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 4 THEN CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 5 THEN CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 6 THEN CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 7 THEN CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 8 THEN CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END+
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 9 THEN CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END,
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 1 THEN T2.AmtOfPayCurrDue ELSE 0 END,
		--T2.AmtOfPayCurrDue,
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 2 THEN CASE WHEN T1.AmtOfPayCurrDue < T2.AmtOfPayXDLate THEN T1.AmtOfPayCurrDue ELSE T2.AmtOfPayXDLate END ELSE 0 END,	
		--T1.AmtOfPayCurrDue,
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 3 THEN CASE WHEN T1.AmtOfPayXDLate < T2.AmountOfPayment30DLate THEN T1.AmtOfPayXDLate ELSE T2.AmountOfPayment30DLate END ELSE 0 END,	 
		--T1.AmtOfPayXDLate,
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 4 THEN CASE WHEN T1.AmountOfPayment30DLate < T2.AmountOfPayment60DLate THEN T1.AmountOfPayment30DLate ELSE T2.AmountOfPayment60DLate END ELSE 0 END,	  
		--T1.AmountOfPayment30DLate, 
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 5 THEN CASE WHEN T1.AmountOfPayment60DLate < T2.AmountOfPayment90DLate THEN T1.AmountOfPayment60DLate ELSE T2.AmountOfPayment90DLate END ELSE 0 END,	 
		--T1.AmountOfPayment60DLate, 
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 6 THEN CASE WHEN T1.AmountOfPayment90DLate < T2.AmountOfPayment120DLate THEN T1.AmountOfPayment90DLate ELSE T2.AmountOfPayment120DLate END ELSE 0 END,	 
		--T1.AmountOfPayment90DLate, 
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 7 THEN CASE WHEN T1.AmountOfPayment120DLate < T2.AmountOfPayment150DLate THEN T1.AmountOfPayment120DLate ELSE T2.AmountOfPayment150DLate END ELSE 0 END,	 
		--T1.AmountOfPayment120DLate,
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 8 THEN CASE WHEN T1.AmountOfPayment150DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment150DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END,	  
		--T1.AmountOfPayment150DLate, 
		CASE WHEN CASE WHEN T2.CycleDueDTD > T1.CycleDueDTD + 1 THEN T1.CycleDueDTD + 1 ELSE T2.CycleDueDTD END >= 9 THEN CASE WHEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate < T2.AmountOfPayment180DLate THEN T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate ELSE T2.AmountOfPayment180DLate END ELSE 0 END,	 
		--T1.AmountOfPayment180DLate+T1.AmountOfPayment210DLate,
		T2.AmountOfPaymentsCTD, T2.AmountOfInterestCTD, T2.TransactionAmount, T2.TotalAmountToApply, T2.AmountApplied
		FROM #TempJobToProcess T1
		JOIN ##TempData T2 ON (T1.acctID = T2.acctID AND T1.RN + 1 = T2.RN)

		--SELECT * FROM ##TempJobs
		--SELECT * FROM #TempJobToProcess
		--SELECT * FROM #TempDataProcessed ORDER BY acctID, RN


		UPDATE ##TempJobs SET JobsUpdated = JobsUpdated + 1 WHERE JobID = @JobID



	END



	--AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue

	--SELECT DATEADD(SS, 86397, TRY_CONVERT(DATETIME, DATEADD(MM, -1, EOMONTH(TRY_CONVERT(Date, GETDATE())))))

	--SELECT DATEADD(SS, 86397, TRY_CONVERT(DATETIME, EOMONTH(DATEADD(MM, 0, GETDATE()))))
END

/*
SELECT *
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
WHERE T1.CycleDueDTD > T2.CycleDueDTD

SELECT * FROM ##TempData WHERE acctID = 365059 ORDER BY acctID, RN
SELECT * FROM ##TempDataProcessed WHERE acctID = 365059 ORDER BY acctID, RN

SELECT * FROM ##Cookie_PHP_01012025 WHERE Account_UUID = '601ea3be-a911-49bc-aaba-0a8e10951eb7'


;WITH CTE
AS
(
SELECT DISTINCT T1.acctID
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
WHERE T1.CycleDueDTD > T2.CycleDueDTD
)
SELECT COUNT(1)
FROM CTE

DROP TABLE IF EXISTS #AccountData
;WITH CTE
AS
(
SELECT Account_UUID, MIN(Clearing_date_DFT)  MinClearing_date_DFT, MAX(PC_Date_Final) MaxPC_Date_Final
FROM #TempAllRecords
GROUP BY Account_UUID
)
SELECT BP.acctID, RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, MinClearing_date_DFT, MaxPC_Date_Final
INTO #AccountData
FROM CTE C
JOIN BSegment_Primary BP WITH (NOLOCK) ON (C.Account_UUID = BP.UniversalUniqueID)



DROP TABLE IF EXISTS #ImpactedAccounts
;WITH CTE
AS
(
SELECT DISTINCT T1.acctID
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
WHERE T1.CycleDueDTD > T2.CycleDueDTD
)
SELECT BP.acctID, RTRIM(BP.AccountNumber) AccountNumber, AccountUUID, MinClearing_date_DFT, MaxPC_Date_Final
INTO #ImpactedAccounts
FROM CTE C
JOIN #AccountData BP WITH (NOLOCK) ON (BP.acctID = C.acctID)
--WHERE BP.acctID = 365059

SELECT* FROM #ImpactedAccounts
SELECT * FROM #TempRecords


SELECT CASE WHEN T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearing_date_DFT, I.MaxPC_Date_Final, T1.ClearingLastStatement, T1.PCLastStatement PCNextStatement, t1.TransactionAmount DisputeAmountOfCycle, T1.RN StatmentOrder, 
T1.StatementDate, T1.CurrentBalance, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #ImpactedAccounts I ON (T1.acctID = I.acctId)
ORDER BY T1.acctID, T1.RN
--12963

SELECT CASE WHEN T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement, 
I.acctID, I.AccountNumber, I.AccountUUID, I.MinClearing_date_DFT, I.MaxPC_Date_Final, T1.ClearingLastStatement, T1.PCLastStatement PCNextStatement, t1.TransactionAmount DisputeAmountOfCycle, T1.RN StatmentOrder, 
T1.StatementDate, T1.CurrentBalance, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ,
T1.AmountOfPaymentsCTD,T1.AmountOfInterestCTD, 
T1.AmountOfTotalDue AmountOfTotalDue_Original,T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T1.AmtOfPayXDLate AmtOfPayXDLate_Original,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,
T2.AmountOfTotalDue AmountOfTotalDue_Calc,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,
T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,
T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,
T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,
T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc,
T1.TotalAmountToApply--,T1.AmountApplied
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #ImpactedAccounts I ON (T1.acctID = I.acctId)
ORDER BY T1.acctID, T1.RN


;WITH CTE
AS
(
SELECT acctID, MIN(ClearingLastStatement)  ClearingLastStatement, MAX(PCLastStatement) PCLastStatement, SUM(TransactionAmount) DisputeAmountOfCycle
FROM #TempRecords
GROUP BY acctID
)
SELECT CASE WHEN T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement, *
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #ImpactedAccounts I ON (T1.acctID = I.acctId)
JOIN CTE T ON (T1.acctID = T.acctID AND T1.ClearingLastStatement = T.ClearingLastStatement)
ORDER BY T1.acctID, T1.RN


SELECT CASE WHEN T1.CycleDueDTD > T2.CycleDueDTD THEN 'YES' ELSE 'NO' END ImpactedStatement, 
I.acctID, I.AccountNumber, AccountUUID, I.MinClearing_date_DFT, I.MaxPC_Date_Final, T1.ClearingLastStatement, T1.PCLastStatement PCNextStatement, t1.TransactionAmount DisputeAmountOfCycle, T1.RN StatmentOrder, 
T1.StatementDate, T1.CurrentBalance, T1.CycleDueDTD OriginalDQ, T2.CycleDueDTD CalculatedDQ,
T1.AmountOfPaymentsCTD,T1.AmountOfInterestCTD, 
T1.AmountOfTotalDue AmountOfTotalDue_Original,T1.AmtOfPayCurrDue AmtOfPayCurrDue_Original,T1.AmtOfPayXDLate AmtOfPayXDLate_Original,
T1.AmountOfPayment30DLate AmountOfPayment30DLate_Original,T1.AmountOfPayment60DLate AmountOfPayment60DLate_Original,
T1.AmountOfPayment90DLate AmountOfPayment90DLate_Original,T1.AmountOfPayment120DLate AmountOfPayment120DLate_Original,
T1.AmountOfPayment150DLate AmountOfPayment150DLate_Original,T1.AmountOfPayment180DLate AmountOfPayment180DLate_Original,
T1.AmountOfPayment210DLate AmountOfPayment210DLate_Original,
T2.AmountOfTotalDue AmountOfTotalDue_Calc,T2.AmtOfPayCurrDue AmtOfPayCurrDue_Calc,T2.AmtOfPayXDLate AmtOfPayXDLate_Calc,
T2.AmountOfPayment30DLate AmountOfPayment30DLate_Calc,T2.AmountOfPayment60DLate AmountOfPayment60DLate_Calc,
T2.AmountOfPayment90DLate AmountOfPayment90DLate_Calc,T2.AmountOfPayment120DLate AmountOfPayment120DLate_Calc,
T2.AmountOfPayment150DLate AmountOfPayment150DLate_Calc,T2.AmountOfPayment180DLate AmountOfPayment180DLate_Calc,
T2.AmountOfPayment210DLate AmountOfPayment210DLate_Calc,
T1.TotalAmountToApply
FROM ##TempData T1
JOIN ##TempDataProcessed T2 ON (T1.acctID = T2.acctID AND T1.RN = T2.RN)
JOIN #AccountData I WITH (NOLOCK) ON (I.acctID = T2.acctID)
ORDER BY T1.acctID, T1.RN


SELECT * FROM #AccountData

*/