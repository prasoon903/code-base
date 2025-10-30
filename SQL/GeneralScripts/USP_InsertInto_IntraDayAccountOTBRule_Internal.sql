-- =============================================   
-- Author:   Kiran Malani/ Prasoon Parashar  
-- Create date:  11/16/2018  
-- Description:  Cookie - 8808  | Plat - Make the Payment OTB hold after the Payment variable at the Account Level.  
-- =============================================   
--Exec Kmalani_base_CI..USP_InsertInto_IntraDayAccountOTBRule_Internal '2019061144231', 'AccountLevelPaymentHold_20190605193909.csv'  
  
--select * from IntraDayAccountOTBRule_External   
--select * from IntraDayAccountOTBRule_internal   
  
ALTER   
  PROCEDURE [USP_InsertInto_IntraDayAccountOTBRule_Internal] (   @fileId VARCHAR(100) ,   
               @fileName  VARCHAR(200),  
               @InstitutionID INT) --,@Error int = 0 OUTPUT )   
AS  
  BEGIN  
 SET nocount ON ;  
 DECLARE @InvalidRecordCount INT =0,   
      @RecordCount              INT = 0,   
      @Error                    INT =0,   
      @RecordCountExt           INT = 0,   
      @BatchCount               INT =100000,   
      @validateCount            INT = 0,  
   @EndDate datetime,  
   @startDate datetime,  
   @ErrorCount bigint = 0 ,  
   @ArchiveCount bigint = 0 ,  
   @SuccessCount bigint = 0 ,  
   @notprocessedCount bigint,  
   @SysOrgID INT  
   --@fileId VARCHAR(100) ='IntraDayAccountOTBRule_201811122120248.csv' ,  
   --@fileName  VARCHAR(200) = 'aaaaa'  
     
 SELECT @RecordCount = Count(1)  
 FROM   intradayaccountotbrule_external IT WITH(nolock)   
 WHERE  status = 0  
 --drop  table #tempupdateotb  
 Create table  #tempupdateotb   
 (  
  skey DECIMAL (19,0),  
  fileId VARCHAR(100)  ,  
  fileName  VARCHAR(200),  
  ranking int,  
  AccountNumber char (19) NULL,  
  BSAcctID int NULL,  
  ProductID int NULL  
 )  
  
 --DROP TABLE #tempHoldpaymentdetails  
 CREATE TABLE #tempHoldpaymentdetails  
 (  
  PymtHoldTranCode char(10),  
  Institutionid INT  
 )  
  
 SELECT @RecordCountExt = Count(1)   
    FROM   intradayaccountotbrule_internal WITH(nolock)   
    WHERE  status IN (0,1)     AND    fileid = @fileId   
  
  
  
 SELECT  top 1 @SysOrgID =  SysOrgID  
 FROM   Institutions  With(NOLOCK)  
 WHERE InstitutionID = @InstitutionID  
  
  
 IF (@RecordCount > 0     AND     @fileName <> ''     AND     @fileId <> '')   
    BEGIN   
      BEGIN try   
        WHILE (@RecordCount >= @validateCount )   
        BEGIN   
          BEGIN TRANSACTION   
          SET @validateCount = @validateCount + @BatchCount   
  
  if(@SysOrgID = 10)  
    BEGIN  
     Insert INTO   #tempupdateotb   
     SELECT TOP(@BatchCount) IT.skey ,  
       @fileId as [fileid],  
       @fileName as [filename] ,  
       rank() over (partition by IT.UniversalUniqueID,transactioncode order by IT.skey) as Ranking,  
       BP.AccountNumber,  
       BP.AcctID,  
       BP.Parent02AID  
     FROM   intradayaccountotbrule_external IT WITH(nolock)  
     LEFT JOIN BSEGMENT_PRIMARY BP WITH(nolock) ON(IT.UniversalUniqueID = BP.AccountNumber )   
     WHERE  status =0   
  END  
  ELSE  
  BEGIN  
     Insert INTO   #tempupdateotb   
     SELECT TOP(@BatchCount) IT.skey ,  
       @fileId as [fileid],  
       @fileName as [filename] ,  
       rank() over (partition by IT.UniversalUniqueID,transactioncode order by IT.skey) as Ranking,  
       BP.AccountNumber,  
       BP.AcctID,  
       BP.Parent02AID  
     FROM   intradayaccountotbrule_external IT WITH(nolock)  
     LEFT JOIN BSEGMENT_PRIMARY BP WITH(nolock) ON(IT.UniversalUniqueID = BP.UniversalUniqueID )   
     WHERE  status =0   
  END  
  
  
    UPDATE IT  
  SET status = -5 --Invalid StartDate  
  FROM   intradayaccountotbrule_external IT with(nolock)  
   JOIN   #tempupdateotb TT   
   ON     ( IT.skey = TT.skey)    
  where (Startdate is not null and ltrim(rtrim(IT.startdate)) <> ''  
   AND TRY_CONVERT(datetime,Stuff(Stuff(Stuff(Ltrim(Rtrim(IT.StartDate)),13,0,':'),11,0,':'),9,0,' '),112 ) IS NULL)  
  
  set @ErrorCount =  @ErrorCount + @@rowcount  
      
      
  
     UPDATE IT   
     SET IT.startdate = case when (IT.startdate is not null and ltrim(rtrim(IT.startdate)) <> '') then  CAST(Try_convert(datetime,Stuff(Stuff(Stuff(Ltrim(Rtrim(IT.startdate)),13,0,':'),11,0,':'),9,0,' '),112 ) AS VARCHAR(20))  else ('NoDatePassed') end , 
 
      IT.Ranking = TT.Ranking,   
      IT.Transactioncode =  REPLACE(REPLACE(IT.Transactioncode, CHAR(13), ''), CHAR(10), '')  
      FROM   intradayaccountotbrule_external IT   
      JOIN   #tempupdateotb TT   
      ON     (IT.skey = TT.skey)  
  
  
  
   UPDATE IT   set IT.status  = -1 --Duplicate Entry  
    FROM   intradayaccountotbrule_external IT   
    JOIN   #tempupdateotb TT   
    ON     ( IT.skey = TT.skey)  where IT. ranking > 1  
  
    set @ErrorCount =  @ErrorCount + @@rowcount  
  
   INSERT INTO #tempHoldpaymentdetails  
   SELECT m.ActualTranCode,  l.parent02Aid as Institutionid  
   FROM MonetaryTxnControl m WITH(NOLOCK)   
   JOIN HoldPayment h WITH(NOLOCK)   
   ON (h.PymtHoldTranCode = m.TransactionCode)   
   JOIN Logo_Primary l WITH(NOLOCK)   
   ON (h.ProductId = l.acctId) where h.Status =0  
  
   IF(@SysOrgID <> 10 and  @SysOrgID <> 51)  
   BEGIN  
  
    UPDATE IT set IT.status  =-2 --Invalid Tran Code  
    from   intradayaccountotbrule_external IT   with(nolock)   
    left  join #tempHoldpaymentdetails  H on   (IT.InstitutionId  = H.institutionid and  REPLACE(REPLACE(IT.Transactioncode, CHAR(13), ''), CHAR(10), '') = H.PymtHoldTranCode)   
    where H.PymtHoldTranCode is  null   
  
    set @ErrorCount =  @ErrorCount + @@rowcount  
   END  
    --Blank Value Validation  
          UPDATE IT   
     SET    status = - 3 -- Error in Record   
     FROM   intradayaccountotbrule_external IT   
     JOIN   #tempupdateotb TT   
     ON     (IT.skey = TT.skey)   
     WHERE (( [UniversalUniqueID] IS NULL   
     OR     Ltrim(Rtrim([UniversalUniqueID])) = ''   
     OR    [InstitutionID] IS NULL   
     OR    [InstitutionID] <= 0   
     OR    [IntradayThreshholdAmount] IS NULL   
     OR    Ltrim(Rtrim([IntradayThreshholdAmount])) = ''  
     OR  ISNUMERIC(LTRIM(RTRIM(IntradayThreshholdAmount))) =0  
     OR  Ltrim(Rtrim([IntradayThreshholdAmount])) < 0  
     OR  [HeldDays_LessThanIntradayThreshhold] IS NULL   
     OR     Ltrim(Rtrim([HeldDays_LessThanIntradayThreshhold])) = ''  
     OR  ISNUMERIC(LTRIM(RTRIM(HeldDays_LessThanIntradayThreshhold))) =0  
     OR     [HeldDays_GreaterThanIntradayThreshhold] IS NULL   
     OR     Ltrim(Rtrim([HeldDays_GreaterThanIntradayThreshhold])) = ''  
     OR  ISNUMERIC(LTRIM(RTRIM(HeldDays_GreaterThanIntradayThreshhold)))=0  
     OR     Transactioncode IS NULL   
     OR     Ltrim(Rtrim(Transactioncode)) = ''   
     /*OR     [StartDate] IS NULL   
     OR     Ltrim(Rtrim([StartDate])) = ''*/  )  
     and status >= 0 )     
            
    set @ErrorCount =  @ErrorCount + @@rowcount  
  
  
    IF(@SysOrgID = 10)  
    BEGIN  
  
     UPDATE IT   
     SET    status = -4 --Invalid Account Number or Account Number does not exists or not matching institution id  
     FROM   intradayaccountotbrule_external IT   
      JOIN   #tempupdateotb TT ON(IT.skey = TT.skey)   
      LEFT OUTER JOIN Bsegment_Primary BP WITH(NOLOCK)   
      ON (BP.AccountNumber = IT.UniversalUniqueID and bp.institutionid = IT.InstitutionId)  
     WHERE  status = 0 AND BP.AccountNumber IS NULL  
  
  
     set @ErrorCount =  @ErrorCount + @@rowcount  
   END  
   ELSE  
   BEGIN  
     UPDATE IT   
     SET    status = -4 --Invalid Account Number or Account Number does not exists or not matching institution id  
     FROM   intradayaccountotbrule_external IT   
      JOIN   #tempupdateotb TT ON(IT.skey = TT.skey)   
      LEFT OUTER JOIN Bsegment_Primary BP WITH(NOLOCK)   
      ON (BP.UniversalUniqueID = IT.UniversalUniqueID and bp.institutionid = IT.InstitutionId)  
     WHERE  status = 0 AND BP.AccountNumber IS NULL  
  END  
  
    UPDATE IT   
          SET    status = 1   
     --startdate =  Try_convert(datetime,Stuff(Stuff(Stuff(Ltrim(Rtrim(startdate)),13,0,':'),11,0,':'),9,0,' '),112 )  
          FROM   intradayaccountotbrule_external IT   
          JOIN   #tempupdateotb TT   
          ON     (   
                        IT.skey = TT.skey)   
          WHERE  status =0   
       
     set @SuccessCount = @SuccessCount + @@rowcount  
  
   UPDATE II   
    SET    ArchieveStatus = 1   
    FROM intradayaccountotbrule_internal II   
     JOIN intradayaccountotbrule_external IT ON (II.UniversalUniqueID = IT.UniversalUniqueID and II.transactioncode  = IT.transactioncode  )  
     JOIN   #tempupdateotb TT ON(IT.skey = TT.skey)  
    WHERE ArchieveStatus = 0  AND IT.Status > 0  
    
     set @ArchiveCount  = @ArchiveCount +@@rowcount  
      
  
     INSERT INTO intradayaccountotbrule_internal   
        (   
        accountnumber,  
        UniversalUniqueID,   
        institutionid,   
        startdate,   
        intradaythreshholdamount,   
        helddays_lessthanintradaythreshhold,   
        helddays_greaterthanintradaythreshhold,   
        status,   
        processingtime,  
        TransactionCode,  
        FileID,  
        FileName,  
        AcctID,  
        ProductID  
        )   
     SELECT TT.ACCOUNTNUMBER,  
      UniversalUniqueID,  
      institutionid,   
      case when (startdate is not null and ltrim(rtrim(startdate)) <> '' and ltrim(rtrim(startdate)) <> 'NoDatePassed')THEN Try_convert(datetime,startdate,112 ) else NULL END,  
      intradaythreshholdamount,   
      helddays_lessthanintradaythreshhold,   
      helddays_greaterthanintradaythreshhold,   
      status,   
      Getdate(),  
      TransactionCode,  
      TT.FileID,  
      TT.FileName,  
      TT.BsAcctID,  
      TT.ProductID  
     FROM   intradayaccountotbrule_external IT WITH(nolock)   
     JOIN   #tempupdateotb TT   
     ON     (IT.skey = TT.skey)  
    
    UPDATE II   
    SET ArchieveStatus = 1   
    FROM intradayaccountotbrule_internal II   
     JOIN intradayaccountotbrule_external IT ON (II.UniversalUniqueID = IT.UniversalUniqueID and II.transactioncode  = IT.transactioncode  )  
     JOIN   #tempupdateotb TT ON(IT.skey = TT.skey)  
    WHERE ArchieveStatus = 0   AND IT.StartDate ='NoDatePassed'  
  
  
  
    set @ArchiveCount  = @ArchiveCount +@@rowcount   
  
   DELETE IT   
   FROM   intradayaccountotbrule_external IT   
   JOIN   #tempupdateotb TT   
   ON     (IT.skey = TT.skey)  
  
   TRUNCATE TABLE #tempupdateotb  
   TRUNCATE TABLE #tempHoldpaymentdetails  
          COMMIT TRANSACTION   
        END   
   set @notprocessedCount = @RecordCount - @ErrorCount - @SuccessCount  
  
      END try   
      BEGIN catch   
         ROLLBACK TRAN   
        SET @Error =1   
      END catch   
  
    END   
    ELSE   
    BEGIN   
      SET @Error =4   
    END  
 SELECT @Error AS fileerror ,@RecordCount as TotalCount,@SuccessCount as SuccessCount,@ErrorCount as ErrorCount,@ArchiveCount as ArchiveCount,@notprocessedCount as notprocessedCount  
  end