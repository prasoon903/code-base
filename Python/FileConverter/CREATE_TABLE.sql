DROP TABLE IF EXISTS RemediationData 
GO

CREATE TABLE RemediationData (
 [Skey] DECIMAL(19, 0) IDENTITY(1, 1) NOT NULL,
 [AccountUUID] VARCHAR(64) NULL,
 [TranTime] DATETIME NULL,
 [Amount] MONEY NULL,
 [AccountNumber] VARCHAR(19) NULL,
 [ManualStatus] INT NULL,
 [JobStatus] INT DEFAULT(0)
 ,

 CONSTRAINT csPk_RemediationData PRIMARY KEY CLUSTERED ( 
  [Skey] 
 
) 
  )


DROP TABLE IF EXISTS TransactionCreationTempData 
GO

CREATE TABLE TransactionCreationTempData (
 [Skey] DECIMAL(19, 0) IDENTITY(1, 1) NOT NULL,
 [TxnAcctId] INT NULL,
 [AccountNumber] VARCHAR(64) NULL,
 [TransactionAmount] MONEY NULL,
 [CMTTranType] VARCHAR(5) NULL,
 [ActualTranCode] VARCHAR(20) NULL,
 [TranTime] DATETIME NULL,
 [RevTgt] DECIMAL(19,0) NULL,
 [JobStatus] INT DEFAULT(0)
 ,

 CONSTRAINT csPk_TransactionCreationTempData PRIMARY KEY CLUSTERED ( 
  [Skey], [JobStatus]
 
) 
  )


--SELECT * FROM MonetaryTxnControl