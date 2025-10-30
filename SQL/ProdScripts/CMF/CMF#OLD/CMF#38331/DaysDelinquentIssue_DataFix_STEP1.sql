DROP TABLE IF EXISTS Temp_bsegment_DelinqDays
GO

CREATE TABLE Temp_bsegment_DelinqDays
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT,
	JobStatus INT 
)

DROP INDEX IF EXISTS IX_Temp_bsegment_DelinqDays_Skey ON Temp_bsegment_DelinqDays

CREATE CLUSTERED INDEX IX_Temp_bsegment_DelinqDays_Skey  
    ON Temp_bsegment_DelinqDays (Skey);   
GO  

DROP INDEX IF EXISTS IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays

CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays
(
	JobStatus
)

INSERT INTO Temp_bsegment_DelinqDays
SELECT
	BP.acctId, NoPayDaysDelinquent, DaysDelinquent, 0 AS JobStatus
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus = 14 And BillingCycle <>'LTD'
-- 660 rows

UPDATE Temp_bsegment_DelinqDays
SET DaysDelinquent = DaysDelinquent + 31
WHERE acctId = 739959
-- 1 row





