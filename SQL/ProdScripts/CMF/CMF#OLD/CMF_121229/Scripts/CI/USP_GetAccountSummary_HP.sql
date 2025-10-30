SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************  
Author       - Aastha Gupta  
Reviewer     - JP Jain
Modified For - PLAT-175729
Date Added   - 04/25/2024
Version      - Plat_23.8.13 
Description  - Cards-113520 Late Fee Max $8
**********************************************************************************************************************/
/**********************************************************************************************************************  
Author       - Kashish Meid 
Reviewer     - Ashish Saxena   
Modified For - PLAT-58045
Date Added   - October 16, 2023  
Version      - Plat_24.2  
Description  - Added a condition of CLCreditLimitType for value 1.   
**********************************************************************************************************************/
/**********************************************************************************************************************    
Author       - Puspendra Maurya    
Reviewer     - Rohit Soni  
Modified For - PLAT-141342  
Date Added   - 10/13/2023  
Version      - Plat_23.8.8    
Description  - Added 1 second in posttime for testaccount to return ExceededPastDueDaysPermitted    
**********************************************************************************************************************/  
/**********************************************************************************************************************    
Author       - AFTAB RAIN    
Reviewer     - SHOBHIT SAXENA  
Modified For - PLAT-78860  
Date Added   - MAY 15, 2023   
Version      - Plat_23.2.4    
Description  - Enhanced code to take care of if negative value has been assign to @availablecashbalance in case of cashlmtamt is 0.00    
**********************************************************************************************************************/  
-- =============================================  
-- Author:  Abhishek Singh  
-- Create date: April 4, 2019  
-- Description: Cookie-96855  
-- Updated By : Sonam Gupta  
-- Updated for : td# 219167  
-- Updated By  : Abhishek Singh  
-- Updated for : Added New Field ExceededPastDueDaysPermitted   
-- Updated By : Sarajit Mondal  
-- Updated for : TD# 231254,TD#231215  
-- Updated BY  : Sheetal Jaiswal  
-- Updated for : TD# 246367 - Added Condition to set WaiveInterest as false if Reage gets cancelled.  
  
--     Mismatch BeginningBalance and BeginningBalanceAmount buckets for both Account Details and Customer wise details and CustomerID missing in Customer wise reward Details  
-- Updated By  : Raj prakash kumar  
-- Updated for : upgrade Current_Balance, PendingOTB or AvailableBalance --date-1502/2021  
-- Updated for : PLAT-14910 added condition to get reage tags for Test Account and not compare it with ARSystemDate   
-- Updated BY  : Krunal Kumbhare   
--UPdated by : Sonam Gupta for Cookie_187417  
-- =============================================  
/**********************************************************************************************************************  
/*  
Author       - Aastha Gupta  
Reviewer     - Pankaj Pateriya  
Modified For - Cards-55261  
Date Added   - April 20, 2022  
Version      - 17.00.05  
Description  - Returning ProductID column from Bsegment_primary  
*/  
**********************************************************************************************************************/  
/**********************************************************************************************************************  
Author       - Kashish Meid   
Reviewer     - Ashish Saxena   
Modified For - PLAT-63688(Cookie-196137)  
Date Added   - September 01, 2022  
Version      - Plat_22.8.2  
Description  - Returning BankruptcyFilingDate column from Bsegment_primary  
**********************************************************************************************************************/  
  
/**********************************************************************************************************************  
Author       - Puspendra Maurya  
Reviewer     - Prasoon Parashar   
Modified For - PLAT-70928  
Date Added   - November 03, 2022  
Version      - Plat_22.10.2  
Description  - Added Condition to take BeginningBalance from   
               CurrentStatementHeader table when it is <= 0 to define AccountGraceFlag T/F in AccountSummary API.   
**********************************************************************************************************************/  
  
/**********************************************************************************************************************  
Author       - Agraj Sharma  
Reviewer     - Ashish Saxena   
Modified For - Cookie-224046/PLAT-78450  
Date Added   - November 30, 2022  
Version      - Plat_22.10.5  
Description  - We have added a new column 'mPODID' in the SP - USP_GetAccountSummary_HP.   
**********************************************************************************************************************/  
/**********************************************************************************************************************    
Author       - Agraj Sharma    
Reviewer     - Ashish Saxena     
Modified For - PLAT-12479  
Date Added   - December 22, 2022    
Version      - Plat_22.11.2    
Description  - We have added a condition in AvailablecashBalkance for chargeOff.     
**********************************************************************************************************************/  
/**********************************************************************************************************************    
Author       - Agraj Sharma    
Reviewer     - Ashish Saxena     
Modified For - PLAT-124164  
Date Added   - Oct 27, 2023    
Version      - Plat_24.2    
Description  - We have added a new cloumn in output "chargeOffDate".     
**********************************************************************************************************************/ 
/**********************************************************************************************************************    
Author       - KUMARS SHUBHAM    
Reviewer     - Deepak Jain  
Modified For - Cookie- 285060 
Date Added   - July 19, 2024    
Version      - Plat_24.2.7    
Description  - Added code for COOKIE-285060 to include PendingOTB and MergePendingOTB  in Current Balance for Credit Balance Check (Line- 777 to 783).     
**********************************************************************************************************************/
/**********************************************************************************************************************  
Author       - Vandana Pawar
Reviewer     - Rohit Soni
Modified For - PLAT-191199
Date Added   - 07/29/2024
Description  - Added AmountOfCreditCTD for pr_GetBeginningBalanceForInterest_PS
**********************************************************************************************************************/

/*  
USE asplatcoreissue  
  
USP_GetAccountSummary_HP 5027  
*/  
CREATE OR ALTER    PROCEDURE USP_GetAccountSummary_HP  
 -- Add the parameters for the stored procedure here  
 @BSAccountId INT  
AS  
SET NOCOUNT ON;  
SET ANSI_NULLS ON  
SET QUOTED_IDENTIFIER ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;   
BEGIN  
 --DECLARE @AStatuses as TABLE(AID int, Parent01AId  int, MerchantAID int,Priority int)  
 DECLARE @PaymentScheduleStatus AS INT  
 DECLARE @PaymentScheduleFrequency AS INT  
 DECLARE @CardAutomaticPaymentEnrollmentStatus AS VARCHAR(5)  
 DECLARE @iDelinquencyDays AS INT  
 DECLARE @DelinquencyDays AS INT  
 DECLARE @ASCounter AS INT  
 DECLARE @DeAcctActivityDate AS DATETIME  
 DECLARE @ARSystemDate AS DATETIME  
 DECLARE @ProductID AS INT  
 DECLARE @iDaysActive AS INT  
 DECLARE @DtOfLastDelinqCTD AS DATETIME  
 DECLARE @BankruptcyFilingDate as Datetime  
 DECLARE @ChargeOffDate as Date -- Added By Agraj for ChargeOffDate Enhancement #PLAT-124164
  
 --#REGION for @AccountGraceFlag calculation  
 DECLARE @AccountGraceFlag AS VARCHAR(1),  
 --@AccountGraceStatus VARCHAR(5),  
 --@GraceDaysStatus VARCHAR(5),  
 --@GraceDayCutoffDate DATETIME,  
 --@BeginningBalance money,  
 --@CreditPlanType VARCHAR(5),  
 --@CurrentBalance money,  
 --FD.PostTime DATETIME,  
 --@LAPD DATETIME,  
 --@InstitutionID INT,  
 @LastReportedInterestDate datetime  
 DECLARE @ReageStartDate As datetime  
 DECLARE @ReageEndDate As datetime  
 DECLARE @ReageStatus As int  
 DECLARE @DisplayReageParams As varchar(5)  
 DECLARE @MonthlyReagePaymentAmount As Money  
 DECLARE @RemainingTotalReageAmount As Money  
 DECLARE @RemainingMonthlyReagePaymentAmount As Money  
 DECLARE @ReagePaymentAmt As Money  
 DECLARE @TotalReagePaymentAmt As Money  
 DECLARE @PaymentDuringReage As Money  
 DECLARE @PaymentDuringReageCTD As Money  
  
 DECLARE @RemainingTDREligibilityCounter As int  
 DECLARE @TDREligibilityCounter As int  
 DECLARE @InteragencyEligible As int  
 DECLARE @CycleDueDTD As int  
 DECLARE @DqTDRCounterYTD As int  
 DECLARE @NonDqTDRCounterYTD As int   
 DECLARE @PendingDqTDRCounterYTD As int  
 DECLARE @PendingNonDqTDRCounterYTD As int  
 DECLARE @ccinhparent125aid as int  
 --Cookie 153082 - Start  
 DECLARE @CashLmtAmt As Money  
 DECLARE @CashBalance As Money  
 DECLARE @cashouAmount As Money  
 DECLARE @latechargesctd As Money  
 DECLARE @ServiceChargeCTD As Money  
 DECLARE @AvailableCashBalance As Money  
 Declare @LateFeeMaxAmount AS MONEY  
 Declare @SchargeID AS INT  
 Declare @BillingTable As INT  
 Declare @LateFeeMaxAmount_Base AS MONEY  
 Declare @LateFeeMaxAmount_Base1 AS MONEY  
 DECLARE @TCapStatus INT=0  
 --DECLARE @CashCreditLimitLastUpdated as DATETIME  
 --DECLARE @CashCreditLimitLastIncreased as DATETIME  
 --DECLARE @CashCreditLimitLastDecreased as DATETIME  
 DECLARE @TestAccount INT --PLAT-14910  
 --Cookie 153082 - End  
 --#END REGION  
  
 DECLARE @AssociationProductType VARCHAR(10),  
   @InterestGraceDecisionOn VARCHAR(2)  
   
    
 --DECLARE @LastAuthTimeStamp DATETIME=NULL  
  
 /*  
 SELECT @LastAuthTimeStamp=MAX(LastAuthDateTime)  
 FROM SYN_COREAUTH_EMBOSSING_ACCOUNTS  where parent01AID=@BSAccountId  
 */  
  
 --Changes for displaying DaysPastDue as in sync with svcAPICardHolderDetail - Start  
 --UDF_BSDerivedStatus - this Fn returns Acctid of Astatus with higher priority  
 DECLARE @mPODID VARCHAR(64)  
 SELECT @mPODID = MiniPodId from CPS_Environment with(nolock)  
  
 SELECT   
 @ProductId = BSP.parent02AID, @iDelinquencyDays = BSCC.daysdelinquent,   
 @DeAcctActivityDate = BSP.DeAcctActivityDate, @DtOfLastDelinqCTD = BSCC.DtOfLastDelinqCTD,  
 @ReageStartDate = BSCC.ReageStartDate, @ReageEndDate = BSCC.ReageEndDate,   
 @ReageStatus = BSCC.ReageStatus, @ReagePaymentAmt = BSCC.ReagePaymentAmt,   
 @TotalReagePaymentAmt=BSCC.TotalReagePaymentAmt, @DqTDRCounterYTD = BSCC.DqTDRCounterYTD ,   
 @NonDqTDRCounterYTD = BSCC.NonDqTDRCounterYTD, @InteragencyEligible = BSCC.InteragencyEligible,  
 @PendingDqTDRCounterYTD = BSCC.PendingDqTDRCounterYTD , @PendingNonDqTDRCounterYTD = BSCC.PendingNonDqTDRCounterYTD,   
 @InteragencyEligible = BSCC.InteragencyEligible, @PaymentDuringReage = BSCC.PaymentDuringReage,   
 @PaymentDuringReageCTD = BSCC.PaymentDuringReageCTD, @ccinhparent125aid = BSP.ccinhparent125aid,  
 @CycleDueDTD =BSP.cycleduedtd,  
 @TCapStatus=IsNULL(BSCC.TCapStatus,0),@BankruptcyFilingDate = BSCC.BankruptcyFilingDate,
 @ChargeOffDate = CASE WHEN BSP.systemstatus=14 THEN BSCC.chargeoffDate ELSE NULL END -- Added By Agraj for ChargeOffDate Enhancement #PLAT-124164
 from Bsegment_primary BSP with(nolock) join BSegmentCreditCard BSCC  with(nolock) on (BSCC.acctId = BSP.acctid) where BSP.acctid = @BSAccountId  
  
 SELECT @TestAccount =  TestAccount , @CashLmtAmt = CashLmtAmt,@CashBalance = CashBalance,@latechargesctd = latechargesctd,@ServiceChargeCTD = ServiceChargeCTD   
 from BSegment_Secondary with(nolock) where ACCTID = @BSAccountId  
   
 Select  @ASCounter = Count(1) from AstatusAccounts with(nolock) where Acctid = dbo.UDF_BSDerivedStatus (@BSAccountId) and WaiveMinDue in ('1','2')   
 IF ((@ASCounter IS NOT NULL AND  @ASCounter = 1) OR  @TestAccount =1 )  
  BEGIN  
   Set @DelinquencyDays = @iDelinquencyDays  
  END  
 ELSE  
  BEGIN  
   IF @DtOfLastDelinqCTD IS NOT NULL  
    BEGIN  
     --print @ProductId  
     Set @ARSystemDate = dbo.UDF_GetARSystemDate(@ProductId)  
     --Set @ARSystemDate = GetDate()  
     Set @iDaysActive = dbo.UDF_GetPeriodCount('DTD',@DeAcctActivityDate,@ARSystemDate)  
     Set @iDaysActive = @iDaysActive - 1  
     Set @DelinquencyDays = @iDelinquencyDays + @iDaysActive  
     --SELECT @DelinquencyDays = (dbo.UDF_GetPeriodCount('DTD',@DeAcctActivityDate,dbo.UDF_GetARSystemDate(@ProductId))-1) + @iDelinquencyDays  
    END  
   ELSE  
    BEGIN  
     Set @DelinquencyDays = @iDelinquencyDays  
    END  
  END  
 --Changes for displaying DaysPastDue as in sync with svcAPICardHolderDetail - End  
 --Changes for cookie - 147500 - Start  
 Set @ARSystemDate = dbo.UDF_GetARSystemDate(@ProductId)  
 IF( @TCapStatus=0 and (@ReageStartDate is not null) and (@ReageEndDate is not null) and (@ReageStatus is not null and @ReageStatus in(1,2))   
 and (@ARSystemDate > @ReageStartDate and @ARSystemDate <= @ReageEndDate))   
  BEGIN  
   SET @DisplayReageParams = '1'--Yes  
   SET @MonthlyReagePaymentAmount = @ReagePaymentAmt  
   SET @RemainingTotalReageAmount = @TotalReagePaymentAmt - @PaymentDuringReage  
   SET @RemainingMonthlyReagePaymentAmount = @ReagePaymentAmt - @PaymentDuringReageCTD  
  END  
 ELSE  
  BEGIN  
   SET @DisplayReageParams = '0'--No  
   SET @MonthlyReagePaymentAmount = NULL  
   SET @RemainingTotalReageAmount = NULL  
   SET @RemainingMonthlyReagePaymentAmount = NULL  
  END  
 --Changes for cookie - 147500 - End  
 --Changes for Jira Ticket_147693 - Start  
 SET @RemainingTDREligibilityCounter = 0  
 SET @TDREligibilityCounter = 6  
 IF((@InteragencyEligible is not null or @CycleDueDTD is not null) and (@InteragencyEligible = 0 or @CycleDueDTD >= 3))  
  BEGIN  
   SET @TDREligibilityCounter = 3  
  END  
 IF((@ccinhparent125aid is not null) and (@ccinhparent125aid=15996 or @ccinhparent125aid=16000 or (@ccinhparent125aid=16304 and @ReageStatus in (1,2))))  
  BEGIN  
   SET @RemainingTDREligibilityCounter = @TDREligibilityCounter - (ISNULL(@DqTDRCounterYTD,0) + ISNULL(@NonDqTDRCounterYTD,0) + ISNULL(@PendingDqTDRCounterYTD,0) + ISNULL(@PendingNonDqTDRCounterYTD,0))  
  END  
 ELSE   
  BEGIN  
   SET @RemainingTDREligibilityCounter = @TDREligibilityCounter - (ISNULL(@DqTDRCounterYTD,0) + ISNULL(@NonDqTDRCounterYTD,0))  
  END  
 IF(@RemainingTDREligibilityCounter is not null and @RemainingTDREligibilityCounter < 0)  
 BEGIN  
  SET @RemainingTDREligibilityCounter = 0   
 END   
 --Changes for Jira Ticket_147693 - End  
 --CT - 153082 - Start  
 SELECT @cashouAmount = CashouAmount from SYN_CAuth_BSegment_Primary  WITH(NOLOCK) WHERE ACCTID = @BSAccountId   
 SET @AvailableCashBalance = ISNULL(@CashLmtAmt,0) - (ISNULL(@CashBalance,0) + ISNULL(@cashouAmount,0))  
 --PLAT-78860 - Start  
 IF(@AvailableCashBalance<0.00)  
 BEGIN  
  SET @AvailableCashBalance=0.00  
 END  
 IF((@AvailableCashBalance<0.00) and (@CashLmtAmt=0.00))  
 BEGIN  
  SET @AvailableCashBalance=(ISNULL(@CashBalance,0) + ISNULL(@cashouAmount,0))  
 END  
 --PLAT-78860 - END  
 --CT - 153082 - End  
 --PLAT-14910 CODE START  
 IF( (@TestAccount IS NOT NULL )AND (@TestAccount = 1)  )  
  BEGIN  
    IF( @TCapStatus=0 and (@ReageStartDate is not null) and (@ReageEndDate is not null) and (@ReageStatus is not null and @ReageStatus in(1,2)) )   
    BEGIN  
     SET @DisplayReageParams = '1'--Yes  
     SET @MonthlyReagePaymentAmount = @ReagePaymentAmt  
     SET @RemainingTotalReageAmount = @TotalReagePaymentAmt - @PaymentDuringReage  
     SET @RemainingMonthlyReagePaymentAmount = @ReagePaymentAmt - @PaymentDuringReageCTD  
    END  
  END  
 --PLAT-14910 CODE END  
 DECLARE @FinalData as TABLE  
 (  
  AccountNumber char(19),  
  InstitutionID INT,  
  PostTime DATETIME,  
  LAPD DATETIME,  
  AccountDerivedStatus int,  
  AmountOfTotalDue money,  
  AvailableBalance money,  
  OpeningBillingCycle datetime,  
  BillingCycle char(9),  
  BillingTable int,  
  CreditLimit money,  
  Current_Balance money,  
  CycleDue int,  
  GeneratedStatus int,  
  LastPaymentAmount money,  
  LastPaymentDate datetime,  
  LastStatementDate datetime,  
  ManualStatus int,  
  ManualStatusReason varchar(100),  
  PostalCode VARCHAR(10),  
  ClosedBillingCycle datetime,  
  CreditsCTD money,  
  StatementRemainingBalance money,  
  payment_due_date datetime,  
  BalanceTransferCTD money,  
  ChargeOffCurrentBalance money,  
  TotalFeeCTD money,  
  InterestChargedCTD money,  
  OutStandingAuth money,  
  PurchaseCTD money ,  
  AccountOpenDate Datetime,  
  PendingOTB money,  
  FiveCyclePastDue money,  
  AmtOfPayCurrDue money,  
  DateOfTotalDue datetime,  
  ClientId varchar(64),  
  TimeStamp datetime,  
  RecoveryFeesCTD money,   
  AcctId INT,  
  Parent02AID INT,  
  Parent05AID INT,  
  ccinhParent125AID INT,    
  SystemChargeOffStatus INT,  
  IDinOpenToBuy char(5),  
  PartnerId varchar(50),  
  CustomerId varchar(50),  
  AutoInitialChargeOffCriteria varchar(5),   
  DRStatusStartDate DATETIME,  
  DRStatusResumeDate DATETIME,  
  CreditOutStandingAmount money,  
  InstallmentOutStandingAmount money,  
  SBWithInstallmentDue money,  
  SRBWithInstallmentDue money,    
  StatementDate DATETIME,  
  DRPSkipDate DATETIME,  
  InstallmentsBalance MONEY,  
  NumberofInstallments INT,  
  InstallmentsPendingPurchases MONEY,  
  RevolvingCurrentBalance MONEY,  
  AdjustedCurrentBalance  MONEY,  
  InstallmentRemainingMinimumDue MONEY,  
  NextMonthlyPayment MONEY,  
  PrevStmtRemainingBalance money,  
  InstallmentPurchasesCTD money,  
  ExceededPastDueDaysPermitted varchar(3),  
  DateOfLastDelinquent DATE,  
  LgDynamicStaticADCGroup INT,  
  StrategyCheckEnabled BIT,  
  UsePastDueStrategy VARCHAR(1),  
  PDPastDueDaysPass INT,--Logo  
  PastDueDaysPermitted INT,--Account  
  CreditLimitLastUpdated DATETIME,  
  CreditLimitLastIncreased DATETIME,  
  CreditLimitLastDecreased DATETIME,  
  LastAuthTimeStamp DATETIME,  
  DisputeAmountNotSettled money,  
  DisputeAmountReleasedFromOTB money,  
  SCRAEffectiveStartDate Datetime,  
  SCRAEffectiveEndDate Datetime,  
  RemainingMinimumDue money,   
  WaiveInterest bit,  
  WaiveInterestFor tinyint,  
  WaiveInterestFrom varchar(1),  
  BSWFeeIntStartDate  datetime,  
  DaysPastDue int,  
  AssociationProductType varchar(200),  
  --JIRA 134447 & 132521  
  OverrideFlag varchar(1),  
  OverrideCounter int,  
  PastDue money,   
  OneCyclePastDue money,   
  TwoCyclePastDue money,    
  ThreeCyclePastDue money,   
  FourCyclePastDue money,   
  SixCyclePastDue money,   
  SevenCyclePastDue money,  
  PastDueDate datetime,  
  OneCyclePastDueDate datetime,  
  TwoCyclePastDueDate datetime,  
  ThreeCyclePastDueDate datetime,  
  FourCyclePastDueDate datetime,  
  FiveCyclePastDueDate dateTime,  
  SixCyclePastDueDate datetime,  
  SevenCyclePastDueDate datetime,  
  MonthlyReagePaymentAmount money,  
  RemainingTotalReageAmount money,  
  RemainingMonthlyReagePaymentAmount money,  
  RemainingTDREligibilityCounter int,  
  CashLmtAmt money,  
  CashBalance money,  
  cashouAmount money,  
  AvailableCashBalance Money,  
  latechargesctd money,  
  ServiceChargeCTD money,    
  CashCreditLimitLastUpdated DATETIME,  
  CashCreditLimitLastIncreased DATETIME,  
  CashCreditLimitLastDecreased DATETIME,  
  MergeDate DateTime,  
  LateFeeMaxAmount Money,  
  AccountMergedByAccountNumber varchar(19),  
  MergedAccountNumber varchar(19),  
  PendingPaymentDueDate DATETIME,  
  PendingBillingCycleDate DATETIME,  
  PendingBillingCycleUpdateDate DATETIME,  
  SourceStmtBalanceAtMerge MONEY ,  
  SourceInstallmentAtMerge MONEY ,  
  SourceCurrentBalanceAtMerge MONEY ,  
  DestStmtBalanceAtMerge MONEY ,  
  DestinationInstallmentAtMerge MONEY ,  
  DestCurrentBalanceAtMerge MONEY ,  
  TotalMontlyStatementBalance MONEY,  
  TotalCurrentBalanceAtMerge  MONEY,  
  BusinessID varchar(71),  
  RequestorID  VARCHAR(64),  
  RequestorTimestamp  DATETIME,  
  IsMigrated tinyint,  
  DateAcctClosed DATETIME,  
  ReageActive tinyint,  
  ACC_AccountGraceStatus VARCHAR(5),  
  ACC_GraceDaysStatus VARCHAR(5),  
  ACC_GraceDayCutoffDate DATETIME,  
  ACC_BeginningBalance money,  
  ACC_Currentbalance money,  
  mPODID VARCHAR(64),
  ChargeoffDate Date -- Added By Agraj for ChargeOffDate Enhancement #PLAT-124164
  )  
  
 INSERT INTO @FinalData(AcctId)  
 VALUES(@BSAccountId)  
  
 --DECLARE @CreditLimitLastUpdated as DATETIME  
 --DECLARE @CreditLimitLastIncreased as DATETIME  
 --DECLARE @CreditLimitLastDecreased as DATETIME  
  
 UPDATE FD  
 SET   
  FD.AccountNumber = P.AccountNumber,  
  FD.BillingCycle = P.BillingCycle,  
  FD.GeneratedStatus = P.SystemStatus,  
  FD.BillingTable = P.ccinhparent127AID,  
  FD.CycleDue = P.CycleDueDTD,  
  CreditLimit = P.CreditLimit,  
  FD.LastPaymentAmount = P.LastPaymentAmt,  
  FD.LastPaymentDate = P.lastpmtdate,  
  FD.LastStatementDate = P.LastStatementDate,  
  FD.ManualStatus=P.ccinhparent125AID,  
  FD.ClosedBillingCycle = P.DateOfNextStmt,  
  FD.CreditsCTD=P.AmountOfCreditsCTD,  
  FD.PurchaseCTD = ISNULL(AmountOfPurchasesCTD,0),  
  FD.TotalFeeCTD=ISNULL(NSFFeesCTD,0),  
  FD.IDinOpenToBuy = P.IDinOpenToBuy,  
  FD.Parent02AID = P.Parent02AID,  
  FD.Parent05AID = P.Parent05AID,  
  FD.ccinhParent125AID = P.CCInhParent125AID,  
  FD.AmtOfPayCurrDue = P.AmtOfPayCurrDue,  
  FD.CustomerId = P.CustomerId,  
  FD.AmountOfTotalDue = ISNULL(P.AmtOfPayCurrDue,0),  
  InstitutionID=FD.InstitutionID,  
  PostTime=LAD,  
  LAPD=P.LAPD,  
  SCRAEffectiveStartDate  = p.SCRAEffectiveDate,  
  AssociationProductType = P.AssociationProductType,  
  FD.PendingPaymentDueDate = P.PendingPaymentDueDate,   
  FD.PendingBillingCycleDate = P.PendBillingCycledate,  
  FD.PendingBillingCycleUpdateDate=P.PendingBillingCycleDate,  
  FD.BusinessID                   =P.BusinessID,  
  FD.DateAcctClosed = P.DateAcctClosed,  
  FD.ACC_AccountGraceStatus = BCC.AccountGraceStatus,  
  FD.ACC_GraceDaysStatus = P.GraceDaysStatus,  
  FD.ACC_GraceDayCutoffDate = P.GraceDayCutoffDate,  
  FD.ACC_BeginningBalance = P.BeginningBalance,  
  FD.ACC_Currentbalance = P.Currentbalance,
  ChargeOffDate = @ChargeOffDate -- Added By Agraj for ChargeOffDate Enhancement #PLAT-124164
 FROM @FinalData FD  
 JOIN BSEGMENT_PRIMARY P ON(FD.AcctId = P.AcctId)  
 JOIN BSEGMENTCREDITCARD BCC ON(BCC.Acctid = P.Acctid)  
    
 Select @BillingTable = BillingTable from @FinalData FD Where ACCTID=@BSAccountId  
  
 Select @SchargeID = ccinhparent107AID From BillingTableAccounts With(NoLock) Where ACCTID=@BillingTable  
  
 Select @LateFeeMaxAmount_Base = latefeemaxamtvalue,@LateFeeMaxAmount_Base1 = latefeemaxamtvalue2  From schargesaccounts With(nolock) where ACCTID=@SchargeID  
 --Select @LateFeeMaxAmount_Base1 = latefeemaxamtvalue2 From schargesaccounts With(nolock) where ACCTID=@SchargeID  /*aastha - PLAT-175729*/
  
 /*
 if (@LateFeeMaxAmount_Base1>@LateFeeMaxAmount_Base)  
 begin  
   SET @LateFeeMaxAmount_Base = @LateFeeMaxAmount_Base1  
 END  
 */

	/*aastha - PLAT-175729*/
	if(@LateFeeMaxAmount_Base1 IS NOT NULL OR @LateFeeMaxAmount_Base1 <> 0 )
	BEGIN
		if (@LateFeeMaxAmount_Base1>@LateFeeMaxAmount_Base)  
		BEGIN  
			SET @LateFeeMaxAmount_Base = @LateFeeMaxAmount_Base1  
		END
		ELSE
		BEGIN
			SET @LateFeeMaxAmount_Base = @LateFeeMaxAmount_Base;
		END
	END
	ELSE
	BEGIN
		SET @LateFeeMaxAmount_Base = @LateFeeMaxAmount_Base;
	END
	/*aastha - PLAT-175729*/
   
  
 UPDATE FD  
 SET  
  FD.TotalFeeCTD = FD.TotalFeeCTD+ISNULL(S.ServiceChargeCTD,0)+ISNULL(S.MembershipFeesCTD,0)+ISNULL(S.LateChargesCTD,0)+ISNULL(S.AmtOfOvrLimitFeesCTD,0)+ISNULL(S.CollectionFeesCTD,0),  
  FD.ClientId = S.ClientID,  
  FD.RecoveryFeesCTD = ISNULL(S.RecoveryFeesCTD,0),  
  FD.PartnerId = S.PartnerId,  
  FD.DRStatusStartDate = S.DRStatusStartDate,  
  PostTime=CASE WHEN TESTACCOUNT=1 THEN DateAdd(Second,1,PostTime) ELSE dbo.UDF_GetARSystemDate(FD.InstitutionID) END, --DateAdd(Second,1,PostTime) : PLAT-141342  
  FD.MergeDate = CASE WHEN S.AccountMergedByAccountNumber IS NOT NULL OR S.MergedAccountNumber IS NOT NULL THEN S.MergeDate ELSE NULL END,  
  FD.AccountMergedByAccountNumber=S.AccountMergedByAccountNumber ,  
  FD.MergedAccountNumber=S.MergedAccountNumber,  
  FD.RequestorID= S.RequestorID,  
  FD.RequestorTimestamp = S.RequestorTimestamp,  
  FD.IsMigrated = S.Migrated  
 FROM @FinalData FD  
 JOIN BSegment_Secondary S ON(FD.AcctId = S.AcctId)  
  
  
 UPDATE FD  
 SET  
  FD.BalanceTransferCTD = B.BalanceTransfer_CTD,  
  FD.PastDueDate=B.DateOfTotalDueCC1,  
  FD.OneCyclePastDueDate=B.DateOfTotalDueCC2,  
  FD.TwoCyclePastDueDate=B.DateOfTotalDueCC3,  
  FD.ThreeCyclePastDueDate=B.DateOfTotalDueCC4,  
  FD.FourCyclePastDueDate=B.DateOfTotalDueCC5,  
  FD.FiveCyclePastDueDate=B.DateOfTotalDueCC6,  
  FD.SixCyclePastDueDate=B.DateOfTotalDueCC7,  
  FD.SevenCyclePastDueDate=B.DateOfTotalDueCC8,  
  FD.DestCurrentBalanceAtMerge = CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.DestCurrentBalanceAtMerge ELSE 0.0 END,  
  FD.TotalMontlyStatementBalance=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN CAST(B.TotalMontlyStatementBalance as decimal(10,2)) ELSE NULL END,  
     FD.DestinationInstallmentAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.DestinationInstallmentAtMerge ELSE 0.0 END,  
  FD.DestStmtBalanceAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.DestStmtBalanceAtMerge ELSE 0.0 END,  
  FD.SourceCurrentBalanceAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.SourceCurrentBalanceAtMerge ELSE 0.0 END,  
  FD.SourceInstallmentAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.SourceInstallmentAtMerge ELSE 0.0 END,  
  FD.SourceStmtBalanceAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.SourceStmtBalanceAtMerge ELSE 0.0 END,  
  FD.TotalCurrentBalanceAtMerge=CASE WHEN ISNULL(B.MergeCycle,0)=1 THEN B.SourceCurrentBalanceAtMerge + B.DestCurrentBalanceAtMerge ELSE 0.0 END  
    
 FROM @FinalData FD  
 JOIN BSegment_Balances B ON(FD.AcctId = B.AcctId)  
   
  
  
 SET @AccountGraceFlag = 'T'  
  
 SELECT @AssociationProductType = S.AssociationProductType, @InterestGraceDecisionOn = InterestGraceDecisionOn FROM @FinalData FD JOIN Logo_Secondary S ON(FD.parent02AID = S.AcctId)   
  
 IF (@InterestGraceDecisionOn IN (5,6))  
 BEGIN  
  
  DECLARE @ACC_AccountGraceStatus VARCHAR(2) ,  
    @ACC_GraceDaysStatus VARCHAR(5) ,  
    @ACC_GraceDayCutoffDate datetime,  
    @ACC_BeginningBalance MONEY ,  
    @ACC_CurrentBalance MONEY,  
    @ACC_PostTime DATETIME ,  
    @ACC_InstitutionID INT,  
    @LastStatementDate DATETIME  
    
   SELECT  @ACC_AccountGraceStatus  = FD.ACC_AccountGraceStatus,@ACC_GraceDaysStatus  = FD.ACC_GraceDaysStatus,@ACC_GraceDayCutoffDate  = FD.ACC_GraceDayCutoffDate,@ACC_BeginningBalance  = FD.ACC_BeginningBalance,@ACC_CurrentBalance  = FD.ACC_CurrentBalance,@ACC_PostTime  = FD.PostTime,@ACC_InstitutionID  = FD.InstitutionID   
     ,@LastStatementDate = FD.LastStatementDate FROM @FinalData FD WHERE FD.Acctid = @BSAccountId  
  
   IF (@ACC_BeginningBalance <= 0 AND @LastStatementDate IS NOT NULL) -- PLAT-70928  
   BEGIN  
  
   CREATE TABLE #TempAccountBB  
   (  
    AcctID        INT      NULL ,  
    BeginningBalance MONEY NULL,
	AmountOfCreditCTD Money NULL --//PLAT-191199
   )  
   INSERT INTO #TempAccountBB (BeginningBalance,AcctID,AmountOfCreditCTD)       
     EXEC pr_GetBeginningBalanceForInterest_PS NULL,@LastStatementDate,@InterestGraceDecisionOn,@BSAccountId  
  
   SET @ACC_BeginningBalance  =  (SELECT BeginningBalance FROM #TempAccountBB)  
  END  
  
  SELECT @AccountGraceFlag = CASE WHEN dbo.UDF_GetPlanGraceFlag(@ACC_AccountGraceStatus,@ACC_GraceDaysStatus,@ACC_GraceDayCutoffDate,@ACC_BeginningBalance,NULL,@ACC_CurrentBalance,@ACC_PostTime,@ACC_InstitutionID) !=1 THEN 'F' ELSE 'T'END  
 END  
 ELSE  
 BEGIN  
  
  DECLARE @GraceCalcTable as TABLE(  
  GraceDaysStatus varchar(5),  
  AccountGraceStatus varchar(2),  
  GraceDayCutoffDate datetime,  
  BeginningBalance money,  
  CreditPlanType varchar(5),  
  CurrentBalance money,    
  PostTime datetime,  
  InstitutionID INT,  
  AccountGraceFlag char(1)  
  )  
  
  INSERT INTO @GraceCalcTable(GraceDaysStatus, AccountGraceStatus, GraceDayCutoffDate, BeginningBalance, CreditPlanType, CurrentBalance,PostTime,InstitutionID)  
  SELECT  
  GraceDaysStatus,  
  AccountGraceStatus,  
  GraceDayCutoffDate,  
  BeginningBalance,  
  CreditPlanType,  
  ( ISNULL(CPSA.CurrentBalance,0) + ISNULL(CPCC.CurrentBalanceCO,0) ) as CurrentBalance  
  ,  
  FD.PostTime,FD.InstitutionID  
  FROM @FinalData FD  
  JOIN   CPsgmentAccounts CPSA ON(CPSA.parent02Aid = FD.AcctId)  
  JOIN CPSgmentCreditCard CPCC ON (CPCC.Acctid = CPSA.Acctid)  
  
  UPDATE @GraceCalcTable  
   SET AccountGraceFlag = CASE WHEN dbo.UDF_GetPlanGraceFlag(AccountGraceStatus,GraceDaysStatus,GraceDayCutoffDate,BeginningBalance,CreditPlanType,CurrentBalance,PostTime,InstitutionID) !=1 THEN 'F' ELSE 'T'END  
  
  IF EXISTS(SELECT 1 FROM @GraceCalcTable WHERE AccountGraceFlag='F')  
   SET @AccountGraceFlag = 'F'  
 END  
  
 IF EXISTS(SELECT 1 FROM PaymentSchedule WHERE acctId=@BSAccountId AND ScheduleStatus=1 AND Frequency IN(0,1,3,6))  
  SET @CardAutomaticPaymentEnrollmentStatus='Yes'  
 ELSE  
  SET @CardAutomaticPaymentEnrollmentStatus='No'  
  
 UPDATE FD  
 SET FD.PostalCode= A.PostalCode  
 FROM @FinalData FD  
 JOIN Address A ON(FD.CustomerId = A.CustomerId)  
  
 UPDATE FD  
 SET FD.IDinOpenToBuy=ISNULL(FD.IDinOpenToBuy,L.IDinOpenToBuy)  
 FROM @FinalData FD  
 JOIN dbo.Logo_Primary L ON(FD.Parent02AID = L.AcctId)  
  
 UPDATE FD  
 SET  
  --FD.ChargeOffCurrentBalance = C.currentbalanceco,  
  /*CT#32201  
  We are not supposed to show charge of balance in that field rather whatever is on product setting based on that pick the due bucket and show here.  
  So if product have charge off parameter is 5 cycle past due as charge off frequency then it should show 5 cycle past due bucket.  
       --robin.khatwani@gs.com  
    Fri 05/24/19 06:22  
                                                                                   
  */  
  /*  
  CT#32769 -  COOKIE-103241 | ChargeOffCurrentBalance is incorrect in the AccountSummary API  
  FD.ChargeOffCurrentBalance = CASE  
          WHEN FD.AutoInitialChargeOffCriteria = '3' THEN C.AmountOfPayment30DLate--1 Cycle Past Due  
          WHEN FD.AutoInitialChargeOffCriteria = '4' THEN C.AmountOfPayment60DLate--2 Cycles Past Due  
          WHEN FD.AutoInitialChargeOffCriteria = '5' THEN C.AmountOfPayment90DLate--3 Cycles Past Due  
          WHEN FD.AutoInitialChargeOffCriteria = '6' THEN C.AmountOfPayment120DLate--4 Cycles Past Due  
          WHEN FD.AutoInitialChargeOffCriteria = '7' THEN C.AmountOfPayment150DLate--5 Cycles Past Due  
          WHEN FD.AutoInitialChargeOffCriteria = '8' THEN C.AmountOfPayment180DLate--6 Cycles Past Due  
          ELSE C.currentbalanceco  
         END,  
  */  
  FD.ChargeOffCurrentBalance = C.currentbalanceco,   
  FD.InterestChargedCTD = C.AmtOfInterestCTD,  
  FD.SystemChargeOffStatus = C.SystemChargeOffStatus,  
  FD.AmountOfTotalDue = FD.AmountOfTotalDue  
  +ISNULL(C.AmtOfPayXDLate,0)  
  +ISNULL(C.AmountOfPayment30DLate,0)  
  +ISNULL(C.AmountOfPayment60DLate,0)  
  +ISNULL(C.AmountOfPayment90DLate,0)  
  +ISNULL(C.AmountOfPayment120DLate,0)  
  +ISNULL(C.AmountOfPayment150DLate,0)  
  +ISNULL(C.AmountOfPayment180DLate,0)  
  +ISNULL(C.AmountOfPayment210DLate,0),  
  FD.StatementRemainingBalance = CASE WHEN C.StatementRemainingBalance<0 THEN 0 ELSE ISNULL(C.StatementRemainingBalance,0) END,  
  FD.AccountOpenDate = C.AccountOpenDate,  
  FD.FiveCyclePastDue = C.AmountOfPayment150DLate,  
  FD.DateOfTotalDue = C.DateOfTotalDue,  
  FD.SBWithInstallmentDue = C.SBWithInstallmentDue,  
  FD.SRBWithInstallmentDue = C.SRBWithInstallmentDue,  
  FD.DRPSkipDate = C.DRPSkipDate,  
  FD.PrevStmtRemainingBalance =C.PrevStmtRemainingBalance,  
  FD.ManualStatusReason = C.StatusReason,  
  FD.SCRAEffectiveEndDate  = C.SCRAEndDate,  
  FD.RemainingMinimumDue  = C.RemainingMinimumDue,  
  --FD.WaiveInterest = C.WaiveInterest,  
  FD.WaiveInterest = case when ((C.MinDueRequired = 2 and C.ReageStatus in(3, 7)) OR   
           (C.ReageStatus = 4 and FD.Posttime > C.ActualReageEndDate)) then '0'  
        else C.WaiveInterest END,  
  FD.WaiveInterestFor = C.WaiveInterestFor,  
  FD.WaiveInterestFrom = C.WaiveInterestFrom,  
  FD.BSWFeeIntStartDate = case when C.WaiveInterestFor = 0 then NUll else C.BSWFeeIntStartDate end,--CT# 42015   - return BSWFeeIntStartDate as NULL when WaiveInterestFor = 0(Forever)  
  DaysPastDue = @DelinquencyDays, -- dbo.UDF_GetPeriodCount('DTD',DtOfLastDelinqCTD,PostTime),  
  FD.PastDue=c.AmtOfPayXDLate ,  
  FD.OneCyclePastDue=C.AmountOfPayment30DLate,  
  FD.TwoCyclePastDue=C.AmountOfPayment60DLate,  
  FD.ThreeCyclePastDue=C.AmountOfPayment90DLate,  
  FD.FourCyclePastDue=C.AmountOfPayment120DLate ,  
  FD.SixCyclePastDue=C.AmountOfPayment180DLate,  
  FD.SevenCyclePastDue=C.AmountOfPayment210DLate,  
  --Cookie - 145700 Changes Strat  
  FD.MonthlyReagePaymentAmount = case when (@DisplayReageParams='1' and @ReagePaymentAmt is not null) then @ReagePaymentAmt   
           when (@DisplayReageParams='0') then NULL   
           else NULL END,  
  FD.RemainingTotalReageAmount = case when (@DisplayReageParams='1' and (@RemainingTotalReageAmount > 0)) then @RemainingTotalReageAmount   
           when (@DisplayReageParams='0') then NULL  
           else '0' END,  
  FD.RemainingMonthlyReagePaymentAmount = case when (@DisplayReageParams='1' and  (@RemainingMonthlyReagePaymentAmount > 0)) then (case when (@RemainingMonthlyReagePaymentAmount > @RemainingTotalReageAmount) then @RemainingTotalReageAmount else @RemainingMonthlyReagePaymentAmount END)  
              when (@DisplayReageParams='0') then NULL  
              else '0' END  ,--Cookie - 145700 Changes End  
  FD.ReageActive = CASE WHEN (C.ReageStatus is not null and C.ReageStatus in ( 1, 2) ) then 1  
       ELSE 0    
       END --Cookie 187417 by sonam          
 FROM @FinalData FD  
 JOIN bsegmentcreditcard C ON(FD.AcctId = C.AcctId)  
  
   
  
 UPDATE FD  
 SET  
  FD.OutStandingAuth= ISNULL(CAP.TotalOutStgAuthAmt,0),  
  FD.Current_Balance = CAP.CurrentBalance, /*+ (ISNULL(CAP.MergeTotalDebits,0) - ISNULL(CAP.MergeTotalCredits,0)),*/--rp  
  FD.AvailableBalance =   
  CASE WHEN FD.SystemChargeOffStatus IN (4,5,6)  THEN 0      
      ELSE      
   (--Credit Limit      
    CASE WHEN ISNULL(FD.IDinOpenToBuy, ISNULL(L.IDinOpenToBuy,0)) = 1    
       THEN (ISNULL(CAP.CreditLimit,0) - (ISNULL(CAP.DisputesAmtNS,0) - ISNULL(CAP.AmtOfDispRelFromOTB,0) - ISNULL(CAP.MergeDisputeAmtNS,0) - ISNULL(CAP.MergeAmtOfDispRelFromOTB,0))) --rp  
    ELSE ISNULL(CAP.CreditLimit,0)    
    END      
   )      
   -  
   (--Current Balance  
   /*COOKIE-285060 changes*/
     CASE WHEN ISNULL(CAP.CurrentBalance, 0) + CASE WHEN ISNULL(CAP.PendingOTB,0) > 0 THEN ISNULL(CAP.PendingOTB,0) ELSE 0 END  
	 + CASE WHEN ISNULL(CAP.MergePendingOTB,0) > 0 THEN ISNULL(CAP.MergePendingOTB,0) ELSE 0 END  /*COOKIE-285060 changes*/
	 < 0
	 
    THEN   
     CASE WHEN   (L.ICBOpenToBuy IS NULL OR L.ICBOpenToBuy = 0) THEN 0    
     ELSE (ISNULL(CAP.CurrentBalance, 0) + ISNULL(CAP.MergeTotalDebits,0)) - ISNULL(CAP.MergeTotalCredits,0) /*rp*/   END     
    ELSE  
     ISNULL(CAP.CurrentBalance, 0) + ISNULL(CAP.MergeTotalDebits,0) - ISNULL(CAP.MergeTotalCredits,0)  
    END           
   )      
   -      
   (--Outstanding Auth      
    ISNULL(CAP.TotalOutStgAuthAmt,0)  
   )      
   -      
   (--Pending OTB      
    CASE WHEN ISNULL(CAP.PendingOTB,0) > 0       
    THEN ISNULL(CAP.PendingOTB,0)      
    ELSE 0      
    END  
   )  
   -  
   (--Merge Pending OTB      
    CASE WHEN ISNULL(CAP.MergePendingOTB,0) > 0       
    THEN ISNULL(CAP.MergePendingOTB,0)      
    ELSE 0      
    END  
   )   
  END,  
 FD.PendingOTB = (CASE WHEN ISNULL(CAP.PendingOTB,0) > 0       
    THEN (ISNULL(CAP.PendingOTB,0) + ISNULL(CAP.MergePendingOTB,0))--rp     
    ELSE 0      
    END),  
 FD.LastAuthTimeStamp = CAP.LastAuthDateTime,  
 FD.CreditOutStandingAmount = CAP.CreditOutStgAmt,  
 FD.InstallmentOutStandingAmount = CAP.InstallmentOutStgAmt,   
 FD.DateOfLastDelinquent=CASE WHEN CAP.DateOfLastDelinquent is NOT NULL THEN DATEADD(DAY,1,CAP.DateOfLastDelinquent)  ELSE NULL END  
 ,FD.DisputeAmountNotSettled = CAP.DisputesAmtNS,  
 FD.DisputeAmountReleasedFromOTB = CAP.AmtOfDispRelFromOTB,  
 --JIRA 134447 & 132521  
 FD.OverrideFlag = CAP.OverrideFlag,  
 fd.OverrideCounter = CAP.OverrideCounter  
 FROM @FinalData FD  
 JOIN SYN_CAuth_BSegment_Primary CAP ON(FD.AcctId = CAP.AcctId)  
 JOIN SYN_CI_Logo_Primary L ON(CAP.parent02AID = L.AcctId)  
--Arun  
  
 --TD 233447 : Get AssociationProductType from Logo if not found on Product  
 UPDATE FD  
 SET  
  --FD.AssociationProductType = ISNULL(FD.AssociationProductType,S.AssociationProductType)  
  FD.AssociationProductType=C1.LutDescription  
 FROM @FinalData FD  
 JOIN Logo_Secondary S ON(FD.parent02AID = S.AcctId)  
 JOIN CCARDLookup C1 with(nolock) on (LutId='AssoProductType' and LutCode= ISNULL(FD.AssociationProductType,S.AssociationProductType))  
  
  
 DECLARE @OpeningBillingCycle AS DATETIME  
 DECLARE @paymentDueDate AS DATETIME  
  /***********************************ExceededPastDueDaysPermitted Evaluation**********************************/  
 UPDATE FD  
 SET   
 FD.ExceededPastDueDaysPermitted='NO',  
 FD.LgDynamicStaticADCGroup=L.DynamicStaticADCGroup,  
 FD.PDPastDueDaysPass = L.PDPastDueDaysPass  
 FROM @FinalData FD  
 JOIN SYN_CAuth_Logo_Primary L ON(FD.parent02AID = L.AcctId)  
  
 UPDATE FD  
 SET FD.StrategyCheckEnabled=MAP.Status,  
 FD.UsePastDueStrategy=PDASDt.UsePastDueStrategy,  
 FD.PastDueDaysPermitted=PDAS.PastDueDaysPermitted  
 FROM @FinalData FD  
 JOIN SYN_COREAUTH_ADCMAPPING MAP ON(FD.LgDynamicStaticADCGroup = MAP.ADCGroupID AND RuleDescription='Past Due Strategy Check')  
 LEFT JOIN SYN_CoreAuth_ADCPastDueStrageDeatil PDASDt ON(PDASDt.ADCId=MAP.ADCId)  
 LEFT JOIN SYN_CAuth_PastDueAuthorizationStrategy PDAS ON(FD.AcctId=PDAS.AcctId)  
  
  
 UPDATE FD  
 SET ExceededPastDueDaysPermitted=  
  CASE WHEN ISNULL(FD.StrategyCheckEnabled,0)=1--ADC ENABLED( null => Disabled )  
  THEN  
   CASE   
    WHEN FD.UsePastDueStrategy=0 --//ADC level  
   THEN  
    CASE WHEN ( DATEDIFF(day,FD.DateOfLastDelinquent,FD.PostTime) >= FD.PastDueDaysPermitted)--DATEDIFF > PastDueAuthorizationStrategy.PastDueDaysPermitted  
     THEN 'YES'  
     ELSE  'NO'     
    END      
   WHEN FD.UsePastDueStrategy=1 --//Product level  
   THEN  
    CASE WHEN ( DATEDIFF(day,FD.DateOfLastDelinquent,FD.PostTime) >= FD.PDPastDueDaysPass)--DATEDIFF > SYN_CAuth_Logo_Primary.PDPastDueDaysPass  
     THEN 'YES'  
     ELSE  'NO'  
    END  
   ELSE  
    'NO'  
   END  
  ELSE 'NO' --ADC NOT ENABLED  
  END  
 FROM  
 @FinalData FD  
   
 /***********************************ExceededPastDueDaysPermitted Evaluation**********************************/  
 DECLARE @AccountDerivedStatus AS INT  
  
 SELECT  TOP  1 @AccountDerivedStatus= A.Parent01AID  
 FROM @FinalData P  
 JOIN AStatusAccounts A on (A.Parent01AID in(P.GeneratedStatus,P.ccinhParent125AID) AND A.MerchantAID=P.Parent05AID)  
 WHERE (P.acctid=@BSAccountId)  
 ORDER BY Priority desc  
  
 SELECT  
   --@OpeningBillingCycle = DATEADD(SECOND, 3,ISNULL(P.LastStatementDate, P.CreatedTime)),  
   @OpeningBillingCycle = DATEADD(SECOND, 3,ISNULL(P.LastStatementDate, C.AccountOpenDate)),  
   --@paymentDueDate = ISNULL(C.DateOfTotalDue, dbo.UDF_GetPeriodBoundary('STMT.'+P.BillingCycle,ISNULL(P.LastStatementDate, P.CreatedTime),1))  
   --CT#32124  
   --Requirement is for due date on account summary to be null for a new account. The due date should only be populated after the account receives its first statement.  
   @paymentDueDate = CASE WHEN P.LastStatementDate IS NULL THEN NULL ELSE C.DateOfTotalDue END,  
   @LastReportedInterestDate = CASE WHEN DATEDIFF(DAY,P.LastStatementDate , c.LastReportedInterestDate) = 0 THEN DATEADD(DAY,1,CAST(c.LastReportedInterestDate AS DATE))  ELSE c.LastReportedInterestDate END  
 FROM Bsegment_primary  P  
 join bsegmentcreditcard C  on (P.acctid=c.acctid)  
 WHERE (P.acctid=@BSAccountId)  
  
 UPDATE @FinalData  
 SET  
  AccountDerivedStatus=@AccountDerivedStatus,  
  OpeningBillingCycle = @OpeningBillingCycle,  
  payment_due_date = @paymentDueDate,  
  TimeStamp = @LastReportedInterestDate  
 WHERE acctid=@BSAccountId  
  
 UPDATE @FinalData  
 SET AvailableBalance=CASE WHEN AvailableBalance<0 THEN 0 ELSE AvailableBalance END  
  
 --CT#33262: Updated to get AmountOfTotalDue, AmtOfPayCurrDue from StatementHeader when StatementDate != LAPD ie CTD Job has not been processed.  
 UPDATE FD  
 SET   
 StatementDate = SH.StatementDate,  
 AmountOfTotalDue = SH.AmountOfTotalDue,  
 AmtOfPayCurrDue = SH.AmtOfPayCurrDue,  
 CreditsCTD=0,  
 BalanceTransferCTD=0,  
 TotalFeeCTD=0,  
 InterestChargedCTD=0,  
 PurchaseCTD=0,  
 RecoveryFeesCTD=0  
 FROM @FinalData FD  
 JOIN Statementheader SH  ON(SH.acctid=FD.acctid)  
 WHERE SH.StatementDate=FD.LAPD  
 --Note:This will not update anything if StatementDate != LAPD  
  
  
 ----Cards 1426 JAZZ 
   
 	/*Select @LateFeeMaxAmount = SH.MaxLateFees   FROM @FinalData FD
	JOIN Statementheader SH  ON(SH.acctid=FD.acctid AND SH.StatementDate = FD.LastStatementDate) /*Commented aastha*/

	UPDATE FD SET  LateFeeMaxAmount=@LateFeeMaxAmount FROM @FinalData FD      WHERE FD.AcctId = @BSAccountId
	Update FD SET  LateFeeMaxAmount=@LateFeeMaxAmount_Base FROM @FinalData FD WHERE FD.AcctId = @BSAccountId and(LateFeeMaxAmount IS NULL OR LateFeeMaxAmount = 0)*/
	Update FD SET  LateFeeMaxAmount=@LateFeeMaxAmount_Base FROM @FinalData FD WHERE FD.AcctId = @BSAccountId /*aastha - PLAT-175729*/ 

  
 --Cookie 153082 - Start  
 UPDATE FD SET   
 CashLmtAmt = @CashLmtAmt,  
 CashBalance = @CashBalance,  
 cashouAmount = @cashouAmount,  
 latechargesctd = @latechargesctd,  
 ServiceChargeCTD = @ServiceChargeCTD,  
 AvailableCashBalance = CASE WHEN FD.SystemChargeOffStatus IN (4,5,6)  THEN 0 ELSE @AvailableCashBalance  END  -- Done changes to fix Bug #PLAT-12479  
 FROM @FinalData FD WHERE FD.AcctId = @BSAccountId  
 --Cookie 153082 - End  
  
 --Cookie - 153082 - Start--------------------------  
 --******************CLCreditLimitType - 99 used for CashCreditLimit*****************************  
 ;WITH CLALOG1 as  
 (  
  SELECT  
   ROW_NUMBER() OVER ( ORDER BY CLSkey) as RN,   
   CreditLimitAuditLog.acctId,  
   CLRequestDate as CashCreditLimitLastUpdated,  
   CASE WHEN CLOldValues < CLNewValues THEN CLRequestDate ELSE NULL END as CashCreditLimitLastIncreased,  
   CASE WHEN CLOldValues > CLNewValues THEN CLRequestDate ELSE NULL END as CashCreditLimitLastDecreased  
  FROM CreditLimitAuditLog WHERE (CreditLimitAuditLog.acctId=@BSAccountId) AND CreditLimitAuditLog.CLCreditLimitType IN ('99','1') -- Added a condition of 1 for PLAT-58045  
 )  
   
  
 UPDATE FD  
 SET  
  CashCreditLimitLastUpdated= (SELECT TOP 1 CashCreditLimitLastUpdated FROM CLALOG1 ORDER BY RN DESC),  
  CashCreditLimitLastIncreased= (SELECT TOP 1 CashCreditLimitLastIncreased FROM CLALOG1 WHERE CashCreditLimitLastIncreased is not null ORDER BY RN DESC),  
  CashCreditLimitLastDecreased= (SELECT TOP 1 CashCreditLimitLastDecreased FROM CLALOG1 WHERE CashCreditLimitLastDecreased is not null ORDER BY RN DESC)  
 FROM @FinalData FD  
 JOIN CreditLimitAuditLog CLALOG1 ON(CLALOG1.acctId=FD.acctid)  
  
 --Cookie - 153082 - End---------------------   
 --******************CLCreditLimitType - 99 used for CashCreditLimit*****************************  
 --------------------------  
 ;WITH CLALOG as  
 (  
  SELECT  
   ROW_NUMBER() OVER ( ORDER BY CLSkey) as RN,   
   CreditLimitAuditLog.acctId,  
   CLRequestDate as CreditLimitLastUpdated,  
   CASE WHEN CLOldValues < CLNewValues THEN CLRequestDate ELSE NULL END as CreditLimitLastIncreased,  
    CASE WHEN CLOldValues > CLNewValues THEN CLRequestDate ELSE NULL END as CreditLimitLastDecreased  
  FROM CreditLimitAuditLog WHERE (CreditLimitAuditLog.acctId=@BSAccountId) AND CreditLimitAuditLog.CLCreditLimitType  NOT IN ('99','1') -- Added a condition of 1 for PLAT-58045 
 )  
   
  
 UPDATE FD  
 SET  
  CreditLimitLastUpdated= (SELECT TOP 1 CreditLimitLastUpdated FROM CLALOG ORDER BY RN DESC),  
  CreditLimitLastIncreased= (SELECT TOP 1 CreditLimitLastIncreased FROM CLALOG WHERE CreditLimitLastIncreased is not null ORDER BY RN DESC),  
  CreditLimitLastDecreased= (SELECT TOP 1 CreditLimitLastDecreased FROM CLALOG WHERE CreditLimitLastDecreased is not null ORDER BY RN DESC)  
 FROM @FinalData FD  
 JOIN CreditLimitAuditLog clalog ON(clalog.acctId=FD.acctid)  
 ---------------------  
  
 DECLARE @InstallmentsBalance MONEY  
 DECLARE @NumberofInstallments INT  
 DECLARE @InstallmentsPendingPurchases MONEY  
 --cookie 107443  
 DECLARE @RevolvingCurrentBalance as MONEY  
 DECLARE @AdjustedCurrentBalance  as MONEY  
 DECLARE @InstallmentRemainingMinimumDue as MONEY  
 --cookie 109877  
 DECLARE @NextMonthlyPayment AS MONEY  
 SET @NextMonthlyPayment=0  
 set @InstallmentsBalance =0  
 set @NumberofInstallments=0  
 SET @InstallmentsPendingPurchases=0  
 set @RevolvingCurrentBalance=0  
 set @RevolvingCurrentBalance=0  
 set @AdjustedCurrentBalance=0  
 SET @InstallmentRemainingMinimumDue=0  
  
 --Cookie - 114952 Add Installment purchases field to account summary API  
 DECLARE @InstallmentPurchasesCTD AS MONEY  
  
SELECT @InstallmentsPendingPurchases=SUM(ISNULL(OutstandingAmount,0.0)) --CT#34498 - Rounding Off Correction  
  ,@NumberofInstallments = @NumberofInstallments+COUNT(1)  
FROM Auth_Primary CAT  
JOIN @FinalData FD on (FD.AccountNumber=CAT.AccountNumber)  
WHERE CAT.MessageTypeIdentifier in ('0100','9100','9120') and AuthStatus in('0','6') and RetailFlag=1 and txnSource='29'  
  
   
 ;WITH CPSCTE as(  
 SELECT  
  FD.acctid,  
  SUM(1) CNT,  
  NextMonthlyPayment =SUM(  
  CASE  
  WHEN (FD.PostTime < RetailAniversaryDate and FD.LastStatementDate IS NOT NULL and plansegcreatedate < FD.LastStatementDate  )  
   THEN  0  
  WHEN (Currentbalance - CC.AmountOfTotalDue) > 0 AND (Currentbalance - CC.AmountOfTotalDue) < EqualPaymentAmt  
   THEN (Currentbalance - CC.AmountOfTotalDue)  
  WHEN (Currentbalance - CC.AmountOfTotalDue) <=0 --Added for jira PLAT-39972  
   THEN 0  
  ELSE  
   EqualPaymentAmt  
  END  
  ),  
  NumberofInstallments =SUM( CASE WHEN CM.paymenttype='9' and (CurrentBalance + CurrentBalanceCO ) > 0 THEN 1 ELSE 0 END),  
  InstallmentsBalance = SUM(CASE WHEN CM.paymenttype='9' and (CurrentBalance + CurrentBalanceCO ) > 0 THEN ISNULL(CurrentBalance,0) + ISNULL(CurrentBalanceCO,0) ELSE 0 END),  
  RevolvingCurrentBalance = SUM(CASE WHEN CPSA.creditplantype <> '16' THEN ISNULL(CurrentBalance,0)+ISNULL(CurrentBalanceCO,0) ELSE 0 END),  
  AdjustedCurrentBalance =SUM(CASE WHEN CPSA.creditplantype = '16' THEN ISNULL(CC.AmountOfTotalDue,0) ELSE 0 END),  
  InstallmentRemainingMinimumDue = SUM(CASE WHEN CPSA.creditplantype = '16' THEN ISNULL(CC.AmountOfTotalDue,0) ELSE 0 END),  
  InstallmentPurchasesCTD = SUM(CASE WHEN CPSA.creditplantype = '16' THEN AmountOfPurchasesCTD ELSE 0 END)  
 FROM  
 @FinalData FD  
 JOIN CPsgmentAccounts CPSA ON(CPSA.parent02Aid=FD.acctid)  
 JOIN CPSgmentCreditCard CC  on(CC.acctId=CPSA.acctId)  
 JOIN CPMAccounts CM  on(CM.acctId=CPSA.Parent01aid)  
 GROUP BY FD.acctid  
 )  
  
  
  
 UPDATE  FD  
 SET   
  FD.NextMonthlyPayment = CPSCTE.NextMonthlyPayment,  
  FD.NumberofInstallments = CPSCTE.NumberofInstallments,  
  FD.InstallmentsBalance = CPSCTE.InstallmentsBalance,  
  FD.RevolvingCurrentBalance = CPSCTE.RevolvingCurrentBalance,  
  FD.AdjustedCurrentBalance = CPSCTE.AdjustedCurrentBalance,  
  FD.InstallmentRemainingMinimumDue = CPSCTE.InstallmentRemainingMinimumDue,  
  FD.InstallmentPurchasesCTD = CPSCTE.InstallmentPurchasesCTD  
 FROM CPSCTE  
 JOIN @FinalData FD on (CPSCTE.acctid=FD.acctid)  
   
  
 UPDATE @FinalData  
 SET  
  AdjustedCurrentBalance=AdjustedCurrentBalance+RevolvingCurrentBalance,  
  InstallmentsPendingPurchases=@InstallmentsPendingPurchases,  
  NumberofInstallments=NumberofInstallments+@NumberofInstallments  
  
  
 SELECT  
  AccountNumber,  
  AccountDerivedStatus,  
  AmountOfTotalDue,  
  AvailableBalance,  
  ClosedBillingCycle,  
  OpeningBillingCycle,  
  BillingCycle,  
  BillingTable,  
  CreditLimit,  
  Current_Balance,  
  CycleDue,  
  GeneratedStatus,  
  LastPaymentAmount,  
  LastPaymentDate,  
  LastStatementDate,  
  ManualStatus,  
  PostalCode,  
  ClosedBillingCycle,  
  CreditsCTD,  
  StatementRemainingBalance,  
  payment_due_date,  
  BalanceTransferCTD,  
  ChargeOffCurrentBalance,  
  TotalFeeCTD,  
  InterestChargedCTD,  
  OutStandingAuth,  
  PurchaseCTD,  
  @AccountGraceFlag as AccountGraceFlag,  
  AccountOpenDate,  
  @CardAutomaticPaymentEnrollmentStatus as CardAutomaticPaymentEnrollmentStatus,  
  PendingOTB,  
  FiveCyclePastDue,  
  AmtOfPayCurrDue,  
  DateOfTotalDue,  
  ClientId,  
  TimeStamp,  
  RecoveryFeesCTD,  
  ISNULL(RecoveryFeesCTD,0)+PurchaseCTD as TransactionCTD,  
  PartnerId,  
  CASE WHEN DRStatusStartDate IS NOT NULL THEN CAST(DATEADD(DAY,1,dbo.UDF_GetPeriodBoundary('STMT.'+RTRIM(LTRIM(BillingCycle)),DRStatusStartDate,1)) as DATE) ELSE NULL END AS DRStatusResumeDate,    
  CreditOutStandingAmount,  
  InstallmentOutStandingAmount,  
  SBWithInstallmentDue as StatementBalanceWithInstallmentDue,  
  SRBWithInstallmentDue as StatementRemainingBalanceWithInstallmentDue,  
  PostTime as ProcTime,  
  LAPD,  
  StatementDate,  
  DRPSkipDate,  
  InstallmentsBalance,  
  NumberofInstallments,  
  InstallmentsPendingPurchases,  
  RevolvingCurrentBalance,  
  AdjustedCurrentBalance,  
  NextMonthlyPayment,  
  InstallmentRemainingMinimumDue,  
  PrevStmtRemainingBalance --Cookie - 113373  
  ,InstallmentPurchasesCTD--Cookie - 114952 Add Installment purchases field to account summary API  
  ,ExceededPastDueDaysPermitted,  
  CreditLimitLastUpdated,  
  CreditLimitLastIncreased,  
  CreditLimitLastDecreased,  
  ManualStatusReason,  
  LastAuthTimeStamp  
  ,DisputeAmountNotSettled,  
  DisputeAmountReleasedFromOTB,  
  SCRAEffectiveStartDate ,  
  SCRAEffectiveEndDate,  
  RemainingMinimumDue,  
  WaiveInterest,  
  WaiveInterestFrom,  
  WaiveInterestFor,    
  BSWFeeIntStartDate as InterestWaiverStartDate,  
  DaysPastDue,  
  AssociationProductType,  
  OverrideFlag,  
  OverrideCounter,  
  PastDue,  
  OneCyclePastDue,  
  TwoCyclePastDue,  
  ThreeCyclePastDue,  
  FourCyclePastDue,  
  SixCyclePastDue,  
  SevenCyclePastDue,  
  PastDueDate,  
  OneCyclePastDueDate,  
  TwoCyclePastDueDate,  
  ThreeCyclePastDueDate,  
  FourCyclePastDueDate,  
  FiveCyclePastDueDate,  
  SixCyclePastDueDate,  
  SevenCyclePastDueDate,  
  MonthlyReagePaymentAmount,  
  RemainingTotalReageAmount,   
  RemainingMonthlyReagePaymentAmount,  
     @RemainingTDREligibilityCounter as RemainingTDREligibilityCounter,  
  CashLmtAmt as CashCreditLimit,  
  CashBalance,  
  cashouAmount as CashOutStandingAuth,  
  AvailableCashBalance,  
  latechargesctd as LateFeeCTD,  
  ServiceChargeCTD as TransactionFeeCTD,    
  CashCreditLimitLastUpdated,  
  CashCreditLimitLastIncreased,  
  CashCreditLimitLastDecreased,  
  MergeDate,  
  LateFeeMaxAmount,  
  AccountMergedByAccountNumber,  
  MergedAccountNumber,  
  PendingPaymentDueDate,  
  PendingBillingCycleDate,  
  PendingBillingCycleUpdateDate,  
  PendingBillingCycleUpdateDate,  
  SourceStmtBalanceAtMerge,  
  SourceInstallmentAtMerge,  
  SourceCurrentBalanceAtMerge,  
  DestStmtBalanceAtMerge,  
  DestinationInstallmentAtMerge,  
  DestCurrentBalanceAtMerge,  
  TotalMontlyStatementBalance,  
     TotalCurrentBalanceAtMerge,  
     BusinessID,  
  RequestorID,  
  RequestorTimestamp,  
    CASE WHEN IsMigrated is null THEN cast(0 as bit) ELSE cast(IsMigrated as bit) END AS Converted  
    ,DateAcctClosed AS ClosureDate,  
    ReageActive,  
    @ProductId as ProductId,--Cards-55261  
    @BankruptcyFilingDate as BankruptcyFilingDate ,        
    @mPODID as mPODID,
	 @ChargeOffDate as ChargeoffDate -- Added By Agraj for ChargeOffDate Enhancement #PLAT-124164
 FROM @FinalData  
  
   
  
 SELECT Priority,MStatusCode as ManualStatusCode,StatusDescription,StartDate,EndDate,StatusReason,RequestorID,RequestorTimeStamp  
 FROM BSEGMENT_MSTATUSES  
 WHERE ACCTID=@BSAccountId  
  
  
 SELECT  
  parent01AID as LoyaltyProgram,  
  CCardLookup.LutDescription  as LoyaltyProgramName,  
  de_LytPrgSeg_ProgramStartDate as ProgramStartDate,  
  de_LytPrgSeg_ProgramEndDate AS ProgramEndDate,  
  de_LtyPrgSeg_CurrentBalance AS LoyaltyPoints,  
  de_LtyPrgSeg_CurrentBalance*mPPOneLoyaltyPointIsEqualTo AS LoyaltyRewardBalance,  
  de_LtyPrgSeg_BeginningBalance AS RewardBeginningBalance,  
  de_LtyPrgSeg_BeginningBalance * mPPOneLoyaltyPointIsEqualTo AS RewardBeginingBalanceAmount,  
  (de_LytPrgSeg_CTD_CreditsAmount+de_LytPrgSeg_CTD_DebitAdjustmentsAmount + PointsRecoveredCTD)-(de_LytPrgSeg_CTD_DebitsAmount+de_LytPrgSeg_CTD_CreditAdjustmentsAmount ) AS RewardEarned,  
  ((de_LytPrgSeg_CTD_CreditsAmount+de_LytPrgSeg_CTD_DebitAdjustmentsAmount + PointsRecoveredCTD)-(de_LytPrgSeg_CTD_DebitsAmount+de_LytPrgSeg_CTD_CreditAdjustmentsAmount ))*mPPOneLoyaltyPointIsEqualTo AS RewardEarnedAmount,  
  --PointsExpiredCTD AS RewardExpired,  
  --PointsExpiredCTD*mPPOneLoyaltyPointIsEqualTo AS RewardExpiredAmount,  
  PointsForfeitedCTD AS RewardForfeited,  
  PointsForfeitedCTD*mPPOneLoyaltyPointIsEqualTo AS RewardForfeitedAmount,  
  PointsRecoveredCTD AS RewardRecovered,  
  PointsRecoveredCTD*mPPOneLoyaltyPointIsEqualTo AS RewardRecoveredAmount,  
  PendingRedeemBalance AS PendingRedeemRewardBalance,  
  PendingRedeemBalance*mPPOneLoyaltyPointIsEqualTo AS PendingRedeemRewardBalanceAmount,  
  de_LytPrgSeg_CTD_RedemptionsAmount AS RewardRedeemed,  
  de_LytPrgSeg_CTD_RedemptionsAmount*mPPOneLoyaltyPointIsEqualTo AS RewardRedeemedAmount,  
  de_LytPrgSeg_CTD_RedemptionsReversalsAmount AS RedeemReversalBalance,  
  de_LytPrgSeg_CTD_RedemptionsReversalsAmount*mPPOneLoyaltyPointIsEqualTo AS RedeemReversalBalanceAmount,  
  ApprovedReward AS ApprovedRewardRedeem,  
  ApprovedReward*mPPOneLoyaltyPointIsEqualTo AS ApprovedRewardRedeemAmount,  
  PointsReturnCTD AS RewardReturn,  
  PointsReturnCTD*mPPOneLoyaltyPointIsEqualTo AS RewardReturnAmount,  
  ISNULL(RewardAbandonedCTD,0) AS RewardAbandoned,  
  ISNULL(RewardAbandonedCTD,0)*mPPOneLoyaltyPointIsEqualTo AS RewardAbandonedAmount,  
  ISNULL(RewardAbandonedRevCTD,0) AS RewardAbandonedReversal,  
  ISNULL(RewardAbandonedRevCTD,0)*mPPOneLoyaltyPointIsEqualTo AS RewardAbandonedReversalAmount,  
  (de_LytPrgSeg_YTD_CreditsAmount+de_LytPrgSeg_YTD_DebitsAdjustmentsAmount + PointsRecoveredYTD)-(de_LytPrgSeg_YTD_DebitsAmount+de_LytPrgSeg_YTD_CreditAdjustmentsAmount) AS PointsEarnedYTD,  
  ((de_LytPrgSeg_YTD_CreditsAmount+de_LytPrgSeg_YTD_DebitsAdjustmentsAmount + PointsRecoveredYTD)-(de_LytPrgSeg_YTD_DebitsAmount+de_LytPrgSeg_YTD_CreditAdjustmentsAmount))*mPPOneLoyaltyPointIsEqualTo AS AmountEarnedYTD,  
  (de_LytPrgSeg_LTD_CreditsAmount+de_LytPrgSeg_LTD_DebitAdjustmentsAmount + PointsRecoveredLTD)-(de_LytPrgSeg_LTD_DebitsAmount+de_LytPrgSeg_LTD_CreditAdjustmentsAmount) AS PointsEarnedLTD,  
  ((de_LytPrgSeg_LTD_CreditsAmount+de_LytPrgSeg_LTD_DebitAdjustmentsAmount + PointsRecoveredLTD)-(de_LytPrgSeg_LTD_DebitsAmount+de_LytPrgSeg_LTD_CreditAdjustmentsAmount))*mPPOneLoyaltyPointIsEqualTo AS AmountEarnedLTD  
 FROM LPSegmentAccounts  
 --JOIN LPAccounts ON(parent01AID=acctId)  
 LEFT JOIN ccardLookup ON(ccardLookup.LUTid='LPProgramName' AND ccardLookup.LutCode =parent01AID)  
 WHERE parent02AID = @BSAccountId  
  
/*  
SELECT  
  Customer.ClientID,  
  Customer.customeruniversaluniqueid as CustomerUUID,  
  Customer.CustomerId as CustomerID,  
  Customer.ParentClientID,  
  Customer.ParentCustomerID,  
  Customer.PartnerID,  
  CurrentBalance AS LoyaltyPoints,  
  CurrentBalance*0.01 AS LoyaltyRewardBalance,  
  BeginningBalance AS RewardBeginningBalance,  
  BeginningBalance * 0.01 AS RewardBeginingBalanceAmount,  
  ((CreditAmountCTD + DebitAdjustmentAmountCTD + PointsRecoveredCTD)-(DebitAmountCTD + CreditAdjustmentAmountCTD)) AS RewardEarned,  
  ((CreditAmountCTD + DebitAdjustmentAmountCTD + PointsRecoveredCTD)-(DebitAmountCTD + CreditAdjustmentAmountCTD)) * 0.01 AS RewardEarnedAmount,  
  PointsForfeitedCTD AS RewardForfeited,  
  PointsForfeitedCTD * 0.01  AS RewardForfeitedAmount,  
  PointsRecoveredCTD AS RewardRecovered,  
  PointsRecoveredCTD * 0.01  AS RewardRecoveredAmount,  
  PendingRedeemBalance AS PendingRedeemRewardBalance,  
  PendingRedeemBalance * 0.01  AS PendingRedeemRewardBalanceAmount,  
  RedemptionAmountCTD AS RewardRedeemed,  
  RedemptionAmountCTD * 0.01  AS RewardRedeemedAmount,  
  RedemptionReversalAmountCTD AS RedeemReversalBalance,  
  RedemptionReversalAmountCTD * 0.01  AS RedeemReversalBalanceAmount,  
  PointsReturnedCTD AS RewardReturn,  
  PointsReturnedCTD * 0.01  AS RewardReturnAmount,  
  ISNULL(RewardAbandonedCTD,0) AS RewardAbandoned,  
  ISNULL(RewardAbandonedCTD,0) * 0.01  AS RewardAbandonedAmount,  
  ISNULL(RewardAbandonedRevCTD,0) AS RewardAbandonedReversal,  
  ISNULL(RewardAbandonedRevCTD,0) * 0.01  AS RewardAbandonedReversalAmount,  
  (CreditAmountLTD + DebitAdjustmentAmountLTD + PointsRecoveredLTD)-(DebitAmountLTD + CreditAdjustmentAmountLTD) AS PointsEarnedLTD,  
  ((CreditAmountLTD + DebitAdjustmentAmountLTD + PointsRecoveredLTD)-(DebitAmountLTD + CreditAdjustmentAmountLTD)) * 0.01 AS AmountEarnedLTD  
 FROM LPSCustomerDetails   
 JOIN Customer  on (Customer.CustomerID = LPSCustomerDetails.CustomerID)  
 WHERE LPSCustomerDetails.BsAcctId = @BSAccountId  
  
  
 SELECT  
  CIC.ClientID,  
  CIC.customeruniversaluniqueid as CustomerUUID,  
  CIC.CustomerId as CustomerID,  
  CIC.ParentClientID,  
  CIC.ParentCustomerID,  
  CIC.PartnerID,  
  cac.PendingPurchase as PendingPurchases,  
  cac.Purchase as ClearedPurchases  
 from Address A  
 JOIN Customer CIC on(CIC.customerid=A.customerid)  
 JOIN syn_coreauth_customer cac on(CIC.customerid=A.customerid)  
 where A.parent02AID = @BSAccountId  
 */  
END
GO


