import json
import os 
from datetime import datetime
import re
import pyodbc
import json
# from .ExectableFunction import *
from .DataBaseConnections import *


CurrentTime =  datetime.now().strftime("%Y_%m_%d_%H_%M_%S")

RootPath  = os.environ.get('RootPath')
# RootPath = f'E:\\Python\\BehaveBDD\\features'

Configuration =  json.load(open(RootPath+"\Configuration/Configuration.json"))
"""DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'],
                        Server = Configuration['DBServer'],
                        Database = Configuration['YourDBNames']['COREISSUE'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        )
"""
cursor=DBCon.cursor()




# EXECUTION_ID =  cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
# EXECUTION_ID = cursor.fetchone().MaxExecutionID

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
def fn_getexecuationidbyfeaturename(FeatureName):
    print(FeatureName)
    sqry = "SELECT MAX(ExecutionID) AS ExecutionID FROM FeatureStepDataStore WHERE FeatureName = ?"
    # cursor = conn.cursor()
    cursor.execute(sqry, (FeatureName,))
    result = cursor.fetchone()

    if result:
        executionid = str(result[0])
        print("Execution ID:", executionid)
    else:
        print("No results found for the given FeatureName.")

    # sqry ="SELECT max(ExecutionID) as ExecutionID FROM FeatureStepDataStore where FeatureName = ?"
    # cursor.execute(sqry,(FeatureName,))
    # executionid = str(cursor.fetchone()[0])
    print("Execution ID-outside:", executionid)
    return executionid

def fn_InsertFeatureStepExecutionInfo(ExecutionID,FeatureName,ScenarioName,StepName,Staus):
    
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepExecutionInfo {ExecutionID},'{FeatureName}','{ScenarioName}','{StepName}','{Staus}'"
    print(sql)
    cursor.execute(sql)

def fn_InsertFeatureStepDataStore(ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue):
     
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepDataStore {ExecutionID}, '{FeatureName}', '{ScenarioName}', '{VariableName}', '{VariableValue}'"
    print("fn_InsertFeatureStepDataStore",sql)
    print(VariableName)
    print(VariableValue)
    cursor.execute(sql)
    FeatureStepDataStore[VariableName]=VariableValue

def fn_GetValueFromDataStore(ExecutionID,  VariableName):
    print("Inside fn_GetValueFromDataStore")
    if VariableName in FeatureStepDataStore:
        print(VariableName)
        return str(FeatureStepDataStore[VariableName]).strip()
    else:
        sql =  f"SET NOCOUNT ON EXEC USP_PDF_GetValueFromDataStore {ExecutionID},'{VariableName}'"
        print(sql)
        cursor.execute(sql)
        Value  =  cursor.fetchone().VariableValue
        print(Value)
        return str(Value).strip()

def fn_GetCurrentCommonTNPDate():
    cursor.execute("SELECT TOP 1 CONVERT(date,trantime) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate

# def fn_GetTxnDetailsFromCommonTNP(TranID):
#     cursor.execute(f"SELECT COUNT(1) TxnCount FROM CommonTNP where TranID = {TranID}")
#     TxnCount = str(cursor.fetchone()[0])
#     return TxnCount

def fn_GetAgingDate(Days):
    cursor.execute(f"SELECT TOP 1 CONVERT(date,DATEADD(day,{Days},tnpdate)) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate
    

def fn_GetTxnDetails(ExecutionID, VariableName, FeatureName):
    sql = f"SET NOCOUNT ON EXEC USP_GETTxnDetails_Behave {ExecutionID},'{VariableName}','{FeatureName}'"
    print(sql)
    try:
        cursor.execute(sql)
        results = []
        print("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                print("we are here inside loop")
                result_dict[column[0]] = row[idx].strip()
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except Exception as e:
        print("we are here in error",e)
        result_json= {}

    return result_json


def fn_setexeutionID(fetaurename,action):
    if action == "new":
        EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
        EXECUTION_ID = cursor.fetchone().MaxExecutionID
        set_global_EXECUTION_ID(EXECUTION_ID)
        print("fn_setexeutionID",EXECUTION_ID )
        return EXECUTION_ID
    elif re.match(r'^\d+$', action):
        EXECUTION_ID = fetaurename
        set_global_EXECUTION_ID(EXECUTION_ID)
        print("custom EXECUTION_ID for rerun", EXECUTION_ID)
    else:
        print(fetaurename)
        print("Rohit",action)
        sql = f"SELECT TOP 1 executionid FROM FeatureStepExecutionInfo (NOLOCK) WHERE FeatureName = '{fetaurename}' ORDER BY id DESC"
        print(sql)
        cursor.execute(sql)
        row =  cursor.fetchone()
        if row is None:
            EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
            EXECUTION_ID = cursor.fetchone().MaxExecutionID
            set_global_EXECUTION_ID(EXECUTION_ID)
            print("fn_setexeutionID", EXECUTION_ID)
        else:
            EXECUTION_ID = str(row[0])
            print("EXECUTION_ID for rerun", EXECUTION_ID)
            set_global_EXECUTION_ID(EXECUTION_ID)
        return EXECUTION_ID


def set_global_EXECUTION_ID(value):
    global EXECUTION_ID
    EXECUTION_ID = value

def get_global_EXECUTION_ID():
    if "EXECUTION_ID" in globals():
        return EXECUTION_ID
    else:
        return None

def fn_GetAccountDetails(AccountNumber):
    print("Inside fn_GetAccountDetails")
    print(AccountNumber)
    sql = f"EXEC USP_AccountDetails @AccountNumber = '{AccountNumber}'"
    print(sql)
    try:
        cursor.execute(sql)
        results = []
        # print("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # print("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except Exception as e:
        print("we are here in error", e)
        result_json = {}

    print(result_json)
    return result_json

def fn_GetPlanDetails(AccountNumber):
    print("Inside fn_GetPlanDetails")
    sql = f"EXEC USP_AccountDetails @AccountNumber = '{AccountNumber}', @AccountData = 0, @CPSData = 1"
    print(sql)
    print(sql)
    try:
        cursor.execute(sql)
        results = []
        # print("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # print("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except Exception as e:
        print("we are here in error", e)
        result_json = {}

    return result_json