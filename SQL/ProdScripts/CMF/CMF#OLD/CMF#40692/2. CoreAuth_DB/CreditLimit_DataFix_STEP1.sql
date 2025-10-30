USE CCGS_CoreAuth
GO

DROP TABLE IF EXISTS TEMP_CreditLimit
GO

CREATE TABLE TEMP_CreditLimit
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	acctId INT,
	AccountNumber VARCHAR(19),
	AccountUUID VARCHAR(64),
	CreditLimit MONEY,
	SystemStatus INT,
	JobStatus INT 
)

DROP INDEX IF EXISTS IX_TEMP_CreditLimit_Skey ON TEMP_CreditLimit
CREATE CLUSTERED INDEX IX_TEMP_CreditLimit_Skey  
    ON dbo.TEMP_CreditLimit (Skey);   
GO  

DROP INDEX IF EXISTS IDX_TEMP_CreditLimit_JobStatus ON TEMP_CreditLimit

CREATE NONCLUSTERED INDEX IDX_TEMP_CreditLimit_JobStatus ON TEMP_CreditLimit
(
	JobStatus
)

INSERT INTO TEMP_CreditLimit (acctId, AccountNumber, AccountUUID, CreditLimit, SystemStatus, JobStatus)
SELECT acctId, AccountNumber, AccountUUID, CreditLimit, SystemStatus, JobStatus
FROM CCGS_CoreIssue..TEMP_CreditLimit WITH (NOLOCK)
WHERE JobStatus = 1