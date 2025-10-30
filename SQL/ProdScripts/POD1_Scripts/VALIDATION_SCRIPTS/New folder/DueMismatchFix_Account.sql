
DECLARE @LastDay DATETIME = '2022-09-30 23:59:57' , @LastSTMTDate DATETIME = '2022-08-31 23:59:57', @Flag INT

--1 -- FILL DATA
--2 -- Calculate Data
--3 -- BS/CPS CycleDueDTD =0 fix 
--4 -- BS/CPS CycleDueDTD =1 fix 
--5 -- CBA / CBAPS Fix 

DROP TABLE IF EXISTS #CorrectionAccounts
CREATE TABLE #CorrectionAccounts (AccountID INT)

INSERT INTO #CorrectionAccounts
SELECT acctId FROM BSegment_Primary WITH (NOLOCK) WHERE acctID IN
(17026654)

SET @Flag = 3


IF @Flag = 1 
BEGIN
	DROP TABLE IF EXISTS #BSRecords
	SELECT  
	BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
	RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid, 
	CAST(0 AS MONEY) DueAdjusted_BS, CAST('CASE12345' AS VARCHAR(10)) IssueType
	INTO #BSRecords
	FROM .AccountInfoForReport AIR WITH (NOLOCK) 
	JOIN #CorrectionAccounts CA ON (AIR.BSAcctID = CA.AccountID)
	WHERE BusinessDay = @LastDay

	DROP TABLE IF EXISTS #PSRecords
	SELECT 
	PIR.CPSAcctId, PIR.BSAcctID, PIR.CycleDueDTD, PIR.AmountOfTotalDue, PIR.AmtOfPayCurrDue, PIR.AmtOfPayXDLate, PIR.AmountOfPayment30DLate, PIR.SRBWithInstallMentDue, 
	PIR.CreditPlanType, CAST(0 AS MONEY) DueAdjusted_PS, BS.IssueType
	INTO #PSRecords
	FROM .PlanInfoForReport PIR WITH (NOLOCK) 
	JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON (PIR.CPSAcctID = CPS.acctId AND PIR.BusinessDay = @LastDay)
	JOIN #BSRecords BS WITH (NOLOCK) ON (BS.BSAcctId = CPS.parent02AID)
	WHERE PIR.BusinessDay = @LastDay

	DROP TABLE IF EXISTS ##BSRecords
	SELECT * INTO ##BSRecords FROM #BSRecords

	DROP TABLE IF EXISTS #PS_BeforeFix
	SELECT * INTO #PS_BeforeFix FROM #PSRecords

	DROP TABLE IF EXISTS #BS_BeforeFix
	SELECT * INTO #BS_BeforeFix FROM #BSRecords

	DROP TABLE IF EXISTS #Accounts
	SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
	CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
	INTO #Accounts
	FROM #PSRecords
	GROUP BY BSAcctId

END


IF @Flag = 2 
BEGIN
	;WITH CTE
	AS
	(
		SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
		FROM #PSRecords I 
		WHERE CreditPlanType <> '16'
		GROUP BY BSAcctId
	)
	UPDATE A
	SET SRB_NoNRetail = I.SRBWithInstallmentDue, Due_NoNRetail = I.AmountOfTotalDue
	FROM #Accounts A
	JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

	;WITH CTE
	AS
	(
		SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
		FROM #PSRecords I 
		WHERE CreditPlanType = '16'
		GROUP BY BSAcctId
	)
	UPDATE A
	SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
	FROM #Accounts A
	JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

	UPDATE #Accounts SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

	--SELECT * FROM #Accounts

	UPDATE #PSRecords SET AmountOfTotalDue = 0, CycleDueDTD = 0 WHERE SRBWithInstallmentDue <= 0 AND AmountOfTotalDue > 0

	UPDATE  P
	SET AmountOfTotalDue = 0, CycleDueDTD = 0
	FROM #PSRecords P 
	JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
	WHERE SRB_NoNRetail = 0 And P.AmountOfTotalDue > 0

	UPDATE  P
	SET AmountOfTotalDue = SRB_NoNRetail
	FROM #PSRecords P
	JOIN #Accounts A ON (P.BSAcctid = A.BSAcctid AND P.CreditPlanType <> '16')
	WHERE SRB_NoNRetail > 0 AND SRB_NoNRetail < Due_NoNRetail AND P.AmountOfTotalDue > 0



	DROP TABLE IF EXISTS #Accounts_Fixed
	SELECT BSAcctID, SUM(AmountOfTotalDue) AmountOfTotalDue, MAX(CycleDueDTD) CycleDueDTD, CAST(0 AS MONEY) SRB_NoNRetail, CAST(0 AS MONEY) SRB_Retail, CAST(0 AS MONEY) TotalSRB,
	CAST(0 AS MONEY) Due_NoNRetail, CAST(0 AS MONEY) Due_Retail, CAST(0 AS MONEY) TotalDue
	INTO #Accounts_Fixed
	FROM #PSRecords
	GROUP BY BSAcctId


	;WITH CTE
	AS
	(
		SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
		FROM #PSRecords I 
		WHERE CreditPlanType <> '16'
		GROUP BY BSAcctId
	)
	UPDATE A
	SET SRB_NoNRetail = I.SRBWithInstallmentDue, Due_NoNRetail = I.AmountOfTotalDue
	FROM #Accounts_Fixed A
	JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

	;WITH CTE
	AS
	(
		SELECT BSAcctId, CASE WHEN SUM(SRBWithInstallmentDue) < 0 THEN 0 ELSE SUM(SRBWithInstallmentDue) END SRBWithInstallmentDue, SUM(AmountOfTotalDue) AmountOfTotalDue
		FROM #PSRecords I 
		WHERE CreditPlanType = '16'
		GROUP BY BSAcctId
	)
	UPDATE A
	SET SRB_Retail = I.SRBWithInstallmentDue, Due_Retail = I.AmountOfTotalDue
	FROM #Accounts_Fixed A
	JOIN CTE I ON (A.BSAcctId = I.BSAcctId)

	UPDATE #Accounts_Fixed SET TotalSRB = SRB_Retail + SRB_NoNRetail, TotalDue = Due_Retail + Due_NoNRetail

	--SELECT * FROM #Accounts_Fixed

	--SELECT * FROM #PSRecords
	--SELECT * FROM #PS_BeforeFix


	DROP TABLE IF EXISTS #Corrected_BS
	SELECT B2.*, B1.AmountOfTotalDue AmountOfTotalDue_OLD, B1.CycleDueDTD CycleDueDTD_OLD
	INTO #Corrected_BS
	FROM #BSRecords B1
	JOIN #Accounts_Fixed B2 ON (B1.BSacctId = B2.BSacctId)
	WHERE B1.AmountOfTotalDue <> B2.AmountOfTotalDue 

	DROP TABLE IF EXISTS #Corrected_PS
	SELECT B1.*, B2.AmountOfTotalDue AmountOfTotalDue_OLD, B2.CycleDueDTD CycleDueDTD_OLD 
	INTO #Corrected_PS
	FROM #PSRecords B1
	JOIN #PS_BeforeFix B2 ON (B1.CPSacctId = B2.CPSacctId)
	WHERE B1.AmountOfTotalDue <> B2.AmountOfTotalDue 


	--SELECT * FROM #Corrected_BS WHERE BSAcctId = 17026654

	--SELECT * FROM #Corrected_PS WHERE BSAcctId = 17026654
END


IF @Flag = 3 
BEGIN
	SELECT * , 
	'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
	'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
	RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
	DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL
	WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard
	FROM #Corrected_BS
	WHERE CycleDueDTD = 0


	SELECT * ,
	'UPDATE TOP(1) #CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = ' + TRY_CAST(CPSAcctID AS VARCHAR) CPSgmentCreditCard
	FROM #Corrected_PS
	WHERE CycleDueDTD = 0

END


-- Please update DateOfOriginalPaymentDueDTD and FirstDueDate According to STMT Date
IF @Flag = 4
BEGIN
	SELECT *, 
	'UPDATE TOP(1) #BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentPrimary,
	'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,
	RunningMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', RemainingMinimumDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + 
	', DaysDelinquent = 0, NoPayDaysDelinquent = 0, 
	DateOfOriginalPaymentDueDTD = ''2022-09-30 23:59:57'', DtOfLastDelinqCTD = NULL, FirstDueDate = ''2022-09-30 23:59:57''
	WHERE acctID = ' + TRY_CAST(BSAcctID AS VARCHAR) BSegmentCreditCard 
	FROM #Corrected_BS
	WHERE CycleDueDTD = 1



	SELECT *,
	'UPDATE TOP(1) #CPSgmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ', AmtOfPayCurrDue = ' + TRY_CAST(AmountOfTotalDue AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(CPSAcctID AS VARCHAR) CPSgmentCreditCard  
	FROM #Corrected_PS
	WHERE CycleDueDTD = 1

END


IF @Flag = 5 
BEGIN
	;WITH CTE 
	AS
	(
		SELECT C.*, A.AmountOfTotalDue, A.CycleDueDTD, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay DESC)  Ranking
		FROM CurrentBalanceAudit C WITH (NOLOCK) JOIN #Corrected_BS A ON (C.AID = A.BSAcctId AND C.ATID = 51 /*AND IssueType = 'Issue1'*/)
		WHERE C.BusinessDay > @LastSTMTDate
		AND DENAME = 200
	)
	SELECT 
	CASE 
	WHEN C.OldValue = TRY_CAST(AmountofTotalDue AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
	WHEN C.OldValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) AND C.NewValue <> TRY_CAST(AmountofTotalDue AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(AmountofTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(C.IdentityField AS VARCHAR)
	ELSE NULL END CBA_Due,
	CASE 
	WHEN CA.TID IS NOT NULL THEN 
		CASE 
		WHEN C.OldValue = TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = ' + TRY_CAST(CA.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(CA.IdentityField AS VARCHAR)
		WHEN CA.OldValue <> TRY_CAST(CycleDueDTD AS VARCHAR) AND CA.NewValue <> TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAudit SET NewValue = ''' + TRY_CAST(CycleDueDTD AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(CA.AID AS VARCHAR) + ' AND ATID = 51 AND IdentityField = ' + TRY_CAST(CA.IdentityField AS VARCHAR)
		ELSE NULL END
	ELSE CASE 
		WHEN C.AmountofTotalDue = 0 THEN 'INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (' + TRY_CAST(C.TID AS VARCHAR) + ', ''' + TRY_CONVERT(VARCHAR(50), C.businessday, 20) + ''', 51, ' +TRY_CAST(C.AID AS VARCHAR) + ', 115, ''1'', ''0'')'
		ELSE NULL END
	END CBA_CycleDueDTD,
	*
	FROM CTE C
	LEFT JOIN CurrentBalanceAudit CA WITH (NOLOCK) ON (C.AID = CA.AID AND C.TID = CA.TID AND CA.ATID = 51 AND CA.DENAME = 115)
	WHERE C.Ranking = 1
	--AND C.AID NOT IN (18539988)


	;WITH CBA_210 
	AS
	(
		SELECT C.TID, C.AID, C.businessday, C.Dename Dename_210, C.OldValue OldValue_210, C.NewValue NewValue_210, 
		A.AmountOfTotalDue, A.CycleDueDTD, A.AmountOfTotalDue_OLD, A.CycleDueDTD_OLD, RANK() OVER (PARTITION BY C.AID ORDER BY C.BusinessDay)  Ranking
		FROM CurrentBalanceAuditPS C WITH (NOLOCK) 
		JOIN #Corrected_PS A ON (C.AID = A.CPSAcctId AND C.ATID = 52)
		WHERE C.BusinessDay > @LastSTMTDate
		AND DENAME = 210
		AND TRY_CAST(C.NewValue AS MONEY) < AmountofTotalDue
	),
	CBA_200
	AS
	(
		SELECT C.TID, CA.IdentityField IdentityField_200, CA.Dename Dename_200, CA.OldValue OldValue_200, CA.NewValue NewValue_200
		FROM CBA_210 C
		LEFT JOIN CurrentBalanceAuditPS CA WITH (NOLOCK) ON (C.AID = CA.AID AND C.TID = CA.TID AND CA.ATID = 52 AND CA.DENAME = 200)
		--WHERE C.Ranking = 1
	),
	CBA_115
	AS
	(
		SELECT C.TID, CA.IdentityField IdentityField_115, CA.Dename Dename_115, CA.OldValue OldValue_115, CA.NewValue NewValue_115
		FROM CBA_210 C
		LEFT JOIN CurrentBalanceAuditPS CA WITH (NOLOCK) ON (C.AID = CA.AID AND C.TID = CA.TID AND CA.ATID = 52 AND CA.DENAME = 115)
		--WHERE C.Ranking = 1
	)
	SELECT *,
	CASE 
	WHEN C2.Dename_200 IS NOT NULL THEN 
		CASE 
		WHEN C2.OldValue_200 = TRY_CAST(AmountOfTotalDue AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C1.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C2.IdentityField_200 AS VARCHAR)
		WHEN C2.OldValue_200 <> TRY_CAST(AmountOfTotalDue AS VARCHAR) AND C2.NewValue_200 <> TRY_CAST(AmountOfTotalDue AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(AmountOfTotalDue AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C1.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C2.IdentityField_200 AS VARCHAR)
		ELSE NULL END
	ELSE CASE 
		WHEN C1.AmountofTotalDue = 0 THEN 'INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) 
		VALUES (' + TRY_CAST(C1.TID AS VARCHAR) + ', ''' + TRY_CONVERT(VARCHAR(50), C1.businessday, 20) + ''', 52, ' + TRY_CAST(C1.AID AS VARCHAR) + ', 200, ''' + TRY_CAST(C1.AmountOfTotalDue_OLD AS VARCHAR) + ''', ''' + TRY_CAST(C1.AmountOfTotalDue AS VARCHAR) + ''')'
		ELSE NULL END
	END CBA_Due,
	CASE 
	WHEN C3.Dename_115 IS NOT NULL THEN 
		CASE 
		WHEN C3.OldValue_115 = TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = ' + TRY_CAST(C1.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C3.IdentityField_115 AS VARCHAR)
		WHEN C3.OldValue_115 <> TRY_CAST(CycleDueDTD AS VARCHAR) AND C3.NewValue_115 <> TRY_CAST(CycleDueDTD AS VARCHAR) THEN 'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(CycleDueDTD AS VARCHAR)+ ''' WHERE AID = ' + TRY_CAST(C1.AID AS VARCHAR) + ' AND ATID = 52 AND IdentityField = ' + TRY_CAST(C3.IdentityField_115 AS VARCHAR)
		ELSE NULL END
	ELSE CASE 
		WHEN C1.AmountofTotalDue = 0 THEN 'INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) 
		VALUES (' + TRY_CAST(C1.TID AS VARCHAR) + ', ''' + TRY_CONVERT(VARCHAR(50), C1.businessday, 20) + ''', 52, ' +TRY_CAST(C1.AID AS VARCHAR) + ', 115, ''' + TRY_CAST(C1.CycleDueDTD_OLD AS VARCHAR) + ''', ''' + TRY_CAST(C1.CycleDueDTD AS VARCHAR) + ''')'
		ELSE NULL END
	END CBA_CycleDueDTD
	FROM CBA_210 C1
	JOIN CBA_200 C2 ON (C1.TID = C2.TID)
	JOIN CBA_115 C3 ON (C2.TID = C3.TID)
	WHERE C1.Ranking = 1
	--ORDER BY C1.AID, C1.Ranking

END


