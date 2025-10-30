--select top  100  *  from ErrorAp with(nolock) where tranid=139381376874
----------------------------step 1 ------------------------------------
begin Tran
update ccard_primary set noblobindicator = '5' where tranid = 138622357535
 --commit tran
 --rollback tran


----Verification Query 

select noblobindicator,memoindicator,transactiondescription,* from ccard_primary with (nolock) where tranid = 138622357535

-----------------------------step 2 ------------------------------------
Begin Tran

Insert into CommonAp(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID) 
select tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0,6981
from  ErrorAP with(nolock) where tranid =139381376874 and Acctid =2178450


--1 row affected
delete from ErrorAP where tranid =139381376874 and Acctid  =2178450
--1 row affected


--commit Tran
--Rollback Tran

----Verification Query 
--select top 10 * from CommonAp with(nolock) where tranid =139381376874
--select top 10 * from ErrorAP with(nolock) where tranid =139381376874
--select postingref,postingflag,* from ccard_primary with(nolock) where  tranid =139381376874
--select * from logartxnaddl with(nolock) where  tranid =139381376874
--select * from trans_in_acct with(nolock) where  tran_id_index =139381376874




--select institutionid from bsegment_primary with(nolock) where Acctid =2178450