IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'FeatureStepExecutionInfo')
BEGIN
CREATE TABLE FeatureStepExecutionInfo (
    ID INT DEFAULT(NEXT VALUE FOR dbo.FeatureStepExecutionInfo_ID),
    ExecutionID INT ,
    FeatureName VARCHAR(1000),
    ScenarioName VARCHAR(1000),
    StepName VARCHAR(500), 
    CurrentTime DATETIME DEFAULT Getdate(),
    Staus VARCHAR(50)
)
END