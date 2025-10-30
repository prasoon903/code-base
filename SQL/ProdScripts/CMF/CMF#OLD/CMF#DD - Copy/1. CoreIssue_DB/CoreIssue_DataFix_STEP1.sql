USE CCGS_CoreIssue
GO

DROP TABLE IF EXISTS Temp_bsegment_DateDelinq
GO

CREATE TABLE Temp_bsegment_DateDelinq
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	AccountNumber VARCHAR(19),
	UniversalUniqueID VARCHAR(64),
	CycleDueDTD INT,
	DtOfLastDelinqCTD DATETIME, 
	DateOfOriginalPaymentDueDTD DATETIME,
	JobStatus INT 
)

DROP INDEX IF EXISTS IX_Temp_bsegment_DateDelinq_Skey ON Temp_bsegment_DateDelinq
CREATE CLUSTERED INDEX IX_Temp_bsegment_DateDelinq_Skey  
    ON dbo.Temp_bsegment_DateDelinq (Skey);   
GO  

DROP INDEX IF EXISTS IDX_Temp_bsegment_DateDelinq_JobStatus ON Temp_bsegment_DateDelinq

CREATE NONCLUSTERED INDEX IDX_Temp_bsegment_DateDelinq_JobStatus ON Temp_bsegment_DateDelinq
(
	JobStatus
)

-- TEMP DATA Tables

INSERT INTO Temp_bsegment_DateDelinq
SELECT
	BP.acctId, BP.AccountNumber, BP.UniversalUniqueID, CycleDueDTD, NULL, DateOfOriginalPaymentDueDTD, 0
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE CycleDueDTD < 2 AND DtOfLastDelinqCTD IS NOT NULL
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

-- 534 rows