--SELECT AccountNumber, BSAcctID, TranID, TranTime, PostTime, CMTTranType, TransactionAmount, TransactionDescription, 
--ArTxnType, TxnSource, TxnAcctId, ClaimID, TranRef, RevTgt, MemoIndicator, NoblobIndicator, CreditPlanMaster, MergeActivityFlag
--INTO #TempTxns
--FROM CCard_Primary WITH (NOLOCK)
--WHERE PostTime BETWEEN '2023-10-17' AND '2023-11-18'
--AND TranTime < '2021-05-31 23:59:57'

SELECT * FROM #TempTxns WHERE CMTTRanType NOT IN ('121', '135')

--99032713446 - 35422178
--99376668094 - 50520402

SELECT CreditPlanType,* FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = 16565733

SELECT AccountNumber, BSAcctID, TranID, TranTime, PostTime, CMTTranType, TransactionAmount, DateTimeLocalTransaction, TransactionDescription, 
ArTxnType, TxnSource, TxnAcctId, ClaimID, TranRef, RevTgt, MemoIndicator, NoblobIndicator, CreditPlanMaster, MergeActivityFlag
FROM CCard_Primary WITH (NOLOCK)
WHERE TranRef = 99032713446

SELECT * FROM CurrentSummaryHeader WITH (NOLOCK) WHERE acctID = 35422178 AND StatementDate > '2021-02-28 23:59:57' ORDER BY StatementDate

SELECT AmtOfInterestCTD,* FROM SummaryHeader WITH (NOLOCK) WHERE acctID = 35422178 AND StatementDate > '2021-02-28 23:59:57' ORDER BY StatementDate

SELECT AccountNumber, BSAcctID, TranID, TranTime, PostTime, CMTTranType, TransactionAmount, DateTimeLocalTransaction, TransactionDescription, 
ArTxnType, TxnSource, TxnAcctId, ClaimID, TranRef, RevTgt, MemoIndicator, NoblobIndicator, CreditPlanMaster, MergeActivityFlag
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011157255906'
AND PostTime BETWEEN '2021-02-28 23:59:57' AND '2021-05-31 23:59:57'
AND CMTTRanType IN ('02', '03')
ORDER BY PostTime


SELECT AccountNumber, BSAcctID, TranID, TranTime, PostTime, CMTTranType, TransactionAmount, DateTimeLocalTransaction, TransactionDescription, 
ArTxnType, TxnSource, TxnAcctId, ClaimID, TranRef, RevTgt, MemoIndicator, NoblobIndicator, CreditPlanMaster, MergeActivityFlag
FROM CCard_Primary WITH (NOLOCK)
WHERE TranRef = 99376668094 
ORDER BY DateTimeLocalTransaction


SELECT * FROM CurrentSummaryHeader WITH (NOLOCK) WHERE acctID = 50520402 AND StatementDate > '2021-03-31 23:59:57' ORDER BY StatementDate

SELECT AmtOfInterestCTD,* FROM SummaryHeader WITH (NOLOCK) WHERE acctID = 50520402 AND StatementDate > '2021-03-31 23:59:57' ORDER BY StatementDate

SELECT AccountNumber, BSAcctID, TranID, TranTime, PostTime, CMTTranType, TransactionAmount, DateTimeLocalTransaction, TransactionDescription, 
ArTxnType, TxnSource, TxnAcctId, ClaimID, TranRef, RevTgt, MemoIndicator, NoblobIndicator, CreditPlanMaster, MergeActivityFlag
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011171305786'
AND PostTime BETWEEN '2021-03-31 23:59:57' AND '2021-05-31 23:59:57'
AND CMTTRanType IN ('02', '03')
ORDER BY PostTime 