# import json
# import os
from datetime import datetime, timedelta
import re
# import pyodbc
# import json
# from .ExectableFunction import *
from Scripts.DataBaseConnections import *
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import set_global_EXECUTION_ID


CurrentTime = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")

# RootPath  = os.environ.get('RootPath')
# RootPath = f'E:\\Python\\BehaveBDD\\features'
Configuration = c.Configuration

# Configuration =  json.load(open(RootPath+"\Configuration/Configuration.json"))
"""DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'],
                        Server = Configuration['DBServer'],
                        Database = Configuration['YourDBNames']['COREISSUE'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        )
"""
cursor = DBCon.cursor()




# EXECUTION_ID =  cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
# EXECUTION_ID = cursor.fetchone().MaxExecutionID

PlatformCodeloc = Configuration['PlatformCodeloc']

global FeatureStepDataStore
FeatureStepDataStore = {}

CurrentTime = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
#ExecutionStepDataWareHouseObj = open(f"DataStore\ExecutionStepDataWareHouse_{CurrentTime}.json","w+")
"""   
def fn_WriteScenarioStaus(Scenario,Sataus):


    if os.path.isfile(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json"):
            ExecutionFileScenarioStatusDataReadOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","r")
            Data = ExecutionFileScenarioStatusDataReadOBj.read()
            MessageLogger.info(Data)
            ExecutionFileScenarioStatusDataReadOBj.close()

            ExecutionFileScenarioStatusDataOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
            
            ExecutionFileScenarioStatusData = json.loads(Data)
            ExecutionFileScenarioStatusData[Scenario] = Sataus
            json.dump(ExecutionFileScenarioStatusData,ExecutionFileScenarioStatusDataOBj,indent=4)
        
            MessageLogger.info(ExecutionFileScenarioStatusData)
    else:
        ExecutionFileScenarioStatusDataOBj = open(f"DataStore\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
        ExecutionFileScenarioStatusData ={}
        ExecutionFileScenarioStatusData[Scenario] = Sataus
        json.dump(ExecutionFileScenarioStatusData,ExecutionFileScenarioStatusDataOBj,indent=4)
        MessageLogger.info(ExecutionFileScenarioStatusData)
    MessageLogger.info("Exit Function ................")
    ExecutionFileScenarioStatusDataOBj.close()
 """


def fn_getexecuationidbyfeaturename(FeatureName):
    MessageLogger.info(FeatureName)
    sqry = "SELECT MAX(ExecutionID) AS ExecutionID FROM FeatureStepDataStore WHERE FeatureName = ?"
    # cursor = conn.cursor()
    cursor.execute(sqry, (FeatureName,))
    result = cursor.fetchone()
    executionid = 0

    if result:
        executionid = str(result[0])
        MessageLogger.info("Execution ID:" + str(executionid))
    else:
        MessageLogger.info("No results found for the given FeatureName.")

    # sqry ="SELECT max(ExecutionID) as ExecutionID FROM FeatureStepDataStore where FeatureName = ?"
    # cursor.execute(sqry,(FeatureName,))
    # executionid = str(cursor.fetchone()[0])
    MessageLogger.info("Execution ID-outside:" + str(executionid))
    return executionid


def fn_InsertFeatureStepExecutionInfo(ExecutionID,FeatureName,ScenarioName,StepName,Status):
    
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepExecutionInfo {ExecutionID},'{FeatureName}','{ScenarioName}','{StepName}','{Status}'"
    MessageLogger.info(sql)
    cursor.execute(sql)


def fn_InsertFeatureStepDataStore(ExecutionID, FeatureName, ScenarioName, VariableName, VariableValue):
    MessageLogger.info(f"Saving data to datastore for {VariableName} with {VariableValue}")
    sql = f"SET NOCOUNT ON EXEC USP_PDF_InsertFeatureStepDataStore {ExecutionID}, '{FeatureName}', '{ScenarioName}', '{VariableName}', '{VariableValue}'"
    # MessageLogger.info("fn_InsertFeatureStepDataStore" + sql)
    # MessageLogger.info(VariableName)
    # MessageLogger.info(VariableValue)
    cursor.execute(sql)
    FeatureStepDataStore[f'{VariableName}'] = VariableValue


def fn_GetValueFromDataStore(ExecutionID,  VariableName):
    MessageLogger.info(f"Inside fn_GetValueFromDataStore for {VariableName}")
    if VariableName in FeatureStepDataStore:
        MessageLogger.info(VariableName)
        return str(FeatureStepDataStore[VariableName]).strip()
    else:
        sql = f"SET NOCOUNT ON EXEC USP_PDF_GetValueFromDataStore {ExecutionID},'{VariableName}'"
        MessageLogger.info(sql)
        cursor.execute(sql)
        Value = cursor.fetchone().VariableValue
        MessageLogger.info(Value)
        return str(Value).strip()


def fn_GetCurrentCommonTNPDate():
    cursor.execute("SELECT TOP 1 CONVERT(date,trantime) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate


def fn_GetAgingDate(Days):
    cursor.execute(f"SELECT TOP 1 CONVERT(date,DATEADD(day,{Days},tnpdate)) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    return tnpdate
    

def fn_GetTxnDetails(ExecutionID, VariableName, FeatureName):
    sql = f"SET NOCOUNT ON EXEC USP_GETTxnDetails_Behave {ExecutionID},'{VariableName}','{FeatureName}'"
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx].strip()
            results.append(result_dict)
        # Convert the results to JSON
        result_json = results
    except Exception as e:
        MessageLogger.error("we are here in error"+str(e))
        result_json= {}

    return result_json


def fn_setexeutionID(fetaurename,action):
    if action == "new":
        EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
        EXECUTION_ID = cursor.fetchone().MaxExecutionID
        set_global_EXECUTION_ID(EXECUTION_ID)
        MessageLogger.info("fn_setexeutionID" + str(EXECUTION_ID))
        return EXECUTION_ID
    elif re.match(r'^\d+$', action):
        EXECUTION_ID = fetaurename
        set_global_EXECUTION_ID(EXECUTION_ID)
        MessageLogger.info("custom EXECUTION_ID for rerun" + str(EXECUTION_ID))
    else:
        MessageLogger.info(fetaurename)
        MessageLogger.info("Rohit" + action)
        sql = f"SELECT TOP 1 executionid FROM FeatureStepExecutionInfo (NOLOCK) WHERE FeatureName = '{fetaurename}' ORDER BY id DESC"
        MessageLogger.info(sql)
        cursor.execute(sql)
        row =  cursor.fetchone()
        if row is None:
            EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
            EXECUTION_ID = cursor.fetchone().MaxExecutionID
            set_global_EXECUTION_ID(EXECUTION_ID)
            MessageLogger.info("fn_setexeutionID" + str(EXECUTION_ID))
        else:
            EXECUTION_ID = str(row[0])
            MessageLogger.info("EXECUTION_ID for rerun" + str(EXECUTION_ID))
            set_global_EXECUTION_ID(EXECUTION_ID)
        return EXECUTION_ID


def fn_GetAccountDetails(AccountNumber):
    MessageLogger.info("Inside fn_GetAccountDetails")
    MessageLogger.info(AccountNumber)
    sql = f"EXEC USP_AccountDetails @AccountNumber = '{AccountNumber}'"
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))
        result_json = {}

    MessageLogger.info(result_json)
    return result_json


def fn_GetPlanDetails(AccountNumber):
    MessageLogger.info("Inside fn_GetPlanDetails")
    sql = f"EXEC USP_AccountDetails @AccountNumber = '{AccountNumber}', @AccountData = 0, @CPSData = 1"
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))
        result_json = {}

    return result_json


def fn_UpdateCITable(AccountNumber, tableName, field, value):
    MessageLogger.info(f"Updating {tableName} for {field} with {value}")
    sql = f"UPDATE {tableName} SET {field} = {value} WHERE AccountNumber = '{AccountNumber}'"
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))


def fn_GetAccountDataForTxnPosting(AccountNumber):
    MessageLogger.info(f"Inside fn_GetAccountDataForTxnPosting for AccountNumber: {AccountNumber}")
    sql = (f"SELECT BP.acctID, TRY_CONVERT(VARCHAR(100), LAD, 20) LAD, "
           f"RTRIM(AccountNumber) AccountNumber, TestAccount, "
           f"TRY_CONVERT(VARCHAR(100), AmountOfTotalDue, 2) AmountOfTotalDue "
           f"FROM BSegment_Primary BP WITH (NOLOCK) "
           f"JOIN BSegment_Secondary BS WITH (NOLOCK) ON BP.acctID = BS.acctID "
           f"JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON BCC.acctID = BS.acctID "
           f"WHERE AccountNumber = '{AccountNumber}'")
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)
        # Convert the results to JSON
        result_json = results
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))
        result_json = {}
    MessageLogger.info(result_json)
    return result_json


def fn_SetTxnTimeForAccount(ExecutionID, TxnTime):
    VariableName = "MyAccountNumber"
    sql = f"SET NOCOUNT ON EXEC USP_PDF_GetValueFromDataStore {ExecutionID},'{VariableName}'"
    MessageLogger.info(sql)
    cursor.execute(sql)
    Value = cursor.fetchone().VariableValue
    MessageLogger.info(Value)
    AccountNumber = str(Value).strip()
    TranTime = ""
    PostTime = ""
    CalcTime = ""
    date_format = "%Y-%m-%d %H:%M:%S"
    IsTestAccount = False

    if TxnTime == "posttime":
        TxnTime = ""

    AccountDetails = fn_GetAccountDataForTxnPosting(AccountNumber)
    AccountData = AccountDetails[0]
    MessageLogger.info(AccountData)

    if AccountData:
        if AccountData["TestAccount"] == 1:
            IsTestAccount = True
            LAD = AccountData["LAD"]
            datetime_obj = datetime.strptime(LAD, date_format)
            one_second = timedelta(seconds=1)
            CalcTime_date = datetime_obj + one_second
            CalcTime = CalcTime_date.strftime("%Y%m%d%H%M%S")

    if IsTestAccount:
        if TxnTime == "":
            PostTime = TranTime = CalcTime
        else:
            PostTime = CalcTime
            TranTime = TxnTime
    else:
        if TxnTime != "":
            TranTime = TxnTime

    MessageLogger.info(f"IsTestAccount: {IsTestAccount}")
    MessageLogger.info(f"TranTime: {TranTime}")
    MessageLogger.info(f"PostTime: {PostTime}")

    return IsTestAccount, TranTime, PostTime



