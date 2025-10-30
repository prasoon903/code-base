/****************************************************************************************************************
ALTER BY	 :- Ranveer Thakur
PURPOSE		 :- Added auto RetryAttempts code for self Retry in Merging Process
Sample call  :-	EXEC PR_MrgActWFSource '2018-02-06 15:42:46.000',11804,'RTHAKUR1'
*****************************************************************************************************************/
CREATE OR ALTER PROCEDURE PR_MrgActWFSource
@CurrentSysTime			DATETIME,
@ProcessID				INT,
@ComputerName			VARCHAR(30)
AS         
BEGIN
	SET NOCOUNT ON
	DECLARE @JobID					DECIMAL(19,0)
	DECLARE @MinJobID				DECIMAL(19,0)
	DECLARE @MaxSkey				DECIMAL(19,0)
	DECLARE @JobStatus				VARCHAR(50)
	DECLARE @PrevJobStatus			VARCHAR(50)
	DECLARE @JobIDFinal				VARCHAR(50)
	DECLARE @SrcInstIDTime			DATETIME
	DECLARE @DestInstIDTime			DATETIME
	DECLARE @MrgTransmissionTime	DATETIME
	DECLARE @MrgSrcActProcDayEndMin	DATETIME
	DECLARE @MrgSrcActProcDayEndMax	DATETIME
	DECLARE @MrgStartTime			DATETIME
	DECLARE @WS_StartTime			DATETIME
	DECLARE @MrgStep				VARCHAR(50)
	DECLARE @PrevMergeStep			VARCHAR(50)	
	DECLARE @Desc					VARCHAR(500)
	DECLARE @LogDesc				VARCHAR(500)
	DECLARE @ErrorMessage			VARCHAR(100)
	DECLARE @CompStatus				VARCHAR(50)
	DECLARE @RetryFlg				SMALLINT = 0
	DECLARE @ErrorLine				INT
	DECLARE @SrcMrgActBSAcct		INT
	DECLARE @DestMrgActBSAcct		INT
	DECLARE @ErrorTNPJobCount		INT
	DECLARE @SrcInstID				INT
	DECLARE @DestInstID				INT
	DECLARE @SrcAcctBacklogCount	INT
	DECLARE @DestAcctBacklogCount	INT
	DECLARE @SrcProcDayTimeDiff		INT
	DECLARE @DestProcDayTimeDiff	INT
	DECLARE @ProcDayTimeDiff		INT
	DECLARE @MsmqJobcount			INT
	DECLARE @MrgActWaitSec			INT
	DECLARE @InqueJobcount			INT
	DECLARE @RetryJobCount			SMALLINT
	DECLARE @UnderProcJobCount		INT
	DECLARE @ProcessIDNew			INT
	DECLARE @ComputerNameNew		VARCHAR(30)
	DECLARE @SrcWSNameName			VARCHAR(50)
	DECLARE @CurrentCompoName		VARCHAR(50)
	DECLARE @DestWSNameName			VARCHAR(50)
	DECLARE @ProcessNameChk			TINYINT
	DECLARE @bJobFound				TINYINT
	DECLARE @RetryAttempt			TINYINT
	DECLARE @bChkRetryAttempt		TINYINT
	DECLARE @PostingSrcJobTotCount	INT
	DECLARE @PostingDestJobTotCount	INT
	DECLARE @HoldPostTxnTotCount	INT
	DECLARE @PostingSrcJobCount		INT
	DECLARE @PostingDestJobCount	INT
	DECLARE @HoldPostTxnCount		INT
	DECLARE @JobStuckTime			INT
	DECLARE @JobWaitTime			INT
	DECLARE @bLogCreate				TINYINT


	SET @bJobFound = 0
	SET @RetryAttempt = 0
	SET @bChkRetryAttempt = 0
	SET @ProcessIDNew	 = @ProcessID
	SET @ComputerNameNew = @ComputerName
	SET @ProcessNameChk	 = 0
	SET @ProcDayTimeDiff = 0
	SET @MrgActWaitSec	 = 0
	SET @UnderProcJobCount	= 0
	SET @SrcWSNameName		= 'WS_MrgActSource'
	SET @DestWSNameName		= 'WS_MrgActSource'
	SET	@CurrentCompoName	= 'PR_MrgActWFSource'
	SET @Desc = ''
	SET @LogDesc = ''
	BEGIN TRY
	BEGIN TRANSACTION 
	
	---------------============================================= Processing Jobs in Retry Mod =========================================================================
	--StuckFixChange Start
	SET @JobID = 0
	SELECT TOP 1 @JobID = JobID FROM MergeAccountJob WITH(UPDLOCK,READPAST) 
	WHERE Jobstatus = 'READY' AND ProcessID = @ProcessID AND ComputerName = @ComputerName ORDER BY sKey

	IF( ISNULL(@JobID,0) > 0)
	BEGIN--Case 1
		SET @JobIDFinal =  CAST(@JobID AS VARCHAR(50))
		SET @Desc = @Desc + '|Jobstatus = READY AND ProcessID = ' + CAST(ISNULL(@ProcessID,0) AS VARCHAR) + ' AND ComputerName = ' 
					+ CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + ' | Found JobID: ' + CAST(ISNULL(@JobID,'NULL') AS VARCHAR)
		SET @LogDesc = @LogDesc + '|Underprocess Ready Job, Found JobID: ' + CAST(ISNULL(@JobID,'NULL') AS VARCHAR)
		INSERT INTO MrgActProcessLog 
			(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
			 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
		VALUES 
			(@JobID, @JobStatus, @SrcWSNameName, @DestWSNameName, @CurrentCompoName, @Desc, @LogDesc + '| MergeStep: ' 
			+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
			+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@CompStatus,'NULL') AS VARCHAR) + ' | ProcessID: ' 
			+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR), @CompStatus, @MrgStep, @RetryFlg, 
			@CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
	END
	ELSE
	BEGIN --StuckFixChange End
		IF(@bJobFound = 0)
		BEGIN
			SET @JobID = 0
			SET @bJobFound = 0 --StuckFixChange
			-- Seek : IDX_MergeAccountJob_RetryFlag
			SELECT TOP 1 @JobID = JobID FROM MergeAccountJob WITH(UPDLOCK,READPAST) WHERE RetryFlag = 2 ORDER BY sKey --StuckFixChange
			
			SET @Desc = @Desc + '|Tried RetryFlag = 2, Found JobID: ' + CAST(ISNULL(@JobID,'NULL') AS VARCHAR) 
			SET @LogDesc = @LogDesc + '|Tried RetryFlag = 2, Found JobID: ' + CAST(ISNULL(@JobID,'NULL') AS VARCHAR) 
			IF(ISNULL(@JobID,0) > 0)
			BEGIN --StuckFixChange
				-- Index Seek : IDX_MergeAccountJob_JobId
				SET @bJobFound = 1
				SELECT TOP 1 @JobID = JobID, @JobStatus = JobStatus, @MrgStep = MergeStep, @SrcMrgActBSAcct = SrcBSAcctId, @DestMrgActBSAcct = DestBSAcctId, 
						@SrcInstID = SrcBSInstitutionID, @DestInstID = DestBSInstitutionID, @CompStatus = CompStatus, @RetryFlg = RetryFlag, @MrgStartTime = MergeStartTime, 
						@MrgActWaitSec = MrgActProcessWait4Sec, @ProcessID = ProcessID, @ComputerName =  ComputerName, @PrevJobStatus = PrevJobStatus 
				FROM MergeAccountJob WHERE JobID = @JobID
				
				IF(@JobStatus IN ('NEW','DONE','INQUEUE','MDONE','MERROR'))
				BEGIN
					-- Seek : IDX_MergeAccountJob_RetryFlag
					UPDATE MAJ SET RetryFlag = 0 FROM MergeAccountJob MAJ WHERE JobID = @JobID
					SET @Desc = @Desc + '|Manual Retry is not required, Found JobID: ' + CAST(ISNULL(@JobID,'NULL') AS VARCHAR)
					SET @LogDesc = @LogDesc + '|Manual Retry is not required for JobStatus: NEW/DONE/MDONE/MERROR '
					SET @bJobFound = 0
					SET @JobID = 0
				END
				ELSE
				BEGIN
					SELECT TOP 1 @PrevMergeStep = PrevMergeStep FROM MrgActProcessLog WITH(NOLOCK) WHERE JobID = @JobID AND MergeStep = @MrgStep 
					AND PrevMergeStep <> MergeStep ORDER BY sKey DESC

					SET @Desc = @Desc + '|JobID = '+ CAST(ISNULL(@JobID,'NULL') AS VARCHAR) + 'AND MergeStep = ' + @MrgStep + 'AND PrevMergeStep <> MergeStep'
					SET @LogDesc = @LogDesc + ' |Manual Retry Job: '
					--Case 2
					INSERT INTO MrgActProcessLog 
						(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
						 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
					VALUES 
						(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + 'MergeStep: '
						+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
						+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | ProcessID: ' 
						+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR), @PrevMergeStep, @MrgStep, @RetryFlg, 
						@CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
	
					IF(@ComputerNameNew <> @ComputerName)
					BEGIN
						SET @ProcessNameChk = 1
					END

					IF(@ProcessIDNew <> @ProcessID )
					BEGIN
						SET @ProcessNameChk = 1
					END

					IF(@ProcessNameChk = 1)
					BEGIN
						
						SET @Desc = @Desc + '| Found JobID = '+ CAST(ISNULL(@JobID,'NULL') AS VARCHAR) + ' |ComputerNameNew' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR)
								 + ' |ComputerName' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + ' |@ProcessIDNew' + CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) 
								 + ' |ProcessID' + CAST(ISNULL(@ProcessID,0) AS VARCHAR)
						SET @LogDesc = @LogDesc +' |Manual Retry Job with Diff .WF:-'
						INSERT INTO MrgActProcessLog 
							(JobID, JobStatus,SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep, RetryFlag,
							 WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
						VALUES 
							(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName,@Desc, @LogDesc + 'MergeStep: ' 
							+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
							+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
							+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
							+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
							@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
							
						SET @ProcessID = @ProcessIDNew
						SET @ComputerName = @ComputerNameNew
					END
					-- Index Seek : IDX_MergeAccountJob_JobId
					UPDATE MAJ SET JobStatus = 'MERGE_IN_PROCESS',PrevJobStatus = @JobStatus, ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew --StuckFixChange
					FROM MergeAccountJob MAJ
					WHERE JobID = @JobID --StuckFixChange
				END
			END
		END
		---------------============================================= Processing MERGE_IN_PROCESS Jobs  ===================================================================
		IF(@bJobFound = 0)
		BEGIN
			SET @JobID = 0
			--StuckFixChange
			-- Seek with: IDX_MergeAccountJob_JobStatus
			SELECT TOP 1 @JobID = JobID, @JobStatus = JobStatus, @MrgStep = MergeStep, @SrcMrgActBSAcct = SrcBSAcctId, @DestMrgActBSAcct = DestBSAcctId, @SrcInstID = SrcBSInstitutionID, 
			@DestInstID = DestBSInstitutionID, @CompStatus = CompStatus,@RetryFlg = RetryFlag, @MrgStartTime = MergeStartTime, @MrgActWaitSec = MrgActProcessWait4Sec,
			 @ProcessID = ProcessID, @ComputerName =  ComputerName, @PrevJobStatus = JobStatus
			FROM MergeAccountJob  WITH(UPDLOCK,READPAST) WHERE JobStatus = 'MERGE_IN_PROCESS' AND ProcessID IS NULL AND ComputerName IS NULL --StuckFixChange
			ORDER BY TransmissionTime ASC --StuckFixChange

			SET @Desc = @Desc + '|JobStatus = MERGE_IN_PROCESS AND ProcessID IS NULL AND ComputerName IS NULL'
			SET @LogDesc = @LogDesc +'| MERGE_IN_PROCESS Job:'
			IF (ISNULL(@JobID, 0) > 0)
			BEGIN
				--Case 3
				SET @bJobFound = 1
				--StuckFixChange Start
				UPDATE MAJ SET ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew FROM MergeAccountJob MAJ WHERE JobID = @JobID
				INSERT INTO MrgActProcessLog
					(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
					RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
				VALUES
					(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName,@Desc, @LogDesc + ' MergeStep: ' 
					+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
					+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@CompStatus,'NULL') AS VARCHAR) + ' | ProcessID: ' 
					+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR), @CompStatus, @MrgStep, @RetryFlg, 
					@CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
			END
		END
			
		---================================================= Start Auto Retry for stuck Jobs =============================================================--

		IF(@bJobFound = 0)
		BEGIN
			SET @JobID = 0
			SET @WS_StartTime = NULL
			SET @MrgStep = 'NULL'
			-- Seek : 
			--StuckFixChange Start
			--SELECT TOP 1 @JobID = JobID FROM MergeAccountJob WITH(UPDLOCK,READPAST) WHERE JobStatus IN ('READY','LOCKED') AND RetryFlag = 0 ORDER BY sKey

			SELECT TOP 1 @JobID = JobID FROM MergeAccountJob WITH(UPDLOCK,READPAST) 
			WHERE JobStatus IN('READY','LOCKED') AND RetryFlag = 0 AND DATEDIFF(MINUTE,CompletedStepTime,GetDate()) > 10 
			ORDER BY sKey
			SET @Desc = @Desc + ' |JobStatus IN(READY,LOCKED) AND RetryFlag = 0 AND AND DATEDIFF(MINUTE,CompletedStepTime,GetDate()) > 10 '
			SET @LogDesc = @LogDesc +' |Going to process Job in Auto-Retry:'
			IF(ISNULL(@JobID,0) > 0)
			BEGIN
				--Case 4
				--StuckFixChange End
				-- Index Seek : IDX_MergeAccountJob_JobId
				SET @RetryAttempt = 0

				SELECT TOP 1 @JobID = JobID, @JobStatus = JobStatus, @MrgStep = MergeStep, @SrcMrgActBSAcct = SrcBSAcctId, @DestMrgActBSAcct = DestBSAcctId, 
				@SrcInstID = SrcBSInstitutionID, @DestInstID = DestBSInstitutionID, @CompStatus = CompStatus, @RetryFlg = RetryFlag, @MrgStartTime = MergeStartTime, 
				@MrgActWaitSec = MrgActProcessWait4Sec, @ProcessID = ProcessID, @ComputerName =  ComputerName, @PrevJobStatus = PrevJobStatus, @RetryAttempt = RetryAttempt 
				FROM MergeAccountJob WHERE JobID = @JobID
		
				SELECT TOP 1 @PrevMergeStep = PrevMergeStep FROM MrgActProcessLog WITH(NOLOCK) WHERE JobID = @JobID AND MergeStep = @MrgStep AND PrevMergeStep <> MergeStep 
				ORDER BY sKey DESC

				SELECT TOP 1 @WS_StartTime = WS_StartTime FROM MrgActProcessLog WITH(NOLOCK) WHERE JobID = @JobID AND MergeStep = @MrgStep ORDER BY sKey DESC
				
				INSERT INTO MrgActProcessLog 
					(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
						RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
				VALUES 
					(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
					+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
					+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
					+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
					+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
					@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)

				SET @JobStuckTime = 0
				SET @JobStuckTime = DATEDIFF(MINUTE, @WS_StartTime, GETDATE())  --SELECT DATEDIFF(MINUTE, '2021-04-22 15:25:10.000', '2021-04-22 16:10:55.000')
				SET @RetryAttempt = ISNULL(@RetryAttempt, 0)
				SET @bJobFound = 1

				IF(@JobStatus = 'READY')
				BEGIN
					SET @bChkRetryAttempt = 1
                    SET @Desc = @Desc + ' |@JobStatus = READY '
				END
				ELSE
				BEGIN
					IF(@MrgStep IN ('UpdAcctStatus','UpdPendingAuth','UpdBankAcct','RetailTxn','UpdStatusSCRA_MLA'))
					BEGIN   
						SET @Desc = @Desc + ' |@MrgStep IN (UpdAcctStatus,...'
						IF(@RetryAttempt < 5) 
						BEGIN
							SET @bChkRetryAttempt = 1
							SET @Desc = @Desc + '|@RetryAttempt < 5'	
						END
					END
					ELSE IF(@MrgStep = 'PostingSrcAcct')
					BEGIN
						SET @PostingSrcJobTotCount = 0
						SELECT @PostingSrcJobTotCount = COUNT(1) FROM MrgActCCardLog WITH(NOLOCK) WHERE MergeStep = @MrgStep AND JobID = @JobID
						SET @PostingSrcJobCount = 0
						SELECT @PostingSrcJobCount = COUNT(1) FROM MrgActCCardLog WITH(NOLOCK) WHERE MergeStep = @MrgStep AND MergeStatus IN('PENDINGDEST','DONE','ERROR') 
						AND JobID = @JobID
						
						SET @Desc = @Desc + ' |@MrgStep = PostingSrcAcct '
						SET @JobWaitTime = 0
						SET @PostingSrcJobTotCount = ISNULL(@PostingSrcJobTotCount,0)
						SET @PostingSrcJobCount = ISNULL(@PostingSrcJobCount,0)
						SET @PostingSrcJobCount = @PostingSrcJobTotCount - @PostingSrcJobCount
						SET @JobWaitTime = (@PostingSrcJobCount * 0.5) + 5

						IF(@JobStuckTime > @JobWaitTime AND @RetryAttempt < 5 AND @PostingSrcJobCount >= 0)
						BEGIN
							SET @bChkRetryAttempt = 1
							SET @Desc = @Desc + ' |@JobStuckTime > @JobWaitTime... '
						END
					END
					ELSE IF(@MrgStep = 'PostingDestAcct')
					BEGIN
						SET @Desc = @Desc + ' |@MrgStep = PostingDestAcct '
						SET @PostingDestJobTotCount = 0
						SELECT @PostingDestJobTotCount = COUNT(1) FROM MrgActCCardLog WITH(NOLOCK) WHERE MergeStep = @MrgStep AND JobID = @JobID
						SET @PostingDestJobCount = 0
						SELECT @PostingDestJobCount = COUNT(1) FROM MrgActCCardLog WITH(NOLOCK) WHERE MergeStep = @MrgStep AND MergeStatus IN ('DONE','ERROR') AND JobID = @JobID
						
						SET @JobWaitTime = 0
						SET @PostingDestJobTotCount = ISNULL(@PostingDestJobTotCount,0)
						SET @PostingDestJobCount = ISNULL(@PostingDestJobCount,0)
						SET @PostingDestJobCount = @PostingDestJobTotCount - @PostingDestJobCount
						SET @JobWaitTime = (@PostingDestJobCount * 0.5) + 5

						IF(@JobStuckTime > @JobWaitTime AND @RetryAttempt < 5 AND @PostingDestJobCount >= 0)
						BEGIN
							SET @bChkRetryAttempt = 1
							SET @Desc = @Desc + ' |@JobStuckTime > @JobWaitTime AND @RetryAttempt < 5 AND @PostingDestJobCount >= 0'
						END
					END
					ELSE IF(@MrgStep = 'HoldTxnPstAcct')
					BEGIN
						SET @Desc = @Desc + ' |@MrgStep = HoldTxnPstAcct'
						SET @HoldPostTxnTotCount = 0
						SELECT @HoldPostTxnTotCount = COUNT(1) FROM MergeAccounts With(NOLOCK) WHERE JobStatus = '1' AND parent01AID = @SrcMrgActBSAcct AND TranId IS NOT NULL
						SET @HoldPostTxnCount = 0
						SELECT @HoldPostTxnCount = COUNT(1) FROM MergeAccounts With(NOLOCK) WHERE JobStatus = '2' AND parent01AID = @SrcMrgActBSAcct AND TranId IS NOT NULL
						-- JobStatus=1 Tot Txn to be posted, Jobstatus=2 means Txn posted
						SET @JobWaitTime = 0
						SET @HoldPostTxnTotCount = ISNULL(@HoldPostTxnTotCount,0)
						SET @HoldPostTxnCount = ISNULL(@HoldPostTxnCount,0)
						SET @HoldPostTxnCount = @HoldPostTxnTotCount - @HoldPostTxnCount
						SET @JobWaitTime = (@HoldPostTxnCount * 0.5) + 5

						IF(@JobStuckTime > @JobWaitTime AND @RetryAttempt < 5 AND @HoldPostTxnCount >= 0)
						BEGIN
							SET @bChkRetryAttempt = 1 
							SET @Desc = @Desc + ' |@JobStuckTime > @JobWaitTime AND @RetryAttempt < 5 AND @HoldPostTxnCount >= 0'
						END
					END
				END
				IF(@RetryAttempt < 5)
				BEGIN
					SET @LogDesc = @LogDesc + ' |Auto-Retry LOCKED/READY Job:- '
					SET @Desc = @Desc + ' |Auto-Retry LOCKED/READY Job, @RetryAttempt < 5'
				END
				ELSE
				BEGIN
					SET @LogDesc = ' |RetryAttempt more than 5 Times and still Job is stuck with  MergeStep:  '
				END
				IF(@bChkRetryAttempt = 1)
				BEGIN
					SET @RetryFlg = 1
					UPDATE MAJ SET ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew, RetryFlag = @RetryFlg, RetryAttempt = ISNULL(RetryAttempt,0) + 1 
					FROM MergeAccountJob MAJ WHERE JobID = @JobID --StuckFixChange
					INSERT INTO MrgActProcessLog 
						(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
						 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
					VALUES 
						(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
						+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
						+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
						+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
						+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
						@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
				END
			END--StuckFixChange
			--SET @bJobFound = 0 --StuckFixChange
		END
	
		---================================================= End Auto Retry for stuck Jobs =======================================================================--
	
		IF(@MrgActWaitSec > 0)
		BEGIN
			WAITFOR DELAY @MrgActWaitSec
		END

		--====================================================  Restrict MergeAccount process 10 min before DayEnd   =================================================
	
		CREATE TABLE #Temp_MrgActProcDayEnd
		(
			SerialID		INT IDENTITY(1,1),
			InstitutionID	INT,
			ProcDayEnd		DATETIME
		)
		----========================================================================= Processing NEW jobs ==========================================================================
		IF (@bJobFound = 0 AND @CurrentSysTime IS NOT NULL)
		BEGIN
			SET @MrgStartTime = @CurrentSysTime
			-- Seek with: IDX_MergeAccountJob_JobStatus
			SET @JobID = 0
			SELECT TOP 1 @JobID = JobID, @JobStatus = JobStatus, @MrgStep = MergeStep, @SrcMrgActBSAcct = SrcBSAcctId, @DestMrgActBSAcct = DestBSAcctId, 
			@SrcInstID = SrcBSInstitutionID, @DestInstID = DestBSInstitutionID, @CompStatus = CompStatus,@RetryFlg = RetryFlag, @PrevJobStatus = NULL, 
			@MrgTransmissionTime = TransmissionTime
			FROM MergeAccountJob WITH(UPDLOCK,READPAST) 
			WHERE JobStatus = 'NEW' AND TransmissionTime <= @CurrentSysTime AND ProcessID IS NULL AND ComputerName IS NULL --StuckFixChange
			ORDER BY TransmissionTime, sKey ASC
			
			SET @Desc = @Desc + ' |JobStatus = NEW AND TransmissionTime <= ' + CAST(ISNULL(@CurrentSysTime,'NULL') AS VARCHAR) + 'AND ProcessID IS NULL AND ComputerName IS NULL'
			SET @LogDesc = @LogDesc + ' | Going to process NEW MrgAct Job:- '

			--StuckFixChange Start
			SET @bJobFound = 0
			IF(ISNULL(@JobID,0) > 0)
			BEGIN
				INSERT INTO #Temp_MrgActProcDayEnd (InstitutionID) SELECT SrcBSInstitutionID FROM MergeAccountJob  WITH(NOLOCK) WHERE JobID = @JobID
				INSERT INTO #Temp_MrgActProcDayEnd (InstitutionID) SELECT DestBSInstitutionID FROM MergeAccountJob WITH(NOLOCK) WHERE JobID = @JobID
				UPDATE TPD SET TPD.ProcDayEnd = AR.ProcDayEnd FROM #Temp_MrgActProcDayEnd TPD JOIN ARSystemEMAccounts AR WITH(NOLOCK) ON TPD.InstitutionID = AR.InstitutionID
				SELECT @MrgSrcActProcDayEndMin = MIN (ProcDayEND) From #Temp_MrgActProcDayEnd  -- to set hold	

				INSERT INTO MrgActProcessLog 
					(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
					 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
				VALUES 
					(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
					+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
					+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
					+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
					+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
					@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)

				--Case 5
				--StuckFixChange End
				SET @bLogCreate = 0
				IF(CAST(@MrgSrcActProcDayEndMin AS DATE) < CAST(@MrgTransmissionTime AS DATE))
				BEGIN
					SET @Desc = @Desc + ' | Hold Merge Process: ProcDayEnd is not updated, NEW Jobs will be processed when ProcDayEnd updated.'
					SET @bLogCreate = 1
				END			

				SET @MrgSrcActProcDayEndMax = DATEADD(MINUTE, -10, @MrgSrcActProcDayEndMin); 
				IF(CAST(@MrgSrcActProcDayEndMin AS DATE) = CAST(@MrgTransmissionTime AS DATE))				
				BEGIN
					IF (CONVERT(VARCHAR(20),@MrgTransmissionTime, 114) >= CONVERT(VARCHAR(20),@MrgSrcActProcDayEndMax, 114)) 
					BEGIN
						SET @Desc =  @Desc + ' |Hold Merge Process: ProcDayEnd is approaching soon, NEW Jobs will be processed in next businessday.'
						SET @bLogCreate = 1
					END			
				END

				IF(@bLogCreate = 1)
				BEGIN
					INSERT INTO MrgActProcessLog 
						(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
						 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
					VALUES 
						(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
						+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
						+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
						+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
						+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
						@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
					-- Seek : IDX_MergeAccountJob_JobId

					UPDATE MAJ SET Description = @Desc, TransmissionTime = DATEADD(minute, 1, TransmissionTime) FROM MergeAccountJob MAJ WHERE JobID = @JobID 
					SET @JobID = 0
				END
				ELSE
				BEGIN
					------------========================================= Validating under process Job ===================================================================
					SET @UnderProcJobCount = 0
					SELECT @UnderProcJobCount = COUNT(1) FROM MergeAccountJob WITH(NOLOCK) 
					WHERE JobStatus IN ('MERGE_IN_PROCESS','READY','LOCKED') AND (SrcBSAcctId IN (@SrcMrgActBSAcct, @DestMrgActBSAcct) OR 
					DestBSAcctId IN(@SrcMrgActBSAcct, @DestMrgActBSAcct))

					SET @Desc = @Desc + ' | JobStatus IN (MERGE_IN_PROCESS,READY,LOCKED) AND (SrcBSAcctId IN (' + CAST(@SrcMrgActBSAcct AS VARCHAR) + ',' 
							+ CAST(@DestMrgActBSAcct AS VARCHAR ) + ') OR DestBSAcctId IN(' + CAST(@SrcMrgActBSAcct AS VARCHAR ) + ',' + CAST(@DestMrgActBSAcct AS VARCHAR) 
							+ ')'
					SET @LogDesc = @LogDesc + ' | There is already a job in process having same Source / Dest. Account:- '
					
					IF(ISNULL(@UnderProcJobCount,0) > 0)
					BEGIN	
						-- Seek : IDX_MergeAccountJob_JobId
						UPDATE MAJ SET Description = @Desc FROM MergeAccountJob MAJ WHERE JobID = @JobID 

						INSERT INTO MrgActProcessLog 
							(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
							 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
						VALUES 
							(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
							+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
							+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
							+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
							+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
							@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)

						SET @JobID = 0 
						SET @JobStatus = NULL
						SET @bJobFound = 0
					END
					ELSE
					BEGIN
						--StuckFixChange Start
						CREATE TABLE #Temp_MsmqJobEmbAcctid
						(
							SKey		INT IDENTITY(1,1) NOT NULL,
							EmbAcctID	INT PRIMARY KEY
						)
						-- Seek : IDXN_DBA_EmbossingAccounts_parent01AID
						INSERT INTO #Temp_MsmqJobEmbAcctid(EmbAcctID) 
						SELECT AcctID FROM EmbossingAccounts WITH(NOLOCK) WHERE parent01AID = @SrcMrgActBSAcct

						-- Cluster Index Seek in #Temp_MsmqJobEmbAcctid and Seek dbbidx_IX_deJobStatus in SYN_CAuth_CoreIssueAuthMessage
						SET @MsmqJobcount = 0
						SELECT @MsmqJobcount = COUNT(1) FROM SYN_CAuth_CoreIssueAuthMessage CIA WITH(NOLOCK) 
						JOIN #Temp_MsmqJobEmbAcctid EA ON (CIA.TxnAcctId = EA.EmbAcctID) 
						WHERE  CIA.JobStatus IN('New','Pending','NoETCMapNP','NoETCMapP')

						IF(ISNULL(@MsmqJobcount,0) > 0)
						BEGIN
							SET @Desc = @Desc + ' |MSMQ Pending Jobs'
							SET @LogDesc = @LogDesc + ' |There are Pending Job(s) in MSMQ to process:-'
							-- Seek with : IDX_MergeAccountJob_JobId
							UPDATE MAJ SET Description = @Desc FROM  MergeAccountJob MAJ WHERE JobID = @JobID

							INSERT INTO MrgActProcessLog 
								(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
								 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
							VALUES 
								(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
								+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
								+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
								+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
								+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
								@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)

							SET @JobID = 0
						END
						ELSE
						BEGIN
							SET @bJobFound = 1
							SET @JobStatus = 'NEW'
							UPDATE MAJ SET ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew FROM MergeAccountJob MAJ WHERE JobID = @JobID --StuckFixChange

							SET @Desc = @Desc + ' |NEW Job Processing.'
							SET @LogDesc = @LogDesc + ' |NEW Job Processing:-'

							INSERT INTO MrgActProcessLog 
								(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
								 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
							VALUES 
								(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName, @Desc, @LogDesc + ' MergeStep: ' 
								+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
								+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@PrevMergeStep,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
								+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
								+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
								@PrevMergeStep, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)
						END
					END
				END
			END
		END
		--StuckFixChange Start
		-------------------------------------------------------- Deleting MergeActProcessLog ---------------------------------------------------
		-- Index Seek with : IDX_MergeAccountJob_JobStatus
		SET @MaxSkey = 0
		SELECT @MaxSkey = ISNULL(MAX(Skey),300000) - 300000 FROM  MergeAccountJob MA WITH(NOLOCK) WHERE MA.JobStatus = 'DONE'
		IF(@MaxSkey > 300000)
		BEGIN
			SET @MinJobID = 0
			-- Clustered Index Seek
			SELECT @MinJobID = jobID FROM MergeAccountJob WITH(NOLOCK) WHERE Skey = @MaxSkey
			SET @MinJobID = ISNULL(@MinJobID,0)
			-- Index Seek with : IX_MrgActProcessLog_JobID
			DELETE FROM MrgActProcessLog WHERE JobID < @MinJobID AND JobStatus = 'DONE'
		END
		-------------------------------------------------------- Deleting MergeActProcessLog ---------------------------------------------------
		--StuckFixChange END
		--=================================================================  MergeAccount Process ============================================================================		
		IF (@JobID > 0)
		BEGIN
			IF(@MrgStep IS NULL)
			BEGIN
				SET @MrgStep = 'UpdAcctStatus'
			END
			SET @PrevJobStatus = @JobStatus
			SET @JobStatus = 'READY' 

			IF @RetryFlg IN (1,2)
			BEGIN
				--SELECT TOP 1 @PrevMergeStep = PrevMergeStep FROM MrgActProcessLog WITH(NOLOCK) WHERE JobID = @JobID AND MergeStep = @MrgStep AND PrevMergeStep <> MergeStep 
				--ORDER BY sKey DESC
				-- Index Seek : IDX_MergeAccountJob_JobId
				UPDATE MergeAccountJob
				SET JobStatus = @JobStatus, CompStatus = @PrevMergeStep, ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew, 
				PrevJobStatus = @PrevJobStatus, Description = 'Retry Mode Job.'
				WHERE JobID = @JobID

				SET @CompStatus = @PrevMergeStep
			END
			ELSE
			BEGIN
				-- Index Seek with : IDX_MergeAccountJob_JobId
				UPDATE MergeAccountJob 
				SET JobStatus = @JobStatus, CompStatus = @CompStatus, MergeStep = @MrgStep, ProcessID = @ProcessIDNew, ComputerName = @ComputerNameNew,
					CompletedStepTime = CASE WHEN  @MrgStep = 'UpdAcctStatus' THEN @CurrentSysTime ELSE CompletedStepTime END,
					PrevJobStatus = @PrevJobStatus, Description = 'Regular Mode Job.'
				WHERE JobID = @JobID
			END
			
			--SET @Desc = @Desc + 'End of PR_MrgActWFSource'
			SET @LogDesc = @LogDesc + ' |End of PR_MrgActWFSource:-'
			INSERT INTO MrgActProcessLog
				(JobID, JobStatus, SrcWorkStepName, DestWorkStepName, CurrentComponentName, Description, LogDescription, PrevMergeStep, MergeStep,
				 RetryFlag, WS_StartTime, WS_EndTime, TotalTimeTaken, PrevJobStatus)
			VALUES 
				(@JobID,@JobStatus,@SrcWSNameName,@DestWSNameName,@CurrentCompoName,@Desc, @LogDesc + ' MergeStep: ' 
				+ CAST(ISNULL(@MrgStep,'NULL') AS VARCHAR) + ' | JobStatus: ' + CAST(ISNULL(@JobStatus,'NULL') AS VARCHAR) + ' | PrevJobStatus: ' 
				+ CAST(ISNULL(@PrevJobStatus,'NULL') AS VARCHAR) + '| CompletedStatus: ' + CAST(ISNULL(@CompStatus,'NULL') AS VARCHAR) + ' | Old ProcessID: ' 
				+ CAST(ISNULL(@ProcessID,0) AS VARCHAR) + '| Old ComputerName: ' + CAST(ISNULL(@ComputerName,'NULL') AS VARCHAR) + '| New ProcessID: ' 
				+ CAST(ISNULL(@ProcessIDNew,0) AS VARCHAR) + '| New ComputerName: ' + CAST(ISNULL(@ComputerNameNew,'NULL') AS VARCHAR),
				@CompStatus, @MrgStep, @RetryFlg, @CurrentSysTime, GETDATE(), DATEDIFF(SECOND, @CurrentSysTime, GETDATE()), @PrevJobStatus)

			SET @JobIDFinal = CAST(@JobID AS VARCHAR(50))
			--SELECT @JobIDFinal  --StuckFixChange
		END
		ELSE
		BEGIN
			-- Not required any Index for below query
			SET @JobIDFinal ='0'
			--SELECT @JobIDFinal  --StuckFixChange
		END
	END
	COMMIT TRANSACTION 
	SELECT @JobIDFinal	 --StuckFixChange
	END TRY

	BEGIN CATCH					
	ROLLBACK TRANSACTION
	-- Index Seek with : IDX_MergeAccountJob_JobId
	UPDATE MergeAccountJob SET Description = OBJECT_NAME(@@PROCID) + ' - ERROR LINE ( ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' ) DESCRIPTION : ' + ERROR_MESSAGE()
	WHERE JobID = @JobID				

	SET @JobIDFinal = CAST(@JobID AS VARCHAR(50))
	SELECT @JobIDFinal
	END CATCH
END
