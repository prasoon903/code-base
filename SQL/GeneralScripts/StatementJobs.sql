--select * from postvalues where name ='jobid'
--EXEC StatementJobs_Ins '2018-02-28 23:59:57.000'
create OR ALTER procedure StatementJobs_Ins @statementdate datetime 
AS
--drop table #statementjobs
DECLARE @JobID BIGINT,
@SeqID INT,
@acctid INT,
@count INT,
@ErrorInTranID INT,
--@statementdate datetime = '2018-02-28 23:59:57.000'
@ReportID  int,    
@AID   int,    
@SecondaryIdParam decimal,    
@CurrentDate datetime,    
@InstitutionId int  ,
 @ScheduleIDInc int   , 
 @ATID int ,   
 @SecondaryID int    ,
 @RecipientId int    ,
 @Source varchar(50)   , 
 @Frequency tinyint    ,
 @DeliveryMethod int   , 
 @NextDateTime datetime  

BEGIN

select @SeqID = COUNT(1) from statementheader with(nolock) where StatementDate = @statementdate

BEGIN TRY 
	BEGIN TRAN 
		SELECT @JobID = seq + 2 
		FROM   postvalues WITH(updlock)  WHERE  NAME = 'jobid' 
			
		UPDATE postvalues 
		SET    seq = seq +  Isnull(@SeqID, 0) + 2  WHERE  NAME = 'jobid'
	COMMIT TRAN 
END TRY
BEGIN catch 
	SET @ErrorInTranID =1 
END catch 

create table #statementjobs( 
JobID INT,
acctId int,
parent05AID int null,
StatementDate datetime null,
AccountNumber varchar(19) null,
ClientId varchar(50),
LastStatementDate datetime null,
productID int null,
BSegment_UUID varchar(64) null,
StmtHeader_UUID varchar(64) null,
requestdate datetime null,
status varchar(10) null,
processeddate datetime null,
stmtprodflag varchar(8) null,
)

INSERT INTO #statementjobs(acctId,parent05AID,StatementDate,AccountNumber,ClientId,LastStatementDate,productID,StmtHeader_UUID,status,requestdate,stmtprodflag)
(SELECT acctId,parent05AID,StatementDate,AccountNumber,ClientId,LastStatementDate,parent02AID,UniversalUniqueID,'NEW' as status,statementdate
,0 as stmtprodflag from statementheader where statementdate = @statementdate)

UPDATE SJ SET SJ.BSegment_UUID = BP.universalUniqueId FROM Bsegment_Primary BP join #statementjobs SJ on BP.acctid= SJ.acctid where SJ.statementdate = @statementdate


select @count=count(1) from #statementjobs

WHILE(@count>0)
	BEGIN
		select TOP 1 @acctid = acctid from #statementjobs where JobID IS NULL
		update #statementjobs SET JobID = @jobid + 1 WHERE acctId = @acctid
		set @jobid = @jobid+1

		SET @count = @count - 1

	END

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			insert into statementjobs(JobID,acctId,parent05AID,StatementDate,AccountNumber,ClientId,LastStatementDate,StmtHeader_UUID,productID,status,requestdate,processeddate,stmtprodflag,BSegment_UUID)
			(select JobID,acctId,parent05AID,StatementDate,AccountNumber,ClientId,LastStatementDate,StmtHeader_UUID,productID,status,requestdate,processeddate,stmtprodflag,BSegment_UUID from #statementjobs)
			--SET @CurrentDate = '';
			SET @InstitutionId = 6969
			SET @ReportID = 327
			--SET @AID = 327

			set @ATID=51    
			set @RecipientId=@AID    
			--set @SecondaryID=JOB ID of statement jobs    
			set @Source='CoreIssue'    
			set @Frequency=2    
			set @DeliveryMethod=4    
			set @NextDateTime= '2019-06-01 00:00:01.000'
				
			CREATE TABLE #TempReportSchedule
			(

			ReportID INT
			,ATID INT
			,AID INT
			,SecondaryID DECIMAL
			,RecipientId INT
			,Source VARCHAR(15)
			,Frequency INT
			,DeliveryMethod INT 
			,NextDateTime DATETIME
			,InstitutionId INT
			)

			INSERT INTO #TempReportSchedule (ReportID,ATID,AID,SecondaryID,RecipientId,Source,Frequency,DeliveryMethod,NextDateTime,InstitutionId)
			SELECT 327,51,acctId,JOBID,acctId,'coreissue',2,4,'2019-06-01 00:00:01.000',6969 FROM StatementJobs WHERE StatementDate = @statementdate

			INSERT INTO ReportSchedules (ReportID,ATID,AID,SecondaryID,RecipientId,Source,Frequency,DeliveryMethod,NextDateTime,InstitutionId)    
			SELECT ReportID,ATID,AID,SecondaryID,RecipientId,Source,Frequency,DeliveryMethod,NextDateTime,InstitutionId FROM #TempReportSchedule
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
END

END


