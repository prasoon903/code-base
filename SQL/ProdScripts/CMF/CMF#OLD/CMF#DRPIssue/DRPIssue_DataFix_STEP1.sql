DROP TABLE IF EXISTS Temp_bsegment_DRP
GO

CREATE TABLE Temp_bsegment_DRP
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	ccinhparent125AID INT,
	SystemStatus INT,
	JobStatus INT 
)

DROP INDEX IF EXISTS IX_Temp_bsegment_DRP_Skey ON Temp_bsegment_DRP
CREATE CLUSTERED INDEX IX_Temp_bsegment_DRP_Skey  
    ON dbo.Temp_bsegment_DRP (Skey);   
GO  

DROP INDEX IF EXISTS IDX_Temp_bsegment_DRP_JobStatus ON Temp_bsegment_DRP

CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DRP_JobStatus ON Temp_bsegment_DRP
(
	JobStatus
)

INSERT INTO Temp_bsegment_DRP
SELECT
	acctId, ccinhparent125AID, SystemStatus, 0
FROM BSegment_Primary BP WITH (NOLOCK)
WHERE SystemStatus = 15991 AND CCInhParent125AID = 15996 And BillingCycle <>'LTD'
-- 227 rows



