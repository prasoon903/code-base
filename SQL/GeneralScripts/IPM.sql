
Select TOP 4 jobid Job,FileStatus,TotalTxnReceivedInFile,LastParsedMessageNumber,ErrorReason,FileSource,Date_Received,Retry,ATID,CreateExceptionFile,TimeTaken_Stage1ToStage2,
* FROM PP_CI..ClearingFiles with(NoLock) WHERE FileSource IN ('MASTERCARDIPM','IPMJSON') -- AND FileID LIKE '%IPMLocalBigFileNew_PLAT%'
order by jobid desc

SELECT PostingRef,CMTTranType,PostingFlag,AuthTranId,AccountNumber,PostTime, * 
FROM CCard_Primary WITH(NOLOCK)
WHERE TranId IN(SELECT CCArdTranid FROM IPMMaster WITH(NOLOCK) WHERE Jobid IN(112))


SELECT CP.AccountNumber,CS.SettlementDate,CP.TxnAcctId, CP.CMTTRANTYPE,CP.TxnAcctId, CP.Transactionidentifier, txnsource, CP.creditplanmaster, 
CP.TransactionAmount,CP.NoBlobIndicator,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt, CP.PaymentCreditFlag,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.CardAcceptorIdCode, 
CP.TransactionDescription, FeesAcctID, CP.CPMgroup, CS.InvoiceNumber, CP.InstitutionID, CP.HostMachineName
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN 
(SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 14551547) 
--AND CP.TxnAcctId = 5060 --AND CP.MemoIndicator IS NULL
ORDER BY CP.PostTime DESC

SELECT  tpyNAD,tpyLAD, tpyBlob,ECardType, ESecCardType, ManualCardStatus, ccinhparent125AID,* FROM EmbossingAccounts WITH (NOLOCK) WHERE parent01AID = 14551547

--UPDATE EmbossingAccounts SET ccinhparent125AID = 8, FraudEffectiveDate = '2018-05-15 19:00:37.000' WHERE parent01AID = 14551547

select PP_CI..EmbossingAccounts.PrimaryAccountNumber, PP_CI..EmbossingAccounts.parent05ATID, 
PP_CI..EmbossingAccounts.parent05AID, PP_CI..EmbossingAccounts.ccinhparent125AID, 
PP_CI..EmbossingAccounts.ccinhparent125ATID, PP_CI..EmbossingAccounts.FraudEffectiveDate, 
PP_CI..EmbossingAccounts.FraudEffectiveTime, PP_CI..EmbossingAccounts.FraudLocation, 
PP_CI..EmbossingAccounts.FraudMemo, PP_CI..EmbossingAccounts.FraudReportDate, 
PP_CI..EmbossingAccounts.FraudReportTime, PP_CI..EmbossingAccounts.SystemStatus, 
PP_CI..EmbossingAccounts.ATID, PP_CI..EmbossingAccounts.Pan_Hash, 
PP_CI..EmbossingAccounts.PrimaryAccountNumber, PP_CI..EmbossingAccounts.Pan_Hash
from  PP_CI..EmbossingAccounts  with ( nolock )
where
((PP_CI..EmbossingAccounts.Pan_Hash = 821891324) AND (PP_CI..EmbossingAccounts.CardNumber4Digits = '2325'))

SELECT SettlementDate,* FROM LogArTxnAddl WITH (NOLOCK) WHERE TranID = 1382913533799104512

SELECT * FROM BatchAccounts

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId = 1382913533799104512

--UPDATE CCard_Primary SET TranTime = '2018-05-15 19:08:37.000'

SELECT * FROM IPMMaster

SELECT * FROM IPMMasterInterim