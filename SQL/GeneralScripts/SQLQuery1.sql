select bp.acctId,bp.AccountNumber,bs.CBRSpecialComments,bs.CBRComplianceCode,bcbr.CBRIndicator,bcc.BankruptcyFileDate,c.CbBnkrptNotifDate,bs.BankruptcyIndicator,bcc.ConfirmedBankruptcyDate,ConsumerInfoIndicator,
c.COA_CbBnkrptNotifDate,c.COA_Deceased,c.CbBnkrptNotifDate,c.Deceased,c.COA_CBRConsumerInfoIndicator
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId JOIN
BSCBRIndicatorDetail bcbr with (NOLOCK) on bp.acctId = bcbr.acctId JOIN
Address a WITH (NOLOCK) on bp.acctId = a.acctId JOIN
Customer c WITH (NOLOCK) on bp.acctId = c.CustomerId
where bp.acctId in (5000)

SELECT * from NonMonetaryLog

								SELECT CB.Skey, BP.acctId, CPS.acctId,BP.PrimaryCurrencyCode,BP.parent02AID, BP.InstitutionID FROM CollateralID_BulkUpdate_Insert CB
									
									
									JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.AccountNumber = CB.AccountNumber)
									JOIN CPSgmentAccounts CPS ON (CPS.parent02AID = BP.acctId)





use PARASHAR_CB_CI
select * from PARASHAR_CB_CI..APIMaster WHERE APIName LIKE '%CreditBureauReporting%'

SELECT * FROM PARASHAR_CB_CI..UsrServiceMappingDetails 
WHERE --Product = 7131 AND Merchant = 14992 AND
 ServiceName LIKE '%updateCredit%'

SELECT * FROM PARASHAR_CB_CL..UserGroups WHERE  usrGroupName LIKE '%Updatecre%'

IF NOT EXISTS ( SELECT TOP 1 1 FROM PARASHAR_CB_CL..USERINFORMATION WITH(NOLOCK) WHERE USRID = 'svcUpdateCreditBureauReporting' AND USRTYPE = '4')
	BEGIN 
		INSERT INTO  PARASHAR_CB_CL..USERINFORMATION(USRID,USRINFO1,USRTYPE,USRERNLOGIN,USRSTATUS) VALUES('svcUpdateCreditBureauReporting','appCardinal','4','0','0')
	END
GO

SELECT * FROM PARASHAR_CB_CL..UserInformation WHERE usrId LIKE '%svcUpdateCreditBureauReporting%'
SELECT * FROM PARASHAR_CB_CL..UserInformation WHERE usrId LIKE '%cardholder%'

SELECT * FROM PARASHAR_CB_CL..UserInformation WHERE usrId LIKE '%PLAT%'


INSERT INTO PARASHAR_CB_CL..userinformation(usrid, usrInfo1, usrType) VALUES('PlatCall', 'CoreIssueEndUser',1)

SELECT * from PostValues with(NOLOCK) WHERE Name = 'UsrServiceDetail'

INSERT INTO PARASHAR_CB_CI..UsrServiceMappingDetails (UsmDetailAcctid,UsmId,Merchant,Product,Active,ServiceName,SysOrgID,IsAllowedForTestAccount)
VALUES (4109,1215,14992,7131,1,'svcUpdateCreditBureauReporting' ,51,NULL)

INSERT INTO PARASHAR_CB_CL..UserGroups (usrId,usrGroupName)
VALUES ('PlatCall','svcViewCreditBureauReporting')

EXEC USP_GenerateMappingUserDetails 'svcUpdateCreditBureauReporting',51,1

select * from usrservicemappingmaster
select * from UsrServicesourceMapping

SELECT -- max(UsmDetailAcctid) 
  * FROM UsrServiceMappingDetails with(NOLOCK) where servicename='svcUpdateCreditBureauReporting' ORDER by UsmDetailAcctid desc

	  UPDATE PostValues SET Seq = 4110 WHERE NAME = 'UsrServiceDetail'

insert into PARASHAR_CB_cl..userinformation(usrid,usrinfo1,usrtype,usrErnLogin,usrstatus) values('svcViewCreditBureauReporting','appCardinal','4','0','0')
INSERT INTO PARASHAR_CB_cl..USERINFORMATION(USRID,USRINFO1,USRTYPE,USRERNLOGIN,USRSTATUS) VALUES('svcUpdateCreditBureauReporting','appCardinal','4','0','0')