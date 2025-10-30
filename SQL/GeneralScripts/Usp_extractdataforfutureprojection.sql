/****** Object:  StoredProcedure [dbo].[Usp_extractdataforfutureprojection]    Script Date: 10/4/2018 11:26:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


/*
 =============================================  
 Updated by  : Sunil Rathor 
 Update      : Added code for Insert record in report schedules table for report id 538 (Interest Projection File)   
 Date        : 09/28/2018   
 =============================================
 */


ALTER PROCEDURE [dbo].[Usp_extractdataforfutureprojection] (@ARSystemAcctId INT)
AS
    SET nocount ON

    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE          
    DECLARE @BusinessDay DATETIME
    /*<<== Changes required for Multi Institution ==>> */
    DECLARE @iARSystemAcctId INT = @ARSystemAcctId
    DECLARE @OrgAcctid   INT,
            @ChunkSize   INT=5000,
            @MinAcctid   DECIMAL(19)=0,
            @MaxAcctid   DECIMAL(19)=0,
            @RecordCount INT,
            @LastChunk   INT=0,
			@CurrentDate Datetime,--CBR
			@MonthEndDate Datetime, --CBR
			@AccountInfoCount INT=0,
			@PlanInfoCount INT=0

	Create Table #TempBsegmentPrimary(
		Acctid int Primary Key,
		accountnumber varchar(19),
		AlternateAccount varchar(19),
		AmountOfCreditsCTD money,
		AmountOfDebitsCTD money,
		AmountOfPaymentsMTD money,
		amtofaccthighballtd money,
		amtofpaycurrdue money,
		beginningbalance money,
		billingcycle varchar(9),
		ccinhparent125aid int ,
		ccinhparent127aid int,
		createdtime datetime,
		creditlimit money,
		currentbalance money,
		cycleduedtd int,
		DateAcctClosed datetime,
		DateofLastDebit datetime,
		dateofnextstmt  datetime,
		EnterCollectionDate datetime,
		institutionid int,
		LastCreditDate datetime,
		LastNSFPayRevDate datetime,
		lastreagedate datetime,
		laststatementdate datetime,
		nsffeesbillednotpaid money,
		NSFFeesCTD money,
		NumberAccounts int,
		parent02aid int,
		parent05aid int,
		pendingotb money,
		principal money,
		systemstatus int,
		WaiveLateFees varchar(5),
		WaiveMembershipFee varchar(5),
		WaiveOverlimitFee varchar(5),
		WaiveTranFeeNCharOff varchar(5),
		SysOrgID INT,--CBR 
		Application_ID VARCHAR(25),--CBR 
		Date_Opened datetime,--CBR 
		AmtOfPaymentRevMTD MONEY,--CBR 
		OldAccountNumber varchar(19),--CBR
		ReportHistoryCtrCC01 Int ,--CBR 
		ReportHistoryCtrCC02 Int ,--CBR
		ReportHistoryCtrCC03 Int  ,--CBR
		ReportHistoryCtrCC04 Int ,--
		ReportHistoryCtrCC05 Int ,--CBR
		ReportHistoryCtrCC06 Int ,--CBR
		ReportHistoryCtrCC07 Int ,--CBR
		ReportHistoryCtrCC08 Int ,--CBR
		ReportHistoryCtrCC09 Int ,--CBR
		ReportHistoryCtrCC10 Int ,--CBR
		ReportHistoryCtrCC11 Int ,--CBR
		ReportHistoryCtrCC12 Int ,--CBR
		ReportHistoryCtrCC13 Int ,--CBR
		ReportHistoryCtrCC14 Int ,--CBR
		ReportHistoryCtrCC15 Int ,--CBR
		ReportHistoryCtrCC16 Int ,--CBR
		ReportHistoryCtrCC17 Int ,--CBR
		ReportHistoryCtrCC18 Int ,--CBR
		ReportHistoryCtrCC19 Int ,--CBR
		ReportHistoryCtrCC20 Int ,--CBR
		ReportHistoryCtrCC21 Int ,--CBR
		ReportHistoryCtrCC22 Int ,--CBR
		ReportHistoryCtrCC23 Int, --CBR
		ReportHistoryCtrCC24 Int ,--CBR
		LAD DATETIME,
		IntWaiveForSCRA INT,
		DateAcctOpened DATETIME,
		LastPaymentdate DATETIME--TD#202532 
	)

	


    SELECT @BusinessDay = procdayend
    FROM   dbo.arsystemaccounts WITH(nolock)
    WHERE  acctid = @iARSystemAcctId

	SELECT  @CurrentDate = DATEADD(dd, DATEDIFF(dd, 0, @BusinessDay),0) -- CBR current date with 00:00:00.00 time 
  	SELECT @MonthEndDate= DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @BusinessDay) + 1, 0)) -- CBR month end date  with 00:00:00.00 time 
	--print @CurrentDate
	--print @MonthEndDate
    --PRINT '0'    
    --PRINT @BusinessDay    
    DECLARE @TotalSecond INT = Datediff(second, Cast(@BusinessDay AS DATE), @BusinessDay)

    SELECT @OrgAcctid = acctid
    FROM   dbo.org_balances WITH(nolock)
    WHERE  acctid > 0
           AND arsystemacctid = @iARSystemAcctId

	insert into #TempBsegmentPrimary
	Select BP.Acctid  ,
		accountnumber ,
		AlternateAccount ,
		AmountOfCreditsCTD ,
		AmountOfDebitsCTD ,
		AmountOfPaymentsMTD ,
		amtofaccthighballtd ,
		amtofpaycurrdue ,
		beginningbalance ,
		billingcycle ,
		ccinhparent125aid  ,
		ccinhparent127aid ,
		createdtime ,
		creditlimit ,
		currentbalance ,
		cycleduedtd ,
		DateAcctClosed ,
		DateofLastDebit ,
		dateofnextstmt,
		EnterCollectionDate ,
		institutionid ,
		LastCreditDate ,
		LastNSFPayRevDate ,
		lastreagedate ,
		laststatementdate ,
		nsffeesbillednotpaid ,
		NSFFeesCTD ,
		NumberAccounts ,
		parent02aid ,
		parent05aid ,
		pendingotb ,
		principal ,
		systemstatus ,
		WaiveLateFees ,
		WaiveMembershipFee ,
		WaiveOverlimitFee ,
		WaiveTranFeeNCharOff ,
		BP.SysOrgID ,--CBR 
		  BP.ApplicationID ,--CBR 
		  BP.DateAcctOpened ,--CBR 
		  BP.AmtOfPaymentRevMTD, --CBR    
		  BP.OldAccountNumber,--CBR
		  BB.ReportHistoryCtrCC01,--CBR
		  BB.ReportHistoryCtrCC02,--CBR
		  BB.ReportHistoryCtrCC03,--CBR
		  BB.ReportHistoryCtrCC04,--CBR
		  BB.ReportHistoryCtrCC05,--CBR
		  BB.ReportHistoryCtrCC06,--CBR
		  BB.ReportHistoryCtrCC07,--CBR
		  BB.ReportHistoryCtrCC08,--CBR
		  BB.ReportHistoryCtrCC09,--CBR
		  BB.ReportHistoryCtrCC10,--CBR
		  BB.ReportHistoryCtrCC11,--CBR
		  BB.ReportHistoryCtrCC12,--CBR
		  BB.ReportHistoryCtrCC13,--CBR
		  BB.ReportHistoryCtrCC14,--CBR
		  BB.ReportHistoryCtrCC15,--CBR
		  BB.ReportHistoryCtrCC16,--CBR
		  BB.ReportHistoryCtrCC17,--CBR
		  BB.ReportHistoryCtrCC18,--CBR
		  BB.ReportHistoryCtrCC19,--CBR
		  BB.ReportHistoryCtrCC20,--CBR
		  BB.ReportHistoryCtrCC21,--CBR
		  BB.ReportHistoryCtrCC22,--CBR
		  BB.ReportHistoryCtrCC23,--CBR
		  BB.ReportHistoryCtrCC24,--CBR
		  CASE WHEN 
				((CASE WHEN LAD > LAPD 
					THEN 
						LAD 
					ELSE 
						LAPD 
					END)=LastStatementDate) OR LastStatementDate IS NULL 
				THEN 
					CASE WHEN LAD>LAPD 
						THEN 
							LAD 
						ELSE 
							LAPD 
						END 
				ELSE 
				CASE WHEN DeAcctActivityDate IS NOT NULL  AND 
				(CASE WHEN LAD>LAPD 
					THEN 
						LAD 
					ELSE 
						LAPD 
					END)<DeAcctActivityDate
					THEN 
						DATEAdd(DD,1,DeAcctActivityDate) 
					ELSE 
						CASE WHEN LAD>LAPD 
						THEN 
							LAD 
						ELSE 
							LAPD 
						END 
					END 
			 END AS LAD,
		IntWaiveForSCRA,
		DateAcctOpened,
		LastPmtdate   
	from Bsegment_primary BP with(nolock)  Join BSegment_Balances BB On BP.Acctid = BB.Acctid
	Where institutionid = @OrgAcctid
	--order by institutionid 
	--select * from #TempBsegmentPrimary 

    IF EXISTS((SELECT TOP 1 1
               FROM   dbo.SPExecutionLOg WITH(nolock)
               WHERE  businessday = @BusinessDay
                      AND institutionid = @OrgAcctid))
      BEGIN
          DELETE FROM SPExecutionLOg
          WHERE  institutionid = @OrgAcctid
                 AND BusinessDay = @BusinessDay
      END

    INSERT INTO SPExecutionLOg
    VALUES      ('Usp_extractdataforfutureprojection',
                 Getdate(),
                 NULL,
                 'SpStarted',
                 @BusinessDay,
                 @OrgAcctid)

    /* Commented By Snamdeo    
       IF EXISTS (SELECT 1        
                  FROM   tempdb.dbo.sysobjects        
                  WHERE  id = Object_id(N'tempdb..#AccountInfoForReport')        
                         AND type = 'U')        
         BEGIN        
             DROP TABLE #accountinfoforreport        
         END        
       */
    CREATE TABLE #temp_lastactivitylog
      (
         SKey                      INT IDENTITY(1, 1) PRIMARY KEY,
         acctid                    INT,
         lastactivitydateofbilling DATETIME
      )

    INSERT INTO #temp_lastactivitylog
    SELECT l.acctid,
           Max(l.requestdatetime)
    FROM   dbo.lastactivitylog l WITH(nolock)
           JOIN dbo.#TempBsegmentPrimary b WITH(nolock)
             ON ( l.acctid = b.acctid
                  /*AND b.institutionid = @OrgAcctid*/ )
    WHERE  Skey > 0
    GROUP  BY l.acctid

    ------------------------------------------------Create Temp Table #accountinfoforreport---------------------------------------------        
    CREATE TABLE #accountinfoforreport
      (
         [businessday]                 [DATETIME] NOT NULL,
         [bsacctid]                    [INT] PRIMARY KEY,
         [accountnumber]               [VARCHAR](19) NOT NULL,
         [dateofnextstmt]              [DATETIME] NULL,
         [laststatementdate]           [DATETIME] NULL,
         [currentbalance]              [MONEY] NULL,
         [principal]                   [MONEY] NULL,
         [servicefeesbnp]              [MONEY] NULL,
         [servicechargectd]            [MONEY] NULL,
         [latefeesbnp]                 [MONEY] NULL,
         [latechargesctd]              [MONEY] NULL,
         [amountoftotaldue]            [MONEY] NULL,
         [fixedpaymentamt]             [MONEY] NULL,
         [fixedpaymentpercent]         [MONEY] NULL,
         [paymenttype]                 [VARCHAR](5) NULL,
         [skey]                        [INT] IDENTITY(1, 1),
         [systemstatus]                [INT] NULL,
         [institutionid]               [INT] NULL,
         [productid]                   [INT] NULL,
         [paymentlevel]                [VARCHAR](5) NULL,
         [cycleduedtd]                 [INT] NULL,
         [amtofpaycurrdue]             [MONEY] NULL,
         [nsffeesbillednotpaid]        [MONEY] NULL,
         [ccinhparent125aid]           [INT] NULL,
         [beginningbalance]            [MONEY] NULL,
         [ccinhparent127aid]           [INT] NULL,
         [billingcycle]                [VARCHAR](10) NULL,
         [dateoftotaldue]              [DATETIME] NULL,
         [creditlimit]                 [MONEY] NULL,
         [recoveryfeesbnp]             [MONEY] NULL,
         [recoveryfeesctd]             [MONEY] NULL,
         [lastreagedate]               [DATETIME] NULL,
         [createdtime]                 [DATETIME] NULL,
         [totaloutstgauthamt]          [MONEY] NULL,
         [amtofaccthighballtd]         [MONEY] NULL,
         [pendingotb]                  [MONEY] NULL,
         [merchantid]                  [INT] NULL,
         [lastactivitydateofbilling]   [DATETIME],
         [NSFFeesCTD]                  [MONEY] NULL,
         [MembershipFeesBNP]           [MONEY] NULL,
         [MembershipFeesCTD]           [MONEY] NULL,
         [OverlimitFeesBNP]            [MONEY] NULL,
         [AmtOfOvrLimitFeesCTD]        [MONEY] NULL,
         [CollectionFeesBNP]           [MONEY] NULL,
         [CollectionFeesCTD]           [MONEY] NULL,
         [InsuranceFeesBnp]            [MONEY] NULL,
         [AmtOfPayXDLate]              [MONEY] NULL,
         [AmountOfPayment30DLate]      [MONEY] NULL,
         [AmountOfPayment60DLate]      [MONEY] NULL,
         [AmountOfPayment90DLate]      [MONEY] NULL,
         [AmountOfPayment120DLate]     [MONEY] NULL,
         [AmountOfPayment150DLate]     [MONEY] NULL,
         [AmountOfPayment180DLate]     [MONEY] NULL,
         [AmountOfPayment210DLate]     [MONEY] NULL,
         [DaysDelinquent]              [INT] NULL,
         [TotalDaysDelinquent]         [INT] NULL,
         [DateOfDelinquency]           [DATETIME] NULL,
         [DateOfOriginalPaymentDueDTD] [DATETIME] NULL,
         [LateFeesLTD]                 [MONEY] NULL,
         [ChargeOffDate]               [DATETIME] NULL,
         [CashBalance]                 [MONEY] NULL,
         [EnterCollectionDate]         [DATETIME] NULL,
         [AmountOfDebitsCTD]           [MONEY] NULL,
         [AmountOfCreditsCTD]          [MONEY] NULL,
         [DisputesAmtNS]               [MONEY] NULL,
         [SystemChargeOffStatus]       [VARCHAR](5) NULL,
         [PrePaidAmount]               [MONEY] NULL,
         [WaiveLateFees]               [VARCHAR](5) NULL,
         [WaiveOverlimitFee]           [VARCHAR](5) NULL,
         [WaiveMembershipFee]          [VARCHAR](5) NULL,
         [WaiveTranFeeNCharOff]        [VARCHAR](5) NULL,
         [LastCreditDate]              [DATETIME] NULL,
         [DateofLastDebit]             [DATETIME] NULL,
         [AmtOfInterestYTD]            [MONEY] NULL,
         [LastNSFPayRevDate]           [DATETIME] NULL,
         [AmountOfPaymentsMTD]         [MONEY] NULL,
         [userchargeoffstatus]         [VARCHAR](5) NULL,
         [AlternateAccount]            [VARCHAR](19) NULL,
         [NumberAccounts]              [INT] NULL,
         [FieldTitleTAD1]              [VARCHAR](40) NULL,
         [DateAcctClosed]              [DATETIME] NULL,--Added New Column      
         [RecencyDue]                  [MONEY] NULL,
         [CurrentBalanceCo]            [MONEY] NULL,
		 [OriginalDueDate]				[DATETIME],
		 [DlqOneCpdLtdCount] [INT] NULL, 
		[DlqTwoCpdLtdCount] [INT] NULL, 
		[DlqThreePlusCpdLtdCount] [INT] NULL, 
		[PriEmbActivationFlag] [INT] NULL,
		[AccountStatusChangeDate] [DATETIME] NULL,
		[CreditlimitPrev]   [MONEY] NULL,
		[CLChangeDate]  [DATETIME] NULL,
		StatementRunningBalance MONEY,
		StatementRemainingBalance MONEY,
		[CollateralID] varchar (50) NULL,
		RunningMinimumDue MONEY,
		RemainingMinimumDue MONEY,
		ManualInitialChargeOffReason Varchar(5),
		AutoInitialChargeOffReason Varchar(5),
		ChargeOffDateParam DATETIME,
		LAD DATETIME,
		IntWaiveForSCRA INT,
		DateAcctOpened DATETIME,
		WaiveInterest VARCHAR(1),
		WaiveInterestFor VARCHAR(2),
		WaiveInterestFrom VARCHAR(1),
		BSWFeeIntStartDate DATETIME,
		TestAccount	tinyint
      )

CREATE TABLE #Temp_CLHistory
  (
     RowNumber    INT,
     ClChangeDate DATETIME,
     CLPrevValue  MONEY,
     AcctID       INT
  )

CREATE TABLE #Temp_ASHistory
  (
     RowNumber         INT,
     AStatusChangeDate DATETIME,
     AcctID            INT
  ) 

    ------------------------------------------------Create Temp Table #planinfoforreport---------------------------------------------        
    /* Commented By Snamdeo    
    IF EXISTS (SELECT 1        
               FROM   tempdb.dbo.sysobjects        
               WHERE  id = Object_id(N'tempdb..#PlanInfoForReport')        
                      AND type = 'U')        
      BEGIN        
          DROP TABLE #planinfoforreport        
      END        
    */
    CREATE TABLE #planinfoforreport
      (
         [businessday]             [DATETIME] NOT NULL,
         [cpsacctid]               [INT] PRIMARY KEY,
         [bsacctid]                [INT] NOT NULL,
         [accountnumber]           [VARCHAR](19) NOT NULL,
         [dateofnextstmt]          [DATETIME] NULL,
         [laststatementdate]       [DATETIME] NULL,
         [lad]                     [DATETIME] NULL,
         [plansegcreatedate]       [DATETIME] NULL,
         [lastreagedate]           [DATETIME] NULL,
         [currentbalance]          [MONEY] NULL,
         [principal]               [MONEY] NULL,
         [origequalpmtamt]         [MONEY] NULL,
         [equalpaymentamt]         [MONEY] NULL,
         [servicefeesbnp]          [MONEY] NULL,
         [servicechargectd]        [MONEY] NULL,
         [latefeesbnp]             [MONEY] NULL,
         [latechargesctd]          [MONEY] NULL,
         [amountoftotaldue]        [MONEY] NULL,
         [skey]                    [INT] IDENTITY(1, 1),
         [nextfeedate]             [DATETIME] NULL,
         [nsffeesbillednotpaid]    [MONEY] NULL,
         [systemstatus]            [INT] NULL,
         [ccinhparent125aid]       [INT] NULL,
         [intbillednotpaid]        [MONEY] NULL,
         [amtofinterestctd]        [MONEY] NULL,
         [revolvingbsfc]           [MONEY] NULL,
         [revolvingagg]            [DECIMAL](25,10) NULL,
         [revolvingaccrued]        [DECIMAL](25,10) NULL,
         [newtransactionsbsfc]     [MONEY] NULL,
         [newtranagg]              [DECIMAL](25,10) NULL,
         [newtranaccrued]          [DECIMAL](25,10) NULL,
         [intplanoccurr]           [INT] NULL,
         [beginningbalance]        [MONEY] NULL,
         [intereststartdate]       [DATETIME] NULL,
         [daysincycle]             [INT] NULL,
         [collateralid]            [VARCHAR](50) NULL,
         [cideffectivedate]        [DATETIME] NULL,
         [interestearnednp]        [DECIMAL](19, 8) NULL,
         [currentbalanceco]        [MONEY] NULL,
         [recoveryfeesbnp]         [MONEY] NULL,
         [recoveryfeesctd]         [MONEY] NULL,
         [institutionid]           [INT] NULL,
         [amtofaccthighballtd]     [MONEY],
         [NSFFeesCTD]              [MONEY] NULL,
         [MembershipFeesBNP]       [MONEY] NULL,
         [MembershipFeesCTD]       [MONEY] NULL,
         [OverlimitFeesBNP]        [MONEY] NULL,
         [AmtOfOvrLimitFeesCTD]    [MONEY] NULL,
         [CollectionFeesBNP]       [MONEY] NULL,
         [CollectionFeesCTD]       [MONEY] NULL,
         [InsuranceFeesBnp]        [MONEY] NULL,
         [AmtOfPayCurrDue]         [MONEY] NULL,
         [CycleDueDTD]             [INT] NULL,
         [AmtOfPayXDLate]          [MONEY] NULL,
         [AmountOfPayment30DLate]  [MONEY] NULL,
         [AmountOfPayment60DLate]  [MONEY] NULL,
         [AmountOfPayment90DLate]  [MONEY] NULL,
         [AmountOfPayment120DLate] [MONEY] NULL,
         [AmountOfPayment150DLate] [MONEY] NULL,
         [AmountOfPayment180DLate] [MONEY] NULL,
         [AmountOfPayment210DLate] [MONEY] NULL,
         [DaysDelinquent]          [INT] NULL,
         [DateOfDelinquency]       [DATETIME] NULL,
         [LateFeesLTD]             [MONEY] NULL,
         [LateFeeCreditLTD]        [MONEY] NULL,
         [TotalAccruedInterest]    [MONEY] NULL,
         [AnticipatedInterest]     [MONEY] NULL,
		 GraceDaysStatus Varchar(5),
		 GraceDayCutoffDate DATETIME,
		 [AccountGraceStatus]	   [VARCHAR](2) NULL,
		 [TrailingInterestDate]    [DATETIME] NULL,
		 [ActivityDay]			   [BIT] NULL
      )

    ------------------------------------------------Create Temp Table #planinfoforaccount---------------------------------------------        
    /* Commented By Snamdeo    
    IF EXISTS (SELECT 1        
               FROM   tempdb.dbo.sysobjects        
               WHERE  id = Object_id(N'tempdb..#PlanInfoForAccount')        
                      AND type = 'U')        
      BEGIN        
          DROP TABLE #planinfoforaccount        
      END        
    */
    CREATE TABLE #planinfoforaccount
      (
         [businessday]             [DATETIME] NOT NULL,
         [cpsacctid]               [INT] PRIMARY KEY,
         [bsacctid]                [INT] NOT NULL,
         [accountnumber]           [VARCHAR](19) NOT NULL,
         [dateofnextstmt]          [DATETIME] NULL,
         [laststatementdate]       [DATETIME] NULL,
         [lad]                     [DATETIME] NULL,
         [plansegcreatedate]       [DATETIME] NULL,
         [currentbalance]          [MONEY] NULL,
         [principal]               [MONEY] NULL,
         [equalpaymentamt]         [MONEY] NULL,
         [servicefeesbnp]          [MONEY] NULL,
         [servicechargectd]        [MONEY] NULL,
         [amountoftotaldue]        [MONEY] NULL,
         [skey]                    [INT] IDENTITY(1, 1),
         [latefeesbnp]             [MONEY] NULL,
         [latechargesctd]          [MONEY] NULL,
         [nextfeedate]             [DATETIME] NULL,
         [nsffeesbillednotpaid]    [MONEY] NULL,
         [systemstatus]            [INT] NULL,
         [ccinhparent125aid]       [INT] NULL,
         [intbillednotpaid]        [MONEY] NULL,
         [amtofinterestctd]        [MONEY] NULL,
         [revolvingbsfc]           [MONEY] NULL,
         [revolvingagg]            [MONEY] NULL,
         [revolvingaccrued]        [MONEY] NULL,
         [newtransactionsbsfc]     [MONEY] NULL,
         [newtranagg]              [MONEY] NULL,
         [newtranaccrued]          [MONEY] NULL,
         [intplanoccurr]           [INT] NULL,
         [beginningbalance]        [MONEY] NULL,
         [intereststartdate]       [DATETIME] NULL,
         [daysincycle]             [INT] NULL,
         [collateralid]            [VARCHAR](50) NULL,
         [cideffectivedate]        [DATETIME] NULL,
         [interestearnednp]        [DECIMAL](19, 8) NULL,
         [currentbalanceco]        [MONEY] NULL,
         [recoveryfeesbnp]         [MONEY] NULL,
         [recoveryfeesctd]         [MONEY] NULL,
         [institutionid]           [INT] NULL,
         [amtofaccthighballtd]     [MONEY],
         [NSFFeesCTD]              [MONEY] NULL,
         [MembershipFeesBNP]       [MONEY] NULL,
         [MembershipFeesCTD]       [MONEY] NULL,
         [OverlimitFeesBNP]        [MONEY] NULL,
         [AmtOfOvrLimitFeesCTD]    [MONEY] NULL,
         [CollectionFeesBNP]       [MONEY] NULL,
         [CollectionFeesCTD]       [MONEY] NULL,
         [InsuranceFeesBnp]        [MONEY] NULL,
         [CycleDueDTD]             [INT] NULL,
         [AmtOfPayCurrDue]         [MONEY] NULL,
         [AmtOfPayXDLate]          [MONEY] NULL,
         [AmountOfPayment30DLate]  [MONEY] NULL,
         [AmountOfPayment60DLate]  [MONEY] NULL,
         [AmountOfPayment90DLate]  [MONEY] NULL,
         [AmountOfPayment120DLate] [MONEY] NULL,
         [AmountOfPayment150DLate] [MONEY] NULL,
         [AmountOfPayment180DLate] [MONEY] NULL,
         [AmountOfPayment210DLate] [MONEY] NULL,
         [DaysDelinquent]          [INT] NULL,
         [DateOfDelinquency]       [DATETIME] NULL,
         [LateFeesLTD]             [MONEY] NULL,
         [LateFeeCreditLTD]        [MONEY] NULL,
         [TotalAccruedInterest]    [MONEY] NULL,
         [AnticipatedInterest]     [MONEY] NULL
      )

    ------------------------------------------------Create Temp Table #LoyaltyInfoForReport---------------------------------------------        
    /* Commented By Snamdeo    
    IF EXISTS (SELECT 1        
     FROM   tempdb.dbo.sysobjects        
     WHERE  id = Object_id(N'tempdb..#LoyaltyInfoForReportt')        
      AND type = 'U')        
    BEGIN        
    DROP TABLE #LoyaltyInfoForReport        
    END        
    */
    CREATE TABLE #LoyaltyInfoForReport
      (
         [BusinessDay]              DATETIME,
         [InstitutionID]            INT,
         [BSAcctid]                 DECIMAL(19),
         [LPSAcctid]                DECIMAL(19),
         [LPSProgramID]             DECIMAL(19),
         [Points]                   MONEY,
         [OneLoyaltyPointIsEqualTo] MONEY,
         [skey]                     DECIMAL(19) IDENTITY(1, 1) PRIMARY KEY
      )

  BEGIN
      --PRINT '1'        
      INSERT INTO SPExecutionLOg
      VALUES      ('Usp_extractdataforfutureprojection',
                   Getdate(),
                   NULL,
                   'deleteStarted',
                   @BusinessDay,
                   @OrgAcctid)

      -----------------------------------Delete planinfoforreport for Business Day----------------------------------------------------        
      --Comment by Jinendra        
      IF EXISTS((SELECT TOP 1 1
                 FROM   dbo.planinfoforreport P WITH(nolock)
                        JOIN dbo.accountinfoforreport A WITH(nolock)
                          ON( P.bsacctid = A.bsacctid
                              AND P.businessday = A.businessday )
                 WHERE  P.businessday = @BusinessDay
                        AND A.institutionid IN ( @OrgAcctid )))
        DELETE P
        FROM   dbo.planinfoforreport P
               JOIN dbo.accountinfoforreport A WITH(nolock)
                 ON( P.bsacctid = A.bsacctid
                     AND P.businessday = A.businessday )
        WHERE  P.businessday = @BusinessDay
               AND A.institutionid = @OrgAcctid

      --PRINT '1.1'        
      -----------------------------------Delete planinfoforaccount for Business Day----------------------------------------------------        
      --Comment by Jinendra      
      IF EXISTS((SELECT TOP 1 1
                 FROM   dbo.planinfoforaccount P WITH(nolock)
                        JOIN dbo.accountinfoforreport A WITH(nolock)
                          ON( P.bsacctid = A.bsacctid
                              AND P.businessday = A.businessday )
                 WHERE  P.businessday = @BusinessDay
                        AND A.institutionid IN ( @OrgAcctid )))
        DELETE P
        FROM   dbo.planinfoforaccount P
               JOIN dbo.accountinfoforreport A WITH(nolock)
                 ON( P.bsacctid = A.bsacctid
                     AND P.businessday = A.businessday )
        WHERE  P.businessday = @BusinessDay
               AND A.institutionid = @OrgAcctid

      --PRINT '1.2'        
      -----------------------------------Delete accountinfoforreport for Business Day----------------------------------------------------        
      --Comment by Jinendra      
      IF EXISTS((SELECT TOP 1 1
                 FROM   dbo.accountinfoforreport WITH(nolock)
                 WHERE  businessday = @BusinessDay
                        AND institutionid IN ( @OrgAcctid )))
        DELETE FROM dbo.accountinfoforreport
        WHERE  businessday = @BusinessDay
               AND institutionid = @OrgAcctid

      --PRINT '1.3'        
      -----------------------------------Delete LoyaltyInfoForReport for Business Day----------------------------------------------------        
      --Comment by Jinendra      
      IF EXISTS((SELECT TOP 1 1
                 FROM   dbo.LoyaltyInfoForReport WITH(nolock)
                 WHERE  SKey > 0
                        AND businessday = @BusinessDay
                        AND institutionid IN ( @OrgAcctid )))
        DELETE FROM dbo.LoyaltyInfoForReport
        WHERE  businessday = @BusinessDay
               AND institutionid = @OrgAcctid

      UPDATE SPExecutionLOg
      SET    endtime = Getdate()
      WHERE  operation = 'deleteStarted'
             AND institutionid = @OrgAcctid
             AND BusinessDay = @BusinessDay

      --PRINT '2'      
  /*   snamdeo    
     IF EXISTS (SELECT 1        
                FROM   tempdb.dbo.sysobjects        
                WHERE  id = Object_id(N'tempdb..#CollateralInfo')        
                       AND type = 'U')        
       BEGIN        
           DROP TABLE #collateralinfo        
       END        
   */
      --Created temp table ,,,snamdeo    
      CREATE TABLE #collateralinfo
        (
           SeqID            INT IDENTITY(1, 1),
           RowNumber        INT,
           collateralid     VARCHAR(50),
           cideffectivedate DATETIME,
           cpsid            INT,
		   BSAcctid	INT,
		   Atid			INT
        )

      INSERT INTO SPExecutionLOg
      VALUES      ('Usp_extractdataforfutureprojection',
                   Getdate(),
                   NULL,
                   'Inserttemptablestart',
                   @BusinessDay,
                   @OrgAcctid)

      INSERT INTO #collateralinfo
      SELECT Row_number()
               OVER (
                 partition BY  case  when atid =52  then cpsid else BSAcctid end
                 ORDER BY effectiveenddate DESC) rownumber,
             collateralid,
             cideffectivedate,
             cpsid,
			 BSAcctid,
			 atid
      --INTO   #collateralinfo        
      FROM   dbo.cpscollateralinfo WITH(nolock)
      WHERE  Tranid > 0
             AND cideffectivedate < @BusinessDay
             AND cideffectivedate < effectiveenddate
             AND requestdate < @BusinessDay
             AND institutionid = @OrgAcctid

  /*Commented snamdeo    
    CREATE INDEX idx_collateral        
      ON #collateralinfo (rownumber)        
      include(cpsid, collateralid, cideffectivedate)        
  */
      -----------------------------------Insert into Temp #accountinfoforreport table-----------------------------------------------        
      INSERT INTO #accountinfoforreport
                  (businessday,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   currentbalance,
                   principal,
                   servicefeesbnp,
                   servicechargectd,
                   latefeesbnp,
                   latechargesctd,
                   amountoftotaldue,
                   fixedpaymentamt,
                   fixedpaymentpercent,
                   paymenttype,
                   systemstatus,
                   institutionid,
                   productid,
                   paymentlevel,
                   cycleduedtd,
                   amtofpaycurrdue,
                   nsffeesbillednotpaid,
                   ccinhparent125aid,
                   beginningbalance,
                   ccinhparent127aid,
                   dateoftotaldue,
                   creditlimit,
                   billingcycle,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   lastreagedate,
                   createdtime,
                   totaloutstgauthamt,
                   pendingotb,
                   amtofaccthighballtd,
                   merchantid,
                   lastactivitydateofbilling,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   TotalDaysDelinquent,
                   DateOfDelinquency,
                   DateOfOriginalPaymentDueDTD,
                   LateFeesLTD,
                   ChargeOffDate,
                   CashBalance,
                   EnterCollectionDate,
                   AmountOfDebitsCTD,
                   AmountOfCreditsCTD,
                   DisputesAmtNS,
                   SystemChargeOffStatus,
                   PrePaidAmount,
                   WaiveLateFees,
                   WaiveOverlimitFee,
                   WaiveMembershipFee,
                   WaiveTranFeeNCharOff,
                   LastCreditDate,
                   DateofLastDebit,
                   AmtOfInterestYTD,
                   LastNSFPayRevDate,
                   AmountOfPaymentsMTD,
                   userchargeoffstatus,
                   AlternateAccount,
                   NumberAccounts,
                   FieldTitleTAD1,
                   DateAcctClosed,
                   RecencyDue,
                   CurrentBalanceCo,
				   [OriginalDueDate],
				   DlqOneCpdLtdCount,
				   DlqTwoCpdLtdCount,
				   DlqThreePlusCpdLtdCount,
				   PriEmbActivationFlag, --Added New Column      
				   StatementRunningBalance,
				   StatementRemainingBalance,
				   CollateralID,
				   RunningMinimumDue,
				   RemainingMinimumDue,
				   ManualInitialChargeOffReason,
				   AutoInitialChargeOffReason,
				   ChargeOffDateParam,
				   LAD,
				   IntWaiveForSCRA,
				   DateAcctOpened,
				   WaiveInterest ,
				   WaiveInterestFor ,
				   WaiveInterestFrom ,
				   BSWFeeIntStartDate,
				   TestAccount)
      SELECT @BusinessDay,
             BP.acctid                         bsacctid,
             BP.accountnumber,
             BP.dateofnextstmt,
             Isnull(BP.laststatementdate, CASE
                                            WHEN Datediff(ss, CONVERT(VARCHAR(10), BP.createdtime, 111), BP.createdtime) >= ( @TotalSecond + 1 ) THEN Dateadd(ss, @TotalSecond, CONVERT(VARCHAR(10), BP.createdtime, 111))
                                            ELSE Dateadd(ss, @TotalSecond, Dateadd(d, -1, CONVERT(VARCHAR( 10 ), BP.createdtime, 111)))
                                          END) AS laststatementdate,
             /*Fixed TD#138594*/
             /*DateAdd(SS,86397,CONVERT(VARCHAR(10),DateOfNextStmt,111)) DateOfNextStmt,            
             ISNULL(BP.LastStatementDate, CASE WHEN datediff(ss, CONVERT(VARCHAR(10), CreatedTime, 111), CreatedTime) = 86398            
             THEN DATEADD(ss, -1, CreatedTime)            
             ELSE DATEADD(ss, -3, CONVERT(VARCHAR(10), CreatedTime, 111)) END) LastStatementDate,*/
             BP.currentbalance,
             BP.principal,
             BS.servicefeesbnp,
             BS.servicechargectd,
             BS.latefeesbnp,
             BS.latechargesctd,
             BCC.amountoftotaldue,
             BCC.fixedpaymentamt,
             BCC.fixedpaymentpercent,
             BCC.paymenttype,
             BP.systemstatus,
             BP.institutionid,
             BP.parent02aid,
             Isnull(BCC.paymentlevel, '1')     paymentlevel,
             BP.cycleduedtd,
             BP.amtofpaycurrdue,
             BP.nsffeesbillednotpaid,
             BP.ccinhparent125aid,
             BP.beginningbalance,
             BP.ccinhparent127aid,
             BCC.dateoftotaldue,
             BP.creditlimit,
             BP.billingcycle,
             BS.recoveryfeesbnp,
             BS.recoveryfeesctd,
             BP.lastreagedate,
             BP.createdtime,
             ABP.totaloutstgauthamt,
             Bp.pendingotb,
             BP.amtofaccthighballtd,
             BP.parent05aid                    AS merchantid,
             LA.lastactivitydateofbilling,
             BP.NSFFeesCTD,
             BS.MembershipFeesBNP,
             BS.MembershipFeesCTD,
             BS.overlimitbnp,
             BS.AmtOfOvrLimitFeesCTD,
             BS.CollectionFeesBNP,
             BS.CollectionFeesCTD,
             BI.InsuranceFeesBnp,
             BCC.AmtOfPayXDLate,
             BCC.AmountOfPayment30DLate,
             BCC.AmountOfPayment60DLate,
             BCC.AmountOfPayment90DLate,
             BCC.AmountOfPayment120DLate,
             BCC.AmountOfPayment150DLate,
             BCC.AmountOfPayment180DLate,
             BCC.AmountOfPayment210DLate,
             BCC.DaysDelinquent,
             BCC.NoPayDaysDelinquent,
             BCC.DtOfLastDelinqCTD,
             BCC.DateOfOriginalPaymentDueDTD,
             BS.LateChargesLTD,
             BCC.ChargeOffDateParam,
             BS.CashBalance,
             BP.EnterCollectionDate,
             BP.AmountOfDebitsCTD,
             BP.AmountOfCreditsCTD,
             BS.DisputesAmtNS,
             BCC.SystemChargeOffStatus,
             BCC.PrePaidAmount,
             BP.WaiveLateFees,
             BP.WaiveOverlimitFee,
             BP.WaiveMembershipFee,
             BP.WaiveTranFeeNCharOff,
             BP.LastCreditDate,
             BP.DateofLastDebit,
             BCC.AmtOfInterestYTD,
             BP.LastNSFPayRevDate,
             BP.AmountOfPaymentsMTD,
             BCC.userchargeoffstatus,
             BP.AlternateAccount,
             BP.NumberAccounts,
             BS.FieldTitleTAD1,
             BP.DateAcctClosed,--Added New Column      
             BS.RecencyDue,
             BCC.CurrentBalanceCo,
			 BCC.[OriginalDueDate],
			 Bcc.DlqOneCpdLtdCount,
			 Bcc.DlqTwoCpdLtdCount,
			 Bcc.DlqThreePlusCpdLtdCount,
			 Bcc.PriEmbActivationFlag,  
		     CASE WHEN BCC.StatementRunningBalance <= 0 THEN 0 ELSE BCC.StatementRunningBalance END AS 'StatementRunningBalance',  
		     CASE WHEN BCC.StatementRemainingBalance <= 0 THEN 0 ELSE BCC.StatementRemainingBalance END AS 'StatementRemainingBalance',  
		     CInfo.CollateralID,
			 BCC.RunningMinimumDue,
			 BCC.RemainingMinimumDue,
			 BCC.ManualInitialChargeOffReason,
			 BCC.AutoInitialChargeOffReason,
			 BCC.ChargeOffDateParam,
			 BP.LAD,
			 BP.IntWaiveForSCRA,
			 BP.DateAcctOpened,
			 BCC.WaiveInterest ,
			 BCC.WaiveInterestFor ,
			 BCC.WaiveInterestFrom ,
			 BCC.BSWFeeIntStartDate,
			 BS.TestAccount
      FROM   dbo.#TempBsegmentPrimary BP WITH(nolock)
             LEFT OUTER JOIN dbo.bsegment_secondary BS WITH(nolock)
                          ON ( BP.acctid = BS.acctid )
             -- AND --BP.CurrentBalance > 0 AND --BP.InstitutionID = 1042 AND --BP.SYSTemStatus <> 14 )            
             LEFT OUTER JOIN dbo.bsegmentcreditcard BCC WITH(nolock)
                          ON ( BP.acctid = BCC.acctid )
             LEFT OUTER JOIN dbo.syn_cauth_bsegment_primary ABP WITH(nolock)
                          ON ( BP.acctid = ABP.acctid )
             LEFT JOIN #temp_lastactivitylog LA WITH(nolock)
                    ON ( BP.acctid = LA.acctid )
             LEFT OUTER JOIN dbo.BSegmentInsurance BI WITH(nolock)
                          ON ( BP.Acctid = BI.Acctid )
			 LEFT OUTER JOIN #collateralinfo CInfo WITH(nolock)
                          ON ( BP.acctid = CInfo.BSAcctid
                            AND CInfo.rownumber = 1
                            AND CInfo.SeqID > 0 
							AND CInfo.Atid = 51)
     -- aasati WHERE  BP.institutionid = @OrgAcctid
      ORDER  BY BP.Acctid

	  --Insert Credit Limit change history
	;WITH CLHistory
         AS (SELECT Row_number()
                      OVER (
                        partition BY c.AcctID
                        ORDER BY CLRequestDate DESC ) rownumber,
                    c.CLRequestDate,
                    CLOldValues,
                    C.Acctid
             FROM   CreditLimitAuditLog C WITH(nolock)
                    JOIN #TempBsegmentPrimary bp WITH(nolock)
                      ON c.AcctID = Bp.Acctid
             -- aasati WHERE  InstitutionID = @OrgAcctid
			 )
    INSERT INTO #Temp_CLHistory(RowNumber,ClChangeDate,CLPrevValue,AcctID)
    SELECT *
    FROM   CLHistory
    WHERE  rownumber = 1 
	--Astatus change history
;WITH AsHistory
     AS (SELECT Row_number()
                  OVER (
                    partition BY cba.AID
                    ORDER BY Cba.BusinessDay DESC ) rownumber,
                Cba.BusinessDay,
                bp.Acctid
         FROM   CurrentBalanceAudit cba WITH(nolock)
                JOIN #TempBsegmentPrimary bp WITH(nolock)
                  ON cba.AID = Bp.Acctid
                     AND cba.Atid = 51
                     AND cba.Dename =112
         --aasati WHERE  InstitutionID = @OrgAcctid
		 )
INSERT INTO #Temp_ASHistory(RowNumber, AStatusChangeDate,AcctID)
SELECT *
FROM   AsHistory
WHERE  rownumber = 1 
--set credit limit in temp table
UPDATE a
SET    a.CreditlimitPrev = c.CLPrevValue,
       a.CLChangeDate = c.ClChangeDate
FROM   #accountinfoforreport a
       JOIN #Temp_CLHistory C
         ON a.bsacctid = c.AcctID

--set status change date in temp table
UPDATE a
SET    a.AccountStatusChangeDate = c.AStatusChangeDate
FROM   #accountinfoforreport a
       JOIN #Temp_ASHistory C
         ON a.bsacctid = c.AcctID 

      ---Commented snamdeo    
      CREATE NONCLUSTERED INDEX [RD_NC_BusinessDay_Include_BSAcctidEtc]
        ON #accountinfoforreport ([paymentlevel])
        include ( bsacctid, accountnumber, dateofnextstmt, laststatementdate, systemstatus, institutionid, ccinhparent125aid, lastreagedate, createdtime )

      ----*/        
      -----------------------------------Insert into Temp #planinfoforreport table-----------------------------------------------        
      INSERT INTO #planinfoforreport
                  (businessday,
                   cpsacctid,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   lad,
                   plansegcreatedate,
                   lastreagedate,
                   currentbalance,
                   principal,
                   origequalpmtamt,
                   equalpaymentamt,
                   servicefeesbnp,
                   servicechargectd,
                   latefeesbnp,
                   latechargesctd,
                   amountoftotaldue,
                   nsffeesbillednotpaid,
                   systemstatus,
                   ccinhparent125aid,
                   intbillednotpaid,
                   amtofinterestctd,
                   revolvingbsfc,
                   revolvingagg,
                   revolvingaccrued,
                   newtransactionsbsfc,
                   newtranagg,
                   newtranaccrued,
                   intplanoccurr,
                   beginningbalance,
                   intereststartdate,
                   daysincycle,
                   collateralid,
                   cideffectivedate,
                   interestearnednp,
                   currentbalanceco,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   institutionid,
                   amtofaccthighballtd,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   CycleDueDTD,
                   AmtOfPayCurrDue,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   DateOfDelinquency,
                   LateFeesLTD,
                   LateFeeCreditLTD,
                   TotalAccruedInterest,
                   AnticipatedInterest,
				   GraceDaysStatus,
				   GraceDayCutoffDate,
				   AccountGraceStatus,
				   TrailingInterestDate,
				   ActivityDay)
      SELECT @BusinessDay,
             CA.acctid                         cpsacctid,
             BP.bsacctid                       bsacctid,
             BP.accountnumber,
             BP.dateofnextstmt,
             Isnull(BP.laststatementdate, CASE
                                            WHEN Datediff(ss, CONVERT(VARCHAR(10), createdtime, 111), createdtime) >= ( @TotalSecond + 1 ) THEN Dateadd(ss, @TotalSecond, CONVERT(VARCHAR(10), createdtime, 111))
                                            ELSE Dateadd(ss, @TotalSecond, Dateadd(d, -1, CONVERT(VARCHAR( 10 ), createdtime, 111)))
                                          END) AS laststatementdate,
             /*Fixed TD#138594*/
             /*DateAdd(SS,86397,CONVERT(VARCHAR(10),DateOfNextStmt,111)) DateOfNextStmt,            
             ISNULL(BP.LastStatementDate, CASE WHEN datediff(ss, CONVERT(VARCHAR(10), CreatedTime, 111), CreatedTime) = 86398            
             THEN DATEADD(ss, -1, CreatedTime)            
             ELSE DATEADD(ss, -3, CONVERT(VARCHAR(10), CreatedTime, 111)) END) LastStatementDate,*/
             CASE
               WHEN CA.lad = BP.laststatementdate
                     OR BP.laststatementdate IS NULL THEN CA.lad
               ELSE
                 CASE
                   WHEN CA.deacctactivitydate IS NOT NULL THEN Dateadd(dd, 1, CA.deacctactivitydate)
                   ELSE CA.lad
                 END
             END,
             CA.plansegcreatedate,
             BP.lastreagedate,
             CA.currentbalance,
             CA.principal,
             CC.origequalpmtamt,
             CC.equalpaymentamt,
             CA.servicefeesbnp,
             CA.servicechargectd,
             CA.latefeesbnp,
             CA.latechargesctd,
             CC.amountoftotaldue,
             CA.nsffeesbillednotpaid,
             BP.systemstatus,
             BP.ccinhparent125aid,
             CC.intbillednotpaid,
             CC.amtofinterestctd,
             CC.revolvingbsfc,
             CASE
               WHEN CC.intereststartdate <= CA.lad
                    AND CA.deacctactivitydate < CC.intereststartdate THEN 0
               ELSE CC.revolvingagg
             END,
             CC.revolvingaccrued,
             CC.newtransactionsbsfc,
             CASE
               WHEN CC.intereststartdate <= CA.lad
                    AND CA.deacctactivitydate < CC.intereststartdate THEN 0
               ELSE CC.newtransactionsagg
             END,
             CC.newtransactionsaccrued,
             0,
             CA.beginningbalance,
             CC.intereststartdate,
             CASE
               WHEN CC.intereststartdate IS NULL THEN CA.daysincycle
               ELSE
                 CASE
                   WHEN CC.intereststartdate <= CA.lad
                        AND CA.deacctactivitydate < CC.intereststartdate THEN 0
                   ELSE
                     CASE
                       WHEN CC.intereststartdate < CA.deacctactivitydate
                            AND CC.intereststartdate > BP.laststatementdate THEN Datediff(dd, CC.intereststartdate, CA.deacctactivitydate)
                                                                                 + 1
                       ELSE CA.daysincycle
                     END
                 END
             END                               daysincycle,
             CInfo.collateralid,
             CInfo.cideffectivedate,
             CASE
               WHEN ( CA.currentbalance + CC.currentbalanceco ) <= 0
                    AND CC.interestearnednp <> 0 THEN NULL
               ELSE
                 CASE
                   WHEN CC.interestearnednptd = @BusinessDay THEN CC.interestearnednp
                   ELSE CC.interestearnednp + ( CC.dailyinterestearned * Datediff(dd, CC.interestearnednptd, @BusinessDay) )
                 END
             END                               interestearnednp,
             CC.currentbalanceco,
             CA.recoveryfeesbnp,
             CA.recoveryfeesctd,
             BP.institutionid,
             CA.amtofaccthighballtd,
             CA.NSFFeesCTD,
             CA.MembershipFeesBNP,
             CA.MembershipFeesCTD,
             CA.overlimitbnp,
             CA.AmtOfOvrLimitFeesCTD,
             CA.CollectionFeesBNP,
             CA.CollectionFeesCTD,
             CI.InsuranceFeesBnp,
             CC.CycleDueDTD,
             CC.AmtOfPayCurrDue,
             CC.AmtOfPayXDLate,
             CC.AmountOfPayment30DLate,
             CC.AmountOfPayment60DLate,
             CC.AmountOfPayment90DLate,
             CC.AmountOfPayment120DLate,
             CC.AmountOfPayment150DLate,
             CC.AmountOfPayment180DLate,
             CC.AmountOfPayment210DLate,
             CC.DaysDelinquent,
             CC.DtOfLastDelinqCTD,
             CA.LateChargesLTD,
             CC.LateFeeCreditLTD,
             CC.TotalAccruedInterest,
             CC.AnticipatedInterest,
			 CC.GraceDaysStatus,
			 CC.GraceDayCutoffDate,
			 CASE WHEN CC.AccountGraceStatus IS NULL OR ltrim(rtrim(CC.AccountGraceStatus)) = '' THEN 'T' ELSE CC.AccountGraceStatus END,
			 CC.TrailingInterestDate,
			 CASE WHEN BP.TestAccount = 1 THEN 0
			 WHEN DATEDIFF(DAY,BP.LAD,BP.BusinessDay) = 0 
			 THEN CASE WHEN CC.newtransactionsbsfc > 0 THEN 1
					   WHEN CC.revolvingbsfc > 0 THEN 1
					   WHEN CC.revolvingbsfc > 0 THEN 1 
					   WHEN CC.newtransactionsagg > 0 THEN 1
					   WHEN CC.revolvingagg > 0 THEN 1 
					   WHEN CC.newtransactionsaccrued > 0 THEN 1
					   WHEN CC.revolvingaccrued > 0 THEN 1
					   WHEN CA.beginningbalance > 0 THEN 1
					   WHEN CA.CurrentBalance > 0 THEN 1
				  ELSE 0 END
			ELSE 0 END AS ActivityDay
      FROM   dbo.cpsgmentaccounts CA WITH(nolock)
             LEFT OUTER JOIN dbo.cpsgmentcreditcard CC WITH(nolock)
                          ON ( CA.acctid = CC.acctid )
             LEFT OUTER JOIN CPSgmentInsurance CI WITH(nolock)
                          ON ( CA.acctId = CI.acctId )
             JOIN #accountinfoforreport BP WITH(nolock)
               ON ( CA.parent02aid = BP.bsacctid )
             LEFT OUTER JOIN #collateralinfo CInfo WITH(nolock)
                          ON ( CInfo.cpsid = CA.acctid
                               AND CInfo.rownumber = 1
                               AND CInfo.SeqID > 0 
							   AND CInfo.Atid = 52)
      WHERE  BP.paymentlevel = '1' --IsNull(BS.PaymentLevel,1) <> 0        
      --     PRINT '3'           
  /*    
  CREATE NONCLUSTERED INDEX [CPSRecordPlan_Acctid]        
    ON #planinfoforreport ( cpsacctid )        
  */
      -----------------------------------Insert into Temp #planinfoforaccount table-----------------------------------------------        
      --PRINT '4'           
      INSERT INTO #planinfoforaccount
                  (businessday,
                   cpsacctid,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   lad,
                   plansegcreatedate,
                   currentbalance,
                   principal,
                   equalpaymentamt,
                   servicefeesbnp,
                   servicechargectd,
                   amountoftotaldue,
                   latefeesbnp,
                   latechargesctd,
                   nsffeesbillednotpaid,
                   systemstatus,
                   ccinhparent125aid,
                   intbillednotpaid,
                   amtofinterestctd,
                   revolvingbsfc,
                   revolvingagg,
                   revolvingaccrued,
                   newtransactionsbsfc,
                   newtranagg,
                   newtranaccrued,
                   intplanoccurr,
                   beginningbalance,
                   intereststartdate,
                   daysincycle,
                   collateralid,
                   cideffectivedate,
                   interestearnednp,
                   currentbalanceco,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   institutionid,
                   amtofaccthighballtd,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   CycleDueDTD,
                   AmtOfPayCurrDue,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   DateOfDelinquency,
                   LateFeesLTD,
                   LateFeeCreditLTD,
                   TotalAccruedInterest,
                   AnticipatedInterest)
      SELECT @BusinessDay,
             CA.acctid cpsacctid,
             AIR.bsacctid,
             AIR.accountnumber,
             AIR.dateofnextstmt,
             AIR.laststatementdate,
             CASE
               WHEN CA.lad = AIR.laststatementdate
                     OR AIR.laststatementdate IS NULL THEN CA.lad
               ELSE
                 CASE
                   WHEN CA.deacctactivitydate IS NOT NULL THEN Dateadd(dd, 1, CA.deacctactivitydate)
                   ELSE CA.lad
                 END
             END,
             CA.plansegcreatedate,
             CA.currentbalance,
             CA.principal,
             CC.equalpaymentamt,
             CA.servicefeesbnp,
             CA.servicechargectd,
             CC.amountoftotaldue,
             CA.latefeesbnp,
             CA.latechargesctd,
             CA.nsffeesbillednotpaid,
             AIR.systemstatus,
             AIR.ccinhparent125aid,
             CC.intbillednotpaid,
             CC.amtofinterestctd,
             CC.revolvingbsfc,
             CASE
               WHEN CC.intereststartdate <= CA.lad
                    AND CA.deacctactivitydate < CC.intereststartdate THEN 0
               ELSE CC.revolvingagg
             END,
             CC.revolvingaccrued,
             CC.newtransactionsbsfc,
             CASE
               WHEN CC.intereststartdate <= CA.lad
                    AND CA.deacctactivitydate < CC.intereststartdate THEN 0
               ELSE CC.newtransactionsagg
             END,
             CC.newtransactionsaccrued,
             0,
             CA.beginningbalance,
             CC.intereststartdate,
             CASE
               WHEN CC.intereststartdate IS NULL THEN CA.daysincycle
               ELSE
                 CASE
                   WHEN CC.intereststartdate <= CA.lad
                        AND CA.deacctactivitydate < CC.intereststartdate THEN 0
                   ELSE
                     CASE
                       WHEN CC.intereststartdate < CA.deacctactivitydate
                            AND CC.intereststartdate > AIR.laststatementdate THEN Datediff(dd, CC.intereststartdate, CA.deacctactivitydate)
                                                                                  + 1
                       ELSE CA.daysincycle
                     END
                 END
             END       daysincycle,
             CInfo.collateralid,
             CInfo.cideffectivedate,
             CASE
               WHEN ( CA.currentbalance + CC.currentbalanceco ) <= 0
                    AND CC.interestearnednp <> 0 THEN NULL
               ELSE
                 CASE
                   WHEN CC.interestearnednptd = @BusinessDay THEN CC.interestearnednp
                   ELSE CC.interestearnednp + ( CC.dailyinterestearned * Datediff(dd, CC.interestearnednptd, @BusinessDay) )
                 END
             END       interestearnednp,
             CC.currentbalanceco,
             CA.recoveryfeesbnp,
             CA.recoveryfeesctd,
             AIR.institutionid,
             CA.amtofaccthighballtd,
             CA.NSFFeesCTD,
             CA.MembershipFeesBNP,
             CA.MembershipFeesCTD,
             CA.overlimitbnp,
             CA.AmtOfOvrLimitFeesCTD,
             CA.CollectionFeesBNP,
             CA.CollectionFeesCTD,
             CI.InsuranceFeesBnp,
             CC.CycleDueDTD,
             CC.AmtOfPayCurrDue,
             CC.AmtOfPayXDLate,
             CC.AmountOfPayment30DLate,
             CC.AmountOfPayment60DLate,
             CC.AmountOfPayment90DLate,
             CC.AmountOfPayment120DLate,
             CC.AmountOfPayment150DLate,
             CC.AmountOfPayment180DLate,
             CC.AmountOfPayment210DLate,
             CC.DaysDelinquent,
             CC.DtOfLastDelinqCTD,
             CA.LateChargesLTD,
             CC.LateFeeCreditLTD,
             CC.TotalAccruedInterest,
             CC.AnticipatedInterest
      FROM   dbo.cpsgmentaccounts CA WITH(nolock)
             LEFT OUTER JOIN dbo.cpsgmentcreditcard CC WITH(nolock)
                          ON ( CA.acctid = CC.acctid ) --AND --CA.CurrentBalance > 0            
             LEFT OUTER JOIN CPSgmentInsurance CI WITH(nolock)
                          ON ( CA.acctId = CI.acctId )
             LEFT OUTER JOIN #collateralinfo CInfo WITH(nolock)
                          ON ( CInfo.cpsid = CA.acctid
                               AND CInfo.rownumber = 1
                               AND CInfo.SeqID > 0
							   AND CInfo.Atid = 52)
             JOIN #accountinfoforreport AIR WITH(nolock)
               ON ( CA.parent02aid = AIR.bsacctid
                    AND AIR.paymentlevel = '0' )

      --PRINT '5'      
  /* Commented snamdeo      
     CREATE NONCLUSTERED INDEX [CPSRecordAccount_Acctid]        
       ON #planinfoforaccount ( cpsacctid )        
       
     CREATE NONCLUSTERED INDEX [RD_NC_PlanInfoForAccount_BusinessDay_Includes]        
       ON #planinfoforaccount ( [businessday] ASC )        
       include ( [CPSAcctid], [BSAcctid], [AccountNumber], [DateOfNextStmt],        
     [LastStatementDate], [LAD], [PlanSegCreateDate], [CurrentBalance],        
     [Principal], [EqualPaymentAmt], [ServiceFeesBNP], [ServiceChargeCTD],        
     [AmountOfTotalDue], [SKey], [LateFeesBNP], [LateChargesCTD], [NextFeeDate]        
     ,        
     [NSFFeesBilledNotPaid], [SystemStatus], [ccinhparent125AID])        
       
     CREATE NONCLUSTERED INDEX [RD_NC_PlanInfoForReport_BusinessDay_Includes]        
       ON #planinfoforreport ( [businessday] ASC )        
       include ( [CPSAcctid], [BSAcctid], [AccountNumber], [DateOfNextStmt],        
     [LastStatementDate], [LAD], [PlanSegCreateDate], [LastReageDate],        
     [CurrentBalance], [Principal], [OrigEqualPmtAmt], [EqualPaymentAmt],        
     [ServiceFeesBNP], [ServiceChargeCTD], [LateFeesBNP], [LateChargesCTD],        
     [AmountOfTotalDue], [SKey], [NextFeeDate], [NSFFeesBilledNotPaid],        
     [SystemStatus], [ccinhparent125AID])        
   */
      -----------------------------------Insert into Temp #RecurringRecordAccount table-----------------------------------------------        
  /* Commented snamdeo    
      IF EXISTS (SELECT 1        
                 FROM   tempdb.dbo.sysobjects        
                 WHERE  id = Object_id(N'tempdb..#RecurringRecordAccount')        
                        AND type = 'U')        
        BEGIN        
            DROP TABLE #recurringrecordaccount        
        END        
    */
      --PRINT '6'      
      --snamdeo,,created new temp table instead of into command    
      CREATE TABLE #recurringrecordaccount
        (
           SeqID       INT IDENTITY(1, 1),
           RowNum      INT,
           cpsacctid   INT,
           nextfeedate DATETIME
        )

      INSERT INTO #recurringrecordaccount
      SELECT Row_number()
               OVER (
                 partition BY RF.txnacctid
                 ORDER BY RF.nextfeedate) rownum,
             C.cpsacctid,
             RF.nextfeedate
      --INTO   #recurringrecordaccount        
      FROM   dbo.recurringfeerecord RF WITH(nolock)
             JOIN dbo.feeforscaccounts FFS WITH(nolock)
               ON( RF.feesacctid = FFS.acctid
                   AND RF.status = 'OPEN'
                   AND RF.nextfeedate >= @BusinessDay )
             JOIN syn_kbcl_feescatalogaccounts FC WITH(nolock)
               ON( FFS.parent02aid = FC.acctid )
             JOIN #planinfoforaccount C WITH(nolock)
               ON( C.cpsacctid = RF.txnacctid )

      -- and C.BusinessDay=@BusinessDay and C.InstitutionID=@OrgAcctid)          
      /* Commented snamdeo    
      CREATE NONCLUSTERED INDEX [Idx_Recurring_Account]        
        ON #recurringrecordaccount ( rownum )        
        include (cpsacctid, nextfeedate)        
      */
      UPDATE c
      SET    c.nextfeedate = RF.nextfeedate
      FROM   #planinfoforaccount C
             JOIN #recurringrecordaccount RF WITH(nolock)
               ON( C.cpsacctid = RF.cpsacctid
                   AND RF.rownum = 1
                   AND C.businessday = @BusinessDay
                   AND RF.SeqID > 0 )

      -----------------------------------Insert into Temp #recurringrecordplan table-----------------------------------------------        
      --PRINT '7'    
  /*          
  IF EXISTS (SELECT 1        
                FROM   tempdb.dbo.sysobjects        
                WHERE  id = Object_id(N'tempdb..#RecurringRecordPlan')        
                       AND type = 'U')        
       BEGIN        
           DROP TABLE #recurringrecordplan        
       END        
   */
      --snamdeo,,, created new temp table instead of into command    
      CREATE TABLE #recurringrecordplan
        (
           RowNum      INT ,
           cpsacctid   INT,
           nextfeedate DATETIME
		   Primary Key Clustered (RowNum,cpsacctid)
        )

      INSERT INTO #recurringrecordplan
      SELECT Row_number()
               OVER (
                 partition BY RF.txnacctid
                 ORDER BY RF.nextfeedate) rownum,
             C.cpsacctid,
             RF.nextfeedate
      --INTO   #recurringrecordplan        
      FROM   dbo.recurringfeerecord RF WITH(nolock)
             JOIN dbo.feeforscaccounts FFS WITH(nolock)
               ON( RF.feesacctid = FFS.acctid
                   AND RF.[status] = 'OPEN'
                   AND RF.nextfeedate >= @BusinessDay )
             JOIN syn_kbcl_feescatalogaccounts FC WITH(nolock)
               ON( FFS.parent02aid = FC.acctid )
             JOIN #planinfoforreport C WITH(nolock)
               ON( C.cpsacctid = RF.txnacctid )

      -- and C.BusinessDay=@BusinessDay and C.InstitutionID=@OrgAcctid)          
  /* Commented snamdeo    
  CREATE NONCLUSTERED INDEX [Idx_Recurring_Plan]        
  ON #recurringrecordplan ( rownum )        
    include (cpsacctid, nextfeedate)        
  */
      --PRINT '8'           
      --SELECT *             
      UPDATE c
      SET    c.nextfeedate = RF.nextfeedate
      FROM   #planinfoforreport C
             JOIN #recurringrecordplan RF WITH(nolock)
               ON( C.cpsacctid = RF.cpsacctid
                   AND RF.rownum = 1
                   AND C.businessday = @BusinessDay )

      --DROP TABLE #OrgInfo     
      -----------------------------------Insert into Temp #LoyaltyInfoForReport table-----------------------------------------------        
      INSERT INTO #LoyaltyInfoForReport
                  (BusinessDay,
                   InstitutionID,
                   BSAcctid,
                   LPSAcctid,
                   LPSProgramID,
                   Points,
                   OneLoyaltyPointIsEqualTo)
      SELECT @BusinessDay,
             BP.InstitutionID,
             BP.AcctID,
             LPS.AcctID,
             LP.AcctID,
             LPS.de_LtyPrgSeg_CurrentBalance,
             LP.mPPOneLoyaltyPointIsEqualTo
      FROM   LPSEGMENTACCOUNTS LPS WITH(NOLOCK)
             INNER JOIN #TempBsegmentPrimary BP WITH(NOLOCK)
                     ON BP.AcctID = LPS.Parent02AID
                        -- aasati AND BP.InstitutionID = @OrgAcctid
             LEFT JOIN LPACCOUNTS LP WITH(NOLOCK)
                    ON LPS.Parent01AID = LP.AcctID

      --PRINT '9'      
      UPDATE SPExecutionLOg
      SET    endtime = Getdate()
      WHERE  operation = 'Inserttemptablestart'
             AND institutionid = @OrgAcctid
             AND BusinessDay = @BusinessDay

      --------------------------------------------Update Due Buckets from StatementHeader if BusinessDay = StatementDate.Ref TD 177303------------------------------------------------    
      INSERT INTO SPExecutionLOg
      VALUES      ('Usp_extractdataforfutureprojection',
                   Getdate(),
                   NULL,
                   'update_Temptable',
                   @BusinessDay,
                   @OrgAcctid)

      UPDATE AIR
      SET    AIR.DateOfDelinquency = SE.DtOfLastDelinqCTD,
			 AIR.AmtOfPayCurrDue = SH.AmtOfPayCurrDue,
             AIR.AmtOfPayXDLate = SH.AmtOfPayXDLate,
             AIR.AmountOfPayment30DLate = SH.AmountOfPayment30DLate,
             AIR.AmountOfPayment60DLate = SH.AmountOfPayment60DLate,
             AIR.AmountOfPayment90DLate = SH.AmountOfPayment90DLate,
             AIR.AmountOfPayment120DLate = SH.AmountOfPayment120DLate,
             AIR.AmountOfPayment150DLate = SH.AmountOfPayment150DLate,
             AIR.AmountOfPayment180DLate = SH.AmountOfPayment180DLate,
             AIR.AmountOfPayment210DLate = SH.AmountOfPayment210DLate
      FROM   #AccountInfoForReport AIR
             JOIN StatementHeader SH WITH(NOLOCK)
               ON ( AIR.LastStatementDate = @BusinessDay
                    AND AIR.BSAcctid = SH.acctId
                    AND SH.StatementDate = @BusinessDay )
             JOIN BSegmentCreditCard BC WITH(NOLOCK)
               ON ( AIR.LastStatementDate = @BusinessDay
                    AND AIR.BSAcctid = BC.acctId)
			JOIN StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)

      UPDATE PIR
      SET    PIR.AmtOfPayCurrDue = SHCC.CurrentDue,
             PIR.AmtOfPayXDLate = SHCC.AmtOfPayXDLate,
             PIR.AmountOfPayment30DLate = SHCC.AmountOfPayment30DLate,
             PIR.AmountOfPayment60DLate = SHCC.AmountOfPayment60DLate,
             PIR.AmountOfPayment90DLate = SHCC.AmountOfPayment90DLate,
             PIR.AmountOfPayment120DLate = SHCC.AmountOfPayment120DLate,
             PIR.AmountOfPayment150DLate = SHCC.AmountOfPayment150DLate,
             PIR.AmountOfPayment180DLate = SHCC.AmountOfPayment180DLate,
             PIR.AmountOfPayment210DLate = SHCC.AmountOfPayment210DLate
      FROM   #PlanInfoForReport PIR
             JOIN SummaryHeader SH WITH(NOLOCK)
               ON ( PIR.LastStatementDate = @BusinessDay
                    AND PIR.CPSAcctid = SH.acctId
                    AND SH.StatementDate = @BusinessDay )
             JOIN SummaryHeaderCreditCard SHCC WITH(NOLOCK)
               ON ( SH.acctId = SHCC.acctId
                    AND SH.StatementID = SHCC.StatementID )

      UPDATE PIA
      SET    PIA.AmtOfPayCurrDue = SHCC.CurrentDue,
             PIA.AmtOfPayXDLate = SHCC.AmtOfPayXDLate,
             PIA.AmountOfPayment30DLate = SHCC.AmountOfPayment30DLate,
             PIA.AmountOfPayment60DLate = SHCC.AmountOfPayment60DLate,
             PIA.AmountOfPayment90DLate = SHCC.AmountOfPayment90DLate,
             PIA.AmountOfPayment120DLate = SHCC.AmountOfPayment120DLate,
             PIA.AmountOfPayment150DLate = SHCC.AmountOfPayment150DLate,
             PIA.AmountOfPayment180DLate = SHCC.AmountOfPayment180DLate,
             PIA.AmountOfPayment210DLate = SHCC.AmountOfPayment210DLate
      FROM   #PlanInfoForAccount PIA
             JOIN SummaryHeader SH WITH(NOLOCK)
               ON ( PIA.LastStatementDate = @BusinessDay
                    AND PIA.CPSAcctid = SH.acctId
                    AND SH.StatementDate = @BusinessDay )
             JOIN SummaryHeaderCreditCard SHCC WITH(NOLOCK)
               ON ( SH.acctId = SHCC.acctId
                    AND SH.StatementID = SHCC.StatementID )

      UPDATE SPExecutionLOg
      SET    endtime = Getdate()
      WHERE  operation = 'update_Temptable'
             AND institutionid = @OrgAcctid
             AND BusinessDay = @BusinessDay

      -----------------------------------Code For Making Chunk-------------------------------------------------------------------------    
      /*    
      SELECT @RecordCount=Count(1) FROM #accountinfoforreport WITH(NOLOCK) WHERE SKey>@LastChunk AND SKey<=@LastChunk+@ChunkSize    
      SELECT @MinAcctid=Min(bsacctid),@MaxAcctid=Max(bsacctid),@LastChunk=Max(SKey) FROM #accountinfoforreport WITH(NOLOCK) WHERE bsacctid>@MaxAcctid AND SKey<=@LastChunk+@ChunkSize    
      */
      DECLARE @iCounter   INT = 0,
              @MidCounter INT = 0

      SELECT @RecordCount = Count(1)
      FROM   #accountinfoforreport WITH(NOLOCK)
      WHERE  bsacctid > 0

      INSERT INTO SPExecutionLOg
      VALUES      ('Usp_extractdataforfutureprojection',
                   Getdate(),
                   NULL,
                   'chunkinsert',
                   @BusinessDay,
                   @OrgAcctid)

      IF @ChunkSize > @RecordCount
        SET @MidCounter = @RecordCount
      ELSE
        SET @MidCounter = @iCounter + @ChunkSize

      --print '@RecordCount = ' + cast (@RecordCount as varchar)   
      WHILE @iCounter <= @RecordCount
        BEGIN
            -----------------------------------Insert into Physical table accountinfoforreport-----------------------------------------------          
            SELECT @MinAcctid = bsacctid
            FROM   #accountinfoforreport WITH(NOLOCK)
            WHERE  SKey = @iCounter + 1

            SELECT @MaxAcctid = bsacctid
            FROM   #accountinfoforreport WITH(NOLOCK)
            WHERE  SKey = @MidCounter

            --print 'From @iCounter -  ' + cast (@iCounter as varchar)+  ' To ' + cast (@MidCounter as varchar)    
            --print 'From @MinAcctid - ' + cast (@MinAcctid as varchar)+ ' To ' + cast (@MaxAcctid as varchar)    
            IF @MidCounter = @RecordCount
              SET @iCounter = @RecordCount + 1 -- Terminate here    
            ELSE
              BEGIN
                  SET @iCounter = @iCounter + @ChunkSize
                  SET @MidCounter = @iCounter + @ChunkSize
              END

            IF @MidCounter > @RecordCount
              SET @MidCounter = @MidCounter - ( @MidCounter - @RecordCount )

            INSERT INTO accountinfoforreport
                        (businessday,
                         bsacctid,
                         accountnumber,
                         dateofnextstmt,
                         laststatementdate,
                         currentbalance,
                         principal,
                         servicefeesbnp,
                         servicechargectd,
                         latefeesbnp,
                         latechargesctd,
                         amountoftotaldue,
                         fixedpaymentamt,
                         fixedpaymentpercent,
                         paymenttype,
                         systemstatus,
                         institutionid,
                         productid,
                         paymentlevel,
                         cycleduedtd,
                         amtofpaycurrdue,
                         nsffeesbillednotpaid,
                         ccinhparent125aid,
                         beginningbalance,
                         ccinhparent127aid,
                         dateoftotaldue,
                         creditlimit,
                         billingcycle,
                         recoveryfeesbnp,
                         recoveryfeesctd,
                         totaloutstgauthamt,
                         amtofaccthighballtd,
                         merchantid,
                         LastActivityDateOfBilling,
                         NSFFeesCTD,
                         MembershipFeesBNP,
                         MembershipFeesCTD,
                         OverlimitFeesBNP,
                         AmtOfOvrLimitFeesCTD,
                         CollectionFeesBNP,
                         CollectionFeesCTD,
                         InsuranceFeesBnp,
                         AmtOfPayXDLate,
                         AmountOfPayment30DLate,
                         AmountOfPayment60DLate,
                         AmountOfPayment90DLate,
                         AmountOfPayment120DLate,
                         AmountOfPayment150DLate,
                         AmountOfPayment180DLate,
                         AmountOfPayment210DLate,
                         DaysDelinquent,
                         TotalDaysDelinquent,
                         DateOfDelinquency,
                         DateOfOriginalPaymentDueDTD,
                         LateFeesLTD,
                         ChargeOffDate,
                         CashBalance,
                         EnterCollectionDate,
                         AmountOfDebitsCTD,
                         AmountOfCreditsCTD,
                         DisputesAmtNS,
                         SystemChargeOffStatus,
                         PrePaidAmount,
                         WaiveLateFees,
                         WaiveOverlimitFee,
                         WaiveMembershipFee,
                         WaiveTranFeeNCharOff,
                         LastCreditDate,
                         DateofLastDebit,
                         AmtOfInterestYTD,
                         LastNSFPayRevDate,
                         AmountOfPaymentsMTD,
                         userchargeoffstatus,
                         AlternateAccount,
                         NumberAccounts,
                         FieldTitleTAD1,
                         DateAcctClosed,--Added New Column      
                         RecencyDue,
                         CurrentBalanceCo,
						 [OriginalDueDate],
						[DlqOneCpdLtdCount] ,
						[DlqTwoCpdLtdCount] ,
						[DlqThreePlusCpdLtdCount],
						[PriEmbActivationFlag] ,
						[AccountStatusChangeDate],
						[CreditlimitPrev]  ,
						[CLChangeDate],
						StatementRunningBalance,
						StatementRemainingBalance,
						CollateralID,
						RunningMinimumDue,
						RemainingMinimumDue,
						ManualInitialChargeOffReason,
						AutoInitialChargeOffReason,
						ChargeOffDateParam,
						LAD,
						IntWaiveForSCRA,
						DateAcctOpened,
						WaiveInterest ,
						WaiveInterestFor ,
						WaiveInterestFrom ,
						BSWFeeIntStartDate)
            SELECT businessday,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   currentbalance,
                   principal,
                   servicefeesbnp,
                   servicechargectd,
                   latefeesbnp,
                   latechargesctd,
                   amountoftotaldue,
                   fixedpaymentamt,
                   fixedpaymentpercent,
                   paymenttype,
                   systemstatus,
                   institutionid,
                   productid,
                   paymentlevel,
                   cycleduedtd,
                   amtofpaycurrdue,
                   nsffeesbillednotpaid,
                   ccinhparent125aid,
                   beginningbalance,
                   ccinhparent127aid,
                   dateoftotaldue,
                   creditlimit,
                   billingcycle,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   totaloutstgauthamt,
                   amtofaccthighballtd,
                   merchantid,
                   LastActivityDateOfBilling,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   TotalDaysDelinquent,
                   DateOfDelinquency,
                   DateOfOriginalPaymentDueDTD,
                   LateFeesLTD,
                   ChargeOffDate,
                   CashBalance,
                   EnterCollectionDate,
                   AmountOfDebitsCTD,
                   AmountOfCreditsCTD,
                   DisputesAmtNS,
                   SystemChargeOffStatus,
                   PrePaidAmount,
                   WaiveLateFees,
                   WaiveOverlimitFee,
                   WaiveMembershipFee,
                   WaiveTranFeeNCharOff,
                   LastCreditDate,
                   DateofLastDebit,
                   AmtOfInterestYTD,
                   LastNSFPayRevDate,
                   AmountOfPaymentsMTD,
                   userchargeoffstatus,
                   AlternateAccount,
                   NumberAccounts,
                   FieldTitleTAD1,
                   DateAcctClosed,--Added New Column      
                   RecencyDue,
                   CurrentBalanceCo,
				   [OriginalDueDate],
				   [DlqOneCpdLtdCount] ,
					[DlqTwoCpdLtdCount] ,
					[DlqThreePlusCpdLtdCount],
					[PriEmbActivationFlag] ,
					[AccountStatusChangeDate],
					[CreditlimitPrev]  ,
					[CLChangeDate],
					StatementRunningBalance,
					StatementRemainingBalance,
					CollateralID,
					RunningMinimumDue,
					RemainingMinimumDue,
					ManualInitialChargeOffReason,
					AutoInitialChargeOffReason,
					ChargeOffDateParam,
					LAD,
					IntWaiveForSCRA,
					DateAcctOpened,
					WaiveInterest ,
					WaiveInterestFor ,
					WaiveInterestFrom ,
					BSWFeeIntStartDate
            FROM   #accountinfoforreport
            WHERE  bsacctid >= @MinAcctid
                   AND bsacctid <= @MaxAcctid
			SET @AccountInfoCount = @AccountInfoCount + @@ROWCOUNT
            --PRINT '10'            
            -----------------------------------Insert into Physical table planinfoforreport-----------------------------------------------        
            INSERT INTO planinfoforreport 
                        (businessday,
                         cpsacctid,
                         bsacctid,
                         accountnumber,
                         dateofnextstmt,
                         laststatementdate,
                         lad,
                         plansegcreatedate,
                         lastreagedate,
                         currentbalance,
                         principal,
                         origequalpmtamt,
                         equalpaymentamt,
                         servicefeesbnp,
                         servicechargectd,
                         latefeesbnp,
                         latechargesctd,
                         amountoftotaldue,
                         nsffeesbillednotpaid,
                         systemstatus,
                         ccinhparent125aid,
                         intbillednotpaid,
                         amtofinterestctd,
                         revolvingbsfc,
                         revolvingagg,
                         revolvingaccrued,
                         newtransactionsbsfc,
                         newtranagg,
                         newtranaccrued,
                         intplanoccurr,
                         beginningbalance,
                         intereststartdate,
                         daysincycle,
                         collateralid,
                         cideffectivedate,
                         interestearnednp,
                         currentbalanceco,
                         amtofaccthighballtd,
                         recoveryfeesbnp,
                         recoveryfeesctd,
                         NSFFeesCTD,
                         MembershipFeesBNP,
                         MembershipFeesCTD,
                         OverlimitFeesBNP,
                         AmtOfOvrLimitFeesCTD,
                         CollectionFeesBNP,
                         CollectionFeesCTD,
                         InsuranceFeesBnp,
                         CycleDueDTD,
                         AmtOfPayCurrDue,
                         AmtOfPayXDLate,
                         AmountOfPayment30DLate,
                         AmountOfPayment60DLate,
                         AmountOfPayment90DLate,
                         AmountOfPayment120DLate,
                         AmountOfPayment150DLate,
                         AmountOfPayment180DLate,
                         AmountOfPayment210DLate,
                         DaysDelinquent,
                         DateOfDelinquency,
                         LateFeesLTD,
                         LateFeeCreditLTD,
                         TotalAccruedInterest,
                         AnticipatedInterest,
						 GraceDaysStatus,
						 GraceDayCutoffDate,
						 AccountGraceStatus,
						 TrailingInterestDate,
						 ActivityDay)
            SELECT businessday,
                   cpsacctid,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   lad,
                   plansegcreatedate,
                   lastreagedate,
                   currentbalance,
                   principal,
                   origequalpmtamt,
                   equalpaymentamt,
                   servicefeesbnp,
                   servicechargectd,
                   latefeesbnp,
                   latechargesctd,
                   amountoftotaldue,
                   nsffeesbillednotpaid,
                   systemstatus,
                   ccinhparent125aid,
                   intbillednotpaid,
                   amtofinterestctd,
                   revolvingbsfc,
                   revolvingagg,
                   revolvingaccrued,
                   newtransactionsbsfc,
                   newtranagg,
                   newtranaccrued,
                   intplanoccurr,
                   beginningbalance,
                   intereststartdate,
                   daysincycle,
                   collateralid,
                   cideffectivedate,
                   interestearnednp,
                   currentbalanceco,
                   amtofaccthighballtd,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   CycleDueDTD,
                   AmtOfPayCurrDue,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   DateOfDelinquency,
                   LateFeesLTD,
                   LateFeeCreditLTD,
                   TotalAccruedInterest,
                   AnticipatedInterest,
				   GraceDaysStatus,
				   GraceDayCutoffDate,
				   AccountGraceStatus,
				   TrailingInterestDate,
				   ActivityDay
            FROM   #planinfoforreport
            WHERE  bsacctid >= @MinAcctid
                   AND bsacctid <= @MaxAcctid
			
			SET @PlanInfoCount = @PlanInfoCount + @@ROWCOUNT

            --PRINT '11'         
            -----------------------------------Insert into Physical table planinfoforaccount-----------------------------------------------          
            INSERT INTO planinfoforaccount
                        (businessday,
                         cpsacctid,
                         bsacctid,
                         accountnumber,
                         dateofnextstmt,
                         laststatementdate,
                         lad,
                         plansegcreatedate,
                         currentbalance,
                         principal,
                         equalpaymentamt,
                         servicefeesbnp,
                         servicechargectd,
                         amountoftotaldue,
                         latefeesbnp,
                         latechargesctd,
                         nsffeesbillednotpaid,
                         systemstatus,
                         ccinhparent125aid,
                         intbillednotpaid,
                         amtofinterestctd,
                         revolvingbsfc,
                         revolvingagg,
                         revolvingaccrued,
                         newtransactionsbsfc,
                         newtranagg,
                         newtranaccrued,
                         intplanoccurr,
                         beginningbalance,
                         intereststartdate,
                         daysincycle,
                         collateralid,
                         cideffectivedate,
                         interestearnednp,
                         currentbalanceco,
                         recoveryfeesbnp,
                         recoveryfeesctd,
                         amtofaccthighballtd,
                         NSFFeesCTD,
                         MembershipFeesBNP,
                         MembershipFeesCTD,
                         OverlimitFeesBNP,
                         AmtOfOvrLimitFeesCTD,
                         CollectionFeesBNP,
                         CollectionFeesCTD,
                         InsuranceFeesBnp,
                         CycleDueDTD,
                         AmtOfPayCurrDue,
                         AmtOfPayXDLate,
                         AmountOfPayment30DLate,
                         AmountOfPayment60DLate,
                         AmountOfPayment90DLate,
                         AmountOfPayment120DLate,
                         AmountOfPayment150DLate,
                         AmountOfPayment180DLate,
                         AmountOfPayment210DLate,
                         DaysDelinquent,
                         DateOfDelinquency,
                         LateFeesLTD,
                         LateFeeCreditLTD,
                         TotalAccruedInterest,
                         AnticipatedInterest)
            SELECT businessday,
                   cpsacctid,
                   bsacctid,
                   accountnumber,
                   dateofnextstmt,
                   laststatementdate,
                   lad,
                   plansegcreatedate,
                   currentbalance,
                   principal,
                   equalpaymentamt,
                   servicefeesbnp,
                   servicechargectd,
                   amountoftotaldue,
                   latefeesbnp,
                   latechargesctd,
                   nsffeesbillednotpaid,
                   systemstatus,
                   ccinhparent125aid,
                   intbillednotpaid,
                   amtofinterestctd,
                   revolvingbsfc,
                   revolvingagg,
                   revolvingaccrued,
                   newtransactionsbsfc,
                   newtranagg,
                   newtranaccrued,
                   intplanoccurr,
                   beginningbalance,
                   intereststartdate,
                   daysincycle,
                   collateralid,
                   cideffectivedate,
                   interestearnednp,
                   currentbalanceco,
                   recoveryfeesbnp,
                   recoveryfeesctd,
                   amtofaccthighballtd,
                   NSFFeesCTD,
                   MembershipFeesBNP,
                   MembershipFeesCTD,
                   OverlimitFeesBNP,
                   AmtOfOvrLimitFeesCTD,
                   CollectionFeesBNP,
                   CollectionFeesCTD,
                   InsuranceFeesBnp,
                   CycleDueDTD,
                   AmtOfPayCurrDue,
                   AmtOfPayXDLate,
                   AmountOfPayment30DLate,
                   AmountOfPayment60DLate,
                   AmountOfPayment90DLate,
                   AmountOfPayment120DLate,
                   AmountOfPayment150DLate,
                   AmountOfPayment180DLate,
                   AmountOfPayment210DLate,
                   DaysDelinquent,
                   DateOfDelinquency,
                   LateFeesLTD,
                   LateFeeCreditLTD,
                   TotalAccruedInterest,
                   AnticipatedInterest
            FROM   #planinfoforaccount
            WHERE  bsacctid >= @MinAcctid
                   AND bsacctid <= @MaxAcctid

            -----------------------------------Insert into Physical table LoyaltyInfoForReport-----------------------------------------------              
            INSERT INTO LoyaltyInfoForReport 
                        (BusinessDay,
                         InstitutionID,
                         BSAcctid,
                         LPSAcctid,
                         LPSProgramID,
                         Points,
                         OneLoyaltyPointIsEqualTo)
            SELECT BusinessDay,
                   InstitutionID,
                   BSAcctid,
                   LPSAcctid,
                   LPSProgramID,
                   Points,
                   OneLoyaltyPointIsEqualTo
            FROM   #LoyaltyInfoForReport
            WHERE  bsacctid >= @MinAcctid
                   AND bsacctid <= @MaxAcctid

				   	if(@CurrentDate = @MonthEndDate) --CBR if we are on month end then fill CBRMonthEndTable for CBR file for GS
		Begin 
			Insert into CBRMonthEndTable(
					CBRMonthEnd,
					acctId,
					ReportHistoryCtrCC01,--CBR
					ReportHistoryCtrCC02,--CBR
					ReportHistoryCtrCC03,--CBR
					ReportHistoryCtrCC04,--CBR
					ReportHistoryCtrCC05,--CBR
					ReportHistoryCtrCC06,--CBR
					ReportHistoryCtrCC07,--CBR
					ReportHistoryCtrCC08,--CBR
					ReportHistoryCtrCC09,--CBR
					ReportHistoryCtrCC10,--CBR
					ReportHistoryCtrCC11,--CBR
					ReportHistoryCtrCC12,--CBR
					ReportHistoryCtrCC13,--CBR
					ReportHistoryCtrCC14,--CBR
					ReportHistoryCtrCC15,--CBR
					ReportHistoryCtrCC16,--CBR
					ReportHistoryCtrCC17,--CBR
					ReportHistoryCtrCC18,--CBR
					ReportHistoryCtrCC19,--CBR
					ReportHistoryCtrCC20,--CBR
					ReportHistoryCtrCC21,--CBR
					ReportHistoryCtrCC22,--CBR
					ReportHistoryCtrCC23,--CBR
					ReportHistoryCtrCC24,--CBR
					Date_Opened ,--CBR 
					AmtOfPaymentRevMTD, --CBR 
					OldAccountNumber,--CBR
					Application_ID,
					AmountOfPaymentsMTD,
					systemstatus,
					currentbalance,
					CBRIndicator,
					InstitutionID,
					LastCreditDate
					)
			Select  @BusinessDay,
					BP.Acctid,
					BP.ReportHistoryCtrCC01,--CBR
					BP.ReportHistoryCtrCC02,--CBR
					BP.ReportHistoryCtrCC03,--CBR
					BP.ReportHistoryCtrCC04,--CBR
					BP.ReportHistoryCtrCC05,--CBR
					BP.ReportHistoryCtrCC06,--CBR
					BP.ReportHistoryCtrCC07,--CBR
					BP.ReportHistoryCtrCC08,--CBR
					BP.ReportHistoryCtrCC09,--CBR
					BP.ReportHistoryCtrCC10,--CBR
					BP.ReportHistoryCtrCC11,--CBR
					BP.ReportHistoryCtrCC12,--CBR
					BP.ReportHistoryCtrCC13,--CBR
					BP.ReportHistoryCtrCC14,--CBR
					BP.ReportHistoryCtrCC15,--CBR
					BP.ReportHistoryCtrCC16,--CBR
					BP.ReportHistoryCtrCC17,--CBR
					BP.ReportHistoryCtrCC18,--CBR
					BP.ReportHistoryCtrCC19,--CBR
					BP.ReportHistoryCtrCC20,--CBR
					BP.ReportHistoryCtrCC21,--CBR
					BP.ReportHistoryCtrCC22,--CBR
					BP.ReportHistoryCtrCC23,--CBR
					BP.ReportHistoryCtrCC24,--CBR
					BP.Date_Opened ,--CBR 
					AmtOfPaymentRevMTD, --CBR 
					BP.OldAccountNumber,--CBR
					  BP.Application_ID,
					  BP.AmountOfPaymentsMTD,
					  BP.systemstatus,
					  BP.currentbalance,
					  BCBR.CBRIndicator,
					  BP.InstitutionID,
					  BP.LastPaymentdate
			From dbo.#TempBsegmentPrimary BP with(nolock)
			 JOIN dbo.BSCBRIndicatorDetail BCBR WITH(nolock) ON ( BP.acctid = BCBR.acctid AND BCBR.CBRIndicator in(1,6,7,8) AND BP.laststatementdate Is Not Null AND BP.Sysorgid = 7)  
			WHERE  BP.acctid >= @MinAcctid  
                   AND BP.acctid <= @MaxAcctid  

			Update CBRME
			Set CBRME.totalamountco =  BCC.totalamountco ,
				CBRME.CollateralID	= BCC.CollateralID
			From CBRMonthEndTable CBRME With(Nolock) 
			Join dbo.bsegmentcreditcard BCC WITH(nolock) On BCC.acctId = CBRME.acctId 
			Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 
		
			Update CBRME
			Set CBRME.CBRComplianceCode			= BS.CBRComplianceCode,
				CBRME.AcctInCollectionsSystem	= BS.AcctInCollectionsSystem
			From CBRMonthEndTable CBRME With(Nolock) 
			JOIN dbo.bsegment_secondary BS WITH(nolock)  ON ( CBRME.acctid = BS.acctid )  
			Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 

			Update CBRME
			Set		CBRME.Primary_Borrower_Surname					= Cst.LastName,--CBR
					CBRME.Primary_Borrower_First_Name				= Cst.FirstName,--CBR
					CBRME.Primary_Borrower_Middle_Name				= Cst.MiddleName,--CBR
					CBRME.Primary_Borrower_Generation_Code			= Cst.SNSuffix,--CBR
					CBRME.Primary_Borrower_Social_Security_Number	= Cst.SocialSecurityNumber,--CBR
					CBRME.Primary_Borrower_Date_Of_Birth			= Cst.DateofBirth,--CBR
					CBRME.Primary_Borrower_Telephone_Number			= Cst.HomePhoneNumber,--CBR
					CBRME.Primary_Borrower_Ecoa_Code				= CASE When Cst.COA_FirstName Is NULL Then '1' Else '2' END,--CBR
					CBRME.CO_Borrower_Surname						= Cst.COA_LastName,--CBR
					CBRME.CO_Borrower_First_Name					= Cst.COA_FirstName,--CBR
					CBRME.CO_Borrower_Middle_Name					= Cst.COA_MiddleName,--CBR
					CBRME.CO_Borrower_Generation_Code				= Cst.COA_SurnameSuffix,--CBR
					CBRME.CO_Borrower_SSN							= Cst.COA_SSN,--CBR
					CBRME.CO_Borrower_DOB							= Cst.CAPCOADateOfBirth,--CBR
					CBRME.CO_Borrower_Telephone						= Cst.COA_HomePhoneNo,--CBR
					CBRME.CO_Borrower_Ecoa_Code						= CASE When Cst.COA_FirstName Is not NULL and LTRIM(RTRIM(Cst.COA_FirstName)) != '' Then '2'  END,--CBR  CASE When Cst.COA_FirstName Is NULL Then '1' Else '2' END,--CBR
					CBRME.Deceased									= Cst.Deceased,
					CBRME.COA_Deceased								= Cst.COA_Deceased	,
					CBRME.COA_CBRConsumerInfoIndicator				= Cst.COA_CBRConsumerInfoIndicator
			From CBRMonthEndTable CBRME With(Nolock)
			 Join EmbossingAccounts EMB With(Nolock) on EMB.Parent01Aid = CBRME.Acctid
			 Join Customer Cst With(nolock) on EMB.CustomerId = Cst.CustomerId 
			Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 
			
			Update CBRME
			Set Primary_Borrower_Country_Code = 'US',--CBR
					Primary_Borrower_First_Line_Of_Address = ADR.addressline1 ,--CBR
					Primary_Borrower_Second_Line_Of_Address = ADR.addressline2,--CBR
					Primary_Borrower_City =  ADR.city,--CBR
					Primary_Borrower_State =  ADR.StateorProvince,--CBR
					Primary_Borrower_Zip_Code = ADR.postalcode,--CBR
					CO_Borrower_AddressLine1 = ADR.COA_CAPStreetAddLine1,--CBR
					CO_Borrower_AddressLine2 = ADR.COA_CAPStreetAddLine2,--CBR
					CO_Borrower_City = ADR.COA_City,--CBR
					CO_Borrower_State = ADR.COA_State,--CBR
					CO_Borrower_ZipCode = ADR.COA_ZIP,
					CO_Borrower_Country_Code ='US',--CBR
					CBRME.ConsumerInfoIndicator = ADR.ConsumerInfoIndicator
			From CBRMonthEndTable CBRME With(Nolock)
			Join EmbossingAccounts EMB With(Nolock) on EMB.Parent01Aid = CBRME.Acctid
			Join Address ADR With(nolock) on EMB.CustomerId = ADR.CustomerId 
			Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 

			Update CBRME
			SET   CBRME.ProductID =  AIR.ProductID    ,   --
			-- CBRME.CollateralID  = AIR.CollateralID,
			 CBRME.Accountnumber  = AIR.Accountnumber,
			 CBRME.CreditLimit  = AIR.CreditLimit,
			 CBRME.AmtOfAcctHighBalLTD  = AIR.AmtOfAcctHighBalLTD,
			 --CBRME.AmountOfTotalDue  = AIR.AmountOfTotalDue,
			 --CBRME.DaysDelinquent  = AIR.DaysDelinquent,
			 CBRME.DaysDelinquent  = IsNull(datediff(d,AIR.DateOfDelinquency,@BusinessDay),0),  -- fixed 201882
			 CBRME.Principal  = AIR.Principal,
			 --CBRME.AmtOfPayXDLate  = AIR.AmtOfPayXDLate,
			 CBRME.AmtOfPayXDLate  = AIR.amountoftotaldue - AIR.amtofpaycurrdue,
			 CBRME.DateOfDelinquency  = AIR.DateOfDelinquency,
			 CBRME.DateAcctClosed  = AIR.DateAcctClosed,
			 --CBRME.LastCreditDate  = AIR.LastCreditDate,
			 CBRME.DisputesAmtNS  = AIR.DisputesAmtNS,
			 CBRME.MerchantId  = AIR.MerchantId,
			 CBRME.ccinhparent125aid  = AIR.ccinhparent125aid,
			 CBRME.LastStatementDate  = AIR.LastStatementDate,
			 CBRME.ChargeOffDate  = AIR.ChargeOffDate,
			 CBRME.currentbalanceco  = AIR.currentbalanceco,
			 CBRME.amtofpaycurrdue = AIR.amtofpaycurrdue
			 From CBRMonthEndTable CBRME With(Nolock)
			 JOIN #accountinfoforreport AIR WITH(NOLOCK) ON AIR.bsacctid = CBRME.Acctid
			 Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 

			Update CBRME
			Set CBRME.AmountOfTotalDue  = SHDR.AmountOfTotalDue
			From  CBRMonthEndTable CBRME With(Nolock)
			JOin StatementHeader SHDR With(nolock) ON CBRME.acctId = SHDR.acctId AND SHDR.StatementDate = CBRME.LastStatementDate
			Where CBRME.acctid >= @MinAcctid  
                   AND CBRME.acctid <= @MaxAcctid 
				   AND CBRME.CBRMonthEnd = @BusinessDay 


			End
        /*    
        SELECT @RecordCount=Count(1) FROM #accountinfoforreport WITH(NOLOCK) WHERE SKey>@LastChunk AND SKey<=@LastChunk+@ChunkSize    
        SELECT @MinAcctid=Min(bsacctid),@MaxAcctid=Max(bsacctid),@LastChunk=Max(SKey) FROM #accountinfoforreport WITH(NOLOCK) WHERE bsacctid>@MaxAcctid AND SKey<=@LastChunk+@ChunkSize    
        */
        END

      UPDATE SPExecutionLOg
      SET    endtime = Getdate()
      WHERE  operation = 'chunkinsert'
             AND institutionid = @OrgAcctid
             AND BusinessDay = @BusinessDay

      UPDATE SPExecutionLOg
      SET    endtime = Getdate()
      WHERE  operation = 'SpStarted'
             AND institutionid = @OrgAcctid
             AND BusinessDay = @BusinessDay
	  
	  INSERT INTO EODControlData(BusinessDay,InstitutionID,JobStatus,AccountInfoCount,PlanInfoCount)
	  VALUES(@BusinessDay,@OrgAcctid,'NEW',@AccountInfoCount,@PlanInfoCount)	
      
	  INSERT INTO SYN_CL_ReportSchedules ([ReportID],[ATID],[AID],[SecondaryID],[RecipientId],[Source],[Frequency],[DeliveryMethod],[NextDateTime],[InstitutionId])
	  SELECT 538,6,InstitutionID,Skey,InstitutionID,'CoreIssue',2,1
		  ,(SELECT MAX(period_time) FROM PeriodTable WITH(NOLOCK) WHERE Period_Name = 'LTD') AS NextDateTime
		  ,InstitutionID 
	  FROM EODControlData WITH(NOLOCK) WHERE InstitutionID = @OrgAcctid AND businessDay = @businessDay   
	  
	  --PRINT '12'          
      SELECT @BusinessDay
  END 

GO


