CREATE OR ALTER PROCEDURE USP_PDF_InsertFeatureStepExecutionInfo
@ExecutionID INT,
@FeatureName VARCHAR(1000),
@ScenarioName VARCHAR(1000), 
@StepName VARCHAR(500),
@Staus VARCHAR(50)
AS 
IF NOT EXISTS (SELECT TOP 1 1 FROM FeatureStepExecutionInfo WITH(NOLOCK) WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName
 AND StepName=@StepName)
BEGIN 
    INSERT INTO FeatureStepExecutionInfo(ExecutionID, FeatureName, ScenarioName, StepName,Staus)
    SELECT @ExecutionID, @FeatureName, @ScenarioName, @StepName, @Staus
END
BEGIN
    UPDATE FeatureStepExecutionInfo SET Staus=@Staus,CurrentTime=GetDate()
    WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName AND StepName=@StepName
END