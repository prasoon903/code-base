

	BEGIN TRY
		
		BEGIN TRANSACTION
		
			UPDATE CPS
			SET Parent02AID = -CPS.Parent02AID
			FROM CPSgmentAccounts CPS 
			JOIN TempData_Delink_CIM_134955 T1 ON (CPS.acctID = T1.PlanID)


			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailSummary ILP 
			JOIN TempData_Delink_CIM_134955 T1 ON (ILP.PlanID = T1.PlanID)

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetails ILP 
			JOIN TempData_Delink_CIM_134955 T1 ON (ILP.acctId = T1.PlanID)

			UPDATE ILP
			SET Parent02AID = -ILP.Parent02AID
			FROM ILPScheduleDetailsRevised ILP 
			JOIN TempData_Delink_CIM_134955 T1 ON (ILP.acctId = T1.PlanID)


			DELETE X
			FROM XRefTable X 
			JOIN TempData_Delink_CIM_134955 T ON (X.ParentATID = 51 AND X.parentAID = T.BSAcctID AND ChildATID = 52 AND X.ChildAID = T.PlanID)

			--UPDATE TempData_Delink_CIM_134955 SET JobStatus = 1

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION 
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH

