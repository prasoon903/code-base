SELECT A.uuid RMATranUUID, LifeCycle_ID TransactionLifeCycleUniqueID, A.MTI, TRY_CAST(AccountNumber AS VARCHAR) AccountNumber, TranID CoreAuthTranID, A.Plan_ID, TransmissionDateTime, Amount, OTB_Amount_Held, expiration_datetime , OTBReleaseAmount, *
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
--WHERE B.AccountNumber = '1100011113517233' 
WHERE A.uuid = 'd8429f54-b0a3-4233-a67b-f770f78343c0' 
--AND A.MTI = 9200

SELECT * FROM Auth_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 3478854429

SELECT MessageTypeIdentifier, TxnSource,coreauthtranid, TransactionAmount,* 
FROM Auth_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011109100044' 
AND TransactionLifeCycleUniqueID = 3478854429 
ORDER BY PostTime DESC

select messagetypeidentifier, TransactionAmount, TransactionLifeCycleUniqueID,* from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.coreauthtransactions with (nolock) where TranID in (3478854429)


DROP TABLE IF EXISTS #RetailAuth
SELECT A.uuid RMATranUUID, A.MTI, TRY_CAST(AccountNumber AS VARCHAR) AccountNumber, TranID CoreAuthTranID, A.Plan_ID, TransmissionDateTime, Amount, OTB_Amount_Held, expiration_datetime, OTBReleaseAmount
INTO #RetailAuth
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CPMAccounts CP WITH (NOLOCK) ON (CP.acctId = A.Plan_ID)
WHERE APIErrorFound = 0
AND A.Plan_ID IN (14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640)
AND TransmissionDateTime BETWEEN '2023-03-31 23:59:58' AND '2023-04-27 23:59:57'
--JOIN #TempData1 T ON (T.RMATranUUID = A.uuid /*AND A.MTI = 9200*/)
--WHERE CR_DR = 'DR'
--ORDER BY A.uuid, A.MTI

;WITH #Temp9100
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9100'
),
#Temp9200
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9100'
)
SELECT T1.*
FROM #Temp9200 t1
LEFT JOIN #Temp9100 T2 ON (T1.RMATranUUID = T2.RMATranUUID)
WHERE T2.RMATranUUID IS NULL

SELECT MTI, COUNT(1) FROM #RetailAuth GROUP BY MTI

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData (RMATranUUID VARCHAR(64), AccountNumber VARCHAR(19), PlanID INT, IsCreated INT, CreatedAmount MONEY, CreatedDate DATETIME, 
						ExpirationDate DATETIME, CurrentState VARCHAR(20), CancelledAmount MONEY, ActivatedAmount MONEY, 
						RefundedAmount MONEY, IsForcePost INT, ForcePostAmount MONEY)

INSERT INTO #TempData (RMATranUUID, AccountNumber, PlanID)
SELECT DISTINCT RMATranUUID, AccountNumber, Plan_ID FROM #RetailAuth WHERE MTI = '9100'

/*
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY RMATranUUID ORDER BY TransmissionDateTime) [Rank] FROM #RetailAuth WHERE MTI = '9100'
)
SELECT * FROM CTE WHERE [Rank] > 1
*/

;WITH CTE
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9100'
)
UPDATE T1
SET IsCreated = 1, CreatedAmount = Amount, CreatedDate = TransmissionDateTime, ExpirationDate = expiration_datetime
FROM #TempData T1
JOIN CTE C ON (T1.RMATranUUID = C.RMATranUUID)

/*
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY RMATranUUID ORDER BY TransmissionDateTime) [Rank] FROM #RetailAuth WHERE MTI = '9420'
)
SELECT * FROM CTE WHERE [Rank] > 1
*/

;WITH CTE
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9420'
)
UPDATE T1
SET CancelledAmount = OTBReleaseAmount
FROM #TempData T1
JOIN CTE C ON (T1.RMATranUUID = C.RMATranUUID)

--SELECT * FROM #RetailAuth WHERE RMATranUUID = '057344c8-5299-40c2-b699-2f88a04969b6'
--SELECT * FROM #TempData WHERE RMATranUUID = '057344c8-5299-40c2-b699-2f88a04969b6'


;WITH CTE
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9200'
)
UPDATE T1
SET ActivatedAmount = Amount
FROM #TempData T1
JOIN CTE C ON (T1.RMATranUUID = C.RMATranUUID)

;WITH CTE
AS
(
	SELECT MessageTypeIdentifier, TxnSource,R.coreauthtranid, R.RMATranUUID, TransactionAmount 
	FROM Auth_Primary A WITH (NOLOCK) 
	JOIN #RetailAuth R ON (A.AccountNumber = R.AccountNumber AND A.TransactionLifeCycleUniqueID = R.CoreAuthTranID AND A.MessageTypeIdentifier = '9200')
	JOIN #TempData T ON (T.RMATranUUID = R.RMATranUUID)
	WHERE ISNULL(T.ActivatedAmount, 0) = 0
)
UPDATE T1
SET ActivatedAmount = TransactionAmount
FROM #TempData T1
JOIN CTE C ON (T1.RMATranUUID = C.RMATranUUID)


;WITH CTE
AS
(
SELECT * FROM #RetailAuth WHERE MTI = '9220'
)
UPDATE T1
SET refundedAmount = Amount
FROM #TempData T1
JOIN CTE C ON (T1.RMATranUUID = C.RMATranUUID)



/*
SELECT * FROM #TempData WHERE ActivatedAmount > CreatedAmount
SELECT * FROM #TempData WHERE CreatedAmount > ActivatedAmount

SELECT * FROM #TempData WHERE CreatedAmount < ISNULL(ActivatedAmount,0) + ISNULL(CancelledAmount,0)
*/

DROP TABLE IF EXISTS #TempRecords
;WITH CTE
AS
(
	SELECT T1.* , BP.UniversalUniqueID AccountUUID, CP.acctID CPSID, CP.CurrentBalance
	FROM #TempData T1
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (T1.AccountNumber = BP.AccountNumber)
	JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
	JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPC.acctID = CP.acctID AND CPC.PlanUUID = T1.RMATranUUID)
)
SELECT T1.*, AccountUUID, CPSID, CurrentBalance
INTO #TempRecords
FROM #TempData T1
LEFT JOIN CTE ON (T1.RMATranUUID = CTE.RMATranUUID)

SELECT COUNT(1) FROM #TempData
SELECT COUNT(1) FROM #TempRecords
--28962

SELECT * FROm #TempRecords

SELECT COUNT(1) FROM #TempRecords WHERE ISNULL(ActivatedAmount,0) > 0
--28607
SELECT COUNT(1) FROM #TempRecords WHERE ISNULL(CancelledAmount,0) > 0
--335

SELECT COUNT(1) FROM #TempRecords WHERE ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) = 0

SELECT * FROM #TempRecords WHERE ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) = 0 AND CPSID > 0

SELECT *,
CASE 
	WHEN ISNULL(ActivatedAmount,0) > 0 AND CurrentBalance > 0 THEN 'Active'
	WHEN ISNULL(ActivatedAmount,0) > 0 AND CurrentBalance = 0 THEN 
		CASE	WHEN ISNULL(RefundedAmount,0) = ISNULL(ActivatedAmount,0) THEN 'Full Refunded' 
				WHEN ISNULL(RefundedAmount,0) > 0 AND ISNULL(RefundedAmount,0) < ISNULL(ActivatedAmount,0) THEN 'Partial Refunded'  
				WHEN ISNULL(RefundedAmount,0) = 0 THEN 'Paid-Off' 
				ELSE 'NA'
		END
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) > 0 AND ISNULL(CancelledAmount,0) = ISNULL(CreatedAmount,0) THEN 'Full Cancelled'
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) > 0 AND ISNULL(CancelledAmount,0) < ISNULL(CreatedAmount,0) THEN 'Partial Cancelled'
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) = 0 AND ExpirationDate > GETDATE() THEN 'Expired'
ELSE 'Status Not Match'
END CurrentStatus
FROM #TempRecords


UPDATE T
SET CurrentState = 
CASE 
	WHEN ISNULL(ActivatedAmount,0) > 0 AND ISNULL(CurrentBalance,0) > 0 THEN 'Active'
	WHEN ISNULL(ActivatedAmount,0) > 0 AND ISNULL(CurrentBalance,0) = 0 THEN 
		CASE	WHEN ISNULL(RefundedAmount,0) = ISNULL(ActivatedAmount,0) THEN 'Full Refunded' 
				WHEN ISNULL(RefundedAmount,0) > 0 AND ISNULL(RefundedAmount,0) < ISNULL(ActivatedAmount,0) THEN 'Partial Refunded'  
				WHEN ISNULL(RefundedAmount,0) = 0 THEN 'Paid-Off' 
				ELSE 'NA'
		END
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) > 0 AND ISNULL(CancelledAmount,0) = ISNULL(CreatedAmount,0) THEN 'Full Cancelled'
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) > 0 AND ISNULL(CancelledAmount,0) < ISNULL(CreatedAmount,0) THEN 'Partial Cancelled'
	WHEN ISNULL(ActivatedAmount,0) = 0 AND ISNULL(CancelledAmount,0) = 0 AND ExpirationDate < GETDATE() THEN 'Expired'
ELSE 'Status Not Match'
END
FROM #TempRecords T

SELECT CurrentState, COUNT(1) FROM #TempRecords Group BY CurrentState

SELECT * FROM #TempRecords WHERE CurrentState = 'Status Not Match'

SELECT RMATranUUID,AccountNumber, AccountUUID, PlanID,IsCreated,ISNULL(CreatedAmount, 0) CreatedAmount,CreatedDate,ExpirationDate,
CurrentState,ISNULL(CancelledAmount, 0) CancelledAmount,ISNULL(ActivatedAmount, 0) ActivatedAmount,ISNULL(RefundedAmount, 0) RefundedAmount,IsForcePost,ForcePostAmount,ISNULL(CurrentBalance, 0)  CurrentBalance
FROM #TempRecords
--WHERE CurrentState = 'Expired'



SELECT CreditPlanType, SingleSaleTranID,* FROM CPSgmentAccounts with (NOLOCK) WHERE acctID = 111399351
SELECT PlanUUID,* FROM CPSgmentCreditCard with (NOLOCK) WHERE acctID = 111399351

SELECT TxnSource, TransactionAmount, TransactionDescription, TransactionIdentifier, HostMachineName,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 83523799032
--d8429f54-b0a3-4233-a67b-f770f78343c0