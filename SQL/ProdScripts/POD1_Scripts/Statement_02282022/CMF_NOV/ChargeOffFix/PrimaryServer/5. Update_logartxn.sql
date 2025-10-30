-- TO BE RUN ON PRIMARY SERVER ONLY


Begin transaction
--commit
--rollback

 Update top (1) disputestatuslog SET ExcludeFlag =NULL WHERE  DisputeTranID in(50504946961)
 Update top (1) logartxnaddl SET ExcludeFlag =NULL  WHERE TranID in(50504946961)

 
 
 Update top (1) disputestatuslog SET ExcludeFlag ='1' WHERE  DisputeTranID in(50100071319)
 Update top (1) logartxnaddl SET ExcludeFlag ='1'  WHERE TranID in(50100071319)
