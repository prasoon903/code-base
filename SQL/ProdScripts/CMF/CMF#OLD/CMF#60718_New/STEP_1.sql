-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO CreateNewSingleTransactionData (Accountnumber,transactionamount,ActualTrancode,Txnsource,reason,transactionstatus)
SELECT    accountnumber ,currentbalanceco,'5401', '2', 'CT_59662_Fix1_D',2 from bsegment_primary b with(nolock)  join  bsegmentcreditcard bcc  with(nolock)  on (b.acctid = bcc.acctid )where 
accountnumber in 
('1100011114160058',   
'1100011116450051',  
'1100011121228963',   
--'1100011137455550',   
'1100011151532664')