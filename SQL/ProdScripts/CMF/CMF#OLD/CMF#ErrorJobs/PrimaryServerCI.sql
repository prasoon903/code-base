-- step 1 

-- COMMIT 
BEGIN TRANSACTION
---- COMMIT 
---- ROLLBACK

UPDATE BSegment_Mstatuses SET EffectiveEndDate_MS = '2023-10-01 00:00:00' WHERE acctID = 506194 AND Skey = 525481077

UPDATE BSegment_Mstatuses SET EffectiveEndDate_MS = '2023-10-01 00:00:00' WHERE acctID = 2253373 AND Skey = 525791093
UPDATE BSegment_Mstatuses SET EffectiveEndDate_MS = '2023-10-01 00:00:01' WHERE acctID = 2253373 AND Skey = 523470457


-------------------------------------------------------------------------------------------------------------------------
---step 2
--COMMIT
BEGIN TRANSACTION
-- COMMIT 
-- ROLLBACK

	
	
	INSERT INTO CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID)
	SELECT E.tnpdate,E.priority,E.TranTime,E.TranId,E.ATID,E.acctId,E.ttid,E.NADandROOFlag,E.GetAllTNPJobsFlag,0,6981 
	FROM ErrorTNP E WITH (NOLOCK)
	--LEFT JOIN CommonTNP C WITH (NOLOCK) ON (E.acctId = C.acctId AND C.TranID = 0)
	WHERE E.acctID IN (506194, 2253373) AND E.ATID = 51 AND E.TranID = 0
	---1 Row insert

	DELETE FROM ErrorTNP  where  atid =51  and Tranid = 0  AND Acctid IN (506194, 2253373)
	--1 row delete 
				
