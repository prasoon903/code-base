BEGIN TRAN
--COMMIT 
--ROLLBACK

UPDATE BC
SET DateOfLastDelinquent = T.DtOfLastDelinqCTD 
FROM BSegment_Primary BC WITH (NOLOCK)
JOIN ##TempDelinq T ON (BC.acctID = T.BSAcctID)