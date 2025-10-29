--EXEC USP_InstallmentDetails @PlanID = 40755648, @LinkServer = 'XEON-S8', @DB = 'PP_CI', @PurchaseSchedule = 1
--EXEC USP_InstallmentDetails @SpecificSchedule = 4653298, @LinkServer = 'XEON-S8', @DB = 'PP_CI', @ScheduleProjection = 1
USE PP_CI
GO
CREATE OR ALTER PROCEDURE USP_InstallmentDetails
	@BSacctId INT = NULL,
	@PlanID INT = NULL,
	@AccountNumber VARCHAR(19) = NULL,
	@AccountUUID VARCHAR(64) = NULL, 
	@PlanUUID VARCHAR(64) = NULL, 
	@PurchaseSchedule INT = 0,
	@SpecificSchedule DECIMAL(19,0) = 0, 
	@ScheduleProjection INT = 0,
	@LinkServer VARCHAR(50),
	@DB VARCHAR(30),
	@DB_Sec VARCHAR(30) = NULL
AS
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	SET XACT_ABORT ON;


	DECLARE 
		@SQL NVARCHAR(MAX), 
		@ColumnNames NVARCHAR(MAX),
		@SelectionCriteria NVARCHAR(MAX),
		@ID NVARCHAR(100), 
		@Date NVARCHAR(100),
		@ScheduleIndicator INT

	--AUTHOR: PRASOON PARASHAR
	--Purpose: Dashboard intergration
	
	   	  
	BEGIN TRY
		IF (@LinkServer IS NULL OR @LinkServer = '')
		BEGIN

			SELECT 'LINKSERVER CAN NOT BE NULL' AS ErrorMessage
			RETURN
		END
		ELSE IF (@LinkServer IS NOT NULL AND @LinkServer <> '')
		BEGIN

			IF NOT EXISTS (SELECT TOP 1 1 FROM Sys.servers WITH(NOLOCK) WHERE NAME =  @LinkServer)
			BEGIN 
				SELECT 'Please Provide Correct LINKSERVER == '+ @LinkServer AS ErrorMessage
				RETURN
			END
		END

		SET @LINKSERVER = QUOTENAME(@LINKSERVER)
		SET @DB = QUOTENAME(@DB)
		SET @DB_Sec = QUOTENAME(@DB_Sec)

		IF(@SpecificSchedule IS NULL OR @SpecificSchedule = 0)
		BEGIN
			IF(@PlanID IS NULL OR @PlanID <= 0)
			BEGIN
				IF(@PlanUUID IS NULL OR @PlanUUID = '')
				BEGIN
					IF(@BSacctId IS NOT NULL AND @BSacctId <> 0)
					BEGIN
						SET @BSacctId = @BSacctId
					END
					ELSE IF(@AccountNumber IS NOT NULL AND @AccountNumber <> '')
					BEGIN
						SET @ID = TRY_CAST(@AccountNumber AS NVARCHAR(19))
						SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber =  @ID'
						--PRINT @SQL
						EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @BSacctId OUTPUT
						SET @BSacctId = @BSacctId
					END
					ELSE IF(@AccountUUID IS NOT NULL AND @AccountUUID <> '')
					BEGIN
						SET @ID = TRY_CAST(@AccountUUID AS NVARCHAR(64))
						--PRINT @ID
						SET @SQL = 'SELECT @acctID = acctID FROM ' + @LINKSERVER + '.' + @DB + '.dbo.Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID =  @ID'
						--PRINT @SQL
						EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @acctID INT OUTPUT', @ID=@ID, @acctID = @BSacctId OUTPUT
						SET @BSacctId = @BSacctId
					END
					ELSE
					BEGIN
						SELECT 'AccountID or AccountNumber or AccountUUID or SpecificSchedule or PlanID or PlanUUID MUST BE PASSED' ErrorMessage
						RETURN
					END
				END
			END
		END


		IF(@ScheduleProjection = 1)
		BEGIN
			IF(@SpecificSchedule IS NULL OR @SpecificSchedule = 0)
			BEGIN
				SELECT 'Schedule ID required to fetch the schedule projection' ErrorMessage
				RETURN
			END

			SET @ID = TRY_CAST(@SpecificSchedule AS NVARCHAR(19))
			SET @SQL = 'SELECT @ScheduleIndicator = ScheduleIndicator FROM ' + @LINKSERVER + '.' + @DB + '.dbo.ILPScheduleDetailSummary WITH (NOLOCK) WHERE ScheduleID =  @ID'
			--PRINT @SQL
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100), @ScheduleIndicator INT OUTPUT', @ID=@ID, @ScheduleIndicator = @ScheduleIndicator OUTPUT
			SET @ScheduleIndicator = @ScheduleIndicator

			IF(@ScheduleIndicator = 2)
			BEGIN
				SET @ColumnNames = N'acctId,parent02AID,LoanDate,LoanTerm,LastStatementDate,DateOfNextStmt,RegularPaymentAmountforIteration,
									StatementDate,DateOfTotalDue,CurrentBalance,OriginalLoanTerm,OriginalLoanEndDate,OriginalLoanAmount,RemainingPrincipal,
									PrincipalBilledCTD,ScheduleIndicator,LoanEndDate,ScheduleID,IsDeferCycle'
	
				SET @SQL = N'SELECT ''ILPScheduleDetailsRevised'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB + '.dbo.ILPScheduleDetailsRevised ILPS WITH(NOLOCK)
				WHERE  ILPS.ScheduleID = @ID
				ORDER BY ILPS.LoanTerm'
			END
			ELSE
			BEGIN
				SET @ColumnNames = N'acctId,parent02AID,LoanDate,LoanTerm,LastStatementDate,DateOfNextStmt,RegularPaymentAmountforIteration,
									StatementDate,DateOfTotalDue,CurrentBalance,OriginalLoanTerm,OriginalLoanEndDate,OriginalLoanAmount,RemainingPrincipal,
									PrincipalBilledCTD,ScheduleIndicator,LoanEndDate,ScheduleID,IsDeferCycle'
	
				SET @SQL = N'SELECT ''ILPScheduleDetails'' [Table], ' + @ColumnNames + '
				FROM ' + @LINKSERVER + '.' + @DB + '.dbo.ILPScheduleDetails ILPS WITH(NOLOCK)
				WHERE  ILPS.ScheduleID = @ID
				ORDER BY ILPS.LoanTerm'
			END

			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END
		--SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
		ELSE
		BEGIN
			SET @ColumnNames = N'PlanID,parent02AID,TranId,AuthTranId,APR,creditplanmaster, RTRIM(CL.LutDescription) AS ActivityDescription,Principal,CurrentBalance,OriginalLoanAmount,LoanDate,OriginalLoanEndDate,
			LoanTerm,RevisedLoanTerm,EqualPaymentAmountCalc,EqualPaymentAmountPassed,FirstMonthPayment,LastMonthPayment,ScheduleIndicator,ScheduleDate,PlanUUID,
			LoanEndDate,ScheduleID,Activity,PaidOffDate,LoanReversedDate,CaseID,WaiveMinDueCycle,LastStatementDate,ActivityAmount,MaturityDate,ActivityOrder,
			ActualLoanEndDate,LastTermDate,ScheduleType,CorrectionDate,ClaimID,DRPApplied,ClientID,DeferCycle,ReageReversed,ReageReversalGenerated,LoanStartDate,
			MergeDate,MergeIndicator,MergeSourceAccountID,MergeSourcePlanID,MergeDestinationPlanID,MergeScheduleType'
	
			SET @SQL = N'SELECT ''ILPSummary'' [Table], ' + @ColumnNames + '
			FROM ' + @LINKSERVER + '.' + @DB + '.dbo.ILPScheduleDetailSummary ILPS WITH(NOLOCK)
			LEFT OUTER JOIN ' + @LINKSERVER + '.' + @DB + '.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)'
			--WHERE  BP.acctid = @ID'

			SET @SelectionCriteria = ' WHERE CL.LUTid = ''EPPReasonCode'' '

			IF(@SpecificSchedule IS NOT NULL AND @SpecificSchedule > 0)
			BEGIN
				SET @ID = TRY_CAST(@SpecificSchedule AS NVARCHAR(19))
				SET @SelectionCriteria = @SelectionCriteria + ' AND ILPS.ScheduleID = @ID'
			END
			ELSE IF(@PlanUUID IS NOT NULL AND @PlanUUID <> '')
			BEGIN
				SET @ID = TRY_CAST(@PlanUUID AS NVARCHAR(64))
				SET @SelectionCriteria = @SelectionCriteria + ' AND ILPS.PlanUUID = @ID'
			END
			ELSE IF(@PlanID IS NOT NULL AND @PlanID > 0)
			BEGIN
				SET @ID = TRY_CAST(@PlanID AS NVARCHAR)
				SET @SelectionCriteria = @SelectionCriteria + ' AND ILPS.PlanID = @ID'
			END
			ELSE IF(@BSacctId IS NOT NULL AND @BSacctId > 0)
			BEGIN
				SET @ID = TRY_CAST(@BSacctId AS NVARCHAR)
				SET @SelectionCriteria = @SelectionCriteria + ' AND ILPS.parent02AID = @ID'
			END

			IF(@PurchaseSchedule = 1)
			BEGIN 
				SET @SelectionCriteria = @SelectionCriteria + ' AND ILPS.ActivityOrder = 1'
			END	
			
			SET @SelectionCriteria = @SelectionCriteria + ' ORDER BY ILPS.ActivityOrder'

			SET @SQL = @SQL + @SelectionCriteria

			--PRINT(@SQL)
	
			EXECUTE SP_EXECUTESQL @SQL, N'@ID NVARCHAR(100)', @ID=@ID
		END


	END TRY

	BEGIN CATCH
			SELECT ERROR_number() AS ERRORnumberInSP,ERROR_LINE() as ERRORLINEInSP,ERROR_MESSAGE() AS ERRORMESSAGEInSP,ERROR_STATE() AS ERRORSTATEInSP
	END CATCH

END