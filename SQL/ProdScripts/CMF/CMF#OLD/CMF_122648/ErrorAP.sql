Begin Tran

UPDATE TOP(1) CCard_Primary SET CreditPlanMaster = 13754 WHERE AccountNumber = '1100011103573402' AND TranID = 119487427120

--Commit 
--rollback 

/*Run in coreissue DB*/

-----------------------------------------step 2------------------------------

BEGIN TRANSACTION 

	INSERT INTO CommonAP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag, InstitutionID, Retries)  
	SELECT tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag , 6981, 0
	FROM ErrorAP WITH(NOLOCK) WHERE ATID = 51
	AND TranID IN (119487427120)
	 --1 ROWS AFFECTED 
			       
	DELETE FROM ErrorAP WHERE ATID = 51 AND TranID IN (119487427120)
	 --1 ROWS AFFECTED 

--COMMIT TRANSACTION 
--ROLLBACK TRANSACTION 

