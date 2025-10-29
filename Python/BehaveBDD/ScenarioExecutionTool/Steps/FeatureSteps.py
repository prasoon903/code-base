import time
import subprocess
from behave import *

from Scripts.DataBaseConnections import *
from Scripts.DatabaseORM import *
from Scripts.ExecutableFunctions import *
from Scripts.DataManager import *
from Scripts.Config import *
from Scripts.TviewTimeOp import *


from Scripts.MiniDice import DBRestoreWithBackUp, DBRestore
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID


Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if get_global_EXECUTION_ID() is not None:
    EXECUTION_ID = get_global_EXECUTION_ID()

# loggerName = "TraceFile"
# log_folder = os.path.join(c.BasePath, "LOG") + "\\"
# LOG_FILE = log_folder + "LOG_" + loggerName + ".log"
# # LOG_FILE = log_folder + "LOG_Test3.log"
# MessageLogger = get_logger(LOG_FILE)


@given("Create Account")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        # payLoad['ClientId'] = get_random_uuid_from_file()
        payLoad['ClientId'] = generate_random_clientid()
        context.clientid =payLoad['ClientId']
        context.customersave = "Owner"
        (response,request) = fn_HitAPI("AccountCreation", payLoad)
        context.response = response
        context.request = request
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "Done",
        )

        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "InProgress",
        )

        assert context.response.ok, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Assert API Response is not ok",
        )
        JsonData = context.response.json()
        context.jsonData = context.response.json()
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        MessageLogger.info(
            f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}"
        )
        assert ErrorFound.upper() == "NO", fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "FAIL Error Found Yes",
        )
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "Fail ",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")
        # raise Exception('An error occurred during this step')


@when("Verify API response is OK")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "InProgress",
        )

        assert context.response.ok, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Assert API Response is not ok",
        )
        JsonData = context.response.json()
        context.jsonData = context.response.json()
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        MessageLogger.info(
            f"ErrorFound: {ErrorFound} \nErrorNumber: {ErrorNumber} \nErrorMessage: {ErrorMessage}"
        )
        assert ErrorFound.upper() == "NO", fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "FAIL Error Found Yes",
        )
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@then("Verify Account Number in Database")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Account Number in Database",
            "InProgress",
        )
        if context.response.ok:
            context.jsonData = context.response.json()
            cursor.execute(
                f"SELECT TOP 1 1 FROM Bsegment_Primary WITH(NOLOCK) WHERE AccountNumber={context.jsonData['AccountNumber']}"
            )
            AccountRes = cursor.fetchall()
            assert len(AccountRes) >= 1, fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Verify Account Number in Database",
                "Fail AccountNumber Not found in DB",
            )
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Verify Account Number in Database",
                "Done",
            )
            MessageLogger.info("Checking account creation jobs")
            value = fn_GetDataCITable('BSegment', ["acctId"], 'AccountNumber', context.jsonData["AccountNumber"])
            AccountID = value[0]["acctId"]
            fn_GetPendingTxnOfAccount(AccountID)
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Account Number in Database",
            "Fail ",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@given('Use "{APIName}" "{AccountNumber}"')
def step_impl(context, APIName, AccountNumber):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info(APIName)
    jsonResponse = fn_GetAPIResponseTags(APIName)
    jsonResponse = fn_OverrideTagName(
        jsonResponse, "MyAccountNumber", "MyAccountNumber"
    )
    table_var = fn_TablefromJSON(jsonResponse)
    # MessageLogger.info(jsonResponse)
    context.custom_table = table_var
    assert len(context.custom_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        "Save tag into variable",
        "Fail More than two column",
    )
    try:
        sAccountNumber = AccountNumber
        MessageLogger.info("going to save accountnumber " + str(sAccountNumber))
        # context.jsonData = json.dumps(data)
        for row in context.custom_table:
            fn_InsertFeatureStepDataStore(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                row[1],
                str(sAccountNumber),
            )
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Done",
            )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@then("Save tag into variable")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    assert len(context.table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        "Save tag into variable",
        "Fail More than two column",
    )
    try:
        for row in context.table:
            fn_InsertFeatureStepDataStore(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                row[1],
                str(context.jsonData[row[0]]),
            )
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Done",
            )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@then('Save tag into variable "{APIName}"')
def step_impl(context, APIName):
    try:
        table_other = None
        keepOtherData = False
        MessageLogger.debug("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        MessageLogger.debug(APIName)
        jsonResponse = fn_GetAPIResponseTags(APIName)
        jsonResponse = fn_OverrideTagName(jsonResponse, "MyAccountNumber", "MyAccountNumber")
        table_var = fn_TablefromJSON(jsonResponse)
        if hasattr(context, 'customersave') and hasattr(context, 'clientid'):
            table_other = {context.customersave: context.clientid}
            keepOtherData = True
            
        # MessageLogger.info(jsonResponse)
        context.custom_table = table_var
        
        assert len(context.custom_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail More than two column",
        )
        for row in context.custom_table:
            fn_InsertFeatureStepDataStore(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                row[1],
                str(context.jsonData[row[0]]),
            )
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Done",
            )
    
        if keepOtherData:
            context.payment_table = list(table_other.items())
            MessageLogger.info(f"Saving other data response of  {context.payment_table}")
            MessageLogger.info(f"Saving other data response of  {len(context.payment_table[0])}")
            assert len(context.payment_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,
                                                                                        context.feature.name,
                                                                                        context.scenario.name,
                                                                                        "Save tag into variable",
                                                                                        'Fail More than two column')
            for key, value in context.payment_table:
                fn_InsertFeatureStepDataStore(EXECUTION_ID, context.feature.name, context.scenario.name, key, value)
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name, "Save tag into variable", 'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}", exc_info=True)
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        MessageLogger.error(str(e), exc_info=True)
        raise Exception("An error occurred during this step")

@given("Create Secondary Card")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        (response,request)  = fn_HitAPI("SecondaryCardCreation", payLoad)
        context.response = response
        context.request = request
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "Fail ",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@given("Post Transaction")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        # MessageLogger.info(payLoad)
        (response,request)  = fn_HitAPI("PostSingleTransaction", payLoad)
        MessageLogger.info(payLoad)
        context.response = response
        context.request = request
        JsonData = context.response.json()
        context.TransactionID = JsonData["TransactionID"]
        context.AccountNumber = payLoad["AccountNumber"]
        context.TransactionAmount = payLoad["TransactionAmount"]
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )


@then("Verify Transaction in DB")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "InProgress",
        )
        sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) 
                 WHERE AccountNumber = '{context.AccountNumber}' AND
                    Tranid = {context.TransactionID} 
                """
        MessageLogger.info(sql)
        cursor.execute(sql)
        res = cursor.fetchall()
        res2 = {}
        MessageLogger.info(len(res))
        bflag = False
        loopcount = 0
        while bflag == False:
            if len(res) > 0:
                sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) join trans_in_acct tia (nolock)
                 on c.tranid = tia.tran_id_index 
                 WHERE AccountNumber = {context.AccountNumber} AND
                    Tranid = {context.TransactionID} AND tia.ATID=51
                """
                MessageLogger.info(sql)
                loopcount = loopcount + 1
                cursor.execute(sql)
                res1 = cursor.fetchall()
                MessageLogger.info(len(res1))
                if len(res1) > 0:
                    bflag = True
                    MessageLogger.info("Transaction has been posted successfully", context.TransactionID)
                else:
                    bflag = False
                    MessageLogger.warning("Transaction posting is InProgress", context.TransactionID)
                    time.sleep(5)
                    if loopcount > 10:
                        sql = f""" SELECT * FROM Errortnp e WITH(NOLOCK) 
                                        WHERE  Tranid = {context.TransactionID} 
                                       """
                        MessageLogger.info(sql)
                        cursor.execute(sql)
                        res2 = cursor.fetchall()
                        MessageLogger.info(len(res2))
                        if len(res2) > 0:
                            MessageLogger.error(
                                "Transaction posting is in ErrorTNP",
                                context.TransactionID,
                            )
                            bflag = True

        assert len(res2) <= 1, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "Fail - Transaction is moved to errortnp",
        )
        assert len(res) >= 1, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "Fail - Transaction is not present in CCard_Primary",
        )
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@then('Age TestAccount to "{Date}" Date')
def step_impl(context, Date):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Age TestAccount",
            "InProgress",
        )
        DateToAge = Date.split("-")
        AgingDate = DateToAge[0] + DateToAge[1] + DateToAge[2]
        # Month, Date, Year = DateToAge[1], DateToAge[2], DateToAge[0]

        context.apiname = "AgingAPI"
        data = {
            "TagName": ["AccountNumber", "AgingDate"],
            "VariableName": ["@MyAccountNumber", AgingDate]
        }
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)

        MessageLogger.info("Payload here", payLoad)
        MessageLogger.info("context.apiname here " + context.apiname)
        (response,request)  = fn_HitAPI(context.apiname, payLoad)
        context.response = response
        context.request = request
        MessageLogger.info(response.json())
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Age TestAccount",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Aging of account",
            "Fail ",
        )




@then('Age system "{nDays}" days')
def step_impl(context, nDays):
    CurrentTnpDate = fn_GetAgingDate(nDays)
    tnpdate = CurrentTnpDate.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]

    fn_SetDateInTview(Month, Date, Year)

    while not (fn_checkAgingDate(CurrentTnpDate)):
        MessageLogger.warning("Aging is InProgress")
        time.sleep(30)


@then('Age system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    CurrentTnpDate = fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)
    while not (fn_checkAgingDate(Datetocheck)):
        MessageLogger.warning("Aging is InProgress")
        time.sleep(15)




@then('Set system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    # CurrentTnpDate =fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)


@then('Wait for {seconds} seconds')
def step_impl(context, seconds):
    MessageLogger.warning(f"Waiting for {seconds} seconds")
    time.sleep(int(seconds))


# @then('Check Payment_"{cnt}" is posted')
# def step_impl(context, cnt):
#     EXECUTION_ID = get_global_EXECUTION_ID()
#     variableToCheck = f"Payment_"+{cnt}+"_TranID"
#     if not re.match(r'^\d+$', ):
#         value = fn_GetValueFromDataStore(EXECUTION_ID, variableToCheck)
#         amount = value
#     TxnCount =fn_GetTxnDetailsFromCommonTNP()
#     tnpdate = Date.split('-')
#     Month , Date , Year = tnpdate[1], tnpdate[2], tnpdate[0]
#     fn_SetDateInTview(Month , Date , Year)
#     while not(fn_checkAgingDate(Datetocheck)):
#         MessageLogger.info("Aging is InProgress")
#         time.sleep(15)



@then("Verify API response is OK")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "InProgress",
        )

        assert context.response.ok, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Assert API Response is not ok",
        )
        JsonData = context.response.json()
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        MessageLogger.info(
            f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}"
        )
        assert ErrorFound.upper() == "NO", fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "FAIL Error Found Yes",
        )
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")


@then('Pause for "{WaitforDelay}" Second')
def step_impl(context, WaitforDelay):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Wait for {WaitforDelay} Second",
        "InProgress",
    )
    time.sleep(int(WaitforDelay))
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Wait for {WaitforDelay} Second",
        "Done",
    )


@given("Make bin file entry in txt file")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Make bin file entry in txt file",
        "InProgress",
    )
    FI = open(r"D:\OnePackageSetup\BIN_SETUP\Input\Main.txt", "w")
    FI.write("100_MC_Card.bin")
    FI.close()
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Make bin file entry in txt file",
        "Done",
    )




@then("verify entry in CoreAuthTransaction")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    Cursor_CoreAuth.execute(
        "SELECT Count(1) AS Count from CoreAuthTransactions WITH(NOLOCK)"
    )
    AfterExecCount = int(Cursor_CoreAuth.fetchone()[0])
    assert AfterExecCount > context.count, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"verify entry in CoreAuthTransaction",
        "Fail - Assert",
    )
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"verify entry in CoreAuthTransaction",
        "Done",
    )
    MessageLogger.info("verified in database ")


@given("Take DB Backup")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    res = fn_TakeDBbackup(context.feature.name, context.scenario.name)
    assert res != 1, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Fail - Assert",
    )
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Done",
    )


@given("Pause")
def step_impl(context):
    input("Press ENTER to continue execution")


@when("Take DB Backup")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    res = fn_TakeDBbackup()
    assert res != 1, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Fail - Assert",
    )
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Done",
    )


@when("Pause")
def step_impl(context):
    input("Press ENTER to continue execution")


@then("Take DB Backup")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    res = fn_TakeDBbackup()
    assert res != 1, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Fail - Assert",
    )
    fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Take DB Backup",
        "Done",
    )


@then("Pause")
def step_impl(context):
    input("Press ENTER to continue execution")





@given("Restore Database")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info("Database Restore")
    DBRestore()


@given("Restore Database with backup")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info("Database Restore with backup")
    DBRestoreWithBackUp()



@given("Test Given")
def step_impl(context):
    MessageLogger.info("Given is executed")


@given('Run feature file "{feature_file}"')
def step_impl(context, feature_file):
    # feature_file = feature_file + " --no-capture"
    subprocess.run(["behave", feature_file], check=True)




@given('Run as "{action}"')
def step_impl(context, action):
    MessageLogger.info(context.feature.name)
    EXECUTION_ID = fn_setexeutionID(context.feature.name, action)
    MessageLogger.info(EXECUTION_ID)




@Then('Set system to "{Date}" DateTime')
def step_impl(context, Date):
    # Date = str(Date)
    MessageLogger.info("Set tview time without checking aging")
    DatePart, TimePart = Date.split(" ")
    # DatePart = tnpdate[0]
    Year, Month, Date = DatePart.split("-")

    # TimePart = tnpdate[1]
    hour, minute, secound = TimePart.split("_")
    fn_SetDateInTview(Month, Date, Year, hour, minute, secound)



@Given('Update Control Table "{Key}" "{KeyValue}" "{tableName}" "{field}" "{value}"')
def step_impl(context, Key, KeyValue, tableName, field, value):
    fn_UpdateControlTable(Key, KeyValue, tableName, field, value)


@when('Update account "{column}" with "{value}"')
def step_impl(context, column, value):
    try:
        EXECUTION_ID = get_global_EXECUTION_ID()
        MessageLogger.info("Code with new execution id: " + str(EXECUTION_ID))
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        # MessageLogger.info(payLoad)
        context.AccountNumber = payLoad["AccountNumber"]
        fn_UpdateCITable(context.AccountNumber, "BSegment_Primary", "ReProjectionFlag", "2")
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")



                