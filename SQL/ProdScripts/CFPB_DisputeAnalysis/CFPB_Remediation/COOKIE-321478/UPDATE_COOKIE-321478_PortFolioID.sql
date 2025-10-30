DROP TABLE IF EXISTS #AccountData
SELECT B.acctID, B.AccountNumber, T.AccountUUID, DATEADD(SS, 86397, T.StatementDate) StatementDate
INTO #AccountData
FROM CBRPHPUpdate_COOKIE_321478 T
JOIN BSegment_Primary B WITH (NOLOCK) ON (T.AccountUUID = B.UniversalUniqueID)


UPDATE SH
SET PortfolioID = 1
FROM StatementHeaderEX SH
JOIN #AccountData A ON (A.acctID = SH.acctID AND A.StatementDate = SH.StatementDate)



/*
--VALIDATION

SELECT A.*, SH.PortfolioID
FROM StatementHeaderEX SH WITH (NOLOCK)
JOIN #AccountData A ON (A.acctID = SH.acctID AND A.StatementDate = SH.StatementDate)

*/