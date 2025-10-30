
SELECT JobStatus, COUNT(1) RecordCount
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.TransactionCreationTempData WITH (NOLOCK)
GROUP BY JobStatus

SELECT TransactionStatus, COUNT(1) RecordCount
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE PostTime > TRY_CAST(GETDATE() AS DATE)
GROUP BY TransactionStatus

SELECT COUNT(1) CommonTNPRecordCount
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()

SELECT COUNT(1) ErrorTNPRecordCount
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ErrorTNP WITH (NOLOCK)


SELECT COUNT(1) PostedJobRecordCount_Remaining
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
	WHERE PostTime > TRY_CAST(GETDATE() AS DATE)
	AND TransactionStatus = 2
)

/*

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE TranID IN 
(
	SELECT TranID
	FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
	WHERE PostTime > TRY_CAST(GETDATE() AS DATE)
	AND TransactionStatus = 2
)
ORDER BY TranTime


SELECT TransactionStatus, *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 1-- AND TranID IS NULL
Order bY TransactionCount

SELECT  *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.TransactionCreationTempData WITH (NOLOCK)
WHERE JobStatus = 0-- AND TranID IS NULL


SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, DestBSAcctId) + ', '''+RTRIM(DestAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, C.TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), C.TranTime, 20) + ''')'
SrcAccountNumber, DestAccountNumber, DestBSAcctId,TransactionStatus, BP.MergeInProcessPH, C.*
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.accountNumber = C.AccountNumber)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob M WITH (NOLOCK) ON (M.SrcAccountNumber = BP.accountNumber)
WHERE TransactionStatus = 1 AND TranID IS NULL
ORDER BY C.TranTime



SELECT ArTxnType,* FROM LogARTxnAddl WITH (NOLOCK) where TranId IN ( 48306545797,48306545938)
SELECT BSAcctId,PostingRef,hostmachinename, * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK) WHERE TranId IN ( 70217338231)

SELECT PostingRef, EntryReason, * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CP WITH (NOLOCK) WHERE TranId IN ( 57671807206, 57671807207)


SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE acctId IN (2801034, 2550083, 556395) 
AND TranID > 0

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ErrorTNP WITH (NOLOCK)

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 55971261461

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE TranID IN (SELECT TranID FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ErrorTNP WITH (NOLOCK))

SELECT TOP(10) *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH (NOLOCK)
WHERE TranTime < GETDATE()
ORDER BY TranTime ASC

SELECT  COUNT(1)
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP C WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
--ORDER BY CA.TranTime


SELECT  AccountNumber, acctId, COUNT(1)
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP C WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
GROUP BY AccountNumber, acctId
--ORDER BY CA.TranTime 

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCardLookup WITH (NOLOCK) WHERE Lutid ='órganizationname '

*/

/*
SELECT TransactionStatus, *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 1 AND TranID IS NULL
Order bY TransactionCount


SELECT TransactionStatus, BP.InstitutionID, CD.*
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CD WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (CD.AccountNumber = BP.AccountNumber)
WHERE TransactionStatus = 1 AND TranID IS NULL

SELECT *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.EmbossingAccounts E WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (E.Parent01AID = BP.acctId AND E.ECardType = 0)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = 1 AND BP.InstitutionID = 6981)


SELECT E.ECardType, BP.BillingCycle, BP.SystemStatus, BP.CCInhParent125AID
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.EmbossingAccounts E WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (E.Parent01AID = BP.acctId AND E.ECardType = 0)
WHERE BP.acctId IN (18436937, 3513074, 2329625, 630491, 15929129, 1912495, 1943188, 4128045, 1283228, 16053160, 1571171, 2192632, 787526, 320032
, 2103168, 2227944, 2227944, 19500692, 1516175, 1516175, 1346887, 20156240, 20156240, 1299837, 1715751, 1715751, 1715751, 5701370)


SELECT E.ECardType, BP.BillingCycle, BP.SystemStatus, BP.CCInhParent125AID, ST.*
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = 1 AND BP.InstitutionID = 6981)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.EmbossingAccounts E WITH (NOLOCK) ON (E.Parent01AID = BP.acctId)
WHERE ST.TransactionStatus = -2
ORDER BY BP.AccountNumber

SELECT BP.AccountNumber, BP.UniversalUniqueID AccountUUID, A.StatusDescription
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (ST.AccountNumber = BP.AccountNumber AND ST.TransactionStatus = -2 AND BP.InstitutionID = 6981)
LEFT JOIN AStatusAccounts A WITH (NOLOCK) ON (A.MerchantAID = 14992 AND A.Parent01AID = BP.CCInhParent125AID)
WHERE ST.TransactionStatus = -2
ORDER BY A.StatusDescription

SELECT TOP(10) 'MergeAccountJob====>', SrcRemainingMinDue, DESTRemainingMinDue, * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK) ORDER BY Skey DESC


SELECT SrcAccountNumber, DestAccountNumber, DestBSAcctId, ST.TransactionAmount TransactionAmountToBePosted, ST.TranTime TranTime_Src, BP.DateAcctOpened DateAcctOpened_DEST, MA.EndTime MergeTime
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
WHERE ST.TransactionStatus = -2
--AND ST.AccountNumber = '1100011120177807'
AND ST.TranTime >= BP.DateAcctOpened

DROP Table IF EXISTS ##CalcInterestAccount
SELECT SrcBSAcctId, SrcBSAccountUUID, SrcAccountNumber, ST.TranTime TranTime_Src, ST.TransactionAmount TransactionAmountToBePosted, 0 InterestAmount, MA.EndTime MergeTime
INTO ##CalcInterestAccount
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
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
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 0
GROUP BY AccountNumber
ORDER BY COUNT(1) DESC


SELECT TransactionStatus, *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
--WHERE TransactionStatus = 1 AND AccountNumber = '1100011118460637'
ORDER BY Skey DESC

*/