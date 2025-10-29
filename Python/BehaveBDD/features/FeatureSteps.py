from behave import *
# from Environment import *
from Scripts.DataBaseConnections import *
from Scripts.DatabaseORM import *
from Scripts.ExecutableFunctions import *
from Scripts.DataManager import *
# from DataManager import EXECUTION_ID
import time
import subprocess
from Scripts.GetAccountPlanData import fn_GetAllDetails
from Scripts.MiniDice import fn_VerifyTracefiles, DBRestoreWithBackUp
from Scripts.MiniDice import DBRestore
from Scripts.MiniDice import fn_VerifyTracefiles
from Scripts.ExecutableFunctions import fn_getmaxexecuationidforfeature
# from ExecutableFunctions import get_global_EXECUTION_ID
from Scripts.DataManager import fn_setexeutionID
# from Scripts.ScenarioExecution import fn_fileSplitter, fn_ExecuteSteps
from Scripts.GetLogger import MessageLogger
import Scripts.Config as c
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID

Configuration = c.Configuration
RootPath = c.BasePath


Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if get_global_EXECUTION_ID() is not None:
    EXECUTION_ID = get_global_EXECUTION_ID()



@given('execute {action} {details}')
def step_impl(context, action, details):
    # Use regular expressions to match the variations of the steps
    action = action.lower()
    details = details.lower()
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info("*********************| "  + action+" " + details  + " |*********************",EXECUTION_ID)

    if action in ("create", "get", "add"):
        # Implement logic for "Create" statement
        input_string = action
        match = re.search(r'(\S+)', input_string)
        APIName = details
        context.apiname = fn_GetAPINAME(APIName)
        actype = "create"
        context.activitytype = actype

    elif action in "post" :
        APIName = "PostSingleTransaction"
        context.apiname = fn_GetAPINAME(APIName)
        # Implement logic for "Post" statement
        FullString =  action + " "  + details
        MessageLogger.info("FullString",FullString)
        match = re.search(r'post (.*?) of', FullString)
        if match:
            word_in_between = match.group(1)
            word_in_between =word_in_between.lower()
            MessageLogger.info(word_in_between)
            parts = word_in_between.split("_")
            if len(parts) > 0:
                word_in_between = parts[0]
            MessageLogger.info("after",word_in_between)
            if word_in_between in ("payment reversal","purchase reversal"):
                match = re.search(r'of (\S+)', details)
                context.Txninfo = match.group(1)
                actype = "post transaction reversal"
                context.activitytype = actype
                context.txntype = context.Txninfo
            elif (word_in_between in ("payment", "debit","credit","purchase","cashpurchase","return")):
                variable,digit,amount,by,cpm,at,txntype = extract_information(FullString)
                MessageLogger.info(f"From input_string:")
                MessageLogger.info(f"Variable: {variable}")
                MessageLogger.info(f"digit: {digit}")
                MessageLogger.info(f"Amount: {amount}")
                MessageLogger.info(f"By: {by}")
                MessageLogger.info(f"CPM: {cpm}")
                MessageLogger.info(f"At: {at}")
                MessageLogger.info(f"At: {txntype}")
                context.variable =variable
                context.amount =amount
                context.by =by
                context.cpm =cpm
                context.at =at
                actype = "post transaction"
                context.activitytype = actype
                context.cnt = digit
                context.txntype = txntype

    else:
        # Implement logic for other statements
       MessageLogger.info ("Invalid Step")

    try:
        MessageLogger.info("APName",context.apiname)
        MessageLogger.info("activitytype", context.activitytype)
        MessageLogger.info("Code with new execuationid", get_global_EXECUTION_ID())
        MessageLogger.info("action in ", action)
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                          context.activitytype + "" + context.apiname, 'InProgress')

        if action.strip() in ("create","get","add"):
                if action == "get":
                    data = {
                        "TagName": ["AccountNumber"],
                        "VariableName": ["@MyAccountNumber"]
                    }
                    context.PaymentTable = fn_TablefromJSON(data)
                    payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.PaymentTable)
                else:
                    payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)

        else:
            if context.activitytype == "post transaction":
                    MessageLogger.info("activity of ", context.activitytype)
                    data = {
                        "TagName": ["AccountNumber", "TranType", "TransactionAmount", "DateTimeLocalTransaction","CreditPlanMaster"],
                        "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount", "DateTimeLocalTransaction","CreditPlanMaster"]
                    }

                    context.PaymentTable = fn_TablefromJSON(data)
                    payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                    payLoad['TranType'] = context.by
                    payLoad['TransactionAmount'] = context.amount
                    payLoad['CreditPlanMaster'] = context.cpm
                    if context.at != "posttime":
                        payLoad['DateTimeLocalTransaction'] = context.at
                    else:
                        payLoad['DateTimeLocalTransaction'] = ""


            if context.activitytype == "post transaction reversal":
                MessageLogger.info("reversal of ",context.Txninfo)
                Payment_1 = context.Txninfo + "_tranid"
                TxnDetail =fn_GetTxnDetails(EXECUTION_ID,Payment_1,context.feature.name)
                MessageLogger.info(TxnDetail)
                data = {
                    "TagName": ["AccountNumber", "TranType", "TransactionAmount","ReversalTargetTranID"],
                    "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount","ReversalTargetTranID"]
                }

                context.PaymentTable =fn_TablefromJSON(data)
                payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.PaymentTable)
                first_item = TxnDetail[0]

                # Access the value associated with "ManualReversalTrancode" in the dictionary
                result = first_item.get("ManualReversalTrancode", None)  # Use .get() to avoid KeyError
                payLoad['TranType'] =first_item.get("ManualReversalTrancode", None)
                payLoad['TransactionAmount'] =first_item.get("transactionamount", None)
                payLoad['ReversalTargetTranID'] = first_item.get("tranid", None)
                payLoad['AccountNumber'] = first_item.get("accountnumber", None)

        MessageLogger.info("Payload here",payLoad)
        MessageLogger.info("context.apiname here", context.apiname)
        response = fn_HitAPI(context.apiname, payLoad)
        context.response = response
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                          action + "" + context.apiname, 'Done')

        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                          "Verify API response is OK", 'InProgress')


        assert context.response.ok, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name,
                                                                      context.scenario.name,
                                                                      "Verify API response is OK",
                                                                      'Fail Assert API Response is not ok')

        JsonData = context.response.json()
        context.jsonData = context.response.json()
        MessageLogger.info("APIResponse", JsonData)
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        MessageLogger.info(f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}")
        assert ErrorFound.upper() == 'NO', fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name,
                                                                             context.scenario.name,
                                                                             "Verify API response is OK",
                                                                             'FAIL Error Found Yes')
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                          "Verify API response is OK", 'Done')

        if (action in ("Create", "Get", "Add")):
            context.AccountNumber = payLoad['AccountNumber']
        else:
            context.TransactionID = JsonData['TransactionID']
            context.AccountNumber = payLoad['AccountNumber']
            context.TransactionAmount = payLoad['TransactionAmount']
            if context.activitytype != "post transaction reversal":
                TagName = context.txntype +"_"+ str(context.cnt) + "_Tranid"
            else:
                TagName =  "Reversal_" + context.Txninfo + "_tranid"
            MessageLogger.info("TagName =", TagName)
            jsonResponse = fn_GetAPIResponseTags(context.apiname)
            jsonResponse = fn_OverrideTagName(jsonResponse, "TransactionID", TagName)
            bflag,errortnp,timeout=verfiyTxninDB(context.AccountNumber,context.TransactionID)
            assert bflag ==  False or errortnp == True or timeout == True, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name,
                                                                             context.scenario.name,
                                                                             "Transcation posted Sucessfully",
                                                                             'FAIL in posting')

        table_var = fn_TablefromJSON(jsonResponse)
        MessageLogger.info("Rohit", table_var)
        context.payment_table = table_var
        MessageLogger.info(context.payment_table)
        MessageLogger.info("Rohit here for save variable")
        MessageLogger.info("json varailbe value11111", context.jsonData)
        assert len(context.payment_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,
                                                                                     context.feature.name,
                                                                                     context.scenario.name,
                                                                                     "Save tag into variable",
                                                                                     'Fail More than two column')
        MessageLogger.info("json varailbe value----------------11111111", context.jsonData)

        try:
            MessageLogger.info("Rohit here for save variable new")
            for row in context.payment_table:
                fn_InsertFeatureStepDataStore(EXECUTION_ID, context.feature.name, context.scenario.name, row[1],
                                              str(context.jsonData[row[0]]))
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  "Save tag into variable", 'Done')
        except AssertionError as ae:
            # Handle AssertionError specifically (if needed)
            MessageLogger.info(f"AssertionError occurred: {ae}")
            raise Exception('An error occurred during this step')
            exit()
        except Exception as e:
            fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                              "Save tag into variable", 'Fail ')
            MessageLogger.info(str(e))
            raise Exception('An error occurred during this step')
            exit()


    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
        exit()
    except Exception as e:
        MessageLogger.info(f"AssertionError occurred: {e}")
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                          "Post Transaction", 'Fail - ')




@given("Create Account")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("AccountCreation", payLoad)
        context.response = response
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")
        # raise Exception('An error occurred during this step')


@when("Verify API response is OK")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@then("Verify Account Number in Database")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Account Number in Database",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@then("Save tag into variable")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@then('Save tag into variable "{APIName}"')
def step_impl(context, APIName):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info(APIName)
    jsonResponse = fn_GetAPIResponseTags(APIName)
    jsonResponse = fn_OverrideTagName(
        jsonResponse, "MyAccountNumber", "MyAccountNumber"
    )
    table_var = fn_TablefromJSON(jsonResponse)
    MessageLogger.info(table_var)
    context.custom_table = table_var
    MessageLogger.info(context.custom_table)
    assert len(context.custom_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        "Save tag into variable",
        "Fail More than two column",
    )
    try:
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
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@given("Create Secondary Card")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("SecondaryCardCreation", payLoad)
        context.response = response
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "Fail ",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@given("Post Transaction")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        MessageLogger.info(payLoad)
        context.response = response
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
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
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "InProgress",
        )
        sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) 
                 WHERE AccountNumber = {context.AccountNumber} AND
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
                    MessageLogger.info("Transaction posting sucessfully", context.TransactionID)
                else:
                    bflag = False
                    MessageLogger.info("Transaction posting is InProgress", context.TransactionID)
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
                            MessageLogger.info(
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
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


@given("Age TestAccount")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Age TestAccount",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("AgingAPI", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Age TestAccount",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Aging of account",
            "Fail ",
        )


@given("Initiate Dispute")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Initiate Dispute",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("AgingAPI", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Initiate Dispute",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Initiate Dispute",
            "Fail ",
        )


@given("Dispute Resolution")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Dispute Resolution",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("AgingAPI", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Dispute Resolution",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Dispute Resolution",
            "Fail ",
        )


@given("Get AccountSummary")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        MessageLogger.info(EXECUTION_ID)
        # MessageLogger.info(get_global_EXECUTION_ID())
        # if (get_global_EXECUTION_ID() is not None):
        #     EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get AccountSummary",
            "InProgress",
        )
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        MessageLogger.info(payLoad)
        response = fn_HitAPI("AccountSummary", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get AccountSummary",
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get AccountSummary",
            "Fail ",
        )


@given("Get StatementMetaData")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get StatementMetaData",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("StatementMetaData", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get StatementMetaData",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get StatementMetaData",
            "Fail ",
        )


@given("Get PlanSegmentDetails")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get PlanSegmentDetails",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        response = fn_HitAPI("PlanSegmentDetails", payLoad)
        context.response = response
        JsonData = context.response.json()
        context.AccountNumber = payLoad["AccountNumber"]
        # context.Aging = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get PlanSegmentDetails",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get PlanSegmentDetails",
            "Fail ",
        )

    """ sql = []
    queryFormat  = 'SELECT * FROM {TableName} WITH(NOLOCK) WHERE '
    previousTableName = None
    query = queryFormat
    counter=0
    for row in context.table:
        counter+=1
    

    for index ,row in enumerate(context.table):
        TableName = str(row[0]).strip()
        ColumnName = str(row[1]).strip()
        Value = str(row[2]).strip()

        if str(row[0]).startswith("@"):
            TableName =  fn_GetValueFromDataStore(EXECUTION_ID,str(TableName)[1:])
        if str(row[1]).startswith("@"):
            ColumnName =  fn_GetValueFromDataStore(EXECUTION_ID,str(ColumnName)[1:])
        if str(row[2]).startswith("@"):
            Value =  fn_GetValueFromDataStore(EXECUTION_ID,str(Value)[1:]) 

        if previousTableName is None:
            previousTableName =str(TableName).strip()
        
        if previousTableName.upper() == TableName.upper():
            MessageLogger.info("Ritik")
            query = query.replace("{TableName}",TableName)
            if index+1 == counter:
                query = query+f" {ColumnName} = '{Value}'"
            else:
                query = query+f" {ColumnName} = '{Value}' AND"
                
            previousTableName = str(TableName).strip()
            if index+1 == counter:
                sql.append(query)
        else:
            MessageLogger.info("riitkelse")
            sql.append(query)
            query = queryFormat

            query = query.replace("{TableName}",TableName)
            if index+1 == counter:
                query = query+f" {ColumnName} = '{Value}'"
            else:
                query = query+f" {ColumnName} = '{Value}' AND"
            previousTableName = str(TableName).strip()
            if index+1 == counter:
                sql.append(query)
         
          else:

            if previousTableName == row[0]:

                if str(row[0]).startswith("@"):
                    row[0] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[0])[1:])
                if str(row[1]).startswith("@"):
                    row[1] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[1])[1:])
                if str(row[2]).startswith("@"):
                    row[2] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[2])[1:])

                query = query.replace("{TableName}",row[0])
                query = query+f" {row[1]} = '{row[2]}'"
                previousTableName = str(row[0]).strip()
                if index+1 == counter:
                    sql.append(query)
            else:
                #sql.append(query)
                query = queryFormat

                if str(row[0]).startswith("@"):
                    row[0] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[0])[1:])
                if str(row[1]).startswith("@"):
                    row[1] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[1])[1:])
                if str(row[2]).startswith("@"):
                    row[2] =  fn_GetValueFromDataStore(EXECUTION_ID,str(row[2])[1:])

                query = query.replace("{TableName}",row[0])
                query = query+f" {row[1]} = '{row[2]}'"
                previousTableName = str(row[0]).strip()
                if index+1 == counter:
                    sql.append(query)
"""
    # MessageLogger.info(sql)


@then('Age system "{nDays}" days')
def step_impl(context, nDays):
    CurrentTnpDate = fn_GetAgingDate(nDays)
    tnpdate = CurrentTnpDate.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]

    fn_SetDateInTview(Month, Date, Year)

    while not (fn_checkAgingDate(CurrentTnpDate)):
        MessageLogger.info("Aging is InProgress")
        time.sleep(30)


@then('Age system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    CurrentTnpDate = fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)
    while not (fn_checkAgingDate(Datetocheck)):
        MessageLogger.info("Aging is InProgress")
        time.sleep(15)


@then('Set system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    # CurrentTnpDate =fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)

@then('Wait for "{seconds}" seconds')
def step_impl(context, seconds):
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


@given("Post Manual Auth")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Manual Auth",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        # MessageLogger.info(payLoad)
        response = fn_HitAPI("ManualAuth", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        if payLoad.get("TransactionAmount", None) is None:
            # MessageLogger.info("RItik===========================")
            # MessageLogger.info(fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount'))
            context.TransactionAmount = fn_GetKeyValueFromJsonFile(
                "ManualAuth", "TransactionAmount"
            )
        else:
            context.TransactionAmount = payLoad["TransactionAmount"]
        time.sleep(2)
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Manual Auth",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Manual Auth",
            "Fail - ",
        )
        MessageLogger.info(e)


@when("Post ReatilAuth")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post ReatilAuth",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)

        response = fn_HitAPI("RetailManualAuth", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        """ if payLoad.get('TransactionAmount' , None) is None:
            #MessageLogger.info("RItik===========================")
            MessageLogger.info(fn_GetKeyValueFromJsonFile('RetailManualAuth','TransactionAmount'))
            context.TransactionAmount = fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount')
        else:
            context.TransactionAmount = payLoad['TransactionAmount']  """
        time.sleep(2)
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post ReatilAuth",
            "Done",
        )
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post ReatilAuth",
            "Fail - ",
        )
        MessageLogger.info(e)
        raise Exception("An error occurred during this step")


@then("Verify API response is OK")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        MessageLogger.info(str(e))
        raise Exception("An error occurred during this step")


@then('Pause for "{WaitforDelay}" Second')
def step_impl(context, WaitforDelay):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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


@when('start "sim.bat"')
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            f"start sim.bat",
            "InProgress",
        )
        cwd = os.getcwd()
        Cursor_CoreAuth.execute(
            "SELECT Count(1) AS Count from CoreAuthTransactions WITH(NOLOCK)"
        )
        context.count = int(Cursor_CoreAuth.fetchone()[0])
        os.chdir("D:\OnePackageSetup\BIN_SETUP\Input")
        a = subprocess.run(
            ["D:\OnePackageSetup\BIN_SETUP\Input\sim.bat"],
            shell=True,
            stdout=subprocess.PIPE,
            text=True,
            check=True,
        )
        os.chdir(cwd)
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            f"start sim.bat",
            "Done",
        )
    except subprocess.CalledProcessError as e:
        MessageLogger.info(e)
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            f"start sim.bat",
            "Fail",
        )
        raise Exception("An error occurred during this step")


@then("verify entry in CoreAuthTransaction")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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


@given("Pause")
def step_impl(context):
    input("Press ENTER to continue execution")


@when("Take DB Backup")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
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


@given("Start CI AppServer")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["CIAppServerName"])

    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"MoveTrace.bat")
    time.sleep(30)
    Output = fn_VerifyTracefiles(
        "Ready for Login",
        Configuration["CITraceFileLocation"],
        "appCardinal",
        "CoreIusse Appserver",
    )
    os.chdir(cwd)
    assert Output != False, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Start CI AppServer",
        "AppServer Fatal - Assert",
    )


@given("Stop Processes")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"StopProcesses.bat")
    time.sleep(15)
    os.chdir(cwd)


@given("Restore Database")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info("Database Restore")
    DBRestore()


@given("Restore Database with backup")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    MessageLogger.info("Database Restore with backup")
    DBRestoreWithBackUp()


@given("Start CITNP")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["TnpWfName"])

    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"MoveTrace.bat")
    time.sleep(30)
    Output = fn_VerifyTracefiles(
        "sched->Exec() starting",
        Configuration["CITraceFileLocation"],
        "wfTnpNad",
        "CITNP",
    )
    os.chdir(cwd)
    assert Output != False, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Start CITNP",
        "CITNP  Fatal - Assert",
    )


@given("Start CI APJOB")
def step_impl(context):
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["APJOB"])
    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"MoveTrace.bat")
    time.sleep(30)
    Output = fn_VerifyTracefiles(
        "sched->Exec() starting",
        Configuration["CITraceFileLocation"],
        "WFAPJob",
        "APJOB",
    )
    os.chdir(cwd)
    assert Output != False, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Start APJOB",
        "APJOB  Fatal - Assert",
    )


@then("Upgrade Posting2.0")
def step_impl(context):
    MessageLogger.info("Upgrading with Posting2.0")
    MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["Posting2.0"])
    context.ps_script_path = os.path.join(
        Configuration["Posting2.0"], Configuration["PSFileName"]
    )
    MessageLogger.info(context.ps_script_path)
    try:
        output = subprocess.check_output(
            ["powershell.exe", "-File", context.ps_script_path],
            stderr=subprocess.STDOUT,
            shell=True,
            universal_newlines=True,
        )
        context.ps_script_output = output
    except subprocess.CalledProcessError as e:
        context.ps_script_output = e.output
    os.chdir(cwd)


@given("Test Given")
def step_impl(context):
    MessageLogger.info("Given is executed")


@given('Run feature file "{feature_file}"')
def step_impl(context, feature_file):
    # feature_file = feature_file + " --no-capture"
    subprocess.run(["behave", feature_file], check=True)


@given('Post purchase of $"{amount}" by trancode "{trancode}"')
def step_impl(context, amount, trancode):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        data = {
            "TagName": ["AccountNumber", "TranType", "TransactionAmount"],
            "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount"],
        }
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        payLoad["TranType"] = trancode
        payLoad["TransactionAmount"] = amount
        MessageLogger.info(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        MessageLogger.info(payLoad)
        context.response = response
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )


@given('Post cash purchase of $"{amount}" by trancode "{trancode}" and "{CPM}"')
def step_impl(context, amount, trancode, CPM):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        data = {
            "TagName": ["AccountNumber", "TranType", "TransactionAmount"],
            "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount"],
        }
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        payLoad["TranType"] = trancode
        payLoad["TransactionAmount"] = amount
        payLoad["CreditPlanMaster"] = CPM
        MessageLogger.info(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        MessageLogger.info(payLoad)
        context.response = response
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
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )


@given('Post Payment_"{cnt}" of $"{amount}" by trancode "{trancode}" at "{posttime}"')
def step_impl(context, cnt, amount, trancode, posttime):
    try:
        MessageLogger.info("Code with new executionid", get_global_EXECUTION_ID())
        MessageLogger.info(amount)
        EXECUTION_ID = get_global_EXECUTION_ID()

        # MessageLogger.info(re.search(r'^+', amount))
        TotalAmount = 0.0
        if "+" in amount:
            AmountList = amount.split("+")
            MessageLogger.info(AmountList)
            for amountValue in AmountList:
                if not re.match(r"^\d+$", amountValue):
                    TotalAmount = TotalAmount + float(
                        fn_GetValueFromDataStore(EXECUTION_ID, amountValue)
                    )
                else:
                    TotalAmount = TotalAmount + float(amountValue)
        elif "-" in amount:
            AmountList = amount.split("-")
            MessageLogger.info(AmountList)
            for amountValue in AmountList:
                if not re.match(r"^\d+$", amountValue):
                    TotalAmount = TotalAmount + float(
                        fn_GetValueFromDataStore(EXECUTION_ID, amountValue)
                    )
                else:
                    TotalAmount = TotalAmount - float(amountValue)
        elif not re.match(r"^\d+$", amount):
            value = fn_GetValueFromDataStore(EXECUTION_ID, amount)
            TotalAmount = value
        else:
            TotalAmount = amount

        amount = str(TotalAmount)

        # if not re.match(r'^\d+$', amount):
        #     value = fn_GetValueFromDataStore(EXECUTION_ID, amount)
        #     amount = value

        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        data = {
            "TagName": [
                "AccountNumber",
                "TranType",
                "TransactionAmount",
                "DateTimeLocalTransaction",
            ],
            "VariableName": [
                "@MyAccountNumber",
                "TranType",
                "TransactionAmount",
                "DateTimeLocalTransaction",
            ],
        }
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        payLoad["TranType"] = trancode
        payLoad["TransactionAmount"] = amount
        if posttime != "posttime":
            payLoad["DateTimeLocalTransaction"] = posttime
        else:
            payLoad["DateTimeLocalTransaction"] = ""
        MessageLogger.info(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)

        MessageLogger.info(payLoad)
        context.response = response
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
        MessageLogger.info("APIResponse", JsonData)
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

        APIName = "PostSingleTransaction"
        TagName = "Payment_" + str(cnt) + "_Tranid"
        jsonResponse = fn_GetAPIResponseTags(APIName)
        jsonResponse = fn_OverrideTagName(jsonResponse, "TransactionID", TagName)
        table_var = fn_TablefromJSON(jsonResponse)
        MessageLogger.info("Rohit", table_var)
        context.payment_table = table_var
        MessageLogger.info(context.payment_table)
        MessageLogger.info("Rohit here for save variable")
        MessageLogger.info("json variable value", context.jsonData)
        assert len(context.payment_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail More than two column",
        )
        try:
            for row in context.payment_table:
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
            MessageLogger.info(f"AssertionError occurred: {ae}")
            raise Exception("An error occurred during this step")
        except Exception as e:
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Fail ",
            )
            MessageLogger.info(str(e))
            raise Exception("An error occurred during this step")

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )


@given('Post Payment Reversal of Payment_"{cnt}"')
def step_impl(context, cnt):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        Payment_1 = "Payment_" + str(cnt) + "_Tranid"
        # MessageLogger.info(Payment_1)
        # TxnDetail =fn_GetTxnDetails(0,Payment_1, context.feature.name)
        TxnDetail = fn_GetTxnDetails(EXECUTION_ID, Payment_1, context.feature.name)
        MessageLogger.info(TxnDetail)
        data = {
            "TagName": [
                "AccountNumber",
                "TranType",
                "TransactionAmount",
                "ReversalTargetTranID",
            ],
            "VariableName": [
                "@MyAccountNumber",
                "TranType",
                "TransactionAmount",
                "ReversalTargetTranID",
            ],
        }

        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        first_item = TxnDetail[0]
        MessageLogger.info("first_item")
        MessageLogger.info(first_item)

        # Access the value associated with "ManualReversalTrancode" in the dictionary
        result = first_item.get(
            "ManualReversalTrancode", None
        )  # Use .get() to avoid KeyError
        payLoad["TranType"] = first_item.get("ManualReversalTrancode", None)
        payLoad["TransactionAmount"] = first_item.get("transactionamount", None)
        payLoad["ReversalTargetTranID"] = first_item.get("tranid", None)
        payLoad["AccountNumber"] = first_item.get("accountnumber", None)
        MessageLogger.info(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        # if posttime  != "posttime":
        #     payLoad['DateTimeLocalTransaction'] = posttime
        # MessageLogger.info (payLoad)
        context.response = response
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
        MessageLogger.info("APIResponse", JsonData)
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

        APIName = "PostSingleTransaction"
        TagName = "Payment_" + str(cnt) + "_Tranid_rev"
        jsonResponse = fn_GetAPIResponseTags(APIName)
        jsonResponse = fn_OverrideTagName(jsonResponse, "TransactionID", TagName)
        table_var = fn_TablefromJSON(jsonResponse)
        MessageLogger.info("Rohit", table_var)
        context.payment_table = table_var
        MessageLogger.info(context.payment_table)
        MessageLogger.info("Rohit here for save variable")
        MessageLogger.info("json varailbe value", context.jsonData)
        assert len(context.custom_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail More than two column",
        )
        try:
            for row in context.payment_table:
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
            MessageLogger.info(f"AssertionError occurred: {ae}")
            raise Exception("An error occurred during this step")
        except Exception as e:
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Fail ",
            )
            MessageLogger.info(str(e))
            raise Exception("An error occurred during this step")

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )
        MessageLogger.info(e)


@given('Run as "{action}"')
def step_impl(context, action):
    MessageLogger.info(context.feature.name)
    EXECUTION_ID = fn_setexeutionID(context.feature.name, action)
    MessageLogger.info(EXECUTION_ID)


@given("Get Account Plan Details")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execuationid" + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        MessageLogger.info(EXECUTION_ID)
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get Account Plan Details",
            "InProgress",
        )
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        # MessageLogger.info(payLoad)
        context.AccountNumber = payLoad["AccountNumber"]
        # MessageLogger.info(context.AccountNumber)
        response = fn_GetAllDetails(context.AccountNumber)
        context.response = response
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get Account Plan Details",
            "Done",
        )

        file_path = os.path.join(RootPath, "JsonPayload")
        file_path = os.path.join(file_path, context.feature.name)
        if not os.path.exists(file_path):
            os.makedirs(file_path)

        # file_path = f'E:\\Python\\BehaveBDD\\features\\JsonPayload\\PlanDetails_{context.feature.name}.json'
        file_name = (
            f"Account_Plan_Details_{context.scenario.name}.json"
        )
        file_path = file_path + "\\" + file_name
        # JsonData = context.response.json()
        # context.jsonData = context.response.json()
        with open(file_path, "w") as json_file:
            json.dump(context.response, json_file, indent=2)

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.info(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")


