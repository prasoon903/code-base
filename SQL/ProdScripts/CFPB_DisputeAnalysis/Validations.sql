DROP TABLE IF EXISTS #TempRecords
SELECT AccountNumber, acctID, InterestAtCycle, APR, StatementDate, SystemStatus, ManualStatus
INTO #TempRecords
FROM ##Final_AllAccounts
WHERE RecordType = 'ImpactedRecords'

SELECT COUNT(DISTINCT AccountUUID) FROM ##TempRawData

SELECT COUNT(DISTINCT AccountUUID) FROM ##Final_AllAccounts

SELECT * FROM ##TempRawData

SELECT * FROM ##Final_AllAccounts WHERE MinClearingDate < '2020-06-30 23:59:57'

SELECT * FROM ##Final_AllAccounts WHERE acctid = 21507933 ORDER BY RecordNumber

SELECT T1.*
FROM ##Final_AllAccounts T1
JOIN ##Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber = T2.RecordNumber-1)
WHERE T1.RecordType = 'ImpactedRecords'
AND T1.ProjectedDQ - T2.ProjectedDQ > 1
AND T1.OriginalDQ - T2.OriginalDQ <= 1

;WITH CTE
AS
(
SELECT DISTINCT acctID, ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck 
FROM ##Final_AllAccounts
WHERE 
--MinClearingDate >= '2020-06-30 23:59:57'
--AND
(
ImpactedStatement = 'YES' OR 
PHPImpact = 'YES' OR
PHPImpactWithStatusCheck = 'YES')
)
SELECT ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck , COUNT(1) RecordCount
FROM CTE 
GROUP BY ImpactedStatement, PHPImpact, PHPImpactWithStatusCheck




SELECT * FROM ##Final_AllAccounts WHERE AmountOfTotalDue_Proj > SRB_Calc AND AmountOfTotalDue_Proj > 0 
SELECT * FROM ##Final_AllAccounts WHERE AmountOfTotalDue_Proj > MAX(SRB_Calc, 0) AND AmountOfTotalDue_Proj > 0  

DROP TABLE IF EXISTS #StatementData
SELECT T.*, S.AmtOfInterestCTD
INTO #StatementData
FROM SummaryHeader  S WITH (NOLOCK)
JOIN #TempRecords T ON (S.parent02AID = T.acctID AND S.StatementDate = T.StatementDate)
WHERE S.CreditPlanType = '0'

SELECT *
FROM #StatementData
WHERE InterestAtCycle <> AmtOfInterestCTD
ORDER BY acctID, StatementDate

SELECT SH.acctID, SH.CreditPlanType, SH.StatementDate, CSH.InterestAtCycle, SH.AmtOfInterestCTD SH_AmtOfInterestCTD, CSH.AmtOfInterestCTD CSH_AmtOfInterestCTD
FROM SummaryHeader SH WITH (NOLOCK)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementDate = CSH.StatementDate)
WHERE SH.CreditPlanType = '0'
AND parent02AID = 21955379
AND SH.StatementDate = '2023-02-28 23:59:57.000'

SELECT TransactionAmount, TransactionDescription,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '11000112106005717'
AND CMTTRANTYPE = '02'
AND PostTime BETWEEN '2023-01-31 23:59:57.000' AND '2023-02-28 23:59:57.000'


DROP TABLE IF EXISTS #CCardData
SELECT T.*, CP.TransactionAmount, CP.NoblobIndicator, CP.TxnSource
INTO #CCardData
FROM CCard_Primary Cp WITH (NOLOCK)
JOIN #TempRecords T ON (CP.AccountNumber = T.AccountNumber AND CP.PostTime = T.StatementDate)
WHERE CP.CMTTRANTYPE = '02'

SELECT *
FROM #CCardData
WHERE TxnSource <> '4'

SELECT *
FROM #CCardData
WHERE InterestAtCycle <> TransactionAmount



SELECT SH.parent02AID, SH.acctID, SH.StatementDate, SH.CreditPlanType, SH.Currentbalance, SHC.CurrentBalanceCO, SRBWithInstallmentDue, EqualPaymentAmt, AmountOfTotalDue, CycleDueDTD
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHC WITH (NOLOCK) ON (SH.acctID = SHC.acctID AND SH.StatementDate = SHC.StatementDate)
WHERE parent02AID = 4871648
AND SH.StatementDate = '2021-05-31 23:59:57.000'

SELECT acctID, AccountNumber, StatementDate, Currentbalance, CurrentBalanceCO, SRBWithInstallmentDue, CycleDueDTD, AmountOfTotalDue, ccinhparent125AID, SystemStatus 
FROM StatementHeader WITH (NOLOCK) WHERE acctID = 4871648 AND StatementDate = '2021-05-31 23:59:57.000'

SELECT CMTTRANTYPE, TransactionAmount,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011113109171'
AND CMTTRANTYPE IN ('02')
AND PostTime BETWEEN '2019-08-31 23:59:57.000' AND '2020-03-31 23:59:57.000'
ORDER BY PostTime DESC

SELECT InterestAtCycle, SH.AmtOfInterestCTD, CreditPlanType, *
FROM SummaryHeader Sh WITH (NOLOCK)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementDate = CSH.StatementDate)
WHERE SH.parent02AID = 1314514
AND SH.CreditPlanType = '0'
AND SH.StatementDate BETWEEN '2019-08-31 23:59:57.000' AND '2020-03-31 23:59:57.000'
ORDER BY SH.StatementDate DESC


SELECT *
FROM sys.columns
WHERE name LIKE '%Port%'
AND OBJECT_NAME(OBJECT_ID) = 'StatementHeaderEX'

SELECT StatementFlag,*
FROM StatementHeader WITH (NOLOCK)
WHERE acctID = 660906
ORDER BY StatementDate DESC

SELECT StatementDate, PortfolioID, COUNT(1)
FROM StatementHeaderEX WITH (NOLOCK)
WHERE StatementDate > '2024-12-31 23:59:57'
GROUP BY StatementDate, PortfolioID
ORDER BY StatementDate DESC
