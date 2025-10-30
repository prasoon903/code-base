SELECT BSAcctid, CP.ARTxnType, CP.CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator,CP.RevTgt,CP.CaseID,CP.TxnCode_Internal,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CS.Amount5,CS.InvoiceNumber, InstitutionID
--, CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 3981136) 
AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA'))
AND CP.TxnSource NOT IN ('4','10')
AND CP.MemoIndicator IS NULL
ORDER BY CP.PostTime DESC


SELECT TOP 100 TxnIsFor,BSAcctid, CP.ARTxnType, CP.CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, 
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.PostingRef, CP.MemoIndicator,CP.RevTgt,CP.CaseID,CP.TxnCode_Internal,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, InstitutionID
--, CP.*
FROM CCard_Primary CP WITH (NOLOCK)
WHERE --CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 3981136) AND 
CP.CMTTRANTYPE IN ('*SCR')
ORDER BY CP.PostTime DESC
