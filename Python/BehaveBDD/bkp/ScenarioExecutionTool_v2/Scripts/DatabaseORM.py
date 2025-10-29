# import pyodbc
# import json
from Scripts.DataBaseConnections import *
# import Config as c



#Configuration =  json.load(open("Configuration/Configuration.json"))
""" DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'] ,
                        Server = Configuration['DBServer'],
                        Database = Configuration['CoreIssueDBName'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        ) """
cursor=DBCon.cursor()


sql ="""IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'FeatureStepExecutionInfo')
BEGIN
CREATE TABLE FeatureStepExecutionInfo (
    ID INT IDENTITY(1,1),
    ExecutionID INT ,
    FeatureName VARCHAR(100),
    ScenarioName VARCHAR(100),
    StepName VARCHAR(500), 
    CurrentTime DATETIME DEFAULT Getdate(),
    Staus VARCHAR(50)
)
END
"""
cursor.execute(sql)

sql ="""
IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'FeatureStepDataStore')
BEGIN
CREATE TABLE FeatureStepDataStore (
    ID INT IDENTITY(1,1),
    ExecutionID INT,
    FeatureName VARCHAR(1000),
    ScenarioName VARCHAR(1000), 
    VariableName VARCHAR(500),
    VariableValue VARCHAR(3000)
    )
END
"""
cursor.execute(sql)

sql ="""
IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'MaxExecutionValue')
BEGIN
CREATE TABLE MaxExecutionValue (
    ID INT IDENTITY(1,1),
    Name VARCHAR(50),
    Value INT,
    StepSize INT
    )
INSERT INTO MaxExecutionValue(Name,Value,StepSize)
SELECT 'ExecutionID',2,2

END
"""

cursor.execute(sql)

sql = """
CREATE OR ALTER PROCEDURE USP_PDF_GetMaxExecutionID
AS
DECLARE @MaxExecutionID INT
SELECT @MaxExecutionID = Value  FROM MaxExecutionValue WITH(UPDLOCK) WHERE Name = 'ExecutionID'
UPDATE MaxExecutionValue SET Value = @MaxExecutionID + StepSize WHERE Name = 'ExecutionID'
SELECT @MaxExecutionID AS MaxExecutionID
"""
cursor.execute(sql)

sql = """
CREATE OR ALTER PROCEDURE USP_PDF_InsertFeatureStepExecutionInfo
@ExecutionID INT,
@FeatureName VARCHAR(100),
@ScenarioName VARCHAR(100), 
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
"""
cursor.execute(sql)



sql = """
CREATE OR ALTER PROCEDURE USP_PDF_InsertFeatureStepDataStore
@ExecutionID INT,
@FeatureName VARCHAR(100),
@ScenarioName VARCHAR(100), 
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
"""
cursor.execute(sql)


sql = """
CREATE OR ALTER PROCEDURE USP_PDF_GetValueFromDataStore
@ExecutionID int,
@VariableName VARCHAR(100)
AS
DECLARE @VariableValue VARCHAR(3000)
SELECT TOP 1 @VariableValue= VariableValue  FROM FeatureStepDataStore WITH(NOLOCK) 
WHERE ExecutionID = @ExecutionID and VariableName=@VariableName 
ORDER BY ID DESC
SELECT  @VariableValue AS  VariableValue
"""
cursor.execute(sql)
sql="""
CREATE OR ALTER PROCEDURE [dbo].[USP_GETTxnDetails_Behave]
@ExecutionID int = 0, 
@VariableName varchar(500), 
@FeatureName VARCHAR(1000)
as 
BEGIN  
	Declare @VariableValue varchar(3000) 
	IF(@ExecutionID = 0) 
	BEGIN  
	select @VariableValue = VariableValue from FeatureStepDataStore (nolock)  where FeatureName = @FeatureName AND VariableName=@VariableName 
	END 
	ELSE 
	BEGIN  select @VariableValue = VariableValue from FeatureStepDataStore (nolock)  where Executionid = @ExecutionID and VariableName=@VariableName END
	Declare @tranid decimal(19,0) = try_cast( @VariableValue as decimal(19, 0)) 

	;WITH CTE
	as (     
	select accountnumber,tranid, txncode_internal, cmttrantype, posttime, trantime, transactionamount, ISNULL(ClaimID, '') ClaimID from ccard_primary(nolock) where tranid = @tranid  
	) 
	select accountnumber, cast(tranid as varchar(50)) tranid, txncode_internal, cmttrantype, 
	CONVERT(varchar, posttime, 120) posttime, CONVERT(varchar, trantime, 120) trantime, ClaimID,
	cast(transactionamount as varchar) transactionamount, M.ActualTrancode , 
	M.ManualAdjustmentTxnCode, M1.ActualTrancode as ManualReversalTrancode 
	from CTE 
	Join MonetaryTxnControl M(nolock) on CTE.txncode_internal = M.TransactionCode Join MonetaryTxnControl M1(nolock) on M1.TransactionCode = M.ManualAdjustmentTxnCode    
END"""
cursor.execute(sql)
