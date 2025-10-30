DROP TABLE IF EXISTS Temp_bsegment_DelinqDays
GO

CREATE TABLE Temp_bsegment_DelinqDays
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	FirstDueDate DATETIME,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT, 
	DtOfLastDelinqCTD DATETIME, 
	DateOfOriginalPaymentDueDTD DATETIME,
	LAD DATETIME,
	DeAcctActivityDate DATETIME,
	ccinhparent125AID INT,
	ActualDRPStartDate DATETIME,
	JobStatus INT -- 0 = TNPJob, 1 = CalculateAndUpdate, 2 = DirectlyUpdate
)

DROP INDEX IF EXISTS IX_Temp_bsegment_DelinqDays_Skey ON Temp_bsegment_DelinqDays
CREATE CLUSTERED INDEX IX_Temp_bsegment_DelinqDays_Skey  
    ON dbo.Temp_bsegment_DelinqDays (Skey);   
GO  

DROP INDEX IF EXISTS IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays

CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DelinqDays_JobStatus ON Temp_bsegment_DelinqDays
(
	JobStatus
)

INSERT INTO Temp_bsegment_DelinqDays
SELECT
	BP.acctId, DateOfOriginalPaymentDueDTD, NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, 0
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'
-- 1203 rows



