----------------------------------------------Step1 -------------------------------------------------------
--Script need to run on coreissue primary  database 
DECLARE @SrcTranID decimal (19)
DECLARE @TranID decimal(19)
DECLARE @AccountNumber VARCHAR(20)
DECLARE @BSAcctID INT
DECLARE @TransactionAmount MONEY
DECLARE @TXnCode_Internal VARCHAR(20)
DECLARE @Error int = 0 
SET @SrcTranID = 76646908042
SET @AccountNumber = '1100011182704787'
SET @BSAcctID = (SELECT acctid FROM BSegment_Primary WITH(NOLOCK) WHERE AccountNumber = @AccountNumber)

SELECT top 1 @TXnCode_Internal= transactioncode FROM monetarytxncontrol where ActualTranCode = '2106'
BEGIN try 	
	BEGIN TRANSACTION 

	   DECLARE @SequenceID  DECIMAL(19,0)  
	   DECLARE @PostValue_StepSize INT  
	   DECLARE @varTWid INT  
	   DECLARE @vTmpBsegmentCount INT
	   SET @vTmpBsegmentCount=1
	   DECLARE @ReserveCount INT=Isnull(@vTmpBsegmentCount, 0) + 10 
	   --DECLARE @TranID decimal(19,0)  
  
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
  

	COMMIT TRANSACTION
END try 
BEGIN catch 
	SET @Error =1 
	ROLLBACK TRANSACTION; 
	select error_number(),Error_message()
END catch 

if (@Error = 0 and @TranID > 1 )
Begin 
	Begin Try	
		PRINT @TranID

		SELECT * INTO #CCard_PrimaryLM43Src FROM CCard_Primary WITH(NOLOCK) WHERE tranid = @SrcTranID
		SELECT * INTO #CCard_SecondaryLM43Src FROM CCard_Secondary WITH(NOLOCK) WHERE tranid = @SrcTranID
		

		UPDATE #CCard_PrimaryLM43Src SET UNiqueID = @TranID,TranID = @TranID,ATID=51
		,TxnAcctID=@BSAcctID,CMTTranType = '21',TXnCode_Internal=@TXnCode_Internal,
		BSAcctID=@BSAcctID,accountnumber = @AccountNumber
		WHERE tranid = @SrcTranID

		UPDATE #CCard_SecondaryLM43Src SET TranID = @TranID,ReconciliationDate=null,ReconciliationIndicator=null,
		AcqTranID=Null,transactioncode ='2106',EntryReason=1,FileName='CI@ForcePost' WHERE tranid = @SrcTranID
		


		if exists (SELECT top 1 1   FROM #CCard_PrimaryLM43Src WITH(NOLOCK))
		Begin 
		BEGIN TRANSACTION 
			INSERT INTO CCard_Primary SELECT * FROM #CCard_PrimaryLM43Src
			INSERT INTO CCard_Secondary SELECT * FROM #CCard_SecondaryLM43Src

		COMMIT TRANSACTION 
		End 
		else 
		Begin 
			select 'Tranid is not valid '	
		End

END try 
BEGIN catch 
	SET @Error =1 
	if (@@trancount > 0 )
		ROLLBACK TRANSACTION; 

	select error_number(),Error_message()
END catch

END 
Else 
Begin 
	select 'Error in tranid generateion'
End 

