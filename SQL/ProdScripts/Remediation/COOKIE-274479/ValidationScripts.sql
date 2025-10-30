SELECT * FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT T.*, RTRIM(AccountNumber) AccountNumber, acctID, SystemStatus, ccinhparent125AID, MergeInProcessPH
INTO #TempRecords
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN #TempData T ON (T.AccountUUID = BP.UniversalUniqueID)

SELECT * FROM #TempRecords 
WHERE acctID = 1236634
ORDER BY acctID 

SELECT T1.* 
FROM #TempRecords T1
LEFT JOIN BSegment_MStatuses B WITH (NOLOCK) ON (T1.acctID = B.acctID AND T1.Reason = B.StatusDescription AND B.IsDeleted = '0')
WHERE B.acctID IS NULL

SELECT 'UPDATE TOP(1) BSegment_MStatuses SET IsDeleted = ''1'', EndDate = GETDATE(), StatusReason = ''COOKIE-274479'' WHERE Skey = ' + TRY_CAST(B.Skey AS VARCHAR(20))
FROM #TempRecords T1
JOIN BSegment_MStatuses B WITH (NOLOCK) ON (T1.acctID = B.acctID AND T1.Reason = B.StatusDescription AND B.IsDeleted = '0')

SELECT B.*
FROM #TempRecords T1
JOIN BSegment_MStatuses B WITH (NOLOCK) ON (T1.acctID = B.acctID AND T1.Reason = B.StatusDescription AND B.IsDeleted = '1' AND StatusReason = 'COOKIE-274479')


SELECT *
FROM BSegment_MStatuses WITH (NOLOCK)
WHERE acctID = 2032277
--AND IsDeleted = '0'
ORDER BY Skey DESC

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData (AccountUUID VARCHAR(64), reason VARCHAR(100))
INSERT INTO #TempData
SELECT '34552504-3f60-4c41-9d61-b9a16d710116','Deceased'
UNION ALL SELECT 'e7e82fe5-426f-483d-961d-f6a7fc31ed8a','Closed by Customer and Blocked'
UNION ALL SELECT 'b498b337-c9ae-43f7-85fb-d07f74e976f3','Indirect CBD'
UNION ALL SELECT '3a794ec3-f711-4f6c-8006-ab5468e1b9cb','Closed by Customer and Blocked'
UNION ALL SELECT 'aaa9445d-cf7d-4cfe-93b6-9719e2f1d3fb','Do Not Call'
UNION ALL SELECT '6fc2604b-2ca4-4381-8564-d3a47944268c','Closed By Customer'
UNION ALL SELECT '1b2f61de-9032-49c4-b7c2-222d6e6d7f10','Bankruptcy No Payments'
UNION ALL SELECT '62e07513-a6b1-44f9-bf74-f54f3c23fc7b','Debt Validation'
UNION ALL SELECT 'a6a0fdfb-c036-40d3-9488-cff55ef03e0c','Indirect CBD'
UNION ALL SELECT '51f9c24b-06d0-40e5-8bd9-0a8752fbfea2','SCRA'
UNION ALL SELECT '684206c7-0a3f-4323-bd65-aa0c8e6c1bb7','Cease and Desist'
UNION ALL SELECT 'f7048201-7fb7-4d05-8642-1d39693311fe','Debt Validation'
UNION ALL SELECT '5afc2dcb-5167-4345-8a14-98fc33e526bd','Bankruptcy No Payments'
UNION ALL SELECT '5afc2dcb-5167-4345-8a14-98fc33e526bd','Pending Bankruptcy'
UNION ALL SELECT 'f831beaf-8487-4ac1-b484-28541daf35d2','Bankruptcy with Payments'
UNION ALL SELECT '280dcb94-8794-41ee-9b56-d834ffffdc63','Closed by Customer and Blocked'
UNION ALL SELECT '95f3be5a-07b8-448a-b156-798bd02bbbc5','Closed by Customer and Blocked'
UNION ALL SELECT 'b159dce1-fa03-4c43-9f00-3e9a75fe4a3d','Blocked'
UNION ALL SELECT '73d39263-7bd3-46a2-9187-4faa53793009','Closed by Customer and Blocked'
UNION ALL SELECT '7d89b662-2902-4a2b-8033-56b5c5266d4d','Closed by Customer and Blocked'
UNION ALL SELECT '4979bd4a-bbdd-4c12-b4e8-0c7082c3989a','Closed By Issuer Other'
UNION ALL SELECT '1badb39e-3722-42c8-9a09-2bfadec60832','Deceased'
UNION ALL SELECT '84e14e9d-b924-4368-b74c-b5469fabb1d5','Bankruptcy No Payments'
UNION ALL SELECT '36fd5473-85be-4c17-aca4-1ade264f2e9d','Closed by Customer and Blocked'