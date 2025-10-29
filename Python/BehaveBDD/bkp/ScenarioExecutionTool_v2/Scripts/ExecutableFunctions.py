import re
import time

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

# MessageLogger.info(APINAmeEndPointMapping)


Cursor = DBCon.cursor()

Cursor.execute("SELECT TOP 1 Environment_Name FROM CPS_ENVIRONMENT WITH(NOLOCK)")
Environment = Cursor.fetchone()


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


def fn_HitAPI(APIName, PayLoad):
    MessageLogger.info("fn_HitAPI: " + str(PayLoad))
    MessageLogger.info("APIName: " + APIName)
    response = {}
    APIUrl = ""
    try:
        if APIName.lower() == "accountsummary":
            APIName = "AccountSummary"
            if APINAmeEndPointMapping[APIName] is not None:
                MessageLogger.info(f"API end point: {APINAmeEndPointMapping[APIName]}")
                APIUrl = Configuration['APIDomainUrlAS'] + APINAmeEndPointMapping[APIName]
            else:
                MessageLogger.error(f"{APIName} is not mapped with valid end point")
        else:
            if APINAmeEndPointMapping[APIName] is not None:
                MessageLogger.info(f"API end point: {APINAmeEndPointMapping[APIName]}")
                APIUrl = Configuration['APIDomainUrl']+APINAmeEndPointMapping[APIName]
            else:
                MessageLogger.error(f"{APIName} is not mapped with valid end point")

        JsonPath = RootPath + f"\JsonPayload/{APIName}.json"
        MessageLogger.info(f"Path to API json: {JsonPath}")
        if os.path.exists(JsonPath) and APINAmeEndPointMapping[APIName] is not None:
            APIJson = json.load(open(JsonPath))
            if "UserID".upper() not in PayLoad.keys():
                if "PLAT" in str(Environment.Environment_Name).upper():
                    PayLoad["UserID"] = "PlatCall"
                else:
                    PayLoad["UserID"] = "JazzCall"

            APIJson.update(PayLoad)
            replace_guids(APIJson)

            # MessageLogger.info(APIUrl)

            headers = {"Accept": "application/json", "Content-Type": "application/json"}
            # MessageLogger.info(APIJson)
            response = requests.post(APIUrl, data=json.dumps(APIJson), headers=headers)
            # MessageLogger.info(response)
        else:
            MessageLogger.error("API Json not configured on : " + JsonPath)
    except KeyError as e:
        MessageLogger.error(f"Error in hitting API: {e}")
    except FileNotFoundError as e:
        MessageLogger.error(f"Error in hitting API: {e}")
    except Exception as e:
        MessageLogger.error(f"Error in hitting API: {e}")
    return response


def fn_HitAPIbyParam(APIName, param1):
    response = {}
    if APIName == "AccountSummary":
        APIUrl = Configuration['APIDomainUrlAS'] + APINAmeEndPointMapping[APIName]
    else:
        APIUrl = Configuration['APIDomainUrl'] + APINAmeEndPointMapping[APIName]
    JsonPath = RootPath + f"\JsonPayload/{APIName}.json"
    if os.path.exists(JsonPath):
        APIJson = json.load(open(JsonPath))
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
    else:
        MessageLogger.error("API Json not configured on : " + JsonPath)
    return response


def fn_CheckErrorFound(Response):
    return Response['ErrorFound'], Response['ErrorNumber'], Response['ErrorMessage']


def fn_CreateJsonPayloadUsingTable(ExecutionID, Table):
    MessageLogger.info("fn_CreateJsonPayloadUsingTable--1111")
    PayLoad = {}
    assert len(Table[0]) == 2, "We are not able to create Key Value because length of table is greater than 2"
    for row in Table:
        if str(row[1]).startswith("@"):
            MessageLogger.info("fn_CreateJsonPayloadUsingTable--2222")
            MessageLogger.info(str(row[1])[1:])
            # MessageLogger.info(str(row[1]))
            Value = fn_GetValueFromDataStore(ExecutionID, str(row[1])[1:])
            PayLoad[row[0]] = Value
            # MessageLogger.info(row[1])
            # MessageLogger.info(Value)
        else:
            PayLoad[row[0]] = row[1]
            MessageLogger.info(row[1])
    return PayLoad


def fn_SetDateInTview(Month, Date, Year):
    if len(Date) == 1:
        Date = "0"+Date
    if len(Month) == 1:
        Month = "0"+Month

    virtualtime = Month+"/"+Date+"/"+Year
    MessageLogger.info(virtualtime)
    TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
    os.system(TviewdateSetCmd)


def fn_checkAgingDate(afterAgingDate):

    CurrentTnpDate = fn_GetCurrentCommonTNPDate()

    if afterAgingDate == CurrentTnpDate:
        return True

    if afterAgingDate <= CurrentTnpDate:
        MessageLogger.error(f"Current TnpDate is {CurrentTnpDate} is lesser or equal to after Aging Date {afterAgingDate} ")
        return True
    MessageLogger.debug(f"Current TnpDate is {CurrentTnpDate} after Aging Date {afterAgingDate}")
    return False


def fn_GetKeyValueFromJsonFile(APIName, tagName):
    APIJson = json.load(open(RootPath+f"\JsonPayload/{APIName}.json"))
    return APIJson[tagName]


def fn_getmaxexecuationidforfeature(featurename):
    ExecutionID = fn_getexecuationidbyfeaturename(featurename)
    return ExecutionID


def fn_TakeDBbackup():
    cwd = Configuration['BackupFolderLocation']
    bkpfolderName = os.path.join(cwd, "DBBackup_"+str(datetime.now().strftime("%Y_%m_%d_%H_%M_%S")))
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
    qry = f"sqlcmd -S {Configuration['DBServer']} -i ExecutableFunctions\\sqlfiles\\Backupscript.sql  -o ExecutableFunctions\\sqlfiles\\Backupscript.out -b -d master\n echo %ERRORLEVEL%"
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
    MessageLogger.info("Table after" + str(table_var))
    return table_var


def fn_TablefromJSON(json_data):
    #df = pd.DataFrame(APIJson)
    #table_var = df.to(index=False)
    #table_var = [(json_data["TagName"][i], json_data["VariableName"][i]) for i in range(len(json_data["TagName"]))]
    # Combine the headers and data into a list of tuples
    # table_var = list(zip(['TagName', 'VariableName'], json_data["TagName"], json_data["VariableName"]))
    table_var = list(zip(json_data["TagName"], json_data["VariableName"]))
    # MessageLogger.info the table
    MessageLogger.info(table_var)
    return table_var


def fn_OverrideTagName(json_data, oldname, newname):
    # Find the index of the "TransactionID" tag in the "TagName" list
    MessageLogger.info("json_data before" + str(json_data))
    try:
        for i in range(len(json_data["VariableName"])):
            if json_data["VariableName"][i] == oldname:
                json_data["VariableName"][i] = newname
    except ValueError:
        index_to_override = None

    # Convert the JSON data back to a JSON string
    overridden_json = json.dumps(json_data, indent=2)
    MessageLogger.info("json_data after" + str(json_data))
    return json_data

def fn_GetAPINAME(APINAME):
    MessageLogger.info("fn_GetAPINAME: " + str(APINAME))
    if APINAME in ("Payment Reversal", "Purchase", "Cash Purchase", "Payment", "Credit", "Return", "Debit"):
        APINAME = "PostSingleTransaction"
    elif APINAME == "AccountSummary":
        APINAME = "AccountSummary"
    elif APINAME == "Get StatementMetaData":
        APINAME = "StatementMetaData"
    elif APINAME.upper() == "account".upper():
        APINAME = "AccountCreation"
    elif APINAME == "addmanualstatus":
        APINAME = "AddManualStatus"
    elif APINAME == "removemanualstatus":
        APINAME = "RemoveManualStatus"
    elif APINAME == "dispute":
        APINAME = "InitiateDispute"
    elif APINAME == "disputeresolution":
        APINAME = "DisputeResolution"
    elif APINAME == "reageenrollment":
        APINAME = "ReageEnrollment"
    elif APINAME == "tcapenrollment":
        APINAME = "TCAPEnrollment"
    elif APINAME == "pwpenrollment":
        APINAME = "PWPEnrollment"
    elif APINAME == "accountupdate":
        APINAME = "AccountUpdate"

    return APINAME


def fn_ExtractData(input_string):
    MessageLogger.info("*********** |" + input_string + "| ********************************")
    API = ''
    Status = 0
    amount = 0
    txntype = ''
    digit = 0
    action = 0
    months = 0
    field = ''
    value = ''
    pattern1 = r'(\w+) for (\d+)'
    pattern2 = r'(\w+) of \$(\d+) for (\w+)'
    pattern3 = r'(\w+) of \$(\d+) for (\w+) with action (\d+)'
    pattern4 = r'(\w+) with \$(\d+) for (\d+) months'
    pattern5 = r'(\w+) for (\d+) months'
    pattern6 = r'(\w+) for (\w+) with (\w+)'

    patternMatched = 0

    match = False
    if not match:
        match = re.search(pattern3, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 3
    if not match:
        match = re.search(pattern2, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 2
    if not match:
        match = re.search(pattern4, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 4
    if not match:
        match = re.search(pattern6, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 6
    if not match:
        match = re.search(pattern5, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 5
    if not match:
        match = re.search(pattern1, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 1

    if match:
        group = len(match.groups())
        for i in range(1, group+1):
            MessageLogger.info("Group loop " + str(i))
            MessageLogger.info("match: " + str(match.group(i)))
            if i == 1:
                API = match.group(i)
                parts = API.split("_")
                if len(parts) > 0:
                    API = parts[0]
            elif i == 2:
                if patternMatched == 1:
                    Status = match.group(i)
                elif patternMatched in (2, 3, 4):
                    amount = match.group(i)
                elif patternMatched == 5:
                    months = match.group(i)
                elif patternMatched == 6:
                    field = match.group(i)
            elif i == 3:
                if patternMatched in (2, 3):
                    variable = match.group(i)
                    pattern12 = r'\d+'
                    match12 = re.search(pattern12, variable)
                    parts = variable.split('_')
                    if len(parts) >= 1:
                        txntype = parts[0]
                    if match12:
                        digit = match12.group(0)
                        MessageLogger.info(f"Extracted digit: {digit}")
                elif patternMatched == 4:
                    months = match.group(i)
                elif patternMatched == 6:
                    value = match.group(i)
            elif i == 4:
                action = match.group(i)

    MessageLogger.info("API: " + API)
    MessageLogger.info("Status: " + str(Status))
    MessageLogger.info("amount: " + str(amount))
    MessageLogger.info("txntype: " + txntype)
    MessageLogger.info("digit: " + str(digit))
    MessageLogger.info("action: " + str(action))
    MessageLogger.info("months: " + str(months))
    MessageLogger.info("field: " + field)
    MessageLogger.info("value: " + value)

    return API, Status, amount, txntype, digit, action, months, field, value


def extract_informationforPST(input_string):
    MessageLogger.info("*********** |" + input_string + "| ********************************")
    variable = ''
    digit = ''
    amount = ''
    by = ''
    cpm = ''
    at = ''
    txntype = ''
    patternMatched = 0
    match = False

    pattern1 = r'post (.+?) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) on cpm (\d+) at (\d+)'
    pattern2 = r'post (.+?) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) on cpm (\d+)'
    pattern3 = r'post (.+?) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) at (\d+)'
    pattern4 = r'post (.+?) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+)'

    if not match:
        match = re.search(pattern1, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 1
    if not match:
        match = re.search(pattern2, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 2
    if not match:
        match = re.search(pattern3, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 3
    if not match:
        match = re.search(pattern4, input_string)
        MessageLogger.info("match: " + str(match))
        patternMatched = 4

    MessageLogger.info("PatternMatched = " + str(patternMatched))

    # for i in range(len(match.groups())):
    #     MessageLogger.info(f"index: {i} with value: {match.group(i)}")

    if match:
        group = len(match.groups())
        for index in range(1, group + 1):
            # MessageLogger.info("Group loop " + str(index))
            # MessageLogger.info("match: " + str(match.group(index)))
            MessageLogger.info(f"index: {index} with value: {match.group(index)}")
            if index == 1:
                variable = match.group(index)
                pattern12 = r'\d+'
                match12 = re.search(pattern12, variable)
                parts = variable.split('_')
                if len(parts) >= 1:
                    txntype = parts[0]
                if match12:
                    digit = match12.group(0)
                    MessageLogger.info(f"Extracted digit: {digit}")
            elif index == 2:
                amount = match.group(index)
            elif index == 4:
                by = match.group(index).title()
            elif index == 5:
                if patternMatched in (1, 2):
                    cpm = match.group(index)
                elif patternMatched == 3:
                    at = match.group(index)
            elif index == 6:
                if patternMatched == 1:
                    at = match.group(index)

    return variable, digit, amount, by, cpm, at, txntype
#
# def extract_informationforPST(input_string):
#     MessageLogger.info("*********** |" + input_string + "| ********************************")
#     variable = ''
#     digit = ''
#     amount = ''
#     by = ''
#     cpm = ''
#     at = ''
#     txntype = ''
#     # Define a regular expression pattern to match the desired parts
#     # pattern1 = r'post (\w+) of \$(\d+) by trancode (\d+) on CPM (\d+) at (\w+)'
#     # pattern2 = r'post (\S+) of \$(\d+) by trancode (\d+) on CPM (\w+)'
#     # pattern3 = r'post (\w+) of \$(\d+) by trancode (\d+) at (\w+)'
#     # pattern4 = r'post (\w+) of \$(\d+) by trancode (\d+)'
#
#     pattern1 = r'post (\w+) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) on cpm (\w+) at (\w+)'
#     pattern2 = r'post (\S+) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) on cpm (\w+)'
#     pattern3 = r'post (\w+) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+) at (\w+)'
#     pattern4 = r'post (\w+) of \$(\w+(?:[+-]?\d+(\.\d+)?)?) by trancode (\w+)'
#
#     match = re.search(pattern1, input_string)
#     MessageLogger.info(match)
#     if not match:
#         MessageLogger.info("pattern2")
#         match = re.search(pattern2, input_string)
#         MessageLogger.info("match: " + str(match))
#     if not match:
#         MessageLogger.info("pattern3")
#         match = re.search(pattern3, input_string)
#         MessageLogger.info("match: " + str(match))
#     if not match:
#         MessageLogger.info("pattern4")
#         match = re.search(pattern4, input_string)
#         MessageLogger.info("match: " + str(match))
#
#     pattern5 = r'(\w+) (on cpm) (\w+)'
#     pattern6 = r'(\w+) (on cpm) (\w+) (at) (\w+)'
#     pattern7 = r'(\w+) (at) (\w+)'
#     match1 = re.search(pattern5, input_string)
#     MessageLogger.info("match1" + str(match1))
#     match2 = re.search(pattern6, input_string)
#     MessageLogger.info("match2" + str(match2))
#     match3 = re.search(pattern7, input_string)
#     MessageLogger.info("match3" + str(match3))
#
#     if match:
#         group = len(match.groups())
#         for i in range(1, group+1):
#             MessageLogger.info("Group loop " + str(i))
#             MessageLogger.info("match3: " + str(match.group(i)))
#             if i == 1:
#                 variable = match.group(i)
#                 pattern12 = r'\d+'
#                 match12 = re.search(pattern12, variable)
#                 parts = variable.split('_')
#                 if len(parts) >= 1:
#                     txntype = parts[0]
#                 if match12:
#                     digit = match12.group(0)
#                     MessageLogger.info(f"Extracted digit: {digit}")
#             elif i == 2:
#                 amount = match.group(i)
#             elif i == 3:
#                 by = match.group(i)
#             elif i == 4 and match1:
#                 cpm = match.group(i)
#             elif i == 5 and match2:
#                 at = match.group(i)
#
#             if i == 4 and match1:
#                 cpm = match.group(i)
#             elif i < 4:
#                 cpm = ''
#
#             if i == 5 and match2:
#                 at = match.group(i)
#             elif i < 5:
#                 at = ''
#
#             if i == 4 and match3:
#                 at = match.group(i)
#             elif i < 4:
#                 at = ''
#
#     return variable, digit, amount, by, cpm, at, txntype


def verfiyTxninDB(accountNumber,tranid):
    try:
        # MessageLogger.info("Code with new executionid", get_global_EXECUTION_ID())
        # EXECUTION_ID = get_global_EXECUTION_ID()
        # fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'InProgress')
        MessageLogger.info("Verfiy transaction for ", str(tranid))
        sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) 
                 WHERE AccountNumber = '{accountNumber}' AND
                    Tranid = {tranid} 
                """
        MessageLogger.info(sql)
        cursor = DBCon.cursor()
        cursor.execute(sql)
        res = cursor.fetchall()
        res2 = {}
        MessageLogger.info(len(res))
        bflag = False
        errortnp= False
        loopcount = 0
        txnsecond = 3
        timeout = False
        time.sleep(3)
        while bflag is False and txnsecond > 300:
            if len(res) > 0:
                sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) join trans_in_acct tia (nolock)
                 on c.tranid = tia.tran_id_index 
                 WHERE AccountNumber = {accountNumber} AND
                    Tranid = {tranid} AND tia.ATID=51
                """
                MessageLogger.info(sql)
                loopcount = loopcount + 1
                cursor.execute(sql)
                res1 =cursor.fetchall()
                MessageLogger.info(len(res1))
                if(len(res1) >0 ):
                    bflag = True
                    MessageLogger.info("Transaction has been successfully" + str(tranid))
                else:
                    bflag = False
                    MessageLogger.info("Transaction posting is InProgress " + str(tranid))
                    MessageLogger.info("Transaction posting is in queue from " + str(txnsecond))

                    time.sleep(5)
                    txnsecond = txnsecond + 5
                    if(loopcount> 10):
                        sql = f""" SELECT * FROM Errortnp e WITH(NOLOCK) 
                                        WHERE  Tranid = {tranid} 
                                       """
                        MessageLogger.info(sql)
                        cursor.execute(sql)
                        res2 = cursor.fetchall()
                        MessageLogger.info(len(res2))
                        if(len(res2) > 0 ):
                            MessageLogger.error("Transaction posting is in ErrorTNP" + str(tranid))
                            bflag = True
                            errortnp = True

        if txnsecond > 300:
            timeout = True
        return bflag, errortnp, timeout
    except Exception as e:
        MessageLogger.error(str(e))
        raise Exception('An error occurred during this step')


# def custom_title_case(text):
#     # Split the text into words
#     words = re.findall(r'\b\w+\b', text)
#
#     # Capitalize words and leave numbers as they are
#     result = ' '.join(word.capitalize() if word.isalpha() else word for word in words)
#
#     return result