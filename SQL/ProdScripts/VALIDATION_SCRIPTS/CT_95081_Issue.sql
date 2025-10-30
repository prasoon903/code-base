SELECT JobStatus, MachineName, MsgIndicator,*
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAuthJobs A WITH (NOLOCK)
WHERE TranID = 2394245689

SELECT *
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.CoreAuthTransactions A WITH (NOLOCK)
WHERE TranID = 2394245689

SELECT JobStatus, MachineName, MsgIndicator,*
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAuthJobs A WITH (NOLOCK)
WHERE TranID = 2394245689


SELECT CurrentBalance, * FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011116822721'

SELECT CurrentBalance, * FROM LS_P1MARPRODDB01.ccgs_coreIssue.dbo.BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011116822721'


SELECT MessageTypeIdentifier,*
FROM LS_P1MARPRODDB01.ccgs_coreIssue.dbo.Auth_Primary A WITH (NOLOCK)
--WHERE CoreAuthTranID = 2394245689
WHERE AccountNumber = '1100011116822721'
AND PlanUUID = '3bab2bfb-c584-4764-9ee8-f450fdd59588'



SELECT 
A.uuid RMATranUUID, A.Request_ID, 
CASE 
	WHEN A.MTI = '9000' THEN 'INITIATE'
	WHEN A.MTI = '9100' THEN 'CREATE'
	WHEN A.MTI = '9200' THEN 'ACTIVATE'
	WHEN A.MTI = '9220' THEN 'REFUND'
	WHEN A.MTI = '9420' THEN 'CANCEL'
	ELSE 'NA'
	END
AS TransactionType,
A.MTI, A.Amount TransactionAmount, TransmissionDateTime, * 
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.CPMAccounts C WITH (NOLOCK) ON (A.Plan_ID = C.acctId AND C.CreditPlanType = '16')
WHERE B.AccountNumber = '1100011100562135' 
AND A.uuid = '042b2ed5-d949-41be-a711-f72afabc6e56' --AND A.MTI = 9200
AND APIErrorFound = 0
ORDER BY A.uuid, A.MTI


;with CTE 
AS
(
SELECT 
A.uuid RMATranUUID, A.Request_ID, 
CASE 
	WHEN A.MTI = '9000' THEN 'INITIATE'
	WHEN A.MTI = '9100' THEN 'CREATE'
	WHEN A.MTI = '9200' THEN 'ACTIVATE'
	WHEN A.MTI = '9220' THEN 'REFUND'
	WHEN A.MTI = '9420' THEN 'CANCEL'
	ELSE 'NA'
	END
AS TransactionType,
A.MTI, A.Amount TransactionAmount, TransmissionDateTime 
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.CPMAccounts C WITH (NOLOCK) ON (A.Plan_ID = C.acctId AND C.CreditPlanType = '16')
WHERE B.AccountNumber = '1100011116822721' 
AND APIErrorFound = 0
--AND A.uuid = '3bab2bfb-c584-4764-9ee8-f450fdd59588' --AND A.MTI = 9200
--ORDER BY A.uuid, A.MTI
)
SELECT TransactionType, COUNT(1) [COUNT]
FROM CTE 
GROUP BY TransactionType




;with CTE 
AS
(
SELECT 
A.uuid RMATranUUID, A.Request_ID, 
CASE 
	WHEN A.MTI = '9000' THEN 'INITIATE'
	WHEN A.MTI = '9100' THEN 'CREATE'
	WHEN A.MTI = '9200' THEN 'ACTIVATE'
	WHEN A.MTI = '9220' THEN 'REFUND'
	WHEN A.MTI = '9420' THEN 'CANCEL'
	ELSE 'NA'
	END
AS TransactionType,
A.MTI, A.Amount TransactionAmount, TransmissionDateTime 
FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN LS_P1MARPRODDB01.ccgs_coreauth.dbo.CPMAccounts C WITH (NOLOCK) ON (A.Plan_ID = C.acctId AND C.CreditPlanType = '16')
WHERE B.AccountNumber = '1100011116822721' 
AND A.MTI IN (9200, 9220)
AND APIErrorFound = 0
--ORDER BY A.uuid, A.MTI
)
, TransactionGroup AS
(
SELECT RMATranUUID, TransactionType, SUM(TransactionAmount)*CASE WHEN TransactionType = 'ACTIVATE' THEN 1 ELSE -1 END TransactionAmount
--, CASE WHEN TransactionType = 'ACTIVATE' THEN 1 ELSE -1 END TransactionType 
FROM CTE 
GROUP BY RMATranUUID, TransactionType
--ORDER BY RMATranUUID, TransactionType
)
SELECT RMATranUUID, SUM(TransactionAmount) TransactionAmount
FROM TransactionGroup
GROUP BY RMATranUUID
HAVING SUM(TransactionAmount) <> 0