IF((SELECT COUNT(1) FROM TempData_DelinkDebitPlans WITH (NOLOCK) WHERE JobStatus = 0) > 0)
BEGIN

	BEGIN TRY
		
		BEGIN TRANSACTION
		
			UPDATE CPS
			SET Parent02AID = -CPS.Parent02AID
			FROM CPSgmentAccounts CPS 
			JOIN TempData_DelinkDebitPlans T1 ON (CPS.acctID = T1.acctID)


			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailSummary ILP 
			JOIN TempData_DelinkDebitPlans T1 ON (ILP.PlanID = T1.acctID)

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetails ILP 
			JOIN TempData_DelinkDebitPlans T1 ON (ILP.acctId = T1.acctID)

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailsRevised ILP 
			JOIN TempData_DelinkDebitPlans T1 ON (ILP.acctId = T1.acctID)


			DELETE X
			FROM XRefTable X 
			JOIN TempData_DelinkDebitPlans T ON (X.ParentATID = 51 AND X.parentAID = T.BSAcctID AND ChildATID = 52 AND X.ChildAID = T.acctID)

			UPDATE TempData_DelinkDebitPlans SET JobStatus = 1

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION 
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH

END