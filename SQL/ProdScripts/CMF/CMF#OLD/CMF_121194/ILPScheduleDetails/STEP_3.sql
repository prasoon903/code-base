--UPDATE TempILPScheduleDetails SET Skey = NULL

--SELECT Skey, * FROM TempILPScheduleDetails

--SELECT * FROM Postvalues WHERE Name = 'ILPScheduleDetails'

DECLARE @CurrDateTime DATETIME 
DECLARE @Skey DECIMAL(19) 
DECLARE @vTmpBsegmentCount INT

SELECT @vTmpBsegmentCount = COUNT(1) 
FROM   TempILPScheduleDetails WITH(nolock) 
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
		@NameKey				= 'ILPScheduleDetails',
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

--SELECT MergeSourcePlanID, ScheduleID, Activity,* FROM ILPScheduleDetailSummary WITH (NOLOCK) WHERE parent02AID = 4363497 AND Mergeindicator IS NOT NULL ORDER BY ActivityOrder

--SELECT * FROM ILPScheduleDetails WITH (NOLOCK) WHERE acctID = 18339073



UPDATE TempILPScheduleDetails SET Skey = @Skey + SN

UPDATE TempILPScheduleDetails SET ScheduleID = 34054469, acctID = 162705154, parent02AID = 4363497 WHERE acctID = 90980655
UPDATE TempILPScheduleDetails SET ScheduleID = 34054468, acctID = 162721151, parent02AID = 4363497 WHERE acctID = 90980654
UPDATE TempILPScheduleDetails SET ScheduleID = 34054467, acctID = 162735145, parent02AID = 4363497 WHERE acctID = 18339073