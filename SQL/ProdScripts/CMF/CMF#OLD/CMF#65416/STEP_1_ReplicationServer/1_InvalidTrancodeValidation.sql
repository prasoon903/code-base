---- Script  to insert record  for true up  data feed 
--- Need to run ccgs_rpt_coreisse reporting database  in plat production pod1 

use  ccgs_rpt_coreisse 


	select accountnumber,coreasonCode ,MTCGrpName   into #bsegment1   
	from  bsegment_primary  b  with(nolock)  join astatusaccounts  a  with(nolock) 
	  on (b.ccinhparent125aid = a.acctid )   where  ccinhparent125aid 
	 in  (select acctid  from astatusaccounts  with(nolock) where  coreasonCode is not null  and parent01aid  =1 )
	 and systemstatus  = 14  and accountnumber not in
	  (
	  select bp.Accountnumber  from ccard_primary  c  with(nolock) join 
	  bsegment_primary  bp  with(nolock) on (c.accountnumber = bp.accountnumber )  
	  where bp.systemstatus = 14 and bp.billingcycle ='31'  and   cmttrantype = 'RCLS'  and  posttime  > getdate()  and posttime  <  '2022-03-31 23:59:57')




	select    row_number()   over (partition by  C.accountnumber  order by posttime  desc )as rk1,
	C.accountnumber ,tranid ,BP.coreasonCode,c.posttime ,txncode_internal,Transactiondescription  ,c.cmttrantype, c.artxntype,transactionamount,MTCGrpName  into  #ccard5111
	  from    ccard_primary  c with(nolock) join
	  #bsegment1   bp    on  c.accountnumber  = bp.accountnumber  where  CMTTrantype = '51 '
	  --and accountnumber not in (select Accountnumber  from ccard_primary   with(nolock) where cmttrantype = 'RCLS'  and  posttime  > getdate())
	--select * from  #ccard51


	IF OBJECT_ID('dbo.Ccard_CorrectionTranID') IS  NULL 
	Begin 
	 Create  Table Ccard_CorrectionTranID
	 (
		tranid   decimal(19,0),
		cmttrantype varchar(8),
		accountnumber varchar(19),
		posttime datetime,
		Transactiondescription varchar(100),
		artxntype varchar(5),
		transcationamount money,
		coreasonCode varchar(5) ,
		MTCGrpName varchar(10),
		RowStatus int default(0)

	 )
	 END





	 insert into Ccard_CorrectionTranID
	select c.tranid,c.cmttrantype, c.accountnumber,c.posttime ,c.transactiondescription CurrentTxnDesc,artxntype,transactionamount,c.coreasonCode,MTCGrpName,0 --into #finatransactions 
	 from   #ccard5111 c
	 join  monetarytxncontrol  m  with(nolock)   on    (c.txncode_internal  = m.transactioncode )
	 join  trancodelookup  t  with(nolock)   on    (t.Lutcode  = m.transactioncode  and lutid = 'trancode ')
	 where  ((M.chargeoffreason <> c.coreasonCode  )  or 
	 (M.chargeoffreason is  null  ))
	 AND rk1  =1 --and  coreasoncode  = 3   --and accountnumber  = '1100011104947639'
	 --order by posttime   desc    
	


	 insert into Ccard_CorrectionTranID
	select c.tranid,c.cmttrantype, c.accountnumber,c.posttime ,c.transactiondescription CurrentTxnDesc,c.artxntype,c.transactionamount ,f.coreasonCode,f.MTCGrpName,0
	from  Ccard_CorrectionTranID  f join  ccard_primary c   with(nolock)on   (f.PostTime = c.PostTime and f.accountnumber = c.accountnumber )
	 
	 join  monetarytxncontrol  m  with(nolock)   on    (c.txncode_internal  = m.transactioncode )
	 join  trancodelookup  t  with(nolock)   on    (t.Lutcode  = m.transactioncode  and lutid = 'trancode ')
	 where   c.cmttrantype  in ('160','161','167') and f.rowstatus =0 --and  coreasoncode  = 3   --and accountnumber  = '1100011104947639'
	-- order by posttime   desc 

	


