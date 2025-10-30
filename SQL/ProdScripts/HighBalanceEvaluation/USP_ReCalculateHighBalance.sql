

DECLARE
	@AccountID INT,
	@AccountNumber VARCHAR(19), 
	@AccountCreationTime DATETIME,
	@Acquisitiondate DATETIME,
	@ProcessTime DATETIME,
	@CBRAmountOfCurrentBalance MONEY,
	@CBRAmountOfHighBalance MONEY

SELECT 
	@AccountID = acctId,
	@AccountNumber = AccountNumber,
	@AccountCreationTime = CreatedTime,
	@Acquisitiondate = NULL,
	@CBRAmountOfCurrentBalance = 0,
	@CBRAmountOfHighBalance = 0
FROM BSegment_Primary WITH (NOLOCK)
WHERE acctID = 1919800




SET @ProcessTime = @AccountCreationTime

IF(@Acquisitiondate IS NOT NULL AND @Acquisitiondate > @ProcessTime)  
 BEGIN  
  SELECT TOP 1  
  @CBRAmountOfCurrentBalance = CurrentBalance + CurrentBalanceCO,  
  @CBRAmountOfHighBalance = AmtOfAcctHighBalLTD,  
  @ProcessTime = StatementDate  
  FROM StatementHeader WITH(NOLOCK)  
  WHERE Acctid = @AccountID  
  AND StatementDate > @Acquisitiondate  
 END
	   	
DROP TABLE IF EXISTS #TempData
SELECT --ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) RowCounter,
CP.AccountNumber, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionAmount,CP.TranId,CP.TranRef,
CP.RevTgt, Trantime,CP.PostTime, CP.TxnSource, CP.NoBlobIndicator,Transactionidentifier,
CASE WHEN CP.TranRef IS NULL THEN 1 ELSE 5 END Priority,  --PLAT-125950 
CP.DateTimeLocalTransaction,
CP.Artxntype  --PLAT-99400
,CP.TxnAcctID
INTO #TempData
FROM CCard_Primary CP WITH (NOLOCK)
WHERE CP.AccountNumber IN (@AccountNumber) 
AND CP.CMTTRANTYPE IN ('02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',  
						'17','18','19','21','22','23','24','25','26','28','29','30','31','32','33',  
						'35','37','38','40','41','42','43','45','48','49','50',/*'51','52',*/'53',/*'54', */  --PLAT-92882
						'55','56','57','58','60','61','62','63','64','65','66','67','68','69','70',  
						'71','72','73','74','75','76','77','78','79','80','81','82','83','84','85',  
						'86','87','90','91','92','93','94','95','96','97','98',
						'110','111','1111','115','116','117','118')
AND CP.PostTime > @ProcessTime

INSERT INTO #TempData (TranId, CMTTRANTYPE, AccountNumber, TransactionAmount, Trantime, PostTime, Priority)
VALUES
 (0, '00', @AccountNumber, @CBRAmountOfCurrentBalance, @ProcessTime, @ProcessTime, 0) --PLAT-91601(Changed Priority from 1 to 0)
	

DROP TABLE IF EXISTS #Plans
CREATE TABLE #Plans (acctID INT)

INSERT INTO #Plans
SELECT acctId
FROM CPSgmentAccounts WITH (NOLOCK)
WHERE parent02AID = @AccountID

INSERT INTO #TempData (TranId, TxnAcctID, AccountNumber, CMTTranType, TransactionAmount, Trantime, PostTime, Priority)
SELECT 0, P.acctID, @AccountNumber, 
CASE 
	WHEN CS.AmtOfInterestCTD > 0 
	THEN '03' 
	ELSE '02' 
END, 
ABS(CS.AmtOfInterestCTD), CS.StatementDate, CS.StatementDate, 2
FROM CurrentSummaryHeader CS WITH (NOLOCK)
JOIN #Plans P ON (CS.acctID = P.acctID)
AND CS.StatementDate > @ProcessTime

INSERT INTO #TempData (TranId, AccountNumber, CMTTranType, TransactionAmount, Trantime, PostTime, Priority)
SELECT 0, @AccountNumber, '08', TransactionAmount, JobDate, PostTime, 2 --Plat-109380(Added JobDate As HighBalance Was Calculate Wrong In Case Of Payment Reversal)
FROM LateFeeDeterminant WITH (NOLOCK)
WHERE acctId = @AccountID
AND LateFeeDeterminantFlag = 1
AND JobDate > @ProcessTime   --PLAT-122024

DELETE FROM #TempData WHERE CMTTranType IN('03','02') AND TxnSource = '4' AND NoBlobIndicator = '9' --PLAT-105058(Added '02')
DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND Transactionidentifier = 'TCAP' --PLAT-136407
DELETE FROM #TempData WHERE CMTTranType = '03' AND TxnSource = '2' AND RevTgt IS NOT NULL --PLAT-144199
DELETE FROM #TempData WHERE CMTTranType = '08' AND TranRef IS NOT NULL --PLAT-144199 
DELETE FROM #TempData WHERE CMTTranType = '09' AND RevTgt IS NOT NULL --PLAT-144199 

;WITH CTE  
AS  
(  
	SELECT *  
	FROM #TempData  
	WHERE RevTgt IS NOT NULL  
)  
UPDATE T1  
SET TransactionAmount = CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN T1.TransactionAmount - C.TransactionAmount END
FROM #TempData T1  
JOIN CTE C ON (T1.TranID = C.RevTgt)  
  
;WITH CTE  
AS  
(  
	SELECT *  
	FROM #TempData  
	WHERE CMTTranType = '03'  
)  
UPDATE T1  
SET TransactionAmount = CASE WHEN T1.TransactionAmount - C.TransactionAmount >= 0 THEN T1.TransactionAmount - C.TransactionAmount END
FROM #TempData T1  
JOIN CTE C ON (T1.TranTime = C.TranTime AND T1.TxnAcctID = C.TxnAcctID AND T1.CMTTranType = '02') 
	

DELETE FROM #TempData WHERE RevTgt IS NOT NULL 
DELETE FROM #TempData WHERE CMTTranType = '03' AND TranID = 0

DELETE FROM #TempData WHERE TransactionAmount = 0 AND Priority > 0 --PLAT-91601 
DELETE FROM #TempData WHERE Artxntype  IN ('99','104')  --PLAT-99400 (Added Artxntype '95' for PLAT-92882)
DELETE FROM #TempData WHERE Artxntype  = '95' AND CMTTranType <> '61' 

DROP TABLE IF EXISTS #TempRecords
;WITH CTE
AS
(
	SELECT ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY TranTime) RowCounter, 
	AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID,
	SUM(CASE WHEN TRY_CAST(CMTTRANTYPE AS INT)%2 = 1 THEN TransactionAmount*-1 ELSE TransactionAmount END) 
	OVER (PARTITION BY NULL ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) CurrentBalance
	FROM #TempData
)
SELECT RowCounter, AccountNumber, CMTTRANTYPE, TransactionAmount, TranId, TranRef, RevTgt, Trantime, PostTime, TxnSource, Priority, TxnAcctID, CurrentBalance,
CASE WHEN RowCounter = 1 Then @CBRAmountOfHighBalance
ELSE MAX(CASE WHEN CurrentBalance > @CBRAmountOfHighBalance THEN CurrentBalance ELSE @CBRAmountOfHighBalance END) OVER (PARTITION BY NULL ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) END HighBalance
--MAX(CurrentBalance) OVER (PARTITION BY NULL ORDER BY TranTime, Priority ROWS UNBOUNDED PRECEDING) HighBalance
INTO #TempRecords
FROM CTE

SELECT * FROM #TempRecords --WHERE TransactionAmount = 0.84


SELECT T1.*, T2.OldValue, T2.NewValue 
FROM #TempRecords T1
LEFT JOIN CurrentBalanceAudit T2 WITH (NOLOCK) ON (T1.TranID = T2.TID /*AND T2.AID = 1919800 AND T2.DENAME = 111*/)
WHERE T2.AID = 1919800 AND T2.DENAME = 111 AND T1.Priority > 0
ORDER BY IdentityField 
