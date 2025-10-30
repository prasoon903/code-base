--1. Created by Tlim on 10/18/2019 as per Beekman requirement.
--2. Updated by Tlim on 10/21/2019 to add Q9 and Q10 and combined Q3 into Q4 validation as per Plat label 15.00.12.02_4.2.40.24 testing.
--3. Updated by Nayan on 11/19/2019 to change permanent table creation into insertion. CMF31495.
--4. Updated by Tlim on 11/5/2019 to fix execution error.
--5. Updated by Tlim on 12/11/2019 to only return accounts that has Beekman transactions.
--6. Updated by Tlim on 12/13/2019 to add Total Accounts with Beekman plan information.
--7. Updated by Tlim on 01/07/2020 to add OPTION (MAXDOP 8) as suggested by OP and script is successfully executed for 12/31/19 audit.
--8. Updated by Tlim on 02/12/2020 to eliminate false positive using tester's testing DB and Plat Prod 1/31/2020 audit, TD227851.
--9. Updated by Tlim on 03/11/2020 to partially fix TD231088 and added TD231270 validation.
--10. Updated by Tlim on 03/27/2020 to fix TD231209.
--11. Updated by Tlim on 04/06/2020 to fix Amount Due calculation issue when accounts having waive minimum due calculation setup and Prior Monthly Total 
--Balance calculation when accounts are past due.
--12. Updated by Tlim on 04/10/2020 to fix exception where EqualPaymentAmount <> 0 when account is in DRP status.
--13. Updated by Tlim on 05/06/2020 to eliminate false positive in Q2 and Q4 and changes done on 01/07/2020. As per Mukesh, OPTION (MAXDOP) will cause blocking issue.
--14. Updated by Tlim on 06/01/2020 to eliminate false positive in Q2 after development's confirmation and Q10 as per May 2020 audit.
--15. Updated by Tlim on 06/02/2020 and 06/10/2020 to eliminate false positive in Q4 as per May 2020 audit.
--16. Updated by Tlim on 06/30/2020 to remove where condition while inserting into #SH_SUB table after comparing Remediation list from Rohit in 
--svn://10.205.10.31/Compliance/Audits/Plat/Production/2020/May 2020/Remediation/BeekmanOOB_112_Fix.xlsx.
--17. Updated by Tlim on 07/17/2020 to fix more exception scenarios in TD231209. Still few exceptions returned.
--18. Updated by Rahul Sahu 07/19/2020 to script move in chunks Code and Optimized some queres.
--19. Updated by Tlim 07/23/2020 to fix more exception scenarios in TD231209.
--20. Updated by Tlim on 09/04/2020 to fix TD241383 for Inadverant Credit feature (svn://10.205.10.31/Design Documents/CoreISSUE/Plat/128008_InadvertentCredit.docx)
--21. Updated by Mukesh on 09/09/2020
--22. Updated by Tlim on 01/12/2021 to add Original Purchase Amount < Current Balance validation.
--23. Updated by Tlim on 03/23/2021 to fix TD246511 and 241786.
--24. Updated by Tlim on 06/23/2021 to revert the fixed for TD241383 as this fixed doesn’t apply to EPA field. It's only applicable to Amt Due calculation. 
--To add EPA calculation for ChargeOff accounts and to fix TD251663.

--Provide SysOrgID from Institution table or 0 (Means All Institutions) for Client to be 
--audited.
--SELECT * FROM Institutions WITH (NOLOCK)

DECLARE @SysOrgID INT
SET @SysOrgID = 51

--Provide Daily or Monthly for single Billing Cycle or Full Month audit.
--When @AuditPeriod='Daily', exact Billing Cycle date should be provided in @StatementDate
--parameter.

DECLARE @AuditPeriod VARCHAR(25)
SET @AuditPeriod = 'Monthly'

--Set @TopStatement as the number of accounts to be audited.
DECLARE @TopStatement INT
SET @TopStatement = 1250000

-- added new parameter

DECLARE @DisplayFlag BIT
SET @DisplayFlag= 1  -- Value 0 for display result at the end of processing, 1 for display result for current batch as well.

DECLARE @StatementDate DATETIME
SET @StatementDate = '2018-07-31 23:59:57.000'	

SET NOCOUNT ON;

	DROP TABLE IF EXISTS #InstitutionList
	DROP TABLE IF EXISTS #Dates
	DROP TABLE IF EXISTS #CPMInfo
	DROP TABLE IF EXISTS #CPMInfoSetup
	DROP TABLE IF EXISTS #MerchantStatusInfo
	DROP TABLE IF EXISTS #MerchantStatusSetup
	DROP TABLE IF EXISTS #LookupData
	DROP TABLE IF EXISTS #BeekmanPlans
	DROP TABLE IF EXISTS #PriorSH
	DROP TABLE IF EXISTS #SHAB
	DROP TABLE IF EXISTS #SH_SUB
	DROP TABLE IF EXISTS #SH
	DROP TABLE IF EXISTS #StatusChange
	DROP TABLE IF EXISTS #REV
	DROP TABLE IF EXISTS #MonetaryTrans
	DROP TABLE IF EXISTS #Temp 
	DROP TABLE IF EXISTS #EODAccounts
	DROP TABLE IF EXISTS #EODPlans
	DROP TABLE IF EXISTS #LoyaltyTrans
	
--Create Audit Institution List
CREATE TABLE #InstitutionList (
	InstitutionID INT
	,InstitutionName VARCHAR(100)
	)

IF @SysOrgID = 0
	INSERT INTO #InstitutionList
	SELECT DISTINCT L.parent02aid
		,C.LutDescription
	FROM Logo_Primary L WITH (NOLOCK)
	JOIN CCardLookUp C WITH (NOLOCK) ON C.LutCode = L.parent02AID
		AND C.LUTid = 'OrganizationName'
		AND C.LutLanguage = 'dbb'
	
ELSE
	--INSERT INTO #InstitutionList
	--SELECT DISTINCT L.parent02aid
	--	,C.LutDescription
	--FROM Logo_Primary L WITH (NOLOCK)
	--JOIN CCardLookUp C WITH (NOLOCK) ON C.LutCode = L.parent02AID
	--	AND C.LUTid = 'OrganizationName'
	--	AND C.LutLanguage = 'dbb'
	--WHERE L.parent02aid IN (
	--		SELECT InstitutionID
	--		FROM Institutions WITH (NOLOCK)
	--		WHERE SysOrgID = @SysOrgID
	--		)
	INSERT INTO #InstitutionList
	SELECT DISTINCT 
		I.InstitutionID
		,C.LutDescription
	FROM Institutions I WITH (NOLOCK)
	JOIN CCardLookUp C WITH (NOLOCK) ON C.LutCode = I.InstitutionID
		AND C.LUTid = 'OrganizationName'
		AND C.LutLanguage = 'dbb'
	WHERE I.SysOrgID = @SysOrgID

--Create Audit Date List
CREATE TABLE #Dates (
	InstitutionID INT
	--,InstitutionName VARCHAR(50)
	,AuditDate DATETIME
	)

IF @AuditPeriod = 'Daily'
	INSERT INTO #Dates
	SELECT DISTINCT S.InstitutionID
		--,I.InstitutionName
		,S.StatementDate
	FROM StatementHeader S WITH (NOLOCK)
	--JOIN #InstitutionList I ON S.InstitutionID = I.InstitutionID
	--AND DATEDIFF(DAY, S.StatementDate, @StatementDate) = 0
	WHERE 
	S.StatementDate >= CONVERT(DATETIME, CONVERT(DATE, @StatementDate))
		AND S.StatementDate < CONVERT(DATETIME, CONVERT(DATE, @StatementDate)) + 1
		AND S.InstitutionID IN (
			SELECT InstitutionID
			FROM #InstitutionList
			)
ELSE
	INSERT INTO #Dates
	SELECT DISTINCT S.InstitutionID
		--,I.InstitutionName
		,S.StatementDate
	FROM StatementHeader S WITH (NOLOCK)
	--JOIN #InstitutionList I ON S.InstitutionID = I.InstitutionID
	WHERE
		--DATEDIFF(MONTH, S.StatementDate, @StatementDate) = 0
		S.StatementDate >= CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - DAY(@StatementDate) + 1, @StatementDate)))
		AND S.StatementDate < CONVERT(DATETIME, CONVERT(DATE, DATEADD(MONTH, 1, DATEADD(DD, - DAY(@StatementDate) + 1, @StatementDate))))
		AND S.InstitutionID IN (
			SELECT InstitutionID
			FROM #InstitutionList
			)

CREATE TABLE #LookupData (
	Lutid VARCHAR(16)
	,LutCode VARCHAR(50)
	,LutDescription VARCHAR(250)
	)

INSERT INTO #LookupData (
	Lutid
	,LutCode
	,LutDescription
	)
SELECT Lutid
	,LutCode
	,LutDescription
FROM Ccardlookup WITH (NOLOCK)
WHERE Lutid IN (
		'YesNo'
		,'NoYes'
		)
	AND Module = 'BC'
	AND LutLanguage = 'dbb'

DECLARE @CPMCount INT
	,@RemainCPMCount INT

SELECT Acctid CPMID
	,Parent01Aid CPMParentID
	,CreditPlanType
	,IntPlanOccurr
	,InterestPlan
	,PenaltyPricingInterestPlanOccurrence
	,InterestOnGraceReactivation
	,EqualPayments
	,GraceDaysApp
	,NumofGraceDays
	,MinimumPaymentDue
	,DueRounding
	,MinimumInterest
	,DefIntExpDate
	,DefIntNumCycles
	,DefIntNumDays
	,DefPmtExpDate
	,DefPmtNumCycles
	,DefermentCancelLevel
	,DefermentCancelType
	,RolloverReq
	,ISNULL(RollCPMDays, 0) AS RollCPMDays
	,MTCGrpName
INTO #CPMInfo
FROM CPMAccounts WITH (NOLOCK)

SELECT @CPMCount = COUNT(1)
FROM #CPMInfo

--Resolve Inheritance Code
WHILE @CPMCount > 0
BEGIN
	SELECT @RemainCPMCount = COUNT(1)
	FROM #CPMInfo
	WHERE CPMParentID IS NOT NULL
		AND CPMParentID <> 1

	UPDATE CPM
	SET CPM.CreditPlanType = ISNULL(CPM.CreditPlanType, CPM1.CreditPlanType)
		,CPM.IntPlanOccurr = ISNULL(CPM.IntPlanOccurr, CPM1.IntPlanOccurr)
		,CPM.InterestPlan = ISNULL(CPM.InterestPlan, CPM1.InterestPlan)
		,CPM.PenaltyPricingInterestPlanOccurrence = ISNULL(CPM.PenaltyPricingInterestPlanOccurrence, CPM1.PenaltyPricingInterestPlanOccurrence)
		,CPM.InterestOnGraceReactivation = ISNULL(CPM.InterestOnGraceReactivation, CPM1.InterestOnGraceReactivation)
		,CPM.EqualPayments = ISNULL(CPM.EqualPayments, CPM1.EqualPayments)
		,CPM.GraceDaysApp = ISNULL(CPM.GraceDaysApp, CPM1.GraceDaysApp)
		,CPM.NumofGraceDays = ISNULL(CPM.NumofGraceDays, CPM1.NumofGraceDays)
		,CPM.MinimumPaymentDue = ISNULL(CPM.MinimumPaymentDue, CPM1.MinimumPaymentDue)
		,CPM.DueRounding = ISNULL(CPM.DueRounding, CPM1.DueRounding)
		,CPM.MinimumInterest = ISNULL(CPM.MinimumInterest, CPM1.MinimumInterest)
		,CPM.DefIntExpDate = ISNULL(CPM.DefIntExpDate, CPM1.DefIntExpDate)
		,CPM.DefIntNumCycles = ISNULL(CPM.DefIntNumCycles, CPM1.DefIntNumCycles)
		,CPM.DefIntNumDays = ISNULL(CPM.DefIntNumDays, CPM1.DefIntNumDays)
		,CPM.DefPmtExpDate = ISNULL(CPM.DefPmtExpDate, CPM1.DefPmtExpDate)
		,CPM.DefPmtNumCycles = ISNULL(CPM.DefPmtNumCycles, CPM1.DefPmtNumCycles)
		,CPM.DefermentCancelLevel = ISNULL(CPM.DefermentCancelLevel, CPM1.DefermentCancelLevel)
		,CPM.DefermentCancelType = ISNULL(CPM.DefermentCancelType, CPM1.DefermentCancelType)
		,CPM.RolloverReq = ISNULL(CPM.RolloverReq, CPM1.RolloverReq)
		,CPM.RollCPMDays = ISNULL(CPM.RollCPMDays, CPM1.RollCPMDays)
		,CPM.MTCGrpName = ISNULL(CPM.MTCGrpName, CPM1.MTCGrpName)
		,CPM.CPMParentID = CPM1.CPMParentID
	FROM #CPMInfo CPM
	JOIN #CPMInfo CPM1 ON (CPM.CPMParentID = CPM1.CPMID)

	SELECT @CPMCount = COUNT(1)
	FROM #CPMInfo

	IF @RemainCPMCount = 0
		BREAK;
END

--Create Audit Credit Plan Master List
CREATE TABLE #CPMInfoSetup (
	CPMParentID INT
	,CPMID INT
	,CPMName VARCHAR(100)
	,CreditPlanType INT
	,CreditPlanTypeDesc VARCHAR (50)
	,IntPlanOccurr INT
	,InterestPlan INT
	,PenaltyPricingInterestPlanOccurrence INT
	,CPMInterestOnGraceReactivation INT
	,CPMInterestOnGraceReactivationDesc VARCHAR(100)
	,EqualPayments INT
	,GraceDaysApp INT
	,GraceDaysAppDesc VARCHAR(100)
	,CPMNumofGraceDays INT
	,MinimumPaymentDue INT
	,MinimumPaymentDueDesc VARCHAR(10)
	,DueRounding INT
	,DueRoundingDesc VARCHAR(10)
	,MinimumInterest INT
	,MinimumInterestDesc VARCHAR(10)
	,DefIntExpDate DATETIME
	,DefIntNumCycles INT
	,DefIntNumDays INT
	,DefPmtExpDate DATETIME
	,DefPmtNumCycles INT
	,DefermentCancelLevel VARCHAR(50)
	,DefermentCancelType VARCHAR(50)
	,RolloverReq INT
	,RollCPMDays INT
	,CPMMTCGrpName INT
	)
	
--Join #CPMInfoSetup with CCardLookup to obtain Fields Lookup Value.
IF @SysOrgID = 0
BEGIN
	INSERT INTO #CPMInfoSetup
	SELECT CPMParentID
		,CPMID
		,CL.LutDescription CPMName
		,CreditPlanType
		,CL2.LutDescription
		,IntPlanOccurr
		,InterestPlan
		,PenaltyPricingInterestPlanOccurrence
		,InterestOnGraceReactivation
		,CL3.LutDescription
		,EqualPayments
		,GraceDaysApp
		,CL1.LutDescription GraceDaysAppDesc
		,NumofGraceDays CPMNumofGraceDays
		,MinimumPaymentDue
		,CL4.LutDescription
		,DueRounding
		,CL5.LutDescription
		,MinimumInterest
		,CL6.LutDescription
		,DefIntExpDate
		,DefIntNumCycles
		,DefIntNumDays
		,DefPmtExpDate
		,DefPmtNumCycles
		,DefermentCancelLevel
		,DefermentCancelType
		,RolloverReq
		,RollCPMDays
		,MTCGrpName
	FROM #CPMInfo A
	LEFT OUTER JOIN CCardLookup CL WITH (NOLOCK) ON CL.LutCode = A.CPMID
		AND CL.LUTid = 'CpmCrPlanName'
		AND CL.Module = 'BC'
		AND CL.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL1 WITH (NOLOCK) ON CL1.LutCode = A.GraceDaysApp
		AND CL1.LUTid = 'CPMGraceDaysApp'
		AND CL1.Module = 'BC'
		AND CL1.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL2 WITH (NOLOCK) ON CL2.LutCode = A.CreditPlanType
		AND CL2.LUTid = 'CPMCrPlanType'
		AND CL2.Module = 'BC'
		AND CL2.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL3 WITH (NOLOCK) ON CL3.LutCode = A.InterestOnGraceReactivation
		AND CL3.LutID = 'IntOnGraceReact'
		AND CL3.Module = 'BC'
		AND CL3.LutLanguage = 'dbb'
	LEFT OUTER JOIN TranCodeLookUp TL WITH (NOLOCK) ON TL.LutCode = ISNULL(A.MTCGrpName, 10)
		AND TL.LutID = 'MtcGroupId'
		AND TL.LutLanguage = 'dbb'
	LEFT OUTER JOIN #LookupData CL4 WITH (NOLOCK) ON CL4.LutCode = A.MinimumPaymentDue
		AND CL4.LutID = 'NoYes'
	LEFT OUTER JOIN #LookupData CL5 WITH (NOLOCK) ON CL5.LutCode = A.DueRounding
		AND CL5.LutID = 'NoYes'
	LEFT OUTER JOIN #LookupData CL6 WITH (NOLOCK) ON CL6.LutCode = A.MinimumInterest
		AND CL6.LutID = 'NoYes'
END
ELSE
BEGIN
	INSERT INTO #CPMInfoSetup
	SELECT CPMParentID
		,CPMID
		,CL.LutDescription CPMName
		,CreditPlanType
		,CL2.LutDescription
		,IntPlanOccurr
		,InterestPlan
		,PenaltyPricingInterestPlanOccurrence
		,InterestOnGraceReactivation
		,CL3.LutDescription
		,EqualPayments
		,GraceDaysApp
		,CL1.LutDescription GraceDaysAppDesc
		,NumofGraceDays CPMNumofGraceDays
		,MinimumPaymentDue
		,CL4.LutDescription
		,DueRounding
		,CL5.LutDescription
		,MinimumInterest
		,CL6.LutDescription
		,DefIntExpDate
		,DefIntNumCycles
		,DefIntNumDays
		,DefPmtExpDate
		,DefPmtNumCycles
		,DefermentCancelLevel
		,DefermentCancelType
		,RolloverReq
		,RollCPMDays
		,MTCGrpName
	FROM #CPMInfo A
	LEFT OUTER JOIN CCardLookup CL WITH (NOLOCK) ON CL.LutCode = A.CPMID
		AND CL.LUTid = 'CpmCrPlanName'
		AND CL.Module = 'BC'
		AND CL.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL1 WITH (NOLOCK) ON CL1.LutCode = A.GraceDaysApp
		AND CL1.LUTid = 'CPMGraceDaysApp'
		AND CL1.Module = 'BC'
		AND CL1.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL2 WITH (NOLOCK) ON CL2.LutCode = A.CreditPlanType
		AND CL2.LUTid = 'CPMCrPlanType'
		AND CL2.Module = 'BC'
		AND CL2.LutLanguage = 'dbb'
	LEFT OUTER JOIN CCardLookup CL3 WITH (NOLOCK) ON CL3.LutCode = A.InterestOnGraceReactivation
		AND CL3.LutID = 'IntOnGraceReact'
		AND CL3.Module = 'BC'
		AND CL3.LutLanguage = 'dbb'
	LEFT OUTER JOIN TranCodeLookUp TL WITH (NOLOCK) ON TL.LutCode = ISNULL(A.MTCGrpName, 10)
		AND TL.LutID = 'MtcGroupId'
		AND TL.LutLanguage = 'dbb'
	LEFT OUTER JOIN #LookupData CL4 WITH (NOLOCK) ON CL4.LutCode = A.MinimumPaymentDue
		AND CL4.LutID = 'NoYes'
	LEFT OUTER JOIN #LookupData CL5 WITH (NOLOCK) ON CL5.LutCode = A.DueRounding
		AND CL5.LutID = 'NoYes'
	LEFT OUTER JOIN #LookupData CL6 WITH (NOLOCK) ON CL6.LutCode = A.MinimumInterest
		AND CL6.LutID = 'NoYes'
	WHERE (
			CASE 
				WHEN @SysOrgID = 51 --Goldman Sachs
					THEN TL.LutDescription
				END LIKE '%GS%'
		
				
				OR CASE 
					WHEN @SysOrgID = 51 --Goldman Sachs
						THEN TL.LutDescription
					END LIKE '%PA%'
				OR CASE 
					WHEN @SysOrgID = 51 --Goldman Sachs
						THEN TL.LutDescription
					END LIKE '%Cookie%'
				)
			
END

DECLARE @MerchantTemplate VARCHAR(60)
SELECT @MerchantTemplate = LutCode
FROM CCardLookup WITH (NOLOCK)
WHERE LUTid = 'MerchantName'
	AND LutDescription = 'Template Record'

--Create Merchant Status Setup Information Table
CREATE TABLE #MerchantStatusInfo (
	OrigStatusAcctID INT
	,OrigStatusDescription VARCHAR(100)
	,OrigPriority INT
	,OrigMerchantAID INT
	,OrigParent01AID INT
	,MerchantStatusAcctID INT
	,MerchantStatusDescription VARCHAR(100)
	,MerchantPriority INT
	,MerchantMerchantAID INT
	,MerchantParent01AID INT
	,Priority INT
	,Reissue_IssueAction VARCHAR(5)
	,FinanceChargeAction VARCHAR(5)
	,RevolvingPaymentAction VARCHAR(5)
	,InsCancellationAction VARCHAR(5)
	,CreditBureauStatus VARCHAR(2)
	,CheckOTB VARCHAR(5)
	,TransactionPosting VARCHAR(5)
	,LoyaltyPointsAccumulation INT
	,EligibleForInsurance VARCHAR(5)
	,PostingReason VARCHAR(5)
	,HoldStatement VARCHAR(25)
	,WaiveLateChargeAction VARCHAR(5)
	,WaiveLateChargeFor VARCHAR(2)
	,WaiveLateChargeFrom VARCHAR(1)
	,WaiveAnnualChgAction VARCHAR(5)
	,WaiveAnnualChgFor VARCHAR(2)
	,WaiveAnnualChgFrom VARCHAR(1)
	,WaiveOverLimitFeeAction VARCHAR(5)
	,WaiveOverLimitFeeFor VARCHAR(2)
	,WaiveOverLimitFeeFrom VARCHAR(1)
	,WaiveNSFAction VARCHAR(5)
	,WaiveNSFFor VARCHAR(2)
	,WaiveNSFFrom VARCHAR(1)
	,StatementDelivery VARCHAR(5)
	,WaiveMinDue VARCHAR(5)
	,WaiveMinDueFor VARCHAR(2)
	,WaiveMinDueFrom VARCHAR(1)
	,WaiveInsPremium VARCHAR(5)
	,WaiveInsPremiumFor VARCHAR(2)
	,WaiveInsPremiumFrom VARCHAR(1)
	,WaiveInterest VARCHAR(5)
	,WaiveInterestFor VARCHAR(2)
	,WaiveInterestFrom VARCHAR(1)
	,WaiveTransactionFeeAction VARCHAR(5)
	,WaiveTransactionFeeFor VARCHAR(2)
	,WaiveTransactionFeeFrom VARCHAR(1)
	,WaiveAuthFeeAction VARCHAR(5)
	,WaiveAuthFeeFor VARCHAR(2)
	,WaiveAuthFeeFrom VARCHAR(1)
	,WaiveCardFeeAction VARCHAR(5)
	,WaiveCardFeeFor VARCHAR(2)
	,WaiveCardFeeFrom VARCHAR(1)
	,WaiveMbrshipFeeAction VARCHAR(5)
	,WaiveMbrshipFeeFor VARCHAR(2)
	,WaiveMbrshipFeeFrom VARCHAR(1)
	,WaiveServiceFeeAction VARCHAR(5)
	,WaiveServiceFeeFor VARCHAR(2)
	,WaiveServiceFeeFrom VARCHAR(1)
	,WaiveMessageFeeAction VARCHAR(5)
	,WaiveMessageFeeFor VARCHAR(2)
	,WaiveMessageFeeFrom VARCHAR(1)
	,CBRStatusGroup VARCHAR(2)
	,ExcludeFromCBR INT
	,CollectionFlagsbyStatus VARCHAR(5)
	,SetDunSuppress VARCHAR(5)
	,ASResActionCode VARCHAR(2)
	,ASCCaseActionCode VARCHAR(2)
	,ACOverridePriority INT
	,Email VARCHAR(30)
	,GenerateSMS VARCHAR(30)
	,GenerateLetter VARCHAR(30)
	)

INSERT INTO #MerchantStatusInfo (
	OrigStatusAcctID
	,OrigStatusDescription
	,OrigPriority
	,OrigMerchantAID
	,OrigParent01AID
	,MerchantStatusAcctID
	,MerchantStatusDescription
	,MerchantPriority
	,MerchantMerchantAID
	,MerchantParent01AID
	,Priority
	,Reissue_IssueAction
	,FinanceChargeAction
	,RevolvingPaymentAction
	,InsCancellationAction
	,CreditBureauStatus
	,CheckOTB
	,TransactionPosting
	,LoyaltyPointsAccumulation
	,EligibleForInsurance
	,PostingReason
	,HoldStatement
	,WaiveLateChargeAction
	,WaiveLateChargeFor
	,WaiveLateChargeFrom
	,WaiveAnnualChgAction
	,WaiveAnnualChgFor
	,WaiveAnnualChgFrom
	,WaiveOverLimitFeeAction
	,WaiveOverLimitFeeFor
	,WaiveOverLimitFeeFrom
	,WaiveNSFAction
	,WaiveNSFFor
	,WaiveNSFFrom
	,StatementDelivery
	,WaiveMinDue
	,WaiveMinDueFor
	,WaiveMinDueFrom
	,WaiveInsPremium
	,WaiveInsPremiumFor
	,WaiveInsPremiumFrom
	,WaiveInterest
	,WaiveInterestFor
	,WaiveInterestFrom
	,WaiveTransactionFeeAction
	,WaiveTransactionFeeFor
	,WaiveTransactionFeeFrom
	,WaiveAuthFeeAction
	,WaiveAuthFeeFor
	,WaiveAuthFeeFrom
	,WaiveCardFeeAction
	,WaiveCardFeeFor
	,WaiveCardFeeFrom
	,WaiveMbrshipFeeAction
	,WaiveMbrshipFeeFor
	,WaiveMbrshipFeeFrom
	,WaiveServiceFeeAction
	,WaiveServiceFeeFor
	,WaiveServiceFeeFrom
	,WaiveMessageFeeAction
	,WaiveMessageFeeFor
	,WaiveMessageFeeFrom
	,CBRStatusGroup
	,ExcludeFromCBR
	,CollectionFlagsbyStatus
	,SetDunSuppress
	,ASResActionCode
	,ASCCaseActionCode
	,ACOverridePriority
	,Email
	,GenerateSMS
	,GenerateLetter
	)
SELECT A.AcctID OrigStatusAcctID
	,A.StatusDescription OrigStatusDescription
	,A.Priority OrigPriority
	,A.MerchantAID OrigMerchantAID
	,A.Parent01AID OrigParent01AID
	,MA.AcctID MerchantStatusAcctID
	,C.LutDescription AS MerchantStatusDescription
	,MA.Priority MerchantPriority
	,MA.MerchantAID MerchantMerchantAID
	,MA.Parent01AID MerchantParent01AID
	,ISNULL(MA.Priority, A.Priority) Priority
	,ISNULL(MA.Reissue_IssueAction, A.Reissue_IssueAction) Reissue_IssueAction
	,ISNULL(MA.FinanceChargeAction, A.FinanceChargeAction) FinanceChargeAction
	,ISNULL(MA.RevolvingPaymentAction, A.RevolvingPaymentAction) RevolvingPaymentAction
	,ISNULL(MA.InsCancellationAction, A.InsCancellationAction) InsCancellationAction
	,ISNULL(MA.CreditBureauStatus, A.CreditBureauStatus) CreditBureauStatus
	,ISNULL(MA.CheckOTB, A.CheckOTB) CheckOTB
	,ISNULL(MA.TransactionPosting, A.TransactionPosting) TransactionPosting
	,ISNULL(MA.LoyaltyPointsAccumulation, A.LoyaltyPointsAccumulation) LoyaltyPointsAccumulation
	,ISNULL(MA.EligibleForInsurance, A.EligibleForInsurance) EligibleForInsurance
	,ISNULL(MA.PostingReason, A.PostingReason) PostingReason
	,ISNULL(MA.HoldStatement, A.HoldStatement) HoldStatement
	,ISNULL(MA.WaiveLateChargeAction, A.WaiveLateChargeAction) WaiveLateChargeAction
	,ISNULL(MA.WaiveLateChargeFor, A.WaiveLateChargeFor) WaiveLateChargeFor
	,ISNULL(MA.WaiveLateChargeFrom, A.WaiveLateChargeFrom) WaiveLateChargeFrom
	,ISNULL(MA.WaiveAnnualChgAction, A.WaiveAnnualChgAction) WaiveAnnualChgAction
	,ISNULL(MA.WaiveAnnualChgFor, A.WaiveAnnualChgFor) WaiveAnnualChgFor
	,ISNULL(MA.WaiveAnnualChgFrom, A.WaiveAnnualChgFrom) WaiveAnnualChgFrom
	,ISNULL(MA.WaiveOverLimitFeeAction, A.WaiveOverLimitFeeAction) WaiveOverLimitFeeAction
	,ISNULL(MA.WaiveOverLimitFeeFor, A.WaiveOverLimitFeeFor) WaiveOverLimitFeeFor
	,ISNULL(MA.WaiveOverLimitFeeFrom, A.WaiveOverLimitFeeFrom) WaiveOverLimitFeeFrom
	,ISNULL(MA.WaiveNSFAction, A.WaiveNSFAction) WaiveNSFAction
	,ISNULL(MA.WaiveNSFFor, A.WaiveNSFFor) WaiveNSFFor
	,ISNULL(MA.WaiveNSFFrom, A.WaiveNSFFrom) WaiveNSFFrom
	,ISNULL(MA.StatementDelivery, A.StatementDelivery) StatementDelivery
	,ISNULL(MA.WaiveMinDue, A.WaiveMinDue) WaiveMinDue
	,ISNULL(MA.WaiveMinDueFor, A.WaiveMinDueFor) WaiveMinDueFor
	,ISNULL(MA.WaiveMinDueFrom, A.WaiveMinDueFrom) WaiveMinDueFrom
	,ISNULL(MA.WaiveInsPremium, A.WaiveInsPremium) WaiveInsPremium
	,ISNULL(MA.WaiveInsPremiumFor, A.WaiveInsPremiumFor) WaiveInsPremiumFor
	,ISNULL(MA.WaiveInsPremiumFrom, A.WaiveInsPremiumFrom) WaiveInsPremiumFrom
	,ISNULL(MA.WaiveInterest, A.WaiveInterest) WaiveInterest
	,ISNULL(MA.WaiveInterestFor, A.WaiveInterestFor) WaiveInterestFor
	,ISNULL(MA.WaiveInterestFrom, A.WaiveInterestFrom) WaiveInterestFrom
	,ISNULL(MA.WaiveTransactionFeeAction, A.WaiveTransactionFeeAction) WaiveTransactionFeeAction
	,ISNULL(MA.WaiveTransactionFeeFor, A.WaiveTransactionFeeFor) WaiveTransactionFeeFor
	,ISNULL(MA.WaiveTransactionFeeFrom, A.WaiveTransactionFeeFrom) WaiveTransactionFeeFrom
	,ISNULL(MA.WaiveAuthFeeAction, A.WaiveAuthFeeAction) WaiveAuthFeeAction
	,ISNULL(MA.WaiveAuthFeeFor, A.WaiveAuthFeeFor) WaiveAuthFeeFor
	,ISNULL(MA.WaiveAuthFeeFrom, A.WaiveAuthFeeFrom) WaiveAuthFeeFrom
	,ISNULL(MA.WaiveCardFeeAction, A.WaiveCardFeeAction) WaiveCardFeeAction
	,ISNULL(MA.WaiveCardFeeFor, A.WaiveCardFeeFor) WaiveCardFeeFor
	,ISNULL(MA.WaiveCardFeeFrom, A.WaiveCardFeeFrom) WaiveCardFeeFrom
	,ISNULL(MA.WaiveMbrshipFeeAction, A.WaiveMbrshipFeeAction) WaiveMbrshipFeeAction
	,ISNULL(MA.WaiveMbrshipFeeFor, A.WaiveMbrshipFeeFor) WaiveMbrshipFeeFor
	,ISNULL(MA.WaiveMbrshipFeeFrom, A.WaiveMbrshipFeeFrom) WaiveMbrshipFeeFrom
	,ISNULL(MA.WaiveServiceFeeAction, A.WaiveServiceFeeAction) WaiveServiceFeeAction
	,ISNULL(MA.WaiveServiceFeeFor, A.WaiveServiceFeeFor) WaiveServiceFeeFor
	,ISNULL(MA.WaiveServiceFeeFrom, A.WaiveServiceFeeFrom) WaiveServiceFeeFrom
	,ISNULL(MA.WaiveMessageFeeAction, A.WaiveMessageFeeAction) WaiveMessageFeeAction
	,ISNULL(MA.WaiveMessageFeeFor, A.WaiveMessageFeeFor) WaiveMessageFeeFor
	,ISNULL(MA.WaiveMessageFeeFrom, A.WaiveMessageFeeFrom) WaiveMessageFeeFrom
	,ISNULL(MA.CBRStatusGroup, A.CBRStatusGroup) CBRStatusGroup
	,ISNULL(MA.ExcludeFromCBR, A.ExcludeFromCBR) ExcludeFromCBR
	,ISNULL(MA.CollectionFlagsbyStatus, A.CollectionFlagsbyStatus) CollectionFlagsbyStatus
	,ISNULL(MA.SetDunSuppress, A.SetDunSuppress) SetDunSuppress
	,ISNULL(MA.ASResActionCode, A.ASResActionCode) ASResActionCode
	,ISNULL(MA.ASCCaseActionCode, A.ASCCaseActionCode) ASCCaseActionCode
	,ISNULL(MA.ACOverridePriority, A.ACOverridePriority) ACOverridePriority
	,ISNULL(MA.Email, A.Email) Email
	,ISNULL(MA.GenerateSMS, A.GenerateSMS) GenerateSMS
	,ISNULL(MA.GenerateLetter, A.GenerateLetter) GenerateLetter
FROM AStatusAccounts A WITH (NOLOCK)
LEFT OUTER JOIN AStatusAccounts MA WITH (NOLOCK) ON A.AcctID = MA.Parent01Aid
	AND MA.MerchantAID IN (
		SELECT M.AcctID
		FROM Institutions I WITH (NOLOCK)
		JOIN MerchantPLAccounts M WITH (NOLOCK) ON I.InstitutionID = M.parent02AID
			AND MPLMerchantLevel = 0
		WHERE I.SysOrgID = @SysOrgID
		)
JOIN CCardLookup C WITH (NOLOCK) ON A.AcctID = C.LutCode
	AND C.LUTid = 'AsstPlan'
	AND C.LutLanguage = 'dbb'
	AND C.Module = 'BC'
WHERE A.MerchantAID = @MerchantTemplate
ORDER BY MA.MerchantAID
	,MA.AcctID
	
--Join Merchant Status Setup Information Table with CCardLookup to retrieve field lookup value.
CREATE TABLE #MerchantStatusSetup (
	OrigStatusAcctID INT
	,OrigStatusDescription VARCHAR(100)
	,OrigPriority INT
	,OrigMerchantAID INT
	,OrigParent01AID INT
	,MerchantStatusAcctID INT
	,MerchantStatusDescription VARCHAR(100)
	,MerchantPriority INT
	,MerchantMerchantAID INT
	,MerchantParent01AID INT
	,Priority INT
	,Reissue_IssueAction VARCHAR(5)
	,Reissue_IssueActionDesc VARCHAR(100)
	,FinanceChargeAction VARCHAR(5)
	,FinanceChargeActionDesc VARCHAR(100)
	,RevolvingPaymentAction VARCHAR(5)
	,RevolvingPaymentActionDesc VARCHAR(100)
	,InsCancellationAction VARCHAR(5)
	,InsCancellationActionDesc VARCHAR(100)
	,CreditBureauStatus VARCHAR(2)
	,CheckOTB VARCHAR(5)
	,CheckOTBDesc VARCHAR(100)
	,TransactionPosting VARCHAR(5)
	,TransactionPostingDesc VARCHAR(100)
	,LoyaltyPointsAccumulation INT
	,LoyaltyPointsAccumulationDesc VARCHAR(100)
	,EligibleForInsurance VARCHAR(5)
	,EligibleForInsuranceDesc VARCHAR(100)
	,PostingReason VARCHAR(5)
	,PostingReasonDesc VARCHAR(100)
	,HoldStatement VARCHAR(25)
	,HoldStatementDesc VARCHAR(25)
	,WaiveLateChargeAction VARCHAR(5)
	,WaiveLateChargeActionDesc VARCHAR(100)
	,WaiveLateChargeFor VARCHAR(2)
	,WaiveLateChargeForDesc VARCHAR(10)
	,WaiveLateChargeFrom VARCHAR(1)
	,WaiveLateChargeFromDesc VARCHAR(25)
	,WaiveAnnualChgAction VARCHAR(5)
	,WaiveAnnualChgFor VARCHAR(2)
	,WaiveAnnualChgFrom VARCHAR(1)
	,WaiveOverLimitFeeAction VARCHAR(5)
	,WaiveOverLimitFeeFor VARCHAR(2)
	,WaiveOverLimitFeeFrom VARCHAR(1)
	,WaiveNSFAction VARCHAR(5)
	,WaiveNSFFor VARCHAR(2)
	,WaiveNSFFrom VARCHAR(1)
	,StatementDelivery VARCHAR(5)
	,StatementDeliveryDesc VARCHAR(100)
	,WaiveMinDue VARCHAR(5)
	,WaiveMinDueDesc VARCHAR(100)
	,WaiveMinDueFor VARCHAR(2)
	,WaiveMinDueFrom VARCHAR(1)
	,WaiveInsPremium VARCHAR(5)
	,WaiveInsPremiumFor VARCHAR(2)
	,WaiveInsPremiumFrom VARCHAR(1)
	,WaiveInterest VARCHAR(5)
	,WaiveInterestFor VARCHAR(2)
	,WaiveInterestFrom VARCHAR(1)
	,WaiveTransactionFeeAction VARCHAR(5)
	,WaiveTransactionFeeFor VARCHAR(2)
	,WaiveTransactionFeeFrom VARCHAR(1)
	,WaiveAuthFeeAction VARCHAR(5)
	,WaiveAuthFeeFor VARCHAR(2)
	,WaiveAuthFeeFrom VARCHAR(1)
	,WaiveCardFeeAction VARCHAR(5)
	,WaiveCardFeeFor VARCHAR(2)
	,WaiveCardFeeFrom VARCHAR(1)
	,WaiveMbrshipFeeAction VARCHAR(5)
	,WaiveMbrshipFeeFor VARCHAR(2)
	,WaiveMbrshipFeeFrom VARCHAR(1)
	,WaiveServiceFeeAction VARCHAR(5)
	,WaiveServiceFeeFor VARCHAR(2)
	,WaiveServiceFeeFrom VARCHAR(1)
	,WaiveMessageFeeAction VARCHAR(5)
	,WaiveMessageFeeFor VARCHAR(2)
	,WaiveMessageFeeFrom VARCHAR(1)
	,CBRStatusGroup VARCHAR(2)
	,ExcludeFromCBR INT
	,CollectionFlagsbyStatus VARCHAR(5)
	,SetDunSuppress VARCHAR(5)
	,ASResActionCode VARCHAR(2)
	,ASCCaseActionCode VARCHAR(2)
	,ACOverridePriority INT
	,Email VARCHAR(30)
	,GenerateSMS VARCHAR(30)
	,GenerateLetter VARCHAR(30)
	)

INSERT INTO #MerchantStatusSetup (
	OrigStatusAcctID
	,OrigStatusDescription
	,OrigPriority
	,OrigMerchantAID
	,OrigParent01AID
	,MerchantStatusAcctID
	,MerchantStatusDescription
	,MerchantPriority
	,MerchantMerchantAID
	,MerchantParent01AID
	,Priority
	,Reissue_IssueAction
	,Reissue_IssueActionDesc
	,FinanceChargeAction
	,FinanceChargeActionDesc
	,RevolvingPaymentAction
	,RevolvingPaymentActionDesc
	,InsCancellationAction
	,InsCancellationActionDesc
	,CreditBureauStatus
	,CheckOTB
	,CheckOTBDesc
	,TransactionPosting
	,TransactionPostingDesc
	,LoyaltyPointsAccumulation
	,LoyaltyPointsAccumulationDesc
	,EligibleForInsurance
	,EligibleForInsuranceDesc
	,PostingReason
	,PostingReasonDesc
	,HoldStatement
	,HoldStatementDesc
	,WaiveLateChargeAction
	,WaiveLateChargeActionDesc
	,WaiveLateChargeFor
	,WaiveLateChargeForDesc
	,WaiveLateChargeFrom
	,WaiveLateChargeFromDesc
	,WaiveAnnualChgAction
	,WaiveAnnualChgFor
	,WaiveAnnualChgFrom
	,WaiveOverLimitFeeAction
	,WaiveOverLimitFeeFor
	,WaiveOverLimitFeeFrom
	,WaiveNSFAction
	,WaiveNSFFor
	,WaiveNSFFrom
	,StatementDelivery
	,StatementDeliveryDesc
	,WaiveMinDue
	,WaiveMinDueDesc
	,WaiveMinDueFor
	,WaiveMinDueFrom
	,WaiveInsPremium
	,WaiveInsPremiumFor
	,WaiveInsPremiumFrom
	,WaiveInterest
	,WaiveInterestFor
	,WaiveInterestFrom
	,WaiveTransactionFeeAction
	,WaiveTransactionFeeFor
	,WaiveTransactionFeeFrom
	,WaiveAuthFeeAction
	,WaiveAuthFeeFor
	,WaiveAuthFeeFrom
	,WaiveCardFeeAction
	,WaiveCardFeeFor
	,WaiveCardFeeFrom
	,WaiveMbrshipFeeAction
	,WaiveMbrshipFeeFor
	,WaiveMbrshipFeeFrom
	,WaiveServiceFeeAction
	,WaiveServiceFeeFor
	,WaiveServiceFeeFrom
	,WaiveMessageFeeAction
	,WaiveMessageFeeFor
	,WaiveMessageFeeFrom
	,CBRStatusGroup
	,ExcludeFromCBR
	,CollectionFlagsbyStatus
	,SetDunSuppress
	,ASResActionCode
	,ASCCaseActionCode
	,ACOverridePriority
	,Email
	,GenerateSMS
	,GenerateLetter
	)
SELECT OrigStatusAcctID
	,OrigStatusDescription
	,OrigPriority
	,OrigMerchantAID
	,OrigParent01AID
	,MerchantStatusAcctID
	,MerchantStatusDescription
	,MerchantPriority
	,MerchantMerchantAID
	,MerchantParent01AID
	,Priority
	,Reissue_IssueAction
	,CL.LutDescription Reissue_IssueActionDesc
	,FinanceChargeAction
	,CL1.LutDescription FinanceChargeActionDesc
	,RevolvingPaymentAction
	,CL2.LutDescription RevolvingPaymentActionDesc
	,InsCancellationAction
	,CL3.LutDescription InsCancellationActionDesc
	,CreditBureauStatus
	,CheckOTB
	,CL4.LutDescription CheckOTBDesc
	,TransactionPosting
	,CL5.LutDescription TransactionPostingDesc
	,LoyaltyPointsAccumulation
	,CL6.LutDescription LoyaltyPointsAccumulationDesc
	,EligibleForInsurance
	,CL7.LutDescription EligibleForInsuranceDesc
	,PostingReason
	,CL8.LutDescription PostingReasonDesc
	,HoldStatement
	,CL9.LutDescription HoldStatementDesc
	,WaiveLateChargeAction
	,CL10.LutDescription WaiveLateChargeActionDesc
	,WaiveLateChargeFor
	,CL11.LutDescription WaiveLateChargeForDesc
	,WaiveLateChargeFrom
	,CL12.LutDescription WaiveLateChargeFromDesc
	,WaiveAnnualChgAction
	,WaiveAnnualChgFor
	,WaiveAnnualChgFrom
	,WaiveOverLimitFeeAction
	,WaiveOverLimitFeeFor
	,WaiveOverLimitFeeFrom
	,WaiveNSFAction
	,WaiveNSFFor
	,WaiveNSFFrom
	,StatementDelivery  
	,CL13.LutDescription StatementDeliveryDesc 
	,WaiveMinDue
	,CL14.LutDescription WaiveMinDueDesc 
	,WaiveMinDueFor
	,WaiveMinDueFrom
	,WaiveInsPremium
	,WaiveInsPremiumFor 
	,WaiveInsPremiumFrom
	,WaiveInterest
	,WaiveInterestFor
	,WaiveInterestFrom
	,WaiveTransactionFeeAction
	,WaiveTransactionFeeFor 
	,WaiveTransactionFeeFrom
	,WaiveAuthFeeAction 
	,WaiveAuthFeeFor 
	,WaiveAuthFeeFrom
	,WaiveCardFeeAction 
	,WaiveCardFeeFor
	,WaiveCardFeeFrom
	,WaiveMbrshipFeeAction 
	,WaiveMbrshipFeeFor
	,WaiveMbrshipFeeFrom
	,WaiveServiceFeeAction 
	,WaiveServiceFeeFor
	,WaiveServiceFeeFrom    
	,WaiveMessageFeeAction 
	,WaiveMessageFeeFor 
	,WaiveMessageFeeFrom
	,CBRStatusGroup
	,ExcludeFromCBR
	,CollectionFlagsbyStatus    
	,SetDunSuppress
	,ASResActionCode
	,ASCCaseActionCode 
	,ACOverridePriority  
	,Email         
	,GenerateSMS                  
	,GenerateLetter
FROM #MerchantStatusInfo M
LEFT OUTER JOIN CCardLookup CL WITH (NOLOCK) ON CL.LutCode = M.Reissue_IssueAction
	AND CL.LUTid = 'ASIssueReissue'
	AND CL.Module = 'BC'
	AND CL.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL1 WITH (NOLOCK) ON CL1.LutCode = M.FinanceChargeAction
	AND CL1.LUTid = 'ASFinCharge'
	AND CL1.Module = 'BC'
	AND CL1.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL2 WITH (NOLOCK) ON CL2.LutCode = M.RevolvingPaymentAction
	AND CL2.LUTid = 'ASRevolvingPymt'
	AND CL2.Module = 'BC'
	AND CL2.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL3 WITH (NOLOCK) ON CL3.LutCode = M.InsCancellationAction
	AND CL3.LUTid = 'ASInsCanceln'
	AND CL3.Module = 'BC'
	AND CL3.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL4 WITH (NOLOCK) ON CL4.LutCode = M.CheckOTB
	AND CL4.LUTid = 'ASCheckOTB'
	AND CL4.Module = 'BC'
	AND CL4.LutLanguage = 'dbb'		
LEFT OUTER JOIN CCardLookup CL5 WITH (NOLOCK) ON CL5.LutCode = M.TransactionPosting
	AND CL5.LUTid = 'ASPostTxns'
	AND CL5.Module = 'BC'
	AND CL5.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL6 WITH (NOLOCK) ON CL6.LutCode = M.LoyaltyPointsAccumulation
	AND CL6.LUTid = 'LP_StatDefi'
	AND CL6.Module = 'BC'
	AND CL6.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL7 WITH (NOLOCK) ON CL7.LutCode = M.EligibleForInsurance
	AND CL7.LUTid = 'ASInsEligible'
	AND CL7.Module = 'BC'
	AND CL7.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL8 WITH (NOLOCK) ON CL8.LutCode = M.PostingReason
	AND CL8.LUTid = 'PostingReason'
	AND CL8.Module = 'BC'
	AND CL8.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL9 WITH (NOLOCK) ON CL9.LutCode = M.HoldStatement
	AND CL9.LUTid = 'HoldStatement'
	AND CL9.Module = 'BC'
	AND CL9.LutLanguage = 'dbb'		
LEFT OUTER JOIN CCardLookup CL10 WITH (NOLOCK) ON CL10.LutCode = M.WaiveLateChargeAction
	AND CL10.LUTid = 'ASWaiveLateChg'
	AND CL10.Module = 'BC'
	AND CL10.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL11 WITH (NOLOCK) ON CL11.LutCode = M.WaiveLateChargeFor
	AND CL11.LUTid = 'WaiveForMonths'
	AND CL11.Module = 'BC'
	AND CL11.LutLanguage = 'dbb'		
LEFT OUTER JOIN CCardLookup CL12 WITH (NOLOCK) ON CL12.LutCode = M.WaiveLateChargeFrom
	AND CL12.LUTid = 'AStatusWaiveFrom'
	AND CL12.Module = 'BC'
	AND CL12.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL13 WITH (NOLOCK) ON CL13.LutCode = M.StatementDelivery
	AND CL13.LUTid = 'ASStmtDelivery'
	AND CL13.Module = 'BC'
	AND CL13.LutLanguage = 'dbb'	
LEFT OUTER JOIN CCardLookup CL14 WITH (NOLOCK) ON CL14.LutCode = M.WaiveMinDue
	AND CL14.LUTid = 'ASWaiveMinDue'
	AND CL14.Module = 'BC'
	AND CL14.LutLanguage = 'dbb'
	
CREATE NONCLUSTERED INDEX idx_MerchantStatusSetup1 ON #MerchantStatusSetup (MerchantMerchantAID)

IF OBJECT_ID ('TEMPDB..#TEMP_Statement_All') IS NULL
BEGIN
	DROP TABLE

	IF EXISTS #TEMP_Statement_All
		CREATE TABLE #TEMP_Statement_All (
			AccountNUmber VARCHAR(19)
			,Acctid INT
			,Statementdate DATETIME
			,StatementID INT
			,Processed INT
			)

	INSERT INTO #TEMP_Statement_All
	SELECT AccountNUmber
		,Acctid
		,Statementdate
		,StatementID
		,0
	FROM Statementheader WITH (NOLOCK)
	WHERE Statementdate = @Statementdate
		--AND AccountNumber in ('1100011137950790','1100011137959239','1100011140620117')
		--AND AcctID in (162965,576476,627780,707131,930701,1542992, 1579456,1700933,1971125,9427827,11469017,12294757)
		AND AcctID in (14551538)
END

--select * from #TEMP_Statement_All
IF EXISTS (
		SELECT TOP 1 1
		FROM #TEMP_Statement_All
		)
BEGIN
	PRINT 'DO NOT INSERT #TEMP_Statement_All'
END
ELSE
BEGIN
	PRINT 'DO NOT FOUND THE RECORDS'
END

	--Select * from #TEMP_Statement_Loop

IF OBJECT_ID('TEMPDB..#TEMP_Statement_Loop') IS NULL
BEGIN
	DROP TABLE

	IF EXISTS #TEMP_Statement_Loop
		CREATE TABLE #TEMP_Statement_Loop (
			AccountNUmber VARCHAR(19)
			,Acctid INT
			,Statementdate DATETIME
			,StatementID INT
			,Processed INT
			)
END
ELSE IF EXISTS (
		SELECT TOP 1 1
		FROM #TEMP_Statement_Loop
		)
BEGIN
	PRINT 'DO NOT DELETE #TEMP_Statement_Loop'
END

IF EXISTS (
		SELECT *
		FROM #TEMP_Statement_Loop
		WHERE Processed = 0
		)
BEGIN
	PRINT 'Error:- Please run query in New Session'
END
ELSE
BEGIN
	INSERT INTO #TEMP_Statement_Loop
	SELECT TOP (@TopStatement) AccountNUmber
		,Acctid
		,Statementdate
		,StatementID
		,0
	FROM #TEMP_Statement_All WITH (NOLOCK)
	ORDER BY Acctid
END

DROP TABLE

IF EXISTS #BeekmanPlans
	SELECT DISTINCT SH.AcctID
		,SH.AccountNumber
	--DROP TABLE #BeekmanPlans
	INTO #BeekmanPlans
	FROM StatementHeader SH WITH (NOLOCK)
	JOIN SummaryHeader S WITH (NOLOCK) ON SH.AcctID = S.parent02AID
		AND SH.StatementID = S.StatementID
	JOIN SummaryHeaderCreditCard C WITH (NOLOCK) ON S.AcctID = C.AcctID
		AND S.StatementID = C.StatementID
	JOIN #TEMP_Statement_Loop BP ON SH.StatementID = BP.StatementID
	WHERE SH.StatementDate = @StatementDate
		AND S.CreditPlanType = '16'
		AND BP.Processed = 0

DROP TABLE

IF EXISTS #temppriorSH
	SELECT Statementdate
		,acctid
		,StatementID
		,ccinhparent125AID
		,parent05aid
	INTO #temppriorSH
	FROM StatementHeader B WITH (NOLOCK)
	WHERE EXISTS (
			SELECT 1
			FROM #BeekmanPlans A
			WHERE A.AccountNumber = B.AccountNumber
			)

DROP TABLE

IF EXISTS #PriorSH
	--Create Previous Statement Information
	SELECT B.AcctID
		,B.AccountNumber
		,B.StatementID
		,B.StatementDate
		,B.DateOfTotalDue
		,C.CreditPlanType
		,SMH.Principal
		,SMH.BeginningBalance
		,B.AmtOfPayCurrDue
		,B.AmountOfTotalDue
		,SMH.AmountofTotalDue PlanTotalDue
		,SMH.CurrentBalance
		,SC.CurrentBalanceCO
		,SMH.AmtOfInterestCTD
		,SMH.AmountOfCreditsCTD
		,SMH.AmountOfPaymentsCTD
		,SC.CurrentDue
		,SC.AmtOfPayXDLate
		,SC.AmountOfPayment30DLate
		,SC.AmountOfPayment60DLate
		,SC.AmountOfPayment90DLate
		,SC.AmountOfPayment120DLate
		,SC.AmountOfPayment150DLate
		,SC.AmountOfPayment180DLate
		,SC.AmountOfPayment210DLate
		,SC.EqualPaymentAmt
		,SC.EqualPaymentAmt OriginalEqualPaymentAmt
		,B.ccinhparent125aid ManualStatus
		,M.MerchantStatusDescription
		,B.SystemStatus
		,M.WaiveMinDue
		,SC.CycleDueDTD
		,CSH.AcctID CPSID
		,CSH.AccountGraceStatus
		,CSH.GraceDaysStatus
	--DROP TABLE #PRIORSH
	INTO #PriorSH
	FROM #temppriorSH tsh
	INNER JOIN StatementHeader B WITH (NOLOCK) ON (
			tsh.statementdate = b.statementdate
			AND tsh.acctid = b.acctid
			)
	JOIN SummaryHeader SMH WITH (NOLOCK) ON SMH.StatementID = tsh.StatementID
	JOIN SummaryHeaderCreditCard SC WITH (NOLOCK) ON SMH.StatementID = SC.StatementID
		AND SMH.AcctID = SC.AcctID
		AND SC.AcctID > 0
	LEFT OUTER JOIN #CPMInfo CI ON CASE 
			WHEN SMH.parent01aid = 1
				THEN CI.CPMID
			END = SMH.parent01aid
	LEFT OUTER JOIN #CPMInfoSetup C ON CASE 
			WHEN SMH.parent01aid <> 1
				THEN C.CPMID
			END = SMH.parent01aid
	LEFT OUTER JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON CSH.StatementID = tsh.StatementID
		AND CSH.AcctID = SMH.AcctID
	JOIN #MerchantStatusSetup M ON M.MerchantMerchantAID = tsh.parent05AID
		AND M.OrigStatusAcctID = tsh.ccinhparent125AID
	WHERE tsh.StatementID IN (
			SELECT MAX(a.StatementID)
			FROM StatementHeader A WITH (NOLOCK)
			WHERE A.AcctID = tsh.AcctID
				AND DATEDIFF(MONTH, A.StatementDate, @StatementDate) = 1
			)
	OPTION (MAXDOP 8)

--AND SMH.CreditPlanType = '16'
--select EqualPaymentAmt, * from #PriorSH where accountNumber='1100011134783970'
UPDATE #PriorSH
SET EqualPaymentAmt = CASE 
		WHEN (
				CreditPlanType NOT IN ('16')
				OR SystemStatus = '14'
				)
			THEN CurrentBalance + CurrentBalanceCO
		WHEN CreditPlanType IN ('16')
			THEN CASE 
					--WHEN MerchantStatusDescription LIKE '%Disaster Recovery'
					WHEN WaiveMinDue = 1
						AND CurrentDue + AmtOfPayXDLate + AmountOfPayment30DLate + AmountOfPayment60DLate + AmountOfPayment90DLate + AmountOfPayment120DLate + AmountOfPayment150DLate + AmountOfPayment180DLate + AmountOfPayment210DLate = 0
						THEN 0
					WHEN
						--MerchantStatusDescription LIKE 'Disaster%'
						CurrentDue + AmtOfPayXDLate + AmountOfPayment30DLate + AmountOfPayment60DLate + AmountOfPayment90DLate + AmountOfPayment120DLate + AmountOfPayment150DLate + AmountOfPayment180DLate + AmountOfPayment210DLate <> 0
						THEN CurrentDue + AmtOfPayXDLate + AmountOfPayment30DLate + AmountOfPayment60DLate + AmountOfPayment90DLate + AmountOfPayment120DLate + AmountOfPayment150DLate + AmountOfPayment180DLate + AmountOfPayment210DLate
					WHEN CurrentBalance + CurrentBalanceCO <= 0
						THEN 0
					WHEN CurrentBalance + CurrentBalanceCO <= EqualPaymentAmt
						THEN CurrentBalance + CurrentBalanceCO
					WHEN CycleDueDTD > 1
						AND AmountofCreditsCTD > 0
						AND EqualPaymentAmt - AmountofCreditsCTD > 0
						THEN EqualPaymentAmt + (EqualPaymentAmt - AmountofCreditsCTD)
					WHEN CycleDueDTD > 1
						AND AmountofCreditsCTD = 0
						THEN EqualPaymentAmt * CycleDueDTD
					WHEN CycleDueDTD > 1
						AND ISNULL(AmtOfPayXDLate, 0) <> 0
						THEN EqualPaymentAmt + ISNULL(AmtOfPayXDLate, 0)
							--WHEN AmountofPaymentsCTD > 0
							--			AND AmountofCreditsCTD > 0
							--			AND EqualPaymentAmt - AmountofCreditsCTD > 0
							--			AND AmountofCreditsCTD <> ISNULL(AmtOfPayXDLate, 0)
							--			THEN EqualPaymentAmt + (EqualPaymentAmt - AmountofCreditsCTD)
					ELSE EqualPaymentAmt
					END
		ELSE EqualPaymentAmt
		END
		--select * from #PriorSH where AccountNumber='1100011128250127'
--------------------
DROP TABLE

IF EXISTS #TempSHAB
	SELECT B.systemstatus
		,B.Parent05aid
		,B.Ccinhparent125aid
		,B.StatementDate
		,B.acctid
		,b.statementid
	INTO #TempSHAB
	FROM StatementHeader B WITH (NOLOCK)
	JOIN #TEMP_Statement_Loop BP ON BP.StatementID = B.StatementID
	WHERE B.StatementDate = @StatementDate
		AND BP.Processed = 0
		AND EXISTS (
			SELECT 1
			FROM #BeekmanPlans P
			WHERE P.AccountNumber = B.AccountNumber
			)

DROP TABLE

IF EXISTS #SHAB
	SELECT B.AcctID AS BAcctID
		,B.StatementDate
		,B.StatementID
		,A.AcctID AS AAcctID
		,
		--IL.InstitutionName,
		--New
		B.InstitutionID
		,B.AccountNumber
		,B.parent02aid
		,B.AmountOfTotalDue
		,B.NetInstallmentDueCTD
		,B.NetInstallmentDueCC1
		,B.NetInstallmentDueCC2
		,B.NetInstallmentDueCC3
		,B.NetInstallmentDueCC4
		,B.NetInstallmentDueCC5
		,B.DaysInCycle
		,ISNULL(B.StatementDatecc1, B.DateAcctOpened) AS StatementDateCC1
		,ISNULL(B.StatementDateCC2, B.DateAcctOpened) AS StatementDateCC2
		,B.LastPmtDate
		,B.Parent05AID AS MerchantAID
		,B.ccinhparent125AID AS ManualStatus
		,B.SystemStatus
		,CASE 
			WHEN M.Priority >= G.Priority
				THEN B.systemstatus
			ELSE B.ccinhparent125aid
			END ---updated by Rahul Sahu
		DerivedStatus
		,CASE 
			WHEN M.Priority >= G.Priority
				THEN M.WaiveMinDue
			ELSE G.WaiveMinDue
			END DerivedWaiveMinDue
		,CASE 
			WHEN M.Priority >= G.Priority
				THEN M.WaiveMinDuefor
			ELSE G.WaiveMinDuefor
			END DerivedWaiveMinDueFor
		,CASE 
			WHEN M.Priority >= G.Priority
				THEN M.WaiveMinDueFrom
			ELSE G.WaiveMinDueFrom
			END DerivedWaiveMinDueFrom
		,B.WaiveMinDue AppWaiveMinDue
		,B.DateOfTotalDue
		,B.CurrentBalance
		,B.SBWithInstallmentDue AcctSBWithInstallmentDue
		,B.SRBWithInstallmentDue AcctSRBWithInstallmentDue
		,B.SRBwithInstallmentDueCC1 AcctSRBwithInstallmentDueCC1
		,B.ServiceChargeCTD
		,B.AmtOfInterestCTD
		,B.CTDTotalInt
		,B.CTDTotalFees
		,B.DateAcctOpened
		,B.AmountOfPurchasesCTD
		,B.AmtOfPaymentRevCTD
		,B.AmtOfNSFPayRevCTD
		,B.AmountOfPaymentsCTD
		,B.AmountOfReturnsCTD
		,B.PaymentLevel
		,B.ccinhparent127aid
		,B.ccinhparent112AID
		,B.ccinhparent113AID
		,B.ccinhparent114AID
		,B.ccinhparent115AID
		,B.ccinhparent108AID
		,A.StatementDate AS A_StatementDate
		,A.parent01aid
		,A.PlanSegCreateDate
		,A.CreditPlanType
		,A.Principal
		,A.BeginningBalance
		,A.AmountofDebitsCTD
		,A.AmountofDebitsRevCTD
		,A.AmountOfPurchasesCTD AS A_AmountOfPurchasesCTD
		,A.AmountofCreditsCTD
		,A.AmountOfPaymentsCTD AS A_AmountOfPaymentsCTD
		,A.AmountOfPaymentsLTD
		,A.AmountOfReturnsCTD AS A_AmountOfReturnsCTD
		,A.AmountOfReturnsLTD
		,SC.ManualPurchaseReversal_LTD
		,A.CurrentBalance AS A_CurrentBalance
		,A.AmountofTotalDue AS A_AmountofTotalDue
		,SC.CurrentDue
		,SC.AmtOfPayXDLate
		,SC.AmountOfPayment30DLate
		,SC.AmountOfPayment60DLate
		,SC.AmountOfPayment90DLate
		,SC.AmountOfPayment120DLate
		,SC.AmountOfPayment150DLate
		,SC.AmountOfPayment180DLate
		,SC.AmountOfPayment210DLate
		,SC.CreditBalanceMovement --Credit moved from Regular Individual plan
		,ISNULL(A.InterestStartDate, A.PlanSegCreateDate) AS InterestStartDate
		,A.APR
		,A.BSFC
		,A.BSFCMethod
		,A.AggBalanceCTD
		,A.DaysInCycle AS A_DaysInCycle
		,A.AmtOfInterestCTD AS A_AmtOfInterestCTD
		,A.AmtInterestCreditsCTD
		,A.DeInterestAdjustment
		,A.LateChargesCTD
		,A.ServiceChargeCTD AS A_ServiceChargeCTD
		,A.RecoveryFeesCTD
		,A.InsuranceCTD
		,A.NSFFeesCTD
		,A.MembershipFeesCTD
		,A.AmtOfOvrLimitFeesCTD
		,A.CollectionFeesCTD
		,A.ChargeOffDate
		,A.DeferredAccruedCTD AS A_DeferredAccruedCTD
		,A.DeferredIntAtExpCancel
		,A.AmountOfCreditsRevCTD
		,A.WaivedInterest
		,A.ccinhparent111AID
		,A.ccinhparent116AID
		,A.ccinhparent117AID
		,A.ccinhparent118AID
		,A.ccinhparent119AID
		,A.ccinhparent120AID
		,A.ccinhparent121AID
		,A.ccinhparent122AID
		,SC.CurrentBalanceCO
		,SC.SBWithInstallmentDue
		,SC.SRBWithInstallmentDue
		,SC.SRBwithInstallmentDueCC1
		,SC.OriginalPurchaseAmount
		,SC.EqualPaymentAmt
		,SC.DailyCashPercent
		,SC.DailyCashAmount
		,SC.PayoffDate
		,SC.LoanEndDate
		,SC.CardAcceptorNameLocation
		,SC.NewTransactionsAgg
		,SC.RevolvingAgg
		,SC.NewTransactionsBSFC
		,SC.RevolvingBSFC
		,SC.TotalBSFC
		,SC.DeferredAccrued
		,SC.DeferredAccruedCTD
		,SC.DeferredAccruedFinal
		,SC.PrincipalDefAdjustment
		,SC.PrincipalDefCTD
		,SC.InterestDefermentStatus
		,SC.NewTransactionsAccrued
		,SC.AfterCycleRevolvBSFC
		,SC.CycleDueDTD
		,SC.DaysDelinquent
		,CP.PenaltyPricingActive
		,SC.DispRCHFavororWriteOff
		,SC.DisputesAmtns
		,SC.AmountofCreditsRevLTD
		,A.AmountofCreditsLTD
		,ISNULL(P.AmountofTotalDue, 0) PriorMonthPlanAmtDue
	INTO #SHAB
	FROM StatementHeader B WITH (NOLOCK)
	JOIN #TempSHAB BP ON BP.StatementDate = B.StatementDate
		AND bp.acctid = b.acctid
	LEFT OUTER JOIN SummaryHeader A WITH (NOLOCK) ON A.StatementID = Bp.StatementID
	JOIN SummaryHeaderCreditCard SC WITH (NOLOCK) ON A.StatementID = SC.StatementID
		AND A.AcctID = SC.AcctID
		AND SC.AcctID > 0
	JOIN CPSgmentCreditCard CP WITH (NOLOCK) ON A.AcctID = CP.AcctID
	LEFT JOIN #MerchantStatusSetup M ON Bp.systemstatus = M.OrigStatusAcctID
		AND Bp.Parent05aid = M.MerchantMerchantAID
	LEFT JOIN #MerchantStatusSetup G ON Bp.Ccinhparent125aid = G.OrigStatusAcctID
		AND Bp.Parent05aid = G.MerchantMerchantAID
	LEFT OUTER JOIN #PriorSH P ON P.AcctID = B.AcctID
		AND P.CPSID = A.AcctID
	OPTION (MAXDOP 8)

-----****---------------
CREATE NONCLUSTERED INDEX idxn_#SHAB ON #SHAB (accountnumber)

DROP TABLE

IF EXISTS #SH_SUB
	SELECT *
	INTO #SH_SUB
	FROM #SHAB AB

--WHERE (
--		AB.BeginningBalance <> 0
--		OR AB.A_CurrentBalance + AB.CurrentBalanceCO <> 0
--		)
CREATE NONCLUSTERED INDEX [Idx_#SH_SUB] ON [dbo].[#SH_SUB] ([SystemStatus]) INCLUDE (
	[BAcctID]
	,[StatementID]
	,[AAcctID]
	,[InstitutionID]
	,[AccountNumber]
	,[parent02aid]
	,[AmountOfTotalDue]
	,[NetInstallmentDueCTD]
	,[NetInstallmentDueCC1]
	,[NetInstallmentDueCC2]
	,[NetInstallmentDueCC3]
	,[NetInstallmentDueCC4]
	,[NetInstallmentDueCC5]
	,[DaysInCycle]
	,[StatementDateCC1]
	,[StatementDateCC2]
	,[LastPmtDate]
	,[MerchantAID]
	,[ManualStatus]
	,[DateOfTotalDue]
	,[CurrentBalance]
	,[ServiceChargeCTD]
	,[AmtOfInterestCTD]
	,[CTDTotalInt]
	,[CTDTotalFees]
	,[DateAcctOpened]
	,[AmountOfPurchasesCTD]
	,[AmtOfPaymentRevCTD]
	,[AmtOfNSFPayRevCTD]
	,[AmountOfPaymentsCTD]
	,[CycleDueDTD]
	,[PaymentLevel]
	,[ccinhparent127aid]
	,[ccinhparent112AID]
	,[ccinhparent113AID]
	,[ccinhparent114AID]
	,[ccinhparent115AID]
	,[ccinhparent108AID]
	,[A_StatementDate]
	,[parent01aid]
	,[PlanSegCreateDate]
	,[Principal]
	,[BeginningBalance]
	,[AmountofDebitsCTD]
	,[A_AmountOfPurchasesCTD]
	,[AmountofCreditsCTD]
	,[A_AmountOfPaymentsCTD]
	,[AmountOfPaymentsLTD]
	,[AmountOfReturnsCTD]
	,[AmountOfReturnsLTD]
	,[A_CurrentBalance]
	,[A_AmountofTotalDue]
	,[InterestStartDate]
	,[APR]
	,[BSFC]
	,[BSFCMethod]
	,[AggBalanceCTD]
	,[A_DaysInCycle]
	,[A_AmtOfInterestCTD]
	,[AmtInterestCreditsCTD]
	,[DeInterestAdjustment]
	,[LateChargesCTD]
	,[A_ServiceChargeCTD]
	,[RecoveryFeesCTD]
	,[InsuranceCTD]
	,[NSFFeesCTD]
	,[MembershipFeesCTD]
	,[AmtOfOvrLimitFeesCTD]
	,[CollectionFeesCTD]
	,[ChargeOffDate]
	,[A_DeferredAccruedCTD]
	,[DeferredIntAtExpCancel]
	,[AmountOfCreditsRevCTD]
	,[WaivedInterest]
	,[ccinhparent111AID]
	,[ccinhparent116AID]
	,[ccinhparent117AID]
	,[ccinhparent118AID]
	,[ccinhparent119AID]
	,[ccinhparent120AID]
	,[ccinhparent121AID]
	,[ccinhparent122AID]
	,[CurrentBalanceCO]
	,[SBWithInstallmentDue]
	,[SRBWithInstallmentDue]
	,[SRBwithInstallmentDueCC1]
	,[OriginalPurchaseAmount]
	,[EqualPaymentAmt]
	,[DailyCashPercent]
	,[DailyCashAmount]
	,[PayoffDate]
	,[LoanEndDate]
	,[CardAcceptorNameLocation]
	,[NewTransactionsAgg]
	,[RevolvingAgg]
	,[NewTransactionsBSFC]
	,[RevolvingBSFC]
	,[TotalBSFC]
	,[DeferredAccrued]
	,[DeferredAccruedCTD]
	,[DeferredAccruedFinal]
	,[PrincipalDefAdjustment]
	,[PrincipalDefCTD]
	,[InterestDefermentStatus]
	,[NewTransactionsAccrued]
	,[AfterCycleRevolvBSFC]
	,[DaysDelinquent]
	,[PenaltyPricingActive]
	)

CREATE CLUSTERED INDEX [Idx_#PriorSH] ON [dbo].[#PriorSH] (
	[AccountNumber]
	,[CPSID]
	)
	----------------------------

--Create Current Statement Information

DROP TABLE IF EXISTS #TempCPMInfo
DROP TABLE IF EXISTS #TempCPMInfoSetup

SELECT AB.InstitutionID
	--,IL.InstitutionName
	,AB.StatementID
	,AB.A_StatementDate StatementDate
	,AB.BAcctID AS AcctID
	,RTRIM(AB.AccountNumber) AS AccountNumber
	,AB.parent02aid AS ProductId
	,AB.parent01aid CPMID
	,C.CPMName
	,AB.AAcctID AS CPSID
	,AB.PlanSegCreateDate
	,C.CreditPlanType
	,C.CreditPlanTypeDesc
	,AB.Principal
	,AB.BeginningBalance
	,AB.AmountofDebitsCTD
	,AB.AmountofDebitsRevCTD
	,AB.A_AmountOfPurchasesCTD AmountOfPurchasesCTD
	,AB.AmountofCreditsCTD
	,AB.A_AmountOfPaymentsCTD AmountOfPaymentsCTD
	,AB.AmountOfPaymentsLTD
	,AB.AmountofReturnsCTD AcctAmountofReturnsCTD
	,AB.A_AmountOfReturnsCTD
	,AB.AmountOfReturnsLTD
	,AB.A_CurrentBalance CurrentBalance
	,AB.CurrentBalanceCO
	,AB.A_AmountofTotalDue AS PlanTotalDue
	,AB.AmountOfTotalDue AS AcctTotalDue
	,AB.CurrentDue
	,AB.AmtOfPayXDLate
	,AB.AmountOfPayment30DLate
	,AB.AmountOfPayment60DLate
	,AB.AmountOfPayment90DLate
	,AB.AmountOfPayment120DLate
	,AB.AmountOfPayment150DLate
	,AB.AmountOfPayment180DLate
	,AB.AmountOfPayment210DLate
	,AB.AcctSBWithInstallmentDue
	,AB.AcctSRBWithInstallmentDue
	,AB.AcctSRBwithInstallmentDueCC1
	,AB.SBWithInstallmentDue
	,AB.SRBWithInstallmentDue
	,AB.SRBwithInstallmentDueCC1
	,AB.NetInstallmentDueCTD
	,AB.NetInstallmentDueCC1
	,AB.NetInstallmentDueCC2
	,AB.NetInstallmentDueCC3
	,AB.NetInstallmentDueCC4
	,AB.NetInstallmentDueCC5
	,AB.OriginalPurchaseAmount
	,AB.EqualPaymentAmt
	,AB.DailyCashPercent
	,AB.DailyCashAmount
	,AB.PayoffDate
	,AB.LoanEndDate
	,AB.CardAcceptorNameLocation
	,AB.InterestStartDate
	,AB.APR
	,AB.BSFC
	,--SummaryHeaderBSFC is based on sh DaysInCycle
	AB.BSFCMethod
	,AB.AggBalanceCTD
	,AB.DaysInCycle AS AccountDaysInCycle
	,--statement header days in cycle
	AB.A_DaysInCycle DaysInCycle
	,--summary header days in cycle
	AB.NewTransactionsAgg
	,AB.RevolvingAgg
	,AB.NewTransactionsBSFC
	,--not an adb
	AB.RevolvingBSFC
	,--not an adb
	AB.TotalBSFC
	,--this is not adb, it is a balance
	AB.DeferredAccrued
	,AB.DeferredAccruedCTD AS SmHdCCDeferredAccruedCTD
	,AB.DeferredAccruedFinal
	,AB.PrincipalDefAdjustment
	,AB.PrincipalDefCTD
	,AB.InterestDefermentStatus
	,StatementDateCC1
	,StatementDateCC2
	,AB.NewTransactionsAccrued
	,AB.AfterCycleRevolvBSFC
	,AB.A_AmtOfInterestCTD AmtOfInterestCTD
	,AB.AmtInterestCreditsCTD
	,AB.DeInterestAdjustment
	,AB.LateChargesCTD
	,AB.A_ServiceChargeCTD ServiceChargeCTD
	,AB.RecoveryFeesCTD
	,AB.InsuranceCTD
	,AB.NSFFeesCTD
	,AB.MembershipFeesCTD
	,AB.AmtOfOvrLimitFeesCTD
	,AB.CollectionFeesCTD
	,AB.LastPmtDate
	,AB.ChargeOffDate
	--,SH1.WaivedInterest WaivedInterestAmount
	,AB.A_DeferredAccruedCTD DeferredAccruedCTD
	,AB.DeferredIntAtExpCancel
	,AB.MerchantAID
	,AB.ManualStatus
	,AB.SystemStatus
	,AB.DerivedStatus
	,AB.DerivedWaiveMinDue
	,AB.DerivedWaiveMinDueFor
	,AB.DerivedWaiveMinDueFrom
	,AB.AppWaiveMinDue
	,AB.DateOfTotalDue
	,AB.CurrentBalance AS StHdCurrentBal
	,AB.ServiceChargeCTD AS StHdServiceChargeCTD
	,AB.AmtOfInterestCTD AS StHdAmtOfInterestCTD
	,AB.CTDTotalInt
	,AB.CTDTotalFees
	,AB.DateAcctOpened
	,AB.AmountOfPurchasesCTD AS TotAcctPurchaseCTD
	,AB.AmountOfCreditsRevCTD
	,AB.AmtOfPaymentRevCTD
	,AB.AmtOfNSFPayRevCTD
	,AB.AmountOfPaymentsCTD AS TotAcctPmtRcvCTD
	,AB.CycleDueDTD
	,AB.DaysDelinquent
	,AB.DispRCHFavororWriteOff
	,AB.DisputesAmtns
	,AB.ManualPurchaseReversal_LTD
	,AB.AmountofCreditsRevLTD
	,AB.AmountofCreditsLTD
	,P.ManualStatus PriorManualStatus
	,P.SystemStatus PriorSystemStatus
	,P.StatementDate PriorStmtDate
	,P.DateOfTotalDue PriorStmtDueDate
	,P.Principal PriorStmtPrincipal
	,P.BeginningBalance PriorStmtBegBal
	,P.AmtOfInterestCTD PriorStmtInterestsCTD
	,P.AmountOfPaymentsCTD PriorStmtPaymentsCTD
	,P.AmountOfCreditsCTD PriorStmtCreditsCTD
	,P.AmountOfTotalDue PriorStmtAcctTotalDue
	,ISNULL(P.PlanTotalDue, 0) PriorStmtPlanTotalDue
	,P.AmtOfPayXDLate + P.AmountOfPayment30DLate + P.AmountOfPayment60DLate + P.AmountOfPayment90DLate + P.AmountOfPayment120DLate + P.AmountOfPayment150DLate + P.AmountOfPayment180DLate + P.AmountOfPayment210DLate PriorStmtPastDue
	,P.AccountGraceStatus PriorStmtAccountGraceStatus --To be updated to PriorStmtAccountGraceStatus in Stmt DSL script
	,P.GraceDaysStatus PriorStmtGraceDaysStatus --To be updated to PriorStmtAccountGraceStatus in Stmt DSL script
	,C.MinimumPaymentDue
	,C.DueRounding
	,C.MinimumInterest
	,C.EqualPayments
	,ISNULL(AB.WaivedInterest, 0) AS WaivedInterest
	,LP.ReturnsCreditsBehavior
	,CL1.LutDescription ReturnsCreditsBehaviorDesc
	,LS.CreditsTreatAsPayment --Other Credits for Interest Grace
	,CL3.LutDescription CreditsTreatAsPaymentDesc
	,LS.RetrunCr_InterestGrace --Returns for Interest Grace
	,CL4.LutDescription RetrunCr_InterestGraceDesc
	,LS.ReturnCr_Due_On
	,CL5.LutDescription RetrunCr_DueOnDesc
	,LS.InterestGraceDecisionOn
	,CL6.LutDescription InterestGraceDecisionOnDesc
	,LS.InadverantCreditHold --1: Yes
	,AB.CreditBalanceMovement
	,ISNULL(E.MergeSRBWithInstallmentDueCC1, 0) MergeSRBWithInstallmentDueCC1
	,ISNULL(E.MergeBeginningBalance, 0) MergeBeginningBalance
	,ISNULL(E.MergeCycle, 0) MergeCycle
	,E.MergeDate
--DROP TABLE #SH
INTO #SH
--FROM #SHAB AB
FROM #SH_SUB AB
JOIN StatementHeaderEx E WITH (NOLOCK) ON E.AcctID = AB.BAcctID
	AND E.StatementID = AB.StatementID
LEFT OUTER JOIN #CPMInfo CI ON CASE 
		WHEN AB.parent01aid = 1
			THEN CI.CPMID
		END = AB.parent01aid
LEFT OUTER JOIN #CPMInfoSetup C ON CASE 
		WHEN AB.parent01aid <> 1
			THEN C.CPMID
		END = AB.parent01aid
JOIN BillingTableAccounts D WITH (NOLOCK) ON D.AcctID = AB.ccinhparent127aid
JOIN AStatusAccounts M WITH (NOLOCK) ON M.AcctID = AB.ManualStatus
JOIN AStatusAccounts G WITH (NOLOCK) ON G.AcctID = AB.SystemStatus
JOIN Logo_Primary LP WITH (NOLOCK) ON LP.AcctID = AB.Parent02Aid
LEFT OUTER JOIN CCardLookup CL1 WITH (NOLOCK) ON CL1.LutCode = ISNULL(LP.ReturnsCreditsBehavior, 0)
	AND CL1.LutID = 'LgRetCredBhvr'
	AND CL1.Module = 'BC'
	AND CL1.LutLanguage = 'dbb'
JOIN Logo_Secondary LS WITH (NOLOCK) ON LS.AcctID = LP.AcctID
LEFT OUTER JOIN #LookupData CL3 WITH (NOLOCK) ON CL3.LutCode = ISNULL(LS.CreditsTreatAsPayment, 1)
	AND CL3.LutID = 'YesNo'
LEFT OUTER JOIN #LookupData CL4 WITH (NOLOCK) ON CL4.LutCode = ISNULL(LS.RetrunCr_InterestGrace, 1)
	AND CL4.LutID = 'NoYes'
LEFT OUTER JOIN CCardLookup CL5 WITH (NOLOCK) ON CL5.LutCode = ISNULL(LS.ReturnCr_Due_On, 1)
	AND CL5.LutID = 'BalType'
	AND CL5.Module = 'BC'
	AND CL5.LutLanguage = 'dbb'
LEFT OUTER JOIN CCardLookup CL6 WITH (NOLOCK) ON CL6.LutCode = ISNULL(LS.InterestGraceDecisionOn, 1)
	AND CL6.LutID = 'PymtStmtBalance'
	AND CL6.Module = 'BC'
	AND CL6.LutLanguage = 'dbb'
LEFT OUTER JOIN #PriorSH P ON P.AccountNumber = AB.AccountNumber
	AND P.CPSID = AB.AAcctID

CREATE NONCLUSTERED INDEX IX_SH2 ON [dbo].[#SH] ([AccountNumber]) INCLUDE ([BeginningBalance])

--Status Change Information
DROP TABLE

IF EXISTS #StatusChange
	SELECT DISTINCT C.*
	INTO #StatusChange
	FROM CurrentBalanceAudit C WITH (NOLOCK)
	JOIN #SH S ON C.AID = S.AcctID
		AND C.NewValue = S.DerivedStatus
		AND C.Dename = '114'
		AND C.IdentityField = (
			SELECT TOP 1 identityfield
			FROM CurrentBalanceAudit B WITH (NOLOCK)
			WHERE B.AID = C.AID
				AND B.Dename = '114'
				AND B.NewValue = C.NewValue
				AND B.BusinessDay <= S.StatementDate
			ORDER BY IdentityField DESC
			)
	WHERE S.DerivedWaiveMinDue = 1

--EOD Account Tables Information
DROP TABLE

IF EXISTS #EODAccounts
	SELECT AR.InstitutionID
		,AR.BSAcctID
		,RTRIM(AR.AccountNumber) AccountNumber
		,AR.BusinessDay
		,AR.BeginningBalance
		,AR.CurrentBalance
		,AR.StatementRemainingBalance
		,AR.SRBWithInstallmentDue
		,AR.SBWithInstallmentDue
		,AR.SystemStatus
		,AR.ActualDRPStartDate
		,AR.DateOfDelinquency
		,AR.DateOfOriginalPaymentDueDTD
	INTO #EODAccounts
	FROM AccountInfoForReport AR WITH (NOLOCK)
	WHERE EXISTS (
			SELECT 1
			FROM #SH S
			WHERE S.AccountNumber = AR.AccountNumber
			)
		AND AR.BusinessDay = @Statementdate

--EOD Plan Tables Information
DROP TABLE

IF EXISTS #EODPlans
	SELECT PR.BSAcctID
		,RTRIM(PR.AccountNumber) AccountNumber
		,PR.BusinessDay
		,PR.CPSAcctID
		,PR.BeginningBalance
		,PR.CurrentBalance
		,PR.SRBWithInstallmentDue
		,PR.SBWithInstallmentDue
		,PR.SystemStatus
	--,PR.LastStatementDate DROP TABLE #EODPlans
	INTO #EODPlans
	FROM PlanInfoForReport PR WITH (NOLOCK)
	JOIN #SH S ON PR.AccountNumber = S.AccountNumber
		AND PR.CPSAcctID = S.CPSID
		AND PR.LastStatementDate = S.StatementDate
	WHERE PR.BusinessDay = @Statementdate

--Create Reversal transactions
DROP TABLE

IF EXISTS #REV
	SELECT CC.RevTgt
		,cc.cmttrantype
	INTO #REV
	FROM CCard_Primary CC WITH (NOLOCK)
	JOIN DoDetailTxns DOD WITH (NOLOCK) ON CC.RevTgt IS NOT NULL
		AND CC.RevTgt = DOD.TranId
	JOIN #TEMP_Statement_Loop BP ON BP.StatementID = DOD.StatementID
		AND DOD.StatementDate = @StatementDate
	WHERE CC.ARTxnType = '91'
		AND DOD.StatementDate = @StatementDate
		AND BP.Processed = 0

--Monetary Transactions
DROP TABLE

IF EXISTS #MonetaryTrans
	SELECT --D.AcctID
		DISTINCT RTRIM(C.AccountNumber) AccountNumber
		,D.StatementDate
		--,CS.CardAcceptorNameLocation
		,C.TxnAcctID
		,C.TranID
		,C.TxnSource
		,C.TransactionAmount
	--DROP TABLE #MonetaryTrans
	INTO #MonetaryTrans
	FROM CCard_Primary C WITH (NOLOCK)
	JOIN DoDetailTxns D WITH (NOLOCK) ON D.TranID = C.TranID
		AND D.StatementDate = @StatementDate
	JOIN #SHAB SH ON SH.StatementID = D.StatementID
	--	JOIN #TEMP_Statement_Loop BP ON BP.StatementID = D.StatementID
	--LEFT OUTER JOIN Ccard_Secondary CS WITH (NOLOCK) ON C.TranID = CS.TranID
	--AND C.ARTxnType <> 93
	WHERE C.CMTTRANTYPE IN (
			'40'
			,'41'
			,'42'
			,'43'
			)
		AND C.ARTxnType IN (
			'91'
			,'95'
			,'96'
			)
		--AND D.StatementDate = '2020-05-31 23:59:57.000'
		AND NOT EXISTS (
			SELECT 1
			FROM #REV R
			WHERE R.RevTgt = C.TranID
			)

--AND BP.Processed = 0
DROP TABLE

IF EXISTS #temp
	SELECT DISTINCT D.TranID
		,D.AcctID
		,D.StatementID
		,D.StatementDate
	INTO #temp
	FROM DoDetailTxns D WITH (NOLOCK)
	WHERE D.StatementDate = @StatementDate
		AND D.ATID = '62'
		AND EXISTS (
			SELECT 1
			FROM #BeekmanPlans A
			WHERE A.AcctID = D.AcctID
			)

	--AND L.AccountNumber='1100001000013016'	

--2)	Are we also on the same page that the ORIGINAL TRANSACTION Amount should be shown as “Amount” 

IF OBJECT_ID('tempdb.dbo.#t_Audit__Total_AC_BeekmanPlans') IS NULL
	CREATE TABLE [#t_Audit__Total_AC_BeekmanPlans] ([AAcctID] [bigint])

INSERT INTO #t_Audit__Total_AC_BeekmanPlans ([AAcctID])
SELECT AAcctID
FROM #SHAB

IF OBJECT_ID('tempdb.dbo.#t_Audit__Installment_Plan_0_Amount') IS NULL
	CREATE TABLE [dbo].[#t_Audit__Installment_Plan_0_Amount] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[CreditPlanType] [int] NULL
		,[CreditPlanTypeDesc] [varchar](50) NULL
		,[OriginalPurchaseAmount] [money] NULL
		,[TransactionAmount] [money] NULL
		,[BeginningBalance] [money] NULL
		,[AmountofDebitsCTD] [money] NULL
		,[AmountofCreditsCTD] [money] NULL
		,[CurrentBalance] [money] NULL
		,[CurrentBalanceCO] [money] NULL
		,[PlanTotalDue] [money] NULL
		,[AcctTotalDue] [money] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[SRBwithInstallmentDueCC1] [money] NULL
		,[CardAcceptorNameLocation] [varchar](100) NULL
		)

INSERT INTO [#t_Audit__Installment_Plan_0_Amount] (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,CreditPlanType
	,CreditPlanTypeDesc
	,OriginalPurchaseAmount
	,TransactionAmount
	,BeginningBalance
	,AmountofDebitsCTD
	,AmountofCreditsCTD
	,CurrentBalance
	,CurrentBalanceCO
	,PlanTotalDue
	,AcctTotalDue
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,SRBwithInstallmentDueCC1
	,CardAcceptorNameLocation
	)
SELECT 'Q1-Installment Plan should not have OriginalPurchaseAmount = 0' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.CreditPlanType
	,S.CreditPlanTypeDesc
	,S.OriginalPurchaseAmount
	,M.TransactionAmount
	,S.BeginningBalance
	,S.AmountofDebitsCTD
	,S.AmountofCreditsCTD
	,S.CurrentBalance
	,S.CurrentBalanceCO
	,S.PlanTotalDue
	,S.AcctTotalDue
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,S.SRBwithInstallmentDueCC1
	,S.CardAcceptorNameLocation
FROM #SH S
JOIN #MonetaryTrans M ON S.AccountNumber = M.AccountNumber
	AND S.CPSID = M.TxnAcctID
	AND S.CreditPlanType = '16'
	AND CONVERT(DATE, S.PlanSegCreateDate) = CONVERT(DATE, M.StatementDate)
WHERE S.OriginalPurchaseAmount = 0

INSERT INTO [#t_Audit__Installment_Plan_0_Amount] (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,CreditPlanType
	,CreditPlanTypeDesc
	,OriginalPurchaseAmount
	,TransactionAmount
	,BeginningBalance
	,AmountofDebitsCTD
	,AmountofCreditsCTD
	,CurrentBalance
	,CurrentBalanceCO
	,PlanTotalDue
	,AcctTotalDue
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,SRBwithInstallmentDueCC1
	,CardAcceptorNameLocation
	)
SELECT 'Q1.1-OriginalPurchaseAmount < Current Balance' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.CreditPlanType
	,S.CreditPlanTypeDesc
	,S.OriginalPurchaseAmount
	,0
	,S.BeginningBalance
	,S.AmountofDebitsCTD
	,S.AmountofCreditsCTD
	,S.CurrentBalance
	,S.CurrentBalanceCO
	,S.PlanTotalDue
	,S.AcctTotalDue
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,S.SRBwithInstallmentDueCC1
	,S.CardAcceptorNameLocation
FROM #SH S
WHERE S.CreditPlanType = '16'
	AND S.OriginalPurchaseAmount < S.CurrentBalance

IF OBJECT_ID('tempdb.dbo.#t_Audit__EqualPaymentAmountIncorrect') IS NULL
	CREATE TABLE [dbo].[#t_Audit__EqualPaymentAmountIncorrect] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[PlanSegCreateDate] [datetime] NULL
		,[ActualDRPStartDate] [datetime] NULL
		,[DerivedStatus] [int] NULL
		,[DerivedWaiveMinDue] [varchar](5) NULL
		,[DerivedWaiveMinDueFor] [varchar](2) NULL
		,[DerivedWaiveMinDueFrom] [varchar](1) NULL
		,[CreditPlanType] [int] NULL
		,[CreditPlanTypeDesc] [varchar](50) NULL
		,[CPSID] [int] NULL
		,[CycleDueDTD] [int] NULL
		,[PriorMonthEPA] [money] NULL
		,[OriginalPurchaseAmount] [money] NULL
		,[EqualPayments] [int] NULL
		,[EqualPaymentAmt] [money] NULL
		,[CalcEqPymtAmt] [money] NULL
		,[Diff] [money] NULL
		,[BeginningBalance] [money] NULL
		,[AmountofDebitsCTD] [money] NULL
		,[AmountofCreditsCTD] [money] NULL
		,[A_AmountofReturnsCTD] [money] NULL
		,[CreditBalanceMovement] [money] NULL
		,[PriorMonthPlanAmtDue] [money] NULL
		,[CurrentBalance] [money] NULL
		,[CurrentBalanceCO] [money] NULL
		,[CurrentDue] [money] NULL
		,[PlanTotalDue] [money] NULL
		,[AcctTotalDue] [money] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[SRBwithInstallmentDueCC1] [money] NULL
		,[CardAcceptorNameLocation] [varchar](100) NULL
		,[InadverantCreditHold] [varchar](5) NULL
	)

INSERT INTO [#t_Audit__EqualPaymentAmountIncorrect] (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,PlanSegCreateDate
	,ActualDRPStartDate
	,DerivedStatus
	,DerivedWaiveMinDue
	,DerivedWaiveMinDueFor
	,DerivedWaiveMinDueFrom
	,CreditPlanType
	,CreditPlanTypeDesc
	,CPSID
	,CycleDueDTD
	,PriorMonthEPA
	,OriginalPurchaseAmount
	,EqualPayments
	,EqualPaymentAmt
	,CalcEqPymtAmt
	,Diff
	,BeginningBalance
	,AmountofDebitsCTD
	,AmountofCreditsCTD
	,A_AmountofReturnsCTD
	,CreditBalanceMovement
	,PriorMonthPlanAmtDue
	,CurrentBalance
	,CurrentBalanceCO
	,CurrentDue
	,PlanTotalDue
	,AcctTotalDue
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,SRBwithInstallmentDueCC1
	,CardAcceptorNameLocation
	,InadverantCreditHold
	)
SELECT 'Q2-Equal Payment Amount Incorrect' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.PlanSegCreateDate
	,A.ActualDRPStartDate
	,S.DerivedStatus
	,S.DerivedWaiveMinDue
	,S.DerivedWaiveMinDueFor
	,S.DerivedWaiveMinDueFrom
	,S.CreditPlanType
	,S.CreditPlanTypeDesc
	,S.CPSID
	,S.CycleDueDTD
	,P.OriginalEqualPaymentAmt PriorMonthEPA
	,S.OriginalPurchaseAmount
	,S.EqualPayments
	,S.EqualPaymentAmt
	,CASE 
		WHEN DerivedWaiveMinDue = 1
			AND (
				DATEDIFF(MONTH, S.PlanSegCreateDate, ISNULL(A.ActualDRPStartDate, S.StatementDate)) IN (
					'0'
					,'1'
					)
				OR DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.StatementDate), S.StatementDate) = 0
				)
			THEN 0
		WHEN DerivedStatus = '14'
			THEN 0
		WHEN S.BeginningBalance + S.CurrentBalance + S.CurrentBalanceCO = 0
			THEN 0
		--WHEN InadverantCreditHold = 1
		--	AND ISNULL(S.CreditBalanceMovement, 0) <> 0
		--	AND CAST(ROUND(S.OriginalPurchaseAmount / CASE 
		--				WHEN EqualPayments = 0
		--					THEN 0.01
		--				ELSE EqualPayments
		--				END, 3) AS MONEY) - ISNULL(S.CreditBalanceMovement, 0) <= 0
		--	THEN 0	
		ELSE CAST(ROUND(S.OriginalPurchaseAmount / CASE 
						WHEN EqualPayments = 0
							THEN 0.01
						ELSE EqualPayments
						END, 3) AS MONEY)
		END CalcEqPymtAmt
	,S.EqualPaymentAmt - (
		CASE 
			WHEN DerivedWaiveMinDue = 1
				AND (
					DATEDIFF(MONTH, S.PlanSegCreateDate, ISNULL(A.ActualDRPStartDate, S.StatementDate)) IN (
						'0'
						,'1'
						)
					OR DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.StatementDate), S.StatementDate) = 0
					)
				THEN 0
			WHEN DerivedStatus = '14'
				THEN 0
			WHEN S.BeginningBalance + S.CurrentBalance + S.CurrentBalanceCO = 0
				THEN 0
			--WHEN InadverantCreditHold = 1
			--	AND ISNULL(S.CreditBalanceMovement, 0) <> 0
			--	AND CAST(ROUND(S.OriginalPurchaseAmount / CASE 
			--			WHEN EqualPayments = 0
			--				THEN 0.01
			--			ELSE EqualPayments
			--			END, 3) AS MONEY) - ISNULL(S.CreditBalanceMovement, 0) <= 0
			--	THEN 0
			ELSE CAST(ROUND(S.OriginalPurchaseAmount / (
							CASE 
								WHEN EqualPayments = 0
									THEN 0.01
								ELSE EqualPayments
								END
							), 3) AS MONEY)
			END
		) Diff
	,S.BeginningBalance
	,S.AmountofDebitsCTD
	,S.AmountofCreditsCTD
	,S.A_AmountofReturnsCTD
	,S.CreditBalanceMovement
	,P.PlanTotalDue PriorMonthPlanAmtDue
	,S.CurrentBalance
	,S.CurrentBalanceCO
	,S.CurrentDue
	,S.PlanTotalDue
	,S.AcctTotalDue
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,S.SRBwithInstallmentDueCC1
	,S.CardAcceptorNameLocation
	,S.InadverantCreditHold
FROM #SH S
JOIN #EODAccounts A ON A.BSAcctID = S.AcctID
	AND A.BusinessDay = S.StatementDate
JOIN #PriorSH P ON P.CPSID = S.CPSID
WHERE --S.AcctID in (162965)
	--S.AccountNumber='1100011136057639'
	CASE 
		WHEN S.CreditPlanType = '16'
			THEN S.EqualPaymentAmt
		END <> CASE 
		WHEN DerivedWaiveMinDue = 1
			AND (
				DATEDIFF(MONTH, S.PlanSegCreateDate, ISNULL(A.ActualDRPStartDate, S.StatementDate)) IN (
					'0'
					,'1'
					)
				OR DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.StatementDate), S.StatementDate) = 0
				)
			THEN 0
		WHEN DerivedStatus = '14'
			THEN 0
		WHEN S.BeginningBalance + S.CurrentBalance + S.CurrentBalanceCO = 0
			THEN 0
		--WHEN InadverantCreditHold = 1
		--		AND ISNULL(S.CreditBalanceMovement, 0) <> 0
		--		AND CAST(ROUND(S.OriginalPurchaseAmount / CASE 
		--				WHEN EqualPayments = 0
		--					THEN 0.01
		--				ELSE EqualPayments
		--				END, 3) AS MONEY) - ISNULL(S.CreditBalanceMovement, 0) <= 0
		--		THEN 0
		ELSE CAST(ROUND(S.OriginalPurchaseAmount / CASE 
						WHEN EqualPayments = 0
							THEN 0.01
						ELSE EqualPayments
						END, 3) AS MONEY)
		END
	AND CASE 
		WHEN S.CreditPlanType = '16'
			THEN CAST(ABS(S.EqualPaymentAmt - CASE 
							WHEN DerivedWaiveMinDue = 1
								AND (
									DATEDIFF(MONTH, S.PlanSegCreateDate, ISNULL(A.ActualDRPStartDate, S.StatementDate)) IN (
										'0'
										,'1'
										)
									OR DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.StatementDate), S.StatementDate) = 0
									)
								THEN 0
							WHEN DerivedStatus = '14'
								THEN 0
							--WHEN S.BeginningBalance + S.CurrentBalance + S.CurrentBalanceCO = 0
							--	THEN 0
							--WHEN InadverantCreditHold = 1
							--	AND ISNULL(S.CreditBalanceMovement, 0) <> 0
							--	AND CAST(ROUND(S.OriginalPurchaseAmount / CASE 
							--			WHEN EqualPayments = 0
							--				THEN 0.01
							--			ELSE EqualPayments
							--			END, 3) AS MONEY) - ISNULL(S.CreditBalanceMovement, 0) <= 0
							--	THEN 0
							ELSE CAST(ROUND(S.OriginalPurchaseAmount / CASE 
											WHEN EqualPayments = 0
												THEN 0.01
											ELSE EqualPayments
											END, 3) AS MONEY)
							END) AS MONEY)
		END > 0.01
	AND ABS(S.EqualPaymentAmt - (
			CASE 
				WHEN DerivedWaiveMinDue = 1
					AND (
						DATEDIFF(MONTH, S.PlanSegCreateDate, ISNULL(A.ActualDRPStartDate, S.StatementDate)) IN (
							'0'
							,'1'
							)
						OR DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.StatementDate), S.StatementDate) = 0
						)
					THEN 0
				WHEN DerivedStatus = '14'
					THEN 0
				--WHEN S.BeginningBalance + S.CurrentBalance + S.CurrentBalanceCO = 0
				--	THEN 0
				--WHEN InadverantCreditHold = 1
				--				AND ISNULL(S.CreditBalanceMovement, 0) <> 0
				--				AND CAST(ROUND(S.OriginalPurchaseAmount / CASE 
				--						WHEN EqualPayments = 0
				--							THEN 0.01
				--						ELSE EqualPayments
				--						END, 3) AS MONEY) - ISNULL(S.CreditBalanceMovement, 0) <= 0
				--				THEN 0
				ELSE CAST(ROUND(S.OriginalPurchaseAmount / (
								CASE 
									WHEN EqualPayments = 0
										THEN 0.01
									ELSE EqualPayments
									END
								), 3) AS MONEY)
				END
			)) <> P.OriginalEqualPaymentAmt
	AND S.BeginningBalance <> S.AmountofCreditsCTD

--AND DerivedWaiveMinDue <> 1
IF OBJECT_ID('tempdb.dbo.#t_Audit__FinalInstallmentDueDateIncorrect') IS NULL
	CREATE TABLE [dbo].[#t_Audit__FinalInstallmentDueDateIncorrect] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[CreditPlanType] [int] NULL
		,[CreditPlanTypeDesc] [varchar](50) NULL
		,[CPSID] [int] NULL
		,[CycleDueDTD] [int] NULL
		,[OriginalPurchaseAmount] [money] NULL
		,[EqualPayments] [int] NULL
		,[EqualPaymentAmt] [money] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDueCC1] [money] NULL
		,[CurrentBalance] [money] NULL
		,[AmtofPayXDLate] [money] NULL
		,[DateofTotalDue] [datetime] NULL
		,[PayOffDate] [datetime] NULL
		,[LoanEndDate] [datetime] NULL
		,[ActualDRPStartDate] [datetime] NULL
		)

INSERT INTO #t_Audit__FinalInstallmentDueDateIncorrect (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,CreditPlanType
	,CreditPlanTypeDesc
	,CPSID
	,CycleDueDTD
	,OriginalPurchaseAmount
	,EqualPayments
	,EqualPaymentAmt
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,SRBWithInstallmentDueCC1
	,CurrentBalance
	,AmtofPayXDLate
	,DateofTotalDue
	,PayOffDate
	,LoanEndDate
	,ActualDRPStartDate
	)
SELECT 'Q3-Final Installment Due Date Incorrect' Query, ABS(DATEDIFF(MONTH, SH.PayOffDate, ISNULL(A.ActualDRPStartDate, SH.PayOffDate)))
	,SH.AcctID
	,SH.AccountNumber
	,SH.StatementID
	,SH.StatementDate
	,SH.CreditPlanType
	,SH.CreditPlanTypeDesc
	,SH.CPSID
	,SH.CycleDueDTD
	,SH.OriginalPurchaseAmount
	,SH.EqualPayments
	,SH.EqualPaymentAmt
	,SH.SBWithInstallmentDue
	,SH.SRBWithInstallmentDue
	,SH.SRBWithInstallmentDueCC1
	,SH.CurrentBalance
	,SH.AmtofPayXDLate
	,SH.DateofTotalDue
	,SH.PayOffDate
	,SH.LoanEndDate
	,A.ActualDRPStartDate
FROM #SH SH
JOIN #EODAccounts A ON A.BSAcctID = SH.AcctID
	AND A.BusinessDay = SH.StatementDate
WHERE SH.CycleDueDTD > 0
	AND SH.CurrentBalance <> 0
	AND SH.CurrentBalance = SH.SRBWithInstallmentDue
	AND SH.CurrentBalance <> SH.AmtofPayXDLate
	AND SH.PayOffDate <> SH.DateofTotalDue
	AND ABS(DATEDIFF(MONTH, SH.PayOffDate, ISNULL(A.ActualDRPStartDate, SH.PayOffDate))) <> 1

--ORDER BY PayOffDate
--	,AcctID
--	,CPSID
--select * from #EODAccounts where BSAcctID=420417
IF OBJECT_ID('tempdb.dbo.#t_Audit__SRBWithInstallmentDue_Balance_Incorrect') IS NULL
	CREATE TABLE [dbo].[#t_Audit__SRBWithInstallmentDue_Balance_Incorrect] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[DateOfDelinquency] [datetime] NULL
		,[DateOfOriginalPaymentDueDTD] [datetime] NULL
		,[CreditPlanType] [int] NULL
		,[CreditPlanTypeDesc] [varchar](50) NULL
		,[CPSID] [int] NULL
		,[CycleDueDTD] [int] NULL
		,[OriginalPurchaseAmount] [money] NULL
		,[EqualPayments] [int] NULL
		,[EqualPaymentAmt] [money] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[CalcSRBwInstallmentDue] [money] NULL
		,[SRBWithInstallmentDueCC1] [money] NULL
		,[CurrentDue] [money] NULL
		,[CreditBalanceMovement] [money] NULL
		,[DateOfTotalDue] [datetime] NULL
		,[PayOffDate] [datetime] NULL
		,[LoanEndDate] [datetime] NULL
		,[BeginningBalance] [money] NULL
		,[AmountofDebitsCTD] [money] NULL
		,[AmountofDebitsRevCTD] [money] NULL
		,[AmountofCreditsCTD] [money] NULL
		,[AmountOfCreditsRevCTD] [money] NULL
		,[AmountofPaymentsCTD] [money] NULL
		,[A_AmountOfReturnsCTD] [money] NULL
		,[AmtInterestCreditsCTD] [money] NULL
		,[CurrentBalance] [money] NULL
		,[CurrentBalanceCO] [money] NULL
		,[AmtOfPayXDLate] [money] NULL
		,[PriorStmtPastDue] [money] NULL
		,[PriorStmtPlanTotalDue] [money] NULL
		,[PlanTotalDue] [money] NULL
		,[AcctTotalDue] [money] NULL
		,[StHdCurrentBal] [money] NULL
		,[CardAcceptorNameLocation] [varchar](100) NULL
		,[ManualStatus] [int] NULL
		,[SystemStatus] [int] NULL
		,[DerivedStatus] [int] NULL
		,[MerchantStatusDescription] [varchar](100) NULL
		,[DerivedWaiveMinDue] [varchar](5) NULL
		,[DerivedWaiveMinDueFor] [varchar](2) NULL
		,[DerivedWaiveMinDueFrom] [varchar](1) NULL
		,[AppWaiveMinDue] [int] NULL
		,[PlanSegCreateDate] [datetime] NULL
		,[ActualDRPStartDate] [datetime] NULL
		,[BusinessDay] [datetime] NULL
		,[PriorManualStatus] [int] NULL
		,[PriorSystemStatus] [int] NULL
		,[AmountOfPayment30DLate] [money] NULL
		,[AmountOfPayment60DLate] [money] NULL
		,[AmountOfPayment90DLate] [money] NULL
		,[AmountOfPayment120DLate] [money] NULL
		,[AmountOfPayment150DLate] [money] NULL
		,[AmountOfPayment180DLate] [money] NULL
		,[AmountOfPayment210DLate] [money] NULL
		,[InadverantCreditHold] [varchar](5) NULL
		,[MergeSRBWithInstallmentDueCC1] [money] NULL
		,[MergeBeginningBalance] [money] NULL
		,[MergeCycle] [int] NULL
		,[MergeDate] [datetime] NULL
		)

INSERT INTO #t_Audit__SRBWithInstallmentDue_Balance_Incorrect (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,DateOfDelinquency
	,DateOfOriginalPaymentDueDTD
	,CreditPlanType
	,CreditPlanTypeDesc
	,CPSID
	,CycleDueDTD
	,OriginalPurchaseAmount
	,EqualPayments
	,EqualPaymentAmt
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,CalcSRBwInstallmentDue
	,SRBWithInstallmentDueCC1
	,CurrentDue
	,CreditBalanceMovement
	,DateOFTotalDue
	,PayOffDate
	,LoanEndDate
	,BeginningBalance
	,AmountofDebitsCTD
	,AmountofDebitsRevCTD
	,AmountofCreditsCTD
	,AmountOfCreditsRevCTD
	,AmountofPaymentsCTD
	,A_AmountOfReturnsCTD
	,AmtInterestCreditsCTD
	,CurrentBalance
	,CurrentBalanceCO
	,AmtOfPayXDLate
	,PriorStmtPastDue
	,PriorStmtPlanTotalDue
	,PlanTotalDue
	,AcctTotalDue
	,StHdCurrentBal
	,CardAcceptorNameLocation
	,ManualStatus
	,SystemStatus
	,DerivedStatus
	,MerchantStatusDescription
	,DerivedWaiveMinDue
	,DerivedWaiveMinDueFor
	,DerivedWaiveMinDueFrom
	,AppWaiveMinDue
	,PlanSegCreateDate
	,ActualDRPStartDate
	,BusinessDay
	,PriorManualStatus
	,PriorSystemStatus
	,AmountOfPayment30DLate
	,AmountOfPayment60DLate
	,AmountOfPayment90DLate
	,AmountOfPayment120DLate
	,AmountOfPayment150DLate
	,AmountOfPayment180DLate
	,AmountOfPayment210DLate
	,InadverantCreditHold
	,MergeSRBWithInstallmentDueCC1
	,MergeBeginningBalance
	,MergeCycle
	,MergeDate
	)
SELECT 'Q4-SRBWithInstallmentDue Balance Incorrect' Query
	,SH.AcctID
	,SH.AccountNumber
	,SH.StatementID
	,SH.StatementDate
	,A.DateOfDelinquency
	,A.DateOfOriginalPaymentDueDTD
	,SH.CreditPlanType
	,SH.CreditPlanTypeDesc
	,SH.CPSID
	,SH.CycleDueDTD
	,SH.OriginalPurchaseAmount
	,SH.EqualPayments
	,SH.EqualPaymentAmt
	,SH.SBWithInstallmentDue
	,SH.SRBWithInstallmentDue
	,CASE 
		WHEN CreditPlanType <> '16'
			THEN CASE 
					WHEN SH.CurrentBalanceCO > 0
						THEN SH.CurrentBalanceCO
					WHEN EqualPaymentAmt + ISNULL(SH.SRBWithInstallmentDueCC1, 0) >= SH.CurrentBalance + SH.CurrentBalanceCO
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
					ELSE SH.CurrentBalance + SH.CurrentBalanceCO
					END
		WHEN CreditPlanType = '16'
			THEN CASE 
					WHEN DerivedWaiveMinDue = 1
						AND DerivedStatus <> '14'
						AND (
							DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.BusinessDay), SH.StatementDate) < DerivedWaiveMinDueFor
							OR DerivedWaiveMinDueFor = 0
							)
						--AND DATEDIFF(MONTH, SH.StatementDate, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate)) < DerivedWaiveMinDueFor
						THEN CASE 
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.StatementDate), SH.StatementDate) = 0
									AND PriorStmtPlanTotalDue = 0
									AND AmountofCreditsCTD + AmountofPaymentsCTD = 0
									THEN 0
								WHEN AmountofPaymentsCTD <> 0
									AND AmountofCreditsRevCTD = 0
									AND PriorStmtPastDue + PriorStmtPlanTotalDue <> 0
									THEN PriorStmtPlanTotalDue - AmountofPaymentsCTD
								WHEN CycleDueDTD = 1
									AND PriorStmtPlanTotalDue <> 0
									AND SH.CurrentBalance + SH.CurrentBalanceCO > PriorStmtPlanTotalDue
									AND (
										AmountOfCreditsCTD - AmountOfCreditsRevCTD = A_AmountOfReturnsCTD
										OR AmountOfCreditsCTD - AmountOfCreditsRevCTD <> AmountofPaymentsCTD
										)
									AND AmountofPaymentsCTD = 0 --Add 3/18/2021
									THEN PriorStmtPlanTotalDue
								WHEN CycleDueDTD = 1
									AND PriorStmtPlanTotalDue <> 0
									AND SH.CurrentBalance + SH.CurrentBalanceCO <= PriorStmtPlanTotalDue
									AND AmountofCreditsCTD = 0
									THEN SH.CurrentBalance + SH.CurrentBalanceCO
								WHEN A_AmountofReturnsCTD <> 0
									AND (
										SH.BeginningBalance = A_AmountofReturnsCTD
										OR SH.BeginningBalance = AmountofCreditsCTD
										)
									THEN 0
								WHEN A_AmountofReturnsCTD = 0
									AND (
										AmountofCreditsCTD - AmountofCreditsRevCTD >= ISNULL(SH.SRBWithInstallmentDueCC1, 0)
										OR SH.CurrentBalance + SH.CurrentBalanceCO = 0
										)
									THEN 0
								WHEN AmountofCreditsCTD = AmountofPaymentsCTD
									AND (AmountofCreditsCTD - AmountofCreditsRevCTD) <= 0
									AND DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) <> 0
									THEN EqualPaymentAmt * CycleDueDTD
								WHEN AmountofCreditsCTD - AmountofCreditsRevCTD < ISNULL(SH.SRBWithInstallmentDueCC1, 0)
									AND AmountofCreditsRevCTD <= EqualPaymentAmt
									THEN ISNULL(SH.SRBWithInstallmentDueCC1, 0) - AmountofCreditsCTD + AmountofCreditsRevCTD
							
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) = 0
									AND AmountofPaymentsCTD <> 0
									AND PriorStmtPlanTotalDue <> 0
									THEN PriorStmtPlanTotalDue - AmountofPaymentsCTD
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) = 0
									AND AmountofCreditsCTD + AmountofPaymentsCTD = 0
									AND AmountofCreditsRevCTD > 0
									THEN EqualPaymentAmt * CycleDueDTD
								ELSE ISNULL(SH.SRBWithInstallmentDueCC1, 0)
								END
					WHEN SH.CurrentBalance + SH.CurrentBalanceCO <= 0
						THEN 0
					WHEN SH.CurrentBalanceCO > 0
						THEN SH.CurrentBalanceCO
							--Add 3/18/2021 BeginningBalance condition
					WHEN CycleDueDTD = 1
						AND EqualPaymentAmt >= SH.CurrentBalance + SH.CurrentBalanceCO
						AND EqualPaymentAmt >= SH.BeginningBalance
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
					WHEN CycleDueDTD > 1
						AND PriorStmtPlanTotalDue < EqualPaymentAmt
						AND EqualPaymentAmt * CycleDueDTD >= SH.CurrentBalance + SH.CurrentBalanceCO
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN CreditBalanceMovement = 0
						AND SH.PriorStmtPlanTotalDue = SH.CurrentBalance + SH.CurrentBalanceCO
						AND SH.AmountofPaymentsCTD < SH.PriorStmtPlanTotalDue
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN DATEDIFF(MONTH, SH.StatementDate, SH.PayOffDate) <= 1
						AND (SH.CurrentBalance + SH.CurrentBalanceCO) - SH.EqualPaymentAmt <= 1
						--AND (SH.CurrentBalance + SH.CurrentBalanceCO) <= EqualPaymentAmt
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN PriorSystemStatus = 14
						THEN SH.CurrentBalance
							---------------------------------------------------------------------------------
							--Added 3/18/2021
					WHEN --PriorStmtPlanTotalDue <> 0
						CreditBalanceMovement <> 0
						THEN CASE 
								WHEN AmountofPaymentsCTD - AmountofCreditsRevCTD >= PriorStmtPlanTotalDue
									THEN EqualPaymentAmt - CreditBalanceMovement
								WHEN AmountofCreditsRevCTD - AmountofPaymentsCTD >= PriorStmtPlanTotalDue
									THEN EqualPaymentAmt - CreditBalanceMovement
								WHEN (CreditBalanceMovement + AmountofPaymentsCTD - AmountofCreditsRevCTD) - PriorStmtPlanTotalDue >= 0
									AND AmountofPaymentsCTD <> PriorStmtPlanTotalDue
									THEN (EqualPaymentAmt + PriorStmtPlanTotalDue) - (CreditBalanceMovement + AmountofPaymentsCTD)
								WHEN (CreditBalanceMovement + AmountofPaymentsCTD - AmountofCreditsRevCTD) - PriorStmtPlanTotalDue >= 0
									AND AmountofPaymentsCTD = PriorStmtPlanTotalDue
									THEN (EqualPaymentAmt + PriorStmtPlanTotalDue) - CreditBalanceMovement
								END
							---------------------------------------------------------------------------------
					WHEN CycleDueDTD <= 1
						AND (
							(
								AmountofDebitsRevCTD = AmountofDebitsCTD
								AND AmountOfDebitsRevCTD + AmountofDebitsCTD <> 0
								)
							OR AmountofDebitsRevCTD >= SH.BeginningBalance
							)
						AND SH.CurrentBalance + SH.CurrentBalanceCO > 1
						THEN EqualPaymentAmt
							---------------------------------------------------------------------------------
					WHEN CycleDueDTD > 1
						AND AmountofCreditsRevCTD - AmountofCreditsCTD >= EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt * CycleDueDTD
							---------------------------------------------------------------------------------
					WHEN AmountofCreditsRevCTD - AmountofCreditsCTD >= EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
							--------------------------------------------------------------------------------
							--Remove 3/18/2021. Fixed AcctID 238879
							--WHEN AmountofCreditsCTD > 0
							--	AND AmountofPaymentsCTD = 0
							--	AND PriorStmtPastDue + PriorStmtPlanTotalDue <> 0
							--	THEN EqualPaymentAmt * CycleDueDTD
							----------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD = AmountofPaymentsCTD
						AND AmountofPaymentsCTD < PriorStmtPlanTotalDue
						THEN PriorStmtPlanTotalDue - (AmountofPaymentsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							----------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD = AmountofPaymentsCTD
						AND AmountofPaymentsCTD = PriorStmtPastDue
						AND PriorStmtPastDue <> 0
						THEN EqualPaymentAmt * CycleDueDTD
							--------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD > 0
						AND AmountofPaymentsCTD > 0
						AND AmountofPaymentsCTD < PriorStmtPlanTotalDue
						THEN PriorStmtPlanTotalDue - (AmountofPaymentsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN ISNULL(AmtOfPayXDLate, 0) <> 0
						AND A_AmountofReturnsCTD = 0
						THEN ISNULL(SRBwithInstallmentDueCC1, 0) - (AmountofCreditsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN ISNULL(AmtOfPayXDLate, 0) <> 0
						AND A_AmountofReturnsCTD <> 0
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt * CycleDueDTD
							--------------------------------------------------------------------------------
					WHEN AmountofPaymentsCTD = PriorStmtPlanTotalDue
						THEN EqualPaymentAmt * CycleDueDTD
							--Remove 3/18/2021. Fixed AcctID 238879
							--WHEN AmountofCreditsCTD - AmountofCreditsRevCTD >= ISNULL(SRBwithInstallmentDueCC1, 0)
							--THEN EqualPaymentAmt
							--Add 3/18/2021.
					WHEN ISNULL(CreditBalanceMovement, 0) = 0
						AND (AmountofCreditsCTD + AmountofPaymentsCTD) - AmountofCreditsRevCTD >= ISNULL(SRBwithInstallmentDueCC1, 0)
						THEN EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN CycleDueDTD > 1
						AND AmountofCreditsCTD - AmountofCreditsRevCTD < EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD <> AmountofCreditsCTD
						THEN EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0) - (AmountofCreditsCTD - AmountofCreditsRevCTD)
					ELSE EqualPaymentAmt * CycleDueDTD
					END
		END CalcSRBwInstallmentDue
	,SH.SRBWithInstallmentDueCC1
	,SH.CurrentDue
	,ISNULL(SH.CreditBalanceMovement, 0) CreditBalanceMovement
	,SH.DateOfTotalDue
	,SH.PayOffDate
	,SH.LoanEndDate
	,SH.BeginningBalance
	,AmountofDebitsCTD
	,AmountofDebitsRevCTD
	,AmountofCreditsCTD
	,AmountOfCreditsRevCTD
	,AmountofPaymentsCTD
	,A_AmountOfReturnsCTD
	,SH.AmtInterestCreditsCTD
	,SH.CurrentBalance
	,SH.CurrentBalanceCO
	,SH.AmtOfPayXDLate
	,PriorStmtPastDue
	,PriorStmtPlanTotalDue
	,PlanTotalDue
	,AcctTotalDue
	,StHdCurrentBal
	,CardAcceptorNameLocation
	,ManualStatus
	,SH.SystemStatus
	,DerivedStatus
	,M.MerchantStatusDescription
	,DerivedWaiveMinDue
	,DerivedWaiveMinDueFor
	,DerivedWaiveMinDueFrom
	,AppWaiveMinDue
	,SH.PlanSegCreateDate
	,A.ActualDRPStartDate
	,S.BusinessDay
	,PriorManualStatus
	,PriorSystemStatus
	,SH.AmountOfPayment30DLate
	,SH.AmountOfPayment60DLate
	,SH.AmountOfPayment90DLate
	,SH.AmountOfPayment120DLate
	,SH.AmountOfPayment150DLate
	,SH.AmountOfPayment180DLate
	,SH.AmountOfPayment210DLate
	,SH.InadverantCreditHold
	,SH.MergeSRBWithInstallmentDueCC1
	,SH.MergeBeginningBalance
	,SH.MergeCycle
	,SH.MergeDate
--INTO #SRBCalc
FROM #SH SH
LEFT OUTER JOIN #StatusChange S ON SH.AcctID = S.AID
JOIN #EODAccounts A ON A.BSAcctID = SH.AcctID
	AND A.BusinessDay = SH.StatementDate
JOIN #MerchantStatusSetup M ON M.MerchantMerchantAID = SH.MerchantAID
	AND M.OrigStatusAcctID = SH.DerivedStatus
WHERE --CycleDueDTD > 1
	--SH.AccountNumber = --'1100011116809538'
	--	'1100011145319897' and 
	--AcctID IN (5894)--, 4897650) --1678985
	--CPSID in (26016718), 14233592, 15324010)
	(
		CASE 
			WHEN CreditPlanType <> '16'
				THEN SH.SRBWithInstallmentDue
			END <> SH.CurrentBalance + SH.CurrentBalanceCO
		OR CASE 
			WHEN CreditPlanType = '16'
				THEN SH.SRBWithInstallmentDue
			END <> CASE 
			WHEN DerivedWaiveMinDue = 1
						AND DerivedStatus <> '14'
						AND (
							DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, S.BusinessDay), SH.StatementDate) < DerivedWaiveMinDueFor
							OR DerivedWaiveMinDueFor = 0
							)
						--AND DATEDIFF(MONTH, SH.StatementDate, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate)) < DerivedWaiveMinDueFor
						THEN CASE 
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.StatementDate), SH.StatementDate) = 0
									AND PriorStmtPlanTotalDue = 0
									AND AmountofCreditsCTD + AmountofPaymentsCTD = 0
									THEN 0
								WHEN AmountofPaymentsCTD <> 0
									AND AmountofCreditsRevCTD = 0
									AND PriorStmtPastDue + PriorStmtPlanTotalDue <> 0
									THEN PriorStmtPlanTotalDue - AmountofPaymentsCTD
								WHEN CycleDueDTD = 1
									AND PriorStmtPlanTotalDue <> 0
									AND SH.CurrentBalance + SH.CurrentBalanceCO > PriorStmtPlanTotalDue
									AND (
										AmountOfCreditsCTD - AmountOfCreditsRevCTD = A_AmountOfReturnsCTD
										OR AmountOfCreditsCTD - AmountOfCreditsRevCTD <> AmountofPaymentsCTD
										)
									AND AmountofPaymentsCTD = 0 --Add 3/18/2021
									THEN PriorStmtPlanTotalDue
								WHEN CycleDueDTD = 1
									AND PriorStmtPlanTotalDue <> 0
									AND SH.CurrentBalance + SH.CurrentBalanceCO <= PriorStmtPlanTotalDue
									AND AmountofCreditsCTD = 0
									THEN SH.CurrentBalance + SH.CurrentBalanceCO
								WHEN A_AmountofReturnsCTD <> 0
									AND (
										SH.BeginningBalance = A_AmountofReturnsCTD
										OR SH.BeginningBalance = AmountofCreditsCTD
										)
									THEN 0
								WHEN A_AmountofReturnsCTD = 0
									AND (
										AmountofCreditsCTD - AmountofCreditsRevCTD >= ISNULL(SH.SRBWithInstallmentDueCC1, 0)
										OR SH.CurrentBalance + SH.CurrentBalanceCO = 0
										)
									THEN 0
								WHEN AmountofCreditsCTD = AmountofPaymentsCTD
									AND (AmountofCreditsCTD - AmountofCreditsRevCTD) <= 0
									AND DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) <> 0
									THEN EqualPaymentAmt * CycleDueDTD
								WHEN AmountofCreditsCTD - AmountofCreditsRevCTD < ISNULL(SH.SRBWithInstallmentDueCC1, 0)
									AND AmountofCreditsRevCTD <= EqualPaymentAmt
									THEN ISNULL(SH.SRBWithInstallmentDueCC1, 0) - AmountofCreditsCTD + AmountofCreditsRevCTD
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) = 0
									AND AmountofPaymentsCTD <> 0
									AND PriorStmtPlanTotalDue <> 0
									THEN PriorStmtPlanTotalDue - AmountofPaymentsCTD
								WHEN DATEDIFF(MONTH, ISNULL(A.ActualDRPStartDate, SH.PlanSegCreateDate), SH.StatementDate) = 0
									AND AmountofCreditsCTD + AmountofPaymentsCTD = 0
									AND AmountofCreditsRevCTD > 0
									THEN EqualPaymentAmt * CycleDueDTD
								ELSE ISNULL(SH.SRBWithInstallmentDueCC1, 0)
								END
					WHEN SH.CurrentBalance + SH.CurrentBalanceCO <= 0
						THEN 0
					WHEN SH.CurrentBalanceCO > 0
						THEN SH.CurrentBalanceCO
							--Add 3/18/2021 BeginningBalance condition
					WHEN CycleDueDTD = 1
						AND EqualPaymentAmt >= SH.CurrentBalance + SH.CurrentBalanceCO
						AND EqualPaymentAmt >= SH.BeginningBalance
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
					WHEN CycleDueDTD > 1
						AND PriorStmtPlanTotalDue < EqualPaymentAmt
						AND EqualPaymentAmt * CycleDueDTD >= SH.CurrentBalance + SH.CurrentBalanceCO
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN CreditBalanceMovement = 0
						AND SH.PriorStmtPlanTotalDue = SH.CurrentBalance + SH.CurrentBalanceCO
						AND SH.AmountofPaymentsCTD < SH.PriorStmtPlanTotalDue
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN DATEDIFF(MONTH, SH.StatementDate, SH.PayOffDate) <= 1
						AND (SH.CurrentBalance + SH.CurrentBalanceCO) - SH.EqualPaymentAmt <= 1
						--AND (SH.CurrentBalance + SH.CurrentBalanceCO) <= EqualPaymentAmt
						THEN SH.CurrentBalance + SH.CurrentBalanceCO
							---------------------------------------------------------------------------------
					WHEN PriorSystemStatus = 14
						THEN SH.CurrentBalance
							---------------------------------------------------------------------------------
							--Added 3/18/2021
					WHEN --PriorStmtPlanTotalDue <> 0
						CreditBalanceMovement <> 0
						THEN CASE 
								WHEN AmountofPaymentsCTD - AmountofCreditsRevCTD >= PriorStmtPlanTotalDue
									THEN EqualPaymentAmt - CreditBalanceMovement
								WHEN AmountofCreditsRevCTD - AmountofPaymentsCTD >= PriorStmtPlanTotalDue
									THEN EqualPaymentAmt - CreditBalanceMovement
								WHEN (CreditBalanceMovement + AmountofPaymentsCTD - AmountofCreditsRevCTD) - PriorStmtPlanTotalDue >= 0
									AND AmountofPaymentsCTD <> PriorStmtPlanTotalDue
									THEN (EqualPaymentAmt + PriorStmtPlanTotalDue) - (CreditBalanceMovement + AmountofPaymentsCTD)
								WHEN (CreditBalanceMovement + AmountofPaymentsCTD - AmountofCreditsRevCTD) - PriorStmtPlanTotalDue >= 0
									AND AmountofPaymentsCTD = PriorStmtPlanTotalDue
									THEN (EqualPaymentAmt + PriorStmtPlanTotalDue) - CreditBalanceMovement
								END
							---------------------------------------------------------------------------------
					WHEN CycleDueDTD <= 1
						AND (
							(
								AmountofDebitsRevCTD = AmountofDebitsCTD
								AND AmountOfDebitsRevCTD + AmountofDebitsCTD <> 0
								)
							OR AmountofDebitsRevCTD >= SH.BeginningBalance
							)
						AND SH.CurrentBalance + SH.CurrentBalanceCO > 1
						THEN EqualPaymentAmt
							---------------------------------------------------------------------------------
					WHEN CycleDueDTD > 1
						AND AmountofCreditsRevCTD - AmountofCreditsCTD >= EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt * CycleDueDTD
							---------------------------------------------------------------------------------
					WHEN AmountofCreditsRevCTD - AmountofCreditsCTD >= EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
							--------------------------------------------------------------------------------
							--Remove 3/18/2021. Fixed AcctID 238879
							--WHEN AmountofCreditsCTD > 0
							--	AND AmountofPaymentsCTD = 0
							--	AND PriorStmtPastDue + PriorStmtPlanTotalDue <> 0
							--	THEN EqualPaymentAmt * CycleDueDTD
							----------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD = AmountofPaymentsCTD
						AND AmountofPaymentsCTD < PriorStmtPlanTotalDue
						THEN PriorStmtPlanTotalDue - (AmountofPaymentsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							----------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD = AmountofPaymentsCTD
						AND AmountofPaymentsCTD = PriorStmtPastDue
						AND PriorStmtPastDue <> 0
						THEN EqualPaymentAmt * CycleDueDTD
							--------------------------------------------------------------------------------
					WHEN AmountofCreditsCTD > 0
						AND AmountofPaymentsCTD > 0
						AND AmountofPaymentsCTD < PriorStmtPlanTotalDue
						THEN PriorStmtPlanTotalDue - (AmountofPaymentsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN ISNULL(AmtOfPayXDLate, 0) <> 0
						AND A_AmountofReturnsCTD = 0
						THEN ISNULL(SRBwithInstallmentDueCC1, 0) - (AmountofCreditsCTD - AmountofCreditsRevCTD) + EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN ISNULL(AmtOfPayXDLate, 0) <> 0
						AND A_AmountofReturnsCTD <> 0
						AND AmountofPaymentsCTD = 0
						THEN EqualPaymentAmt * CycleDueDTD
							--------------------------------------------------------------------------------
					WHEN AmountofPaymentsCTD = PriorStmtPlanTotalDue
						THEN EqualPaymentAmt * CycleDueDTD
							--Remove 3/18/2021. Fixed AcctID 238879
							--WHEN AmountofCreditsCTD - AmountofCreditsRevCTD >= ISNULL(SRBwithInstallmentDueCC1, 0)
							--THEN EqualPaymentAmt
							--Add 3/18/2021.
					WHEN ISNULL(CreditBalanceMovement, 0) = 0
						AND (AmountofCreditsCTD + AmountofPaymentsCTD) - AmountofCreditsRevCTD >= ISNULL(SRBwithInstallmentDueCC1, 0)
						THEN EqualPaymentAmt
							--------------------------------------------------------------------------------
					WHEN CycleDueDTD > 1
						AND AmountofCreditsCTD - AmountofCreditsRevCTD < EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0)
						AND AmountofPaymentsCTD <> AmountofCreditsCTD
						THEN EqualPaymentAmt + ISNULL(SRBwithInstallmentDueCC1, 0) - (AmountofCreditsCTD - AmountofCreditsRevCTD)
					ELSE EqualPaymentAmt * CycleDueDTD
					END
		)
	--+ SH.SRBWithInstallmentDueCC2 + SH.SRBWithInstallmentDueCC3 + SH.SRBWithInstallmentDueCC4 + SH.SRBWithInstallmentDueCC5
	--ORDER BY AccountNumber
	--	,CPSID
	--select * from #SRB where SRBWithInstallmentDue = 0
	--select * from #t_Audit__SRBWithInstallmentDue_Balance_Incorrect
	 
UPDATE #t_Audit__SRBWithInstallmentDue_Balance_Incorrect
SET CalcSRBwInstallmentDue = CASE 
		WHEN CalcSRBwInstallmentDue <> SRBWithInstallmentDue
			AND InadverantCreditHold = 1
			THEN CASE 
					WHEN CalcSRBwInstallmentDue < 0
						THEN 0
					WHEN StHdCurrentBal < 1
						THEN 0
					WHEN CreditBalanceMovement <> 0
						AND CalcSRBwInstallmentDue <> CurrentBalance + CurrentBalanceCO
						THEN CalcSRBwInstallmentDue - CreditBalanceMovement
					WHEN CurrentBalance - CalcSRBwInstallmentDue < 1
						AND CurrentBalance > 1
						THEN CurrentBalance
					WHEN DATEDIFF(MONTH, ISNULL(ActualDRPStartDate, PlanSegCreateDate), StatementDate) = 0
						AND AmountofDebitsRevCTD = BeginningBalance
						AND AmountofDebitsRevCTD + BeginningBalance <> 0
						THEN 0
					ELSE CalcSRBwInstallmentDue
					END
		ELSE CalcSRBwInstallmentDue
		END

--select * from #t_Audit__SRBWithInstallmentDue_Balance_Incorrect

--select * from #t_Audit__SRBWithInstallmentDue_Balance_Incorrect where CalcSRBwInstallmentDue <> SRBWithInstallmentDue order by AcctID
--select * from #SH where AcctID=13737
--select 346073
--,'1100011145319897'
--select top 10 * from #PriorSH where AccountNumber='1100011102958174'
--select manualstatus, systemstatus, cpmid, * from #SH where AccountNumber='1100001000000062'
--select EqualPaymentAmt, OrigEqualPmtAmt, * from CPSgmentCreditCard with (nolock) where EqualPaymentAmt<> OrigEqualPmtAmt--acctid=5036

IF OBJECT_ID('tempdb.dbo.#t_Audit__NULL_Merchant_Location') IS NULL
	CREATE TABLE [dbo].[#t_Audit__NULL_Merchant_Location] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[CreditPlanType] [int] NULL
		,[CreditPlanTypeDesc] [varchar](50) NULL
		,[EqualPaymentAmt] [money] NULL
		,[OriginalPurchaseAmount] [money] NULL
		,[CardAcceptorNameLocation] [varchar](100) NULL
		,[BeginningBalance] [money] NULL
		,[AmountofDebitsCTD] [money] NULL
		,[AmountofCreditsCTD] [money] NULL
		,[CurrentBalance] [money] NULL
		,[CurrentBalanceCO] [money] NULL
		,[PlanTotalDue] [money] NULL
		,[AcctTotalDue] [money] NULL
		,[CPSID] [int] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[SRBwithInstallmentDueCC1] [money] NULL
		)

INSERT INTO #t_Audit__NULL_Merchant_Location (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,CreditPlanType
	,CreditPlanTypeDesc
	,EqualPaymentAmt
	,OriginalPurchaseAmount
	,CardAcceptorNameLocation
	,BeginningBalance
	,AmountofDebitsCTD
	,AmountofCreditsCTD
	,CurrentBalance
	,CurrentBalanceCO
	,PlanTotalDue
	,AcctTotalDue
	,CPSID
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,SRBwithInstallmentDueCC1
	)
--Merchant Description
SELECT 'Q5-Merchant Name and Location IS NULL on an Installment Plan but should not' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.CreditPlanType
	,S.CreditPlanTypeDesc
	,S.EqualPaymentAmt
	,S.OriginalPurchaseAmount
	,S.CardAcceptorNameLocation
	,S.BeginningBalance
	,S.AmountofDebitsCTD
	,S.AmountofCreditsCTD
	,S.CurrentBalance
	,S.CurrentBalanceCO
	,S.PlanTotalDue
	,S.AcctTotalDue
	,S.CPSID
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,S.SRBwithInstallmentDueCC1
FROM #SH S
WHERE (
		CASE 
			WHEN S.CreditPlanType <> '16'
				THEN S.CardAcceptorNameLocation
			END IS NOT NULL
		AND CASE 
			WHEN S.CreditPlanType <> '16'
				THEN S.CardAcceptorNameLocation
			END IS NULL
		AND CASE 
			WHEN S.CreditPlanType = '16'
				THEN S.CardAcceptorNameLocation
			END IS NULL
		)

--ORDER BY AccountNumber
--	,CPSID
--EOD Table Validation
IF OBJECT_ID('tempdb.dbo.#t_Audit__EOD_Table_Validation') IS NULL
	CREATE TABLE [dbo].[#t_Audit__EOD_Table_Validation] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[StmtSBWithInstallmentDue] [money] NULL
		,[EODSBWithInstallmentDue] [money] NULL
		,[DiffSBWithInstallmentDue] [money] NULL
		,[StmtSRBWithInstallmentDue] [money] NULL
		,[EODSRBWithInstallmentDue] [money] NULL
		,[DiffSRBWithInstallmentDue] [money] NULL
		,[ID] INT IDENTITY(1, 1)
		)

INSERT INTO #t_Audit__EOD_Table_Validation (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,StmtSBWithInstallmentDue
	,EODSBWithInstallmentDue
	,DiffSBWithInstallmentDue
	,StmtSRBWithInstallmentDue
	,EODSRBWithInstallmentDue
	,DiffSRBWithInstallmentDue
	)
SELECT 'Q6-Sum of SBWithInstallmentDue/SRBWithInstallmentDue <> between Statement and EOD Account table' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,SUM(S.SBWithInstallmentDue) StmtSBWithInstallmentDue
	,E.SBWithInstallmentDue EODSBWithInstallmentDue
	,SUM(S.SBWithInstallmentDue) - E.SBWithInstallmentDue DiffSBWithInstallmentDue
	,SUM(S.SRBWithInstallmentDue) StmtSRBWithInstallmentDue
	,E.SRBWithInstallmentDue EODSRBWithInstallmentDue
	,SUM(S.SRBWithInstallmentDue) - E.SRBWithInstallmentDue DiffSRBWithInstallmentDue
FROM #SH S
JOIN #EODAccounts E ON S.AccountNumber = E.AccountNumber
--WHERE S.AccountNumber='1100011105411205'
WHERE S.CurrentBalance > 0
GROUP BY S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,E.SBWithInstallmentDue
	,E.SRBWithInstallmentDue
HAVING (
		CASE 
			WHEN SUM(S.SBWithInstallmentDue) >= 0
				THEN SUM(S.SBWithInstallmentDue)
			ELSE 0
			END <> E.SBWithInstallmentDue
		OR CASE 
			WHEN SUM(S.SRBWithInstallmentDue) >= 0
				THEN SUM(S.SRBWithInstallmentDue)
			ELSE 0
			END <> E.SRBWithInstallmentDue
		)

IF OBJECT_ID('tempdb.dbo.#t_Audit__EOD_Plan_table') IS NULL
	CREATE TABLE [dbo].#t_Audit__EOD_Plan_table (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[SBWithInstallmentDue] [money] NULL
		,[SRBWithInstallmentDue] [money] NULL
		,[EODSBWithInstallmentDue] [money] NULL
		,[EODSRBWithInstallmentDue] [money] NULL
		,[ID] INT IDENTITY(1, 1)
		)

INSERT INTO #t_Audit__EOD_Plan_table (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,SBWithInstallmentDue
	,SRBWithInstallmentDue
	,EODSBWithInstallmentDue
	,EODSRBWithInstallmentDue
	)
SELECT 'Q7-Sum of SBWithInstallmentDue/SRBWithInstallmentDue <> between Statement and EOD Plan table' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,E.SBWithInstallmentDue EODSBWithInstallmentDue
	,E.SRBWithInstallmentDue EODSRBWithInstallmentDue
FROM #SH S
JOIN #EODPlans E ON S.AccountNumber = E.AccountNumber
	AND S.CPSID = E.CPSAcctID
GROUP BY S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.SBWithInstallmentDue
	,S.SRBWithInstallmentDue
	,E.SBWithInstallmentDue
	,E.SRBWithInstallmentDue
HAVING (
		S.SBWithInstallmentDue <> E.SBWithInstallmentDue
		OR S.SRBWithInstallmentDue <> E.SRBWithInstallmentDue
		)

--select SBWithInstallmentDue, SRBWithInstallmentDue, * from #SH where AccountNumber='1100001000006010'
--select SBWithInstallmentDue, SRBWithInstallmentDue, * from #EODAccounts where AccountNumber='1100001000005020'
--select SBWithInstallmentDue, SRBWithInstallmentDue, * from #EODPlans where AccountNumber='1100001120044610'
--select SRBWithInstallmentDue,	SBWithInstallmentDue,  * from planinfoforreport with (nolock) where AccountNumber='1100001120044610' and businessday = '2019-11-30 23:59:57.000'
--select SRBWithInstallmentDue,	SBWithInstallmentDue,  * from accountinfoforreport with (nolock) where AccountNumber='1100001120044610' and businessday = '2019-11-30 23:59:57.000'
IF OBJECT_ID('tempdb.dbo.#t_Audit__EOD_Account_N_Plan_Balance') IS NULL
	CREATE TABLE [dbo].[#t_Audit__EOD_Account_N_Plan_Balance] (
		[Query] [varchar](500) NOT NULL
		,[BSAcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[BusinessDay] [datetime] NOT NULL
		,[AcctCurrentBalance] [money] NULL
		,[PlanCurrentBalance] [money] NULL
		,[ID] INT IDENTITY(1, 1)
		)

INSERT INTO [#t_Audit__EOD_Account_N_Plan_Balance] (
	[Query]
	,[BSAcctID]
	,[AccountNumber]
	,[BusinessDay]
	,[AcctCurrentBalance]
	,[PlanCurrentBalance]
	)
SELECT 'Q8-EOD Account Balance = EOD Plan Balance' Query
	,A.BSAcctID
	,A.AccountNumber
	,A.BusinessDay
	,A.CurrentBalance AcctCurrentBalance
	,SUM(P.CurrentBalance) PlanCurrentBalance
FROM #EODAccounts A
JOIN #EODPlans P ON A.BSAcctID = P.BSAcctID
	AND A.BusinessDay = P.BusinessDay
--WHERE A.Accountnumber='1100001121728104'
GROUP BY A.BSAcctID
	,A.AccountNumber
	,A.BusinessDay
	,A.CurrentBalance
HAVING A.CurrentBalance <> SUM(P.CurrentBalance)

/*
select BSAcctID, AccountNumber, BusinessDay, SUM(CurrentBalance) AcctCurrentBalance from #EODAccounts where Accountnumber='1100001118787279'
group by BSAcctID, AccountNumber, BusinessDay

select  BSAcctID, AccountNumber, BusinessDay, SUM(CurrentBalance) PlanCurrentBalance from #EODPlans where Accountnumber='1100001118787279'
group by BSAcctID, AccountNumber, BusinessDay

select AcctID, AccountNumber, StatementDate, SUM(CurrentBalance) SHCurrentBalance from #SH where Accountnumber='1100001118787279'
group by AcctID, AccountNumber, StatementDate

select * from #EODAccounts where Accountnumber='1100001120044610' and businessday='2019-11-30 23:59:57.000'
select * from #EODPlans where Accountnumber='1100001120044610' and businessday='2019-11-30 23:59:57.000'
select BeginningBalance, CurrentBalance, * from #SH where Accountnumber='1100001120044610'
*/
--SELECT TOP 25 'Q9-Daily Cash Summary Section - Randomly checked PDF using records returned' Query
--	,L.AcctID
--	,L.AccountNumber
--	,L.StatementID
--	,L.StatementDate
--	,M.TxnSource
--	,M.TransactionAmount
--	,CAST(ROUND(L.TransactionAmount * 0.01, 2) AS MONEY) DailyCash
--FROM #LoyaltyTrans L
--JOIN #MonetaryTrans M ON L.TranOrig = M.TranID
--WHERE L.CmtTranType = '601'
--	AND M.TxnSource IN (
--		'29'
--		,'39'
--		)
----AND L.AccountNumber='1100000100200010'
--ORDER BY L.AccountNumber
--select * from #LoyaltyTrans where AccountNumber='1100000100200010'
--select * from #MonetaryTrans M where AccountNumber='1100000100200010'
--and TranID NOT IN (select TranOrig from #LoyaltyTrans L where L.AccountNumber = M.AccountNumber)
--select * from #MonetaryTrans M where TranID NOT IN (select TranOrig from #LoyaltyTrans L where L.AccountNumber = M.AccountNumber)
--select SRBwithInstallmentDueCC1, * from #SH where AccountNumber='1100000100200010'
--select EqualPaymentAmt, * FROM #PriorSH
--WHERE AccountNumber = '1100011134783970'
--select BeginningBalance, SRBwithInstallmentDue, SRBwithInstallmentDueCC1, * FROM #SH
--WHERE AccountNumber = '1100000100200010'

IF OBJECT_ID('tempdb.dbo.#t_Audit__Account_Summary_Header') IS NULL
	CREATE TABLE [dbo].[#t_Audit__Account_Summary_Header] (
		[Query] [varchar](500) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementID] [decimal](19, 0) NULL
		,[StatementDate] [datetime] NULL
		,[DerivedStatus] [int] NULL
		,[PriorMonthlyBalancePDF] [money] NULL
		,[CalcPriorMonthlyBalance] [money] NULL
		,[CalcPriorMonthlyBalanceDiff] [money] NULL
		,[PriorTotalBalancePDF] [money] NULL
		,[CalcPriorTotalBalance] [money] NULL
		,[CalcPriorTotalBalanceDiff] [money] NULL
		,[AcctSRBWithInstallmentDue] [money] NULL
		,[CalcMonthlyBalance] [money] NULL
		,[CalcMonthlyBalanceDiff] [money] NULL
		,[CreditBalanceMovement] [money] NULL
		,[ID] INT IDENTITY(1, 1)
		)

INSERT INTO #t_Audit__Account_Summary_Header (
	Query
	,AcctID
	,AccountNumber
	,StatementID
	,StatementDate
	,DerivedStatus
	,PriorMonthlyBalancePDF
	,CalcPriorMonthlyBalance
	,CalcPriorMonthlyBalanceDiff
	,PriorTotalBalancePDF
	,CalcPriorTotalBalance
	,CalcPriorTotalBalanceDiff
	,AcctSRBWithInstallmentDue
	,CalcMonthlyBalance
	,CalcMonthlyBalanceDiff
	,CreditBalanceMovement
	)
SELECT 'Q10-Prior Monthly Balance, Prior Total Balance in Account Summary (Header) Section Incorrect' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.DerivedStatus
	,CASE 
		WHEN SUM(S.SRBwithInstallmentDueCC1) <= 0
			THEN 0
		ELSE SUM(S.SRBwithInstallmentDueCC1)
		END PriorMonthlyBalancePDF
	,CASE 
		WHEN SUM(ISNULL(P.EqualPaymentAmt, 0)) <= 0
			THEN 0
		ELSE SUM(ISNULL(P.EqualPaymentAmt, 0))
		END CalcPriorMonthlyBalance
	,CASE 
		WHEN SUM(S.SRBwithInstallmentDueCC1) <= 0
			THEN 0
		ELSE SUM(S.SRBwithInstallmentDueCC1)
		END - CASE 
		WHEN SUM(ISNULL(P.EqualPaymentAmt, 0)) <= 0
			THEN 0
		ELSE SUM(ISNULL(P.EqualPaymentAmt, 0))
		END CalcPriorMonthlyBalanceDiff
	,SUM(S.BeginningBalance) PriorTotalBalancePDF
	,SUM(ISNULL(P.CurrentBalance + P.CurrentBalanceCO, 0)) CalcPriorTotalBalance
	,SUM(S.BeginningBalance) - SUM(ISNULL(P.CurrentBalance, 0)) CalcPriorTotalBalanceDiff
	,S.AcctSRBWithInstallmentDue
	,CASE 
		WHEN SUM(S.SRBwithInstallmentDue) <= 0
			THEN 0
		ELSE SUM(S.SRBwithInstallmentDue)
		END CalcMonthlyBalance
	,S.AcctSRBWithInstallmentDue - CASE 
		WHEN SUM(S.SRBwithInstallmentDue) <= 0
			THEN 0
		ELSE SUM(S.SRBwithInstallmentDue)
		END CalcMonthlyBalanceDiff
	,S.CreditBalanceMovement
FROM #SH S
LEFT OUTER JOIN #PriorSH P ON S.AccountNumber = P.AccountNumber
	AND S.CPSID = P.CPSID
--WHERE S.AccountNumber = '1100011105444933'
WHERE S.AcctID=7093
--WHERE S.CurrentBalance > 0
GROUP BY S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,S.DerivedStatus
	,S.AcctSRBWithInstallmentDue
	,S.CreditBalanceMovement
HAVING (
		CASE 
			WHEN SUM(S.SRBwithInstallmentDueCC1) <= 0
				THEN 0
			ELSE SUM(S.SRBwithInstallmentDueCC1)
			END <> CASE 
			WHEN SUM(ISNULL(P.EqualPaymentAmt, 0)) <= 0
				THEN 0
			ELSE SUM(ISNULL(P.EqualPaymentAmt, 0))
			END
		OR SUM(S.BeginningBalance) <> SUM(ISNULL(P.CurrentBalance + P.CurrentBalanceCO, 0))
		OR S.AcctSRBWithInstallmentDue <> CASE 
			WHEN SUM(S.SRBwithInstallmentDue) <= 0
				THEN 0
			ELSE SUM(S.SRBwithInstallmentDue)
			END
		)

		/*
UPDATE #t_Audit__Account_Summary_Header set CalcPriorMonthlyBalance = CASE WHEN CalcPriorMonthlyBalanceDiff <> 0
																	AND ISNULL(CreditBalanceMovement, 0) <> 0
																THEN CalcPriorMonthlyBalance - ISNULL(CreditBalanceMovement, 0)
																ELSE CalcPriorMonthlyBalance
																END

																select * from #t_Audit__Account_Summary_Header where AcctID=7093*/
/* 
select * from #SHAB where AccounTNumber='1100011128250127'
select * from #SHAB where BAcctID=4232553
select EqualPaymentAmt,  * from #PriorSH where AccounTNumber='1100000100213344'
select EqualPaymentAmt, SRBwithInstallmentDue, SRBwithInstallmentDueCC1, CurrentBalance, CycleDueDTD, * from #SH where AccounTNumber='1100011116789011'

SELECT TOP 25 'Q11-Installment Summary Section - Randomly checked PDF using records returned' Query
	,S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
	,SUM(S.OriginalPurchaseAmount) TotalFinanced
	,SUM(S.AmountofPaymentsLTD) + SUM(S.AmountofReturnsLTD) TotalPaymentsCredits
	,SUM(S.OriginalPurchaseAmount) - SUM(S.AmountofPaymentsLTD) - SUM(S.AmountofReturnsLTD) TotalRemaining
	,SUM(S.OriginalPurchaseAmount) - (SUM(S.AmountofPaymentsLTD) + SUM(S.AmountofReturnsLTD)) - (SUM(S.OriginalPurchaseAmount) - SUM(S.AmountofPaymentsLTD) - SUM(S.AmountofReturnsLTD)) Diff
FROM #SH S
WHERE --S.AccountNumber = '1100011127471690' and
	S.CreditPlanType = '16'
GROUP BY S.AcctID
	,S.AccountNumber
	,S.StatementID
	,S.StatementDate
--HAVING SUM(S.OriginalPurchaseAmount) - (SUM(S.AmountofPaymentsLTD) + SUM(S.AmountofReturnsLTD)) <> SUM(S.OriginalPurchaseAmount) - SUM(S.AmountofPaymentsLTD) - SUM(S.AmountofReturnsLTD)
*/
IF OBJECT_ID('tempdb.dbo.#t_Audit__Installment_Summary') IS NULL
	CREATE TABLE [dbo].[#t_Audit__Installment_Summary] (
		[Query] [varchar](101) NOT NULL
		,[AcctID] [int] NOT NULL
		,[AccountNumber] [varchar](19) NULL
		,[StatementDate] [datetime] NULL
		,[CPSID] [int] NULL
		,[Total Financed] [money] NULL
		,[AmountofCreditsLTD] [money] NULL
		,[AmountofCreditsRevLTD] [money] NULL
		,[DisputesAmtns] [money] NULL
		,[DispRCHFavororWriteOff] [money] NULL
		,[ManualPurchaseReversal_LTD] [money] NULL
		,[Total payments and credits] [money] NULL
		,[Total Remaining] [money] NULL
		,[ActualPlanCurrentBalance] [money] NULL
		,[ActualPlanCurrentBalanceCO] [money] NULL
		,[DIFF] [money] NULL
		)

INSERT INTO #t_Audit__Installment_Summary (
	Query
	,AcctID
	,AccountNumber
	,StatementDate
	,CPSID
	,[Total Financed]
	,AmountofCreditsLTD
	,AmountofCreditsRevLTD
	,DisputesAmtns
	,DispRCHFavororWriteOff
	,ManualPurchaseReversal_LTD
	,[Total payments and credits]
	,[Total Remaining]
	,ActualPlanCurrentBalance
	,ActualPlanCurrentBalanceCO
	,DIFF
	)
SELECT 'Q12: Installment Summary Section OOB (Total Financed - Total Payments/Credits <> Total Plan Balances)' Query
	,AcctID
	,AccountNumber
	,StatementDate
	,CPSID
	,OriginalPurchaseAmount AS "Total Financed"
	--,AmountofCreditsCTD
	,AmountofCreditsLTD
	--,AmountofCreditsRevCTD
	,AmountofCreditsRevLTD
	--,AmountofPaymentsCTD
	,DisputesAmtns
	,DispRCHFavororWriteOff
	,ManualPurchaseReversal_LTD
	,(ISNULL(AmountOfCreditsLTD, 0) - ISNULL(AmountOfCreditsRevLTD, 0) + ISNULL(DisputesAmtNS, 0) + ISNULL(DispRCHFavororWriteoff, 0) + ISNULL(ManualPurchaseReversal_LTD, 0)) AS "Total payments and credits"
	,OriginalPurchaseAmount - ((ISNULL(AmountOfCreditsLTD, 0) - ISNULL(AmountOfCreditsRevLTD, 0) + ISNULL(DisputesAmtNS, 0) + ISNULL(DispRCHFavororWriteoff, 0) + ISNULL(ManualPurchaseReversal_LTD, 0))) AS "Total Remaining"
	,CurrentBalance ActualPlanCurrentBalance
	,CurrentBalanceCO ActualPlanCurrentBalanceCO
	,OriginalPurchaseAmount - (CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD, 0) - ISNULL(AmountOfCreditsRevLTD, 0)) + ISNULL(DisputesAmtNS, 0) + ISNULL(DispRCHFavororWriteoff, 0) + ISNULL(ManualPurchaseReversal_LTD, 0)) AS DIFF
FROM #SH
WHERE CreditPlanType = '16'
	--AND OriginalPurchaseAmount <> (CurrentBalance + CurrentBalanceCO + (AmountofCreditsLTD - AmountofCreditsRevLTD) + DisputesAmtns + DispRCHFavororWriteOff)
	AND OriginalPurchaseAmount <> (CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD, 0) - ISNULL(AmountOfCreditsRevLTD, 0)) + ISNULL(DisputesAmtNS, 0) + ISNULL(DispRCHFavororWriteoff, 0) + ISNULL(ManualPurchaseReversal_LTD, 0))

--ORDER BY AccountNumber
DELETE BL
FROM #TEMP_Statement_All BL
JOIN #TEMP_Statement_Loop BP ON BL.AccountNUmber = BP.AccountNUmber
WHERE BP.Processed = 0

UPDATE #TEMP_Statement_Loop
SET Processed = 1
WHERE Processed = 0

--End 
DECLARE @Processed INT
	,@Remain INT

SELECT @Processed = count(1)
FROM #TEMP_Statement_Loop
WHERE processed = 1

SELECT @Remain = count(1)
FROM #TEMP_Statement_All

IF (
		@Remain = 0
		OR @DisplayFlag = 1
		)
BEGIN
	--Count
	SELECT DISTINCT 'Total Accounts with Beekman Plans' Query
		,COUNT(AAcctID) COUNT
	FROM #t_Audit__Total_AC_BeekmanPlans

	--Q1
	SELECT *
	FROM [#t_Audit__Installment_Plan_0_Amount]
	WHERE Query LIKE 'Q1-Installment%'

	--Q1.1
	SELECT *
	FROM [#t_Audit__Installment_Plan_0_Amount]
	WHERE Query LIKE 'Q1.1%'

	--Q2
	SELECT *
	FROM [#t_Audit__EqualPaymentAmountIncorrect]
	ORDER BY AcctID

	--Q3
	SELECT *
	FROM #t_Audit__FinalInstallmentDueDateIncorrect
	ORDER BY PayOffDate
		,AcctID
		,CPSID

	--Q4
	SELECT *
	FROM [#t_Audit__SRBWithInstallmentDue_Balance_Incorrect]
	WHERE SRBWithInstallmentDue <> CalcSRBwInstallmentDue
	ORDER BY AccountNumber
		,CPSID

	--Q5
	SELECT *
	FROM [#t_Audit__NULL_Merchant_Location]
	ORDER BY AccountNumber
		,CPSID

	--Q6
	SELECT Query
		,AcctID
		,AccountNumber
		,StatementID
		,StatementDate
		,StmtSBWithInstallmentDue
		,EODSBWithInstallmentDue
		,DiffSBWithInstallmentDue
		,StmtSRBWithInstallmentDue
		,EODSRBWithInstallmentDue
		,DiffSRBWithInstallmentDue
	FROM #t_Audit__EOD_Table_Validation
	ORDER BY ID ASC

	--Q7
	SELECT Query
		,AcctID
		,AccountNumber
		,StatementID
		,StatementDate
		,SBWithInstallmentDue
		,SRBWithInstallmentDue
		,EODSBWithInstallmentDue
		,EODSRBWithInstallmentDue
	FROM #t_Audit__EOD_Plan_table
	ORDER BY ID ASC

	--Q8
	SELECT [Query]
		,[BSAcctID]
		,[AccountNumber]
		,[BusinessDay]
		,[AcctCurrentBalance]
		,[PlanCurrentBalance]
	FROM [#t_Audit__EOD_Account_N_Plan_Balance]
	ORDER BY ID ASC

	--Q10
	SELECT Query
		,AcctID
		,AccountNumber
		,StatementID
		,StatementDate
		,DerivedStatus
		,PriorMonthlyBalancePDF
		,CalcPriorMonthlyBalance
		,CalcPriorMonthlyBalanceDiff
		,PriorTotalBalancePDF
		,CalcPriorTotalBalance
		,CalcPriorTotalBalanceDiff
		,AcctSRBWithInstallmentDue
		,CalcMonthlyBalance
		,CalcMonthlyBalanceDiff
	FROM [#t_Audit__Account_Summary_Header]
	ORDER BY ID ASC

	--Q12
	SELECT Query
		,AcctID
		,AccountNumber
		,StatementDate
		,CPSID
		,[Total Financed]
		,AmountofCreditsLTD
		,AmountofCreditsRevLTD
		,DisputesAmtns
		,DispRCHFavororWriteOff
		,ManualPurchaseReversal_LTD
		,[Total payments and credits]
		,[Total Remaining]
		,ActualPlanCurrentBalance
		,ActualPlanCurrentBalanceCO
		,DIFF
	FROM [#t_Audit__Installment_Summary]
	ORDER BY AccountNumber
END

SELECT @Remain + @Processed AS TotalRecords
	,@Remain AS RemainingRecords
	,@Processed AS Processed
