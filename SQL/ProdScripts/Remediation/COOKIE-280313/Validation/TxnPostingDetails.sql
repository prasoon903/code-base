DECLARE @JiraID VARCHAR(20) = 'COOKIE-283574'

DROP TABLE IF EXISTS #TempTxns
CREATE TABLE #TempTxns (TranID DECIMAL(19,0), TransactionStatus INT)

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData (FieldValue VARCHAR(50), RecordStatus VARCHAR(50), RecordCount INT)

INSERT INTO #TempData
SELECT 'TotalInsertedRecords' FieldValue, 
CASE 
	WHEN JobStatus = 0 THEN 'NEW'
	WHEN JobStatus = 1 THEN 'RECORDS INSERTED'
	ELSE 'INVALID STATUS'
END RecordStatus, COUNT(1) RecordCount
FROM TransactionCreationTempData WITH (NOLOCK)
WHERE JiraID = @JiraID
GROUP BY JobStatus

INSERT INTO #TempTxns
SELECT TranID, TransactionStatus
FROM CreateNewSingleTransactionData WITH (NOLOCK)
WHERE Reason = @JiraID

INSERT INTO #TempData
SELECT 'TotalInsertedToTNP' FieldValue, 
CASE 
	WHEN TransactionStatus = 0 THEN 'NEW'
	WHEN TransactionStatus = 1 THEN 'DATA COOKED'
	WHEN TransactionStatus = 2 THEN 'INSERTED TO TNP'
	ELSE 'INVALID STATUS'
END RecordStatus, COUNT(1) RecordCount
FROM #TempTxns T
GROUP BY TransactionStatus

INSERT INTO #TempData
SELECT 'ErrorInCookingData' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM #TempTxns T
WHERE TransactionStatus = 1 AND ISNULL(TranID, 0) = 0

INSERT INTO #TempData
SELECT 'TNPBackLog' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()

INSERT INTO #TempData
SELECT 'TotalJobsInError' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM ErrorTNP WITH (NOLOCK)

INSERT INTO #TempData
SELECT 'InsertedJobsinTNP' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM CommonTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)

INSERT INTO #TempData
SELECT 'InsertedJobsinErrror' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM ErrorTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)


INSERT INTO #TempData
SELECT 'SUCCESSFUL POSTED RECORDS' FieldValue, NULL RecordStatus, COUNT(1) RecordCount
FROM Trans_In_Acct WITH (NOLOCK)
WHERE tran_id_index IN 
(
	SELECT TranID
	FROM #TempTxns
	WHERE TransactionStatus = 2
)
AND ATID = 51




DECLARE @Inserted INT, @Posted INT

SELECT @Inserted = Recordcount FROM #TempData WHERE FieldValue = 'TotalInsertedRecords' 
SELECT @Posted = Recordcount FROM #TempData WHERE FieldValue = 'SUCCESSFUL POSTED RECORDS'

IF(@Inserted - @Posted <> 0)
BEGIN
	SELECT 'ISSUE IN PROCESSING RECORDS OR JOBS ARE IN PROCESS' [RESPONSE MESSAGE]
END
ELSE
BEGIN 
	SELECT 'ALL RECORDS POSTED SUCCESSFULLY' [RESPONSE MESSAGE]
END

SELECT * FROM #TempData


/*

SELECT BP.AccountNumber, BP.SystemStatus, TransactionAmount, TransactionDescription, TranTime, PostTime
FROM CCArd_Primary CP WITH (NOLOCK)
JOIN #TempTxns T ON (CP.TranID = T.TranID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = CP.AccountNumber)


SELECT JiraID, COUNT(1) RecordCount
FROM TransactionCreationTempData WITH (NOLOCK)
GROUP BY JiraID

SELECT * 
FROM CommonTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM CreateNewSingleTransactionData WITH (NOLOCK)
	WHERE PostTime > TRY_CAST(GETDATE() AS DATE)
	AND TransactionStatus = 2
)
ORDER BY TranTime

--81302157672

SELECT TransactionStatus, *
FROM CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 1-- AND TranID IS NULL
Order bY TransactionCount

SELECT  *
FROM TransactionCreationTempData WITH (NOLOCK)
WHERE JobStatus = 0-- AND TranID IS NULL


SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, DestBSAcctId) + ', '''+RTRIM(DestAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, C.TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), C.TranTime, 20) + ''')'
SrcAccountNumber, DestAccountNumber, DestBSAcctId,TransactionStatus, BP.MergeInProcessPH, C.*
FROM CreateNewSingleTransactionData C WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.accountNumber = C.AccountNumber)
JOIN MergeAccountJob M WITH (NOLOCK) ON (M.SrcAccountNumber = BP.accountNumber)
WHERE TransactionStatus = 1 AND TranID IS NULL
ORDER BY C.TranTime



SELECT ArTxnType,* FROM LogARTxnAddl WITH (NOLOCK) where TranId IN ( 48306545797,48306545938)
SELECT BSAcctId,PostingRef,hostmachinename, AccountNumber, * FROM CCard_Primary CP WITH (NOLOCK) WHERE TranId IN ( 81302157672)
--81302157672
--81302037604

SELECT PostingRef, EntryReason, * FROM CreateNewSingleTransactionData CP WITH (NOLOCK) WHERE TranId IN ( 57671807206, 57671807207)


SELECT * 
FROM CommonTNP WITH (NOLOCK)
WHERE acctId IN (2801034, 2550083, 556395) 
AND TranID > 0

SELECT * FROM ErrorTNP WITH (NOLOCK)

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 55971261461

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE TranID IN (SELECT TranID FROM ErrorTNP WITH (NOLOCK))

SELECT TOP(10) *
FROM CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()
ORDER BY TranTime ASC

SELECT  COUNT(1)
FROM CommonTNP C WITH (NOLOCK)
JOIN CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
--ORDER BY CA.TranTime


SELECT  AccountNumber, acctId, COUNT(1)
FROM CommonTNP C WITH (NOLOCK)
JOIN CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
GROUP BY AccountNumber, acctId
--ORDER BY CA.TranTime 

SELECT * FROM CCardLookup WITH (NOLOCK) WHERE Lutid ='órganizationname '

*/

/*
SELECT TransactionStatus, *
FROM CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 1 AND TranID IS NULL
Order bY TransactionCount


SELECT TransactionStatus, BP.InstitutionID, CD.*
FROM CreateNewSingleTransactionData CD WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (CD.AccountNumber = BP.AccountNumber)
WHERE TransactionStatus = 1 AND TranID IS NULL

SELECT *
FROM EmbossingAccounts E WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (E.Parent01AID = BP.acctId AND E.ECardType = 0)
JOIN CreateNewSingleTransactionData ST WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = 1 AND BP.InstitutionID = 6981)


SELECT E.ECardType, BP.BillingCycle, BP.SystemStatus, BP.CCInhParent125AID
FROM EmbossingAccounts E WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (E.Parent01AID = BP.acctId AND E.ECardType = 0)
WHERE BP.acctId IN (18436937, 3513074, 2329625, 630491, 15929129, 1912495, 1943188, 4128045, 1283228, 16053160, 1571171, 2192632, 787526, 320032
, 2103168, 2227944, 2227944, 19500692, 1516175, 1516175, 1346887, 20156240, 20156240, 1299837, 1715751, 1715751, 1715751, 5701370)


SELECT E.ECardType, BP.BillingCycle, BP.SystemStatus, BP.CCInhParent125AID, ST.*
FROM CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = 1 AND BP.InstitutionID = 6981)
LEFT JOIN EmbossingAccounts E WITH (NOLOCK) ON (E.Parent01AID = BP.acctId)
WHERE ST.TransactionStatus = -2
ORDER BY BP.AccountNumber

SELECT BP.AccountNumber, BP.UniversalUniqueID AccountUUID, A.StatusDescription
FROM CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = -2 AND BP.InstitutionID = 6981)
LEFT JOIN AStatusAccounts A WITH (NOLOCK) ON (A.MerchantAID = 14992 AND A.Parent01AID = BP.CCInhParent125AID)
WHERE ST.TransactionStatus = -2
ORDER BY A.StatusDescription

SELECT TOP(10) 'MergeAccountJob====>', SrcRemainingMinDue, DESTRemainingMinDue, * FROM MergeAccountJob WITH (NOLOCK) ORDER BY Skey DESC


SELECT SrcAccountNumber, DestAccountNumber, DestBSAcctId, ST.TransactionAmount TransactionAmountToBePosted, ST.TranTime TranTime_Src, BP.DateAcctOpened DateAcctOpened_DEST, MA.EndTime MergeTime
FROM CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
WHERE ST.TransactionStatus = -2
--AND ST.AccountNumber = '1100011120177807'
AND ST.TranTime >= BP.DateAcctOpened

DROP Table IF EXISTS ##CalcInterestAccount
SELECT SrcBSAcctId, SrcBSAccountUUID, SrcAccountNumber, ST.TranTime TranTime_Src, ST.TransactionAmount TransactionAmountToBePosted, 0 InterestAmount, MA.EndTime MergeTime
INTO ##CalcInterestAccount
FROM CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
WHERE ST.TransactionStatus = -2
--AND ST.AccountNumber = '1100011120177807'
AND ST.TranTime < BP.DateAcctOpened


SELECT * FROM ##CalcInterestAccount



SELECT A.CBRStatusGroup,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority, A.COReasonCode,A.* 
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992 AND A.Parent01AID = 16324
ORDER BY A.Priority


UPDATE CreateNewSingleTransactionData SET TransactionStatus = -2 WHERE TransactionStatus = 1 AND TranID IS NULL

SELECT AccountNumber, COUNT(1)
FROM CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 0
GROUP BY AccountNumber
ORDER BY COUNT(1) DESC


SELECT TransactionStatus, *
FROM CreateNewSingleTransactionData WITH (NOLOCK)
--WHERE TransactionStatus = 1 AND AccountNumber = '1100011118460637'
ORDER BY Skey DESC

*/