  
/****** Object:  StoredProcedure [dbo].[Usp_extractdataforfutureprojection]    Script Date: 7/14/2022 7:06:34 PM ******/  
  
/**********************************************************************************************************************  
/*  
Author - Sonam Gupta  
Reviwer - Sunil Rathore  
Modified For - Plat_33018  
Date Added - 03/21/2022  
Version - Plat_17.00.04  
Description - Added column LateChargesCC1,LateFeeCreditCTD,LateFeeCreditCC1 in AccountInfoForReport table  
----------------------------------------------------------------------------  
--Author = Prashanti kasturi  
--Reviewer = Sunil Rathor  
--Modified For - COOKIE-200879  
--Task - Added PaymentDuringProgram,PaymentDuringProgramCTD,OriginalSettlementAmount,MonthlySettlementAmount,BilledSettlementAmount,  
--ProgramStartDate,ProgramEndDate in accountInfoForReport Table    
----------------------------------------------------------------------------  
*/  
**********************************************************************************************************************/  
  
/****** Object:  StoredProcedure [dbo].[Usp_extractdataforfutureprojection]    Script Date: 3/14/2022 3:38:37 PM ******/  
  
Create  or alter  PROCEDURE [Usp_extractdataforfutureprojection] (@ARSystemAcctId INT)  
AS  
    SET NOCOUNT ON  
 SET ANSI_NULLS ON  
 SET QUOTED_IDENTIFIER ON  
  
----------------------------------------------------------------------------  
--Author = Rohit Soni  
--Reviewer = Deepak Jain  
--Task - Assigned Chargeoff date instead of chargeoffdataparam  
--JIRA - COOKIE-208455  
--linenumber -line no 1673  
----------------------------------------------------------------------------  
--Author = Sonam Gupta  
--Reviewer = Sunil Rathore  
--Task - Assigned value in column LateChargesCC1,LateFeeCreditCTD,LateFeeCreditCC1 in accountInfoForReport table  
----------------------------------------------------------------------------  
--Author = Sonam Gupta  
--Reviewer = Ujjwal Gupta  
--Task - Assigned value in column CBRRefundDate in accountInfoForReport table  
----------------------------------------------------------------------------  
--Author = Sonam Gupta  
--Reviewer = Ujjwal Gupta  
--Task - Assigned value in column [lastpmtdate], [CreditBalanceDate] in accountInfoForReport table  
----------------------------------------------------------------------------  
--Author = Sonam Gupta  
--Reviewer = Rohit Soni  
--Task - Assigned value in column IntBilledNotPaid in accountInfoForReport table  
----------------------------------------------------------------------------  
--Author : Sonam Gupta  
--Task : add New Column AccountMergedByAccountID , MergeDate in AccountInfoForReport   
--Reviewer: Rohit Soni  
----------------------------------------------------------------------------  
--Author : Prashanti Kasturi  
--Task : add New Column DaysDelinquentNew in AccountInfoForReport for Cookie-141126  
--Reviewer: Sunil Rathor  
----------------------------------------------------------------------------  
----------------------------------------------------------------------------  
--Author : Sunil Rathor  
--Task : Add code for assign PODID in ReportSchedules table.  
--Reviewer: Deepak Dharkar  
----------------------------------------------------------------------------  
----------------------------------------------------------------------------  
--Author : Prashanti Kasturi  
--Task : add New Column ReageStatus,ReageStartDate ,ReageEndDate ,ReagePaymentAmt in AccountInfoForReport for Reage program   
--Reviewer: Sunil Rathor  
----------------------------------------------------------------------------  
----------------------------------------------------------------------------  
--Author : Prashanti Kasturi  
--Task : add New Column MinDueRequired in AccountInfoForReport for cookie-134289   
--Reviewer: Sunil Rathor  
----------------------------------------------------------------------------  
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Author : Aman Mehta  
--Task : add New Columns SCRAEffectiveDate,SCRAEndDate in AccountInfoForReport and also update ActualDrpStartDate,ccinhparent125aid on Businessday = LastStatementdate  
--Reviewer: Sunil Rathor  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--***************************************************************************************************  
----Creator      - Rohit Sonni  
----Task Added New column RequestorID   in AccountInfoforREport PLAT-5616  
--******************************************************************************************************  
  
-- We have done following changes in the SP Usp_ExtractDataforFutureProjection.  
--1) Added Index hints in the table Bsegment_primary.  
--2) Changed the where sequence of the clause.  
--3) Created index on the temp table #TempBsegmentPrimary.  
--4) As I came to know that we are not using table anymore now, thus we commented code to insert any data in the #temp_lastactivitylog table.  
--5) Here in the SP we are also using CTE which is created for CreditLimitAuditLog table, but when we saw the execution plan, it is showing Index scan and was not using proper index,  
--Thus we added index hints and now cost looks better than earlier.  
--6) Added index on a column for table #accountinfoforreport.  
--7) Rohit | Added Chuncking of TempTable  
  
    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE            
    DECLARE @BusinessDay DATETIME  
    /*<<== Changes required for Multi Institution ==>> */  
    DECLARE @iARSystemAcctId INT = @ARSystemAcctId  
    DECLARE @OrgAcctid   INT,  
            @ChunkSize   INT=1,  
            @MinAcctid   DECIMAL(19)=0,  
            @MaxAcctid   DECIMAL(19)=0,  
            @RecordCount INT,  
            @LastChunk   INT=0,  
   @CurrentDate Datetime,--CBR  
   @MonthEndDate Datetime, --CBR  
   @AccountInfoCount INT=0,  
   @PlanInfoCount INT=0,  
   @LogCount INT = 0,  
   @loopCount INT = 0 ,  
   @PODID TINYINT,  
   @TotalInsertCount INT = 0,  
   @CombineSTMTEOD varchar(2)= '0',  
   @CombineSTMTCTD varchar(2)= '0'  
  
  select Top 1 @ChunkSize = LoopChunk  from SPBatching  with(nolock)  where Sp_Name= 'Usp_extractdataforfutureprojection'  
  
   set @ChunkSize =1 
  
  
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
  LastPaymentdate DATETIME,--TD#202532   
  AmountOfPurchasesLTD MONEY,  
  AmtOfDispRelFromOTB MONEY,  
  AmountOfReturnsLTD MONEY,  
  LAPD DATETIME,  
  SCRAEffectiveDate DATETIME, --Added new Column  
  PODID TINYINT,  
  MergePendingOTB MONEY,    
  MergeDisputeAmtNS MONEY,    
  MergeTotalDebits MONEY,    
  MergeTotalCredits MONEY,    
  MergeAmtOfDispRelFromOTB MONEY,  
  SysSubOrgID TINYINT,  
  DeAcctActivityDate datetime ,  
  FreezeDelinquency int,  
  CreditBalanceDate datetime,  
  LateChargesCC1 MONEY,  
  LateFeeCreditCC1 MONEY  
 )  
  
   
  
  
    SELECT @BusinessDay = procdayend  
    FROM   arsystemaccounts WITH(nolock)  
    WHERE  acctid = @iARSystemAcctId  
  
 SELECT  @CurrentDate = DATEADD(dd, DATEDIFF(dd, 0, @BusinessDay),0) -- CBR current date with 00:00:00.00 time   
   SELECT @MonthEndDate= DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @BusinessDay) + 1, 0)) -- CBR month end date  with 00:00:00.00 time   
 --print @CurrentDate  
 --print @MonthEndDate  
    --PRINT '0'      
    --PRINT @BusinessDay      
    DECLARE @TotalSecond INT = Datediff(second, Cast(@BusinessDay AS DATE), @BusinessDay)  
  
    SELECT @OrgAcctid = acctid,  
  @PODID = ISNULL(PODID,0),  
  @CombineSTMTEOD = ISNULL(StmtEODCombination,'0'),  
  @CombineSTMTCTD =ISNULL(StmtCTDCombination,'0')  
    FROM   org_balances WITH(nolock)  
    WHERE  acctid > 0  
           AND arsystemacctid = @iARSystemAcctId  
  
       
    IF EXISTS((SELECT TOP 1 1  
               FROM   SPExecutionLOg WITH(nolock)  
               WHERE  businessday = @BusinessDay  
                      AND institutionid = @OrgAcctid))  
      BEGIN  
          DELETE FROM SPExecutionLOg  
          WHERE  institutionid = @OrgAcctid  
                 AND BusinessDay = @BusinessDay  
      END  
   
    INSERT INTO SPExecutionLOg(spname ,Starttime ,endtime ,operation ,Businessday ,institutionid,RecordCount )  
    VALUES      ('Usp_extractdataforfutureprojection',  
                 Getdate(),  
                 NULL,  
                 'SpStarted',  
                 @BusinessDay,  
                 @OrgAcctid,  
     0)  
  
  
    CREATE TABLE #temp_lastactivitylog  
      (  
         SKey                      INT IDENTITY(1, 1) PRIMARY KEY,  
         acctid                    INT,  
         lastactivitydateofbilling DATETIME  
      )  
  
  /* Commented by Monu, as per discussion with Robin, we are not using lastactivitylog table anymore, thus we don't need to insert data in temp table.*/  
   /* INSERT INTO #temp_lastactivitylog  
    SELECT l.acctid,  
           Max(l.requestdatetime)  
    FROM   lastactivitylog l WITH(nolock)  
           JOIN #TempBsegmentPrimary b WITH(nolock)  
             ON ( l.acctid = b.acctid  
                  /*AND b.institutionid = @OrgAcctid*/ )  
    WHERE  Skey > 0  
    GROUP  BY l.acctid  
 */  
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
   [OriginalDueDate]    [DATETIME],  
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
  CashLmtAmt MONEY,  
  LastReportedInterestDate datetime,  
  TestAccount tinyint,  
  AmountOfPurchasesLTD MONEY,  
  SysOrgId INT,  
  AmtOfDispRelFromOTB MONEY,  
  SRBWithInstallmentDue money NULL,  
  SBWithInstallmentDue money NULL,  
  InstallmentOutStgAmt MONEY,  
  CreditOutStgAmt MONEY,  
  ActualDRPStartDate datetime,  
  StatusReason Varchar(150),  
  TotalAmountCO money,  
  AfterCycleRevolvBSFC money,  
  AccountGraceStatus varchar (2),  
  AmountOfReturnsLTD MONEY,  
  LAPD DATETIME,  
  EffectiveEndDate_Acct DATETIME,  
  MinDueRequired tinyint,  
  SCRAEffectiveDate DATETIME, -- Added new Column  
  SCRAEndDate DATETIME, -- Added new Column  
  ReageStatus INT,  
  ReageStartDate DATETIME,  
  ReageEndDate DATETIME,  
  ReagePaymentAmt MONEY,  
  PODID TINYINT,  
  DaysDelinquentNew INT,  
  DqTDRCounterYTD INT,  
  NonDqTDRCounterYTD  INT,  
  InteragencyEligible  INT,  
  PendingDqTDRCounterYTD  INT,  
  PendingNonDqTDRCounterYTD  INT,  
  MergedAccountID INT,  
  MergedAccountNumber varchar(19),  
  AccountMergedByAccountID int,  
  MergeDate datetime,  
  MergePendingOTB MONEY,    
  MergeDisputeAmtNS MONEY,    
  MergeTotalDebits MONEY,    
  MergeTotalCredits MONEY,    
  MergeAmtOfDispRelFromOTB MONEY,  
  TCAPPaymentAmt MONEY,  
  TCAPStatus int,  
  TCAPStartDate datetime,  
  TCAPEndDate datetime,  
  IsAcctSCRA VARCHAR(1),  
  RequestorID  Varchar (64),  
  SysSubOrgID TINYINT,  
  RequestorTimeStamp  datetime,  
  closedStatus INT,  
  DeAcctActivityDate datetime,  
  IntBilledNotPaid money,  
  StmtCTDCombination VARCHAR(2),  
  StmtEODCombination VARCHAR(2),  
  lastpmtdate datetime, --JIRA 11884  
  CreditBalanceDate datetime,  
  CBRRefundDate datetime ,  
  LateChargesCC1 money,  
  LateFeeCreditCTD money,  
  LateFeeCreditCC1 money,  
  PaymentDuringProgram money,  
  PaymentDuringProgramCTD money,  
  OriginalSettlementAmount money,  
  MonthlySettlementAmount money,  
  BilledSettlementAmount money,  
  ProgramStartDate datetime,  
  ProgramEndDate datetime  
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
   [AccountGraceStatus]    [VARCHAR](2) NULL,  
   [TrailingInterestDate]    [DATETIME] NULL,  
   [ActivityDay]      [BIT] NULL,  
   AmountOfPurchasesLTD MONEY,  
   InterestDefermentStatus CHAR(5),  
   DeferredAccruedFinal MONEY,  
   PromoRateDuration int NULL,  
   PromoStartDate DATETIME NULL,  
   PromoRateEndDate DATETIME NULL,  
   InterestRate1 MONEY NULL,  
   PromoTxnPeriodStartDate  datetime NULL,  
   PromoTxnPeriodEndDate  datetime NULL,  
   PromoPlanActive  tinyint NULL,  
   SRBWithInstallmentDue money NULL,  
   SBWithInstallmentDue money NULL,  
   IPOstartdate DATETIME,  
   IPOenddate DATETIME,  
   [RetailAniversaryDate] DATETIME,  
   CreditPlanType varchar(5) Null,  
   AfterCycleRevolvBSFC   money,  
  HoldDisputeBSFCCycle1   money,  
  HoldDisputeBSFCCycle2 money,  
  HoldDisputeBSFCEndDateCycle1  datetime,  
  HoldDisputeBSFCEndDateCycle2   datetime,  
  AmountOfReturnsLTD MONEY,  
  MergeDate datetime,  
  MergeIndicator int,  
  StmtCTDCombination VARCHAR(2),  
  StmtEODCombination VARCHAR(2)  
      )  
  
    ------------------------------------------------Create Temp Table #planinfoforaccount---------------------------------------------          
  
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
         [AnticipatedInterest]     [MONEY] NULL,  
   [PromoRateDuration]  [INT] NULL,  
   [PromoStartDate] [DATETIME] NULL,  
   [PromoRateEndDate] [DATETIME] NULL,  
   [InterestRate1] [MONEY],  
   PromoTxnPeriodStartDate  [DATETIME] NULL,  
   PromoTxnPeriodEndDate  [DATETIME] NULL,  
   PromoPlanActive  [TINYINT] NULL,  
   CreditPlanType    [Varchar] (5) NULL,  
   AfterCycleRevolvBSFC   money,  
  HoldDisputeBSFCCycle1   money,  
  HoldDisputeBSFCCycle2 money,  
  HoldDisputeBSFCEndDateCycle1  datetime,  
  HoldDisputeBSFCEndDateCycle2   datetime,  
  AmountOfReturnsLTD MONEY,  
  MergeDate datetime,  
  MergeIndicator int,  
  AccountGraceStatus VARCHAR(2),  
  StmtCTDCombination VARCHAR(2),  
  StmtEODCombination VARCHAR(2)  
  
      )  
  
    ------------------------------------------------Create Temp Table #LoyaltyInfoForReport---------------------------------------------          
  
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
  
  
 ------------------------------------------------Create Temp Table #CustomerLoyaltyInfoForReport---------------------------------------------          
  
    CREATE TABLE #CustomerLoyaltyInfoForReport  
      (  
         [BusinessDay]              DATETIME,  
         [InstitutionID]            INT,  
         [BSAcctid]                 DECIMAL(19),  
         [LPSAcctid]                DECIMAL(19),  
   [CustomerId]    VARCHAR(25),  
   [PartnerId]    VARCHAR(64),  
   [ClientId]     VARCHAR(64),  
         [LPSProgramID]             DECIMAL(19),  
         [Points]                   MONEY,  
         [OneLoyaltyPointIsEqualTo] MONEY,  
         [skey]                     DECIMAL(19) IDENTITY(1, 1) PRIMARY KEY  
      )  
  
   CREATE TABLE #TempAccountHold  
      (  
   acctid  int ,  
   skey int IDENTITY (1,1)      
   )  
  
   --- Vishal  - Move Temp table  code on top  due to chunking  
    CREATE TABLE #collateralinfo  
        (  
           SeqID            INT IDENTITY(1, 1),  
           RowNumber        INT,  
           collateralid     VARCHAR(50),  
           cideffectivedate DATETIME,  
           cpsid            INT,  
     BSAcctid INT,  
     Atid   INT  
        )  
  
   CREATE TABLE #recurringrecordplan  
        (  
           RowNum      INT ,  
           cpsacctid   INT,  
           nextfeedate DATETIME  
     Primary Key Clustered (RowNum,cpsacctid)  
        )  
  
  CREATE TABLE #recurringrecordaccount  
        (  
           SeqID       INT IDENTITY(1, 1),  
           RowNum      INT,  
           cpsacctid   INT,  
           nextfeedate DATETIME  
        )  
  
  --- Vishal  - Move Indexs code on top  due to chunking  
  --CREATE NONCLUSTERED INDEX [idx_TempAccountHold_Skey_acctid]  
  --ON #TempAccountHold (Skey,acctid)  
  
  CREATE NONCLUSTERED INDEX [idx_TempBSegment_acctid_Include_BSAcctidEtc]  
  ON #TempBsegmentPrimary ([acctid])  
  INCLUDE (accountnumber, dateofnextstmt, laststatementdate,currentbalance,principal,  
  systemstatus, institutionid,parent02aid,cycleduedtd,amtofpaycurrdue,nsffeesbillednotpaid, ccinhparent125aid,beginningbalance,  
  ccinhparent127aid,creditlimit,billingcycle,lastreagedate, createdtime,pendingotb,amtofaccthighballtd,parent05aid,NSFFeesCTD,  
  EnterCollectionDate,AmountOfDebitsCTD,AmountOfCreditsCTD,  
  WaiveLateFees,WaiveOverlimitFee,WaiveMembershipFee,WaiveTranFeeNCharOff,LastCreditDate,DateofLastDebit,  
  LastNSFPayRevDate,AmountOfPaymentsMTD,AlternateAccount,NumberAccounts,DateAcctClosed,LAD,IntWaiveForSCRA,  
  AmountOfPurchasesLTD,SysOrgID,AmtOfDispRelFromOTB,AmountOfReturnsLTD,LAPD )  
  
        CREATE NONCLUSTERED INDEX [RD_NC_BusinessDay_Include_BSAcctidEtc]  
        ON #accountinfoforreport ([bsacctid],[paymentlevel])  
        include ( accountnumber, dateofnextstmt, laststatementdate, systemstatus, institutionid, ccinhparent125aid, lastreagedate, createdtime )  
  -- END  
  
   --- Rohit - Move delete code on top  due to chunking  
  
      --PRINT '1'     
   IF(@CombineSTMTEOD='' or @CombineSTMTEOD is null or @CombineSTMTEOD='0')     
   BEGIN        
  
    INSERT INTO SPExecutionLOg (spname ,Starttime ,endtime ,operation ,Businessday ,institutionid, RecordCount )  
    VALUES      ('Usp_extractdataforfutureprojection',  
        Getdate(),  
        NULL,  
        'deleteStarted',  
        @BusinessDay,  
        @OrgAcctid,  
        0)  
  
    -----------------------------------Delete planinfoforreport for Business Day----------------------------------------------------          
    --Comment by Jinendra       
     
    IF EXISTS((SELECT TOP 1 1  
      FROM   planinfoforreport P WITH(nolock)  
       JOIN accountinfoforreport A WITH(nolock)  
         ON( P.bsacctid = A.bsacctid  
          AND P.businessday = A.businessday )  
      WHERE  P.businessday = @BusinessDay  
       AND A.institutionid IN ( @OrgAcctid )))  
   DELETE P  
   FROM   planinfoforreport P  
       JOIN accountinfoforreport A WITH(nolock)  
      ON( P.bsacctid = A.bsacctid  
       AND P.businessday = A.businessday )  
   WHERE  P.businessday = @BusinessDay  
       AND A.institutionid = @OrgAcctid  
  
    --PRINT '1.1'          
    -----------------------------------Delete planinfoforaccount for Business Day----------------------------------------------------          
    --Comment by Jinendra        
    IF EXISTS((SELECT TOP 1 1  
      FROM   planinfoforaccount P WITH(nolock)  
       JOIN accountinfoforreport A WITH(nolock)  
         ON( P.bsacctid = A.bsacctid  
          AND P.businessday = A.businessday )  
      WHERE  P.businessday = @BusinessDay  
       AND A.institutionid IN ( @OrgAcctid )))  
   DELETE P  
   FROM   planinfoforaccount P  
       JOIN accountinfoforreport A WITH(nolock)  
      ON( P.bsacctid = A.bsacctid  
       AND P.businessday = A.businessday )  
   WHERE  P.businessday = @BusinessDay  
       AND A.institutionid = @OrgAcctid  
  
    --PRINT '1.2'          
    -----------------------------------Delete accountinfoforreport for Business Day----------------------------------------------------          
    --Comment by Jinendra        
    IF EXISTS((SELECT TOP 1 1  
      FROM   accountinfoforreport WITH(nolock)  
      WHERE  businessday = @BusinessDay  
       AND institutionid IN ( @OrgAcctid )))  
   DELETE FROM accountinfoforreport  
   WHERE  businessday = @BusinessDay  
       AND institutionid = @OrgAcctid  
  
    --PRINT '1.3'          
    -----------------------------------Delete LoyaltyInfoForReport for Business Day----------------------------------------------------          
    --Comment by Jinendra        
    IF EXISTS((SELECT TOP 1 1  
      FROM   LoyaltyInfoForReport WITH(nolock)  
      WHERE  SKey > 0  
       AND businessday = @BusinessDay  
       AND institutionid IN ( @OrgAcctid )))  
   DELETE FROM LoyaltyInfoForReport  
   WHERE  businessday = @BusinessDay  
       AND institutionid = @OrgAcctid  
  
    -----------------------------------Delete CustomerLoyaltyInfoForReport for Business Day----------------------------------------------------      
          
    IF EXISTS((SELECT TOP 1 1  
      FROM   CustomerLoyaltyInfoForReport WITH(nolock)  
      WHERE  SKey > 0  
       AND businessday = @BusinessDay  
       AND institutionid IN ( @OrgAcctid )))  
   DELETE FROM CustomerLoyaltyInfoForReport  
   WHERE  businessday = @BusinessDay  
       AND institutionid = @OrgAcctid  
  
    UPDATE SPExecutionLOg  
    SET    endtime = Getdate()  
    WHERE  operation = 'deleteStarted'  
     AND institutionid = @OrgAcctid  
     AND BusinessDay = @BusinessDay  
   
 ---- ---End Delete code   
 END  
  
  declare  @CountAccount   int = 0   
   declare  @AMinAcctid int  = 0  ,@AMaxAcctid  int = 0 ,@count int =0  
  
   /*IF(@CombineSTMTEOD='1')  
  select  @CountAccount =  count(acctid),@AMinAcctid = min(acctid) ,@AMaxAcctid = max(acctid)  from Bsegment_primary  with(index (IDX_Bsegment_primary_InstID_BC_LastSTMT ),nolock)   Where BillingCycle <>'LTD' and (laststatementdate is null or laststatemen
tdate!= @Businessday) and institutionid = @OrgAcctid  
      ELSE*/  
  select  @CountAccount =  count(acctid),@AMinAcctid = min(acctid) ,@AMaxAcctid = max(acctid)  
  from Bsegment_primary  with(index (IDX_Bsegment_primary_InstitutionidBillingCycle),nolock)   Where BillingCycle <>'LTD' and institutionid = @OrgAcctid  
  
   set @MinAcctid  = @AMinAcctid  
   set @MaxAcctid  = @AMinAcctid  
  
   
  UPDATE SPExecutionLOg  
      SET    RecordCount = @RecordCount  
      WHERE  operation = 'SpStarted'  
             AND institutionid = @OrgAcctid  
             AND BusinessDay = @BusinessDay  
  
  
  
  
  INSERT INTO SPExecutionLOg (spname ,Starttime ,endtime ,operation ,Businessday ,institutionid, RecordCount )  
     VALUES      ('Usp_extractdataforfutureprojection',  
         Getdate(),  
         NULL,  
         'chunkinsert',  
         @BusinessDay,  
         @OrgAcctid,  
         0)  
 --print @iCounter  
 --print @RecordCount  
 set @loopCount = 0   
 Begin   
    WHILE @MaxAcctid <= @AMaxAcctid  
        BEGIN  
  --print 'inside loop'  
            -----------------------------------Insert into Physical table accountinfoforreport-----------------------------------------------            
            truncate table #TempBsegmentPrimary  
   truncate table #temp_lastactivitylog  
   truncate table #accountinfoforreport  
   truncate table #Temp_CLHistory  
   truncate table #Temp_ASHistory  
   truncate table #planinfoforreport  
   truncate table #LoyaltyInfoForReport  
   truncate table #CustomerLoyaltyInfoForReport  
   truncate table #collateralinfo  
   truncate table #recurringrecordaccount  
   truncate table #recurringrecordplan  
   truncate table #planinfoforaccount -- CT 99307   change  
   --truncate table #TempBsegmentPrimary  
       
       
    set @MaxAcctid  = @MaxAcctid + @ChunkSize  
  
     IF (@CountAccount < @ChunkSize )  
  BEGIN  
  IF(@CombineSTMTEOD='1')  
  BEGIN  
   INSERT INTO #TempBsegmentPrimary  
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
     LastPmtdate,  
     AmountOfPurchasesLTD,  
     BP.AmtOfDispRelFromOTB,  --Added Index hints for the BillingCycle and InstitutionId column, because without hints index, it is doing index scand and not using existing index.  
     BP.AmountOfReturnsLTD,  
     BP.LAPD,  
     BP.SCRAEffectiveDate,  
     PODID,  
     BP.MergePendingOTB,     
     BP.MergeDisputeAmtNS,    
     BP.MergeTotalDebits,    
     BP.MergeTotalCredits,    
     BP.MergeAmtOfDispRelFromOTB,  
     BP.SysSubOrgID,  
     BP.DeAcctActivityDate,  
     BB.FreezeDelinquency,  
     BP.CreditBalanceDate, --JIRA 11884  
     BB.LateChargesCC1,  --JIRA Plat_33018  
     BB.LateFeeCreditCC1    
    from Bsegment_primary BP   with(index (IDX_Bsegment_primary_InstID_BC_LastSTMT),nolock)    
     Join BSegment_Balances BB  with(nolock) On BP.Acctid = BB.Acctid   
       Where BillingCycle <>'LTD' and (laststatementdate is null or laststatementdate!= @Businessday) and institutionid = @OrgAcctid  and   Bp.acctid  between    @AMinAcctid  and  @AMaxAcctid   
   END  
   ELSE  
   BEGIN  
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
     LastPmtdate,  
     AmountOfPurchasesLTD,  
     BP.AmtOfDispRelFromOTB,  --Added Index hints for the BillingCycle and InstitutionId column, because without hints index, it is doing index scand and not using existing index.  
     BP.AmountOfReturnsLTD,  
     BP.LAPD,  
     BP.SCRAEffectiveDate,  
     PODID,  
     BP.MergePendingOTB,     
     BP.MergeDisputeAmtNS,    
     BP.MergeTotalDebits,    
     BP.MergeTotalCredits,    
     BP.MergeAmtOfDispRelFromOTB,  
     BP.SysSubOrgID,  
     BP.DeAcctActivityDate,  
     BB.FreezeDelinquency,  
     BP.CreditBalanceDate, --JIRA 11884  
     BB.LateChargesCC1,  --JIRA Plat_33018  
     BB.LateFeeCreditCC1   
    from Bsegment_primary BP   with(index (IDX_Bsegment_primary_InstitutionidBillingCycle),nolock)    
     Join BSegment_Balances BB  with(nolock) On BP.Acctid = BB.Acctid   
    Where BillingCycle <>'LTD'  and institutionid = @OrgAcctid  and   Bp.acctid  between    @AMinAcctid  and  @AMaxAcctid   
   END    
   
 set @LogCount  = @@rowcount  
 set @AMaxAcctid  = 0   
 END  
 ELSE   
 BEGIN  
  IF(@CombineSTMTEOD='1')  
  BEGIN  
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
    LastPmtdate,  
    AmountOfPurchasesLTD,  
    BP.AmtOfDispRelFromOTB,  --Added Index hints for the BillingCycle and InstitutionId column, because without hints index, it is doing index scand and not using existing index.  
    BP.AmountOfReturnsLTD,  
    BP.LAPD,  
    BP.SCRAEffectiveDate,  
    PODID,  
    BP.MergePendingOTB,     
    BP.MergeDisputeAmtNS,    
    BP.MergeTotalDebits,    
    BP.MergeTotalCredits,    
    BP.MergeAmtOfDispRelFromOTB,  
    BP.SysSubOrgID,  
    BP.DeAcctActivityDate,  
    BB.FreezeDelinquency,  
    BP.CreditBalanceDate, --JIRA 11884  
    BB.LateChargesCC1,  --JIRA Plat_33018  
    BB.LateFeeCreditCC1   
   from Bsegment_primary BP   with(index (IDX_Bsegment_primary_InstID_BC_LastSTMT),nolock)    
   Join BSegment_Balances BB  with(nolock) On BP.Acctid = BB.Acctid   
   Where BillingCycle <>'LTD' and   (laststatementdate is null or laststatementdate!= @Businessday) and institutionid = @OrgAcctid     and   Bp.acctid  between    @MinAcctid  and   @MaxAcctid   
  END  
 ELSE  
  BEGIN  
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
    LastPmtdate,  
    AmountOfPurchasesLTD,  
    BP.AmtOfDispRelFromOTB,  --Added Index hints for the BillingCycle and InstitutionId column, because without hints index, it is doing index scand and not using existing index.  
    BP.AmountOfReturnsLTD,  
    BP.LAPD,  
    BP.SCRAEffectiveDate,  
    PODID,  
    BP.MergePendingOTB,     
    BP.MergeDisputeAmtNS,    
    BP.MergeTotalDebits,    
    BP.MergeTotalCredits,    
    BP.MergeAmtOfDispRelFromOTB,  
    BP.SysSubOrgID,  
    BP.DeAcctActivityDate,  
    BB.FreezeDelinquency,  
    BP.CreditBalanceDate, --JIRA 11884  
    BB.LateChargesCC1,  --JIRA Plat_33018  
    BB.LateFeeCreditCC1   
   from Bsegment_primary BP   with(index (IDX_Bsegment_primary_InstitutionidBillingCycle),nolock)    
    Join BSegment_Balances BB  with(nolock) On BP.Acctid = BB.Acctid   
   Where BillingCycle <>'LTD' and institutionid = @OrgAcctid  and   Bp.acctid  between    @MinAcctid  and   @MaxAcctid   
  END  
  SET @LogCount  = @@rowcount  
 END  
  
  
  
  
 --set @LogCount  = @@rowcount  
 set @MinAcctid = @MaxAcctid  +1  
  
 if (@LogCount  > 0 )  
 BEGIN  
  
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
      FROM   cpscollateralinfo WITH(nolock)  
      WHERE  Tranid > 0  
             AND cideffectivedate < @BusinessDay  
             AND cideffectivedate < effectiveenddate  
             AND requestdate < @BusinessDay  
             AND institutionid = @OrgAcctid  
  
  
  
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
                   --lastactivitydateofbilling,  
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
       CashLmtAmt,  
       LastReportedInterestDate,  
       TestAccount,  
       AmountOfPurchasesLTD,  
       SysOrgId,  
       AmtOfDispRelFromOTB,  
       SRBWithInstallmentDue,  
       SBWithInstallmentDue,  
       InstallmentOutStgAmt,  
       CreditOutStgAmt,  
       ActualDRPStartDate,   
       StatusReason,  
       TotalAmountCO,  
       AfterCycleRevolvBSFC,  
       AccountGraceStatus,  
       AmountOfReturnsLTD,  
       LAPD,  
       EffectiveEndDate_Acct,  
       MinDueRequired,  
             SCRAEffectiveDate,  
             SCRAEndDate,  
       ReageStatus,  
       ReageStartDate,  
       ReageEndDate,  
       ReagePaymentAmt,  
       PODID,  
       DaysDelinquentNew,  
       DqTDRCounterYTD,  
       NonDqTDRCounterYTD,  
       InteragencyEligible,  
             PendingDqTDRCounterYTD,  
             PendingNonDqTDRCounterYTD,  
       MergedAccountID,  
       MergedAccountNumber,  
       AccountMergedByAccountID,  
       MergeDate,  
       MergePendingOTB,     
       MergeDisputeAmtNS,    
       MergeTotalDebits,    
       MergeTotalCredits,    
       MergeAmtOfDispRelFromOTB,  
       TCAPPaymentAmt,  
       TCAPStatus,  
             TCAPStartDate,  
       TCAPEndDate,  
       IsAcctSCRA,  
       RequestorID,  
       SysSubOrgID,  
       RequestorTimeStamp,  
       ClosedStatus,  
       DeAcctActivityDate,  
       IntBilledNotPaid,  
       StmtCTDCombination,  
       StmtEODCombination,  
     lastpmtdate, --JIRA 11884  
     CreditBalanceDate,  
     CBRRefundDate,  
     LateChargesCC1,  
     LateFeeCreditCTD,  
     LateFeeCreditCC1,  
     PaymentDuringProgram,  
     PaymentDuringProgramCTD,  
     OriginalSettlementAmount,  
     MonthlySettlementAmount,  
     BilledSettlementAmount,  
     ProgramStartDate,  
     ProgramEndDate)  
      SELECT @BusinessDay,  
             BP.acctid                         bsacctid,  
             BP.accountnumber,  
             BP.dateofnextstmt,  
             BP.laststatementdate,  
    /*Isnull(BP.laststatementdate, CASE  
                                            WHEN Datediff(ss, CONVERT(VARCHAR(10), BP.createdtime, 111), BP.createdtime) >= ( @TotalSecond + 1 ) THEN Dateadd(ss, @TotalSecond, CONVERT(VARCHAR(10), BP.createdtime, 111))  
                                            ELSE Dateadd(ss, @TotalSecond, Dateadd(d, -1, CONVERT(VARCHAR( 10 ), BP.createdtime, 111)))  
                                          END) AS laststatementdate *//*task-18140 */  
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
             --LA.lastactivitydateofbilling, --Commented by Monu  
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
          --   CASE WHEN BP.LAPD = @BusinessDay AND BCC.DaysDelinquent > 0 THEN BCC.DaysDelinquent - 1 ELSE BCC.DaysDelinquent END,--added for TD#244139  
            -- CASE WHEN BP.LAPD = @BusinessDay AND BCC.NoPayDaysDelinquent > 0 THEN BCC.NoPayDaysDelinquent - 1 ELSE BCC.NoPayDaysDelinquent END,--added for TD#244139  
   CASE WHEN BP.LAPD = @BusinessDay AND BCC.DaysDelinquent > 0 AND BP.freezeDelinquency = 1 THEN BCC.DaysDelinquent   
     when BP.LAPD = @BusinessDay AND BCC.DaysDelinquent > 0 THEN BCC.DaysDelinquent - 1   
     ELSE BCC.DaysDelinquent END,  
            CASE WHEN BP.LAPD = @BusinessDay AND BCC.NoPayDaysDelinquent > 0 AND BP.freezeDelinquency = 1 THEN BCC.NoPayDaysDelinquent   
     WHEN BP.LAPD = @BusinessDay AND BCC.NoPayDaysDelinquent > 0 THEN BCC.NoPayDaysDelinquent - 1   
     ELSE BCC.NoPayDaysDelinquent END,  
             BCC.DtOfLastDelinqCTD,  
             BCC.DateOfOriginalPaymentDueDTD,  
             BS.LateChargesLTD,  
             BCC.ChargeOffDate,--BCC.ChargeOffDateParam,   -- Added Chargeoffdate for cookie -208455  
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
    BCC.AccountOpenDate,--modified for TD#216111  
    BCC.WaiveInterest ,  
    BCC.WaiveInterestFor ,  
    BCC.WaiveInterestFrom ,  
    BCC.BSWFeeIntStartDate,  
    BS.CashLmtAmt,  
    BCC.LastReportedInterestDate,  
    BS.TestAccount,  
    BP.AmountOfPurchasesLTD,  
    BP.SysOrgID,  
    BP.AmtOfDispRelFromOTB,  
    BCC.SRBWithInstallmentDue,  
    BCC.SBWithInstallmentDue,  
    ABP.InstallmentOutStgAmt,  
    ABP.CreditOutStgAmt,  
    BCC.ActualDRPStartDate,   
    BCC.StatusReason,  
    BCC.TotalAmountCO,  
    BCC.AfterCycleRevolvBSFC,  
    CASE WHEN BCC.AccountGraceStatus IS NULL OR ltrim(rtrim(BCC.AccountGraceStatus)) = '' THEN 'T' ELSE BCC.AccountGraceStatus END,  
    BP.AmountOfReturnsLTD,  
    BP.LAPD,  
    BS.EffectiveEndDate_Acct,  
    BCC.MinDueRequired,  
       BP.SCRAEffectiveDate,  
       BCC.SCRAEndDate,  
    BCC.ReageStatus,  
    BCC.ReageStartDate,  
    BCC.ReageEndDate,  
    BCC.ReagePaymentAmt,  
    BP.PODID,  
    CASE WHEN (@CombineSTMTCTD='1' or BCC.StmtCTDCombination='1') and BP.LastStatementDate = @BusinessDay AND BCC.DaysDelinquentNew > 0 THEN BCC.DaysDelinquentNew - 1 ELSE BCC.DaysDelinquentNew END,  
    --BCC.DaysDelinquentNew,--added for TD#244139  
    BCC.DqTDRCounterYTD ,  
    BCC.NonDqTDRCounterYTD  ,  
    BCC.InteragencyEligible  ,  
       BCC.PendingDqTDRCounterYTD  ,  
       BCC.PendingNonDqTDRCounterYTD,  
    BS.MergedAccountID,  
       BS.MergedAccountNumber,  
    BS.AccountMergedByAccountID,  
    BS.MergeDate,  
    BP.MergePendingOTB,     
    BP.MergeDisputeAmtNS,    
    BP.MergeTotalDebits,    
    BP.MergeTotalCredits,    
    BP.MergeAmtOfDispRelFromOTB,  
    BCC.TCAPPaymentAmt,  
    BCC.TCAPStatus,  
    BCC.TCAPStartDate,  
    BCC.TCAPEndDate,  
    BS.IsAcctSCRA,  
    BS.RequestorID,  
    BP.SysSubOrgID,  
    BS.RequestorTimeStamp,  
    BS.ClosedStatus,  
    BP.DeAcctActivityDate,  
    BCC.IntBilledNotPaid,  
    BCC.StmtCTDCombination,  
    BCC.StmtEODCombination ,  
    BP.lastpaymentdate,  
    BP.CreditBalanceDate,  
    BS.CBRRefundDate,  
    BP.LateChargesCC1,  
    BCC.CTDLateFeesCredit,-- BS.LateFeeCreditCTD,  
    LateFeeCreditCC1,  
    BCC.PaymentDuringProgram,  
   BCC.PaymentDuringProgramCTD,  
   BCC.OriginalSettlementAmount,  
   BCC.MonthlySettlementAmount,  
   BCC.BilledSettlementAmount,  
   BCC.ProgramStartDate,  
   BCC.ProgramEndDate   
      FROM   #TempBsegmentPrimary BP WITH(nolock)  
             LEFT OUTER JOIN bsegment_secondary BS WITH(nolock)  
                          ON ( BP.acctid = BS.acctid )  
             -- AND --BP.CurrentBalance > 0 AND --BP.InstitutionID = 1042 AND --BP.SYSTemStatus <> 14 )              
             LEFT OUTER JOIN bsegmentcreditcard BCC WITH(nolock)  
                          ON ( BP.acctid = BCC.acctid )  
             LEFT OUTER JOIN syn_cauth_bsegment_primary ABP WITH(nolock)  
                          ON ( BP.acctid = ABP.acctid )  
             --LEFT JOIN #temp_lastactivitylog LA WITH(nolock) -- Commented by Monu, since we are not inserting any data in this temp table.  
                --    ON ( BP.acctid = LA.acctid )  
             LEFT OUTER JOIN BSegmentInsurance BI WITH(nolock)  
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
             FROM   CreditLimitAuditLog C WITH(index (idx_CBAuditLogAcctID), nolock)  
                    JOIN #TempBsegmentPrimary bp WITH(nolock)                        ON c.AcctID = Bp.Acctid  
       WHERE  C.clcreditlimittype=0  
             -- aasati WHERE  InstitutionID = @OrgAcctid  
    )  
    INSERT INTO #Temp_CLHistory(RowNumber,ClChangeDate,CLPrevValue,AcctID)  
    SELECT rownumber,CLRequestDate,CLOldValues,Acctid  
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
SELECT rownumber,BusinessDay,Acctid  
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
                   LateFeeCreditLTD,                     TotalAccruedInterest,  
                   AnticipatedInterest,  
       GraceDaysStatus,  
       GraceDayCutoffDate,  
       AccountGraceStatus,  
       TrailingInterestDate,  
       ActivityDay,  
       AmountOfPurchasesLTD,  
       InterestDefermentStatus,  
       DeferredAccruedFinal,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
       PromoTxnPeriodStartDate,  
       PromoTxnPeriodEndDate,  
       PromoPlanActive,  
       SRBWithInstallmentDue,  
       SBWithInstallmentDue,  
       IPOstartdate,  
       IPOenddate,  
       RetailAniversaryDate,  
       CreditPlanType,  
       AfterCycleRevolvBSFC,  
     HoldDisputeBSFCCycle1,  
     HoldDisputeBSFCCycle2,  
     HoldDisputeBSFCEndDateCycle1,  
     HoldDisputeBSFCEndDateCycle2,  
     AmountOfReturnsLTD,  
     MergeIndicator,  
     MergeDate,  
     StmtCTDCombination,  
     StmtEODCombination)  
      SELECT @BusinessDay,  
             CA.acctid                         cpsacctid,  
             BP.bsacctid                       bsacctid,  
             BP.accountnumber,  
             BP.dateofnextstmt,  
             BP.laststatementdate,  
    /*Isnull(BP.laststatementdate, CASE  
                                            WHEN Datediff(ss, CONVERT(VARCHAR(10), createdtime, 111), createdtime) >= ( @TotalSecond + 1 ) THEN Dateadd(ss, @TotalSecond, CONVERT(VARCHAR(10), createdtime, 111))  
                                            ELSE Dateadd(ss, @TotalSecond, Dateadd(d, -1, CONVERT(VARCHAR( 10 ), createdtime, 111)))  
                                          END) AS laststatementdate*//*task-18140 */  
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
    --WHEN DATEDIFF(DAY,BP.LAD,BP.BusinessDay) = 0   
    WHEN (   
     (BP.SysOrgId = 51 AND (BP.SysSubOrgID IS NULL OR BP.SysSubOrgID != 1) AND (DATEDIFF(DAY,BP.laststatementdate,BP.BusinessDay) = 0 OR DATEDIFF(DAY,BP.LastReportedInterestDate,BP.BusinessDay) = 0)) -- Plat  
     OR  
     (BP.SysOrgId = 7 AND DATEDIFF(DAY,BP.LAD,BP.BusinessDay) = 0 AND CC.InterestStartDate > BP.businessday) -- GreenSky  
     OR  
     ((BP.SysOrgId IS NULL OR BP.SysOrgId NOT IN (51,7)) AND DATEDIFF(DAY,BP.LAD,BP.BusinessDay) = 0) -- Other Client  
     OR  
     (BP.SysOrgId = 51 AND BP.SysSubOrgID = 1 AND DATEDIFF(DAY,BP.LAD,BP.BusinessDay) = 0) -- Jazz  
      )  
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
   ELSE 0 END AS ActivityDay,  
     CA.AmountOfPurchasesLTD,  
     CC.InterestDefermentStatus,  
     CC.DeferredAccruedFinal,  
      CC.PromoRateDuration,  
      CC.PromoStartDate,  
   CC.PromoRateEndDate,  
   cc.InterestRate1,  
   CC.PromoTxnPeriodStartDate,  
   CC.PromoTxnPeriodEndDate,  
   CC.PromoPlanActive,  
   CC.SRBWithInstallmentDue,  
   CC.SRBWithInstallmentDue,  
   CC.IPOstartdate,  
      CC.IPOenddate,  
   CC.RetailAniversaryDate,  
   CA.CreditPlanType,  
   CC.AfterCycleRevolvBSFC,    
   CC.HoldDisputeBSFCCycle1,  
   CC.HoldDisputeBSFCCycle2,  
   CC.HoldDisputeBSFCEndDateCycle1,  
   CC.HoldDisputeBSFCEndDateCycle2,  
   CA.AmountOfReturnsLTD,  
   CC.MergeIndicator,  
   CC.MergeDate,  
   BP.StmtCTDCombination,  
   BP.StmtEODCombination  
      FROM   cpsgmentaccounts CA WITH(nolock)  
             LEFT OUTER JOIN cpsgmentcreditcard CC WITH(nolock)  
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
                   AnticipatedInterest,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
       PromoTxnPeriodStartDate,  
       PromoTxnPeriodEndDate ,  
       PromoPlanActive,  
       CreditPlanType,  
       AfterCycleRevolvBSFC,     
     HoldDisputeBSFCCycle1,     
     HoldDisputeBSFCCycle2,   
     HoldDisputeBSFCEndDateCycle1,    
     HoldDisputeBSFCEndDateCycle2,  
     AmountOfReturnsLTD,  
     MergeIndicator,  
     MergeDate,  
     AccountGraceStatus,  
     StmtCTDCombination,  
     StmtEODCombination)  
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
             CC.AnticipatedInterest,  
    CC. PromoRateDuration,  
    CC.PromoStartDate,  
    CC.PromoRateEndDate,  
    CC.InterestRate1,  
    CC.PromoTxnPeriodStartDate,  
    CC.PromoTxnPeriodEndDate,  
     CC.PromoPlanActive,  
    CA.CreditPlanType,  
    CC.AfterCycleRevolvBSFC,    
   CC.HoldDisputeBSFCCycle1,   
   CC.HoldDisputeBSFCCycle2,  
   CC.HoldDisputeBSFCEndDateCycle1,   
   CC.HoldDisputeBSFCEndDateCycle2,  
   CA.AmountOfReturnsLTD,  
   CC.MergeIndicator,  
   CC.MergeDate,  
   CC.AccountGraceStatus,  
   AIR.StmtCTDCombination,  
   AIR.StmtEODCombination  
      FROM   cpsgmentaccounts CA WITH(nolock)  
             LEFT OUTER JOIN cpsgmentcreditcard CC WITH(nolock)  
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
  
      -----------------------------------Insert into Temp #RecurringRecordAccount table-----------------------------------------------          
  
      INSERT INTO #recurringrecordaccount  
      SELECT Row_number()  
               OVER (  
                 partition BY RF.txnacctid  
                 ORDER BY RF.nextfeedate) rownum,  
             C.cpsacctid,  
             RF.nextfeedate  
      --INTO   #recurringrecordaccount          
      FROM   recurringfeerecord RF WITH(nolock)  
             JOIN feeforscaccounts FFS WITH(nolock)  
               ON( RF.feesacctid = FFS.acctid  
                   AND RF.status = 'OPEN'  
                   AND RF.nextfeedate >= @BusinessDay )  
             JOIN syn_kbcl_feescatalogaccounts FC WITH(nolock)  
               ON( FFS.parent02aid = FC.acctid )  
             JOIN #planinfoforaccount C WITH(nolock)  
               ON( C.cpsacctid = RF.txnacctid )  
  
      -- and C.BusinessDay=@BusinessDay and C.InstitutionID=@OrgAcctid)            
  
      UPDATE c  
      SET    c.nextfeedate = RF.nextfeedate  
      FROM   #planinfoforaccount C  
             JOIN #recurringrecordaccount RF WITH(nolock)  
               ON( C.cpsacctid = RF.cpsacctid  
                   AND RF.rownum = 1  
                   AND C.businessday = @BusinessDay  
                   AND RF.SeqID > 0 )  
  
      -----------------------------------Insert into Temp #recurringrecordplan table-----------------------------------------------          
  
  
      INSERT INTO #recurringrecordplan  
      SELECT Row_number()  
               OVER (  
                 partition BY RF.txnacctid  
                 ORDER BY RF.nextfeedate) rownum,  
             C.cpsacctid,  
             RF.nextfeedate  
      --INTO   #recurringrecordplan          
      FROM   recurringfeerecord RF WITH(nolock)  
             JOIN feeforscaccounts FFS WITH(nolock)  
               ON( RF.feesacctid = FFS.acctid  
                   AND RF.[status] = 'OPEN'  
                   AND RF.nextfeedate >= @BusinessDay )  
             JOIN syn_kbcl_feescatalogaccounts FC WITH(nolock)  
               ON( FFS.parent02aid = FC.acctid )  
             JOIN #planinfoforreport C WITH(nolock)  
               ON( C.cpsacctid = RF.txnacctid )  
  
      -- and C.BusinessDay=@BusinessDay and C.InstitutionID=@OrgAcctid)            
  
      --PRINT '8'             
                
      UPDATE c  
      SET    c.nextfeedate = RF.nextfeedate  
      FROM   #planinfoforreport C  
             JOIN #recurringrecordplan RF WITH(nolock)  
               ON( C.cpsacctid = RF.cpsacctid  
                   AND RF.rownum = 1  
                   AND C.businessday = @BusinessDay )  
     
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
  
      -----------------------------------Insert into Temp #CustomerLoyaltyInfoForReport table-----------------------------------------------          
      INSERT INTO #CustomerLoyaltyInfoForReport  
                  (BusinessDay,  
                   InstitutionID,  
                   BSAcctid,  
                   LPSAcctid,  
       CustomerId,  
       PartnerId,  
       ClientId,  
                   LPSProgramID,  
                   Points,  
                   OneLoyaltyPointIsEqualTo)  
      SELECT @BusinessDay,  
             BP.InstitutionID,  
             BP.AcctID,  
             LCD.LPSAcctId,  
    LCD.CustomerId,  
    LCD.PartnerId,  
    LCD.ClientId,  
             LP.AcctID,  
             LCD.CurrentBalance,  
             LP.mPPOneLoyaltyPointIsEqualTo  
      FROM   LPSCustomerDetails LCD WITH(NOLOCK)  
             INNER JOIN #TempBsegmentPrimary BP WITH(NOLOCK)  
                     ON BP.AcctID = LCD.BsAcctid  
                        -- aasati AND BP.InstitutionID = @OrgAcctid  
             LEFT JOIN LPACCOUNTS LP WITH(NOLOCK)  
                    ON LCD.LoyaltyProgramName = LP.AcctID  
  
      --PRINT '9'        
  
      --------------------------------------------Update Due Buckets from StatementHeader if BusinessDay = StatementDate.Ref TD 177303------------------------------------------------      
        
   /*  
  
   UPDATE AIR  
      SET    AIR.DaysDelinquent = SE.DaysDelinquent,  
    AIR.TotalDaysDelinquent = SE.NoPayDaysDelinquent,  
    AIR.DateOfDelinquency = SE.DtOfLastDelinqCTD,  
    AIR.AmtOfPayCurrDue = SH.AmtOfPayCurrDue,  
             AIR.AmtOfPayXDLate = SH.AmtOfPayXDLate,  
             AIR.AmountOfPayment30DLate = SH.AmountOfPayment30DLate,  
             AIR.AmountOfPayment60DLate = SH.AmountOfPayment60DLate,  
             AIR.AmountOfPayment90DLate = SH.AmountOfPayment90DLate,  
             AIR.AmountOfPayment120DLate = SH.AmountOfPayment120DLate,  
             AIR.AmountOfPayment150DLate = SH.AmountOfPayment150DLate,  
             AIR.AmountOfPayment180DLate = SH.AmountOfPayment180DLate,  
             AIR.AmountOfPayment210DLate = SH.AmountOfPayment210DLate,  
    AIR.ActualDRPStartDate      = SH.ActualDRPStartDate, --Added on StatementHeader to Update on Businessday = LastStatementDate  
    AIR.ccinhparent125AID       = SH.ccinhparent125AID,   --Added on StatementHeader to Update on Businessday = LastStatementDate  
    AIR.CurrentBalance     = SH.CurrentBalance,  
    AIR.Principal      = SH.Principal,  
    AIR.AmountOfTotalDue    = SH.AmountOfTotalDue,  
    AIR.SystemStatus     = SH.SystemStatus,  
    AIR.CycleDueDTD     = SH.CycleDueDTD,  
    AIR.DateOfTotalDue     = SH.DateOfTotalDue,  
    AIR.CreditLimit     = SH.CreditLimit,  
    AIR.TotalOutStgAuthAmt    = SH.TotalOutStgAuthAmt,  
    AIR.PendingOTB      = SE.PendingOTB,  
    AIR.recoveryfeesbnp    = SH.recoveryfeesbnp,  
    AIR.RecoveryFeesCTD    = SH.RecoveryFeesCTD,  
    AIR.DateOfOriginalPaymentDueDTD    = SH.DateOfOriginalPaymentDueDTD,  
    AIR.AmountOfDebitsCTD              = SH.AmountOfDebitsCTD,  
    AIR.AmountOfCreditsCTD             = SH.AmountOfCreditsCTD,  
    AIR.DisputesAmtNS                  = SH.DisputesAmtNS,  
    AIR.SystemChargeOffStatus          = SH.SystemChargeOffStatus,  
    AIR.AmtOfInterestYTD               = SH.AmtOfInterestYTD,  
    AIR.userchargeoffstatus            = SH.userchargeoffstatus,  
    AIR.CurrentBalanceCo               = SH.CurrentBalanceCo,  
    AIR.ManualInitialChargeOffReason   = SH.ManualInitialChargeOffReason,  
    AIR.AutoInitialChargeOffReason     = SH.AutoInitialChargeOffReason,  
    AIR.AmountOfPurchasesLTD           = SH.AmountOfPurchasesLTD,  
    AIR.AmtOfDispRelFromOTB            = SH.AmtOfDispRelFromOTB,  
    AIR.SRBWithInstallmentDue          = SH.SRBWithInstallmentDue,  
    AIR.SBWithInstallmentDue           = SH.SBWithInstallmentDue,  
    AIR.LAD       = CASE WHEN ( @CombineSTMTCTD = '1') then SH.StatementDate ELSE  AIR.LAD end,  
    AIR.LAPD       = CASE WHEN ( @CombineSTMTCTD = '1') then SH.StatementDate ELSE  AIR.LAPD end,  
    AIR.AmountOfPaymentsMTD   = CASE WHEN (@CombineSTMTCTD = '1') then SE.AmountOfPaymentsMTD ELSE  AIR.AmountOfPaymentsMTD end,  
    AIR.ccinhparent127aid    = SH.ccinhparent127AID,  
    AIR.IntBilledNotPaid    = SH.intBilledNotPaid  
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
                    AND SH.StatementID = SE.StatementID)   */  
  
       
   UPDATE AIR  
      SET    AIR.DaysDelinquent = SH.DaysDelinquent_STMT,  
    AIR.TotalDaysDelinquent = SH.NoPayDaysDelinquent_STMT,  
    AIR.DateOfDelinquency = SH.DtOfLastDelinqCTD_STMT,  
    AIR.AmtOfPayCurrDue = SH.AmtOfPayCurrDue_STMT,  
             AIR.AmtOfPayXDLate = SH.AmtOfPayXDLate_STMT,  
             AIR.AmountOfPayment30DLate = SH.AmountOfPayment30DLate_STMT,  
             AIR.AmountOfPayment60DLate = SH.AmountOfPayment60DLate_STMT,  
             AIR.AmountOfPayment90DLate = SH.AmountOfPayment90DLate_STMT,  
             AIR.AmountOfPayment120DLate = SH.AmountOfPayment120DLate_STMT,  
             AIR.AmountOfPayment150DLate = SH.AmountOfPayment150DLate_STMT,  
             AIR.AmountOfPayment180DLate = SH.AmountOfPayment180DLate_STMT,  
             AIR.AmountOfPayment210DLate = SH.AmountOfPayment210DLate_STMT,  
    AIR.ActualDRPStartDate      = SH.ActualDRPStartDate_STMT, --Added on StatementHeader to Update on Businessday = LastStatementDate  
    AIR.ccinhparent125AID       = SH.ccinhparent125AID_STMT,   --Added on StatementHeader to Update on Businessday = LastStatementDate  
    AIR.CurrentBalance     = SH.CurrentBalance_STMT,  
    AIR.Principal      = SH.Principal_STMT,  
    AIR.AmountOfTotalDue    = SH.AmountOfTotalDue_STMT,  
    AIR.SystemStatus     = SH.SystemStatus_STMT,  
    AIR.CycleDueDTD     = SH.CycleDueDTD_STMT,  
    AIR.DateOfTotalDue     = SH.DateOfTotalDue_STMT,  
    AIR.CreditLimit     = SH.CreditLimit_STMT,  
    AIR.TotalOutStgAuthAmt    = SH.TotalOutStgAuthAmt_STMT,  
    AIR.PendingOTB      = SH.PendingOTB_STMT,  
    AIR.recoveryfeesbnp    = SH.recoveryfeesbnp_STMT,  
    AIR.RecoveryFeesCTD    = SH.RecoveryFeesCTD_STMT,  
    AIR.DateOfOriginalPaymentDueDTD    = SH.DateOfOriginalPaymentDueDTD_STMT,  
    AIR.AmountOfDebitsCTD              = SH.AmountOfDebitsCTD_STMT,  
    AIR.AmountOfCreditsCTD             = SH.AmountOfCreditsCTD_STMT,  
    AIR.DisputesAmtNS                  = SH.DisputesAmtNS_STMT,  
    AIR.SystemChargeOffStatus          = SH.SystemChargeOffStatus_STMT,  
    AIR.AmtOfInterestYTD               = SH.AmtOfInterestYTD_STMT,  
    AIR.userchargeoffstatus            = SH.userchargeoffstatus_STMT,  
    AIR.CurrentBalanceCo      = SH.CurrentBalanceCo_STMT,  
    AIR.ManualInitialChargeOffReason   = SH.ManualInitialChargeOffReason_STMT,  
    AIR.AutoInitialChargeOffReason     = SH.AutoInitialChargeOffReason_STMT,  
    AIR.AmountOfPurchasesLTD           = SH.AmountOfPurchasesLTD_STMT,  
    AIR.AmtOfDispRelFromOTB            = SH.AmtOfDispRelFromOTB_STMT,  
    AIR.SRBWithInstallmentDue          = SH.SRBWithInstallmentDue_STMT,  
    AIR.SBWithInstallmentDue           = SH.SBWithInstallmentDue_STMT,  
    AIR.LAD       = CASE WHEN ( @CombineSTMTCTD = '1' or AIR.StmtCTDCombination='1') then SH.LAD_STMT ELSE  AIR.LAD end,  
    AIR.LAPD       = CASE WHEN ( @CombineSTMTCTD = '1' or AIR.StmtCTDCombination='1') then SH.LAPD_STMT ELSE  AIR.LAPD end,  
    AIR.AmountOfPaymentsMTD   = CASE WHEN (@CombineSTMTCTD = '1' or AIR.StmtCTDCombination='1') then SH.AmountOfPaymentsMTD_STMT ELSE  AIR.AmountOfPaymentsMTD end,  
    AIR.ccinhparent127aid    = SH.ccinhparent127aid_STMT,  
    AIR.IntBilledNotPaid    = SH.IntBilledNotPaid_STMT  
      FROM   #AccountInfoForReport AIR  
             JOIN BSegmentCreditCard SH WITH(NOLOCK)  
               ON ( AIR.LastStatementDate = @BusinessDay  
                    AND AIR.BSAcctid = SH.acctId)  
  
  /*  
      UPDATE PIR  
      SET    PIR.AmtOfPayCurrDue = SHCC.CurrentDue,  
             PIR.AmtOfPayXDLate = SHCC.AmtOfPayXDLate,  
             PIR.AmountOfPayment30DLate = SHCC.AmountOfPayment30DLate,  
             PIR.AmountOfPayment60DLate = SHCC.AmountOfPayment60DLate,  
             PIR.AmountOfPayment90DLate = SHCC.AmountOfPayment90DLate,  
             PIR.AmountOfPayment120DLate = SHCC.AmountOfPayment120DLate,  
             PIR.AmountOfPayment150DLate = SHCC.AmountOfPayment150DLate,  
             PIR.AmountOfPayment180DLate = SHCC.AmountOfPayment180DLate,  
             PIR.AmountOfPayment210DLate = SHCC.AmountOfPayment210DLate,  
    PIR.CurrentBalance          = SH.CurrentBalance,  
    PIR.Principal               = SH.Principal,  
    PIR.AmountOfTotalDue        = SH.AmountOfTotalDue,  
    PIR.IntBilledNotPaid        = SH.IntBilledNotPaid,  
    PIR.AmtOfInterestCTD        = SH.AmtOfInterestCTD,  
    PIR.recoveryfeesbnp         = SH.recoveryfeesbnp,  
    PIR.RecoveryFeesCTD         = SH.RecoveryFeesCTD,  
    PIR.AmountOfPurchasesLTD    = SH.AmountOfPurchasesLTD,  
    PIR.AmountOfReturnsLTD      = SH.AmountOfReturnsLTD,  
    PIR.CurrentBalanceCO        = SHCC.CurrentBalanceCO,  
    PIR.SRBWithInstallmentDue   = SHCC.SRBWithInstallmentDue,  
    PIR.SBWithInstallmentDue    = SHCC.SBWithInstallmentDue,  
    PIR.RetailAniversaryDate    = SHCC.RetailAniversaryDate,  
    PIR.LAD      = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.StatementDate ELSE  PIR.LAD end,  
    PIR.DaysinCycle    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.DaysinCycle ELSE  PIR.DaysinCycle end,   
    PIR.RevolvingBSFC    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.RevolvingBSFC ELSE  PIR.RevolvingBSFC end,  
    PIR.RevolvingAgg            = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.RevolvingAgg ELSE  PIR.RevolvingAgg end,   
    PIR.NewTransactionsBSFC     = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.NewTransactionsBSFC ELSE  PIR.NewTransactionsBSFC end,  
    PIR.newtranagg     = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.NewTransactionsAgg ELSE  PIR.NewTranAgg end,  
    PIR.newtranaccrued          = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.NewTransactionsAccrued ELSE  PIR.NewTranAccrued end,  
    PIR.RevolvingAccrued   = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.RevolvingAccrued ELSE  PIR.RevolvingAccrued end,  
    PIR.TotalAccruedInterest    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SHCC.TotalAccruedInterest ELSE  PIR.TotalAccruedInterest end   
      FROM   #PlanInfoForReport PIR  
             JOIN SummaryHeader SH WITH(NOLOCK)  
               ON ( PIR.LastStatementDate = @BusinessDay  
                    AND PIR.CPSAcctid = SH.acctId  
                    AND SH.StatementDate = @BusinessDay )  
             JOIN SummaryHeaderCreditCard SHCC WITH(NOLOCK)  
               ON ( SH.acctId = SHCC.acctId  
                    AND SH.StatementID = SHCC.StatementID )     */  
  
   UPDATE PIR  
      SET    PIR.AmtOfPayCurrDue = SH.AmtOfPayCurrDue_Summary,  
             PIR.AmtOfPayXDLate = SH.AmtOfPayXDLate_Summary,  
             PIR.AmountOfPayment30DLate = SH.AmountOfPayment30DLate_Summary,  
             PIR.AmountOfPayment60DLate = SH.AmountOfPayment60DLate_Summary,  
             PIR.AmountOfPayment90DLate = SH.AmountOfPayment90DLate_Summary,  
             PIR.AmountOfPayment120DLate = SH.AmountOfPayment120DLate_Summary,  
             PIR.AmountOfPayment150DLate = SH.AmountOfPayment150DLate_Summary,  
             PIR.AmountOfPayment180DLate = SH.AmountOfPayment180DLate_Summary,  
             PIR.AmountOfPayment210DLate = SH.AmountOfPayment210DLate_Summary,  
    PIR.CurrentBalance          = SH.CurrentBalance_Summary,  
    PIR.Principal               = SH.Principal_Summary,  
    PIR.AmountOfTotalDue        = SH.AmountOfTotalDue_Summary,  
    PIR.IntBilledNotPaid        = SH.IntBilledNotPaid_Summary,  
    PIR.AmtOfInterestCTD        = SH.AmtOfInterestCTD_Summary,  
    PIR.recoveryfeesbnp         = SH.recoveryfeesbnp_Summary,  
    PIR.RecoveryFeesCTD         = SH.RecoveryFeesCTD_Summary,  
    PIR.AmountOfPurchasesLTD    = SH.AmountOfPurchasesLTD_Summary,  
    PIR.AmountOfReturnsLTD      = SH.AmountOfReturnsLTD_Summary,  
    PIR.CurrentBalanceCO        = SH.CurrentBalanceCO_Summary,  
    PIR.SRBWithInstallmentDue   = SH.SRBWithInstallmentDue_Summary,  
    PIR.SBWithInstallmentDue    = SH.SBWithInstallmentDue_Summary,  
    PIR.RetailAniversaryDate    = SH.RetailAniversaryDate_Summary,  
    PIR.LAD      = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.LAD_Summary ELSE  PIR.LAD end,  
    PIR.DaysinCycle    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.DaysinCycle_Summary ELSE  PIR.DaysinCycle end,   
    PIR.RevolvingBSFC    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.RevolvingBSFC_Summary ELSE  PIR.RevolvingBSFC end,  
    PIR.RevolvingAgg            = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.RevolvingAgg_Summary ELSE  PIR.RevolvingAgg end,   
    PIR.NewTransactionsBSFC     = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.NewTransactionsBSFC_Summary ELSE  PIR.NewTransactionsBSFC end,  
    PIR.newtranagg     = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.newtranagg_Summary ELSE  PIR.NewTranAgg end,  
    PIR.newtranaccrued          = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.newtranaccrued_Summary ELSE  PIR.NewTranAccrued end,  
    PIR.RevolvingAccrued   = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.RevolvingAccrued_Summary ELSE  PIR.RevolvingAccrued end,  
    PIR.TotalAccruedInterest    = CASE WHEN ( @CombineSTMTCTD = '1'  or PIR.StmtCTDCombination='1') then SH.TotalAccruedInterest_Summary ELSE  PIR.TotalAccruedInterest end   
      FROM   #PlanInfoForReport PIR  
             JOIN CPSgmentCreditCard SH WITH(NOLOCK)  
               ON ( PIR.LastStatementDate = @BusinessDay  
                    AND PIR.CPSAcctid = SH.acctId )  
  
     /* UPDATE PIA  
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
                    AND SH.StatementID = SHCC.StatementID )*/  
  
      UPDATE PIA  
      SET    PIA.AmtOfPayCurrDue = SH.AmtOfPayCurrDue_Summary,  
             PIA.AmtOfPayXDLate = SH.AmtOfPayXDLate_Summary,  
             PIA.AmountOfPayment30DLate = SH.AmountOfPayment30DLate_Summary,  
             PIA.AmountOfPayment60DLate = SH.AmountOfPayment60DLate_Summary,  
             PIA.AmountOfPayment90DLate = SH.AmountOfPayment90DLate_Summary,  
             PIA.AmountOfPayment120DLate = SH.AmountOfPayment120DLate_Summary,  
             PIA.AmountOfPayment150DLate = SH.AmountOfPayment150DLate_Summary,  
             PIA.AmountOfPayment180DLate = SH.AmountOfPayment180DLate_Summary,  
             PIA.AmountOfPayment210DLate = SH.AmountOfPayment210DLate_Summary  
      FROM   #PlanInfoForAccount PIA  
   JOIN CPSgmentCreditCard SH WITH(NOLOCK)  
      ON ( PIA.LastStatementDate = @BusinessDay  
                    AND PIA.CPSAcctid = SH.acctId )  
     
     
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
                         --LastActivityDateOfBilling,  
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
      BSWFeeIntStartDate,  
      CashLmtAmt,  
      LastReportedInterestDate,  
      AmountOfPurchasesLTD,  
      AmtOfDispRelFromOTB,  
      SRBWithInstallmentDue,  
      SBWithInstallmentDue,  
      InstallmentOutStgAmt,  
       CreditOutStgAmt,  
       pendingotb,  
       ActualDRPStartDate,  
       StatusReason,  
       TotalAmountCO,  
       AfterCycleRevolvBSFC,  
       AccountGraceStatus,  
       AmountOfReturnsLTD,  
       LAPD,  
       EffectiveEndDate_Acct,  
       MinDueRequired,  
                   SCRAEffectiveDate,  
                   SCRAEndDate,  
       ReageStatus,  
       ReageStartDate,  
       ReageEndDate,  
       ReagePaymentAmt,  
       PODID,  
       DaysDelinquentNew,  
       DqTDRCounterYTD,  
             NonDqTDRCounterYTD,  
             InteragencyEligible,  
                   PendingDqTDRCounterYTD,  
                   PendingNonDqTDRCounterYTD ,  
       MergedAccountID,  
       MergedAccountNumber,  
       AccountMergedByAccountID,  
       MergeDate,  
       MergePendingOTB,     
       MergeDisputeAmtNS,    
       MergeTotalDebits,    
       MergeTotalCredits,    
       MergeAmtOfDispRelFromOTB,  
       TCAPPaymentAmt,  
       TCAPStatus,  
       TCAPStartDate,  
       TCAPEndDate,  
       IsAcctSCRA,  
       RequestorID ,  
       RequestorTimeStamp,  
       ClosedStatus,  
       DeAcctActivityDate,  
       IntBilledNotPaid,  
       lastpmtdate, --JIRA 11884  
       CreditBalanceDate,  
       CBRRefundDate,  
       LateChargesCC1,  
       LateFeeCreditCTD,  
       LateFeeCreditCC1,  
       PaymentDuringProgram,  
      PaymentDuringProgramCTD,  
      OriginalSettlementAmount,  
      MonthlySettlementAmount,  
      BilledSettlementAmount,  
      ProgramStartDate,  
      ProgramEndDate)  
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
                   --LastActivityDateOfBilling,  
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
     BSWFeeIntStartDate,  
     CashLmtAmt,  
     LastReportedInterestDate,  
     AmountOfPurchasesLTD,  
     AmtOfDispRelFromOTB,  
     SRBWithInstallmentDue,  
     SBWithInstallmentDue,  
        InstallmentOutStgAmt,  
        CreditOutStgAmt,  
     pendingotb,  
     ActualDRPStartDate,  
     StatusReason,  
     TotalAmountCO ,  
     AfterCycleRevolvBSFC,  
     AccountGraceStatus,  
     AmountOfReturnsLTD,  
     LAPD,  
     EffectiveEndDate_Acct,  
     MinDueRequired,  
              SCRAEffectiveDate,  
              SCRAEndDate,  
     ReageStatus,  
     ReageStartDate,  
     ReageEndDate,  
     ReagePaymentAmt,  
     PODID,  
     DaysDelinquentNew,  
     DqTDRCounterYTD,  
        NonDqTDRCounterYTD,  
        InteragencyEligible,  
              PendingDqTDRCounterYTD,  
              PendingNonDqTDRCounterYTD,  
     MergedAccountID,  
     MergedAccountNumber,  
     AccountMergedByAccountID,  
     MergeDate,  
     MergePendingOTB,     
     MergeDisputeAmtNS,    
     MergeTotalDebits,    
     MergeTotalCredits,    
     MergeAmtOfDispRelFromOTB,  
        TCAPPaymentAmt,  
        TCAPStatus,  
              TCAPStartDate,  
        TCAPEndDate,  
     IsAcctSCRA,  
     RequestorID,  
     RequestorTimeStamp,  
     ClosedStatus,  
     DeAcctActivityDate,  
     IntBilledNotPaid,  
     lastpmtdate, --JIRA 11884  
     CreditBalanceDate,  
     CBRRefundDate,  
     LateChargesCC1,  
     LateFeeCreditCTD,  
     LateFeeCreditCC1,  
     PaymentDuringProgram,  
     PaymentDuringProgramCTD,  
     OriginalSettlementAmount,  
     MonthlySettlementAmount,  
     BilledSettlementAmount,  
     ProgramStartDate,  
     ProgramEndDate  
            FROM   #accountinfoforreport  
           -- WHERE  bsacctid >= @MinAcctid  
                   --AND bsacctid <= @MaxAcctid  
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
       ActivityDay,  
       AmountOfPurchasesLTD,  
       InterestDefermentStatus,  
       DeferredAccruedFinal,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
      PromoTxnPeriodStartDate,  
      PromoTxnPeriodEndDate,  
      PromoPlanActive,  
      SRBWithInstallmentDue,  
      SBWithInstallmentDue,  
      IPOstartdate,  
      IPOenddate,  
      RetailAniversaryDate,  
      CreditPlanType,  
      AfterCycleRevolvBSFC,     
      HoldDisputeBSFCCycle1,    
      HoldDisputeBSFCCycle2,   
      HoldDisputeBSFCEndDateCycle1,   
      HoldDisputeBSFCEndDateCycle2,  
      AmountOfReturnsLTD,  
      MergeIndicator,  
      MergeDate,  
      InstitutionID )  
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
       ActivityDay,  
       AmountOfPurchasesLTD,  
       InterestDefermentStatus,  
       DeferredAccruedFinal,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
       PromoTxnPeriodStartDate,  
       PromoTxnPeriodEndDate,  
       PromoPlanActive,  
       SRBWithInstallmentDue,  
       SBWithInstallmentDue,  
       IPOstartdate,  
       IPOenddate,  
       RetailAniversaryDate,  
       CreditPlanType,  
       AfterCycleRevolvBSFC,     
    HoldDisputeBSFCCycle1,    
    HoldDisputeBSFCCycle2,   
    HoldDisputeBSFCEndDateCycle1,   
    HoldDisputeBSFCEndDateCycle2,  
    AmountOfReturnsLTD,  
    MergeIndicator,  
    MergeDate,  
    InstitutionID  
            FROM   #planinfoforreport  
           -- WHERE  bsacctid >= @MinAcctid  
                   --AND bsacctid <= @MaxAcctid  
     
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
                         AnticipatedInterest,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
       PromoTxnPeriodStartDate,  
       PromoTxnPeriodEndDate,  
       PromoPlanActive,  
       CreditPlanType,  
       AfterCycleRevolvBSFC,     
      HoldDisputeBSFCCycle1,    
      HoldDisputeBSFCCycle2,   
      HoldDisputeBSFCEndDateCycle1,   
      HoldDisputeBSFCEndDateCycle2,  
      AmountOfReturnsLTD,  
      MergeIndicator,  
      MergeDate,  
      AccountGraceStatus)  
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
                   AnticipatedInterest,  
       PromoRateDuration,  
       PromoStartDate,  
       PromoRateEndDate,  
       InterestRate1,  
       PromoTxnPeriodStartDate,  
       PromoTxnPeriodEndDate,  
       PromoPlanActive,  
       CreditPlanType,  
       AfterCycleRevolvBSFC,     
     HoldDisputeBSFCCycle1,    
     HoldDisputeBSFCCycle2,   
     HoldDisputeBSFCEndDateCycle1,   
     HoldDisputeBSFCEndDateCycle2,  
     AmountOfReturnsLTD,  
     MergeIndicator,  
     MergeDate,  
     AccountGraceStatus  
            FROM   #planinfoforaccount  
           -- WHERE  bsacctid >= @MinAcctid  
              --     AND bsacctid <= @MaxAcctid  
  
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
            --WHERE  bsacctid >= @MinAcctid  
                --   AND bsacctid <= @MaxAcctid  
  
            -----------------------------------Insert into Physical table CustomerLoyaltyInfoForReport-----------------------------------------------                
            INSERT INTO CustomerLoyaltyInfoForReport   
                        (BusinessDay,  
                         InstitutionID,  
                         BSAcctid,  
                         LPSAcctid,  
       CustomerId,  
       PartnerId,  
       ClientId,  
                         LPSProgramID,  
                         Points,  
                         OneLoyaltyPointIsEqualTo)  
            SELECT BusinessDay,  
                   InstitutionID,  
                   BSAcctid,  
                   LPSAcctid,  
       CustomerId,  
       PartnerId,  
       ClientId,  
                   LPSProgramID,  
                   Points,  
                   OneLoyaltyPointIsEqualTo  
            FROM   #CustomerLoyaltyInfoForReport  
           -- WHERE  bsacctid >= @MinAcctid  
               --    AND bsacctid <= @MaxAcctid  
  
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
   From #TempBsegmentPrimary BP with(nolock)  
    JOIN BSCBRIndicatorDetail BCBR WITH(nolock) ON ( BP.acctid = BCBR.acctid AND BCBR.CBRIndicator in(1,6,7,8) AND BP.laststatementdate Is Not Null AND BP.Sysorgid = 7)    
    left JOIN CCardLookUp CLU With(nolock) on CLU.LutCode = BP.parent05aid AND CLU.LUTid = 'MerchantName'    
   WHERE -- BP.acctid >= @MinAcctid    
                   --AND BP.acctid <= @MaxAcctid   
        --AND  
      (BP.parent05aid <> 17250 or CLU.LutDescription <> 'Test Provider')  
  
   Update CBRME  
   Set CBRME.totalamountco =  BCC.totalamountco ,  
    CBRME.CollateralID = BCC.CollateralID  
   From CBRMonthEndTable CBRME With(Nolock)   
   Join bsegmentcreditcard BCC WITH(nolock) On BCC.acctId = CBRME.acctId   
   Join #TempBsegmentPrimary BP WITH(nolock) On BP.acctId = BCC.acctId   
   Where --CBRME.acctid >= @MinAcctid    
                  -- AND CBRME.acctid <= @MaxAcctid   
       --AND  
        CBRME.CBRMonthEnd = @BusinessDay   
    
   Update CBRME  
   Set CBRME.CBRComplianceCode   = BS.CBRComplianceCode,  
    CBRME.AcctInCollectionsSystem = BS.AcctInCollectionsSystem  
   From CBRMonthEndTable CBRME With(Nolock)   
   JOIN bsegment_secondary BS WITH(nolock)  ON ( CBRME.acctid = BS.acctid )    
   Join #TempBsegmentPrimary BP WITH(nolock) On BP.acctId = BS.acctId   
   Where   
    --CBRME.acctid >= @MinAcctid    
                  -- AND CBRME.acctid <= @MaxAcctid   
       --AND   
       CBRME.CBRMonthEnd = @BusinessDay   
  
   Update CBRME  
   Set  CBRME.Primary_Borrower_Surname     = Cst.LastName,--CBR  
     CBRME.Primary_Borrower_First_Name    = Cst.FirstName,--CBR  
     CBRME.Primary_Borrower_Middle_Name    = Cst.MiddleName,--CBR  
     CBRME.Primary_Borrower_Generation_Code   = Cst.SNSuffix,--CBR  
     CBRME.Primary_Borrower_Social_Security_Number = Cst.SocialSecurityNumber,--CBR  
     CBRME.Primary_Borrower_Date_Of_Birth   = Cst.DateofBirth,--CBR  
     CBRME.Primary_Borrower_Telephone_Number   = Cst.HomePhoneNumber,--CBR  
     CBRME.Primary_Borrower_Ecoa_Code    = CASE When Cst.COA_FirstName Is NULL Then '1' Else '2' END,--CBR  
     CBRME.CO_Borrower_Surname      = Cst.COA_LastName,--CBR  
     CBRME.CO_Borrower_First_Name     = Cst.COA_FirstName,--CBR  
     CBRME.CO_Borrower_Middle_Name     = Cst.COA_MiddleName,--CBR  
     CBRME.CO_Borrower_Generation_Code    = Cst.COA_SurnameSuffix,--CBR  
     CBRME.CO_Borrower_SSN       = Cst.COA_SSN,--CBR  
     CBRME.CO_Borrower_DOB       = Cst.CAPCOADateOfBirth,--CBR  
     CBRME.CO_Borrower_Telephone      = Cst.COA_HomePhoneNo,--CBR  
     CBRME.CO_Borrower_Ecoa_Code      = CASE When Cst.COA_FirstName Is not NULL and LTRIM(RTRIM(Cst.COA_FirstName)) != '' Then '2'  END,--CBR  CASE When Cst.COA_FirstName Is NULL Then '1' Else '2' END,--CBR  
     CBRME.Deceased         = Cst.Deceased,  
     CBRME.COA_Deceased        = Cst.COA_Deceased ,  
     CBRME.COA_CBRConsumerInfoIndicator    = Cst.COA_CBRConsumerInfoIndicator  
   From CBRMonthEndTable CBRME With(Nolock)  
    Join EmbossingAccounts EMB With(Nolock) on EMB.Parent01Aid = CBRME.Acctid  
    Join #TempBsegmentPrimary BP WITH(nolock) On BP.acctId = EMB.Parent01Aid   
    Join Customer Cst With(nolock) on EMB.CustomerId = Cst.CustomerId   
   Where   
   --CBRME.acctid >= @MinAcctid    
              --     AND CBRME.acctid <= @MaxAcctid   
    --   AND  
        CBRME.CBRMonthEnd = @BusinessDay   
     
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
   Join #TempBsegmentPrimary BP WITH(nolock) On BP.acctId = EMB.Parent01Aid   
   Join Address ADR With(nolock) on EMB.CustomerId = ADR.CustomerId   
   Where   
   --CBRME.acctid >= @MinAcctid    
              --     AND CBRME.acctid <= @MaxAcctid   
       --AND  
        CBRME.CBRMonthEnd = @BusinessDay   
  
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
    CBRME.DisputesAmtNS = AIR.DisputesAmtNS,  
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
   Join #TempBsegmentPrimary BP WITH(nolock) On BP.acctId = SHDR.acctId   
   Where   
   --CBRME.acctid >= @MinAcctid    
              --     AND CBRME.acctid <= @MaxAcctid   
    --   AND   
       CBRME.CBRMonthEnd = @BusinessDay   
  
  
   End  
          
  End  
    set @loopCount = @loopCount + 1   
    UPDATE spexecutionlog   
    SET    recordcount = recordcount + @LogCount ,Endtime = getdate(),LoopCount = @loopCount  
    WHERE  operation = 'chunkinsert'   
       AND businessday = @BusinessDay   
       AND institutionid = @OrgAcctid   
  
       set @TotalInsertCount = @TotalInsertCount + @LogCount  
 ENd  
        
  
  
      UPDATE SPExecutionLOg  
      SET    endtime = Getdate(), recordcount =@TotalInsertCount  
      WHERE  operation = 'SpStarted'  
             AND institutionid = @OrgAcctid  
             AND BusinessDay = @BusinessDay  
   IF(@CombineSTMTEOD='1')  
   BEGIN  
    select @AccountInfoCount=count(1) from accountinfoforreport with(nolock) where InstitutionID = @OrgAcctid and businessDay = @businessDay    
    select @PlanInfoCount=count(1) from planinfoforreport pr with(nolock) where InstitutionID = @OrgAcctid and businessDay = @businessDay    
   END  
     
   --The job status will be new on primary side and completed on the reporting side  
  IF EXISTS(SELECT 1 FROM [ATIDProcessingStatus] WITH(NOLOCK) WHERE CPSEnvironment='PlatQAPrimary' AND acctId=@ARSystemAcctId)  
  BEGIN  
   INSERT INTO EODControlData(BusinessDay,InstitutionID,JobStatus,AccountInfoCount,PlanInfoCount)    
   VALUES(@BusinessDay,@OrgAcctid,'New',@AccountInfoCount,@PlanInfoCount)  
  END  
  ELSE  
  BEGIN  
   INSERT INTO EODControlData(BusinessDay,InstitutionID,JobStatus,AccountInfoCount,PlanInfoCount)    
   VALUES(@BusinessDay,@OrgAcctid,'Completed',@AccountInfoCount,@PlanInfoCount)  
  END  
         
        
   IF EXISTS (SELECT TOP 1 1 FROM Institutions WITH(NOLOCK) WHERE GenerateInterestProjection = 1 AND InstitutionID = @OrgAcctid)  
   BEGIN  
    INSERT INTO SYN_CL_ReportSchedules ([ReportID],[ATID],[AID],[SecondaryID],[RecipientId],[Source],[Frequency],[DeliveryMethod],[NextDateTime],[InstitutionId],[PODID])  
    SELECT 538,6,InstitutionID,Skey,InstitutionID,'CoreIssue',2,1  
     ,(SELECT MAX(period_time) FROM PeriodTable WITH(NOLOCK) WHERE Period_Name = 'LTD') AS NextDateTime  
     ,InstitutionID,@PODID   
    FROM EODControlData WITH(NOLOCK) WHERE InstitutionID = @OrgAcctid AND businessDay = @businessDay     
   END  
   --PRINT '12'            
   --Set the value of flag to 1 to mark sucessfull filling of EOD tables  
      IF EXISTS(SELECT 1 FROM [ATIDProcessingStatus] WITH(NOLOCK) WHERE CPSEnvironment='PlatQAReporting' AND acctId=@ARSystemAcctId)  
      UPDATE ATIDProcessingStatus SET EODIntermediateFlag=1 WHERE acctId=@ARSystemAcctId     
     
      SELECT @BusinessDay   
  END 