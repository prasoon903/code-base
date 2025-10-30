-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


INSERT INTO CreateNewSingleTransactionData (Accountnumber,transactionamount,ActualTrancode,Txnsource,reason,transactionstatus)
SELECT    accountnumber ,currentbalanceco,'5401', '2', 'CT_1231_21_Fix1_D',2 from bsegment_primary b with(nolock)  join  bsegmentcreditcard bcc  with(nolock)  on (b.acctid = bcc.acctid )where 
accountnumber in 
('1100011137885491',   
'1100011139323723',   
'1100011171179397')