USE [CCGS_CoreIssue]
GO

ALTER TABLE [dbo].[CreateNewSingleTransactionData] DROP CONSTRAINT [DF__CreateNew__Trans__1DC51125]
GO

/****** Object:  Table [dbo].[CreateNewSingleTransactionData]    Script Date: 5/22/2024 2:40:48 AM ******/
DROP TABLE [dbo].[CreateNewSingleTransactionData]
GO

/****** Object:  Table [dbo].[CreateNewSingleTransactionData]    Script Date: 5/22/2024 2:40:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CreateNewSingleTransactionData](
	[skey] [decimal](19, 0) IDENTITY(1,1) NOT NULL,
	[accountnumber] [varchar](200) NULL,
	[creditAmount] [money] NULL,
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
	[revtgt] [decimal](19, 0) NULL,
	[TotalRewardPoints] [money] NULL,
	[ClientId] [varchar](64) NULL,
	[MethodName] [int] NULL,
	[Reason] [varchar](255) NULL,
	[ScheduleId] [decimal](19, 0) NULL,
	[RMATranUUID] [varchar](64) NULL,
	[MemoIndicator] [varchar](5) NULL,
	[EntryReason] [char](1) NULL,
	[MergeActivityFlag] [tinyint] NULL,
	[PODID] [tinyint] NULL,
	[CustomerId] [varchar](25) NULL,
	[CPMgroup] [int] NULL,
	[FeesAcctID] [int] NULL,
	[TxnIsFor] [char](5) NULL,
	[ICCSysRelatedData] [varchar](255) NULL,
	[Amount16] [money] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CreateNewSingleTransactionData] ADD  DEFAULT ((0)) FOR [TransactionStatus]
GO


