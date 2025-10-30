


--EXEC USP_GenerateMappingUserDetails 'svcMRT',7,1


--INSERT INTO userinformation(usrid, usrInfo1, usrType) VALUES('svcMRT', 'appCardinal',4)

--IF NOT EXISTS (SELECT * FROM ajay_CL..userGroups with(nolock) where usrid= 'GreenSkyCall' and usrGroupname = 'svcMRT')	
--     INSERT INTO ajay_CL..UserGroups VALUES('GreenSkyCall','svcMRT')
--IF NOT EXISTS (SELECT * FROM userinformation with(nolock) where usrid = 'svcMRT')
--	INSERT INTO userinformation(usrid, usrInfo1, usrType,usrernlogin,usrstatus) VALUES('svcMRT', 'appCardinal',4,'0','0')





IF NOT EXISTS (SELECT * FROM ajay_CL..userGroups with(nolock) where usrid= 'PlatCall' and usrGroupname = 'svcMRT')	
     INSERT INTO ajay_CL..UserGroups VALUES('PlatCall','svcMRT')