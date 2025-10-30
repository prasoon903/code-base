--use PP_jazz_CI
--select ReProjectionFlag, CreatedTime,* from bsegment_primary  WHERE AccountNumber = '1250001000003387'

;WITH CTE
AS
(
SELECT *, RANK() OVER(PARTITION BY FeatureName, VariableName ORDER BY ID)  Counter
FROM FeatureStepDataStore 
WHERE FeatureName IN (SELECT FeatureName FROM FeatureStepExecutionInfo GROUP BY FeatureName)
AND VariableName IN ('MyAccountNumber')
)
SELECT FeatureName, VariableValue AccountNumber FROM CTE WHERE Counter = 1 ORDER BY ExecutionID



;WITH CTE
AS
(
SELECT *, RANK() OVER(PARTITION BY FeatureName, VariableName ORDER BY ID)  Counter
FROM FeatureStepDataStore 
WHERE FeatureName IN (SELECT FeatureName FROM FeatureStepExecutionInfo GROUP BY FeatureName)
AND VariableName IN ('MyAccountNumber')
),
Accounts
AS
(
SELECT ExecutionID, FeatureName, VariableName, VariableValue 
FROM CTE  
WHERE Counter = 1 
--ORDER BY ExecutionID
),
DataSteps
AS
(
SELECT ExecutionID, ScenarioName, VariableName Step, VariableValue StepValue,
ROW_NUMBER() OVER (PARTITION BY ExecutionID ORDER BY ID DESC) RN
FROM FeatureStepDataStore
)
SELECT A.ExecutionID, FeatureName, VariableName, VariableValue, ScenarioName, Step, StepValue
FROM Accounts A
JOIN DataSteps D ON (A.ExecutionID = D.ExecutionID AND D.RN = 1)
ORDER BY ExecutionID



SELECT * FROM ConfigStore

--EXEC USP_PDF_GetValueFromDataStore 4, 'ccc'

SELECT object_name(object_id),* FROM sys.columns WHERE name = 'decurrentbalance_trantime_ps'

SELECT TRY_CONVERT(VARCHAR(100), CurrentBalance, 20) CurrentBalance FROM BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1400001000001737'

--EXEC USP_GETTxnDetails_Behave 8,'dispute_1_TranID','Test Dispute initiate 2'

SELECT CMTTRANTYPE, TransactionAmount,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100001000006697'
ORDER BY PostTime DESC

--TRUNCATE TABLE FeatureStepExecutionInfo
--TRUNCATE TABLE FeatureStepDataStore



SELECT * FROM FeatureStepDataStore WHERE FeatureName = 'Scenario Statement recalculation v2'
SELECT * FROM FeatureStepExecutionInfo WHERE FeatureName = 'Scenario Statement recalculation v2'
SELECT * FROM FeatureStepDataStore WHERE ExecutionID = 2
SELECT * FROM FeatureStepExecutionInfo WHERE 
Staus LIKE '%fail%' and 
ExecutionID = 16

--EXEC USP_GETTxnDetails_Behave 4,'cashpurchase_1_tranid','Scenario 15.1'

--EXEC USP_PDF_GetValueFromDataStore 2,'statementremainingbalancewithinstallmentdue'

--EXEC USP_PDF_InsertFeatureStepDataStore 6, 'Test Dispute', 'Add status and add dispute', 'ClaimID', '26f364fc-3a55-4e09-ae94-973a1bec9be7'

SELECT CurrentBalance, SysSubOrgID,* FROM BSegment_Primary 

--EXEC USP_PDF_GetValueFromDataStore 2,'MyAccountNumber'

SELECT TOP 1 executionid FROM FeatureStepExecutionInfo (NOLOCK) WHERE FeatureName = 'Scenario 7.' ORDER BY id DESC

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'Batch'
--EXEC USP_PDF_InsertFeatureStepExecutionInfo 18,'Scenario 18','Age system','Verify API response is OK','FAIL Error Found Yes'
--EXEC USP_PDF_GetValueFromDataStore 18,'MyAccountNumber'

--DELETE FROM FeatureStepExecutionInfo WHERE ID = 27

--EXEC USP_GETTxnDetails_Behave 0, 'Payment_1_Tranid', 'Scenario 12'

SELECT TransactionDescription,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule = '40'

SELECT CpmDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE CpmDescription LIKE '%promo%'

SELECT * FROM CommonTNP

 --CREATE   PROCEDURE USP_PDF_GetMaxExecutionID 
 --AS DECLARE @MaxExecutionID INT 
 --SELECT @MaxExecutionID = Value  FROM MaxExecutionValue WITH(UPDLOCK) WHERE Name = 'ExecutionID' 
 ----UPDATE MaxExecutionValue SET Value = @MaxExecutionID + StepSize WHERE Name = 'ExecutionID' 
 --SELECT @MaxExecutionID AS MaxExecutionID 

 SELECT * FROM MaxExecutionValue

  --CREATE   PROCEDURE USP_PDF_GetValueFromDataStore @ExecutionID int, @VariableName VARCHAR(100) 
  --AS 
  --DECLARE @VariableValue VARCHAR(3000)
  --SELECT TOP 1 @VariableValue= VariableValue 
  --FROM FeatureStepDataStore WITH(NOLOCK)  
  --WHERE ExecutionID = 2 and VariableName='statementremainingbalancewithinstallmentdue' 
  --ORDER BY ID
  --SELECT  @VariableValue AS  VariableValue 
  

  SELECT *  
  FROM FeatureStepDataStore WITH(NOLOCK)  
  WHERE ExecutionID = 2 and VariableName='statementremainingbalancewithinstallmentdue' 


   CREATE   PROCEDURE USP_PDF_InsertFeatureStepDataStore @ExecutionID INT, @FeatureName VARCHAR(100), @ScenarioName VARCHAR(100),  @VariableName VARCHAR(100), @VariableValue VARCHAR(1000) AS  IF NOT EXISTS (SELECT TOP 1 1 FROM FeatureStepDataStore WITH(NOLO
CK) WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName  AND VariableName=@VariableName ) BEGIN      INSERT INTO FeatureStepDataStore(ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue)     SELECT @E
xecutionID, @FeatureName, @ScenarioName, @VariableName, @VariableValue END ELSE BEGIN     UPDATE FeatureStepDataStore SET VariableValue = @VariableValue     WHERE ExecutionID=@ExecutionID AND FeatureName=@FeatureName AND ScenarioName=@ScenarioName      AN
D VariableName=@VariableName  END 



sp_helptext USP_PDF_GetValueFromDataStore
 CREATE   PROCEDURE USP_PDF_GetValueFromDataStore @ExecutionID int, @VariableName VARCHAR(100) AS 
 DECLARE @VariableValue VARCHAR(3000) 
 SELECT TOP 1 @VariableValue= VariableValue  FROM FeatureStepDataStore WITH(NOLOCK)  WHERE ExecutionID = @ExecutionID and
 VariableName=@VariableName  ORDER BY ID DESC 
 SELECT  @VariableValue AS  VariableValue 


 --EXEC USP_GETTxnDetails_Behave 12,'payment_1_tranid','Scenario Test account full scenario v2'

 --EXEC USP_PDF_GetValueFromDataStore 14,'amountoftotaldue'

 USP_GETTxnDetails_Behave 4