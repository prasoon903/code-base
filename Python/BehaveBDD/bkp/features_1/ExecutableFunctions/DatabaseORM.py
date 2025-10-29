import pyodbc
import json
from .DataBaseConnections import *


Configuration =  json.load(open("Configuration/Configuration.json"))
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
    FeatureName VARCHAR(100),
    ScenarioName VARCHAR(100), 
    VariableName VARCHAR(100),
    VariableValue VARCHAR(1000)
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
SELECT 'ExecutionID',0,2

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
@ExecutionID INT,
@VariableName VARCHAR(100)
AS
DECLARE @VariableValue INT
SELECT @VariableValue= VariableValue  FROM FeatureStepDataStore WITH(NOLOCK) WHERE ExecutionID = @ExecutionID

SELECT  @VariableValue AS  VariableValue
"""
cursor.execute(sql)