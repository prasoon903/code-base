USE [CCGS_CoreIssue]
GO

/****** Object:  Index [IDX_MergeStatementHeader_acctId_StatementID]    Script Date: 4/28/2021 6:11:09 AM ******/
CREATE NONCLUSTERED INDEX [IDX_MergeStatementHeader_acctId_StatementID] ON [dbo].[MergeStatementHeader]
(
	[acctId] ASC,
	[StatementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


