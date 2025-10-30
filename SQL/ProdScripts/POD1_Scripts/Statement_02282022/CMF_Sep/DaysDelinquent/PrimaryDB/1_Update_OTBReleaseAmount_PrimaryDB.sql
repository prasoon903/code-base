

BEGIN Tran 
--commit Tran 
--rollback

Update Bsegment_Primary SET AmtOfDispRelFromOTB = (AmtOfDispRelFromOTB - 32.00) where acctid=223643
--1 row affceted


