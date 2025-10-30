DROP TABLE IF EXISTS #PostedRetailTxns
SELECT AccountNumber, BSAcctID, TxnAcctID, TranID, TranTime, PostTime, TransactionAmount, CreditPlanMaster, RMATranUUID
INTO #PostedRetailTxns
FROM CCArd_primary WITH (NOLOCK)
WHERE PostTime Between '2023-03-31 23:59:58' AND '2023-04-26 23:59:57'
AND CMTTranType = '40'
AND TxnSource = '29'

--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14633, 14733)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14634, 14734)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14635, 14735)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14636, 14736)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14637, 14737)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14638, 14738)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14639, 14739)
--SELECT CreditPlanType, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID IN (14640, 14740)


--14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640
--14733, 14734, 14735, 14736, 14737, 14738, 14739, 14740

;WITH CTE
AS
(
SELECT CreditPlanMaster, COUNT(1) [COUNT]
FROM #PostedRetailTxns
GROUP BY CreditPlanMaster
HAVING CreditPlanMaster IN (14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640)
--ORDER BY COUNT(1) DESC
)
SELECT SUM([COUNT]) FROM CTE

SELECT CreditPlanMaster, COUNT(1) [COUNT]
FROM #PostedRetailTxns
GROUP BY CreditPlanMaster
HAVING CreditPlanMaster IN (14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640)
ORDER BY COUNT(1) DESC

;WITH CTE
AS
(
SELECT *
FROM #PostedRetailTxns
WHERE CreditPlanMaster IN (14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640)
)
SELECT BP.UniversalUniqueID AccountUUID, BS.ClientID, C.*
FROM CTE C
JOIN bsegment_Primary BP WITH (NOLOCK) ON (C.AccountNumber = BP.AccountNumber)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)


;WITH CTE
AS
(
SELECT *
FROM #PostedRetailTxns
WHERE CreditPlanMaster IN (14633, 14634, 14635, 14636, 14637, 14638, 14639, 14640)
)
SELECT C.*, CP.CurrentBalance
FROM CTE C
JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (C.TxnAcctID = CP.acctId)






--SELECT *
--FROM #PostedRetailTxns
--WHERE CreditPlanMaster = 13792