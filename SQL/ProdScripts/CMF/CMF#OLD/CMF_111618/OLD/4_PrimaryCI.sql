--SELECT * FROM ErrorTNP WITH (NOLOCK)


-----------------------------------------step 1------------------------------

BEGIN TRANSACTION A

	DECLARE @CurrentTime DATETIME = GETDATE()
  
	Update ET Set ET.TranTime = @CurrentTime From ErrorTNp ET   WHERE 
	ET.ATID = 51 and ET.TranID IN (107165133596)
	--1 ROWS AFFECTED

	Update ET Set ET.TranTime = @CurrentTime, ET.PostTime = @CurrentTime From CCard_Primary ET   WHERE 
	ET.TranID IN (107165133596)
	 --1 ROWS AFFECTED
 
--COMMIT TRANSACTION A 
--ROLLBACK TRANSACTION A



-----------------------------------------step 2------------------------------

BEGIN TRANSACTION B

	INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag FROM ErrorTNP WITH(NOLOCK) WHERE ATID = 51
	AND TranID IN (107165133596)
	 --1 ROWS AFFECTED 
			       
	DELETE FROM ErrorTNP WHERE ATID = 51 AND TranID IN (107165133596)
	 --1 ROWS AFFECTED  

--COMMIT TRANSACTION B
--ROLLBACK TRANSACTION B

