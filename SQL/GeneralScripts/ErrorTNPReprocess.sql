select TOP 1 * from CCGS_DEV_CoreIssue..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_QA_CoreIssue..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_PTR_CoreIssue..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_INT_CoreIssue..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_TRN_CoreIssue..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_UAT_CoreIssue1..version with (nolock) order by 1 desc

select TOP 1 * from CCGS_UATP_CoreIssue..version with (nolock) order by 1 desc


select * from CCGS_DEV_CoreIssue..errortnp with (nolock)

select * from CCGS_QA_CoreIssue..errortnp with (nolock)

select * from CCGS_PTR_CoreIssue..errortnp with (nolock)

select * from CCGS_INT_CoreIssue..errortnp with (nolock)

select * from CCGS_TRN_CoreIssue..errortnp with (nolock)

select * from CCGS_UAT_CoreIssue1..errortnp with (nolock)

select * from CCGS_UATP_CoreIssue..errortnp with (nolock)


select COUNT(1) AS DEV from CCGS_DEV_CoreIssue..errortnp with (nolock)

select COUNT(1) AS QA from CCGS_QA_CoreIssue..errortnp with (nolock)

select COUNT(1) AS PTR from CCGS_PTR_CoreIssue..errortnp with (nolock)

select COUNT(1) AS INT from CCGS_INT_CoreIssue..errortnp with (nolock)

select COUNT(1) AS TRN from CCGS_TRN_CoreIssue..errortnp with (nolock)

select COUNT(1) AS UAT from CCGS_UAT_CoreIssue1..errortnp with (nolock)

select COUNT(1) AS UATP from CCGS_UATP_CoreIssue..errortnp with (nolock)

SELECT 'ErrorTNP in DEV==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_DEV_CoreIssue..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in QA==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_QA_CoreIssue..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in PTR==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_PTR_CoreIssue..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in INT==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_INT_CoreIssue..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in TRN==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_TRN_CoreIssue..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in UAT==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_UAT_CoreIssue1..errortnp WITH (NOLOCK)
UNION
SELECT 'ErrorTNP in UATP==>' AS EnvironmentName, COUNT(1) AS JobCount FROM CCGS_UATP_CoreIssue..errortnp WITH (NOLOCK)

SELECT TOP 1 'DEV==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_DEV_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'QA==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_QA_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'PTR==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_PTR_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'INT==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_INT_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'TRN==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_TRN_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'UAT==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_UAT_CoreIssue1..version WITH (NOLOCK) ORDER BY entryid desc

SELECT TOP 1 'UATP==>' AS EnvironmentName, Platformversion, Appversion FROM CCGS_UATP_CoreIssue..version WITH (NOLOCK) ORDER BY entryid desc


USE CCGS_DEV_CoreIssue
GO

BEGIN TRAN 

DELETE FROM ErrorTnp where Tranid = 0 AND acctid IN (832096)

-- 1 Rows Affected
-- Rollback
-- Commit

---------------------------------------------------------------------------------------------

USE CCGS_UATP_CoreIssue
GO

BEGIN TRAN 

UPDATE ET Set ET.TranTime = DATEADD(ss,1, BP.LAD)
From ErrorTNP ET JOIN BSegment_Primary BP with(NOLOCK) on ET.acctId = BP.acctId
where ET.TranId = 0 AND ET.acctid IN (96450,96459,96461,96465,96468,96580,96586,96588,96593,96600,96601,96602,96605,96610,96612,96615,96617,96620)

-- 18 Rows Affected
-- Rollback
-- Commit 

BEGIN TRAN
Insert into commontnp (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)
Select tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag from errortnp with(nolock) where Tranid = 0 AND acctid IN (96450,96459,96461,96465,96468,96580,96586,96588,96593,96600,96601,96602,96605,96610,96612,96615,96617,96620)

-- 18 Rows Affected
BEGIN TRAN 
DELETE FROM ErrorTnp where Tranid = 0 AND acctid IN (96450,96459,96461,96465,96468,96580,96586,96588,96593,96600,96601,96602,96605,96610,96612,96615,96617,96620)

-- 18 Rows Affected
-- Rollback
-- Commit

-------------------------------------------------------------------------------------

USE CCGS_QA_CoreIssue
GO

begin  tran 

	 update ccard_primary set trantime = dateadd(ss,1, trantime), posttime =dateadd(ss,1, posttime)  
	 where tranid IN (351138490,351138491,351138492,351138497,351138500,351138501,351138508)
	 --- 7 row update 

	 update ErrorTnp set trantime = trantime
	 where tranid IN (351138490,351138491,351138492,351138497,351138500,351138501,351138508)
	 --- 7 row update 
--commit tran 

BEGIN Tran 
	Insert Into CommonTNp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,institutionid)
	SELECT tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,6969 FROM ErrorTNp 
	where tranid IN (351138490,351138491,351138492,351138497,351138500,351138501,351138508)
	-- 7 row inserted 

	DELETE FROM ErrorTnp where tranid IN (351138490,351138491,351138492,351138497,351138500,351138501,351138508)
	--7 row deleted 
--COMMIT

-----------------------------------------------------------------------------------------




USE CCGS_UATP_CoreIssue

update ccard_primary set creditplanmaster = 13756
	 where tranid IN (14272215)
	 --- 1 row update 

BEGIN Tran 
	Insert Into CommonTNp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,institutionid)
	SELECT tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,6973 FROM ErrorTNp 
	where tranid IN (14272215)
	-- 1 row inserted 
	DELETE FROM ErrorTnp where tranid IN (14272215)
	--1 row deleted 
--COMMIT





USE CCGS_QA_CoreIssue
GO

BEGIN TRAN 
	DELETE FROM ErrorTnp where ATID = 51 and tranid = 0

	--(95 row(s) deleted)
-- ROLLBACK
-- COMMIT




USE CCGS_QA_CoreIssue
GO

BEGIN TRAN 

UPDATE ET Set ET.TranTime = DATEADD(ss,1, BP.LAD)
From ErrorTNP ET JOIN BSegment_Primary BP with(NOLOCK) on ET.acctId = BP.acctId
where ET.TranId = 0 AND ET.atid = 51

Insert into CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries)
Select tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0 from errortnp with(nolock) where Tranid = 0 AND acctid IN
(select acctId from errortnp with (nolock) where ATID = 51 and tranid = 0
EXCEPT 
select acctId from CommonTNP with (nolock)
where acctid in (select acctid from errortnp with (nolock))
and ATID = 51 and tranid = 0)

--(102 row(s) affected)

DELETE from errortnp where ATID = 51 and tranid = 0

--(102 row(s) affected)

-- Rollback
-- Commit

--===============================================================================================

DROP TABLE IF EXISTS #errortnp
DROP TABLE IF EXISTS #Commontnp

select * into #Commontnp from CommonTNP with (nolock) where ATID = 51 and tranid = 0
select * into #errortnp from errortnp with (nolock) where ATID = 51 and tranid = 0


Insert into #Commontnp(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries)
Select tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0 from #errortnp with(nolock) where Tranid = 0 AND acctid IN
(select acctId from #errortnp with (nolock) where ATID = 51 and tranid = 0
EXCEPT 
select acctId from #Commontnp with (nolock)
where acctid in (select acctid from #errortnp with (nolock))
and ATID = 51 and tranid = 0)

select * from #Commontnp where acctId in 
(select acctId from #errortnp with (nolock) where ATID = 51 and tranid = 0
EXCEPT 
select acctId from #Commontnp with (nolock)
where acctid in (select acctid from #errortnp with (nolock))
and ATID = 51 and tranid = 0)

DELETE from #errortnp where ATID = 51 and tranid = 0

select *  from #errortnp with (nolock)

-----------=====================================================
--------------------------------------------------------------------------------------

USE CCGS_PTR_CoreIssue
GO

BEGIN TRAN 

UPDATE ET Set ET.TranTime = DATEADD(ss,1, BP.LAD)
From ErrorTNP ET JOIN BSegment_Primary BP with(NOLOCK) on ET.acctId = BP.acctId
where ET.TranId = 0 AND ET.atid = 51

--- 1 row update

Insert into CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries)
Select tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0 from errortnp with(nolock) where Tranid = 0 AND acctid IN
(select acctId from errortnp with (nolock) where ATID = 51 and tranid = 0
EXCEPT 
select acctId from CommonTNP with (nolock)
where acctid in (select acctid from errortnp with (nolock))
and ATID = 51 and tranid = 0)

--(1 row(s) affected)

DELETE from errortnp where ATID = 51 and tranid = 0

--(1 row(s) affected)

-- Rollback
-- Commit
--------------------------------------------------------------------------------------
USE Mayors_CI
GO
BEGIN TRAN 

		UPDATE ET Set ET.TranTime = DATEADD(ss,1, BP.LAD)
		From ErrorTNP ET JOIN BSegment_Primary BP with(NOLOCK) on ET.acctId = BP.acctId
		where tranid IN (559031282)
		--- 1 row update 

		UPDATE CP
		SET CP.trantime =et.trantime, CP.posttime = et.trantime
		from CCard_Primary CP with (nolock)
		join errortnp et with (nolock) on (cp.tranid = et.tranid)
		where et.tranid IN (559031282)
	 --- 1 row update 
--COMMIT TRAN 

BEGIN TRAN 
	Insert Into CommonTNp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,institutionid)
	SELECT tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,1301 FROM ErrorTNp 
	where tranid IN (559031282)
	-- 1 row inserted 

	DELETE FROM ErrorTnp where tranid IN (559031282)
	--1 row deleted 
--COMMIT TRAN 

-- Rollback

select getdate() AS CURRENTTIME,* from CommonTNP with (nolock) where tranid <> 0 and atid = 51 and trantime < getdate()

SELECT BSAcctid,C.TxnAcctId,C.trantime,posttime,C.PostingRef,CMTTRANTYPE,C.TxnCode_Internal,C.TransactionAmount,txnsource,C.ARTxnType,C.AvailableBalanceAccount,C.TranRef,C.TranId,C.tranorig,C.TransactionDescription,C.TxnCode_Internal,C.GroupId,PaymentReferenceId,C.creditplanmaster,MessageReasonCode,Trantime,C.PostTime,TransactionAmount,FeesAcctID,accountnumber,TranId,UniversalUniqueID,CaseID,PaymentCreditFlag,MessageIdentifier,TranRef,txnacctid,* 
FROM CCard_Primary C WITH (NOLOCK) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 197835) 
ORDER BY C.posttime desc

select DISTINCT bp.acctid,billingcycle,institutionid,LAD,NAD,LAPD,testaccount from bsegment_primary bp with (nolock)
join bsegment_secondary bs with (nolock) on (bp.acctid = bs.acctid)
where bp.acctid = 197835

select DISTINCT bp.acctid,billingcycle,bp.currentbalance,institutionid,LAD,NAD,LAPD,testaccount from bsegment_primary bp with (nolock)
join bsegment_secondary bs with (nolock) on (bp.acctid = bs.acctid)
--where bp.accountnumber = 1100001107681517
join errortnp et with (nolock) on (bp.acctid = et.acctid)
where tranid <> 0


USE CCGS_UAT_CoreIssue1
GO
BEGIN TRAN 
	Insert Into IPMErrorTnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag, ErrorReason)
	SELECT tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag, ErrorReason FROM ErrorTNP
	where tranid IN (SELECT TranID FROM ErrorTNP WITH (NOLOCK) WHERE TranId <> 0) 
	--(3 row(s) affected)

	DELETE FROM ErrorTnp where tranid <> 0
	--(3 row(s) deleted)

--COMMIT TRAN 



	AND ErrorReason LIKE '%Account ''51:30'' not found%'


USE CCGS_PTR_CoreIssue
GO

BEGIN TRAN 
	DELETE from errortnp where ATID = 51 and tranid = 0
	--(1 row(s) deleted)
--COMMIT TRAN 
--ROLLBACK