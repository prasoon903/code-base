DROP TABLE IF EXISTS #TempDetails
DROP TABLE IF EXISTS #TempAccounts
DROP TABLE IF EXISTS #TempUpdate



CREATE TABLE #TempAccounts
(
	AccountID INT, UpdateStatus INT DEFAULT 0
)

INSERT INTO #TempAccounts (AccountID) VALUES 
(758374 )
,(4959473)
,(2356186)
,(2263476)
,(1728411)
,(9155985)

SELECT 'TOTAL ACCOUNT INSERTED===> ' + TRY_CAST(COUNT(1) AS VARCHAR) FROM #TempAccounts WHERE UpdateStatus = 0


--------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE #TempDetails
(
	Skey DECIMAL(19, 0) IDENTITY(1, 1), AccountID INT, PlanID INT, CreditPlanType VARCHAR(10), PlanAmountDue MONEY, PlanSRBID MONEY, DIFF MONEY, CycleDueDTD INT, TranID DECIMAL(19,0), JobStatus INT DEFAULT 0
)

CREATE TABLE #TempUpdate
(
	AccountID INT, PlanID INT, UpdateType VARCHAR(10), Details VARCHAR(500)
)



DECLARE @LastStatementDate DATETIME = '2020-07-31 23:59:57.000', @Businessday VARCHAR(50) = '2020-08-26 23:59:57.000', @JobID INT = 0, @TranID DECIMAL(19, 0), @AccountID INT, @PlanID INT, @CycleDueDTD INT

INSERT INTO #TempDetails (AccountID, PlanID, CreditPlanType, PlanAmountDue, PlanSRBID, DIFF, CycleDueDTD)
SELECT 
	CPA.parent02AID, CPA.acctId, CreditPlanType, AmountOfTotalDue, SRBWithInstallmentDue, SRBWithInstallmentDue - AmountOfTotalDue, CycleDueDTD 
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
JOIN #TempAccounts TA WITH (NOLOCK) ON (TA.AccountID = CPA.parent02AID)
WHERE CreditPlanType = '16' AND SRBWithInstallmentDue - AmountOfTotalDue <> 0


UPDATE TD
	SET TranID = CBA.TID
FROM CurrentbalanceAuditPS CBA WITH (NOLOCK)
JOIN #TempDetails TD ON (CBA.AID = TD.PlanID AND CBA.ATID = 52)
WHERE CBA.DENAME = 200 AND Businessday > '2020-07-31 23:59:57.000'


WHILE((SELECT COUNT(1) FROM #TempDetails WHERE JobStatus = 0) > 0)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			SELECT TOP 1 @JobID = Skey, @TranID = TranID, @AccountID = AccountID, @PlanID = PlanID, @CycleDueDTD = CycleDueDTD FROM #TempDetails WHERE JobStatus = 0

			IF(@CycleDueDTD = 0)
			BEGIN
				INSERT INTO #TempUpdate
				SELECT 
					@AccountID, PlanID, 'CPS', 'UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', AmtOfPayCurrDue = AmtOfPayCurrDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', CycleDueDTD = 1 WHERE acctId = ' + TRY_CAST(PlanID AS VARCHAR) + '   -- AccountID: ' + TRY_CAST(@AccountID AS VARCHAR)
				FROM #TempDetails WITH (NOLOCK) WHERE Skey = @JobID

				INSERT INTO #TempUpdate
				SELECT 
					@AccountID, PlanID, 'EOD', 'UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', AmtOfPayCurrDue = AmtOfPayCurrDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', CycleDueDTD = 1 WHERE CPSacctId = ' + TRY_CAST(PlanID AS VARCHAR) + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(@AccountID AS VARCHAR)
				FROM #TempDetails WITH (NOLOCK) WHERE Skey = @JobID
			END
			ELSE IF(@CycleDueDTD = 1)
			BEGIN
				INSERT INTO #TempUpdate
				SELECT 
					@AccountID, PlanID, 'CPS', 'UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', AmtOfPayCurrDue = AmtOfPayCurrDue + ' + TRY_CAST(DIFF AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(PlanID AS VARCHAR) + '   -- AccountID: ' + TRY_CAST(@AccountID AS VARCHAR)
				FROM #TempDetails WITH (NOLOCK) WHERE Skey = @JobID

				INSERT INTO #TempUpdate
				SELECT 
					@AccountID, PlanID, 'EOD', 'UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', AmtOfPayCurrDue = AmtOfPayCurrDue + ' + TRY_CAST(DIFF AS VARCHAR) + ' WHERE CPSacctId = ' + TRY_CAST(PlanID AS VARCHAR) + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(@AccountID AS VARCHAR)
				FROM #TempDetails WITH (NOLOCK) WHERE Skey = @JobID
			END

			INSERT INTO #TempUpdate
			SELECT 
				@AccountID, AID, 'CBA', 'DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = ' + TRY_CAST(IdentityField AS VARCHAR) + ' AND AID = ' + TRY_CAST(AID AS VARCHAR)
			FROM CurrentBalanceAuditPS WITH (NOLOCK)
			WHERE AID = @PlanID AND ATID = 52 AND DENAME IN (115, 200) AND TID = @TranID

			INSERT INTO #TempUpdate
			SELECT
				@AccountID, acctID, 'PDR', 'DELETE FROM PlanDelinquencyRecord WHERE TranID = ' + TRY_CAST(TranID AS VARCHAR) + ' AND acctId = ' + TRY_CAST(acctID AS VARCHAR)
			FROM PlanDelinquencyRecord WITH (NOLOCK)
			WHERE TranRef = @TranID AND acctId = @PlanID

			INSERT INTO #TempUpdate VALUES (@AccountID, @PlanID, 'BLANK', '')

			UPDATE #TempAccounts SET UpdateStatus = 1 WHERE AccountID = @AccountID

			UPDATE #TempDetails SET JobStatus = 1 WHERE Skey = @JobID
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		--SELECT ERROR_MESSAGE AS Error
	END CATCH
	
END

--SELECT * FROM #TempDetails
SELECT * FROM #TempUpdate WHERE UpdateType <> 'EOD' --ORDER BY UpdateType

--SELECT Count(1) FROM #TempDetails group by AccountID

SELECT 'TOTAL ACCOUNT PROCESSED===> ' + TRY_CAST(COUNT(1) AS VARCHAR) FROM #TempAccounts WHERE UpdateStatus = 1

--SELECT * FROM #TempUpdate WHERE AccountID = 2263476 

--SELECT * FROM #TempUpdate WHERE UpdateType = 'EOD' ORDER BY AccountID

--SELECT CBA.*
--FROM CurrentbalanceAuditPS CBA WITH (NOLOCK)
--JOIN #TempDetails TD ON (CBA.AID = TD.PlanID AND CBA.ATID = 52)
--WHERE CBA.DENAME = 200 AND Businessday > '2020-07-31 23:59:57.000'
--AND Try_CAST(CBA.OldValue AS MONEY) = TD.PlanSRBID AND Try_CAST(CBA.NewValue AS MONEY) = TD.PlanAmountDue

SELECT 
	'EOD', 'UPDATE PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + ' + TRY_CAST(DIFF AS VARCHAR) + ', AmtOfPayCurrDue = AmtOfPayCurrDue + ' + TRY_CAST(DIFF AS VARCHAR) + ' WHERE CPSacctId = ' + TRY_CAST(PlanID AS VARCHAR) + ' AND BusinessDay = ''' + @Businessday + '''   -- AccountID: ' + TRY_CAST(@AccountID AS VARCHAR)
FROM #TempDetails WITH (NOLOCK) WHERE Skey = @JobID