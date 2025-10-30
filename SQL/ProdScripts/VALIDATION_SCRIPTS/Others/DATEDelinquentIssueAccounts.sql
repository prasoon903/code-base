--DROP TABLE IF EXISTS #TempData
SELECT 
	BP.acctId, BP.AccountNumber, BP.UniversalUniqueID, ClientID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID
--INTO #TempData
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
INNER JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
WHERE CycleDueDTD < 2 AND DtOfLastDelinqCTD IS NOT NULL
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

SELECT * FROM Temp_Bsegment_DateDelinq WITH (NOLOCK)
SELECT * FROM CCGS_CoreAuth..Temp_Bsegment_DateDelinq WITH (NOLOCK)

SELECT JobStatus, COUNT(1) FROM Temp_Bsegment_DateDelinq WITH (NOLOCK) GROUP BY JobStatus
SELECT JobStatus, COUNT(1) FROM CCGS_CoreAuth..Temp_Bsegment_DateDelinq WITH (NOLOCK) GROUP BY JobStatus

SELECT JobStatus, ProcessTime, COUNT(1) FROM Temp_Bsegment_DateDelinq WITH (NOLOCK) GROUP BY JobStatus, ProcessTime


SELECT 
	RTRIM(TBD.AccountNumber) AccountNumber, TBD.UniversalUniqueID, BS.ClientID
FROM Temp_BSegment_DateDelinq TBD WITH (NOLOCK)
INNER JOIN BSegment_Secondary BS WITH (NOLOCK) ON (TBD.acctId = BS.acctId)
--WHERE JobStatus = 1
UNION ALL
SELECT 
	RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID, BS.ClientID
--INTO #TempData
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
INNER JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
WHERE BP.acctId IN (2316467, 3662527)

SELECT * FROM CCGS_CoreAuth..Temp_Bsegment_DateDelinq WITH (NOLOCK) WHERE ProcessTime IS NULL
SELECT * FROM Temp_Bsegment_DateDelinq WITH (NOLOCK) WHERE JobStatus = 1


SELECT * FROM BSegment_Primary WITH (NOLOCK) WHERE UniversalUniqueId = '00a70974-8893-4c39-b341-ad648a716859'

--2316467, 3662527