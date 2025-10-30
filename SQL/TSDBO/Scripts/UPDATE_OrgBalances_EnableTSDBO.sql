/**********************************************************************************************************************
Purpose								: PLAT-259458
Author								: Prasoon Parashar
Date									: 09/08/2025
Application version					: Plat_25.10.3
Description							: Enhance high balance calculation logic
Review By							: Deepak Dharkar 
**********************************************************************************************************************/

BEGIN TRY
	BEGIN TRANSACTION
		UPDATE Org_Balances 
		SET 
			TSDBOActive = '1',
			TSDBOActiveDate = dbo.GetBusinessTime()
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION 
		SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
		RAISERROR('ERROR OCCURED :-', 16, 1);
END CATCH



