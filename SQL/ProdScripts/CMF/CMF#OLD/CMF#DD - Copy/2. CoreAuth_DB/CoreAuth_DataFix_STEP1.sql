USE CCGS_CoreAuth
GO

DROP TABLE IF EXISTS TEMP_CreditLimit
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

INSERT INTO TEMP_CreditLimit (acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus)
SELECT acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus
FROM CCGS_CoreIssue..Temp_bsegment_DateDelinq WITH (NOLOCK)
WHERE JobStatus = 1