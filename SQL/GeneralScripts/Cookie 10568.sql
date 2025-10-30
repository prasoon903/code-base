INSERT INTO PARASHAR_CB_cl..USERINFORMATION(USRID,USRINFO1,USRTYPE,USRERNLOGIN,USRSTATUS) VALUES('svcUpdateCreditBureauReporting','appCardinal','4','0','0')

UPDATE PostValues SET Seq = 4110 WHERE NAME = 'UsrServiceDetail'

EXEC USP_GenerateMappingUserDetails 'svcUpdateCreditBureauReporting',51,1