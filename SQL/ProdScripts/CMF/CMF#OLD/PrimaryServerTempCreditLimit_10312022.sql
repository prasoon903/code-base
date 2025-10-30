





Begin Tran

UPDATE TOP(1) StatementHeader SET TempCreditLimit = 5250.00 WHERE acctID = 539180 AND StatementDate = '2022-10-31 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 6800.00 WHERE acctID = 2869796 AND StatementDate = '2022-10-31 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 4500.00 WHERE acctID = 3979730 AND StatementDate = '2022-10-31 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 1500.00 WHERE acctID = 5515390 AND StatementDate = '2022-10-31 23:59:57'
UPDATE TOP(1) StatementHeader SET TempCreditLimit = 2000.00 WHERE acctID = 6845814 AND StatementDate = '2022-10-31 23:59:57'

--Commit 
--rollback 

/*Run in coreissue DB*/
-----------------------------------------step 1------------------------------

BEGIN TRANSACTION A

	DECLARE @CurrentTime DATETIME = GETDATE()
  
	Update ET Set ET.TranTime = @CurrentTime From ErrorTNp ET   WHERE 
	ET.ATID = 51 and ET.TranID IN (73295299360,73422227995,73436534725)
	--3 ROWS AFFECTED


	Update ET Set ET.TranTime = @CurrentTime, ET.PostTime = @CurrentTime From CCard_Primary ET   WHERE 
	ET.TranID IN (73295299360,73422227995,73436534725)
	 --3 ROWS AFFECTED
 
--COMMIT TRANSACTION A 
--ROLLBACK TRANSACTION A



-----------------------------------------step 2------------------------------

BEGIN TRANSACTION B

	INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag FROM ErrorTNP WITH(NOLOCK) WHERE ATID = 51
	AND TranID IN (73295299360,73422227995,73436534725)
	 --3 ROWS AFFECTED 
			       
	DELETE FROM ErrorTNP WHERE ATID = 51 AND TranID IN (73295299360,73422227995,73436534725)
	 --3 ROWS AFFECTED 


--COMMIT TRANSACTION B
--ROLLBACK TRANSACTION B

