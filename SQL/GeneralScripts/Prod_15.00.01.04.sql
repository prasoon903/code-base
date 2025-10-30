USE PARASHAR_CB_CI
GO
 ALTER TABLE UpdateCallRequest add

 [ErrorneousAttempts] int NULL

GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_qsel') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_qsel AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_qsel(  @Skey decimal(19) ) AS
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
 [RequestId],
 [SentFlag],
 [Attempts],
 [Success],
 [ErrorCode],
 [ErrorMessage],
 [RequestStartDate],
 [ResponseDate],
 [InstitutionId],
 [RequestType],
 [ErrorneousAttempts]
FROM DBO.UpdateCallRequest
WHERE 
   [Skey] = @Skey 
GO
grant execute on sp_UpdateCallRequest_qsel to public 
GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_qslk') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_qslk AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_qslk(  @Skey decimal(19) ) AS
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
 [RequestId],
 [SentFlag],
 [Attempts],
 [Success],
 [ErrorCode],
 [ErrorMessage],
 [RequestStartDate],
 [ResponseDate],
 [InstitutionId],
 [RequestType],
 [ErrorneousAttempts]
FROM DBO.UpdateCallRequest with (updlock)
WHERE 
   [Skey] = @Skey 
GO
grant execute on sp_UpdateCallRequest_qslk to public 
GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_sel') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_sel AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_sel AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

SELECT [Skey],
 [RequestId],
 [SentFlag],
 [Attempts],
 [Success],
 [ErrorCode],
 [ErrorMessage],
 [RequestStartDate],
 [ResponseDate],
 [InstitutionId],
 [RequestType],
 [ErrorneousAttempts]
FROM DBO.UpdateCallRequest WITH (NOLOCK)
GO

grant execute on sp_UpdateCallRequest_sel to public 
GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_del') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_del AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_del(  @Skey decimal(19) ) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
DELETE FROM DBO.UpdateCallRequest
WHERE 
   [Skey] = @Skey 
GO
grant execute on sp_UpdateCallRequest_del to public 
GO


if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_upd') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_upd AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_upd  @Skey decimal(19),
  @RequestId decimal(19),
  @SentFlag varchar (1),
  @Attempts varchar (1),
  @Success varchar (10),
  @ErrorCode varchar (20),
  @ErrorMessage varchar (200),
  @RequestStartDate datetime,
  @ResponseDate datetime,
  @InstitutionId int,
  @RequestType int,
  @ErrorneousAttempts int AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET NOCOUNT OFF;
 UPDATE DBO.UpdateCallRequest SET  
  [RequestId] = @RequestId,
  [SentFlag] = @SentFlag,
  [Attempts] = @Attempts,
  [Success] = @Success,
  [ErrorCode] = @ErrorCode,
  [ErrorMessage] = @ErrorMessage,
  [RequestStartDate] = @RequestStartDate,
  [ResponseDate] = @ResponseDate,
  [InstitutionId] = @InstitutionId,
  [RequestType] = @RequestType,
  [ErrorneousAttempts] = @ErrorneousAttempts 
WHERE 
   [Skey] = @Skey 
GO
grant execute on sp_UpdateCallRequest_upd to public 
GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_ins') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_ins AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_ins (
  @Skey decimal(19),
  @RequestId decimal(19),
  @SentFlag varchar (1),
  @Attempts varchar (1),
  @Success varchar (10),
  @ErrorCode varchar (20),
  @ErrorMessage varchar (200),
  @RequestStartDate datetime,
  @ResponseDate datetime,
  @InstitutionId int,
  @RequestType int,
  @ErrorneousAttempts int)
AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
 INSERT INTO DBO.UpdateCallRequest 
(  
 [RequestId],
 [SentFlag],
 [Attempts],
 [Success],
 [ErrorCode],
 [ErrorMessage],
 [RequestStartDate],
 [ResponseDate],
 [InstitutionId],
 [RequestType],
 [ErrorneousAttempts])
VALUES (  
 @RequestId,
 @SentFlag,
 @Attempts,
 @Success,
 @ErrorCode,
 @ErrorMessage,
 @RequestStartDate,
 @ResponseDate,
 @InstitutionId,
 @RequestType,
 @ErrorneousAttempts)
GO

grant execute on sp_UpdateCallRequest_ins to public 
GO

if not exists (select * from sysobjects where 
 id = object_id('sp_UpdateCallRequest_insupd') and sysstat & 0xf = 4)
 EXEC sp_executesql N' CREATE PROCEDURE sp_UpdateCallRequest_insupd AS ' 
GO
ALTER PROCEDURE sp_UpdateCallRequest_insupd (  @Skey decimal(19),
  @RequestId decimal(19),
  @SentFlag varchar (1),
  @Attempts varchar (1),
  @Success varchar (10),
  @ErrorCode varchar (20),
  @ErrorMessage varchar (200),
  @RequestStartDate datetime,
  @ResponseDate datetime,
  @InstitutionId int,
  @RequestType int,
  @ErrorneousAttempts int) AS
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET NOCOUNT OFF;

IF EXISTS (SELECT [Skey] FROM DBO.UpdateCallRequest WHERE 
   [Skey] = @Skey 
)
UPDATE DBO.UpdateCallRequest SET 
  [RequestId] = @RequestId,
  [SentFlag] = @SentFlag,
  [Attempts] = @Attempts,
  [Success] = @Success,
  [ErrorCode] = @ErrorCode,
  [ErrorMessage] = @ErrorMessage,
  [RequestStartDate] = @RequestStartDate,
  [ResponseDate] = @ResponseDate,
  [InstitutionId] = @InstitutionId,
  [RequestType] = @RequestType,
  [ErrorneousAttempts] = @ErrorneousAttempts

WHERE 
   [Skey] = @Skey 
ELSE
INSERT INTO DBO.UpdateCallRequest
 (
 [RequestId],
 [SentFlag],
 [Attempts],
 [Success],
 [ErrorCode],
 [ErrorMessage],
 [RequestStartDate],
 [ResponseDate],
 [InstitutionId],
 [RequestType],
 [ErrorneousAttempts]) VALUES ( 
 @RequestId,
 @SentFlag,
 @Attempts,
 @Success,
 @ErrorCode,
 @ErrorMessage,
 @RequestStartDate,
 @ResponseDate,
 @InstitutionId,
 @RequestType,
 @ErrorneousAttempts)
GO

grant execute on sp_UpdateCallRequest_insupd to public 
GO



