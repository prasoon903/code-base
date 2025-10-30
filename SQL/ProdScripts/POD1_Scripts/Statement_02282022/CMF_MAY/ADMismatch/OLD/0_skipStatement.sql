 ---script need to  run ccgs_coreissue   database plat proudction  primary db
	Begin tran 
	--commit 
	--rollback
	 update  top(1) bsegment_primary    set NAD  = '2021-05-31 23:59:57.000'   where acctid  in (17346311) 
	update  top(1) Commontnp   set Trantime  = '2021-05-31 23:59:57.000' , tnpdate = '2021-05-31', NADandROOFlag =1  	 where 
	acctid  in (17346311)  and tranid = 0 and atid =51 
