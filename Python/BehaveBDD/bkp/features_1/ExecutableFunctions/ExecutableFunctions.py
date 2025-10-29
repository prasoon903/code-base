import requests 
import pyodbc 
import json
import os 
import uuid
from datetime import datetime

from .DataManager import fn_GetValueFromDataStore,fn_GetCurrentCommonTNPDate
from .DataBaseConnections import *



Configuration =  json.load(open("Configuration/Configuration.json"))
APINAmeEndPointMapping = json.load(open("Configuration/APINameEndPointMapping.json"))
""" DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'] ,
                        Server = Configuration['DBServer'],
                        Database = Configuration['CoreIssueDBName'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        ) """
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
    APIUrl  = Configuration['APIDomainUrl']+APINAmeEndPointMapping[APIName]
    APIJson = json.load(open(f"JsonPayload/{APIName}.json"))
    if "UserID".upper() not in PayLoad.keys() :
        if "PLAT" in str(Environment.Environment_Name).upper():
            PayLoad["UserID"] = "PlatCall"
        else:
            PayLoad["UserID"] = "JazzCall"
            

    APIJson.update(PayLoad)

    print(APIJson)
    
    replace_guids(APIJson)

    headers={"Accept": "application/json", "Content-Type": "application/json"}
    #print(APIJson)
    response = requests.post(APIUrl,data=json.dumps(APIJson),headers=headers)
    return response

def fn_CheckErrorFound(Response):
    return Response['ErrorFound'],Response['ErrorNumber'],Response['ErrorMessage']
    
def fn_CreateJsonPayloadUsingTable(ExecutionID ,Table):
    PayLoad = {}
    assert len(Table[0])==2,"We are not able to create Key Value because length of table is greater than 2"
    for row in Table:
        if str(row[1]).startswith("@"):
            Value= fn_GetValueFromDataStore(ExecutionID,str(row[1])[1:])
            PayLoad[row[0]] = Value
        else:
            PayLoad[row[0]] = row[1]
    return PayLoad

def fn_SetDateInTview(Month,Date,Year):
    if len(Date)==1:
        Date="0"+Date
    if len(Month)==1:
        Month="0"+Month

    virtualtime = Month+"/"+Date+"/"+Year
    print(virtualtime)
    TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
    os.system(TviewdateSetCmd)

def fn_checkAgingDate(afterAgingDate ):

    CurrentTnpDate =  fn_GetCurrentCommonTNPDate()

    if afterAgingDate==CurrentTnpDate:
        return True
    print(f"Current TnpDate is {CurrentTnpDate}  after Aging Date {afterAgingDate}")
    return False


def fn_GetKeyValueFromJsonFile(APIName,tagName):
    APIJson = json.load(open(f"JsonPayload/{APIName}.json"))
    return APIJson[tagName]
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

    