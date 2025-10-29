IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'FeatureStepDataStore')
BEGIN
CREATE TABLE FeatureStepDataStore (
    ID INT DEFAULT(NEXT VALUE FOR dbo.FeatureStepDataStore_ID),
    ExecutionID INT,
    FeatureName VARCHAR(1000),
    ScenarioName VARCHAR(1000), 
    VariableName VARCHAR(500),
    VariableValue VARCHAR(3000)
    )
END