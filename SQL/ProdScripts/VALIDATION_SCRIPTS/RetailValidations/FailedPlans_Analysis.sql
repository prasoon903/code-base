SELECT 
AccountUUID,GroupId,RMATranUUID,PlanType,AuthAmount,otb_amount_held,OriginalPurchaseAmount,AmountOfReturnsLTD,AmountLeftForRefund,DisputeAmount,Resolved_Customer,Resolved_Merhant 
FROM #TempAllData
WHERE GroupID ='00204106-3b77-4797-9f01-ea38658c7487'

SELECT 
GroupId,SUM(AuthAmount) AuthAmount,SUM(otb_amount_held) otb_amount_held,SUM(OriginalPurchaseAmount) OriginalPurchaseAmount
,SUM(AmountOfReturnsLTD) AmountOfReturnsLTD,SUM(AmountLeftForRefund) AmountLeftForRefund,SUM(DisputeAmount) DisputeAmount,SUM(Resolved_Customer) Resolved_Customer,SUM(Resolved_Merhant ) Resolved_Merhant
FROM #TempAllData
GROUP BY GroupId




--1.

SELECT TT.GroupId, TT.AccountUUID, TT.RMATranUUID, OriginalPurchaseAmount
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
JOIN #TempPlanOnAuth TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPS.CreditPlanType = '16'

--2.

SELECT TT.GroupId, TT.AccountUUID, TT.RMATranUUID, OriginalPurchaseAmount, AmountOfReturnsLTD, OriginalPurchaseAmount - AmountOfReturnsLTD AmountLeftForRefund
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
JOIN #TempPlanOnAuth TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPS.CreditPlanType = '16'

--3.

SELECT TT.GroupId, TT.AccountUUID, TT.RMATranUUID, OriginalPurchaseAmount, AmountOfReturnsLTD, OriginalPurchaseAmount - AmountOfReturnsLTD AmountLeftForRefund
INTO #TempRefundByGroup
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
JOIN #TempPlanOnAuth TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPS.CreditPlanType = '16'

SELECT  GroupId, SUM(OriginalPurchaseAmount) OriginalPurchaseAmount, SUM(AmountOfReturnsLTD) AmountOfReturnsLTD, SUM(AmountLeftForRefund) AmountLeftForRefund
FROM #TempRefundByGroup
GROUP BY GroupId




DROP TABLE IF EXISTS #TempAllData
SELECT BP.UniversalUniqueID AccountUUID, TT.GroupId, TT.RMATranUUID, CPS.SingleSaleTranID, 
CASE WHEN CPM.CreditPlanType = '16' THEN 'RETAIL' WHEN CPM.CreditPlanType = '0' THEN 'CREDIT LINE' WHEN CPM.CreditPlanType = '10' THEN 'RRC' ELSE 'NA' END AS PlanType
, TT.AuthAmount, TT.otb_amount_held, ISNULL(OriginalPurchaseAmount, 0) OriginalPurchaseAmount, CPS.AmountofDebitsLTD, CPS.AmountOfCreditsLTD,
ISNULL(CPS.AmountOfReturnsLTD, 0) AmountOfReturnsLTD, ISNULL(OriginalPurchaseAmount, 0) - ISNULL(CPS.AmountOfReturnsLTD, 0) AmountLeftForRefund--, 0 DisputeAmount, 0 Resolved_Customer, 0 Resolved_Merhant
INTO #TempAllData
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
RIGHT JOIN #TempOTBRecords TT ON (CPCC.PlanUUID = TT.RMATranUUID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = TT.AccountNumber)
LEFT OUTER JOIN CPMAccounts CPM WITH (NOLOCK) ON (CPM.acctId = TT.PlanID)
ORDER BY TT.GroupId


DROP TABLE IF EXISTS #TempAllData
SELECT BP.UniversalUniqueID AccountUUID, TT.RMATranUUID, CPS.SingleSaleTranID, 
CASE WHEN CPM.CreditPlanType = '16' THEN 'RETAIL' WHEN CPM.CreditPlanType = '0' THEN 'CREDIT LINE' WHEN CPM.CreditPlanType = '10' THEN 'RRC' ELSE 'NA' END AS PlanType, 
ISNULL(OriginalPurchaseAmount, 0) OriginalPurchaseAmount, CPS.CurrentBalance, CPS.AmountofDebitsLTD, CPS.AmountOfCreditsLTD,
ISNULL(CPS.AmountOfReturnsLTD, 0) AmountOfReturnsLTD, ISNULL(OriginalPurchaseAmount, 0) - ISNULL(CPS.AmountOfReturnsLTD, 0) AmountLeftForRefund, CPS.DisputesAmtNS, 0 DisputeAmount, 0 Resolved_Customer, 0 Resolved_Merhant
INTO #TempAllData
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
RIGHT JOIN #TempPlans TT ON (CPCC.PlanUUID = TT.RMATranUUID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = TT.AccountNumber)
LEFT OUTER JOIN CPMAccounts CPM WITH (NOLOCK) ON (CPM.acctId = CPS.parent01AID)


SELECT * FROM #TempAllData


SELECT CP.TranID, CP.CMTTranType, CP.TransactionAmount, TT.*
FROM #TempAllData TT
JOIN Auth_Primary AP WITH (NOLOCK) ON (TT.RMATranUUID = AP.PlanUUID AND AP.MessageTypeIdentifier = '9200')
JOIN CCard_Primary CP WITH (NOLOCK) ON (CP.AuthTranID = AP.TranID AND CP.CMTTranType = '40')
WHERE TT.PlanType = 'CREDIT LINE'
ORDER BY TT.RMATranUUID


DROP TABLE IF EXISTS #CreditPurchaseRecord
SELECT CP.TranID, CP.CMTTranType, CP.TransactionAmount, CP.RMATranUUID, TT.GroupID
INTO #CreditPurchaseRecord
FROM #TempAllData TT
JOIN Auth_Primary AP WITH (NOLOCK) ON (TT.RMATranUUID = AP.PlanUUID AND AP.MessageTypeIdentifier = '9200')
JOIN CCard_Primary CP WITH (NOLOCK) ON (CP.AuthTranID = AP.TranID AND CP.CMTTranType = '40')
WHERE TT.PlanType = 'CREDIT LINE'
ORDER BY TT.RMATranUUID


DROP TABLE IF EXISTS #CreditPurchaseRecordP1
SELECT RMATranUUID,  SUM(TransactionAmount) TransactionAmount INTo #CreditPurchaseRecordP1
FROm #CreditPurchaseRecord
GROUP BY RMATranUUID


UPDATE T1
SET OriginalPurchaseAmount = T2.TransactionAmount
FROm #TempAllData T1
JOIN #CreditPurchaseRecordP1 T2 ON (T1.RMATranUUID = T2.RMATranUUID)


SELECT MessageTypeIdentifier, ProcCode,* FROM Auth_Primary WITH (NOLOCK) WHERE PlanUUID = 'df513ddd-6871-45e7-bdc6-8f7262aeef92' AND MessageTypeIdentifier = '9200'

SELECT  * FROM Auth_Primary WITH (NOLOCK) WHERE CoreAuthTranID = 719855271


SELECT TransactionAmount,* FROM CCard_Primary WITH (NOLOCK) WHERE AuthTranID IN (32113829659,32291306623)


SELECT * FROM #TempAllData WHERE PlanType = 'CREDIT LINE' AND AuthAmount - otb_amount_held > 0


DROP TABLE IF EXISTS #DisputeData
SELECT DL.PurchaseTranId, DL.DisputeID, DL.PurchaseTranAmt, DL.DisputeAmount, TT.SingleSaleTranID, 0 Resolved_Customer, 0 Resolved_Merhant
INTO #DisputeData 
FROM DisputeLog DL WITH (NOLOCK)
JOIN #TempAllData TT ON (TT.SingleSaleTranID = DL.PurchaseTranId AND TT.PlanType = 'RETAIL')


DROP TABLE IF EXISTS #TempDisputeStatusLog
SELECT  DisputeTranCode,
CASE	WHEN DisputeTranCode IN ('110', '116', '118') THEN 0 -- Open
		WHEN DisputeTranCode IN ('115', '117', '1111') THEN 1 -- Merchant
		WHEN DisputeTranCode IN ('113', '1131', '1133') THEN 2 -- Customer
		ELSE -1
END DisputeType,
DS.DisputeAmount,
DS.DisputeID
INTO #TempDisputeStatusLog
FROM #DisputeData T1 
JOIN DisputeStatusLog DS WITH (NOLOCK) ON (T1.DisputeID = DS.DisputeID AND ISNULL(DS.DisputeResolveReverse, 0) = 0)
--WHERE T1.DisputeID = 531847

DROP TABLE IF EXISTS #CollectedDisputeData
SELECT D1.DisputeID, DisputeType, SUM(CASE WHEN DisputeType = 1 THEN D2.DisputeAmount ELSE 0 END) Resolved_Merhant, SUM(CASE WHEN DisputeType = 2 THEN D2.DisputeAmount ELSE 0 END) Resolved_Customer
INTO #CollectedDisputeData
FROM #DisputeData D1
JOIN #TempDisputeStatusLog D2 ON (D1.DisputeID = D2.DisputeID)
--WHERE DisputeType <> 0
GROUP BY D1.DisputeID, DisputeType
ORDER BY D1.DisputeID

UPDATE D1
SET 
	Resolved_Customer = D2.Resolved_Customer, 
	Resolved_Merhant = D2.Resolved_Merhant
FROM #DisputeData D1
JOIN #CollectedDisputeData D2 ON (D1.DisputeID = D2.DisputeID)
WHERE DisputeType = 1

SELECT * FROM #DisputeData WHERE DisputeID = 437862
SELECT * INTO ##TempAllData FROM #TempAllData

SELECT * FROm #CollectedDisputeData WHERE DisputeType = 1

SELECT *
FROM DisputeStatusLog WITH (NOLOCK)
WHERE DisputeID = 694205


UPDATE #TempAllData SET DisputeAmount = 0, Resolved_Customer = 0, Resolved_Merhant = 0


UPDATE T1
SET
	DisputeAmount = T2.DisputeAmount,
	Resolved_Customer = T2.Resolved_Customer,
	Resolved_Merhant = T2.Resolved_Merhant
FROM #TempAllData T1
JOIN #DisputeData T2 ON (T1.SingleSaleTranID = T2.PurchaseTranID)


SELECT T1.DisputeAmount, T2.DisputeAmount, T1.Resolved_Customer, T2.Resolved_Customer, T1.Resolved_Merhant, T2.Resolved_Merhant, T1.SingleSaleTranID, T2.PurchaseTranID, DisputeID
FROM #TempAllData T1
JOIN #DisputeData T2 ON (T1.SingleSaleTranID = T2.PurchaseTranID)
--WHERE T1.SingleSaleTranID = 32311667635
WHERE T1.DisputeAmount < T1.Resolved_Customer + T1.Resolved_Merhant


--UPDATE #DisputeData
--SET Resolved_Customer = CASE WHEN Resolved_Customer > DisputeAmount THEN Resolved_Customer - DisputeAmount ELSE Resolved_Customer END, 
--Resolved_Merhant = CASE WHEN Resolved_Merhant > DisputeAmount THEN Resolved_Merhant - DisputeAmount ELSE Resolved_Merhant END
--WHERE DisputeAmount < Resolved_Customer + Resolved_Merhant


SELECT DisputeTranCode, PurchaseTranAmt, DisputeAmount, * 
FROM DisputeLog DL WITH (NOLOCK)
JOIN DisputeStatusLog DS WITH (NOLOCK) ON (DL.DisputeID = DS.DisputeID)
JOIN #TempAllData TT ON (TT.SingleSaleTranID = DL.PurchaseTranId AND TT.PlanType = 'RETAIL')
WHERE --DL.PurchaseTranId = 27902356423 AND
DisputeTranCode = '110'

SELECT  GroupId
FROM #TempPlans
GROUP BY GroupId


SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LutId = 'DisputeAction' ORDER BY DisplayOrdr




SELECT TT.GroupId, TT.AccountUUID, TT.RMATranUUID, OriginalPurchaseAmount, AmountOfReturnsLTD, OriginalPurchaseAmount - AmountOfReturnsLTD AmountLeftForRefund
INTO #TempPlans_T1
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
JOIN #TempPlans TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPS.CreditPlanType = '16'









select count(1) from #TempPlans with(nolock)

SELECT  * FROM #TempPlans WHERE AccountUUID = '7fa12d11-da7e-48e1-8333-537cd189d50c'

SELECT RMATranUUID, TxnSource, TransactionAmount,ArTxnType,* 
FROM CCard_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011129318311'
AND CMTTranType = '40' AND TxnSource IN ('29', '39')
AND RMATranUUID IN ('f9502acb-e2ca-4e5a-9498-8e082b90d87b','a7f2a6d4-3817-460c-b10d-d43343416fbb')

SELECT A.MTI, TransactionDescription,* 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE B.AccountNumber = '1100011129318311' 
AND A.uuid IN ('f9502acb-e2ca-4e5a-9498-8e082b90d87b','a7f2a6d4-3817-460c-b10d-d43343416fbb') 
AND A.MTI = 9200


SELECT A.MTI, TransactionDescription, Amount,* 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID AND A.MTI = 9200)
WHERE Amount > 0

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE AuthTranID = 34450458577

SELECT MessageTypeIdentifier, ProcCode,* FROM Auth_Primary WITH (NOLOCK) WHERE PlanUUID = '462400de-c4e1-4018-92c7-cb4dae796f78'


SELECT A.MTI, A.TranID, otb_amount_held, TransactionDescription, Amount, A.UUID,* 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID AND A.MTI = 9200)
WHERE 
Amount > 0 OR 
otb_amount_held > 0

SELECT DISTINCT A.MTI,A.Skey,RANK() OVER(PARTITION BY A.UUID ORDER BY A.Skey DESC)  RankRecords,*
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID /*AND A.MTI = 9200*/)
AND A.UUID = '3a724bf1-411f-496c-98ff-31f40535e975' AND A.MTI <> 9000


DROP TABLE IF EXISTS #TempOTB
SELECT DISTINCT A.MTI, otb_amount_held, TT.RMATranUUID UUID, TT.AccountNumber, A.GroupId, Amount, A.Plan_id, A.Datetime, RANK() OVER(PARTITION BY A.UUID ORDER BY A.Skey DESC)  RankRecords
INTO #TempOTB
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID /*AND A.MTI = 9200*/)
WHERE A.MTI <> 9000

DROP TABLE IF EXISTS #TempOTB9100
SELECT DISTINCT A.MTI, A.otb_amount_held, A.UUID, TT.AccountNumber, A.GroupId, A.Amount, A.Datetime, RANK() OVER(PARTITION BY A.UUID ORDER BY A.Skey DESC)  RankRecords--, T1.*
INTO #TempOTB9100
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID /*AND A.MTI = 9200*/)
--LEFT JOIN #TempOTB T1 ON (T1.UUID = TT.RMATranUUID AND T1.RankRecords = 1)
WHERE A.MTI IN ('9120', '9100')
--AND T1.UUID IS NULL

SELECT * 
FROM #TempOTB T1
RIGHT JOIN #TempOTB9100 T2 ON (T1.UUID = T2.UUID)
WHERE T1.RankRecords = 1 AND T2.RankRecords = 1
ORDER BY T1.UUID

SELECT * FROM #TempOTB WHERE RankRecords = 1 AND UUID = '3a724bf1-411f-496c-98ff-31f40535e975'
SELECT * FROM #TempOTB9100 WHERE RankRecords = 1 AND UUID = '3a724bf1-411f-496c-98ff-31f40535e975'

DROP TABLE IF EXISTS #TempOTBRecords
SELECT T1.UUID RMATranUUID, T1.GroupId, T1.AccountNumber, Plan_id PlanID, T2.Amount AuthAmount, T1. otb_amount_held, RANK() OVER(PARTITION BY T1.UUID ORDER BY T1.MTI DESC)  RankRecords1
INTO #TempOTBRecords
FROM #TempOTB T1
LEFT JOIN #TempOTB9100 T2 ON (T1.UUID = T2.UUID)
WHERE T1.RankRecords = 1 AND T2.RankRecords = 1
--AND T2.UUID IS NULL
ORDER BY T1.UUID

SELECT * FROM #TempOTB WHERE RankRecords = 1


SELECT GroupId, SUM(otb_amount_held) otb_amount_held, SUM(AuthAmount) TransactionAmount
FROM #TempOTBRecords
GROUP BY GroupId
--HAVING SUM(Amount) > 0 AND SUM(otb_amount_held) = 0
ORDER BY SUM(AuthAmount), SUM(otb_amount_held)

--01ef3345-e040-425f-8421-736de1c5a98f

SELECT A.MTI, TransactionDescription, Amount,otb_amount_held,* 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID)
WHERE A.GroupID = '71febdc0-b58a-443c-9012-7fa98756c70a'


SELECT A.MTI, TransactionDescription, Amount, otb_amount_held,* 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID)
WHERE A.UUID = '26382546-e2bc-4049-bf8b-d1ff96864584'



DROP TABLE IF EXISTS #TempPlanOnAuth
SELECT TT.*, Plan_Id 
INTO #TempPlanOnAuth
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN #TempPlans TT ON (B.AccountNumber = TT.AccountNumber AND A.uuid = TT.RMATranUUID AND A.MTI = 9200)
WHERE Amount > 0



SELECT * FROM SYS.Servers

--select cg.OriginalPurchaseAmount,cs.AmountOfReturnsLTD,cg.planuuid from #TempPlans rt with(nolock) JOIN CPSgmentCreditCard cg with(nolock)
-- on (rt.rmatranuuid = cg.planuuid) join CPSgmentAccounts cs with(nolock) on (cg.acctid = cs.acctid ) 


SELECT CPS.acctId, CPS.parent02AID, CPCC.PlanUUID, CPCC.OriginalPurchaseAmount, CPS.AmountOfReturnsLTD, TT.*
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
RIGHT JOIN #TempPlans TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPCC.PlanUUID IS NULL


SELECT CPS.acctId, CPS.parent02AID, CPCC.PlanUUID, CreditPlanType, CPCC.OriginalPurchaseAmount, CPS.AmountOfReturnsLTD, TT.*
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
RIGHT JOIN #TempPlanOnAuth TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPCC.PlanUUID IS NULL --AND
--CreditPlanType = '16'


SELECT DISTINCT Plan_Id
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctId)
RIGHT JOIN #TempPlanOnAuth TT ON (CPCC.PlanUUID = TT.RMATranUUID)
WHERE CPCC.PlanUUID IS NULL --AND
--CreditPlanType = '16'

13746
13752
13754
13756


SELECT CPM.acctId, CPM.CpmDescription, CL.LutDescription AS InterestPlanDesc, CPM.CreditPlanType, EqualPayments, CPM.InterestPlan, IT.IntRateType, CLI.LutDescription AS InterestType,
ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) AS TotalInterest, IT.VarInterestRate, IT.Variance1, IT.Variance2, IT.Variance3, CPM.multiplesales
FROM CPMAccounts CPM WITH (NOLOCK)
JOIN InterestAccounts IT WITH (NOLOCK) ON (CPM.interestplan = IT.acctId)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.acctId) = CL.LUTCode AND CL.Lutid = 'InterestPlan')
LEFT OUTER JOIN CCardLookUp CLI WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.IntRateType) = CLI.LUTCode AND CLI.Lutid = 'IntRateType')
WHERE CPM.acctId IN (13746,13752,13754,13756,13762)


SELECT creditplantype,* FROM CPMAccounts WITH (NOLOCK) WHERE acctId IN (13746,13752,13754,13756,13762)



SELECT AccountNumber,* FROM BSegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '7fa12d11-da7e-48e1-8333-537cd189d50c'

SELECT CP.RMATranUUID,* 
FROM CCard_Primary CP WITH (NOLOCK)
JOIN  #TempPlanOnAuth T1 ON (CP.AccountNumber = T1.AccountNumber AND CP.RMATranUUID = T1.RMATranUUID)
WHERE CMTTranType = '40' AND TxnSource IN ('29', '39')



/*

4c473277-ca39-499b-91ae-356d8757be62
b405b0fe-962b-4174-93a3-1516c974b700
10799dd1-927b-4c72-ab75-fafd75d33250
4a036a22-9686-4c3c-846f-5195ea550b43
f0ae0e90-81cc-4b94-9c11-09b7739c3ac9
9fc24841-c095-4765-a920-0065e2e4ebcc

SELECT * FROM #TempPlans

Drop table if exists #TempPlans
create table #TempPlans
(
	GroupId varchar (64), AccountUUID VARCHAR(64), RMATranUUID VARCHAR(64)
)

ALTER TABLE #TempPlans ADD AccountNumber VARCHAR(19)

UPDATE TT
SET AccountNumber = BP.AccountNumber, AccountUUID = BP.UniversalUniqueID
FROM #TempPlans TT
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (TT.RMATranUUID = CPCC.PlanUUID)
JOIN CPSgmentAccounts CPA WITH (NOLOCK) ON (CPCC.acctId = CPA.acctId)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (CPA.parent02AID = BP.acctId)

INSERT INTO #TempPlans (RMATranUUID) VALUES('4c473277-ca39-499b-91ae-356d8757be62')
INSERT INTO #TempPlans (RMATranUUID) VALUES('b405b0fe-962b-4174-93a3-1516c974b700')
INSERT INTO #TempPlans (RMATranUUID) VALUES('10799dd1-927b-4c72-ab75-fafd75d33250')
INSERT INTO #TempPlans (RMATranUUID) VALUES('4a036a22-9686-4c3c-846f-5195ea550b43')
INSERT INTO #TempPlans (RMATranUUID) VALUES('f0ae0e90-81cc-4b94-9c11-09b7739c3ac9')
INSERT INTO #TempPlans (RMATranUUID) VALUES('9fc24841-c095-4765-a920-0065e2e4ebcc')
*/