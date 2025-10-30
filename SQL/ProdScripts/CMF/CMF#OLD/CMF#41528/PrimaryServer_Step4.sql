-- TO BE RUN ON PRIMARY SERVER ONLY

DELETE FROM ILPScheduleDetailsBad WHERE Skey IN
(
255999, 
255997, 
255991, 
255995, 
256012, 
256010, 
256014, 
255996, 
255990, 
256000, 
255994, 
256003, 
256013, 
255989, 
256002, 
256007, 
255992, 
255993, 
256004
)

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION  
  
    UPDATE ILPS  
    SET  
    ILPS.ScheduleType = 1,  
    ILPS.FileDueToError = TT.FileName  
    FROM ILPScheduleDetailSummary ILPS  
    JOIN #TempUpdateSchedules TT ON (ILPS.PlanUUID = TT.PlanUUID)  
  
    UPDATE ILPD  
    SET  
    JobStatus = 1  
    FROM ILPScheduleDetailsBAD ILPD WITH (NOLOCK)  
    JOIN #TempUpdateSchedules TT ON (ILPD.Skey = TT.Skey)  

--ROLLBACK TRANSACTION
-- COMMIT TRANSACTION

--DROP TABLE iF EXISTS #TempUpdateSchedules
--GO

-- CREATE TABLE #TempUpdateSchedules  
-- (  
--  Skey DECIMAL(19,0)  
--  , UniversalUniqueID VARCHAR(64)  
--  , PlanUUID VARCHAR(64)  
--  , ScheduleID DECIMAL(19,0)  
--  , FileName VARCHAR(300)  
-- ) 



--INSERT INTO #TempUpdateSchedules  
--SELECT --TOP (@BatchCount)  
--    Skey,  
--    UniversalUniqueID,  
--    PlanUUID,  
--    ScheduleID,  
--    FileName + '_FileID_' + FileID  
--FROM 

--ILPScheduleDetailsBAD WITH (NOLOCK)  
--WHERE JobStatus = 0 AND FileName = 'amortization_schedule_error_feed_20200821.csv' AND FileID = '202008220414371' 



   
