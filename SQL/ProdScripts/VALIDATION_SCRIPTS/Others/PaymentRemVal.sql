--SELECT 'UPDATE BSegmentCreditCard SET AccountGraceStatus = ''T'' WHERE acctId = ' + TRY_CAST(AccountID AS VARCHAR) FROM #BSDetails

--SELECT acctId AccountID INTO #BSDetails FROM ##BS

SELECT 'BSegment===> ', 'UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = ''T'' WHERE acctId = ' + TRY_CAST(AccountID AS VARCHAR) 
FROM BSegmentCreditCard CA WITH (NOLOCK)
JOIN #BSDetails TT ON (CA.acctId = TT.AccountID)
WHERE  AccountGraceStatus = 'R'
ORDER BY CA.acctId

SELECT 'StatementHeader===> ', 'UPDATE TOP(1) StatementHeader SET AccountGraceStatus = ''T'' WHERE acctId = ' + TRY_CAST(AccountID AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(StatementID AS VARCHAR)
FROM StatementHeader CA WITH (NOLOCK)
JOIN #BSDetails TT ON (CA.acctId = TT.AccountID)
WHERE  AccountGraceStatus = 'R' AND StatementDate = '2021-07-31 23:59:57.000'
ORDER BY CA.acctId

SELECT 'CPSgment===> ', 'UPDATE TOP(1) CPSgmentCreditCard SET AccountGraceStatus = ''T'', TrailingInterestDate = NULL WHERE acctId = ' + TRY_CAST(CA.acctId AS VARCHAR) + ' -- AccountID: ' + TRY_CAST(CA.parent02AID AS VARCHAR)
FROM CPSgmentAccounts CA WITH (NOLOCK)
JOIN CPSgmentCreditCard CP WITH (NOLOCK) ON (CA.acctId = CP.acctId)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0'
ORDER BY CA.parent02AID

SELECT 'SummaryHeader===> ', 'UPDATE TOP(1) SummaryHeaderCreditCard SET AccountGraceStatus = ''T'', GraceDaysStatus = 1 WHERE acctId = ' + TRY_CAST(CA.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(CA.StatementID AS VARCHAR) + ' -- AccountID: ' + TRY_CAST(CA.parent02AID AS VARCHAR)
FROM SummaryHeader CA WITH (NOLOCK)
JOIN SummaryHeaderCreditCard CP WITH (NOLOCK) ON (CA.acctId = CP.acctId AND CA.StatementID = CP.StatementID)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0' 
AND StatementDate = '2021-07-31 23:59:57.000'
ORDER BY CA.parent02AID


SELECT 'CurrentSummaryHeader===> ', 'UPDATE TOP(1) CurrentSummaryHeader SET AccountGraceStatus = ''T'', GraceDaysStatus = 1 WHERE acctId = ' + TRY_CAST(CA.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(CA.StatementID AS VARCHAR) + ' -- AccountID: ' + TRY_CAST(CA.parent02AID AS VARCHAR)
FROM SummaryHeader CA WITH (NOLOCK)
JOIN CurrentSummaryHeader CP WITH (NOLOCK) ON (CA.acctId = CP.acctId AND CA.StatementID = CP.StatementID)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0' 
AND CA.StatementDate = '2021-07-31 23:59:57.000'
ORDER BY CA.parent02AID




SELECT 'BSegment===> ', COUNT(1) 
FROM BSegmentCreditCard CA WITH (NOLOCK)
JOIN #BSDetails TT ON (CA.acctId = TT.AccountID)
WHERE  AccountGraceStatus = 'R'

SELECT 'StatementHeader===> ', COUNT(1) 
FROM StatementHeader CA WITH (NOLOCK)
JOIN #BSDetails TT ON (CA.acctId = TT.AccountID)
WHERE  AccountGraceStatus = 'R' AND StatementDate = '2021-07-31 23:59:57.000'

SELECT 'CPSgment===> ', COUNT(1) 
FROM CPSgmentAccounts CA WITH (NOLOCK)
JOIN CPSgmentCreditCard CP WITH (NOLOCK) ON (CA.acctId = CP.acctId)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0'

SELECT 'SummaryHeader===> ', COUNT(1) 
FROM SummaryHeader CA WITH (NOLOCK)
JOIN SummaryHeaderCreditCard CP WITH (NOLOCK) ON (CA.acctId = CP.acctId AND CA.StatementID = CP.StatementID)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0' 
AND StatementDate = '2021-07-31 23:59:57.000'


SELECT 'CurrentSummaryHeader===> ', COUNT(1) 
FROM SummaryHeader CA WITH (NOLOCK)
JOIN CurrentSummaryHeader CP WITH (NOLOCK) ON (CA.acctId = CP.acctId AND CA.StatementID = CP.StatementID)
JOIN #BSDetails TT ON (CA.parent02AID = TT.AccountID)
WHERE AccountGraceStatus = 'R' 
--AND  CreditPlanType = '0' 
AND CA.StatementDate = '2021-07-31 23:59:57.000'


--CREATE Table #BSDetails (AccountID VARCHAR(64))
--INSERT INTO #BSDetails VALUES
--(115284),
--(245235),
--(323788),
--(333415),
--(335646),
--(565270),
--(607293),
--(862528),
--(1052295),
--(1061486),
--(1103400),
--(1189643),
--(1190456),
--(1206202),
--(1213965),
--(1217410),
--(1353291),
--(1420839),
--(1491614),
--(1626346),
--(1658581),
--(1924420),
--(1980593),
--(2051747),
--(2362917),
--(2414483),
--(2419193),
--(2458156),
--(2481094),
--(2618402),
--(2651492),
--(2653848),
--(2782422),
--(2785312),
--(2809293),
--(2908970),
--(2950773),
--(3426946),
--(3520429),
--(3564484),
--(3932776),
--(4123351),
--(4127047),
--(4256940),
--(4327812),
--(4494759),
--(4705367),
--(4847265),
--(4895584),
--(4941741),
--(5578016),
--(5714890),
--(6975124),
--(9047491),
--(9455408),
--(9868645),
--(11946498),
--(12103991),
--(12386882),
--(12482750),
--(12710375),
--(12847707),
--(13947697),
--(14875970),
--(15333467),
--(15473329),
--(15929064),
--(16052197),
--(16059660),
--(16251112),
--(16823292),
--(17295555),
--(17301734),
--(17541200),
--(18059926)