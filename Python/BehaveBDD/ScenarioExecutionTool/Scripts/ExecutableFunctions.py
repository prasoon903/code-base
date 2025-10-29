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
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID

from Scripts.DataManager import fn_GetValueFromDataStore, fn_getexecuationidbyfeaturename, \
    fn_GetDataCITable
from Scripts.DataBaseConnections import *
from Scripts.GetLogger import MessageLogger
from Scripts.HelperFunction import *


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
CoreIssueURL = Configuration['CoreIssueURL']

# MessageLogger.info(APINAmeEndPointMapping)


Cursor = DBCon.cursor()

Cursor.execute("SELECT TOP 1 Environment_Name FROM CPS_ENVIRONMENT WITH(NOLOCK)")
Environment = Cursor.fetchone()


def fn_HitAPI(APIName, PayLoad):
    MessageLogger.info("Inside fn_HitAPI for : " + APIName)
    MessageLogger.debug("Final PayLoad : " + str(PayLoad))
    response = {}
    APIUrl = ""
    try:
        if APIName.lower() == "accountsummary":
            APIName = "AccountSummary"
            if APINAmeEndPointMapping[APIName] is not None:
                MessageLogger.debug(f"API end point: {APINAmeEndPointMapping[APIName]}")
                APIUrl = Configuration['APIDomainUrlAS'] + APINAmeEndPointMapping[APIName]
            else:
                MessageLogger.error(f"{APIName} is not mapped with valid end point")
        else:
            if APINAmeEndPointMapping[APIName] is not None:
                MessageLogger.debug(f"API end point: {APINAmeEndPointMapping[APIName]}")
                APIUrl = Configuration['APIDomainUrl']+APINAmeEndPointMapping[APIName]
            else:
                MessageLogger.error(f"{APIName} is not mapped with valid end point")

        JsonPath = RootPath + f"\JsonPayload/{APIName}.json"
        # MessageLogger.info(f"Path to API json: {JsonPath}")
        if os.path.exists(JsonPath) and APINAmeEndPointMapping[APIName] is not None:
            APIJson = json.load(open(JsonPath))
            if "UserID".upper() not in PayLoad.keys():
                if "PLAT" in str(Environment.Environment_Name).upper():
                    PayLoad["UserID"] = "SystemCommSvc"
                else:
                    PayLoad["UserID"] = "SystemCommSvc"

            APIJson.update(PayLoad)
            replace_guids(APIJson)

            MessageLogger.debug(APIUrl)

            headers = {"Accept": "application/json", "Content-Type": "application/json"}
            MessageLogger.debug(APIJson)
            response = requests.post(APIUrl, data=json.dumps(APIJson), headers=headers)
            # MessageLogger.debug(response)
            if response.status_code == 200:
                MessageLogger.debug(response.json())
        else:
            MessageLogger.error("API Json not configured on : " + JsonPath)
    except KeyError as e:
        MessageLogger.error(f"KeyError Error in hitting API: {e}")
    except FileNotFoundError as e:
        MessageLogger.error(f"FileNotFoundError Error in hitting API: {e}")
    except Exception as e:
        MessageLogger.error(f"Exception Error in hitting API: {e}")
    return (response,APIJson)


def fn_CheckErrorFound(Response):
    return Response['ErrorFound'], Response['ErrorNumber'], Response['ErrorMessage']


def fn_CreateJsonPayloadUsingTable(ExecutionID, Table):
    MessageLogger.debug("fn_CreateJsonPayloadUsingTable--1111")
    PayLoad = {}
    assert len(Table[0]) == 2, "We are not able to create Key Value because length of table is greater than 2"
    for row in Table:
        if str(row[1]).startswith("@"):
            MessageLogger.debug("fn_CreateJsonPayloadUsingTable--2222")
            MessageLogger.debug(str(row[1])[1:])
            # MessageLogger.debug(str(row[1]))
            Value = fn_GetValueFromDataStore(ExecutionID, str(row[1])[1:])
            PayLoad[row[0]] = Value
            # MessageLogger.debug(row[1])
            # MessageLogger.debug(Value)
        else:
            PayLoad[row[0]] = row[1]
            MessageLogger.debug(row[1])
    return PayLoad


def fn_getmaxexecuationidforfeature(featurename):
    ExecutionID = fn_getexecuationidbyfeaturename(featurename)
    return ExecutionID


def verfiyTxninDB(accountNumber, tranid):
    try:
        # MessageLogger.info("Code with new executionid", get_global_EXECUTION_ID())
        # EXECUTION_ID = get_global_EXECUTION_ID()
        # fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'InProgress')
        MessageLogger.info("Verify transaction for ", str(tranid))
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
        while bflag is False and txnsecond <= 300:
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
                if len(res1) > 0:
                    MessageLogger.info("Transaction has been successfully posted " + str(tranid))
                    break
                else:
                    bflag = False
                    MessageLogger.info("Transaction posting is InProgress " + str(tranid) + " seconds")
                    MessageLogger.info("Transaction posting is in queue from " + str(txnsecond) + " seconds")

                    time.sleep(5)
                    txnsecond = txnsecond + 5
                    if loopcount > 10:
                        sql = f""" SELECT * FROM Errortnp e WITH(NOLOCK) 
                                        WHERE  Tranid = {tranid} 
                                       """
                        MessageLogger.info(sql)
                        cursor.execute(sql)
                        res2 = cursor.fetchall()
                        MessageLogger.info(len(res2))
                        if len(res2) > 0:
                            MessageLogger.error("Transaction posting is in ErrorTNP " + str(tranid))
                            bflag = True
                            errortnp = True
                        sql = f""" SELECT * FROM ErrorAP e WITH(NOLOCK) 
                                        WHERE  Tranid = {tranid} 
                                       """
                        MessageLogger.info(sql)
                        cursor.execute(sql)
                        res2 = cursor.fetchall()
                        MessageLogger.info(len(res2))
                        if len(res2) > 0:
                            MessageLogger.error("Transaction posting is in ErrorAP " + str(tranid))
                            bflag = True
                            errortnp = True

        if txnsecond > 300:
            timeout = True
        return bflag, errortnp, timeout
    except Exception as e:
        MessageLogger.error(str(e))
        raise Exception('An error occurred during this step')


def GetAmount_Account(amount):
    EXECUTION_ID = get_global_EXECUTION_ID()
    tableInfoFields = []
    TotalAmount = 0
    if "+" in amount:
        AmountList = amount.split("+")
        MessageLogger.info(AmountList)
        for amountValue in AmountList:
            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                value = float(fn_GetValueFromDataStore(EXECUTION_ID, amountValue))
                MessageLogger.info('1')
                if value is None or value == 'None':
                    AccountNumber = fn_GetValueFromDataStore(EXECUTION_ID, 'MyAccountNumber')
                    MessageLogger.info('1.1')
                    tableInfoFields.append(amountValue)
                    value = fn_GetDataCITable('BSegment', tableInfoFields, 'AccountNumber',
                                              AccountNumber)
                    value = value[0][f"{amountValue}"]
                TotalAmount = TotalAmount + value
            else:
                TotalAmount = TotalAmount + float(amountValue)
    elif "-" in amount:
        AmountList = amount.split("-")
        MessageLogger.info(AmountList)
        for amountValue in AmountList:
            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                value = float(fn_GetValueFromDataStore(EXECUTION_ID, amountValue))
                MessageLogger.info('2')
                if value is None or value == 'None':
                    AccountNumber = fn_GetValueFromDataStore(EXECUTION_ID, 'MyAccountNumber')
                    MessageLogger.info('2.2')
                    tableInfoFields.append(amountValue)
                    value = fn_GetDataCITable('BSegment', tableInfoFields, 'AccountNumber',
                                              AccountNumber)
                    value = value[0][f"{amountValue}"]
                TotalAmount = TotalAmount - value
            else:
                TotalAmount = TotalAmount - float(amountValue)
    elif not re.match(r"^\d+(\.\d+)?$", amount):
        value = fn_GetValueFromDataStore(EXECUTION_ID, amount)
        MessageLogger.info(f"value: {value}")
        MessageLogger.info('3')
        if value is None or value == 'None':
            AccountNumber = fn_GetValueFromDataStore(EXECUTION_ID, 'MyAccountNumber')
            MessageLogger.info('3.3')
            tableInfoFields.append(amount)
            value = fn_GetDataCITable('BSegment', tableInfoFields, 'AccountNumber', AccountNumber)
            value = value[0][f"{amount}"]
        TotalAmount = value
    else:
        TotalAmount = amount

    return TotalAmount


def GetAmount_Plan(amount, forTxn):
    EXECUTION_ID = get_global_EXECUTION_ID()
    tableInfoFields = []
    TotalAmount = 0
    TranID = fn_GetValueFromDataStore(EXECUTION_ID, f"{forTxn}_tranid")
    PlanID = fn_GetDataCITable('CCard_Primary', ['TxnAcctID'], 'TranID', TranID)
    PlanID = PlanID[0]['TxnAcctID']
    if "+" in amount:
        AmountList = amount.split("+")
        MessageLogger.info(AmountList)
        for amountValue in AmountList:
            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                # value = float(fn_GetValueFromDataStore(EXECUTION_ID, amountValue))
                MessageLogger.info('1')
                # if value is None or value == 'None':
                # AccountNumber = fn_GetValueFromDataStore(EXECUTION_ID, 'MyAccountNumber')
                # MessageLogger.info('1.1')
                # tableInfoFields.append(amountValue)
                value = fn_GetDataCITable('CPSgment', [f"{amountValue}"], 'acctID', PlanID)
                value = value[0][f"{amountValue}"]
                TotalAmount = TotalAmount + value
            else:
                TotalAmount = TotalAmount + float(amountValue)
    elif "-" in amount:
        AmountList = amount.split("-")
        MessageLogger.info(AmountList)
        for amountValue in AmountList:
            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                # value = float(fn_GetValueFromDataStore(EXECUTION_ID, amountValue))
                MessageLogger.info('2')
                value = fn_GetDataCITable('CPSgment', [f"{amountValue}"], 'acctID', PlanID)
                value = value[0][f"{amountValue}"]
                TotalAmount = TotalAmount + value
                TotalAmount = TotalAmount - value
            else:
                TotalAmount = TotalAmount - float(amountValue)
    elif not re.match(r"^\d+(\.\d+)?$", amount):
        # value = fn_GetValueFromDataStore(EXECUTION_ID, amount)
        # MessageLogger.info(f"value: {value}")
        MessageLogger.info('3')
        value = fn_GetDataCITable('CPSgment', [f"{amount}"], 'acctID', PlanID)
        value = value[0][f"{amount}"]
        TotalAmount = value
    else:
        TotalAmount = amount

    return TotalAmount




# Example usage:





# def custom_title_case(text):
#     # Split the text into words
#     words = re.findall(r'\b\w+\b', text)
#
#     # Capitalize words and leave numbers as they are
#     result = ' '.join(word.capitalize() if word.isalpha() else word for word in words)
#
#     return result



    