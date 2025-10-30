-- Script will take around 10 minutes irrespective of number of records. So execute this on the replication server.
DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'
and ap.transactionuuid in
('c59ec984-1ee3-4920-9063-709647eda1a3',
'6e278021-a71c-494d-a7e6-c8234748a0db',
'b6adc67f-f31f-43de-948d-05d92cb5e58b',
'6065646c-2154-46fb-9424-fc77bf570144',
'367062b9-5ca8-487a-9db4-d78c4b7ec90c',
'd0769071-9716-49e2-a285-cd7946a3e048',
'322ddd30-9b85-4875-9334-532078366d0b',
'4c668a32-3f0d-4605-b6e1-c73e02014d94',
'a2e9465b-b198-47d2-9344-77bc840eee4f',
'892a3db6-947e-4799-a09e-2ebb6a551779',
'bbeddb20-a011-41dd-a90c-a474c5d260d2',
'a8dbdba3-6fb5-4314-b5fd-dd63710e1cad',
'73c86c91-7a82-46a1-bbda-82e8ae5950b1',
'6f92478f-0e3c-499b-9981-904f6a14d5de',
'79461c67-c001-4a5c-99f1-2eecb94ae8f9',
'ba93bf35-1257-4930-8d49-d09b8a22718d',
'5f65ee04-677c-4a61-b3bc-ceee2dd7e45c',
'590e3a3d-1a67-462b-a239-c964e6b67c37',
'a3db79ca-460a-43e4-ba5b-13d21340a27c',
'6becd153-ba22-4670-baf3-ef77213b0b3e',
'd0be1d85-0187-46c7-96d9-fc1a41d805f4',
'e049aca4-16b9-403d-8aa1-b2142130c124',
'24dee421-4815-44cb-9575-86a5425ea1f8',
'a27300a9-cd20-4c2a-a2a8-8792ac5f8625',
'95967c82-ba32-4c81-8ac8-a40407665265',
'5cf6cecc-b43e-4024-b654-f346a5a4797e',
'1c9b086c-6b5e-4399-8071-e4fa67af2602',
'cc53db4a-d5db-4901-b7bf-471cc1b3e400',
'aa1c3464-454b-4974-9746-49a00e17128b',
'f457ae90-d01f-4cce-8580-ade704069c87',
'204cdf07-81b4-436b-bb82-c59dac853155',
'64cbc79f-f839-4407-aed8-5545f23b296e',
'25d8b928-ccbf-4ed6-857b-54de743675b5',
'edea7c26-34a6-407e-9286-d4057f7c2e56',
'29996d92-c4a6-496c-b68d-a6e3ced62bcd',
'8328a880-73be-4212-a1af-b4ead1bc1e51',
'2e0fe56b-e2bb-45a4-a4c2-eddc078041d7',
'3b4b4326-cfce-47ff-a537-5a3f511640c4',
'3ccbc092-e3cd-47fc-931d-a0c19c8245e7',
'd4c1443c-b2e0-4c6f-a484-4ca296f4868c',
'72bdb873-d7c2-4c24-9863-28bb2815d5a3',
'778a3437-5fcd-42b9-acb7-13def28e87af',
'f7ce374e-779b-435c-b28f-853e4a824639',
'd0c9517f-0790-466d-bb4c-6a044cd6ab6d',
'1e89272b-7fe2-416e-8c09-9f22c907035b',
'a49a230b-bf50-419a-9c44-0b3173aa8ef8',
'9bafd302-3df7-4d55-8353-bcaf06e313e5',
'3b923dfd-f2bd-453e-95fe-2a2e5e68e0f8',
'4036ebf9-532b-4cb2-a66f-f30cea1f3eee',
'9aa43b20-150d-4629-a8dc-c40e7a097a98',
'a76de054-4c68-49c4-abfc-ad2e13ac5323',
'9b140d68-1ca1-4cf8-803b-71c80f7eff19',
'211269aa-111f-4a61-a427-87334deab926',
'728fa0c5-daab-42bc-bac9-4be9b05e3b18',
'36c37c5c-d549-422e-807f-5c9c98b681b4',
'34599a74-cd20-4cf7-8b67-e8eb990bc424',
'5e884bc1-0e66-49ae-882b-dcb43460113b',
'2ace5ed9-ce13-4581-88c7-b7f40330bfbd',
'22b8d4e4-bfa2-46f0-8bc9-33cc03211cda',
'259622e9-5a45-4ff1-86ff-740727e496d4',
'07194373-9a74-4913-9636-039092aa40c9',
'30bc0336-2cb6-4f65-a642-5d8e1ffd4a3a',
'806686e5-16e7-4b72-911e-28ff7a46794e',
'7a4f544b-d5c8-4082-a663-a0efa2b50ca8',
'40267213-9bbe-4a27-b735-c60aaeea609e',
'ebc28bb2-6c38-48c2-98d3-20674588500c',
'eb8c0e78-e0bd-4e3c-b956-3902a4ae77fb',
'6fe60244-f32a-4e11-991e-0c7b58088d2c')


/*

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #cp

DROP TABLE IF EXISTS ##TempDataAccount
SELECT * INTO ##TempDataAccount FROM #cpAccount

DROP TABLE IF EXISTS ##TempDataAuth
SELECT * INTO ##TempDataAuth FROM #AP

*/
/*

-- Script will take around 10 minutes irrespective of number of records. So execute this on the replication server.
DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempRecords TT ON (TT.TransactionUUID = AP.TransactionUUID)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'


DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempRecords TT ON (TT.transactionlifecycleuniqueid = AP.transactionlifecycleuniqueid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'



DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,Cp.transactionlifecycleuuid transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
JOIN ##TempRecords TT ON (TT.transactionlifecycleuniqueid = CP.transactionlifecycleuniqueid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'




DROP TABLE IF EXISTS #cpAccount
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cpAccount
from bsegment_primary bp with(nolock) 
JOIN ##TempRecords TT ON (TT.AccountUUID = BP.UniversalUniqueID) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'


DROP TABLE IF EXISTS #AP
GO
SELECT bp.acctid,bp.accountnumber,bp.universaluniqueid, ap.TransactionLifeCycleUniqueID, ap.transactionuuid, ap.MessageTypeIdentifier, ap.Transactionamount, ap.AuthStatus, EffectiveDate_ForAgeOff
into #AP
from bsegment_primary bp with(nolock) 
join auth_primary ap with(nolock) on ap.accountnumber = bp.accountnumber
JOIN ##TempRecords TT ON (TT.AccountUUID = BP.UniversalUniqueID) 



DROP TABLE IF EXISTS #cp_Auth
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CaseID
into #cp_Auth
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempDCA TT ON (TT.transactionuuid = AP.transactionuuid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'

DROP TABLE IF EXISTS #cp1
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,cp.UniversalUniqueID transactionuuid, 
CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CaseID
into #cp1
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
JOIN ##TempDCA TT ON (TT.transactionuuid = CP.UniversalUniqueID)
where 
cp.cmttrantype IN ('40', '43')


SELECT * FROM #CP_Auth UNION ALL 
SELECT * FROM #CP1

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #CP_Auth

INSERT INTO ##TempData
SELECT * FROM #CP1


SELECT * FROM #CP_Auth WITH (NOLOCK) WHERE TransactionUUID IN ('6091ce62-943b-4130-84de-69540c414927')
SELECT * FROM #CP1 WITH (NOLOCK) WHERE TransactionUUID IN ('6091ce62-943b-4130-84de-69540c414927')




*/