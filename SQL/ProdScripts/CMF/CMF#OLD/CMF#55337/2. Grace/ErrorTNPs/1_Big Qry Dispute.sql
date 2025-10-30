

select tranid,skey 
into #del 
From purchasereversalrecord pr with(nolock) 
where parent02aid = 2910772 --5231

--------------------------------------------

begin transaction
--commit
--rollback

delete from purchasereversalrecord where tranid in (select tranid from #del with(nolock))
and skey in (select skey from #del with(nolock)) --5231

