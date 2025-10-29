IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ExternalFileProcessing') )
BEGIN
	CREATE TABLE DBO.ExternalFileProcessing
	(
		JobID decimal(19,0) identity(1,1),
		JobStatus varchar(30),	--Default 'NEW'
		FileName varchar(255),
		FileSource VARCHAR(30),
		FilePath VARCHAR(500),
		Date_Received DATETIME,
		ErrorReason VARCHAR(255),
		AlertSend TINYINT DEFAULT 0
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Apply_DBCr_FileDump') )
BEGIN
	CREATE TABLE DBO.Apply_DBCr_FileDump
	(
		[Invoice Id] varchar(240),
		[Invoice Create Ts]  varchar(240),
		[Transaction Method] varchar(240),
		[Transaction Type] varchar(240),
		[Response Id] varchar(240),
		[Pan Last 4 Nr] varchar(240),
		[Amount] varchar(240),
		[Publish Ts] varchar(240),
		Reserve1   varchar(240),
		Reserve2   varchar(240),
		Skey decimal(19,0) identity(1,1),
		JobID DECIMAL(19,0),
		JobStatus int DEFAULT 0
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Apply_DBCr_Transaction') )
BEGIN
	CREATE TABLE DBO.Apply_DBCr_Transaction
	(
		SKey DECIMAL(19,0) IDENTITY(1,1),
		JobID DECIMAL(19,0),	--JobId of Apply_DBCr_FileSource
		Invoice_Id varchar(240),
		Invoice_Create_Ts datetime,
		Transaction_Method varchar(50),
		Transaction_Type varchar(50),
		Response_Id varchar(240),
		Pan_Last_4_Nr int,
		Amount money,
		Publish_Ts datetime,
		AccountNumber varchar(200) NULL,
		TransactionDescription varchar(200) NULL,
		ActualTrancode varchar(200) NULL,
		AccountTransactionSequance int NULL,
		TransactionCount int NULL,
		TransactionAmount money NULL,
		TransactionStatus int NULL,
		InsitutionId int NULL,
		ProductId int NULL,
		TxnCode_Internal varchar(10) NULL,
		TranTime datetime NULL,
		PostTime datetime NULL,
		TransmissionDateTime datetime NULL,
		TxnAcctid int NULL,
		ATID int NULL,
		CMTTRANTYP varchar(10) NULL,
		TranPriority int NULL,
		PrimaryCurrencyCode varchar(40) NULL,
		MerchantId int NULL,
		CardAcceptorIdCode varchar(25) NULL,
		TranId decimal(19, 0) NULL,
		EffectiveDate datetime NULL,
		PostingRef varchar(100) NULL,
		InternalResponseCode varchar(100) NULL,
		PostingReason varchar(100) NULL,
		PrimaryAccountNumber varbinary(100) NULL,
		Pan_hash int NULL,
		CardNumber4Digits int NULL,
		ARTxnType varchar(10) NULL,
		PostingFlag varchar(10) NULL,
		EmbAcctID int NULL,
		NetworkName varchar(10) NULL,
		POSFiller varchar(10) NULL,
		TxnSource varchar(10) NULL,
		FileName varchar(100) NULL,
		FileID varchar(100) NULL,
		GUID varchar(400) NULL,
		CreditPlanMaster int NULL,
		RevTgt decimal(19,0),
		TotalRewardPoints money ,
		ClientId VARCHAR(64),
		MethodName INT,
		Reason VARCHAR(255),
		JobStatus int DEFAULT 0,
		ErrorReason varchar(100)		
	)
END