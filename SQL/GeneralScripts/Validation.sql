select usrId, usrPassword, usrInfo1, usrErnLogin, usrStatus, usrType, usrLocale, usrSecQuestion, usrSecAnswer, PasswordDate, ErnLoginDate, StatusCodeDate, 
usrATID, usrAID, usrIdentifier, PasswordPolicy, usrRLSQualifier, tpyNAD, tpyLAD, tpyBlob, RestrictionPolicy, InternalId, InternalPassword, FirstName, Surname, 
accessID, RLSRef, EmbATID, EmbAcctid, CardRegStatusIVR, CardRegDateIVR, CardCancelDateIVR, LogAction, LogMsgStore, LogForUser, usrSecQuestion2, usrSecAnswer2, 
usrSecQuestion3, usrSecAnswer3, usrSecQuestion4, usrSecAnswer4, usrSecQuestion5, usrSecAnswer5, usrFirstName, usrLastName, usrBusinessPhone, usrBusinessPhoneExtension, 
usrMobilePhone, carrierSelector, usrEmailAddress, usrPwChangeAttempts, usrResetPasswordValue, usrSecurityAnsValue, usrGroupType, LastLoginDate, UserCreationDate, 
EncryptedPass, SecurityType, SecurityLevel, usrSecurityAnsErnLogin, LockAfterInactivityDays, ManuallyAutoLocked, SourceUserType
from PARASHAR_CB_CL.dbo.UserInformation with ( nolock )
where
((PARASHAR_CB_CL.dbo.UserInformation.usrType = 1) AND (PARASHAR_CB_CL.dbo.UserInformation.usrInfo1 = 'CoreIssueEndUser') AND (PARASHAR_CB_CL.dbo.UserInformation.usrATID = '51') AND 
(PARASHAR_CB_CL.dbo.UserInformation.usrId = 'PlatCall'))

SELECT usrid,* FROM PARASHAR_CB_CL.dbo.UserInformation
where
PARASHAR_CB_CL.dbo.UserInformation.usrType = 1 AND
PARASHAR_CB_CL.dbo.UserInformation.usrInfo1 = 'CoreIssueEndUser' AND
PARASHAR_CB_CL.dbo.UserInformation.usrATID = '51'


INSERT INTO UsrServiceMappingDetails  (UsmDetailAcctid,UsmId,Merchant,Product,Active,ServiceName,SysOrgID,IsAllowedForTestAccount) 
VALUES (2562,1025,11607,3399,1,'svcCollateralIdentifier',7,NULL)

select UsmDetailAcctid, UsmId, Merchant, Product, Active, ServiceName, SysOrgID, IsAllowedForTestAccount
from PARASHAR_CB_CI.dbo.UsrServiceMappingDetails with ( nolock )
where
((PARASHAR_CB_CI.dbo.UsrServiceMappingDetails.UsmId = 1025) AND 
(PARASHAR_CB_CI.dbo.UsrServiceMappingDetails.ServiceName = 'svcCollateralIdentifier') AND 
(PARASHAR_CB_CI.dbo.UsrServiceMappingDetails.Active = '1'))  AND 
(PARASHAR_CB_CI.dbo.UsrServiceMappingDetails.Merchant = 11607) AND 
(PARASHAR_CB_CI.dbo.UsrServiceMappingDetails.Product = 3399)



select PARASHAR_CB_CI.dbo.BSegment_Primary.acctId, PARASHAR_CB_CI.dbo.BSegment_Primary.parent02AID, PARASHAR_CB_CI.dbo.BSegment_Primary.parent05AID, PARASHAR_CB_CI.dbo.BSegment_Primary.AccountNumber, PARASHAR_CB_CI.dbo.BSegment_Primary.InstitutionID, PARASHAR_CB_CI.dbo.BSegment_Secondary.TestAccount
from PARASHAR_CB_CI.dbo.BSegment_Primary with ( nolock ), PARASHAR_CB_CI.dbo.BSegment_Secondary with ( nolock )
where
((PARASHAR_CB_CI.dbo.BSegment_Primary.AccountNumber = '8000000000000011') AND 
(PARASHAR_CB_CI.dbo.BSegment_Primary.acctId = PARASHAR_CB_CI.dbo.BSegment_Secondary.acctId) AND 
(PARASHAR_CB_CI.dbo.BSegment_Primary.SysOrgID = 7))


select  DISTINCT PARASHAR_CB_CI.dbo.UsrServiceMappingMaster.UsmId, PARASHAR_CB_CI.dbo.UsrServiceMappingMaster.UsmUsrID, PARASHAR_CB_CI.dbo.UsrServiceMappingMaster.IsAdminUser, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.usrId, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.SelfServiceSource1, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.SelfServiceSource2, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.IVRSource, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.OtherSource, PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.SysOrgID
from PARASHAR_CB_CI.dbo.UsrServiceMappingMaster with ( nolock ), PARASHAR_CB_CI.dbo.UsrServiceSourceMapping with ( nolock )
where
((PARASHAR_CB_CI.dbo.UsrServiceMappingMaster.UsmUsrID = 'GreenSkyCall') AND 
(PARASHAR_CB_CI.dbo.UsrServiceMappingMaster.UsmId = CONVERT
( BIGINT, (PARASHAR_CB_CI.dbo.UsrServiceSourceMapping.usrId) )))

USE PARASHAR_CB_CI
select UsmDetailAcctid, UsmId, Merchant, Product, Active, ServiceName, SysOrgID, IsAllowedForTestAccount
from vishalsh_cbtest.dbo.UsrServiceMappingDetails with ( nolock )
where
((vishalsh_cbtest.dbo.UsrServiceMappingDetails.UsmId = 1025) AND 
(vishalsh_cbtest.dbo.UsrServiceMappingDetails.ServiceName = 'svcCollateralIdentifier') AND 
(vishalsh_cbtest.dbo.UsrServiceMappingDetails.Active = '1'))  AND 
(vishalsh_cbtest.dbo.UsrServiceMappingDetails.Merchant = 11607) AND 
(vishalsh_cbtest.dbo.UsrServiceMappingDetails.Product = 3399)

(SELECT max(UsmDetailAcctid) from UsrServiceMappingDetails + 1)



INSERT INTO UsrServiceMappingDetails  (UsmDetailAcctid,UsmId,Merchant,Product,Active,ServiceName,SysOrgID,IsAllowedForTestAccount) 
VALUES (2562,1025,11607,3399,1,'svcCollateralIdentifier',7,NULL)

select * from vishalsh_cbTest..UsrServiceMappingDetails where ServiceName like '%getpro%'