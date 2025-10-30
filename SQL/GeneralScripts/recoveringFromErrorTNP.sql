-----part2 Error Tnp Reprocessing
--Begin Transaction 

--  INSERT INTO CommonTNP (tnpdate ,priority ,TranTime, TranId ,ATID, acctId, ttid, NADandROOFlag, GetAllTNPJobsFlag,institutionid)  
--    SELECT tnpdate ,priority ,TranTime, TranId ,ATID, acctId, ttid, NADandROOFlag, GetAllTNPJobsFlag,3189 FROM ErrorTNP WHERE acctid = 167413  and  TranId =123372036854775808
----1 Row inserted
    
--    DELETE FROM ErrorTNP WHERE acctid = 167413  and  TranId =123372036854775808
--1 Row deleted
   
   
   
---  COMMIT TRANSACTION 
--rollback