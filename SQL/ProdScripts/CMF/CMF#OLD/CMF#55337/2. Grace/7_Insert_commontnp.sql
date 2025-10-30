
/*

verification-
select institutionid,hostmachinename,postingref,cmttrantype,bsacctid,claimid,Transactionamount,mergeactivityflag,* from [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.ccard_Primary with(nolock)
 where tranid in(43111232549)
 select institutionid,hostmachinename,postingref,cmttrantype,bsacctid,claimid,Transactionamount,mergeactivityflag,* from [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.ccard_Primary with(nolock)
 where tranid in(43111232550)
 select institutionid,hostmachinename,postingref,cmttrantype,bsacctid,claimid,Transactionamount,mergeactivityflag,* from [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.ccard_Primary with(nolock)
 where tranid in(43111232554)


select * from errortnp with(nolock) where Tranid=43111232554
select * from [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.trans_in_acct with(nolock) where Tran_id_index=43111232554


SELECT top 1 * FROM [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.commontnp WITH(NOLOCK) where Tranid=43111232554

select * from [Ls_PRODdrGSDB01].CCGS_COREissue.DBO.bsegment_Primary with(nolock) where acctid=1775930


*/
BEGIN TRANSACTION B

DECLARE @CurrentDate DATETIME
SET @CurrentDate = GetDate()


Update CCard_Primary set  TranTime = @CurrentDate,PostTime= @CurrentDate where tranid  IN (43111232549,43111232550,43111232554)
---(1 rows affected)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT '2021-08-06 00:00:00.000',0,@CurrentDate,43111232549,51,1937173,0,0,0,6981 
---1 row affcted

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT '2021-08-06 00:00:00.000',0,@CurrentDate,43111232550,51,2023541,0,0,0,6981 
---1 row affcted

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT '2021-08-06 00:00:00.000',0,@CurrentDate,43111232554,51,2033757,0,0,0,6981 
---1 row affcted


--Commit Transaction B 
--Rollback Transaction B 
