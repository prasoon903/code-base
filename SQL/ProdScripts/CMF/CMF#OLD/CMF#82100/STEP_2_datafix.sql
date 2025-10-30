/*  select * from  trans_in_acct where tran_id_index =76646908042 and acctid =18248721
select * from  currentbalanceaudit  with(nolock) where tid =76646908042 and aid =18248721
select * from  currentbalanceauditps  with(nolock) where tid =76646908042 and aid =56061388
select * from  LS_P1MARPRODDB01.ccgs_coreissue.dbo.plandelinquencyrecord where tranref =76646908042 and parent02aid =18248721
select accountnumber,bsacctid,tranref,tranorig,* from  ccard_primary   with(nolock) where tranref =76646908042 and accountnumber = '1100011182704787   '
*/
--<newtranid>  need to replace with tranid generated from step1 
--Script need to run on coreissue primary  database 
Begin  Tran 
--Commit 
--rollback

update top(1) trans_in_acct set tran_id_index =<newtranid>   where tran_id_index =76646908042 and acctid =18248721
update top(7) currentbalanceaudit set tid =<newtranid>   where tid =76646908042 and aid =18248721
update top(6) currentbalanceauditps  set tid =<newtranid>  where tid =76646908042 and aid =56061388
update top(2) plandelinquencyrecord set tranref = <newtranid> where tranref =76646908042 and parent02aid =18248721
update top(5) ccard_primary    set tranref = <newtranid>, tranorig =<newtranid> where tranref =76646908042 and accountnumber = '1100011182704787   '
update  top(1) ccard_primary  set  tranref = <newtranid>,tranorig = <newtranid> , accountnumber = '1100011182704787   ' where tranid =76828343458
update top(1) logartxnaddl  set tranid= <newtranid>  where tranid =76646908042 and artxntype = '91'
INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, revtgt)
values  (18248721,'1100011182704787','71.00','22','2202',<newtranid>)

               