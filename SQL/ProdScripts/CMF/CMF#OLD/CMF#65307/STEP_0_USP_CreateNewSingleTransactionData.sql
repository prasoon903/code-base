USE [CCGS_CoreIssue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Author : Rohit Soni
--usp_CreateStatementCredit 54 --@MTCGID
--						,6981 --@InsitutionID
--						, 1 -- @Batchcount
--- To cook data  for transaction 
CREATE OR ALTER   Procedure [dbo].[USP_CreateNewSingleTransactionData] (@MTCGID int  ,@InsitutionID int,@Batchcount int ,@NonMonetaryTxn INT = NULL,@ActualTrancode varchar(20) =null ,
@Accountnumber varchar(19 ) = null,@transactionamount money = null ,@EmbAcctid int = null,@creditplanmaster int = null) 
as  
BEGIN 
	SET NOCOUNT ON 
    --DECLARE @InsitutionID INT =0
	--DECLARE @MTCGID       INT = 0
	if @InsitutionID =0 or @MTCGID =0
	begin 
		select @InsitutionID= lutcode  from ccardlookup  with(nolock) where lutid = 'organizationname ' and lutdescription = 'Cookie-2'
		select @MTCGID= lutcode  from trancodelookup with(nolock) where lutid = 'mtcgroupid ' and lutdescription = 'Cookie MTCG'
	end


	--print @InsitutionID
	--print @MTCGID
    DECLARE @CurrDateTime DATETIME 
    DECLARE @TranID DECIMAL(19) 
    DECLARE @vTmpBsegmentCount INT, 
            @Error             INT =0, 
            @ErrorMessage      VARCHAR(200) 
    DECLARE @iOrgID INT 
    DECLARE @ArAcctid INT ,@fileid varchar(100),@Lastfileid varchar(100)

    SELECT @iOrgID = acctid, 
           @ArAcctid = arsystemacctid 
    FROM   org_balances WITH(nolock) 
    WHERE  acctid = @InsitutionID 



    SELECT @CurrDateTime = Cast (dateadd(second,10,procdaystart)  AS DATE) 
    FROM   dbo.arsystemaccounts WITH(nolock) 
    WHERE  acctid = @ArAcctid 
	SET @CurrDateTime = @CurrDateTime + convert(varchar(10), Getdate(), 108); --Cast(Getdate() AS TIME); 



	if(@InsitutionID > 0 )
	Begin 		

		select top (@Batchcount)  skey into  #tempCreateNewSingleTransactionData from CreateNewSingleTransactionData with(nolock) WHERE  transactionstatus = 0


		--print @CurrDateTime
		--print 'inside for fileid'+ @fileid;
		;WITH cte 
			 AS (SELECT  c1.skey, 
						Row_number() 
						  OVER ( 
							ORDER BY accountnumber ) AS trancount, 
						Row_number() 
						  OVER ( 
							partition BY accountnumber 
							ORDER BY accountnumber)  AS Transeq 
				 FROM   #tempCreateNewSingleTransactionData c WITH(nolock)  join 
				 CreateNewSingleTransactionData  c1 WITH(nolock) on (c.skey  = c1.skey )
				 WHERE  transactionstatus = 0  ) 
		UPDATE st 
		SET    TransactionCount = trancount, 
			   AccountTransactionSequance = Transeq ,
			   transactionstatus = 1
		FROM   cte c 
			   JOIN CreateNewSingleTransactionData st with(nolock) 
				 ON ( c.skey = st.skey ) 

		SELECT @vTmpBsegmentCount = Count(1) 
		FROM   CreateNewSingleTransactionData WITH(nolock) 
		WHERE  transactionstatus = 1  
		--print @vTmpBsegmentCount
		BEGIN try 
			BEGIN TRAN 

			--SELECT @TranID = seq + 2 
			--FROM   postvalues WITH(updlock)  WHERE  NAME = 'TranId'; 
			----print @TranID
			--UPDATE postvalues 
			--SET    seq = seq + Isnull(@vTmpBsegmentCount, 0) + 10 WHERE  NAME = 'TranId'; 

			DECLARE @SequenceID  DECIMAL(19,0)
			DECLARE @PostValue_StepSize INT
			DECLARE @varTWid INT
			DECLARE @ReserveCount INT=Isnull(@vTmpBsegmentCount, 0) + 10 

			EXEC USP_GetSET_PostValues_SF_SQL
			@procedureID =@@procid,
			@pid =@@spid,
			@NameKey ='TranId',
			@hostname ='',
			@ReserveCount =@ReserveCount,
			@SequenceID=@SequenceID OUTPUT ,
			@PostValue_StepSize=@PostValue_StepSize OUTPUT,
			@in_TWID  =@varTWid OUTPUT

			SET @TranID=@SequenceID+2


			COMMIT TRAN 
		END try 

		BEGIN catch 
			SET @Error =1 

			ROLLBACK TRANSACTION; 

			SET @ErrorMessage= 'error in Tranid generation' 
		END catch 

		--PRINT @Error 

		IF @Error = 0 AND (@NonMonetaryTxn IS NULL OR @NonMonetaryTxn = 0)
		  BEGIN 
			  --PRINT 'here ' 
		  
			  UPDATE st 
			  SET    TransactionAmount = TransactionAmount, 
					 insitutionid = bp.institutionid, 
					 productid = bp.parent02aid, 
					 txncode_internal = mtc.transactioncode, 
					 posttime = dateadd(second,AccountTransactionSequance, @CurrDateTime ), 
					 trantime = ISNULL(st.trantime, dateadd (second,AccountTransactionSequance,@CurrDateTime )), 
					 TransmissionDateTime = dateadd (second,AccountTransactionSequance,@CurrDateTime ), 
					 TxnAcctid = bp.acctid, 
					 atid = bp.atid, 
					 cmttrantype = mtc.logicmodule, 
					 Tranpriority = 0, 
					 PrimaryCurrencyCode = bp.primarycurrencycode, 
					 merchantid = bp.parent05aid, 
					 cardacceptoridcode = mpl.mplmerchantnumber, 
					 tranid = @TranID + TransactionCount, 
					 effectivedate = dateadd (second,AccountTransactionSequance,@CurrDateTime), 
					 postingref = 'Transaction Posted Successfully', 
					 InternalResponseCode = 'Posted successfuly', 
					 PostingReason = '0000', 
					 Primaryaccountnumber = case when e.ccinhparent125aid = 1 then  e.primaryaccountnumber else  ISNULL(st.Primaryaccountnumber,e.primaryaccountnumber) END, 
					 Pan_hash = case when e.ccinhparent125aid = 1 then  e.Pan_hash else  ISNULL(st.Pan_hash,e.Pan_hash) END, 
					 cardLastFourdegits = case when e.ccinhparent125aid = 1 then  e.cardnumber4digits else  ISNULL(st.cardLastFourdegits,e.cardnumber4digits) END,  
					 ArtxnType = '91', 
					 PostingFlag = '1', 
					 EmbAcctID = e.acctid, 
					 NetworkName = e.networkname, 
					 POSFiller = '0', 
					 TXNSource = isnull(st. TXNSource,'2'),
					 Creditplanmaster = st.creditplanmaster
			  FROM   embossingaccounts e WITH(nolock)  
					 JOIN bsegment_primary BP WITH(nolock) 
					   ON e.parent01aid = BP.acctid 
						  AND ( (e.ecardtype = 0  and @EmbAcctid is null) or e.acctid = @EmbAcctid) 
					 JOIN CreateNewSingleTransactionData st 
					   ON ( BP.accountnumber = st.accountnumber 
							AND BP.institutionid = @InsitutionID 
							AND st.transactionstatus = 1 ) 
					 JOIN monetarytxncontrol mtc WITH(nolock) 
					   ON ( mtc.actualtrancode = st.actualtrancode 
							AND mtc.groupid = @MTCGID ) 
					 JOIN logo_primary lg WITH(nolock) 
					   ON ( bp.parent02aid = lg.acctid )
					 JOIN merchantplaccounts mpl WITH(nolock) 
					   ON ( bp.parent05aid = mpl.acctid 
							AND mpl.mplmerchantlevel = '0' )  
					 left JOIN lpaccounts lp WITH(nolock) 
					   ON ( lp.acctid = lg.loyaltyprograms1 ) 
                
                        
			  IF ( @@rowcount <= 0 ) 
				BEGIN 
					SET @Error =2 
					SET @ErrorMessage= 'NOrecord MAtch' 
				END 
			  ELSE
				BEGIN 
					SET @Error =0 
					SET @ErrorMessage= 'DATA COOKED SUCCESSFULLY' 
				END 	
		  END 
		  ELSE IF @Error = 0 AND  @NonMonetaryTxn = 1
		  BEGIN 
			  --PRINT 'here ' 
		  
			  UPDATE st 
			  SET    TransactionAmount = TransactionAmount, 
					 insitutionid = bp.institutionid, 
					 productid = bp.parent02aid,  
					 posttime = dateadd(second,AccountTransactionSequance, @CurrDateTime ), 
					 trantime = ISNULL(st.trantime, dateadd (second,AccountTransactionSequance,@CurrDateTime )), 
					 TransmissionDateTime = dateadd (second,AccountTransactionSequance,@CurrDateTime ), 
					 TxnAcctid = bp.acctid, 
					 atid = bp.atid,  
					 Tranpriority = 0, 
					 PrimaryCurrencyCode = bp.primarycurrencycode, 
					 merchantid = bp.parent05aid, 
					 cardacceptoridcode = mpl.mplmerchantnumber, 
					 tranid = @TranID + TransactionCount, 
					 effectivedate = dateadd (second,AccountTransactionSequance,@CurrDateTime), 
					 postingref = 'Transaction Posted Successfully', 
					 InternalResponseCode = 'Posted successfuly', 
					 PostingReason = '0000', 
					 Primaryaccountnumber = case when e.ccinhparent125aid = 1 then  e.primaryaccountnumber else  ISNULL(st.Primaryaccountnumber,e.primaryaccountnumber) END, 
					 Pan_hash = case when e.ccinhparent125aid = 1 then  e.Pan_hash else  ISNULL(st.Pan_hash,e.Pan_hash) END, 
					 cardLastFourdegits = case when e.ccinhparent125aid = 1 then  e.cardnumber4digits else  ISNULL(st.cardLastFourdegits,e.cardnumber4digits) END,  
					 ArtxnType = '91', 
					 PostingFlag = '1', 
					 EmbAcctID = e.acctid, 
					 NetworkName = e.networkname, 
					 POSFiller = '0', 
					 TXNSource = isnull(st. TXNSource,'2'),
					 Creditplanmaster = st.creditplanmaster
			  FROM   embossingaccounts e WITH(nolock)  
					 JOIN bsegment_primary BP WITH(nolock) 
					   ON e.parent01aid = BP.acctid 
						  AND ( (e.ecardtype = 0  and @EmbAcctid is null) or e.acctid = @EmbAcctid) 
					 JOIN CreateNewSingleTransactionData st 
					   ON ( BP.accountnumber = st.accountnumber 
							AND BP.institutionid = @InsitutionID 
							AND st.transactionstatus = 1 ) 
					 JOIN logo_primary lg WITH(nolock) 
					   ON ( bp.parent02aid = lg.acctid )
					 JOIN merchantplaccounts mpl WITH(nolock) 
					   ON ( bp.parent05aid = mpl.acctid 
							AND mpl.mplmerchantlevel = '0' )  
					 left JOIN lpaccounts lp WITH(nolock) 
					   ON ( lp.acctid = lg.loyaltyprograms1 ) 
                    
					IF (@@ROWCOUNT > 0 ) 
					BEGIN 
						SET @Error = 0
						SET @ErrorMessage= 'RESULT - DATA_COOKED_SUCCESSFULLY_FOR_NonMonetaryTxn'
					END
					ELSE
					BEGIN
						SET @Error =2 
						SET @ErrorMessage= 'RESULT - DATA_NOT_COOKED_NO_RECORD_MATCH'
					END
		  END
		

	  End

    SELECT @Error, 
           @ErrorMessage 
END  
GO


