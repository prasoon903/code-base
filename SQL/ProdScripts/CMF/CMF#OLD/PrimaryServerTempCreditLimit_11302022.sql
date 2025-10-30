





Begin Tran

UPDATE TOP(1) StatementHeader SET TempCreditLimit = 6250.00 WHERE acctID = 609115 AND StatementDate = '2022-11-30 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 4000.00 WHERE acctID = 2218080 AND StatementDate = '2022-11-30 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 2500.00 WHERE acctID = 16958287 AND StatementDate = '2022-11-30 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 1000.00 WHERE acctID = 19095632 AND StatementDate = '2022-11-30 23:59:57'

--Commit 
--rollback 

/*Run in coreissue DB*/
-----------------------------------------step 1------------------------------

BEGIN TRANSACTION A

	DECLARE @CurrentTime DATETIME = GETDATE()
  
	Update ET Set ET.TranTime = @CurrentTime From ErrorTNp ET   WHERE 
	ET.ATID = 51 and ET.TranID IN (75279565985,75289725446,75373407447,75461904317,75655006986)
	--4 ROWS AFFECTED


	Update ET Set ET.TranTime = @CurrentTime, ET.PostTime = @CurrentTime From CCard_Primary ET   WHERE 
	ET.TranID IN (75279565985,75289725446,75373407447,75461904317,75655006986)
	 --4 ROWS AFFECTED
 
--COMMIT TRANSACTION A 
--ROLLBACK TRANSACTION A



-----------------------------------------step 2------------------------------

BEGIN TRANSACTION B

	INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag FROM ErrorTNP WITH(NOLOCK) WHERE ATID = 51
	AND TranID IN (75279565985,75289725446,75373407447,75461904317,75655006986)
	 --4 ROWS AFFECTED 
			       
	DELETE FROM ErrorTNP WHERE ATID = 51 AND TranID IN (75279565985,75289725446,75373407447,75461904317,75655006986)
	 --4 ROWS AFFECTED 


--COMMIT TRANSACTION B
--ROLLBACK TRANSACTION B

