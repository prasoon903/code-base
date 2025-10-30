Begin Tran

UPDATE  top(1) StatementHeader SET TempCreditLimit = 4500 WHERE acctID = 4277019 AND StatementDate = '2022-08-31 23:59:57'
UPDATE top(1) StatementHeader SET TempCreditLimit = 1500 WHERE acctID = 15693440 AND StatementDate = '2022-08-31 23:59:57'
UPDATE top(1)  StatementHeader SET TempCreditLimit = 3000 WHERE acctID = 19630016 AND StatementDate = '2022-08-31 23:59:57'

--Commit 
--rollback 

/*Run in coreissue DB*/
-----------------------------------------step 1------------------------------

BEGIN TRANSACTION A

	DECLARE @CurrentTime DATETIME = GETDATE()
  
	Update ET Set ET.TranTime = @CurrentTime From ErrorTNp ET   WHERE 
	ET.ATID = 51 and ET.TranID IN (69249278492, 69371281663, 69424397339, 69080722552, 69080785253)
	--5 ROWS AFFECTED

	Update ET Set ET.TranTime = @CurrentTime From ErrorTNp ET   WHERE 
	ET.ATID = 51 and ET.acctId IN (18698831, 20437365, 21269554) and Et.tranid =0 
	--3 ROWS AFFECTED

	Update ET Set ET.TranTime = @CurrentTime, ET.PostTime = @CurrentTime From CCard_Primary ET   WHERE 
	ET.TranID IN (69249278492, 69371281663, 69424397339, 69080722552, 69080785253)
	 --5 ROWS AFFECTED
 
--COMMIT TRANSACTION A 
--ROLLBACK TRANSACTION A



-----------------------------------------step 2------------------------------

BEGIN TRANSACTION B

	INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag FROM ErrorTNP WITH(NOLOCK) WHERE ATID = 51
	AND TranID IN (69249278492, 69371281663, 69424397339, 69080722552, 69080785253)
	 --5 ROWS AFFECTED 
			       
	DELETE FROM ErrorTNP WHERE ATID = 51 AND TranID IN (69249278492, 69371281663, 69424397339, 69080722552, 69080785253)
	 --5 ROWS AFFECTED 

	INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag FROM ErrorTNP WITH(NOLOCK) WHERE ATID = 51
	AND acctId IN (18698831, 20437365, 21269554) and tranid =0
	 --3 ROWS AFFECTED 
			       
	DELETE FROM ErrorTNP WHERE ATID = 51 AND acctID IN (18698831, 20437365, 21269554) and tranid =0
	 --3 ROWS AFFECTED 

--COMMIT TRANSACTION B
--ROLLBACK TRANSACTION B

