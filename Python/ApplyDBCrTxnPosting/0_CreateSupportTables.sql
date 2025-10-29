
-- Create DUMP Table for file 
drop table if exists Apply_DbCr_DUMP
Create Table  Apply_DbCr_DUMP
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
	Recordstatus int 
)


-- Create Main Table for Transaction Posting
drop table if exists Apply_DbCr
Create Table  Apply_DbCr
(
	[Invoice_Id] varchar(240),
	[Invoice_Create_Ts]  datetime,
	[Transaction_Method] varchar(50),
	[Transaction_Type] varchar(50),
	[Response_Id] varchar(240),
	[Pan_Last_4_Nr] int,
	[Amount] money,
	[Publish_Ts] datetime,
	[accountnumber] [varchar](200) NULL,
	[Transactiondescription] [varchar](200) NULL,
	[ActualTrancode] [varchar](200) NULL,
	[AccountTransactionSequance] [int] NULL,
	[TransactionCount] [int] NULL,
	[TransactionAmount] [money] NULL,
	[TransactionStatus] [int] NULL,
	[insitutionid] [int] NULL,
	[productid] [int] NULL,
	[txncode_internal] [varchar](10) NULL,
	[trantime] [datetime] NULL,
	[posttime] [datetime] NULL,
	[TransmissionDateTime] [datetime] NULL,
	[TxnAcctid] [int] NULL,
	[atid] [int] NULL,
	[cmttrantype] [varchar](10) NULL,
	[Tranpriority] [int] NULL,
	[PrimaryCurrencyCode] [varchar](40) NULL,
	[merchantid] [int] NULL,
	[cardacceptoridcode] [varchar](25) NULL,
	[tranid] [decimal](19, 0) NULL,
	[effectivedate] [datetime] NULL,
	[postingref] [varchar](100) NULL,
	[InternalResponseCode] [varchar](100) NULL,
	[PostingReason] [varchar](100) NULL,
	[Primaryaccountnumber] [varbinary](100) NULL,
	[Pan_hash] [int] NULL,
	[cardLastFourdegits] [int] NULL,
	[ArtxnType] [varchar](10) NULL,
	[PostingFlag] [varchar](10) NULL,
	[EmbAcctID] [int] NULL,
	[NetworkName] [varchar](10) NULL,
	[POSFiller] [varchar](10) NULL,
	[TXNSource] [varchar](10) NULL,
	[FileName] [varchar](100) NULL,
	[FileID] [varchar](100) NULL,
	[guid] [varchar](400) NULL,
	[creditplanmaster] [int] NULL,
	[revtgt] decimal(19,0),
	TotalRewardPoints money ,
	ClientId VARCHAR(64),
	MethodName INT,
	Reason VARCHAR(255),
	Skey decimal(19,0) identity(1,1),
	Recordstatus int ,
	ErrorReason varchar(100)		
)
