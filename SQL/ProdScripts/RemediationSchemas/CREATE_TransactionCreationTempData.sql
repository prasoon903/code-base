USE [CCGS_CoreIssue]
GO

ALTER TABLE [dbo].[TransactionCreationTempData] DROP CONSTRAINT [DF__Transacti__JobSt__1D6F71DD]
GO

/****** Object:  Table [dbo].[TransactionCreationTempData]    Script Date: 5/22/2024 2:41:54 AM ******/
DROP TABLE [dbo].[TransactionCreationTempData]
GO

/****** Object:  Table [dbo].[TransactionCreationTempData]    Script Date: 5/22/2024 2:41:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransactionCreationTempData](
	[SN] [int] IDENTITY(1,1) NOT NULL,
	[TxnAcctId] [int] NULL,
	[AccountNumber] [varchar](19) NULL,
	[TransactionAmount] [money] NULL,
	[CMTTranType] [varchar](10) NULL,
	[ActualTranCode] [varchar](20) NULL,
	[TranTime] [datetime] NULL,
	[JobStatus] [int] NULL,
	[RevTgt] [decimal](19, 0) NULL,
	[JiraID] [varchar](20) NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TransactionCreationTempData] ADD  DEFAULT ((0)) FOR [JobStatus]
GO


