SELECT count(1) from CommonTnp WITH(Nolock) where trantime < getdate()

select * from Manual_LoyaltyTransactionMessage with(nolock) 

select transtatus , count(1) as records from Manual_LoyaltyTransactionMessage with(nolock)
group by transtatus

--0 after entry create Manual_LoyaltyTransactionMessage
--1 after 1st sp executed entry 
--2 after 2st sp executed entry 

select top 10 *  from clearingfiles with(nolock) 
order by jobid desc

--execute only when 
--1. no IPM processing, 
--2. After EOD changed
--3. No backlog should be be there


--=CONCATENATE("INSERT INTO #tempdata (ClientID,AccountUUID,TransactionAmount) VALUES ('",B2,"','",A2,"',",D2,")")


