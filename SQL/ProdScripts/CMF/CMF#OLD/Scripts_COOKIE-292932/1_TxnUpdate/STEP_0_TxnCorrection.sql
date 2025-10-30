DROP INDEX IF EXISTS IX_SN ON TEMP_IncorrectCPMCorrection
CREATE CLUSTERED INDEX IX_SN ON TEMP_IncorrectCPMCorrection 
(
	SN
) 

DROP INDEX IF EXISTS IX_JobStatus ON TEMP_IncorrectCPMCorrection
CREATE NONCLUSTERED INDEX IX_JobStatus ON TEMP_IncorrectCPMCorrection 
(
	JobStatus
) 

DROP INDEX IF EXISTS IX_AccountTranId ON TEMP_IncorrectCPMCorrection
CREATE NONCLUSTERED INDEX IX_AccountTranId ON TEMP_IncorrectCPMCorrection 
(
	AccountNumber, TranID
)