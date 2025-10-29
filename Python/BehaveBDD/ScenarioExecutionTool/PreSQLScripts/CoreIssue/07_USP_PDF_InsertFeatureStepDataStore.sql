CREATE OR ALTER PROCEDURE USP_PDF_InsertFeatureStepDataStore
@ExecutionID INT,
@FeatureName VARCHAR(1000),
@ScenarioName VARCHAR(1000), 
@VariableName VARCHAR(100),
@VariableValue VARCHAR(1000)
AS 
IF NOT EXISTS (SELECT TOP 1 1 FROM FeatureStepDataStore WITH(NOLOCK) WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName 
AND VariableName=@VariableName )
BEGIN 
    INSERT INTO FeatureStepDataStore(ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue)
    SELECT @ExecutionID, @FeatureName, @ScenarioName, @VariableName, @VariableValue
END
ELSE
BEGIN
    UPDATE FeatureStepDataStore SET VariableValue = @VariableValue
    WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName 
    AND VariableName=@VariableName 
END