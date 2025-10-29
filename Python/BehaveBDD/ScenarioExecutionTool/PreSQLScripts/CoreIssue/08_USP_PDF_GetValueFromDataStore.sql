CREATE OR ALTER PROCEDURE USP_PDF_GetValueFromDataStore
@ExecutionID int,
@VariableName VARCHAR(100)
AS
DECLARE @VariableValue VARCHAR(3000)
SELECT TOP 1 @VariableValue= VariableValue  FROM FeatureStepDataStore WITH(NOLOCK) 
WHERE ExecutionID = @ExecutionID and VariableName=@VariableName 
ORDER BY ID DESC
SELECT  @VariableValue AS  VariableValue