import requests 
import pyodbc 
import json
import os 
import uuid
from datetime import datetime
import pandas as pd
from pip._internal.utils.misc import tabulate
import Scripts.Config as c

from Scripts.DataManager import fn_GetValueFromDataStore, fn_GetCurrentCommonTNPDate, fn_getexecuationidbyfeaturename
from Scripts.DataBaseConnections import *
from Scripts.GetLogger import MessageLogger


# RootPath  = os.environ.get('RootPath')
# RootPath = f'E:\\Python\\BehaveBDD\\features'
Configuration = c.Configuration
RootPath = c.BasePath

# Configuration =  json.load(open(RootPath+"\Configuration/Configuration.json"))
APINAmeEndPointMapping = json.load(open(RootPath+"\Configuration/APINameEndPointMapping.json"))
"""DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'],
                        Server = Configuration['DBServer'],
                        Database = Configuration['YourDBNames']['COREISSUE'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        )
"""
PlatformCodeloc = Configuration['PlatformCodeloc']


Cursor = DBCon.cursor()

Cursor.execute("SELECT TOP 1 Environment_Name FROM CPS_ENVIRONMENT WITH(NOLOCK)")
Environment =  Cursor.fetchone()



def replace_guids(obj):
    if isinstance(obj, dict):
        for key, value in obj.items():
            if isinstance(value, (str, bytes)):
                obj[key] = value.replace("{{$guid}}", str(uuid.uuid1()))
            elif isinstance(value, (dict, list)):
                replace_guids(value)
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            if isinstance(item, (str, bytes)):
                obj[i] = item.replace("{{$guid}}", str(uuid.uuid1()))
            elif isinstance(item, (dict, list)):
                replace_guids(item)


def fn_HitAPI(APIName,PayLoad):
    if APIName == "AccountSummary":
        APIUrl = Configuration['APIDomainUrlAS'] + APINAmeEndPointMapping[APIName]
    else:
        APIUrl  = Configuration['APIDomainUrl']+APINAmeEndPointMapping[APIName]
    APIJson = json.load(open(RootPath+f"\JsonPayload/{APIName}.json"))
    if "UserID".upper() not in PayLoad.keys() :
        if "PLAT" in str(Environment.Environment_Name).upper():
            PayLoad["UserID"] = "PlatCall"
        else:
            PayLoad["UserID"] = "JazzCall"
            

    APIJson.update(PayLoad)
    replace_guids(APIJson)

    headers={"Accept": "application/json", "Content-Type": "application/json"}
    # MessageLogger.info(APIJson)
    response = requests.post(APIUrl,data=json.dumps(APIJson),headers=headers)
    # MessageLogger.info(response)
    return response


def fn_HitAPIbyParam(APIName, param1):
    if APIName == "AccountSummary":
        APIUrl = Configuration['APIDomainUrlAS'] + APINAmeEndPointMapping[APIName]
    else:
        APIUrl = Configuration['APIDomainUrl'] + APINAmeEndPointMapping[APIName]
    APIJson = json.load(open(RootPath + f"\JsonPayload/{APIName}.json"))
    #if "UserID".upper() not in PayLoad.keys():
    if "PLAT" in str(Environment.Environment_Name).upper():
        APIJson["UserID"] = "PlatCall"
    else:
        APIJson["UserID"] = "JazzCall"

    if APIName == "AccountSummary":
        APIJson["AccountNumber"] = param1

    #APIJson.update(PayLoad)

    replace_guids(APIJson)

    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    # MessageLogger.info(APIJson)
    response = requests.post(APIUrl, data=json.dumps(APIJson), headers=headers)
    return response


def fn_CheckErrorFound(Response):
    return Response['ErrorFound'],Response['ErrorNumber'],Response['ErrorMessage']
    
def fn_CreateJsonPayloadUsingTable(ExecutionID ,Table):
    MessageLogger.info("fn_CreateJsonPayloadUsingTable--1111")
    PayLoad = {}
    assert len(Table[0])==2,"We are not able to create Key Value because length of table is greater than 2"
    for row in Table:
        if str(row[1]).startswith("@"):
            MessageLogger.info("fn_CreateJsonPayloadUsingTable--2222")
            MessageLogger.info(str(row[1])[1:])
            # MessageLogger.info(str(row[1]))
            Value= fn_GetValueFromDataStore(ExecutionID,str(row[1])[1:])
            PayLoad[row[0]] = Value
            # MessageLogger.info(row[1])
            MessageLogger.info(Value)
        else:
            PayLoad[row[0]] = row[1]
            MessageLogger.info(row[1])
    return PayLoad

def fn_SetDateInTview(Month,Date,Year):
    if len(Date)==1:
        Date="0"+Date
    if len(Month)==1:
        Month="0"+Month

    virtualtime = Month+"/"+Date+"/"+Year
    MessageLogger.info(virtualtime)
    TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
    os.system(TviewdateSetCmd)

def fn_checkAgingDate(afterAgingDate ):

    CurrentTnpDate =  fn_GetCurrentCommonTNPDate()

    if afterAgingDate==CurrentTnpDate:
        return True

    if afterAgingDate<=CurrentTnpDate:
        MessageLogger.info(f"Current TnpDate is {CurrentTnpDate} is lesser or equal to after Aging Date {afterAgingDate} ")
        return True
    MessageLogger.info(f"Current TnpDate is {CurrentTnpDate}  after Aging Date {afterAgingDate}")
    return False


def fn_GetKeyValueFromJsonFile(APIName,tagName):
    APIJson = json.load(open(RootPath+f"\JsonPayload/{APIName}.json"))
    return APIJson[tagName]

def fn_getmaxexecuationidforfeature(featurename):
    ExecutionID = fn_getexecuationidbyfeaturename(featurename)
    return ExecutionID


def fn_TakeDBbackup():
    cwd =  Configuration['BackupFolderLocation']
    bkpfolderName = os.path.join(cwd,"DBBackup_"+str(datetime.now().strftime("%Y_%m_%d_%H_%M_%S")))
    os.mkdir(bkpfolderName)

    backupScript = "USE MASTER\n" 
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREAUTH']+"] TO  DISK = N'"+bkpfolderName+"\\CAuth.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREAUTH']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREISSUE']+"] TO  DISK = N'"+bkpfolderName+"\\CI.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREISSUE']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORELIBRARY']+"] TO  DISK = N'"+bkpfolderName+"\\CL.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORELIBRARY']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORECREDIT']+"] TO  DISK = N'"+bkpfolderName+"\\CoreCredit.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECREDIT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['COREAPP']+"] TO  DISK = N'"+bkpfolderName+"\\CoreApp.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['COREAPP']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CORECOLLECT']+"] TO  DISK = N'"+bkpfolderName+"\\CC.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECOLLECT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n"
    backupScript = backupScript+"BACKUP DATABASE["+Configuration['YourDBNames']['CISECONDARY']+"] TO  DISK = N'"+bkpfolderName+"\\CI_Secondary.bak' WITH NOFORMAT, INIT,  NAME = N'"+Configuration['YourDBNames']['CORECOLLECT']+"-Full Database Backup' , SKIP, NOREWIND, NOUNLOAD,  STATS = 10\n" 
    
    f = open("ExecutableFunctions\\sqlfiles\\Backupscript.sql",'w')
    f.write(backupScript)
    f.close()
    qry =f"sqlcmd -S {Configuration['DBServer']} -i ExecutableFunctions\\sqlfiles\\Backupscript.sql  -o ExecutableFunctions\\sqlfiles\\Backupscript.out -b -d master\n echo %ERRORLEVEL%"
    res = os.system(qry+' &')
    return res



def fn_GetAPIResponseTags(APIName):
    json_data = json.load(open(RootPath + f"\JsonPayload/Response_{APIName}.json"))
    return json_data

def fn_GetTableofResponseTags(json_data):
    # json_data = json.load(open(RootPath+f"\JsonPayload/Response_{APIName}.json"))
    #df = pd.DataFrame(APIJson)
    #table_var = df.to(index=False)
    MessageLogger.info(json_data)
    # table_var = [(json_data["TagName"][i], json_data["VariableName"][i]) for i in range(len(json_data["VariableName"]))]
    table_var = [('TagName', 'VariableName')] + list(zip(json_data["TagName"], json_data["VariableName"]))
    # MessageLogger.info the table
    MessageLogger.info("Table after",table_var)
    return table_var

def fn_TablefromJSON(json_data):
    #df = pd.DataFrame(APIJson)
    #table_var = df.to(index=False)
    #table_var = [(json_data["TagName"][i], json_data["VariableName"][i]) for i in range(len(json_data["TagName"]))]
    # Combine the headers and data into a list of tuples
    # table_var = list(zip(['TagName', 'VariableName'], json_data["TagName"], json_data["VariableName"]))
    table_var =  list(zip(json_data["TagName"], json_data["VariableName"]))
    # MessageLogger.info the table
    MessageLogger.info(table_var)
    return table_var

def fn_OverrideTagName(json_data,oldname,newname):
    # Find the index of the "TransactionID" tag in the "TagName" list
    MessageLogger.info("json_data befire",json_data)
    try:
        for i in range(len(json_data["VariableName"])):
            if json_data["VariableName"][i] == oldname:
                json_data["VariableName"][i] = newname
    except ValueError:
        index_to_override = None

    # Convert the JSON data back to a JSON string
    overridden_json = json.dumps(json_data, indent=2)
    MessageLogger.info("json_data after", json_data)
    return json_data


