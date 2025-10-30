/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_qsel(  @Skey decimal(19) ) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SELECT
 [Skey],
 [acctId],
 [AccountNumber],
 [TranId],
 [TranTime],
 [PostTime],
 [TransactionAmount],
 [LastStatementDate],
 [StatementDate],
 [AdjustedCurrentBalance],
 [AdjustedHighBalance],
 [CurrentBalance],
 [JobStatus]
FROM HighBalanceErrorLog
WHERE 
   [Skey] = @Skey 
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_qslk(  @Skey decimal(19) ) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SELECT
 [Skey],
 [acctId],
 [AccountNumber],
 [TranId],
 [TranTime],
 [PostTime],
 [TransactionAmount],
 [LastStatementDate],
 [StatementDate],
 [AdjustedCurrentBalance],
 [AdjustedHighBalance],
 [CurrentBalance],
 [JobStatus]
FROM HighBalanceErrorLog with (updlock)
WHERE 
   [Skey] = @Skey 
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_sel AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

SELECT [Skey],
 [acctId],
 [AccountNumber],
 [TranId],
 [TranTime],
 [PostTime],
 [TransactionAmount],
 [LastStatementDate],
 [StatementDate],
 [AdjustedCurrentBalance],
 [AdjustedHighBalance],
 [CurrentBalance],
 [JobStatus]
FROM HighBalanceErrorLog WITH (NOLOCK)
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_del(  @Skey decimal(19) ) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
DELETE FROM HighBalanceErrorLog
WHERE 
   [Skey] = @Skey 
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_upd  @Skey decimal(19),
  @acctId int,
  @AccountNumber char (19),
  @TranId decimal(19),
  @TranTime datetime,
  @PostTime datetime,
  @TransactionAmount money,
  @LastStatementDate datetime,
  @StatementDate datetime,
  @AdjustedCurrentBalance money,
  @AdjustedHighBalance money,
  @CurrentBalance money,
  @JobStatus varchar (20) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET NOCOUNT OFF;
 UPDATE HighBalanceErrorLog SET   [Skey] = @Skey,
  [acctId] = @acctId,
  [AccountNumber] = @AccountNumber,
  [TranId] = @TranId,
  [TranTime] = @TranTime,
  [PostTime] = @PostTime,
  [TransactionAmount] = @TransactionAmount,
  [LastStatementDate] = @LastStatementDate,
  [StatementDate] = @StatementDate,
  [AdjustedCurrentBalance] = @AdjustedCurrentBalance,
  [AdjustedHighBalance] = @AdjustedHighBalance,
  [CurrentBalance] = @CurrentBalance,
  [JobStatus] = @JobStatus 
WHERE 
   [Skey] = @Skey 
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_ins (
  @Skey decimal(19),
  @acctId int,
  @AccountNumber char (19),
  @TranId decimal(19),
  @TranTime datetime,
  @PostTime datetime,
  @TransactionAmount money,
  @LastStatementDate datetime,
  @StatementDate datetime,
  @AdjustedCurrentBalance money,
  @AdjustedHighBalance money,
  @CurrentBalance money,
  @JobStatus varchar (20))
AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
 INSERT INTO HighBalanceErrorLog 
(  [Skey],
 [acctId],
 [AccountNumber],
 [TranId],
 [TranTime],
 [PostTime],
 [TransactionAmount],
 [LastStatementDate],
 [StatementDate],
 [AdjustedCurrentBalance],
 [AdjustedHighBalance],
 [CurrentBalance],
 [JobStatus])
VALUES (  @Skey,
 @acctId,
 @AccountNumber,
 @TranId,
 @TranTime,
 @PostTime,
 @TransactionAmount,
 @LastStatementDate,
 @StatementDate,
 @AdjustedCurrentBalance,
 @AdjustedHighBalance,
 @CurrentBalance,
 @JobStatus)
GO

CREATE OR ALTER PROCEDURE sp_HighBalanceErrorLog_insupd (  @Skey decimal(19),
  @acctId int,
  @AccountNumber char (19),
  @TranId decimal(19),
  @TranTime datetime,
  @PostTime datetime,
  @TransactionAmount money,
  @LastStatementDate datetime,
  @StatementDate datetime,
  @AdjustedCurrentBalance money,
  @AdjustedHighBalance money,
  @CurrentBalance money,
  @JobStatus varchar (20)) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET NOCOUNT OFF;

IF EXISTS (SELECT [Skey] FROM HighBalanceErrorLog WHERE 
   [Skey] = @Skey 
)
UPDATE HighBalanceErrorLog SET  [Skey] = @Skey,
  [acctId] = @acctId,
  [AccountNumber] = @AccountNumber,
  [TranId] = @TranId,
  [TranTime] = @TranTime,
  [PostTime] = @PostTime,
  [TransactionAmount] = @TransactionAmount,
  [LastStatementDate] = @LastStatementDate,
  [StatementDate] = @StatementDate,
  [AdjustedCurrentBalance] = @AdjustedCurrentBalance,
  [AdjustedHighBalance] = @AdjustedHighBalance,
  [CurrentBalance] = @CurrentBalance,
  [JobStatus] = @JobStatus

WHERE 
   [Skey] = @Skey 
ELSE
INSERT INTO HighBalanceErrorLog
 ( [Skey],
 [acctId],
 [AccountNumber],
 [TranId],
 [TranTime],
 [PostTime],
 [TransactionAmount],
 [LastStatementDate],
 [StatementDate],
 [AdjustedCurrentBalance],
 [AdjustedHighBalance],
 [CurrentBalance],
 [JobStatus]) VALUES ( @Skey,
 @acctId,
 @AccountNumber,
 @TranId,
 @TranTime,
 @PostTime,
 @TransactionAmount,
 @LastStatementDate,
 @StatementDate,
 @AdjustedCurrentBalance,
 @AdjustedHighBalance,
 @CurrentBalance,
 @JobStatus)
GO

