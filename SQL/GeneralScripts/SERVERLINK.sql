Select *FROM sys.server_role_members AS RM
JOIN sys.server_principals AS L
ON RM.member_principal_id = L.principal_id
JOIN sys.server_principals AS R
ON RM.role_principal_id = R.principal_id
WHERE L.name = 'NEWVISIONSOFT\prasoon.parashar';

select * from [xeon-s8].PRASOON_CB_CI.dbo.Institutions
select * from [xeon-s9].Prasoon_TestDB.dbo.Instituition_sample


Select * from Prasoon_TestDB..Instituition_sample

THANKS BRO ..!!!!!!!!!!!!!!!!!


USE [master]  
GO  
EXEC master.dbo.sp_addlinkedserver   
    @server = N'xeon-s8',   
    @srvproduct=N'SQL Server' ;  
GO  

EXEC master.dbo.sp_addlinkedsrvlogin   
    @rmtsrvname = N'xeon-s9',   
    @locallogin = NULL ,   
    @useself = N'True' ;  
GO  