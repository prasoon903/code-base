DROP TABLE IF EXISTS #TempData

; WITH PurgeTxn AS
(
	SELECT TranID, TranRef, CMTTranType 
	FROM CCArd_Primary WITH (NOLOCK)
	WHERE 
	PostTime > '2021-01-01' AND
	--ArTxnType = '93' AND
	--CMTTranType = '40' AND
	(CMTTranType = '88' OR CMTTranType = '89')
),
CCardData
AS
(
	SELECT BSAcctid, cardnumber4digits cardnumber4digitsOnTxn, rejectbatchacctid, fileName, PT.CMTTRANTYPE PurgeTranType, 
	CP.CMTTRANTYPE, CP.TransactionDescription, CP.TxnSource,CP.TxnAcctId,Trantime,CP.PostTime, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
	CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,CP.RevTgt,
	CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
	CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, 
	CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CP.UniversalUniqueid
	FROM CCard_Primary CP WITH (NOLOCK)
	LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
	JOIN PurgeTxn PT ON (CP.TranID = PT.TranRef)
	WHERE 
	CP.PostTime > '2021-01-01' AND
	--ArTxnType = '93' AND
	--CMTTranType = '40' AND
	TxnCode_Internal = '18355'
	--ORDER BY CP.PostTime DESC
)
SELECT 
CD.BSAcctId, BP.UniversalUniqueID AccountUUID, CD.TranID, CD.rejectbatchacctid, CD.fileName, CD.EmbAcctId, CD.cardnumber4digitsOnTxn, E.cardnumber4digits, E.acctid, E.ecardtype, E.eseccardtype, 
manualcardstatus.LutDescription manualcardstatusLutDescription, BatchDescription, PurgeTranType, CMTTRANTYPE, 
TransactionDescription, Trantime,PostTime, TransactionAmount,
E.UniversalUniqueid CardUUID,ccinhparent125aid.statusdescription CardStatus,systemstatus.statusdescription systemstatus,
manualcardstatus, CD.HostMachineName, CD.UniversalUniqueid TransactionUUID
INTO #TempData
FROM CCardData CD
LEFT JOIN EmbossingAccounts E with(nolock) ON (E.parent01AID = CD.BSAcctId AND E.acctId = CD.EmbAcctId AND E.ECardType=1)
LEFT JOIN Astatusaccounts ccinhparent125aid with(nolock) on (E.ccinhparent125aid=ccinhparent125aid.acctid)
LEFT JOIN Astatusaccounts systemstatus with(nolock) on (E.systemstatus=systemstatus.acctid)
LEFT JOIN BatchAccounts BA with(nolock) ON (BA.acctId = CD.rejectbatchacctid)
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (CD.BsacctId = BP.acctId)
LEFT JOIN CCARDLookup manualcardstatus  ON(manualcardstatus.LUTID='manualcardstatus' AND manualcardstatus.LutCode=E.manualcardstatus)
ORDER BY CD.BSAcctId, CD.PostTime DESC

SELECT 
	BSAcctId, AccountUUID, CardUUID, TransactionUUID, CardStatus, TransactionAmount, Trantime, PostTime
FROM #TempData-- WHERE rejectbatchacctid IS NULL


--SELECT * FROM BatchAccounts WITH(NOLOCK) WHERE acctId = 850968
                                                                                                                                                                      

/*

SELECT LT.ExcludeFlag,* 
FROM #TempData TT 
JOIN LogArTxnAddl LT WITH (NOLOCK) ON (TT.TranID = LT.TranID)
WHERE rejectbatchacctid IS NULL AND ArTxnType = 93

SELECT * FROM LogArTxnAddl LT WITH (NOLOCK) WHERE TranID = 34029981204

select top 10 E.acctid, E.ecardtype, E.eseccardtype,UniversalUniqueid,ccinhparent125aid.statusdescription ccinhparent125aid,systemstatus.statusdescription systemstatus,
manualcardstatus,manualcardstatus.LutDescription manualcardstatusLutDescription,
ReplacementReason,CardReplacedByAdminNo,
pan_hash,cardnumber4digits,ReplacementOrigCardStatus,ReplacementOrigCardAction
from EmbossingAccounts E with(nolock)
LEFT JOIN Astatusaccounts ccinhparent125aid with(nolock) on (E.ccinhparent125aid=ccinhparent125aid.acctid)
LEFT JOIN Astatusaccounts systemstatus with(nolock) on (E.systemstatus=systemstatus.acctid)
LEFT JOIN CCARDLookup manualcardstatus  ON(manualcardstatus.LUTID='manualcardstatus' AND manualcardstatus.LutCode=E.manualcardstatus)
where E.parent01aid=73598 --AND E.ECardType=0
order by acctid

--73598
--9762200


SELECT ecardtype, eseccardtype, * 
FROM EmbossingAccounts WITH (NOLOCK) WHERE parent01AID = 1635110

SELECT * from OPENQUERY([LS_ProdDrGsDB01], N'
select top 10 E.acctid, E.ecardtype, E.eseccardtype,UniversalUniqueid,ccinhparent125aid.statusdescription ccinhparent125aid,systemstatus.statusdescription systemstatus,
manualcardstatus,manualcardstatus.LutDescription manualcardstatusLutDescription,
ReplacementReason,CardReplacedByAdminNo,
pan_hash,cardnumber4digits,E.HoldEmbossing,ReplacementOrigCardStatus,ReplacementOrigCardAction
from ccgs_coreissue.dbo.EmbossingAccounts E with(nolock)
LEFT JOIN ccgs_coreissue.dbo.Astatusaccounts ccinhparent125aid with(nolock) on (E.ccinhparent125aid=ccinhparent125aid.acctid)
LEFT JOIN ccgs_coreissue.dbo.Astatusaccounts systemstatus with(nolock) on (E.systemstatus=systemstatus.acctid)
LEFT JOIN ccgs_coreissue.dbo.CCARDLookup manualcardstatus  ON(manualcardstatus.LUTID=''manualcardstatus'' AND manualcardstatus.LutCode=E.manualcardstatus)
where E.parent01aid=1635110
order by acctid
')

select CCInhParent125AID,SystemStatus FROM LS_ProdDrGsDB01.CCGS_CoreIssue.dbo.BSegment_Primary WITH (NOLOCK) WHERE AcctID = 1635110
select CCInhParent125AID,SystemStatus,* FROM LS_ProdDrGsDB01.CCGS_CoreIssue.dbo.EmbossingAccounts WITH (NOLOCK) WHERE Parent01AID = 1635110 AND ECardType = 0
select ManualCardStatus,* FROM LS_ProdDrGsDB01.CCGS_CoreIssue.dbo.AdditionalCard WITH (NOLOCK) WHERE EmbossingAID = 3334050

--SELECT * FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode = 'F4001'

*/