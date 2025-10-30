BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			UPDATE BP
			SET 
				CBRAmountOfCurrentBalance = CB_Stmt_Calc,
				CBRAmountOfHighBalance = HB_Stmt_Calc
			FROM CurrentStatementHeader BP 
			JOIN ##CBRAccounts C ON (BP.acctID = C.acctID AND BP.StatementDate = C.LastStatementDate)
			WHERE C.JobStatus = 2

			UPDATE ##CBRAccounts SET JobStatus = 5 WHERE JobStatus = 2

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER()
		RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH

END



