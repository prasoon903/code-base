/*
1. ARSystemCutoffAccounts
2. ARSystemHSAccounts
3. Set InstitutionID
4. Set TView date to 59.44
5. Execute last ACH batch
Verify the entry of NEW jobs EOD_AsystemHS.
6. Stop TNP
7. EXEC USP_EOD_AsystemHS_JOB -- this changes to NAD mode 1
8. Start APP server -- ready for real time posting 
Set the TView 1st day and more than 20 minutes
*/


SELECT AsynchronousPosting, RealTimePostingDuringEOM, NewTNPQueue, OB.ACHCutoffTime, * 
FROM OrgAccounts O WITH(NOLOCK) 
JOIN Org_balances OB WITH(NOLOCK) On O.acctId = OB.acctId

select * from Logo_Balances 

SELECT * FROM ConfigStore WITH(NOLOCK) WHERE BlockName = 'DEFAULT' AND KeyName = 'COMMONAP_QNAJOB'

--UPDATE Org_balances set AsynchronousPosting = null, RealTimePostingDuringEOM = null , NewTNPQueue = null
--update ConfigStore set KeyValue = '0' WHERE BlockName = 'DEFAULT' AND KeyName = 'COMMONAP_QNAJOB'

--UPDATE ARSystemHSAccounts SET InstitutionID = NULL, NADMode = 0
--UPDATE ARSystemAccounts SET NADMode = 0

SELECT * FROM CommonTNP WITH (NOLOCK) ORDER BY TranTime, priority		
SELECT * FROM CommonAP WITH (NOLOCK) ORDER BY TranTime, priority 
SELECT TOP 10 * FROM PendingTxnJob WITH (NOLOCK) ORDER BY TranTime, priority 
SELECT TOP 10 * FROM ECommonTNP WITH (NOLOCK) ORDER BY TranTime, priority		

SELECT  * FROM ErrorTNP WITH (NOLOCK) ORDER BY TranTime, priority 
SELECT  * FROM ErrorAP WITH (NOLOCK) ORDER BY TranTime, priority 
SELECT  * FROM errorpendingtxn WITH (NOLOCK) ORDER BY TranTime, priority 
SELECT  * FROM EErrorTNP WITH (NOLOCK) ORDER BY TranTime, priority	

SELECT * FROM CommonTNP ct WITH (NOLOCK) WHERE ATID in (100, 90, 60, 110) ORDER BY TranTime, priority 
SELECT * FROM CommonTNP ct WITH (NOLOCK) WHERE ATID in (51) AND TranID > 0 ORDER BY TranTime, priority 
SELECT * FROM CommonTNP ct WITH (NOLOCK) WHERE ATID in (51) AND TranID = 0 ORDER BY TranTime, priority 

SELECT * FROM ConnectivityTestDetails WITH(NOLOCK)
SELECT * FROM ConnectivityTestAccounts WITH(NOLOCK)
SELECT * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 150 

--delete from commontnp where atid = 51 and acctid <> 14551608

/* *********************************************************** */

-- STEP 1 : Last ACH Batch  -> it will create ATID 100 Job in CommonTNP
--			These needs to be processed 
--			This will create ProcDay change job in table EOD_AsystemHS
SELECT  C.* 
FROM CommonTNP C WITH (NOLOCK)
LEFT JOIN ARSystemHSAccounts A WITH(NOLOCK) ON (C.InstitutionID = A.InstitutionID)
WHERE ATID = 100 
AND C.TranTime <= A.ProcDayEnd

-- UPDATE CommonTNP  SET priority = -50 WHERE ATID = 100

-- STEP 2 : ProcDay Change of ARSystemHS 
--			for ProcDay of ARSystemHS (ATID 100) change job to be done 
--			Execute this Stored Procedure till there is no new job present for that proc day
--			EXEC USP_EOD_AsystemHS_JOB

SELECT * FROM EOD_AsystemHS WITH(NOLOCK) ORDER BY Skey DESC

-- After Job Status is marked is done 
-- Proc Day is changed for ARSystemHSAccounts (ATID-100)
-- Now, TNP can  process ARSystemAccounts (ATID-60) to change business day or age the system

SELECT * FROM ARSystemHSAccounts WITH (NOLOCK)

-- STEP 3 : After Job Status is marked is done 
--			NADMode  0 -> 1
--			CommonTNP will process NAD job and ATID - 60

SELECT  * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60

SELECT * FROM ARSystemAccounts aa WITH (NOLOCK)

/* *********************************************************** */

--ArsystemHSAccount\ArsystemAccount\ARSystemHSEODMapping having invalid setup

-- ATID - 60
SELECT * FROM ARSystemAccounts aa WITH (NOLOCK)

-- ATID - 100
SELECT * FROM ARSystemHSAccounts aa WITH (NOLOCK)

-- ATID - 90
SELECT * FROM ARSystemCutOffAccounts aa WITH (NOLOCK)


SELECT * FROM CommonTNP WITH(NOLOCK) WHERE TranID IN (SELECT TranID FROM CCard_Primary cp WITH(nolock) WHERE CMTTranType = 'EOD')

-- To check last ACH Batch 
select * from ACHDailyRun WITH(NOLOCK) WHERE EODFlag = 1 ORDER BY RunID DESC

-- Pass CurrentTime this will let u know which job is TNP workflow gonna pick
EXEC dbb_PstCmnCommonTnpQryCRI '03/01/2018 16:34:49:000', null


/* ***************************** WHEN EOD FILLING IS WITH NEW METHOD eodProcfromapp IN (22,21) ******************** */

-- per intermediate if filled  entry created with new 
SELECT * FROM EODSelectIntoJob WITH(NOLOCK) WHERE businessday = ''

-- intermediate if filled  entry created with new
SELECT * FROM EODIntermediateData WITH(NOLOCK) WHERE businessday = ''

-- usp status 
SELECT * FROM SPExecutionLog WITH(NOLOCK)

-- -- usp status  if eodProcfromapp  21 
SELECT * FROM SPExecutionLog_ForNewMethod WITH(NOLOCK) 
