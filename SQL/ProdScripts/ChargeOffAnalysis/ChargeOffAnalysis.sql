DROP TABLE IF EXISTS #COAccounts
;WITH CTE
AS
(
SELECT AccountNumber, PostTime, TranID,
ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY PostTime) COCount
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCARD_Primary C1 WITH (NOLOCK) 
WHERE CMTTranType = '51'
)
SELECT C2.AccountNumber, C2.PostTime, C2.TranID, 
DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(C2.PostTime) AS DATETIME)) CycleDate,
DATEADD(SECOND, 86397,TRY_CAST(TRY_CAST(C2.PostTime AS DATE) AS DATETIME)) BusinessDay
INTO #COAccounts
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCARD_Primary C1 WITH (NOLOCK)
RIGHT JOIN CTE C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTranType = 'RCLS') 
WHERE C1.AccountNumber IS NULL
AND COCount = 1
--381223
--392358

--SELECT T.*, COALESCE(A.CycleDueDTD, B.CycleDueDTD) CycleDueDTD, COALESCE(A.daysDelinquent,B.daysDelinquent) daysDelinquent
SELECT T.*, A.CycleDueDTD, A.daysDelinquent
FROM #COAccounts T
LEFT JOIN AccountInfoForreport A WITH (NOLOCK) ON (T.AccountNumber = A.AccountNumber AND T.BusinessDay = A.BusinessDay)
--LEFT JOIN AccountInfoForReport_SwitchOut B WITH (NOLOCK) ON (T.AccountNumber = B.AccountNumber AND T.BusinessDay = B.BusinessDay)
WHERE DATEADD(SS, 2, PostTime) < CycleDate AND DATEADD(SS, 4, PostTime) < CycleDate
ORDER BY BusinessDay DESC

SELECT T.*, A.CycleDueDTD, A.daysDelinquent
FROM #COAccounts T
LEFT JOIN AccountInfoForReport_SwitchOut a WITH (NOLOCK) ON (T.AccountNumber = A.AccountNumber AND T.BusinessDay = A.BusinessDay)
WHERE DATEADD(SS, 2, PostTime) < CycleDate AND DATEADD(SS, 4, PostTime) < CycleDate
ORDER BY BusinessDay DESC


SELECT COUNT(1)
FROM CCARD_Primary C1 WITH (NOLOCK) 
WHERE CMTTranType = '51'
--401484

SELECT COUNT(1)
FROM CCARD_Primary C1 WITH (NOLOCK) 
WHERE CMTTranType = 'RCLS'
--9126

SELECT * FROM sys.tables WHERE NAME LIKE '%AccountInfoForreport%'









SELECT acctID, AccountNumber, UniversalUniqueID FROM BSegment_Primary WITH (NOLOCK)
WHERE acctID IN (587349, 6110273, 2821830, 14811685, 4495723, 16047033, 4727853)
--587349, 6110273, 2821830, 14811685, 4495723, 16047033, 4727853

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 587349
AND BusinessDay BETWEEN '2022-03-16 23:59:57' AND '2022-06-30 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 2821830
AND BusinessDay BETWEEN '2022-08-31 23:59:57' AND '2023-03-10 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD , SystemChargeOffStatus, UserChargeOffStatus
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 4495723
AND BusinessDay BETWEEN '2022-12-21 23:59:57' AND '2023-02-28 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 4727853
AND BusinessDay BETWEEN '2022-01-20 23:59:57' AND '2022-05-31 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 6110273
AND BusinessDay BETWEEN '2022-06-24 23:59:57' AND '2023-01-31 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 14811685
AND BusinessDay BETWEEN '2022-08-28 23:59:57' AND '2022-11-30 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 16047033
AND BusinessDay BETWEEN '2022-08-11 23:59:57' AND '2023-02-28 23:59:57'
ORDER BY BusinessDay DESC

/*

587349	1100011105831626   	5d370930-13a6-43c4-bdcd-0c277c4e9b44 -- 3/17 - 6/30
2821830	1100011128299306   	b77dbcd4-6390-4dc1-8854-abf37833cf4c -- 8/31 - 2/28
4495723	1100011135054512   	54642eaf-e46c-4f3a-b471-d67c1e606385 --12/21 - 2/22
4727853	1100011136638818   	f1442bbc-a0dd-4cef-af3f-3a8ec0e52131 -- 1/20 - 5/31
6110273	1100011139835015   	6edea634-9cb0-47c5-909e-837da3d3a530 -- 6/24 - 1/31
14811685	1100011165100177   	0d84fdf2-401c-4966-ac4a-c3b75eefc8e7 -- 8/28 - 11/30
16047033	1100011169919234   	2a73c1f5-eade-4cb7-b688-800bed4c56a4 --8/11 - 2/28

*/
/*
'b6d18cf3-9892-4ffe-8353-8f4eed7634b1',
'fba40b99-e988-4b5c-8290-2b054051c38d',
'79cc6072-6371-49f1-be39-2a70e7504690',
'9343a098-8027-4d28-906f-1f3f07f35e61'
*/

SELECT acctID, AccountNumber, UniversalUniqueID FROM BSegment_Primary WITH (NOLOCK)
WHERE UniversalUniqueID IN ('b6d18cf3-9892-4ffe-8353-8f4eed7634b1',
'fba40b99-e988-4b5c-8290-2b054051c38d',
'79cc6072-6371-49f1-be39-2a70e7504690',
'9343a098-8027-4d28-906f-1f3f07f35e61')

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD, SystemChargeOffStatus, UserChargeOffStatus 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 20259915
AND BusinessDay BETWEEN '2022-05-26 23:59:57' AND '2022-07-31 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 19089479
AND BusinessDay BETWEEN '2022-03-02 23:59:57' AND '2022-08-31 23:59:57'
ORDER BY BusinessDay DESC

SELECT BusinessDay, BSacctID, AccountNumber, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, CycleDueDTD 
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSAcctID = 18286471
AND BusinessDay BETWEEN '2022-03-02 23:59:57' AND '2022-05-31 23:59:57'
ORDER BY BusinessDay DESC

/*
20259915	1100011192783789   	9343a098-8027-4d28-906f-1f3f07f35e61 -- 5/26/22 - 7/31/22
19089479	1100011188105211   	b6d18cf3-9892-4ffe-8353-8f4eed7634b1 -- 2/3/22 - 8/31/22
18286471	1100011183419989   	fba40b99-e988-4b5c-8290-2b054051c38d -- 2/2/22 - 5/31/22

*/