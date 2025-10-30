 INSERT INTO CreateNewSingleTransactionData
(TxnAcctId, AccountNumber, ATID, CMTTranType, TxnCode_Internal, TransactionDescription, TransactionAmount)
VALUES
(14551537, '1100001000001698', 51, 'ReageTot', 'Reage Tr', 'ReageTotalDueAmount', 225),
(40755609, '1100001000001698', 52, 'ReageTot', 'Reage Tr', 'ReageTotalDuePercent', 75),
(40755611, '1100001000001698', 52, 'ReageTot', 'Reage Tr', 'ReageTotalDuePercent', 150)


-- INSERT INTO CreateNewSingleTransactionData
--(TranTime, PostTime, TxnAcctId, CMTTranType, TransactionDescription,
--TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, PrimaryCurrencyCode,
--TxnSource, ArTxnType, creditplanmaster, ATID, tranpriority)
--VALUES
--('2018-06-07 16:09:01.000','2018-06-07 16:09:01.000', 14551537, 'ReageTot','ReageTotalDueAmount',
--'Reage Tr',250, '1100001000001698','Transaction posted successfully','lclUnitedStates',
--'2','94',NULL,51,0)


UPDATE CCard_Primary SET StateStatus = 'Statemented', NoblobIndicator = 6, TxnIsFor = 0
WHERE TranID IN (1688595060097875971)

UPDATE CCard_Primary SET StateStatus = 'Statemented', NoblobIndicator = 6, TxnIsFor = 0, TranRef = 1688595060021395459
WHERE TranID IN (1688595060097875972,1688595060097875973)



--TRUNCATE TABLE CreateNewSingleTransactionData

EXEC USP_CreateNewSingleTransactionData 53, 6969, 100

SELECT TranID, * FROM CreateNewSingleTransactionData


EXEC USP_CreateNewSingleTransaction



SELECT BSAcctid, CP.CMTTRANTYPE, CP.ARTxnType, CP.TxnSource,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CS.ProfileIDatAutoReage, CS.ReageTrigger
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 14551537) 
--AND CP.TxnAcctId = 5088 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
ORDER BY CP.PostTime DESC

SELECT 
CP.TranId, TranTime, CP.PostTime, TxnAcctId, CMTTranType, TransactionDescription,
CP.TxnCode_Internal, TransactionAmount, AccountNumber, PostingRef, CP.PrimaryCurrencyCode,
CP.StateStatus, TxnSource, ArTxnType, NoblobIndicator, TxnIsFor, creditplanmaster, ATID, CP.priority, TxnSrcAmt, 
TransactionStatus
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 14551537) 
--AND CP.TxnAcctId = 5088 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
ORDER BY CP.PostTime DESC


SELECT * FROM ErrorTNP

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId > 0


SELECT * FROM MonetaryTxnControl WITH (NOLOCK)