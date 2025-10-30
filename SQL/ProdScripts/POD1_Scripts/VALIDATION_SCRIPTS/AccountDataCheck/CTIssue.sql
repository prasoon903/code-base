SELECT BSAcctid, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionDescription,CP.TxnAcctId, txnsource, CP.creditplanmaster, --EqualPayments, 
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.MemoIndicator,CP.RevTgt
FROM CCard_Primary CP WITH (NOLOCK)
--LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId /*AND CP.TxnSource = 29 AND CP.CMTTRANTYPE = '40'*/)
WHERE CP.AccountNumber IN ('1100011120424571') 
--AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR', '40')
--AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR'))
--AND CP.TxnSource NOT IN ('4','10')
--AND CP.MemoIndicator IS NULL
--AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
--AND CP.PostTime >= '2021-10-31'
--AND CP.PostTime <= '2021-11-30'
--AND CMTTranType in ('21','22')
--AND CP.TxnAcctId = 25496592
ORDER BY CP.POSTTIME DESC