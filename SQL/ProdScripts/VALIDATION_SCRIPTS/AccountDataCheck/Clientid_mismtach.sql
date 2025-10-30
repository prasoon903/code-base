
--WITH CTE 
--as
--(
--select  c.embacctid,bp.acctid , c.tranid ,bp.accountnumber,c.clientid,bs.clientid  bsclientid ,c.posttime,artxntype from ccard_primary c  with(nolock)  join  bsegment_Secondary bs with(nolock)
--  on (c.txnacctid  = bs.acctid )
--  join  BSegment_primary  bp with(nolock) on (bp.accountnumber = c.accountnumber)  where   c.cmttrantype = '21' and  c.posttime > '2021-11-30 23:59:57'
--  and rejectbatchacctid  is not null
--)
--select bsclientid,c.acctid,parent01aid  from  embossingaccounts e    with(nolock) join  CTE  c   with(nolock) on (e.parent01aid = c.acctid  and  embacctid  = e.acctid  )
--where c.embacctid is  null

--select txnacctid ,clientid,embacctid,transactionamount,* from ccard_primary with(nolock) where  accountnumber = '1100011145708065' and   cmttrantype = '21' --and rejectbatchacctid is not null 
--order by posttime  
----select * from embossingaccounts  with(nolock) where acctid =9337382 
----69bacab7-8a2a-4704-8a51-3430f1c6e87e
--select clientid,* from customer with(nolock) where bsacctid  = 9337382




--select  c.embacctid,bp.acctid , c.tranid ,bp.accountnumber,c.clientid,bs.clientid  bsclientid ,c.posttime,artxntype from ccard_primary c  with(nolock)  join  bsegment_Secondary bs with(nolock)
--  on (c.txnacctid  = bs.acctid )
--  join  BSegment_primary  bp with(nolock) on (bp.accountnumber = c.accountnumber)  where   c.cmttrantype = '21' and  c.posttime > '2021-11-30 23:59:57'
--  and rejectbatchacctid  is not null and  bs.clientid <> c.clientid 


  
DROP TABLE IF EXISTS #Mismatch
select  c.embacctid,bp.acctid , c.tranid ,bp.accountnumber BS_accountnumber,C.accountnumber CP_accountnumber,c.clientid,bs.clientid  bsclientid ,c.posttime,artxntype, TransactionAmount 
INTO #Mismatch 
from ccard_primary c  with(nolock)  join  bsegment_Secondary bs with(nolock)
  on (c.txnacctid  = bs.acctid )
  join  BSegment_primary  bp with(nolock) on (bp.accountnumber = c.accountnumber)  where   c.cmttrantype = '21' and  c.posttime > '2022-05-31 23:59:57'
  and rejectbatchacctid  is not null and  bs.clientid <> c.clientid 



  
SELECT *,
'UPDATE TOP(1) CCard_Primary SET ClientID = ''' + RTRIM(bsclientid) + '''  WHERE TranID = ' + TRY_CAST(TranID AS VARCHAR) [UPDATE_BS]
FROM #Mismatch

--UPDATE TOP(1) CCard_Primary SET ClientID = '5265019a-6a97-49cf-9019-142ce142cd67'  WHERE TranID = 54426355870
--UPDATE TOP(1) CCard_Primary SET ClientID = 'e0b72b58-188d-4cab-9d95-404e03b952e2'  WHERE TranID = 54426355885
--UPDATE TOP(1) CCard_Primary SET ClientID = '75d3456a-80a1-42d6-b44b-23ac95535353'  WHERE TranID = 54164297225
--UPDATE TOP(1) CCard_Primary SET ClientID = 'e5a4143f-508f-4d26-9fb7-5eade9639880'  WHERE TranID = 52673632751
--UPDATE TOP(1) CCard_Primary SET ClientID = 'a842d360-b7b9-41f8-85e9-e60ac2c985a9'  WHERE TranID = 52056995369

SELECT ClientID, EmbAcctId,*
FROM CCard_Primary WITH (NOLOCK)
WHERE TranID IN (57347598172,57347599424,57347595783,57347595784)


SELECT CP.TranID, CP.ClientID, EM.CustomerID, C.CustomerID, CP.EmbAcctId, EM.acctId, EM.EcardType, EM.ESecCardType,C.NewCardStatus,
'UPDATE TOP(1) CCard_Primary SET EmbAcctId = ' + TRY_CAST(EM.acctId AS VARCHAR) + '		WHERE TranID =	' + TRY_CAST(TranID AS VARCHAR) + '		AND AccountNumber = ''' + RTRIM(AccountNumber) + '''' [UPDATE_BS]
FROM CCard_Primary CP WITH (NOLOCK)
JOIN Customer C WITH (NOLOCK) ON (C.ClientID = CP.ClientID /*AND C.NewCardStatus = '2'*/)
JOIN EmbossingAccounts EM WITH (NOLOCK) ON (CP.BSacctId = EM.parent01AID AND C.CustomerID = EM.CustomerID AND EM.EcardType = '0' AND (EM.ESecCardType IS NULL /*AND EM.ESecCardType <> '0'*/))
WHERE TranID IN (57347598172,57347599424,57347595783,57347595784)

--UPDATE TOP(1) CCard_Primary SET EmbAcctId = 2145206  WHERE TranID = 52056995369  AND AccountNumber = '1100011110366691'
--UPDATE TOP(1) CCard_Primary SET EmbAcctId = 22924255  WHERE TranID = 52673632751  AND AccountNumber = '1100011173298823'
--UPDATE TOP(1) CCard_Primary SET EmbAcctId = 654179	WHERE TranID = 54164297225  AND AccountNumber = '1100011102912916'
--UPDATE TOP(1) CCard_Primary SET EmbAcctId = 15481295  WHERE TranID = 54426355870  AND AccountNumber = '1100011145708065'
--UPDATE TOP(1) CCard_Primary SET EmbAcctId = 2193489  WHERE TranID = 54426355885  AND AccountNumber = '1100011110609421'

SELECT CustomerID, NewCardStatus, CustomerType, BSAcctId, *
FROM Customer WITH (NOLOCK)
WHERE ClientID = '5265019a-6a97-49cf-9019-142ce142cd67'

SELECT CustomerID, EcardType, ESecCardType, *
FROM EmbossingAccounts WITH (NOLOCK)
WHERE CustomerID = 1085420
AND EcardType = '0' AND ESecCardType IS NULL

SELECT * FROM CCardLookUP WITH (NOLOCK) WHERE lutID = 'AsstPlan' AND LutCode IN ('16312', '16', '2')