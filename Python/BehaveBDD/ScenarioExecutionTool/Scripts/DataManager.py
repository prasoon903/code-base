# import json
# import os
from datetime import datetime, timedelta
import re
import time
# import pyodbc
# import json
# from .ExectableFunction import *
from Scripts.DataBaseConnections import *
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import set_global_EXECUTION_ID
from Scripts.MiniDice import fn_SaveProcessDetails
import psutil
import uuid
from Scripts.HelperFunction import generate_insert_statement_for_PII


CurrentTime = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")

# RootPath  = os.environ.get('RootPath')
# RootPath = f'E:\\Python\\BehaveBDD\\features'
Configuration = c.Configuration
RootPath = c.BasePath

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
#ExecutionStepDataWareHouseObj = open(f"DataStore\\ExecutionStepDataWareHouse_{CurrentTime}.json","w+")
"""   
def fn_WriteScenarioStaus(Scenario,Sataus):


    if os.path.isfile(f"DataStore\\ExecutionFileScenarioStatusData_{CurrentTime}.json"):
            ExecutionFileScenarioStatusDataReadOBj = open(f"DataStore\\ExecutionFileScenarioStatusData_{CurrentTime}.json","r")
            Data = ExecutionFileScenarioStatusDataReadOBj.read()
            MessageLogger.info(Data)
            ExecutionFileScenarioStatusDataReadOBj.close()

            ExecutionFileScenarioStatusDataOBj = open(f"DataStore\\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
            
            ExecutionFileScenarioStatusData = json.loads(Data)
            ExecutionFileScenarioStatusData[Scenario] = Sataus
            json.dump(ExecutionFileScenarioStatusData,ExecutionFileScenarioStatusDataOBj,indent=4)
        
            MessageLogger.info(ExecutionFileScenarioStatusData)
    else:
        ExecutionFileScenarioStatusDataOBj = open(f"DataStore\\ExecutionFileScenarioStatusData_{CurrentTime}.json","w")
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


def fn_InsertFeatureStepExecutionInfo(ExecutionID, FeatureName, ScenarioName, StepName, Status):
    
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
    result = ""
    if VariableName in FeatureStepDataStore:
        MessageLogger.info(VariableName)
        return str(FeatureStepDataStore[VariableName]).strip()
    else:
        sql = f"SET NOCOUNT ON EXEC USP_PDF_GetValueFromDataStore {ExecutionID},'{VariableName}'"
        MessageLogger.info(sql)
        cursor.execute(sql)
        Value = cursor.fetchone().VariableValue
        # MessageLogger.info(Value)
        result = str(Value).strip()
        MessageLogger.info(result)
        return result


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
                if row[idx] is not None:
                    result_dict[column[0]] = row[idx].strip()
            results.append(result_dict)
        # Convert the results to JSON
        result_json = results
    except Exception as e:
        MessageLogger.error("we are here in error"+str(e))
        result_json= {}

    return result_json


def fn_setexeutionID(fetaurename, action):
    loopCount = 0
    if action == "new":
        EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
        EXECUTION_ID = cursor.fetchone().MaxExecutionID
        while EXECUTION_ID <= 0:
            time.sleep(3)
            EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
            EXECUTION_ID = cursor.fetchone().MaxExecutionID
            loopCount = loopCount + 1
            if loopCount > 10:
                break
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
        row = cursor.fetchone()
        if row is None:
            EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
            EXECUTION_ID = cursor.fetchone().MaxExecutionID
            while EXECUTION_ID <= 0:
                time.sleep(3)
                EXECUTION_ID = cursor.execute("SET NOCOUNT ON EXEC USP_PDF_GetMaxExecutionID")
                EXECUTION_ID = cursor.fetchone().MaxExecutionID
                loopCount = loopCount + 1
                if loopCount > 10:
                    break
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

    # MessageLogger.info(result_json)
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


def fn_GetDataCITable(tableName, columnName, key, value):
    MessageLogger.info(f"Getting results from {tableName} for {columnName} on the basis of {key} having value {value}")
    # columnMapping = json.load((open(RootPath + f"\JsonPayload/{tableName}.json")))
    json_file_path = RootPath + f"\\JsonPayload\\{tableName}.json"
    # MessageLogger.info(f"json_file_path: {json_file_path}")
    # columnMapping = []

    if os.path.exists(json_file_path):
        try:
            with open(json_file_path) as json_file:
                columnMapping = json.load(json_file)
        except Exception as e:
            MessageLogger.error(f"Error loading column mapping from {json_file_path}: {e}")
    else:
        MessageLogger.error(f"JSON file not found at path: {json_file_path}")
        columnMapping = {}

    results = []
    result = ''
    output = []
    if tableName.lower() == 'bsegment':
        sql = (f"SELECT TRY_CONVERT(VARCHAR(100), acctId, 20) acctId "
               f"FROM BSegment_Primary WITH (NOLOCK)"
               f" WHERE {key} = '{value}'")
        MessageLogger.info(sql)
        try:
            cursor.execute(sql)
            outputdata = []
            # MessageLogger.info("we are here")
            for row in cursor.fetchall():
                output_dict = {}
                for idx, column in enumerate(cursor.description):
                    # MessageLogger.info("we are here inside loop")
                    output_dict[column[0]] = row[idx]
                outputdata.append(output_dict)
            # Convert the results to JSON
            AccountData = outputdata[0]
            MessageLogger.info(f"AccountData: {AccountData}")
            if AccountData:
                key = 'acctId'
                value = AccountData['acctId']
                # MessageLogger.info(f"AccountData=> {AccountData}")
        except Exception as e:
            MessageLogger.error("we are here in error for finding the account data" + str(e))

    for columns in columnName:
        # MessageLogger.info(f"columns: {columns}")
        if columns.lower() in columnMapping:
            table = columnMapping[f"{columns.lower()}"]
            # MessageLogger.info(f"table: {table}")
            sql = (f"SELECT TRY_CONVERT(VARCHAR(100), {columns}, 20) {columns} "
                   f"FROM {table} WITH (NOLOCK)"
                   f" WHERE {key} = {value}")
            MessageLogger.info(sql)
        else:
            sql = (f"SELECT TRY_CONVERT(VARCHAR(100), {columns}, 20) {columns} "
                   f"FROM {tableName} WITH (NOLOCK)"
                   f" WHERE {key} = {value}")
            MessageLogger.info(sql)
        try:
            cursor.execute(sql)
            # MessageLogger.info("we are here")
            for row in cursor.fetchall():
                result_dict = {}
                for idx, column in enumerate(cursor.description):
                    # MessageLogger.info("we are here inside loop")
                    result_dict[column[0]] = row[idx]
                results.append(result_dict)
            # Convert the results to JSON
            result_json = results
            MessageLogger.info(f"result_json: {result_json}")
            result1 = result_json[0][f'{columns}']
            result = result1.replace(",", "")
            MessageLogger.info(f"Result: {result}")
            result_dict = {f"{columns}": f"{result}"}
            output.append(result_dict)
            MessageLogger.info(f"Output: {output[0]}")
        except Exception as e:
            MessageLogger.error("we are here in error " + str(e))
    return output


def fn_SaveAPIResponse(folder_name, file_name, APIName, JsonResponse):
    MessageLogger.info(f"Saving account plan details for {APIName}")
    response = JsonResponse
    file_path = os.path.join(RootPath, "JsonPayload")
    file_path = os.path.join(file_path, folder_name)
    if not os.path.exists(file_path):
        os.makedirs(file_path)
    file_name = (
        f"{APIName}_{file_name}.json"
    )
    file_path = file_path + "\\" + file_name
    # JsonData = context.response.json()
    # context.jsonData = context.response.json()
    with open(file_path, "w") as json_file:
        json.dump(response, json_file, indent=2)


def fn_UpdateControlTable(Key, KeyValue, tableName, field, value):
    MessageLogger.info(f"Updating {tableName} for {field} with {value}")
    sql = f"UPDATE {tableName} SET {field} = '{value}' WHERE {Key} = '{KeyValue}'"
    MessageLogger.info(sql)
    try:
        cursor.execute(sql)
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))


def fn_CheckARSystemHS():
    MessageLogger.info(" Checking ARSystemHS ")
    sql = f"EXEC USP_CheckARSystemHS_Behave"
    try:
        cursor.execute(sql)
    except Exception as e:
            MessageLogger.error("we are here in error " + str(e))


def fn_GetProcessDetails():
    hostmachinename = os.getenv('COMPUTERNAME')
    sql = f"""
    SELECT RTRIM(Hostname) Hostname, RTRIM(Program_name) Program_name, RTRIM(hostprocess) hostprocess, RTRIM(nt_username) nt_username, RTRIM(loginame) loginame 
    FROM SYSProcesses 
    WHERE Program_name IS NOT NULL
    and Program_name <> ''
    and program_name not in ('.Net SqlClient Data Provider','KMS')
    and program_name not like 'SQLAgent -%'
    and program_name not like 'Repl-%'
    and program_name not like 'Microsoft SQL Server Management%'
    --and program_name like '%APP_wfTnpNad%'
    and hostname like '%{hostmachinename}%'
    GROUP BY Program_name,Hostname,hostprocess,nt_username,loginame
    order by hostname, program_name
    """
    try:
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                fn_SaveProcessDetails(str(r.Program_name), str(r.hostprocess))
    except Exception as e:
            MessageLogger.error("we are here in error " + str(e))


def CheckProcessRunningOnDB(ProcessName):
    hostmachinename = os.getenv('COMPUTERNAME')
    check = False
    processID  = None
    sql = f"""
    SELECT RTRIM(Hostname) Hostname, RTRIM(Program_name) Program_name, RTRIM(hostprocess) hostprocess, RTRIM(nt_username) nt_username, RTRIM(loginame) loginame 
    FROM SYSProcesses 
    WHERE Program_name IS NOT NULL
    and Program_name <> ''
    and program_name not in ('.Net SqlClient Data Provider','KMS')
    and program_name not like 'SQLAgent -%'
    and program_name not like 'Repl-%'
    and program_name not like 'Microsoft SQL Server Management%'
    --and program_name like '%APP_wfTnpNad%'
    and hostname like '%{hostmachinename}%'
    GROUP BY Program_name,Hostname,hostprocess,nt_username,loginame
    order by hostname, program_name
    """
    try:
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                if ProcessName == str(r.Program_name):
                    check = True
                    processID = str(r.hostprocess)
                    break
        if processID is not None:
            check = psutil.pid_exists(int(processID))   
        return check
    except Exception as e:
            MessageLogger.error("we are here in error " + str(e))
            return None


def fn_TakeDBbackup(featureName, scenarioName):
    cwd = Configuration['BackupFolderLocation']
    bkpfolderName = os.path.join(cwd, featureName)
    if os.path.exists(bkpfolderName) == False:
        os.mkdir(bkpfolderName)
    bkpfolderName = os.path.join(cwd, featureName, scenarioName)
    if os.path.exists(bkpfolderName) == False:
        os.mkdir(bkpfolderName)
    bkpfolderName = os.path.join(cwd, featureName, scenarioName, "DBBackup_"+str(datetime.now().strftime("%Y_%m_%d_%H_%M_%S")))
    if os.path.exists(bkpfolderName) == False:
        os.mkdir(bkpfolderName)

    backupScript = "USE MASTER\n" 
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREAUTH']+"] TO  DISK = N'"+bkpfolderName+"\\CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREAUTH']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREISSUE']+"] TO  DISK = N'"+bkpfolderName+"\\CI.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREISSUE']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORELIBRARY']+"] TO  DISK = N'"+bkpfolderName+"\\CL.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORELIBRARY']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORECREDIT']+"] TO  DISK = N'"+bkpfolderName+"\\CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECREDIT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREAPP']+"] TO  DISK = N'"+bkpfolderName+"\\CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREAPP']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORECOLLECT']+"] TO  DISK = N'"+bkpfolderName+"\\CC.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECOLLECT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CISECONDARY']+"] TO  DISK = N'"+bkpfolderName+"\\CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECOLLECT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n" 
    
    f = open(os.path.join(RootPath, "SQL\\Backupscript.sql"),'w')
    f.write(backupScript)
    f.close()
    qry = f"sqlcmd -S {Configuration['DBServer']} -i {RootPath}\\SQL\\Backupscript.sql  -o {RootPath}\\SQL\\Backupscript.out -b -d master\n echo %ERRORLEVEL%"
    res = os.system(qry+' &')
    return res


def generate_random_clientid():
    clientid = str(uuid.uuid4())
    sql = generate_insert_statement_for_PII(clientid, Configuration['YourDBNames']['COREISSUE'])
    
    try:
        cursor.execute(sql)
        return clientid
    except Exception as e:
        MessageLogger.error("we are here in error " + str(e))
        return clientid


def fn_GetPendingTxnOfAccount(AccountID):
    MessageLogger.info("Inside fn_GetPendingTxnOfAccount")
    MessageLogger.info("")
    ID = 0
    sql = f"""SELECT TranID FROM CommonTNP WITH (NOLOCK) WHERE acctID = {AccountID} AND TranID > 0
            UNION ALL
            SELECT TranID FROM CommonAP WITH (NOLOCK) WHERE acctID = {AccountID} AND TranID > 0"""
    # MessageLogger.debug(sql)
    try:
        cursor.execute(sql)
        ID = cursor.fetchone()
        if ID is not None:
            temp = str(ID[0])
            MessageLogger.info("Job in Process (TNP/APJob)" + temp)
        while ID is not None:
            time.sleep(5)
            MessageLogger.info("Waiting for 5 seconds")
            cursor.execute(sql)
            ID = cursor.fetchone()
            if ID is not None:
                temp = str(ID[0])
                MessageLogger.info("Job in Process (TNP/APJob)" + temp)
        else:
            MessageLogger.info("Account creation successful and its jobs are processed.")
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))


def get_ntdipsute_tranid(DisputeID):
    TranID = ''
    sql = f"SELECT DisputeGeneratedTranId TranID FROM NonTxnDisputeStatusLog WITH(NOLOCK) WHERE DisputeID = '{DisputeID}' ORDER BY Skey DESC"
    try:
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                TranID = r.TranID
        
        return TranID
    except Exception as e:
        MessageLogger.error("we are here in error" + str(e))
        return None