/**********************************************************************************************************************
Purpose								: COOKIE-240255_PLAT-124829
Author								: Prasoon Parashar
Date									: 12/07/2023
Application version					: 24.2.1
Description							: Performance Improvement in PlanSegment API to reduce in-fly calculation for Closed Loans
Review By							: Rohit Soni
**********************************************************************************************************************/
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.tables WHERE NAME = 'PHPCorrectionData')
BEGIN
CREATE TABLE dbo.PHPCorrectionData (
	[SKey] DECIMAL(19, 0) IDENTITY(1, 1) NOT NULL,
	[JobStatus] VARCHAR (10) NOT NULL DEFAULT('NEW'),
	[AccountNumber] CHAR (19) NULL,
	[acctId] INT NOT NULL,
	[StatementDate] DATETIME NULL,
	[PHPCounter] VARCHAR(30) NULL,
	[CurrentCounterValue] INT NULL,
	[UpdatedCounterValue] INT NULL,
	[RowCreatedDate] DATETIME NULL DEFAULT(GETDATE()),
	[RowChangedDate] DATETIME NULL,

	CONSTRAINT cspk_PHPCorrectionData PRIMARY KEY CLUSTERED 
	(
		[SKey]
	)
  )
END

--DROP TABLE PHPCorrectionData