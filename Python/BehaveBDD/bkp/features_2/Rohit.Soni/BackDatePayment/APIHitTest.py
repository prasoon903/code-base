from ExecutableFunctions.DataManager import fn_InsertFeatureStepExecutionInfo
from ExecutableFunctions.ExecutableFunctions import fn_TablefromJSON, fn_CreateJsonPayloadUsingTable, fn_HitAPI
from behave import *
# from ExecutableFunctions.Environment import *
from ExecutableFunctions.DataBaseConnections import *
from ExecutableFunctions.DatabaseORM import *
from ExecutableFunctions.ExecutableFunctions import *
from ExecutableFunctions.DataManager import *
# from ExecutableFunctions.DataManager import EXECUTION_ID
import time
import subprocess

from ExecutableFunctions.MiniDice import fn_VerifyTracefiles

from ExecutableFunctions.MiniDice import DBRestore

from ExecutableFunctions.MiniDice import fn_VerifyTracefiles

from ExecutableFunctions.ExecutableFunctions import fn_getmaxexecuationidforfeature

# from ExecutableFunctions.ExecutableFunctions import get_global_EXECUTION_ID

from ExecutableFunctions.DataManager import fn_setexeutionID

Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if (get_global_EXECUTION_ID() is not None):
    EXECUTION_ID=get_global_EXECUTION_ID()



data = {
            "TagName": ["AccountNumber"],
            "VariableName": ["1150001100411390"]
        }
PaymentTable = fn_TablefromJSON(data)
payLoad = fn_CreateJsonPayloadUsingTable(0, PaymentTable)
print(payLoad)
response = fn_HitAPI("AccountSummary", payLoad)
response = response
AccountNumber = payLoad['AccountNumber']
# context.Aging = payLoad['TransactionAmount']
fn_InsertFeatureStepExecutionInfo(0, "Test", "APIHit", "Get AccountSummary", 'Done')
