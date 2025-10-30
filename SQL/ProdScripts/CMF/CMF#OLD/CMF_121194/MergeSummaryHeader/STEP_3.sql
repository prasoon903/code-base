--UPDATE TempMergeSummaryHeader SET Skey = NULL

--SELECT * FROM TempMergeSummaryHeader

--SELECT * FROM Postvalues WHERE Name = 'MergeSummaryHeader'

DECLARE @CurrDateTime DATETIME 
DECLARE @Skey DECIMAL(19) 
DECLARE @vTmpBsegmentCount INT

SELECT @vTmpBsegmentCount = COUNT(1) 
FROM   TempMergeSummaryHeader WITH(nolock) 
--print @vTmpBsegmentCount
BEGIN try 
	BEGIN TRAN 
	
	DECLARE @SequenceID  DECIMAL(19,0)
	DECLARE @PostValue_StepSize INT
	DECLARE @varTWid INT
	DECLARE @ReserveCount INT=Isnull(@vTmpBsegmentCount, 0) + 10 

	EXEC USP_GetSET_PostValues_SF_SQL
		@procedureID			= @@procid,
		@pid					= @@spid,
		@NameKey				= 'MergeSummaryHeader',
		@hostname			= '',
		@ReserveCount			= @ReserveCount,
		@SequenceID			= @SequenceID OUTPUT ,
		@PostValue_StepSize	= @PostValue_StepSize OUTPUT,
		@in_TWID				= @varTWid OUTPUT

	SET @Skey = @SequenceID+2


	COMMIT TRAN 
END try 

BEGIN catch 

	ROLLBACK TRANSACTION; 
	SELECT 'ERROR IN SKEY GENERATION FOR APIQueue TABLE' [Message]

END catch


UPDATE TempMergeSummaryHeader SET Skey = @Skey + SN

UPDATE TempMergeSummaryHeader SET acctID = 162705154, parent02AID = 4363497 WHERE acctID = 90980655
UPDATE TempMergeSummaryHeader SET acctID = 162721151, parent02AID = 4363497 WHERE acctID = 90980654