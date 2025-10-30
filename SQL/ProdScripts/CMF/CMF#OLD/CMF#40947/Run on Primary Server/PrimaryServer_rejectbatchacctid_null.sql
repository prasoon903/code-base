
-- Run in Coreissue primary production database
use ccgs_coreissue 
Begin Tran 
--Commit 
--Rollback 
-- 1 row Update  in Each Statement 
Update ccard_primary set  rejectbatchacctid = null,artxntype ='91'  where  tranid = 29191724368 and accountnumber = '1100011111450015'
Update ccard_primary set  rejectbatchacctid = null  where  tranid = 27657664587  and accountnumber = '1100011103381863'