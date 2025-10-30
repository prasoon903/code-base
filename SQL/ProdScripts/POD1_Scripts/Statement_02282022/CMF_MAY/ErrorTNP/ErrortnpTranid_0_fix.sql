-- script need to run on ccgs_coreissue  plat production primary database 



/*

-- To get  bad  lad accounts 
select billingCycle,dateofnextstmt,lad,acctid  from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bsegment_Primary with(nolock)  where   lad > dateofnextstmt  and billingcycle = '31'
order by acctid  desc

select * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.commontnp with(nolock) where Tranid in(40271103970,40271105207,40271115445,
	40271127132,40271129303,40271129468,40271130923,40271131480,40271131481,40271131615,
	40271131723,40271131839,40271142340,40271142378,40271152629,40271154962,40271155186)


select * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.errortnp with(nolock) 
select billingCycle,dateofnextstmt,lad,* from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bsegment_Primary with(nolock)  where 
acctid in(254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)
order by acctid  desc


select lad,lapd,* from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.cpsgmentaccounts with(nolock)  where 
parent02aid in(254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)


select lad,lapd,* from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.lpsegmentaccounts with(nolock)  where 
parent02aid in(254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)


select  * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.statementheaderex with(nolock) where acctid in(254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)
and Statementdate='2021-05-31 23:59:57.000' order by Statementdate desc
*/

----------------------------------------------------Step 1 -------------------------------------------
use ccgs_coreissue 
	 Begin  Tran
	 -- Commit 
	 -- Rollback
	 Update   top(14) bsegment_primary  set  lad = '2021-05-31 23:59:56.000' , lapd = '2021-05-31 23:59:56.000' where 
	 acctid  in (254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)
	 Update   top(32) cpsgmentaccounts  set  lad = '2021-05-31 23:59:56.000' , lapd = '2021-05-31 23:59:56.000' where 
	 parent02aid  in (254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)
	 Update   top(14) lpsegmentaccounts  set  lad = '2021-05-31 23:59:56.000' , lapd = '2021-05-31 23:59:56.000' where 
	 parent02aid  in (254395,1984467,15324580,2441118,2206644,2187713,515098,538391,12479783,9580193,4090858,1331485,17708829,17683134)


-----------------------------------step 2 Tranid=0 Errortnp Reprocess-------------------------------------

use ccgs_coreissue 
	 Begin  Tran
	 -- Commit 
	 -- Rollback


		INSERT INTO CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID)
		SELECT ET.tnpdate,ET.priority,ET.Trantime,ET.TranId,ET.ATID,ET.acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0,6981 
		FROM ErrorTNP ET with(nolock) 
		where ET.atid =51 and  tranid = 0 AND acctId IN (254395,515098,538391,1331485,1984467)
		--5 Row insert 
		DELETE FROM ErrorTNP where atid =51 and  tranid = 0 AND acctId IN (254395,515098,538391,1331485,1984467)
		--5 row deleted


---------------------------------Step 3 Tranid Errortnp Reprocess----------------------------
use ccgs_coreissue 
	 Begin  Tran
	 -- Commit 
	 -- Rollback

	INSERT INTO COMMONTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID)
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0,6981 FROM Errortnp WHERE TRANID IN (40271103970,40271105207,40271115445,
	40271127132,40271129303,40271129468,40271130923,40271131480,40271131481,40271131615,
	40271131723,40271131839,40271142340,40271142378,40271152629,40271154962,40271155186)
	--17 ROWS INSERTED

	DELETE FROM Errortnp WHERE TRANID IN (40271103970,40271105207,40271115445,
	40271127132,40271129303,40271129468,40271130923,40271131480,40271131481,40271131615,
	40271131723,40271131839,40271142340,40271142378,40271152629,40271154962,40271155186)
	--17 ROWS DELETED
