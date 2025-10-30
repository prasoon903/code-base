SELECT AmtOfAcctHighBalLTD,  CurrentBalance, CurrentBalanceCO, BSAcctId
INTO #HBIssue
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2023-09-06 23:59:57'
AND AmtOfAcctHighBalLTD < CurrentBalance+CurrentBalanceCO

SELECT T.*, CBRLastCalculatedDate 
FROM #HBIssue T
JOIN BSegment_Balances BB WITH (NOLOCK) ON (T.BSacctID=BB.acctID)
WHERE CBRLastCalculatedDate IS NOT NULL

SELECT * FROM BSegment_Balances WITH (NOLOCK) WHERE acctID = 2030689


SELECT AccountNumber FROM Bsegment_Primary WITH(NOLOCK) where acctid = 2030689
