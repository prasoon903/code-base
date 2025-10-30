declare @tranid decimal(19, 0)
	   ,@postvalue_stepsize int
	   ,@vartwid int
	   ,@txncode_internal varchar(20)
	   ,@actualtrancode varchar(20)
	   ,@transactiondescription varchar(100)
	   ,@logicmodule varchar(20)


; WITH CTE AS (
SELECT M.NTDReportInitiate 
FROM MonetaryTxnControl M WITH(NOLOCK) 
JOIN TranCodeLookUp T WITH(NOLOCK) ON T.LUTid = 'TranCode' AND T.LutCode = M.TransactionCode
WHERE M.GroupId = 53 
AND M.LogicModule = '21'
AND M.NTD_Action = 1
)
SELECT 
	 @actualtrancode = M.ActualTranCode,
	 @transactiondescription = T.LutDescription ,
	 @logicmodule = M.LogicModule,
	 @txncode_internal = M.TransactionCode
FROM MonetaryTxnControl M WITH(NOLOCK) 
JOIN TranCodeLookUp T WITH(NOLOCK) ON T.LUTid = 'TranCode' AND T.LutCode = M.TransactionCode			
WHERE M.GroupId = 53 
AND M.TransactionCode  IN (SELECT NTDReportInitiate FROM CTE)


exec usp_getset_postvalues_sf_sql @procedureid = @@procid
									,@pid = @@spid
									,@namekey = 'tranid'
									,@hostname = ''
									,@reservecount = 1
									,@sequenceid = @tranid output
									,@postvalue_stepsize = @postvalue_stepsize output
									,@in_twid = @vartwid output

begin try
	begin transaction

	insert into ccard_primary (tranid, posttime, trantime, cardacceptoridcode, cardacceptorbusinesscode, txnacctid, primarycurrencycode, cmttrantype, txncode_internal, transactiondescription, bsacctid, tranref, tranorig, cardnumber4digits, reversed, transactionamount, postingreason, postingref, txnsource, artxntype, memoindicator, priority, txnisfor, productid, institutionid, creditplanmaster, accountnumber, claimid, embacctid, clientid, customerid, transactioncurrencycode)
	select @tranid, posttime, posttime, cardacceptoridcode, cardacceptorbusinesscode, txnacctid, cp.primarycurrencycode, @logicmodule CMTTranType, @txncode_internal TxnCode_Internal, @transactiondescription TransactionDescription, cp.bsacctid, tranid TranRef, tranid TranOrig, cardnumber4digits, reversed, transactionamount, postingreason, postingref, txnsource, '991' artxntype,'memo' memoindicator, priority, txnisfor, cp.productid, cp.institutionid, creditplanmaster, cp.accountnumber, cp.claimid, embacctid, clientid, customerid, transactioncurrencycode
	from ccard_primary cp with(nolock)
	join nontxndisputelog n with(nolock) on cp.bsacctid = n.bsacctid and cp.claimid = n.claimid
	join nontxndisputestatuslog ns with(nolock) on cp.bsacctid = ns.bsacctid and cp.claimid = ns.claimid
	where n.claimid = '29911150-2822-41d0-a2df-a4a718650002' and ns.disputestage = 1
	and cp.tranid = ns.disputegeneratedtranid



	insert into logartxnaddl (tranid, artxnbusinessdate, txncode_internal, artxntype, institutionid, productid, cardacceptoridcode, cmttrantype, transactionamount, creditplanmaster, mtcgrpname, settlementdate, mccplancode, podid)
	select @tranid TranID, l.artxnbusinessdate, @txncode_internal txncode_internal, '991' artxntype, l.institutionid, l.productid, l.cardacceptoridcode, @logicmodule cmttrantype, l.transactionamount, l.creditplanmaster, l.mtcgrpname, l.settlementdate, l.mccplancode, '1' podid
	from logartxnaddl l with(nolock)
	join ccard_primary cp with(nolock) on l.tranid = cp.tranid 
	left join ccard_secondary cs with(nolock) on cp.tranid = cs.tranid 
	join nontxndisputelog n with(nolock) on cp.bsacctid = n.bsacctid and cp.claimid = n.claimid
	join nontxndisputestatuslog ns with(nolock) on cp.bsacctid = ns.bsacctid and cp.claimid = ns.claimid
	where n.claimid = '29911150-2822-41d0-a2df-a4a718650002' and ns.disputestage = 1
	and cp.tranid = ns.disputegeneratedtranid


	update ns
	set disputestage = 2,
		disputereporttranid = @tranid, 
		disputereporttxncode_internal = @txncode_internal
	from nontxndisputestatuslog ns
	where claimid = '29911150-2822-41d0-a2df-a4a718650002' and disputestage = 1



	update n
	set actualdisputeamount = disputeamount
	from nontxndisputelog n
	where claimid = '29911150-2822-41d0-a2df-a4a718650002' 

	commit transaction
end try
begin catch
	if @@trancount >0
        rollback transaction 
    select error_message(),error_line(),error_number()
    raiserror('error occured :-', 16, 1);
end catch
