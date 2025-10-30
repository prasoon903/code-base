ALTER PROCEDURE [dbo].[USP_GenerateMappingUserDetails] (@APIName  VARCHAR(100),  
                                                 @SysOrgId INT,  
                                                 @IsActive INT = 0)  
AS  
  BEGIN  
      /*    
      Author  -- Poonam A    
      Description -- This procedure will create missing entries of any api to that sysorgid's all merchant and products.    
      @IsActive = 0 = Inactive    
      @IsActive = 1 = Active    
         
      --Verification queries    
      SELECT   Seq FROM PostValues WITH(UPDLOCK)    
      WHERE name='UsrServiceDetail'    
              
      ---- delete from usrServiceMappingDetails where servicename='svcplandetail'  and product in(3329,    
      ----3331,    
      ----3333,    
      ----3335)    
      ---- ----select * from usrServiceMappingDetails where servicename='svcplandetail'    
      ----select * from SYN_CORELIBRARY_USERGROUPS where usrGroupName='svcPlanDetail3'    
      ----select * from poonamag_cl..usergroups with(nolock) where USRID='sERVICEuSER' and usrGroupName='svcPlanDetail3'    
  
      */  
      SET NOCOUNT ON  
  
      DECLARE @InstitutionID INT,  
      @UsmDetailAcctid decimal(19,0),  
      @usrid INT,  
      @UsrName VARCHAR(100),  
   @JobInseted decimal (19,0)  
  
      CREATE TABLE #Temp_UsrServiceMappingDetail  
        (  
           [UsmDetailAcctid] [DECIMAL](19, 0),  
           [UsmId]           [DECIMAL](19, 0) NULL,  
           [Merchant]        [INT] NULL,  
           [Product]         [INT] NULL,  
           [Active]          [VARCHAR](1) NULL,  
           [ServiceName]     [VARCHAR](128) NULL,  
           [SysOrgID]        [TINYINT] NULL  
        )  
   CREATE TABLE #Temp_UsrServiceMappingMaster
        (  usrid  [DECIMAL](19, 0) NULL
		)
      --SELECT @UsmDetailAcctid = max(UsmDetailAcctid) FROM usrServiceMappingDetails WITH(NOLOCK)    
	  insert into  #Temp_UsrServiceMappingMaster(usrid)
      SELECT  usrid  
      FROM   UsrServicesourceMapping WITH(NOLOCK)  
      WHERE  sysorgid = @SysOrgId

	IF  NOt exists ( SELECT  Top 1 1 usrid  
      FROM   #Temp_UsrServiceMappingMaster WITH(NOLOCK) )  
        BEGIN  
            SELECT 'This sysorgid is not valid, Or no user mapped with this sysorgid'  
  
            RETURN;  
        END  
  
      IF( @IsActive NOT IN ( 0, 1 ) )  
        BEGIN  
            SELECT 'Not valid value for @IsActive'  
  
            RETURN;  
        END  


   while exists(select  top 1 1 usrid from #Temp_UsrServiceMappingMaster where usrid is not null )
  BEGIN
  select  @usrid=usrid from #Temp_UsrServiceMappingMaster order by usrid desc

      SELECT @UsrName = UsmUsrid  
      FROM   usrservicemappingmaster WITH(NOLOCK)  
      WHERE  usmid  =@usrid
	  
	  delete from #Temp_UsrServiceMappingMaster where usrid=@usrid
  
      IF ( Upper(@UsrName) = Upper('Finaladmin') )  
        BEGIN  
            SET @UsrName='ServiceUser'  
  
            SELECT @usrid = usmid  
            FROM   usrservicemappingmaster WITH(NOLOCK)  
            WHERE  Upper(usmusrid) = @UsrName  
        END  
  
       
   IF NOT EXISTS(SELECT *  
                    FROM   SYN_CORELIBRARY_USERGROUPS  
                    WHERE  usrGroupName = @APIName  
                           AND usrid = @UsrName)  
        BEGIN  
            INSERT INTO SYN_CORELIBRARY_USERGROUPS  
                        (usrid,  
                         usrGroupName)  
            VALUES     (@UsrName,  
                        @APIName)  
        END  
  
      SELECT @UsmDetailAcctid = Seq + 2  
      FROM   PostValues WITH(UPDLOCK)  
      WHERE  NAME = 'UsrServiceDetail'  
  
      BEGIN TRY  
          BEGIN TRANSACTION  
  
          INSERT INTO #Temp_UsrServiceMappingDetail  
          SELECT Row_number()  
                   OVER (  
                     ORDER BY l.acctid),  
                 @usrid,  
                 owningpartner,  
                 l.acctid,  
                 @IsActive,  
                 @APIName,  
                 @SysOrgId  
          FROM   Logo_Primary l WITH(NOLOCK)  
                 JOIN logo_secondary ls WITH(NOLOCK)  
                   ON ( l.acctid = ls.acctid )  
          WHERE  Parent02aid IN (SELECT InstitutionId  
                                 FROM   institutions Ins WITH(NOLOCK)  
                                 WHERE  Ins.SysorgID = @SysOrgId)  
                 AND l.acctid NOT IN (SELECT USM.Product  
                                      FROM   usrServiceMappingDetails USM WITH(nolock)  
                  WHERE  USM.ServiceName = @APIName  
                                             AND USM.SysOrgID = @SysOrgId)  
  
          --UPDATE #Temp_UsrServiceMappingDetail SET UsmDetailAcctid= UsmDetailAcctid + @UsmDetailAcctid    
          UPDATE #Temp_UsrServiceMappingDetail  
          SET    @UsmDetailAcctid = UsmDetailAcctid = @UsmDetailAcctid + 1  
  
          SELECT @JobInseted = Count(1)  
          FROM   #Temp_UsrServiceMappingDetail  
  
          ----select * from #Temp_UsrServiceMappingDetail    
          UPDATE PostValues  
          SET    Seq = @UsmDetailAcctid +  2  
          WHERE  NAME = 'UsrServiceDetail'  
  
          SELECT *  
          FROM   #Temp_UsrServiceMappingDetail  
  
          INSERT INTO usrServiceMappingDetails  
                      (UsmDetailAcctid,  
                       UsmId,  
                       Merchant,  
                       Product,  
                       Active,  
                       ServiceName,  
                       SysOrgID)  
          SELECT *  
          FROM   #Temp_UsrServiceMappingDetail  
  
          COMMIT TRANSACTION  
      END TRY  
      BEGIN CATCH  
          SELECT Error_number(),  
                 Error_message()  
          IF( @@TRANCOUNT > 0 )  
            BEGIN  
                ROLLBACK TRANSACTION  
            END  
      END CATCH  
	  END
  END   