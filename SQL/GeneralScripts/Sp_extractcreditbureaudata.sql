USE [PARASHAR_CB_CI]
GO

/****** Object:  StoredProcedure [dbo].[Sp_extractcreditbureaudata]    Script Date: 4/13/2018 11:32:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[Sp_extractcreditbureaudata] (@BSAcctID  INT, 
                                                     @CycleDate DATETIME, 
                                                     @SSN       VARCHAR(9), 
                                                     @Skey      DECIMAL(19)) 
AS 
    SET nocount ON 
    SET @BSAcctID = Isnull(@BSAcctID, 0) 

    DECLARE @SPQuery        NVARCHAR(1000), 
            @ParmDefinition NVARCHAR(500) 

  BEGIN 
      DECLARE @tempdisp TABLE 
        ( 
           skey          INT IDENTITY(1, 1) NOT NULL, 
           disputetranid DECIMAL(19), 
           disputestage  CHAR(2) 
           UNIQUE CLUSTERED (skey) 
        ) 
      DECLARE @BankRuptcyFileDate              DATETIME, 
              @CBRStatusGroup_val              CHAR(2), 
              @CBRlutdesc_ASCBRStatusGroup     VARCHAR(80), 
              @CBRlutdesc_ASCBRStatusGroupSys  VARCHAR(80), 
              @CBR_ManualStatusCCC			   VARCHAR(80), 
              @CBR_SystemStatusCCC            VARCHAR(80), 
              @CBR_ManualStatusSpecialComments VARCHAR(80), 
              @CBR_SystemStatusSpecialComments VARCHAR(80), 
              @AcctSystemStatus                INT, 
              @ManualStatus                    INT, 
              @amountdue                       MONEY, 
              @SpecialComments                 CHAR(2), 
              @ComplianceCode                  CHAR(2), 
              @CBRIndicator                    VARCHAR(2), 
              @SpecialComments_Drived          CHAR(2), 
              @ComplianceCode_Drived           CHAR(2), 
              @SpecialComments_Reported        CHAR(2), 
              @ComplianceCode_Reported         CHAR(2), 
              @FCRADisputeStatus               CHAR(2), 
              @FCRACustomerDisagree            TINYINT, 
              @Count1                          INT, 
              @CBRCount1                       INT, 
              @AcctInCollectionsSystem         CHAR(5), 
              @AcctReportedInCollections       CHAR(5), 
              @AcctManualStatus                INT, 
              @StatementdatePayHist1           DATETIME, 
              @StatementdatePayHist2           DATETIME, 
              @SystemstatusPayHist             INT, 
              @CurrentBalancePayHist           MONEY, 
              @EnterCollectionDate             DATETIME, 
              @RemoveFromCollDate              DATETIME, 
              @PayhistCount1                   INT, 
              @BSDtOfLastDelinqCTD             DATETIME, 
              @DateOfOriginalPaymentDueDTD     DATETIME --Defect ID :165879  
              ----Cursor related Elements     
              , 
              @acctid                          INT, 
              @StatementID                     DECIMAL(19), 
              @StatementDate                   DATETIME, 
              @SocialSecurityNumber            CHAR(9), 
              @DateAcctClosed                  DATETIME, 
              @NoPayDaysDelinquent             INT, 
              @accountnumber                   VARCHAR(19), 
              @PrimaryAccountNumber            VARCHAR(19), 
              @DateAcctOpened                  DATETIME, 
              @CreditLimit                     MONEY, 
              @AmtOfAcctHighBalLTD             MONEY, 
              @CurrentBalance                  MONEY, 
              @AmtOfPayCurrDue                 MONEY, 
              @AmountOfPaymentsCTD             MONEY, 
              @SystemStatus                    INT, 
              @AmtOfPayPastDue                 MONEY, 
              @totalamountco                   MONEY, 
              @lastpmtdate                     DATETIME, 
              @SNSuffix                        VARCHAR(8), 
              @nameline1                       VARCHAR(40), 
              @nameline2                       VARCHAR(40), 
              @nameline3                       VARCHAR(40), 
              @homephone                       VARCHAR(19), 
              @ccinhparent125AID               INT, 
              @cycleduedtd                     INT, 
              @daysdelinquent            INT, 
              @billingcycle                    CHAR(5), 
              @currentbalanceco                MONEY, 
              @AmountOfTotalDue                MONEY, 
              @addressline1                    VARCHAR(40), 
              @addressline2                    VARCHAR(40), 
              @city                            VARCHAR(40), 
              @stateprovince                   VARCHAR(5), 
              @postalcode                      VARCHAR(10), 
              @institutionid                   INT, 
              @countryCode                     VARCHAR(2) 
              ----Detail Table related     
              , 
              @CBR_StatementDate               DATETIME, 
              @CBR_acctId                      INT, 
              @CBR_ProcessedStatus             INT, 
              @CBR_RecordDescriptor            CHAR (4), 
              @CBR_ProcessingIndicator         CHAR (1), 
              @CBR_CBRStatementDate            DATETIME, 
              @CBR_CorrectionIndicator         CHAR (1), 
              @CBR_IdentificationNumber        VARCHAR (20), 
              @CBR_BillingCycle                VARCHAR (5), 
              @CBR_AccountNumber               VARCHAR (30), 
              @CBR_PortfolioType               CHAR (1), 
              @CBR_AccountType                 CHAR (2), 
              @CBR_CreatedTime                 DATETIME, 
              @CBR_CreditLimit                 MONEY, 
              @CBR_HighestCredit               MONEY, 
              @CBR_TermsDuration               CHAR (3), 
              @CBR_TermsFrequency              CHAR (1), 
              @CBR_SchMonthlyPaymentAmt        MONEY, 
              @CBR_ActualPaymentAmt            MONEY, 
              @CBR_AccountStatus               CHAR (2), 
              @CBR_PaymentRating               CHAR (1), 
              @CBR_PaymentHistProfile          VARCHAR (24), 
              @CBR_SpecialComment              CHAR (2), 
              @CBR_ComplianceConditionCode     CHAR (2), 
              @CBR_CurrentBalance              MONEY, 
              @CBR_PastDueAmount               MONEY, 
              @CBR_OriginalChargeOffAmt        MONEY, 
              @CBR_AccountInfoDate             DATETIME, 
              @CBR_FCRACompliance              DATETIME, 
              @CBR_DateAcctClosed              DATETIME, 
              @CBR_LastPaymentDate             DATETIME, 
              @CBR_DetailReserved              VARCHAR (17), 
              @CBR_ConsumerTransactionType     VARCHAR (1), 
              @CBR_Nameline3                   VARCHAR (25), 
              @CBR_Nameline1                   VARCHAR (20), 
              @CBR_Nameline2                   VARCHAR (20), 
              @CBR_SNSuffix                    CHAR (5), 
              @CBR_SocialSecurityNumber        VARBINARY(60)--Defect ID : 165958 
              , 
              @CBR_SocialSecurityNumber_Hash   INT--Defect ID : 165958 
              , 
              @CBR_DateOfBirth                 DATETIME, 
              @CBR_Homephone                   VARCHAR (10), 
              @CBR_ECOACode                    CHAR (1), 
              @CBR_ConsumerInfoIndicator       CHAR (2), 
              @CBR_CountryCode                 CHAR (2), 
              @CBR_Addressline1                VARCHAR (32), 
              @CBR_Addressline2                VARCHAR (32), 
              @CBR_City                        VARCHAR (20), 
              @CBR_Stateprovince               CHAR (2), 
              @CBR_Postalcode                  VARCHAR (9), 
              @CBR_ResidenceCode               CHAR (1), 
              @CBR_AddressIndicator            CHAR (1), 
              @CBR_FCRACompliance_New          DATETIME --Defect ID :165879      
              ----Other temp variables     
              , 
              @CycleDateTime                   DATETIME, 
              @TotalNoOfAccts                  INT, 
              @ActualTotalNoOfAccts            INT, 
              @Start                           INT, 
              @END                             INT, 
              @Max                             INT, 
              @MaxReached                      INT, 
              @NoOfStmts                       INT, 
              @starttime                       DATETIME, 
              @StartAcctID                     BIGINT, 
              @ENDAcctID                       BIGINT, 
              @ChunkSize                       INT, 
              @MPD                             BIGINT, 
              @TILADispute_Stage               CHAR(5), 
              @CCC                             CHAR(2), 
              @Previous_ConsumerInfoInd        CHAR(2), 
              @AcctQualifiesBasedOnStatus      INT, 
              @AcctQualifiesBasedOnRandomDigit INT, 
              @AcctFinalSelection              INT, 
              @AlreadyReported                 INT, 
              @RandomDigit                     INT, 
              @CaseOpENDate                    DATETIME 
              --,@TH_Cntr int     
              ----Dispute Related ComplianceConditionCode     
              , 
              @TILADisputeCurrentStage         CHAR(5), 
              @TILADisputeOpen                 INT, 
              @TILADisputeResolved             INT, 
              @TILADisputeReversed             INT, 
              @TILADisputeCount                INT, 
              @TILADisputeTranID               DECIMAL(19), 
              @TILACustomerDisagree            TINYINT 
              ----Payment History Profile Elements     
              , 
              @ReportHistoryCtrCC01            INT, 
              @ReportHistoryCtrCC02            INT, 
              @ReportHistoryCtrCC03            INT, 
              @ReportHistoryCtrCC04            INT, 
              @ReportHistoryCtrCC05            INT, 
              @ReportHistoryCtrCC06            INT, 
              @ReportHistoryCtrCC07            INT, 
              @ReportHistoryCtrCC08            INT, 
              @ReportHistoryCtrCC09            INT, 
              @ReportHistoryCtrCC10            INT, 
              @ReportHistoryCtrCC11            INT, 
              @ReportHistoryCtrCC12            INT, 
              @ReportHistoryCtrCC13            INT, 
              @ReportHistoryCtrCC14            INT, 
              @ReportHistoryCtrCC15            INT, 
              @ReportHistoryCtrCC16            INT, 
              @ReportHistoryCtrCC17            INT, 
              @ReportHistoryCtrCC18            INT, 
              @ReportHistoryCtrCC19            INT, 
              @ReportHistoryCtrCC20            INT, 
              @ReportHistoryCtrCC21            INT, 
              @ReportHistoryCtrCC22            INT, 
              @ReportHistoryCtrCC23            INT, 
              @ReportHistoryCtrCC24            INT 
              ----Debugging related     
              , 
              @B_StmtHdr                       DATETIME, 
              @A_StmtHdr                       DATETIME, 
              @B_CBRD1                         DATETIME, 
              @A_CBRD1                         DATETIME, 
              @B_BS                            DATETIME, 
              @A_BS                            DATETIME, 
              @B_StmtHdrEx                     DATETIME, 
              @A_StmtHdrEx                     DATETIME, 
              @B_Disp                          DATETIME, 
              @A_Disp                          DATETIME, 
              @B_CBRD2                         DATETIME, 
              @A_CBRD2                         DATETIME, 
              @B_CBRD3                         DATETIME, 
              @A_CBRD3                         DATETIME, 
              @B_Insert                        DATETIME, 
              @A_Insert                      DATETIME, 
              @StmtHdr                         INT, 
              @CBRD1                           INT, 
              @BS                              INT, 
              @StmtHdrEx                       INT, 
              @Disp                            INT, 
              @CBRD2                           INT, 
              @CBRD3                           INT, 
              @CBRInsert                       INT, 
              @Tot                             INT 
              ----J1 J2 segment elements     
              , 
              @SegmentIdentifier_J1            VARCHAR(2), 
              @ConsumerTransactionType_J1      VARCHAR(1), 
              @Surname_J1                      VARCHAR(25), 
              @FirstName_J1                    VARCHAR(20), 
              @MiddleName_J1                   VARCHAR(20), 
              @GenerationCode_J1               VARCHAR(1), 
              @SocialSecurityNumber_J1         VARCHAR(9), 
              @DateofBirth_J1                  DATETIME, 
              @TelephoneNumber_J1              VARCHAR(10), 
              @ECOACode_J1                     VARCHAR(1), 
              @ConsumerInformationIndicator_J1 VARCHAR(2), 
              @Reserved_J1                     VARCHAR(1), 
              @J1count                         INT, 
              @SegmentIdentifier_J2            VARCHAR(2), 
              @ConsumerTransactionType_J2      VARCHAR(1), 
              @Surname_J2                      VARCHAR(25), 
              @FirstName_J2                    VARCHAR(20), 
              @MiddleName_J2                   VARCHAR(20), 
              @GenerationCode_J2               VARCHAR(1), 
              @SocialSecurityNumber_J2         VARCHAR(9), 
              @DateofBirth_J2                  DATETIME, 
              @TelephoneNumber_J2              VARCHAR(10), 
              @ECOACode_J2                     VARCHAR(1), 
              @ConsumerInformationIndicator_J2 VARCHAR(2), 
              @CountryCode_J2                  VARCHAR(2), 
              @FirstLineofAddress_J2           VARCHAR(32), 
              @SecondLineofAddress_J2          VARCHAR(32), 
              @City_J2                         VARCHAR(20), 
              @State_J2                        VARCHAR(2), 
              @PostalCode_J2                   VARCHAR(9), 
              @AddressIndicator_J2             VARCHAR(1), 
              @ResidenceCode_J2                VARCHAR(1), 
              @Reserved_J2                     VARCHAR(2), 
              @J2count                         INT, 
              @custaddcnt                      INT, 
              @NewRecord                       INT, 
              @AddressType_J1                  INT, 
              @AddressType_J2                  INT, 
              @ChargeOffDate                   DATETIME, 
              @CBR_AccountStatus_DF            CHAR (2), 
              @CBR_PrimaryAccountNumber        VARBINARY(100), 
              @CBR_PAN_Hash                    INT, 
              @ConversionDate                  DATETIME,
			  @Merchantid					   INT

      SET @ConversionDate = '2014-10-31 23:59:57.000'--Mayors Conversion Date 
      -- SET null J1J2 segment elements             
      SELECT @SegmentIdentifier_J1 = NULL, 
             @ConsumerTransactionType_J1 = NULL, 
             @Surname_J1 = NULL, 
             @FirstName_J1 = NULL, 
             @MiddleName_J1 = NULL, 
             @GenerationCode_J1 = NULL, 
             @SocialSecurityNumber_J1 = NULL, 
             @DateofBirth_J1 = NULL, 
             @TelephoneNumber_J1 = NULL, 
             @ECOACode_J1 = NULL, 
             @ConsumerInformationIndicator_J1 = NULL, 
             @Reserved_J1 = NULL, 
             @J1count = NULL, 
             @SegmentIdentifier_J2 = NULL, 
             @ConsumerTransactionType_J2 = NULL, 
             @Surname_J2 = NULL, 
             @FirstName_J2 = NULL, 
             @MiddleName_J2 = NULL, 
             @GenerationCode_J2 = NULL, 
             @SocialSecurityNumber_J2 = NULL, 
             @DateofBirth_J2 = NULL, 
             @TelephoneNumber_J2 = NULL, 
             @ECOACode_J2 = NULL, 
             @ConsumerInformationIndicator_J2 = NULL, 
             @CountryCode_J2 = NULL, 
             @FirstLineofAddress_J2 = NULL, 
             @SecondLineofAddress_J2 = NULL, 
             @City_J2 = NULL, 
             @State_J2 = NULL, 
             @PostalCode_J2 = NULL, 
             @AddressIndicator_J2 = NULL, 
             @ResidenceCode_J2 = NULL, 
             @Reserved_J2 = NULL, 
             @J2count = NULL, 
             @custaddcnt = NULL, 
             @NewRecord = NULL, 
             @AddressType_J1 = NULL, 
             @AddressType_J2 = NULL, 
             @CycleDateTime = @CycleDate 

      SELECT @TotalNoOfAccts = Count(1) 
      FROM   dbo.statementheader WITH(nolock) 
      WHERE  acctid = @BSAcctID 
             AND statementdate = @CycleDate 

      IF ( @TotalNoOfAccts > 0 ) 
        BEGIN 
            SELECT @starttime = Getdate(), 
                   @acctId = NULL, 
                   @StatementID = NULL, 
                   @StatementDate = NULL, 
                   @accountnumber = NULL, 
                   @PrimaryAccountNumber = NULL, 
                   @DateAcctOpened = NULL, 
                   @CreditLimit = NULL, 
                   @AmtOfAcctHighBalLTD = NULL, 
                   @currentbalance = NULL, 
                   @AmtOfPayCurrDue = NULL, 
                   @AmountOfPaymentsCTD = NULL, 
                   @SystemStatus = NULL, 
                   @AmtOfPayPastDue = NULL, 
                   @totalamountco = NULL, 
                   @lastpmtdate = NULL, 
                   @nameline1 = NULL, 
                   @nameline2 = NULL, 
                   @nameline3 = NULL, 
                   @homephone = NULL, 
                   @ccinhparent125AID = NULL, 
                   @cycleduedtd = NULL, 
                   @billingcycle = NULL, 
                   @currentbalanceco = NULL, 
                   @AmountOfTotalDue = NULL, 
                   @addressline1 = NULL, 
                   @addressline2 = NULL, 
                   @city = NULL, 
                   @stateprovince = NULL, 
                   @postalcode = NULL, 
                   @SocialSecurityNumber = NULL, 
                   @DateAcctClosed = NULL, 
                   @NoPayDaysDelinquent = NULL, 
                   @daysdelinquent = NULL 

            -------Rohit ::queries and temp table to get account last 24 month history for td#84478       
            --SELECT @AcctInCollectionsSystem = AcctInCollectionsSystem,@RemoveFromCollDate= RemoveFromCollDate            
            --FROM DBO.BSegment_Secondary   WITH(NOLOCK)       
            --WHERE acctid = @BSAcctID        
            --SELECT  @EnterCollectionDate = EnterCollectionDate            
            --from DBO.BSegment_Primary  WITH(NOLOCK)        
            --WHERE acctid = @BSAcctID            
            SELECT sh.acctid, 
                   sh.statementdate, 
                   sh.systemstatus, 
                   Floor(sh.currentbalance) AS currentbalance, 
                   shx.entercollectiondate, 
                   shx.removefromcolldate, 
                   shx.acctincollectionssystem, 
                   sh.ccinhparent125aid 
            INTO   #accdetail 
            FROM   dbo.statementheader sh WITH(nolock) 
                   JOIN dbo.statementheaderex shx WITH(nolock) 
                     ON ( sh.acctid = shx.acctid 
                          AND sh.statementid = shx.statementid 
                          AND sh.statementdate = shx.statementdate ) 
            WHERE  sh.acctid = @BSAcctID 
                   AND sh.statementdate > @ConversionDate 

            UPDATE acct 
            SET    acct.currentbalance = cbr.currentbalance 
            FROM   #accdetail Acct WITH(nolock) 
                   JOIN dbo.cbreportingdetail cbr WITH(nolock) 
                     ON Acct.acctid = cbr.acctid 
                        AND Acct.statementdate = cbr.statementdate 

            SELECT TOP 1 @acctId = a.acctid, 
                         @StatementID = a.statementid, 
                         @StatementDate = a.statementdate, 
                         @accountnumber = a.accountnumber, 
                         @PrimaryAccountNumber = a.primaryaccountnumber, 
                         @DateAcctOpened = a.dateacctopened, 
                         @CreditLimit = a.creditlimit, 
                         @AmtOfAcctHighBalLTD = a.amtofaccthighballtd, 
                         @currentbalance = a.currentbalance, 
                         @AmtOfPayCurrDue = a.amtofpaycurrdue, 
                         @AmountOfPaymentsCTD = a.amountofpaymentsctd, 
                         @AmtOfPayPastDue = a.amtofpaypastdue, 
                         @totalamountco = a.totalamountco, 
                         @lastpmtdate = a.lastpmtdate, 
                         @nameline1 = a.nameline1, 
                         @nameline2 = a.nameline2, 
                         @nameline3 = a.nameline3, 
                         @homephone = a.homephone, 
                         @cycleduedtd = a.cycleduedtd, 
                         @AcctSystemStatus = a.systemstatus, 
                         @ManualStatus = a.ccinhparent125aid, 
                         @billingcycle = Datepart(day, a.statementdate), 
                         @currentbalanceco = a.currentbalanceco, 
                         @amountdue = a.amountoftotaldue, 
                         @AmountOfTotalDue = a.amountoftotaldue, 
                         @addressline1 = a.addressline1, 
                         @CBR_SNSuffix = a.snsuffix, 
                         @addressline2 = a.addressline2, 
                         @city = a.city, 
                         @stateprovince = a.stateprovince, 
                         @postalcode = a.postalcode, 
                         @countryCode = a.country, 
                         @institutionid = a.institutionid, 
                         @SpecialComments = a.cbrspecialcomments, 
                         @ComplianceCode = a.cbrcompliancecode, 
                         @SocialSecurityNumber = b.socialsecuritynumber, 
                         @NoPayDaysDelinquent = b.nopaydaysdelinquent, 
                         @daysdelinquent = b.daysdelinquent, 
                         @DateAcctClosed = b.dateacctclosed, 
                         @FCRADisputeStatus = c.fcradisputestatus, 
                         @FCRACustomerDisagree = c.fcracustomerdisagree, 
                         @TILADisputeCount = c.tiladisputecount, 
                         @TILADisputeOpen = c.tiladisputeopen, 
                         @TILADisputeResolved = c.tiladisputeresolved, 
                         @TILADisputeReversed = c.tiladisputereversed, 
                         @TILACustomerDisagree = c.tilacustomerdisagree, 
                         @CaseOpENDate = c.caseopendate, 
                         @BankRuptcyFileDate = c.bankruptcyfiledate, 
                         @FirstName_J1 = c.firstname_j1, 
                         @MiddleName_J1 = c.middlename_j1, 
                         @Surname_J1 = c.surname_j1, 
                         @SocialSecurityNumber_J1 = c.socialsecuritynumber_j1, 
                         @DateofBirth_J1 = c.dateofbirth_j1, 
                         @TelephoneNumber_J1 = c.telephonenumber_j1, 
                         @ConsumerTransactionType_J1 = c.consumertrantype_j1, 
                         @ConsumerInformationIndicator_J1 = 
                         c.consumerinfoindicator_j1, 
                         @J1count = c.j1count, 
                         @AddressType_J1 = c.addresstype_j1, 
                        @FirstName_J2 = c.firstname_j2, 
                         @MiddleName_J2 = c.middlename_j2, 
                         @Surname_J2 = c.surname_j2, 
                         @SocialSecurityNumber_J2 = c.socialsecuritynumber_j2, 
                         @DateofBirth_J2 = c.dateofbirth_j2, 
                         @TelephoneNumber_J2 = c.telephonenumber_j2, 
                         @ConsumerTransactionType_J2 = c.consumertrantype_j2, 
                         @ConsumerInformationIndicator_J2 = 
                         c.consumerinfoindicator_j2, 
                         @ResidenceCode_J2 = c.residencecode_j2, 
                         @J2count = c.j2count, 
                         @AddressType_J2 = c.addresstype_j2, 
                         @FirstLineofAddress_J2 = c.firstlineofaddress_j2, 
                         @SecondLineofAddress_J2 = c.secondlineofaddress_j2, 
                         @City_J2 = c.city_j2, 
                         @State_J2 = c.state_j2, 
                         @CountryCode_J2 = c.countrycode_j2, 
                         @PostalCode_J2 = c.postalcode_j2, 
                         @CBR_ConsumerTransactionType = c.cbrconsumertxntype, 
                         @CBR_DateOfBirth = c.dateofbirth, 
                         @ReportHistoryCtrCC01 = c.reporthistoryctrcc01, 
                         @ReportHistoryCtrCC02 = c.reporthistoryctrcc02, 
                         @ReportHistoryCtrCC03 = c.reporthistoryctrcc03, 
                         @ReportHistoryCtrCC04 = c.reporthistoryctrcc04, 
                         @ReportHistoryCtrCC05 = c.reporthistoryctrcc05, 
                         @ReportHistoryCtrCC06 = c.reporthistoryctrcc06, 
                         @ReportHistoryCtrCC07 = c.reporthistoryctrcc07, 
                         @ReportHistoryCtrCC08 = c.reporthistoryctrcc08, 
                         @ReportHistoryCtrCC09 = c.reporthistoryctrcc09, 
                         @ReportHistoryCtrCC10 = c.reporthistoryctrcc10, 
                         @ReportHistoryCtrCC11 = c.reporthistoryctrcc11, 
                         @ReportHistoryCtrCC12 = c.reporthistoryctrcc12, 
                         @ReportHistoryCtrCC13 = c.reporthistoryctrcc13, 
                         @ReportHistoryCtrCC14 = c.reporthistoryctrcc14, 
                         @ReportHistoryCtrCC15 = c.reporthistoryctrcc15, 
                         @ReportHistoryCtrCC16 = c.reporthistoryctrcc16, 
                         @ReportHistoryCtrCC17 = c.reporthistoryctrcc17, 
                         @ReportHistoryCtrCC18 = c.reporthistoryctrcc18, 
                         @ReportHistoryCtrCC19 = c.reporthistoryctrcc19, 
                         @ReportHistoryCtrCC20 = c.reporthistoryctrcc20, 
                         @ReportHistoryCtrCC21 = c.reporthistoryctrcc21, 
                         @ReportHistoryCtrCC22 = c.reporthistoryctrcc22, 
                         @ReportHistoryCtrCC23 = c.reporthistoryctrcc23, 
                         @ReportHistoryCtrCC24 = c.reporthistoryctrcc24, 
                         @CBR_ConsumerInfoIndicator = c.consumerinfoindicator, 
                         --Added New filed in StatementHeaderEx from Label 12.18.8   
                         @CBRIndicator = Isnull(b.cbrindicator, ''), 
                         @AcctInCollectionsSystem = b.acctincollectionssystem, 
                         @EnterCollectionDate = b.entercollectiondate, 
                         @RemoveFromCollDate = b.removefromcolldate, 
                         @BSDtOfLastDelinqCTD = b.dtoflastdelinqctd, 
                         @ChargeOffDate = a.chargeoffdate, 
                         @CBR_SocialSecurityNumber = b.socialsecuritynumber, 
                         @CBR_SocialSecurityNumber_Hash = b.ssn_hash, 
                         @DateOfOriginalPaymentDueDTD = a.dateoforiginalpaymentduedtd ,
						 @Merchantid= a.parent05aid
            --Defect ID :165879  
            FROM   dbo.statementheader a WITH(nolock) 
                   JOIN dbo.statementheaderex b WITH(nolock) 
                     ON( a.acctid = b.acctid 
                         AND a.statementid = b.statementid 
                         AND a.statementdate = b.statementdate ) 
                   JOIN dbo.cbrstatementdetails c WITH(nolock) 
                     ON( a.acctid = c.acctid 
                         AND a.statementid = c.statementid 
                         AND a.statementdate = c.statementdate 
                         AND c.skey = @Skey ) 
            WHERE  a.acctid = @BSAcctID 
                   AND a.statementdate = @CycleDateTime 
            ORDER  BY a.acctid, 
                      a.statementdate 

            SELECT TOP 1 @CBR_PrimaryAccountNumber = primaryaccountnumber, 
                         @CBR_PAN_Hash = pan_hash 
            FROM   dbo.embossingaccounts WITH(nolock) 
            WHERE  parent01aid = @BSAcctID 
                   AND ecardtype = '0' 
            ORDER  BY ecreationdate DESC 

            SELECT @SystemStatus = @AcctSystemStatus, 
                   @ccinhparent125AID = @ManualStatus, 
                   @StartAcctid = @acctid, 
                   @AcctQualifiesBasedOnStatus = 1, 
                   @AcctQualifiesBasedOnRandomDigit = 1, 
                   @AcctFinalSelection = 0, 
                   @AlreadyReported = 0 
                   --SET Detail Table related     
                   , 
                   @CBR_acctId = @acctid, 
                   @CBR_StatementDate = @CycleDateTime, 
                   @CBR_ProcessedStatus = '0', 
                   @CBR_RecordDescriptor = '0726', 
                   @CBR_ProcessingIndicator = '1', 
                   @CBR_CBRStatementDate = @CycleDateTime 

            --Cents off without rounding off     
            --@AmtOfAcctHighBalLTD     
            SET @MPD = 0 
            SET @MPD = @AmtOfAcctHighBalLTD 

            IF ( @AmtOfAcctHighBalLTD > 0.5 
                 AND @MPD > @AmtOfAcctHighBalLTD ) 
              BEGIN 
                  SET @MPD = @AmtOfAcctHighBalLTD - 1 
              END 

            IF ( @AmtOfAcctHighBalLTD < 0 
                 AND @MPD < @AmtOfAcctHighBalLTD ) 
              BEGIN 
                  SET @MPD = @AmtOfAcctHighBalLTD + 1 
              END 

            SET @AmtOfAcctHighBalLTD = @MPD 
            --@AmountOfTotalDue             
            SET @MPD = 0 
            SET @MPD = @AmountOfTotalDue 

            IF ( @AmountOfTotalDue > 0.5 
                 AND @MPD > @AmountOfTotalDue ) 
              BEGIN 
                  SET @MPD = @AmountOfTotalDue - 1 
              END 

            IF ( @AmountOfTotalDue < 0 
                 AND @MPD < @AmountOfTotalDue ) 
              BEGIN 
                  SET @MPD = @AmountOfTotalDue + 1 
              END 

            SET @AmountOfTotalDue = @MPD 
            --@AmtOfPayCurrDue             
            SET @MPD = 0 
            SET @MPD = @AmtOfPayCurrDue 

            IF ( @AmtOfPayCurrDue > 0.5 
                 AND @MPD > @AmtOfPayCurrDue ) 
              BEGIN 
                  SET @MPD = @AmtOfPayCurrDue - 1 
              END 

            IF ( @AmtOfPayCurrDue < 0 
                 AND @MPD < @AmtOfPayCurrDue ) 
              BEGIN 
                  SET @MPD = @AmtOfPayCurrDue + 1 
              END 

            SET @AmtOfPayCurrDue = @MPD 
            --@AmountOfPaymentsCTD             
            SET @MPD = 0 
            SET @MPD = @AmountOfPaymentsCTD 

            IF ( @AmountOfPaymentsCTD > 0.5 
                 AND @MPD > @AmountOfPaymentsCTD ) 
              BEGIN 
                  SET @MPD = @AmountOfPaymentsCTD - 1 
              END 

            IF ( @AmountOfPaymentsCTD < 0 
                 AND @MPD < @AmountOfPaymentsCTD ) 
              BEGIN 
                  SET @MPD = @AmountOfPaymentsCTD + 1 
              END 

            SET @AmountOfPaymentsCTD = @MPD 
            --@currentbalanceco             
            SET @MPD = 0 
            SET @MPD = @currentbalanceco 

            IF ( @currentbalanceco > 0.5 
                 AND @MPD > @currentbalanceco ) 
              BEGIN 
                  SET @MPD = @currentbalanceco - 1 
              END 

            IF ( @currentbalanceco < 0 
                 AND @MPD < @currentbalanceco ) 
              BEGIN 
                  SET @MPD = @currentbalanceco + 1 
              END 

            SET @currentbalanceco = @MPD 
            --@CurrentBalance             
            SET @MPD = 0 
            SET @MPD = @CurrentBalance 

            IF ( @CurrentBalance > 0.5 
                 AND @MPD > @CurrentBalance ) 
              BEGIN 
                  SET @MPD = @CurrentBalance - 1 
              END 

            IF ( @CurrentBalance < 0 
                 AND @MPD < @CurrentBalance ) 
              BEGIN 
                  SET @MPD = @CurrentBalance + 1 
              END 

            SET @CurrentBalance = @MPD 
            --@AmtOfPayPastDue             
            SET @MPD = 0 
            SET @MPD = @AmtOfPayPastDue 

            IF ( @AmtOfPayPastDue > 0.5 
                 AND @MPD > @AmtOfPayPastDue ) 
              BEGIN 
                  SET @MPD = @AmtOfPayPastDue - 1 
              END 

            IF ( @AmtOfPayPastDue < 0 
                 AND @MPD < @AmtOfPayPastDue ) 
              BEGIN 
                  SET @MPD = @AmtOfPayPastDue + 1 
              END 

            SET @AmtOfPayPastDue = @MPD 
            --Original ChargeOff Amt @totalamountco             
            SET @MPD = 0 
            SET @MPD = @totalamountco 

            IF ( @totalamountco > 0.5 
                 AND @MPD > @totalamountco ) 
              BEGIN 
                  SET @MPD = @totalamountco - 1 
              END 

            IF ( @totalamountco < 0 
                 AND @MPD < @totalamountco ) 
              BEGIN 
                  SET @MPD = @totalamountco + 1 
              END 

            SET @totalamountco = @MPD 
            --Need to check IF previously sent to CB, IF yes need to SET to 1             
            --?0¬ = normal?1¬ = replacement (exception processing)             
            SET @CBR_CorrectionIndicator = '0' 

            --SET @CBR_IdentificationNumber = '401DM00213'              
            SELECT @CBR_IdentificationNumber = cbridnumber 
            FROM   orgaccounts WITH(nolock) 
            WHERE  acctid = @institutionid 

            SELECT @CBR_PortfolioType = cbrportfoliotype, 
                   @CBR_AccountType = cbraccounttype 
            FROM   org_balances WITH(nolock) 
            WHERE  acctid = @institutionid 

            SELECT @CBR_BillingCycle = @BillingCycle 
                   --SET @CBR_AccountNumber = @PrimaryAccountNumber     
                   , 
                   @CBR_AccountNumber = @accountnumber 
                   --,@CBR_PortfolioType = 'R'     
                   --,@CBR_AccountType = '07'     
                   , 
                   @CBR_CreatedTime = @DateAcctOpened, 
                   @CBR_CreditLimit = @CreditLimit, 
                   @CBR_HighestCredit = @AmtOfAcctHighBalLTD 

            IF @CBR_HighestCredit < 0 
              SET @CBR_HighestCredit = 0 

            SELECT @CBR_TermsDuration = 'REV', 
                   @CBR_TermsFrequency = 'M' 

            --- new code for ComplianceconditionCode and SpecialComment
			SELECT @CBR_ManualStatusCCC = a.ComplianceconditionCode,
			@CBR_SystemStatusSpecialComments = a.SpecialComment,
			@CBRlutdesc_ASCBRStatusGroup = 
                   (SELECT lutdescription 
                    FROM   dbo.ccardlookup WITH(nolock) 
                    WHERE  lutid = 'ASCBRStatusGroup' 
                           AND lutcode = a.cbrstatusgroup)
						    FROM   dbo.astatusaccounts a WITH(nolock) 
            WHERE  a.parent01aid = @ccinhparent125AID and a.MerchantAID = @Merchantid

			if (@@rowcount <= 0 ) --- if merchant status is not present for manual status
			Begin 
				SELECT @CBR_ManualStatusCCC = a.ComplianceconditionCode,
				@CBR_SystemStatusSpecialComments = a.SpecialComment,
				@CBRlutdesc_ASCBRStatusGroup = 
                   (SELECT lutdescription 
                    FROM   dbo.ccardlookup WITH(nolock) 
                    WHERE  lutid = 'ASCBRStatusGroup' 
                           AND lutcode = a.cbrstatusgroup)
						    FROM   dbo.astatusaccounts a WITH(nolock) 
					WHERE  a.acctid = @ccinhparent125AID 
			END


            SELECT @CBR_SystemStatusCCC = a.ComplianceconditionCode,
			@CBR_ManualStatusSpecialComments = a.SpecialComment,
			@CBRlutdesc_ASCBRStatusGroupSys = 
                   (SELECT lutdescription 
			FROM 
                   dbo.ccardlookup WITH(nolock) 
                                                      WHERE  lutid = 
                   'ASCBRStatusGroup' 
                                                             AND 
                                                     lutcode = a.cbrstatusgroup) 
            FROM   dbo.astatusaccounts a WITH(nolock) 
            WHERE   a.parent01aid = @ccinhparent125AID and a.MerchantAID = @Merchantid

			if (@@rowcount <= 0 ) --- if merchant status is not present for suystem status 
			Begin 
				    SELECT @CBR_SystemStatusCCC = a.ComplianceconditionCode,
					@CBR_ManualStatusSpecialComments = a.SpecialComment,
					@CBRlutdesc_ASCBRStatusGroupSys = 
						   (SELECT lutdescription 
					FROM 
						   dbo.ccardlookup WITH(nolock) 
															  WHERE  lutid = 
						   'ASCBRStatusGroup' 
																	 AND 
															 lutcode = a.cbrstatusgroup) 
					FROM   dbo.astatusaccounts a WITH(nolock) 
					WHERE   a.acctid = @ccinhparent125AID 
			ENd

            --- new code for ComplianceconditionCode and SpecialComment ENd
            IF @SystemStatus = '14' 
               AND @currentbalanceco <= 0 
              SET @CBR_AccountStatus = '64' 
            ELSE IF @SystemStatus = '14' 
               AND @currentbalanceco > 0 
              SET @CBR_AccountStatus = '97' 
            ELSE IF ( @CBRlutdesc_ASCBRStatusGroup = 'Closed' 
                  OR @CBRlutdesc_ASCBRStatusGroupSys = 'Closed' ) 
               AND @currentbalance <= 0 
              SET @CBR_AccountStatus = '13' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent >= 60 
                       AND @daysdelinquent <= 89 ) ) 
              SET @CBR_AccountStatus = '71' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent >= 90 
                       AND @daysdelinquent <= 119 ) ) 
              SET @CBR_AccountStatus = '78' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent >= 120 
                       AND @daysdelinquent <= 149 ) ) 
              SET @CBR_AccountStatus = '80' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent >= 150 
                       AND @daysdelinquent <= 179 ) ) 
              SET @CBR_AccountStatus = '82' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent >= 180 
                       AND @daysdelinquent <= 209 ) ) 
              SET @CBR_AccountStatus = '83' 
            ELSE IF ( ( @SystemStatus = '3' 
                    OR @SystemStatus = '1008' 
                    OR @SystemStatus = '1013' 
                    OR @SystemStatus = '1033' ) 
                 AND @amountdue > 0 
                 AND ( @daysdelinquent > 209 ) ) 
              SET @CBR_AccountStatus = '84' 
            ELSE 
              SET @CBR_AccountStatus = '11' 

            --IF ( @SystemStatus = '1028' 
            --      OR @ccinhparent125AID = '1028' ) 
            --  SET @CBR_AccountStatus = 'DF' 

			--ddharkar : 10 Aug 2017 - Report DA or DF based on Cbr Indicator set on acct.
			IF ( @CBRIndicator = '7')
				SET @CBR_AccountStatus = 'DA' --DA - Delete Account Without Fraud
			IF ( @CBRIndicator = '8')
				SET @CBR_AccountStatus = 'DF' --DF - Delete Account Confirmed Fraud			  

            --IF @CBR_AccountStatus = '11'             
            -- SET @CBR_SchMonthlyPaymentAmt = @AmountOfTotalDue             
            --ELSE           
            --Code Commented as per Waseed suggestion on the TU Testing.       
            SET @CBR_SchMonthlyPaymentAmt = @AmtOfPayCurrDue 

            IF @CBR_SchMonthlyPaymentAmt < 0 
              SET @CBR_SchMonthlyPaymentAmt = 0 

            SET @CBR_ActualPaymentAmt = @AmountOfPaymentsCTD 

            IF @CBR_ActualPaymentAmt < 0 
              SET @CBR_ActualPaymentAmt = 0 

            IF @CBR_AccountStatus = '13' 
              SET @CBR_PaymentRating = 
              Isnull(dbo.Getvaluefromcurrentbalanceaudit 
                     ( 
                     @BSAcctID, 51, @CycleDate, '115', 
                     '21'), Cast(@cycleduedtd AS VARCHAR) 
              ) 

            IF @CBR_PaymentRating = '0' 
                OR @CBR_PaymentRating = '1' 
                OR @CBR_PaymentRating = '2' 
              SET @CBR_PaymentRating = '0' 
            ELSE IF @CBR_PaymentRating <> '' 
               AND @CBR_PaymentRating IS NOT NULL 
               AND Cast(@CBR_PaymentRating AS INT) > 2 
              SET @CBR_PaymentRating = Cast(Cast(@CBR_PaymentRating AS INT) - 2 
                                            AS 
                                            VARCHAR) 
            ELSE 
              SET @CBR_PaymentRating = '' 

            SET @CBR_PaymentHistProfile = NULL 

            -- IF((@CBRlutdesc_ASCBRStatusGroup = 'Closed' OR @CBRlutdesc_ASCBRStatusGroupSys='Closed') AND @CBR_AccountStatus = '11' AND @currentbalance > 0) 
            --SET @CBR_SpecialComment = 'M' 
            IF ( @SystemStatus = '5' 
                  OR @ccinhparent125AID = '5' ) 
              SET @CBR_SpecialComment = 'CI' 
            ELSE IF ( @SystemStatus = '1013' 
                  OR @SystemStatus = '1033' 
                  OR @ccinhparent125AID = '1013' 
                  OR @ccinhparent125AID = '1033' ) 
              -- OR @SystemStatus ='11' OR @ccinhparent125AID ='11')  --added for close  account td#76459           
              SET @CBR_SpecialComment = 'M' 
            ELSE IF ( @SystemStatus = '9' 
                  OR @ccinhparent125AID = '9' ) 
              -- added for lost account td#76459     
              SET @CBR_SpecialComment = 'BL' 

			IF( ( @CBRlutdesc_ASCBRStatusGroup = 'Closed' OR @CBRlutdesc_ASCBRStatusGroupSys = 'Closed' ) AND 
				(@CBR_ManualStatusSpecialComments = '0' OR @CBR_SystemStatusSpecialComments = '0') )
					SET @CBR_SpecialComment = 'M'

            SET @SpecialComments_Drived=@CBR_SpecialComment 

            --If SpecialComments is overrided on Panel then use that Value
			
			--ddharkar : 17 April 2017 - CT Item ID: 17062 Short desc: Credit Bureau Comment and Compliance Codes.
			IF(@SpecialComments IS NOT NULL AND @SpecialComments = 'NO')
				SET @SpecialComments = NULL

            IF ( Isnull(@SpecialComments, '') <> '' 
                 AND @SpecialComments <> 'DF' ) 
              SET @CBR_SpecialComment = @SpecialComments 

            SET @SpecialComments_Reported=@CBR_SpecialComment 

            --IF (@ccinhparent125AID = 16) AND ((@TILADisputeCount = 0) or (@TILADisputeCount > 0 AND @TILADisputeCount = @TILADisputeResolved + @TILADisputeReversed))             
            --IF @ccinhparent125AID != 16 AND @TILADisputeCount > 0 AND @TILADisputeOpen > 0             
            
/* CCC Start :
				ddharkar : 18 Jan 2017 - ComplianceConditionCode reporting is manual process and should be set by CSR.
				So commenting automatic process of CCC reporting.
				
				Please Ref below mail.
				
				"CBR - Compliance Condition Codes"
				
				Hi Dan,

				We have some questions on Compliance Condition Code (CCC) reporting in CBR file. Please refer attached applicable 
				CCC from Metro2 Doc.
				We have following cases in which we need to report correct CCC.

				Case 1 : Account information disputed by consumer - then report 'XB' or 'XF'.
				Case 2 : Dispute resolved — consumer disagrees - then report 'XC' or 'XG'.
				Case 3 : Account closed at consumer’s request and dispute investigation completed, consumer disagrees - then report 'XE'.

				Question 1 : Its a Account Level Dispute or Transaction Level dispute? Account information disputed by consumer : Is it mean that
				there is any transaction which is in dispute initiate status or any other account level process.? <Dan Stavros>  Account level dispute. No transaction is a direct part of the dispute or resolution. 

				In Current processing , we are considering account dispute means, any transaction is in dispute initiate status. 
				For Ex : if customer makes any purchase and raise dispute on it then we will report CCC as 'XB' or 'XF'. 
				So is this the correct process or it should be manual process?  Manual process means , when ever there is any 
				dispute then CSR will update the information for bureau reporting that the Account information disputed by consumer.
				
				<Dan Stavros>  A transaction dispute should not automatically result in reporting of XB or XF. 
				Since the dispute process removes a transaction from what the customer owes there should be no adverse effect to 
				the information reported to the credit bureaus and hence no reason to report XB or XF. 
				These codes should be manually placed on an account by a CSR either directly or via a user status code. 

				Question 2 : Account disputed under "Fair Credit Reporting Act (FCRA)" or "Fair Credit Billing Act (FCBA)" ? 
				As per Metro2 Doc we need to report different CCC if, Account disputed under "Fair Credit Reporting Act (FCRA)" 
				or "Fair Credit Billing Act (FCBA)". In Current processing, we don't find any indicator that differentiate 
				dispute from FCRA or FCBA. 
				
				<Dan Stavros>  Hence the need for these codes to be placed on an account manually by a CSR. 
				We do not know what kind of dispute has been filed. 

				Question 3 : "Dispute resolved — consumer disagrees", we don't have this option available in current processing 
				on dispute resolve. Please suggest on these points. 
				
				<Dan Stavros>  Again, these codes are not to be used with transaction disputes. 
				They should only be reported when a CSR places them on an account manually. 

            
            IF ( @CBR_AccountStatus = '13' ) 
              --(@SystemStatus ='11' OR @ccinhparent125AID ='11')           
              SET @CBR_ComplianceConditionCode = 'XA' 
            ELSE IF( @TILADisputeCount > 0 
                AND @TILADisputeOpen > 0 ) 
              SET @CBR_ComplianceConditionCode = 'XF' 
            ELSE IF ( @TILADisputeResolved > 0 
                 AND @TILACustomerDisagree > 0 ) 
              SET @CBR_ComplianceConditionCode = 'XG' 
            ELSE IF( ( @CBRlutdesc_ASCBRStatusGroup = 'Closed' 
                   OR @CBRlutdesc_ASCBRStatusGroupSys = 'Closed' ) 
                AND @CBR_AccountStatus = '11' 
                AND @currentbalance > 0 ) 
              SET @CBR_ComplianceConditionCode='XA' 
            ELSE 
              SET @CBR_ComplianceConditionCode='' 

            --IF @ccinhparent125AID != 16 AND              
            --((@TILADisputeCount > 0 AND @TILADisputeOpen = 0 AND @TILADisputeResolved > 0) or              
            -- (@FCRADisputeStatus = 2))             
            -- SET @CBR_ComplianceConditionCode = 'XH'                  
            --IF @ccinhparent125AID = 16 AND @TILADisputeCount > 0 AND @TILADisputeOpen > 0             
            -- SET @CBR_ComplianceConditionCode = 'XJ'             
            --IF @FCRADisputeStatus = 1             
            -- SET @CBR_ComplianceConditionCode = 'XB'             
            --IF @FCRADisputeStatus = 2 AND @FCRACustomerDisagree = 1             
            -- SET @CBR_ComplianceConditionCode = 'XC'             
            --   IF (@TILADisputeResolved > 0 AND @TILACustomerDisagree > 0)             
            -- SET @CBR_ComplianceConditionCode = 'XG'             
            --IF @ccinhparent125AID = 16             
            --BEGIN             
            -- IF @FCRADisputeStatus = 1              
            --  SET @CBR_ComplianceConditionCode = 'XD'             
            -- IF (@FCRADisputeStatus = 2 AND @FCRACustomerDisagree = 1) or              
            --    (@TILADisputeResolved > 0 AND @TILACustomerDisagree > 0)             
            --  SET @CBR_ComplianceConditionCode = 'XE'             
            --END             
            SELECT TOP 1 @CCC = complianceconditioncode 
            FROM   dbo.cbreportingdetail WITH(nolock) 
            WHERE  acctid = @acctid 
                   AND ( complianceconditioncode IS NOT NULL 
                         AND complianceconditioncode <> '' ) 
            ORDER  BY acctid, 
                      statementdate DESC 

            SET @Count1=@@ROWCOUNT 

            IF @Count1 > 0 
              BEGIN 
                  IF( @CCC = @CBR_ComplianceConditionCode 
                      AND @CCC <> '' ) 
                    SET @CBR_ComplianceConditionCode='' 
                  ELSE IF ( @CBR_ComplianceConditionCode = '' 
                       AND @CCC <> '' 
                       AND @CCC <> 'XR' ) 
                    SET @CBR_ComplianceConditionCode='XR' 
              END 
CCC Ends :
*/ 

--ddharkar : 10 April 2017. Allow automatic CCC reporting for account Closed cases as per FINAL's request.
--CT 16965 : Credit Bureau Reporting for Closed by Consumer.
--TD 172692 - XA should be automatically assigned during status change as Closed on Consumer request.

			--10 April 2017 Code Start
			SET @CBR_ComplianceConditionCode = ''

            IF ( @CBR_AccountStatus = '13' AND (@CBR_ManualStatusCCC = '0' OR @CBR_SystemStatusCCC = '0')) 
              SET @CBR_ComplianceConditionCode = 'XA' 
            ELSE IF( ( @CBRlutdesc_ASCBRStatusGroup = 'Closed' 
                   OR @CBRlutdesc_ASCBRStatusGroupSys = 'Closed' ) AND (@CBR_ManualStatusCCC = '0' OR @CBR_SystemStatusCCC = '0') )
                --AND @CBR_AccountStatus = '11' 
                --AND @currentbalance > 0 ) 
              SET @CBR_ComplianceConditionCode = 'XA' 

			SELECT TOP 1 @CCC = complianceconditioncode 
            FROM   dbo.cbreportingdetail WITH(nolock) 
            WHERE  acctid = @acctid 
                   AND ( complianceconditioncode IS NOT NULL 
                         AND complianceconditioncode <> '' ) 
            ORDER  BY acctid, 
                      statementdate DESC 

            SET @Count1=@@ROWCOUNT 

            IF @Count1 > 0 
              BEGIN 
                  IF( @CCC = @CBR_ComplianceConditionCode 
                      AND @CCC <> '' ) 
                    SET @CBR_ComplianceConditionCode='' 
                  ELSE IF ( @CBR_ComplianceConditionCode = '' 
                       AND @CCC <> '' 
                       AND @CCC <> 'XR' ) 
                    SET @CBR_ComplianceConditionCode='XR' 
              END 
			  --10 April 2017 Code End

--If Compliance Condition Code is Overrrided on Account Then Use Same. 

			--SET @CBR_ComplianceConditionCode = ''
            
			--ddharkar : 17 April 2017 - CT Item ID: 17062 Short desc: Credit Bureau Comment and Compliance Codes.
			IF(@ComplianceCode IS NOT NULL AND @ComplianceCode = 'NO')
				SET @ComplianceCode = NULL
            
			IF( Isnull(@ComplianceCode, '') <> '' 
                AND @ComplianceCode <> 'DF' ) 
              BEGIN 
                  SET @CBR_ComplianceConditionCode=@ComplianceCode 
              END 

            SET @ComplianceCode_Drived=@CBR_ComplianceConditionCode 

            --If Compliance Condition Code is Overrrided on Account Then Use Same.   
            IF( Isnull(@ComplianceCode, '') <> '' 
                AND @ComplianceCode <> 'DF' ) 
              BEGIN 
                  SET @CBR_ComplianceConditionCode=@ComplianceCode 

					/*--10 April 2017 Code Start
					SELECT TOP 1 @CCC = complianceconditioncode 
					FROM   dbo.cbreportingdetail WITH(nolock) 
					WHERE  acctid = @acctid 
						   AND ( complianceconditioncode IS NOT NULL 
								 AND complianceconditioncode <> '' ) 
					ORDER  BY acctid, 
							  statementdate DESC 
					
					SET @Count1=@@ROWCOUNT 
                  
                  IF @Count1 > 0 
                    BEGIN --10 April 2017 Code End*/ 
                        IF( @CCC = @CBR_ComplianceConditionCode 
                            AND @CCC <> '' ) 
                          SET @CBR_ComplianceConditionCode='' 
                    --END 
              END 

            SET @ComplianceCode_Reported=@CBR_ComplianceConditionCode 

            --CurrentBalance Calculation      
            --Added Condition as we have some Account who's Credit Limit is 0            
            IF ( @CBR_AccountStatus = '64' 
                  OR @CBR_AccountStatus = '97' ) 
               AND @CreditLimit > 0 
              SET @CBR_CurrentBalance = @currentbalanceco 
            ELSE IF @CreditLimit > 0 
              SET @CBR_CurrentBalance = @CurrentBalance 
            ELSE 
              SET @CBR_CurrentBalance = 0 

            IF @CBR_CurrentBalance < 0 
              SET @CBR_CurrentBalance = 0 

            --For accounts with a reporting account status = ?11¬  this should be zero               
            IF @CBR_AccountStatus = '11' 
              SET @CBR_PastDueAmount = 0 
            ELSE 
              SET @CBR_PastDueAmount = @AmtOfPayPastDue 

            IF @CBR_PastDueAmount < 0 
              SET @CBR_PastDueAmount = 0 

            --Balance at time of charge-off v for reporting account status = 64 or 97 only             
            IF @CBR_AccountStatus = '64' 
                OR @CBR_AccountStatus = '97' 
              SET @CBR_OriginalChargeOffAmt = @totalamountco 
            ELSE 
              SET @CBR_OriginalChargeOffAmt = NULL 

            IF @CBR_OriginalChargeOffAmt < 0 
              SET @CBR_OriginalChargeOffAmt = 0 

            SET @CBR_AccountInfoDate = @CycleDate 

            IF @CBR_AccountStatus = '71' 
                OR @CBR_AccountStatus = '78' 
                OR @CBR_AccountStatus = '80' 
                OR @CBR_AccountStatus = '82' 
                OR @CBR_AccountStatus = '83' 
                OR @CBR_AccountStatus = '84' 
              BEGIN 
                  SET @CBR_FCRACompliance = Isnull(@BSDtOfLastDelinqCTD, 
                                            @StatementDate) 
                  --Dateadd(dd, -@NoPayDaysDelinquent + 61, @CycleDatetime)             
                  SET @CBR_FCRACompliance_New = Isnull( 
                  @DateOfOriginalPaymentDueDTD, 
                                                @StatementDate) 
              --Defect ID :165879    
              END 

            IF @CBR_AccountStatus = '97' 
              BEGIN 
                  SET @CBR_FCRACompliance = Isnull(@BSDtOfLastDelinqCTD, 
                                            @StatementDate) 
                  --Dateadd(dd, -@NoPayDaysDelinquent+31, @CycleDatetime)   
                  SET @CBR_FCRACompliance_New = Isnull( 
                  @DateOfOriginalPaymentDueDTD, 
                                                @StatementDate) 
                  --Defect ID :165879    

                  IF @CBR_FCRACompliance > @StatementDate 
                    SET @CBR_FCRACompliance = @ChargeOffDate 

                  IF @CBR_FCRACompliance_New > @StatementDate 
                    --Defect ID :165879    
                    SET @CBR_FCRACompliance_New = @ChargeOffDate 
              END 

            IF @CBR_AccountStatus = '64' 
              BEGIN 
                  IF @CaseOpENDate IS NOT NULL 
                    BEGIN 
                        SET @CBR_FCRACompliance = Dateadd(dd, 31, @CaseOpENDate) 
                        SET @CBR_FCRACompliance_New = 
                        Dateadd(dd, 31, @CaseOpENDate) 
                    --Defect ID :165879    
                    END 
                  ELSE 
                    BEGIN 
                        SET @CBR_FCRACompliance = @ChargeOffDate 
                        SET @CBR_FCRACompliance_New = @ChargeOffDate 
                    --Defect ID :165879    
                    END 
              END 

            --Missing Code for FCRA Compliance (Date of First Delinquency)      
            IF @CBR_AccountStatus = '13' 
               AND @CBR_PaymentRating IN ( '1', '2', '3', '4', 
                                           '5', '6', 'G', 'L' ) 
              BEGIN 
                  IF @BSDtOfLastDelinqCTD IS NOT NULL 
                    SET @CBR_FCRACompliance = @BSDtOfLastDelinqCTD 
                  ELSE 
                    SET @CBR_FCRACompliance = @StatementDate 
                  --Dateadd(dd, -@NoPayDaysDelinquent+61, @CycleDatetime)  
                  IF @DateOfOriginalPaymentDueDTD IS NOT NULL 
                    --Defect ID :165879      
                    SET @CBR_FCRACompliance_New = @DateOfOriginalPaymentDueDTD 
                  ELSE 
                    SET @CBR_FCRACompliance_New = @StatementDate 
              END 

            IF ( @CBR_AccountStatus = '11' 
                 AND @CBRlutdesc_ASCBRStatusGroup = 'Bankruptcy' ) 
              BEGIN 
                  IF @BankRuptcyFileDate IS NOT NULL 
                    BEGIN 
                        SET @CBR_FCRACompliance = @BankRuptcyFileDate 
                        SET @CBR_FCRACompliance_New = @BankRuptcyFileDate 
                    --Defect ID :165879     
                    END 
                  ELSE 
                    BEGIN 
                        SET @CBR_FCRACompliance = @StatementDate 
                        SET @CBR_FCRACompliance_New = @StatementDate 
                    --Defect ID :165879  
                    END 
              END 

            SET @CBR_DateAcctClosed = @DateAcctClosed 
            SET @CBR_LastPaymentDate = @lastpmtdate 
            SET @CBR_DetailReserved = NULL 

            SELECT @CBRCount1 = Count(1) 
            FROM   cbreportingdetail WITH(nolock) 
            WHERE  acctid = @BSAcctID 

            --Code Done for BT#4157 For Report DF Status Only Once and Don't Report Account Again.         
            SELECT TOP 1 @CBR_AccountStatus_DF = accountstatus 
            FROM   cbreportingdetail WITH(nolock) 
            WHERE  acctid = @BSAcctID 
            ORDER  BY skey DESC 

            IF @CBR_AccountStatus_DF = 'DF' 
               AND @CBR_AccountStatus = 'DF' 
               --AND @CBRIndicator <> '6' 
              SET @CBR_ProcessedStatus=2 
            
			IF @CBR_AccountStatus_DF = 'DA' 
               AND @CBR_AccountStatus = 'DA' 
               --AND @CBRIndicator <> '6' 
              SET @CBR_ProcessedStatus=2 

            IF @CBRCount1 = 0 
              SET @CBR_ConsumerTransactionType = '1' 
            ELSE IF( @CBR_ConsumerTransactionType = '1' ) 
              SET @CBR_ConsumerTransactionType = '2' 
            ELSE IF( @CBR_ConsumerTransactionType = '2' ) 
              SET @CBR_ConsumerTransactionType = '3' 
            ELSE IF( @CBR_ConsumerTransactionType = '3' ) 
              SET @CBR_ConsumerTransactionType = '6' 
            ELSE IF( @CBR_ConsumerTransactionType = '4' ) 
              SET @CBR_ConsumerTransactionType = '5' 
            ELSE IF( @CBR_ConsumerTransactionType = '5' ) 
              SET @CBR_ConsumerTransactionType = '8' 
            ELSE IF( @CBR_ConsumerTransactionType = '6' ) 
              SET @CBR_ConsumerTransactionType = '9' 
            ELSE IF( @CBR_ConsumerTransactionType = '7' ) 
              SET @CBR_ConsumerTransactionType = 'A' 
            ELSE 
              SET @CBR_ConsumerTransactionType =NULL 

            SELECT @CBR_Nameline3 = @nameline3, 
                   @CBR_Nameline1 = @nameline1, 
                   @CBR_Nameline2 = @nameline2 

            IF ( @CBR_SNSuffix = '0' ) 
              SET @CBR_SNSuffix = NULL 

            IF ( @CBR_SNSuffix = 'Jr' ) 
              SET @CBR_SNSuffix = 'J' 

            IF ( @CBR_SNSuffix = 'Sr' ) 
              SET @CBR_SNSuffix = 'S' 

            IF ( @CBR_SNSuffix = 'II' ) 
              SET @CBR_SNSuffix = '2' 

            IF ( @CBR_SNSuffix = 'III' ) 
             SET @CBR_SNSuffix = '3' 

            IF ( @CBR_SNSuffix = 'IV' ) 
              SET @CBR_SNSuffix = '4' 

            IF ( @CBR_SNSuffix = 'V' ) 
              SET @CBR_SNSuffix = '5' 

            IF ( @CBR_SNSuffix = 'VI' ) 
              SET @CBR_SNSuffix = '6' 

            IF ( @CBR_SNSuffix = 'VII' ) 
              SET @CBR_SNSuffix = '7' 

            IF ( @CBR_SNSuffix = 'VIII' ) 
              SET @CBR_SNSuffix = '8' 

            IF ( @CBR_SNSuffix = 'IX' ) 
              SET @CBR_SNSuffix = '9' 

            --SET @CBR_SocialSecurityNumber = @SocialSecurityNumber             
            --SET @CBR_SocialSecurityNumber = @SSN --Defect ID : 165958              
            --SET @CBR_Homephone = @homephone             
            SET @CBR_Homephone = Substring(Replace(Replace(Replace(Replace( 
                                 @homephone, 
                                 '-', ''), '(', ''), ')', 
                                 ''), ' ', ''), 1, 3) 
                                 + Substring(Replace(Replace(Replace(Replace( 
                                 @homephone, 
                                 '-' 
                                 , ''), '(', ''), ')', ''), ' ', ''), 4, 7) 

            IF @CBRlutdesc_ASCBRStatusGroup = 'Deceased' 
              SET @CBR_ECOACode = 'X' 
            ELSE IF( @CBR_AccountStatus = 'DF' OR @CBR_AccountStatus = 'DA' ) 
              SET @CBR_ECOACode = 'Z' 
            ELSE 
              SET @CBR_ECOACode = '1' 

            SELECT TOP 1 @Previous_ConsumerInfoInd = consumerinfoindicator 
            FROM   dbo.cbreportingdetail WITH(nolock) 
            WHERE  acctid = @acctid 
                   AND consumerinfoindicator IS NOT NULL 
            ORDER  BY acctid, 
                      statementdate DESC 

            --Required address fields are Address Line 1, City, State AND Zip               
            SELECT @CBR_CountryCode = @countryCode, 
                   @CBR_Addressline1 = @addressline1, 
                   @CBR_Addressline2 = @addressline2, 
                   @CBR_City = @city, 
                   @CBR_Stateprovince = @stateprovince, 
                   @CBR_Postalcode = @postalcode, 
                   @CBR_ResidenceCode = NULL, 
                   @CBR_AddressIndicator = NULL, 
                   @TILADispute_Stage = NULL, 
                   @TILADisputeCurrentStage = NULL, 
                   @SegmentIdentifier_J1 = 'J1', 
                   @SegmentIdentifier_J2 = 'J2' 

            /* Logic to assign Consumer Transaction Type for J1 */ 
            SELECT @NewRecord = Count(*) 
            FROM   statementheader WITH(nolock) 
            WHERE  acctid = @CBR_acctId 

            PRINT( '@NewRecord=' ) 

            PRINT( @NewRecord ) 

            IF( @J1count > 0 ) 
              BEGIN 
                  IF( @NewRecord = 1 ) 
                    SET @ConsumerTransactionType_J1='1' 
                  ELSE IF( @ConsumerTransactionType_J1 = '1' ) 
                    SET @ConsumerTransactionType_J1 = '2' 
                  ELSE IF( @ConsumerTransactionType_J1 = '2' ) 
                    SET @ConsumerTransactionType_J1 = '3' 
                  ELSE IF( @ConsumerTransactionType_J1 = '3' ) 
                    SET @ConsumerTransactionType_J1 = '6' 
                  ELSE IF( @ConsumerTransactionType_J1 = '4' ) 
                    SET @ConsumerTransactionType_J1 = '5' 
                  ELSE IF( @ConsumerTransactionType_J1 = '5' ) 
                    SET @ConsumerTransactionType_J1 = '8' 
                  ELSE IF( @ConsumerTransactionType_J1 = '6' ) 
                    SET @ConsumerTransactionType_J1 = '9' 
                  ELSE IF( @ConsumerTransactionType_J1 = '7' ) 
                    SET @ConsumerTransactionType_J1 = 'A' 
                  ELSE 
                    SET @ConsumerTransactionType_J1 =NULL 

                  SET @GenerationCode_J1 = @CBR_SNSuffix 

                  IF( @AddressType_J1 = '9' ) 
                    SET @ECOACode_J1 = '3' 
                  ELSE 
                    SET @ECOACode_J1 = '5' 
              END 

            /* Logic to assign Consumer Transaction Type for J2 */ 
            IF( @J2count > 0 ) 
              BEGIN 
                  IF( @NewRecord = 1 ) 
                    SET @ConsumerTransactionType_J2='1' 
                  ELSE IF( @ConsumerTransactionType_J2 = 1 ) 
                    SET @ConsumerTransactionType_J2 = '2' 
                  ELSE IF( @ConsumerTransactionType_J2 = 2 ) 
                    SET @ConsumerTransactionType_J2 = '3' 
                  ELSE IF( @ConsumerTransactionType_J2 = 3 ) 
                    SET @ConsumerTransactionType_J2 = '6' 
                  ELSE IF( @ConsumerTransactionType_J2 = 4 ) 
                    SET @ConsumerTransactionType_J2 = '5' 
                  ELSE IF( @ConsumerTransactionType_J2 = 5 ) 
                    SET @ConsumerTransactionType_J2 = '8' 
                  ELSE IF( @ConsumerTransactionType_J2 = 6 ) 
                    SET @ConsumerTransactionType_J2 = '9' 
                  ELSE IF( @ConsumerTransactionType_J2 = 7 ) 
                    SET @ConsumerTransactionType_J2 = 'A' 
                  ELSE 
                    SET @ConsumerTransactionType_J2 =NULL 

                  SET @GenerationCode_J2=@CBR_SNSuffix 

                  IF( @ResidenceCode_J2 = '1' ) 
                    SET @ResidenceCode_J2='O' 
                  ELSE IF( @ResidenceCode_J2 = '2' ) 
                    SET @ResidenceCode_J2='R' 
                  ELSE 
                    SET @ResidenceCode_J2=NULL 

                  IF( @AddressType_J2 = '9' ) 
                    SET @ECOACode_J2 = '3' 
                  ELSE 
                    SET @ECOACode_J2 = '5' 
              END 
----------------------------------------------------------------------------Payment History Profile------------------------------------------------------------
            --Rohit :::Payment History Profile Changes   for td#84478           
            --  PRINT @CBR_PaymentHistProfile             
            /*IF @SystemStatus = '14' 
              SET @CBR_PaymentHistProfile = 'L' 
            --ELSE IF @AcctInCollectionsSystem ='1'       
            -- SET @CBR_PaymentHistProfile = 'G'       
            ELSE IF @CBR_CurrentBalance = 0 
               AND @SystemStatus != '14' 
              SET @CBR_PaymentHistProfile = 'E' 
            ELSE IF @ReportHistoryCtrCC01 != 0 
               AND @ReportHistoryCtrCC01 < 7 
              SET @CBR_PaymentHistProfile = Rtrim(Cast(@ReportHistoryCtrCC01 - 1 
                                                       AS 
                                                       CHAR 
                                                  )) 
            ELSE IF @ReportHistoryCtrCC01 >= 7 
              BEGIN 
                  IF @ReportHistoryCtrCC01 > 7 
                     AND @AcctInCollectionsSystem = '1' 
                    SET @CBR_PaymentHistProfile = 'G' 
                  ELSE 
                    SET @CBR_PaymentHistProfile = '6' 
              END 
            ELSE 
              SET @CBR_PaymentHistProfile = '0' 

            IF @SystemStatus <> '14' 
               AND ( @ccinhparent125AID = 5201 
                      OR @SystemStatus = '5201' )--Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = 'G' */

           SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementDate 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = 'G'
            ELSE IF @SystemstatusPayHist = '14' 
			AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = 'L'
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = 'E'
            ELSE IF @ReportHistoryCtrCC01 != 0 
               AND @ReportHistoryCtrCC01 < 7 
              SET @CBR_PaymentHistProfile = Cast(@ReportHistoryCtrCC01 -1 AS CHAR(1)) 
            ELSE IF @ReportHistoryCtrCC01 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC01 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = 'G'
                  ELSE 
                    SET @CBR_PaymentHistProfile = '6'
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = '0'
            ELSE 
              SET @CBR_PaymentHistProfile = 'B'

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

    SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')        
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC02 != 0 
               AND @ReportHistoryCtrCC02 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC02 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC02 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC02 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            --PRINT @CBR_PaymentHistProfile             
            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
       AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC03 != 0 
               AND @ReportHistoryCtrCC03 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC03 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC03 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC03 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC04 != 0 
               AND @ReportHistoryCtrCC04 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC04 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC04 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC04 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC05 != 0 
               AND @ReportHistoryCtrCC05 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC05 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC05 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC05 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC06 != 0 
               AND @ReportHistoryCtrCC06 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC06 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC06 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC06 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC07 != 0 
               AND @ReportHistoryCtrCC07 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC07 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC07 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC07 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC08 != 0 
               AND @ReportHistoryCtrCC08 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC08 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC08 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC08 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC09 != 0 
               AND @ReportHistoryCtrCC09 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC09 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC09 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC09 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
          AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC10 != 0 
               AND @ReportHistoryCtrCC10 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC10 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC10 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC10 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC11 != 0 
               AND @ReportHistoryCtrCC11 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC11 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC11 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC11 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC12 != 0 
               AND @ReportHistoryCtrCC12 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC12 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC12 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC12 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC13 != 0 
               AND @ReportHistoryCtrCC13 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC13 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC13 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC13 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

           SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC14 != 0 
               AND @ReportHistoryCtrCC14 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC14 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC14 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC14 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC15 != 0 
               AND @ReportHistoryCtrCC15 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC15 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC15 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC15 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC16 != 0 
               AND @ReportHistoryCtrCC16 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC16 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC16 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC16 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC17 != 0 
               AND @ReportHistoryCtrCC17 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC17 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC17 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC17 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC18 != 0 
               AND @ReportHistoryCtrCC18 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC18 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC18 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC18 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC19 != 0 
               AND @ReportHistoryCtrCC19 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC19 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC19 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC19 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1))  AND @PayhistCount1 > 0      
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC20 != 0 
               AND @ReportHistoryCtrCC20 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC20 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC20 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC20 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC21 != 0 
               AND @ReportHistoryCtrCC21 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC21 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC21 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC21 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC22 != 0 
               AND @ReportHistoryCtrCC22 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC22 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC22 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC22 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist2 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist1 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF ((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist2)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist2 and @EnterCollectionDate <= @StatementdatePayHist2))AND @PayhistCount1 > 0        
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')       
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist2 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC23 != 0 
               AND @ReportHistoryCtrCC23 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC23 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC23 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC23 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

            SELECT TOP 1 @StatementdatePayHist1 = statementdate, 
                         @SystemstatusPayHist = systemstatus, 
                         @CurrentBalancePayHist = currentbalance, 
                         @RemoveFromCollDate = removefromcolldate, 
                         @EnterCollectionDate = entercollectiondate, 
                         @AcctReportedInCollections = acctincollectionssystem, 
                         @AcctManualStatus = ccinhparent125aid 
            FROM   #accdetail WITH(nolock) 
            WHERE  statementdate < @StatementdatePayHist2 
            ORDER  BY statementdate DESC 

            SET @PayhistCount1 = @@ROWCOUNT 

            IF @PayhistCount1 < 1 
              BEGIN 
                  SELECT @StatementdatePayHist1 = NULL, 
                         @StatementdatePayHist2 = NULL 
              END 

            IF @PayhistCount1 > 0 
               AND @SystemstatusPayHist <> '14' 
               AND ( @AcctManualStatus = 5201 
                      OR @SystemstatusPayHist = '5201' ) 
              --Status : 5201 = A-AGENCY 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @SystemstatusPayHist = '14' 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'L') 
            --ELSE IF((@RemoveFromCollDate is null and @EnterCollectionDate is not null and @EnterCollectionDate <= @StatementdatePayHist1)       
            --        OR( @RemoveFromCollDate is not null and @EnterCollectionDate > @RemoveFromCollDate and @RemoveFromCollDate <= @StatementdatePayHist1 and @EnterCollectionDate <= @StatementdatePayHist1)) AND @PayhistCount1 > 0       
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G')      
            ELSE IF @CurrentBalancePayHist = 0 
               AND @SystemstatusPayHist != '14' 
               AND @StatementdatePayHist1 > @DateAcctOpened 
               AND @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'E') 
            ELSE IF @ReportHistoryCtrCC24 != 0 
               AND @ReportHistoryCtrCC24 < 7 
              SET @CBR_PaymentHistProfile = Rtrim( 
              @CBR_PaymentHistProfile 
              + Cast(@ReportHistoryCtrCC24 -1 AS CHAR(1) 
              )) 
            ELSE IF @ReportHistoryCtrCC24 >= 7 
              BEGIN 
                  IF @PayhistCount1 > 0 
                     AND @ReportHistoryCtrCC24 > 7 
                     AND @AcctReportedInCollections = '1' 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + 'G') 
                  ELSE 
                    SET @CBR_PaymentHistProfile = Rtrim( 
                    @CBR_PaymentHistProfile + '6') 
              END 
            --ELSE IF @PayhistCount1 > 0 AND @AcctReportedInCollections = '1'--added this condition for converted accts. 
            -- SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'G') 
            ELSE IF @PayhistCount1 > 0 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + '0') 
            ELSE 
              SET @CBR_PaymentHistProfile = Rtrim(@CBR_PaymentHistProfile + 'B') 

 ----------------------------------------------------------------------------Payment History Profile END------------------------------------------------------------

            INSERT INTO dbo.cbreportingdetail 
            VALUES      ( @CBR_StatementDate, 
                          @CBR_acctId, 
                          @CBR_ProcessedStatus, 
                          @CBR_RecordDescriptor, 
                          @CBR_ProcessingIndicator, 
                          @CBR_CBRStatementDate, 
                          @CBR_CorrectionIndicator, 
                          @CBR_IdentificationNumber, 
                          @CBR_BillingCycle, 
                          @CBR_AccountNumber, 
                          @CBR_PortfolioType, 
                          @CBR_AccountType, 
                          @CBR_CreatedTime, 
                          @CBR_CreditLimit, 
                          @CBR_HighestCredit, 
                          @CBR_TermsDuration, 
                          @CBR_TermsFrequency, 
                          @CBR_SchMonthlyPaymentAmt, 
                          @CBR_ActualPaymentAmt, 
                          @CBR_AccountStatus, 
                          @CBR_PaymentRating, 
                          @CBR_PaymentHistProfile, 
                          @CBR_SpecialComment, 
                          @CBR_ComplianceConditionCode, 
                          @CBR_CurrentBalance, 
                          @CBR_PastDueAmount, 
                          @CBR_OriginalChargeOffAmt, 
                          @CBR_AccountInfoDate, 
                          @CBR_FCRACompliance, 
                          @CBR_DateAcctClosed, 
                          @CBR_LastPaymentDate, 
                          @CBR_DetailReserved, 
                          @CBR_ConsumerTransactionType, 
                          @CBR_Nameline3, 
                          @CBR_Nameline1, 
                          @CBR_Nameline2, 
                          @CBR_SNSuffix, 
                          NULL,--Defect ID : 165958               
                          @CBR_DateOfBirth, 
                          @CBR_Homephone, 
                          @CBR_ECOACode, 
                          @CBR_ConsumerInfoIndicator, 
                          @CBR_CountryCode, 
                          @CBR_Addressline1, 
                          @CBR_Addressline2, 
                          @CBR_City, 
                          @CBR_Stateprovince, 
                          @CBR_Postalcode, 
                          @CBR_AddressIndicator, 
                          @CBR_ResidenceCode, 
                          @SegmentIdentifier_J1, 
                          @ConsumerTransactionType_J1, 
                          @Surname_J1, 
                          @FirstName_J1, 
                          @MiddleName_J1, 
                          @GenerationCode_J1, 
                          @SocialSecurityNumber_J1, 
                          @DateofBirth_J1, 
                          @TelephoneNumber_J1, 
                          @ECOACode_J1, 
                          @ConsumerInformationIndicator_J1, 
                          @Reserved_J1, 
                          @SegmentIdentifier_J2, 
                          @ConsumerTransactionType_J2, 
                          @Surname_J2, 
                          @FirstName_J2, 
                          @MiddleName_J2, 
                          @GenerationCode_J2, 
                          @SocialSecurityNumber_J2, 
                          @DateofBirth_J2, 
                          @TelephoneNumber_J2, 
                          @ECOACode_J2, 
                          @ConsumerInformationIndicator_J2, 
                          @CountryCode_J2, 
                          @FirstLineofAddress_J2, 
                          @SecondLineofAddress_J2, 
                          @City_J2, 
                          @State_J2, 
                          @PostalCode_J2, 
                          @AddressIndicator_J2, 
                          @ResidenceCode_J2, 
                          @Reserved_J2, 
                          @institutionid, 
                          @CBR_PrimaryAccountNumber, 
                          @CBR_PAN_Hash, 
                          @CBR_SocialSecurityNumber,--Defect ID : 165958   
                          @CBR_SocialSecurityNumber_Hash,--Defect ID : 165958  
                          @CBR_FCRACompliance_New --Defect ID :165879          
            ) 

            SELECT @CBR_acctId, 
                   @CBR_StatementDate, 
                   @CBR_SpecialComment, 
                   @SpecialComments_Drived, 
                   @ComplianceCode_Drived, 
                   @SpecialComments_Reported, 
                   @ComplianceCode_Reported 

            --ReSET the Detail Table related to NULLs             
            SELECT @CBR_StatementDate = NULL, 
                   @CBR_acctId = NULL, 
                   @CBR_ProcessedStatus = NULL, 
                   @CBR_RecordDescriptor = NULL, 
                   @CBR_ProcessingIndicator = NULL, 
                   @CBR_CBRStatementDate = NULL, 
                   @CBR_CorrectionIndicator = NULL, 
                   @CBR_IdentificationNumber = NULL, 
                   @CBR_BillingCycle = NULL, 
                   @CBR_AccountNumber = NULL, 
                   @CBR_PortfolioType = NULL, 
                   @CBR_AccountType = NULL, 
                   @CBR_CreatedTime = NULL, 
                   @CBR_CreditLimit = NULL, 
                   @CBR_HighestCredit = NULL, 
                   @CBR_TermsDuration = NULL, 
                   @CBR_TermsFrequency = NULL, 
                   @CBR_SchMonthlyPaymentAmt = NULL, 
                   @CBR_ActualPaymentAmt = NULL, 
                   @CBR_AccountStatus = NULL, 
                   @CBR_PaymentRating = NULL, 
                   @CBR_PaymentHistProfile = NULL, 
                   @CBR_SpecialComment = NULL, 
                   @CBR_ComplianceConditionCode = NULL, 
                   @CBR_CurrentBalance = NULL, 
                   @CBR_PastDueAmount = NULL, 
                   @CBR_OriginalChargeOffAmt = NULL, 
                   @CBR_AccountInfoDate = NULL, 
                   @CBR_FCRACompliance = NULL, 
                   @CBR_DateAcctClosed = NULL, 
                   @CBR_LastPaymentDate = NULL, 
                   @CBR_DetailReserved = NULL, 
                   @CBR_ConsumerTransactionType = NULL, 
                   @CBR_Nameline3 = NULL, 
                   @CBR_Nameline1 = NULL, 
                   @CBR_Nameline2 = NULL, 
                   @CBR_SNSuffix = NULL, 
                   @CBR_SocialSecurityNumber = NULL, 
                   @CBR_DateOfBirth = NULL, 
                   @CBR_Homephone = NULL, 
                   @CBR_ECOACode = NULL, 
                   @CBR_ConsumerInfoIndicator = NULL, 
                   @CBR_CountryCode = NULL, 
                   @CBR_Addressline1 = NULL, 
                   @CBR_Addressline2 = NULL, 
                   @CBR_City = NULL, 
                   @CBR_Stateprovince = NULL, 
                   @CBR_Postalcode = NULL, 
                   @CBR_ResidenceCode = NULL, 
                   @CBR_AddressIndicator = NULL, 
                   @CaseOpENDate = NULL, 
                   @Previous_ConsumerInfoInd = NULL, 
                   @CBRlutdesc_ASCBRStatusGroup = NULL, 
                   @CBRStatusGroup_val = NULL 
                   -- J1 J2 segment elements null             
                   , 
                   @institutionid = NULL, 
                   @SegmentIdentifier_J1 = NULL, 
                   @ConsumerTransactionType_J1 = NULL, 
                   @Surname_J1 = NULL, 
                   @FirstName_J1 = NULL, 
                   @MiddleName_J1 = NULL, 
                   @GenerationCode_J1 = NULL, 
                   @SocialSecurityNumber_J1 = NULL, 
                   @DateofBirth_J1 = NULL, 
                   @TelephoneNumber_J1 = NULL, 
 @ECOACode_J1 = NULL, 
                   @ConsumerInformationIndicator_J1 = NULL, 
                   @Reserved_J1 = NULL, 
                   @SegmentIdentifier_J2 = NULL, 
                   @ConsumerTransactionType_J2 = NULL, 
                   @Surname_J2 = NULL, 
                   @FirstName_J2 = NULL, 
                   @MiddleName_J2 = NULL, 
                   @GenerationCode_J2 = NULL, 
                   @SocialSecurityNumber_J2 = NULL, 
                   @DateofBirth_J2 = NULL, 
                   @TelephoneNumber_J2 = NULL, 
                   @ECOACode_J2 = NULL, 
                   @ConsumerInformationIndicator_J2 = NULL, 
                   @CountryCode_J2 = NULL, 
                   @FirstLineofAddress_J2 = NULL, 
                   @SecondLineofAddress_J2 = NULL, 
                   @City_J2 = NULL, 
                   @State_J2 = NULL, 
                   @PostalCode_J2 = NULL, 
                   @AddressIndicator_J2 = NULL, 
                   @ResidenceCode_J2 = NULL, 
                   @Reserved_J2 = NULL, 
                   @CBR_PrimaryAccountNumber = NULL, 
                   @CBR_PAN_Hash = NULL, 
                   @CBR_SocialSecurityNumber_Hash = NULL,--Defect ID : 165958   
                   @CBR_FCRACompliance_New = NULL 
        --Defect ID :165879                    
        END 

      IF EXISTS (SELECT * 
                 FROM   tempdb.dbo.sysobjects 
                 WHERE  id = Object_id('tempdb..#AccDetail')) 
        BEGIN 
            DROP TABLE #accdetail 
        END 
  END   
GO


