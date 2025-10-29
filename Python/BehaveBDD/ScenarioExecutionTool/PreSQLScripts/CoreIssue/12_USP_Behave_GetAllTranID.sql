
/*
SELECT * FROM FeatureStepDataStore 
GO
*/

CREATE OR ALTER PROCEDURE USP_Behave_GetAllTranID (@ExecutionID INT, @TranType VARCHAR(5), @FeatureName VARCHAR(100), @ScenarioName VARCHAR(200), @VariableName VARCHAR(100))
AS
BEGIN

	DECLARE @AccountNumber VARCHAR(19) 

	IF EXISTS (SELECT TOP 1 1 FROM FeatureStepDataStore WITH(NOLOCK) WHERE ExecutionID = @ExecutionID AND FeatureName = @FeatureName AND VariableName LIKE (@VariableName + '_'))
	BEGIN
		DELETE FROM FeatureStepDataStore WHERE ExecutionID = @ExecutionID AND FeatureName = @FeatureName AND VariableName LIKE (@VariableName + '_')
	END


	SELECT TOP 1 @AccountNumber = VariableValue FROM FeatureStepDataStore WITH(NOLOCK) WHERE ExecutionID = @ExecutionID AND VariableName = 'MyAccountNumber'

	SELECT RevTgt INTO #TempRevTgt FROM CCard_Primary WITH(NOLOCK) WHERE AccountNumber = @AccountNumber AND RevTgt IS NOT NULL

	CREATE TABLE #Temp
	(
		TranID DECIMAL(19,0),
		TransactionAmount MONEY,
		Skey INT IDENTITY(1,1)
	)

	INSERT INTO #Temp (TranID, TransactionAmount )
	SELECT tranID , TransactionAmount FROM CCard_Primary WITH(NOLOCK) WHERE AccountNumber = @AccountNumber AND CMTTRANTYPE = @TranType AND TranId NOT IN (SELECT RevTgt FROM #TempRevTgt) 
	ORDER BY PostTime


	INSERT INTO FeatureStepDataStore (ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue)
	SELECT @ExecutionID, @FeatureName, @ScenarioName, @VariableName + '_' + TRY_CAST(Skey AS VARCHAR) + '_TranID' , TranID
	FROM #Temp 
	ORDER BY Skey

	INSERT INTO FeatureStepDataStore (ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue)
	SELECT @ExecutionID, @FeatureName, @ScenarioName, @VariableName + '_' + TRY_CAST(Skey AS VARCHAR) + '_Amount' , TransactionAmount
	FROM #Temp 
	ORDER BY Skey

END
