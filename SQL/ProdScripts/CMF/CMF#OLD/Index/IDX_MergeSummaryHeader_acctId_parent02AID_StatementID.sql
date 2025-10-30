USE [CCGS_CoreIssue]
GO

/****** Object:  Index [IDX_MergeSummaryHeader_acctId_parent02AID_StatementID]    Script Date: 4/28/2021 6:13:50 AM ******/
CREATE NONCLUSTERED INDEX [IDX_MergeSummaryHeader_acctId_parent02AID_StatementID] ON [dbo].[MergeSummaryHeader]
(
	[acctId] ASC,
	[parent02AID] ASC,
	[StatementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


