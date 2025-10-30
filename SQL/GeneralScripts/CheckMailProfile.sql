DECLARE @InstitutionID INT, @ProcessingTime DATETIME

SELECT TOP 1 @InstitutionID =  InstitutionID FROM Institutions WITH (NOLOCK) WHERE SysOrgID = 51

SELECT @ProcessingTime = CAST(CONVERT(VARCHAR, ProcDayEnd, 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)
FROM ARSystemAccounts AR WITH (NOLOCK) 
JOIN Org_Balances OB WITH (NOLOCK) ON (AR.acctId = OB.ARSystemAcctId)
WHERE OB.acctId = @InstitutionID

DECLARE @ProcdayEnddt DATETIME = CAST(CONVERT(DATE, DATEADD(DAY,-1,@ProcessingTime)) AS VARCHAR) + ' 23:59:57'

IF NOT EXISTS(SELECT 1 FROM EODControlData WITH (NOLOCK) WHERE JobStatus='New' AND BusinessDay = @ProcdayEnddt)
BEGIN
	EXEC USP_EODDataValidation @ProcdayEnddt,null
END

INSERT INTO CPS_Emails (ClientName,ProcessName,Mail_recipients,Mail_copy_recipients)
VALUES('PLAT','EODDataValidation','prasoon.parashar@corecard.com','prasoon.parashar@corecard.com')



SELECT Mail_recipients ,Mail_copy_recipients, *
				--@Mail_from_address = ISNULL(From_Address_KB ,'')
		FROM CPS_Emails WITH(NOLOCK)


EXEC msdb.dbo.sysmail_help_configure_sp;
EXEC msdb.dbo.sysmail_help_account_sp;
EXEC msdb.dbo.sysmail_help_profile_sp;
EXEC msdb.dbo.sysmail_help_profileaccount_sp;
EXEC msdb.dbo.sysmail_help_principalprofile_sp;

SELECT  [sa].[account_id]
, [sa].[name] as [Profile_Name]
, [sa].[description]
, [sa].[email_address]
, [sa].[display_name]
, [sa].[replyto_address]
, [ss].[servertype]
, [ss].[servername]
, [ss].[port]
, [ss].[username]
, [ss].[use_default_credentials]
, [ss].[enable_ssl]
FROM 
 msdb.dbo.sysmail_account sa
INNER JOIN msdb.dbo.sysmail_server ss
ON  sa.account_id = ss.account_id