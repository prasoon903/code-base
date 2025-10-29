import json
import os 
from datetime import datetime

import pyodbc
import json
#from .ExectableFunction import *
from .DataBaseConnections import *

CurrentTime =  datetime.now().strftime("%Y_%m_%d_%H_%M_%S")

Configuration =  json.load(open("Configuration/Configuration.json"))

""" DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'] ,
                        Server = Configuration['DBServer'],
                        Database = Configuration['CoreIssueDBName'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        ) """
cursor=DBCon.cursor()




EXECUTION_ID =  cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
EXECUTION_ID = cursor.fetchone().MaxExecutionID

PlatformCodeloc = Configuration['PlatformCodeloc']

global FeatureStepDataStore
FeatureStepDataStore = {}

CurrentTime =  datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
#ExecutionStepDataWareHouseObj = open(f"DataStore\ExecutionStepDataWareHouse_{CurrentTime}.json","w+")
"""   
def fn_WriteScenarioStaus(Scenario,Sataus):


    if os.path.isfile(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json"):
            ExecutionFileScenarioStatusDataReadOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","r")
            Data = ExecutionFileScenarioStatusDataReadOBj.read()
            print(Data)
            ExecutionFileScenarioStatusDataReadOBj.close()

            ExecutionFileScenarioStatusDataOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
            
            ExecutionFileScenarioStatusData = json.loads(Data)
            ExecutionFileScenarioStatusData[Scenario] = Sataus
            json.dump(ExecutionFileScenarioStatusData,ExecutionFileScenarioStatusDataOBj,indent=4)
        
            print(ExecutionFileScenarioStatusData)
    else:
        ExecutionFileScenarioStatusDataOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
        ExecutionFileScenarioStatusData ={}
        ExecutionFileScenarioStatusData[Scenario] = Sataus
        json.dump(ExecutionFileScenarioStatusData,ExecutionFileScenarioStatusDataOBj,indent=4)
        print(ExecutionFileScenarioStatusData)
    print("Exit Function ................")
    ExecutionFileScenarioStatusDataOBj.close()
 """

def fn_InsertFeatureStepExecutionInfo(ExecutionID,FeatureName,ScenarioName,StepName,Staus):
    
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepExecutionInfo {ExecutionID},'{FeatureName}','{ScenarioName}','{StepName}','{Staus}'"
    cursor.execute(sql)

def fn_InsertFeatureStepDataStore(ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue):
     
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepDataStore {ExecutionID}, '{FeatureName}', '{ScenarioName}', '{VariableName}', '{VariableValue}'"
    cursor.execute(sql)
    FeatureStepDataStore[VariableName]=VariableValue

def fn_GetValueFromDataStore(ExecutionID,  VariableName):
    if VariableName in FeatureStepDataStore:
        return str(FeatureStepDataStore[VariableName]).strip()
    else:
        sql =  f"SET NOCOUNT ON EXEC USP_PDF_GetValueFromDataStore {ExecutionID},'{VariableName}'"
        cursor.execute(sql)
        Value  =  cursor.fetchone().VariableValue
        return str(Value).strip()

def fn_GetCurrentCommonTNPDate():
    cursor.execute("SELECT TOP 1 CONVERT(date,tnpdate) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate

def fn_GetAgingDate(Days):
    cursor.execute(f"SELECT TOP 1 CONVERT(date,DATEADD(day,{Days},tnpdate)) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate
    


