-- TO BE RUN ON PRIMARY SERVER COREISSUE DATABASE

-- Trancode Fix 
Begin  Tran 
-- Commit 
-- Rollback 


Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011111379099   ' and   tranid  =  47751542290
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011106167244   ' and   tranid  =  47932803719
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011138693670   ' and   tranid  =  48230790208
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011103026252   ' and   tranid  =  48230790229
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011137796490   ' and   tranid  =  48639231650
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011125396089   ' and   tranid  =  49644906635
Update ccard_primary  set txncode_internal = '17785' , Transactiondescription = '16004 =  PRINCIPLE CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011147954006   ' and   tranid  =  50355008140
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011125396089   ' and   tranid  =  49644906636
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011137796490   ' and   tranid  =  48639231653
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011103026252   ' and   tranid  =  48230790230
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011138693670   ' and   tranid  =  48230790209
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011106167244   ' and   tranid  =  47932803720
Update ccard_primary  set txncode_internal = '17794' , Transactiondescription = '16104 =  INTEREST CHARGE-OFF DEBIT - FRAUD'  where   accountnumber    = '1100011111379099   ' and   tranid  =  47751542291
Update ccard_primary  set txncode_internal = '17848' , Transactiondescription = '16704 = REWARDS REVERSAL CHARGE CHARGE-OFF DEBIT- FRAUD'  where   accountnumber    = '1100011106167244   ' and   tranid  =  47932803715
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011111379099   ' and   tranid  =  47751542287
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011106167244   ' and   tranid  =  47932803710
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011138693670   ' and   tranid  =  48230790200
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011103026252   ' and   tranid  =  48230790228
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011137796490   ' and   tranid  =  48639231647
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011125396089   ' and   tranid  =  49644906628
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011147954006   ' and   tranid  =  50355008137
Update ccard_primary  set txncode_internal = '17995' , Transactiondescription = '5104 =  MANUAL CHARGE-OFF - FRAUD'  where   accountnumber    = '1100011127791436   ' and   tranid  =  50355008139


Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  47751542290
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  47932803719
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  48230790208
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  48230790229
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  48639231650
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  49644906635
Update logartxnaddl   set txncode_internal = '17785' where    tranid  =  50355008140
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  49644906636
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  48639231653
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  48230790230
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  48230790209
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  47932803720
Update logartxnaddl   set txncode_internal = '17794' where    tranid  =  47751542291
Update logartxnaddl   set txncode_internal = '17848' where    tranid  =  47932803715
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  47751542287
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  47932803710
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  48230790200
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  48230790228
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  48639231647
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  49644906628
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  50355008137
Update logartxnaddl   set txncode_internal = '17995' where    tranid  =  50355008139