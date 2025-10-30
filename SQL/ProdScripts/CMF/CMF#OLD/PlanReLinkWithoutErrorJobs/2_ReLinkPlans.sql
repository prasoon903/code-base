
DROP TABLE IF EXISTS #AllPlans
CREATE TABLE #AllPlans(acctID INT,parent02AID INT,parent01AID INT)

IF EXISTS (SELECT TOP 1 1 FROM AccountsOfPlanToReLink WHERE JobStatus = 0)
BEGIN

	;WITH CTE
	AS
	(SELECT DISTINCT acctID FROM AccountsOfPlanToReLink WITH(NOLOCK) WHERE JobStatus = 0)
	INSERT INTO #AllPlans
	SELECT CPS.acctID, CPS.parent02AID, CPS.parent01AID
	FROM CPSgmentAccounts CPS WITH (NOLOCK)
	JOIN CTE C WITH(NOLOCK) ON (CPS.parent02AID = -C.Acctid)
	
END


IF EXISTS (SELECT TOP 1 1 FROM #AllPlans)
BEGIN
	DROP TABLE IF EXISTS #XRefData
	CREATE TABLE #XRefData(ChildAID INT,ChildATID INT,ParentAID INT,ParentATID INT,ParentOrder INT,StartDate DATETIME)

	INSERT INTO #XRefData
	SELECT CPS.acctID, 52, BP.acctID, 51, 1,
	CASE WHEN CPM.LAD > BP.CreatedTime THEN CPM.LAD ELSE BP.CreatedTime END
	FROM BSegment_Primary BP WITH (NOLOCK)
	JOIN #AllPlans CPS WITH (NOLOCK) ON (BP.acctId = -CPS.parent02AID)
	LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CPS.parent01AID = CPM.acctID)
	ORDER BY CPS.acctID

	--SELECT * FROM #XRefData

	BEGIN TRY
		
		BEGIN TRANSACTION
		
			UPDATE CPS
			SET Parent02AID = -CPS.Parent02AID
			FROM CPSgmentAccounts CPS 
			JOIN #AllPlans T1 ON (CPS.acctID = T1.acctID)
			WHERE CPS.Parent02AID < 0

			UPDATE SH
			SET Parent02AID = -SH.Parent02AID
			FROM SummaryHeader SH 
			JOIN #AllPlans T1 ON (SH.acctID = T1.acctID)
			WHERE SH.Parent02AID < 0


			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailSummary ILP 
			JOIN #AllPlans T1 ON (ILP.PlanID = T1.acctID)
			WHERE ILP.Parent02AID < 0

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetails ILP 
			JOIN #AllPlans T1 ON (ILP.acctId = T1.acctID)
			WHERE ILP.Parent02AID < 0

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailsRevised ILP 
			JOIN #AllPlans T1 ON (ILP.acctId = T1.acctID)
			WHERE ILP.Parent02AID < 0

			INSERT INTO XRefTable (ChildAID,ChildATID,ParentAID,ParentATID,ParentOrder,StartDate)
			SELECT ChildAID,ChildATID,ParentAID,ParentATID,ParentOrder,StartDate FROM #XRefData

			UPDATE AccountsOfPlanToReLink SET JobStatus = 1 WHERE JobStatus = 0

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION 
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH

END