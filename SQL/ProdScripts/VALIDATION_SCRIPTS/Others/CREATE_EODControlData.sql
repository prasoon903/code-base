USE [CCGS_CoreIssue]
GO

ALTER TABLE [dbo].[EODControlData] DROP CONSTRAINT [DF__EODContro__PlanI__16B58D14]
GO

ALTER TABLE [dbo].[EODControlData] DROP CONSTRAINT [DF__EODContro__Accou__15C168DB]
GO

ALTER TABLE [dbo].[EODControlData] DROP CONSTRAINT [DF__EODContro__Inter__0C6D08CB]
GO

ALTER TABLE [dbo].[EODControlData] DROP CONSTRAINT [DF__EODContro__Rec_C__0B78E492]
GO

/****** Object:  Table [dbo].[EODControlData]    Script Date: 2/5/2021 8:58:19 AM ******/
DROP TABLE [dbo].[EODControlData]
GO

/****** Object:  Table [dbo].[EODControlData]    Script Date: 2/5/2021 8:58:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EODControlData](
	[Skey] [decimal](19, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessDay] [datetime] NULL,
	[InstitutionID] [int] NULL,
	[JobStatus] [varchar](10) NULL,
	[Rec_CreatedDt] [datetime] NULL,
	[InterestCalculation] [int] NULL,
	[AccountInfoCount] [int] NULL,
	[PlanInfoCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Skey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EODControlData] ADD  DEFAULT (getdate()) FOR [Rec_CreatedDt]
GO

ALTER TABLE [dbo].[EODControlData] ADD  DEFAULT ((0)) FOR [InterestCalculation]
GO

ALTER TABLE [dbo].[EODControlData] ADD  DEFAULT ((0)) FOR [AccountInfoCount]
GO

ALTER TABLE [dbo].[EODControlData] ADD  DEFAULT ((0)) FOR [PlanInfoCount]
GO


