CREATE  or alter  PROC [p_Get_AccountInfoForReport_By_BusinessDay_InstitutionID]    
AS    
/*************************************************************************    
** Name:p_Get_AccountInfoForReport_By_BusinessDay_InstitutionID    
** Desc:p_Get_AccountInfoForReport_By_BusinessDay_InstitutionID SSIS proc    
**************************************************************************    
**History    
**************************************************************************/    
SET NOCOUNT ON    
BEGIN    
 DECLARE @BusinessDay DATETIME,@InstitutionID INT,@Skey DECIMAL(19)    
    
 SELECT TOP 1 @BusinessDay= t.BusinessDay,@InstitutionID=t.InstitutionID FROM t_dba_SSIS_Variables_EODControlData t    
 JOIN EODControlData(NOLOCK) Eod ON t.Skey=Eod.Skey    
 WHERE Eod.JobStatus='InProgress'     
 ORDER BY t.Rec_CreatedDt ASC    
     
 SELECT [BusinessDay]    
      ,[BSAcctid]    
      ,[AccountNumber]    
      ,[DateOfNextStmt]    
      ,[LastStatementDate]    
      ,[CurrentBalance]    
      ,[Principal]    
      ,[ServiceFeesBNP]    
      ,[ServiceChargeCTD]    
      ,[LateFeesBNP]    
      ,[LateChargesCTD]    
      ,[AmountOfTotalDue]    
      ,[FixedPaymentAmt]    
      ,[FixedPaymentPercent]    
      ,[PaymentType]    
      ,[SKey]    
      ,[SystemStatus]    
      ,[InstitutionID]    
      ,[ProductID]    
      ,[PaymentLevel]    
      ,[CycleDueDTD]    
      ,[AmtOfPayCurrDue]    
      ,[NSFFeesBilledNotPaid]    
      ,[ccinhparent125AID]    
      ,[BeginningBalance]    
      ,[ccinhparent127AID]    
      ,[BillingCycle]    
      ,[DateOfTotalDue]    
      ,[CreditLimit]    
      ,[AmtOfAcctHighBalLTD]    
      ,[TotalOutStgAuthAmt]    
      ,[PendingOTB]    
      ,[LastActivityDateOfBilling]    
      ,[recoveryfeesbnp]    
      ,[RecoveryFeesCTD]    
      ,[MerchantID]    
      ,[NSFFeesCTD]    
      ,[MembershipFeesBNP]    
      ,[MembershipFeesCTD]    
      ,[OverlimitFeesBNP]    
      ,[AmtOfOvrLimitFeesCTD]    
      ,[CollectionFeesBNP]    
      ,[CollectionFeesCTD]    
      ,[InsuranceFeesBnp]    
      ,[AmtOfPayXDLate]    
      ,[AmountOfPayment30DLate]    
      ,[AmountOfPayment60DLate]    
      ,[AmountOfPayment90DLate]    
      ,[AmountOfPayment120DLate]    
      ,[AmountOfPayment150DLate]    
      ,[AmountOfPayment180DLate]    
      ,[AmountOfPayment210DLate]    
      ,[DaysDelinquent]    
      ,[TotalDaysDelinquent]    
      ,[DateOfDelinquency]    
      ,[DateOfOriginalPaymentDueDTD]    
      ,[LateFeesLTD]    
      ,[ChargeOffDate]    
      ,[CashBalance]    
      ,[EnterCollectionDate]    
      ,[AmountOfDebitsCTD]    
      ,[AmountOfCreditsCTD]    
      ,[DisputesAmtNS]    
      ,[SystemChargeOffStatus]    
      ,[PrePaidAmount]    
      ,[WaiveLateFees]    
      ,[WaiveOverlimitFee]    
      ,[WaiveMembershipFee]    
      ,[WaiveTranFeeNCharOff]    
      ,[LastCreditDate]    
      ,[DateofLastDebit]    
      ,[AmtOfInterestYTD]    
      ,[LastNSFPayRevDate]    
      ,[AmountOfPaymentsMTD]    
      ,[userchargeoffstatus]    
      ,[AlternateAccount]    
      ,[NumberAccounts]    
      ,[FieldTitleTAD1]    
      ,[DateAcctClosed]    
      ,[RecencyDue]    
      ,[CurrentBalanceCo]    
      ,[OriginalDueDate]    
      ,[DlqOneCpdLtdCount]    
      ,[DlqTwoCpdLtdCount]    
      ,[DlqThreePlusCpdLtdCount]    
      ,[PriEmbActivationFlag]    
      ,[AccountStatusChangeDate]    
      ,[CreditlimitPrev]    
      ,[CLChangeDate]    
      ,[StatementRunningBalance]    
      ,[StatementRemainingBalance]    
      ,[CollateralID]    
      ,[RunningMinimumDue]    
      ,[RemainingMinimumDue]    
      ,[ManualInitialChargeOffReason]    
      ,[AutoInitialChargeOffReason]    
      ,[ChargeOffDateParam]    
      ,[IntWaiveForSCRA]    
      ,[LAD]    
      ,[DateAcctOpened]    
      ,[WaiveInterest]    
      ,[WaiveInterestFor]    
      ,[WaiveInterestFrom]    
      ,[BSWFeeIntStartDate]    
      ,[CashLmtAmt]    
	  ,[LastReportedInterestDate]    
	  ,[AmountOfPurchasesLTD]    
      ,[AmtOfDispRelFromOTB]    
      ,[SRBWithInstallmentDue]   
      ,[SBWithInstallmentDue]  
	  ,[InstallmentOutStgAmt]  
	  ,[CreditOutStgAmt]  
	  ,[ActualDRPStartDate]
	  ,[StatusReason]
	  ,[TotalAmountCO]
	  ,[AfterCycleRevolvBSFC]
	  ,[AccountGraceStatus]
	  ,[AmountOfReturnsLTD]
	  ,[LAPD]
	  ,[EffectiveEndDate_Acct]
	  ,[MinDueRequired]
	  ,[SCRAEffectiveDate]
	  ,[SCRAEndDate]
	  ,[ReageStatus]
	  ,[ReageStartDate]
	  ,[ReageEndDate]
	  ,[ReagePaymentAmt]
	  ,[PODID]
 FROM AccountInfoForReport WITH(NOLOCK)     
 WHERE BusinessDay=@BusinessDay  AND InstitutionID=@InstitutionID    
    
    
  IF object_id('Temp_dba_AccountInfoForReport') IS NOT NULL      
  DROP TABLE Temp_dba_AccountInfoForReport      
        
  SELECT DISTINCT BSAcctid INTO Temp_dba_AccountInfoForReport      
  FROM AccountInfoForReport WITH(NOLOCK)       
  WHERE BusinessDay=@BusinessDay       
    AND InstitutionID=@InstitutionID      
     
       
  CREATE CLUSTERED INDEX idxc_Temp_BSAcctid_1 ON Temp_dba_AccountInfoForReport(BSAcctid)        
     
  
     
    
    
END 