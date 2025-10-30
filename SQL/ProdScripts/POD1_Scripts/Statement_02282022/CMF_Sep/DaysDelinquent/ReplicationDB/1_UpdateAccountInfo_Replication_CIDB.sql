

BEGIN TRAN 

 ---COMMIT TRAN 
 --ROLLBACK

 Update  accountinfoforreport SET AmtOfDispRelFromOTB = (AmtOfDispRelFromOTB  - 32.00) where businessday='2021-09-30 23:59:57.000' and bsacctid =223643
 --1 row affceted


