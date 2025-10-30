/*


  select AmtOfDispRelFromOTB,disputesamtns,* from Link_PROD1GSDB01.CCGS_Coreissue.dbo.Bsegment_Primary BP with(nolock) join Link_PROD1GSDB01.CCGS_Coreissue.dbo.Bsegment_Secondary BS with(nolock)
on(BP.acctid=BS.acctid)
where AmtOfDispRelFromOTB> disputesamtns

select AmtOfDispRelFromOTB,* from Link_PROD1GSDB01.CCGS_Coreissue.dbo.Bsegment_Primary with(nolock) where acctid  in(4639245)



*/

BEGIN Tran 

Update Bsegment_Primary SET AmtOfDispRelFromOTB = (AmtOfDispRelFromOTB - 22.99) where acctid=4639245
--1 row affceted

--commit Tran 
--rollback
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------


