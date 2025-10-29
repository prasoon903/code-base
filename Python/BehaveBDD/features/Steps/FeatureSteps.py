from behave import *

# from ExecutableFunctions.Environment import *
from ExecutableFunctions.DataBaseConnections import *
from ExecutableFunctions.DatabaseORM import *
from ExecutableFunctions.ExecutableFunctions import *
from ExecutableFunctions.DataManager import *

# from ExecutableFunctions.DataManager import EXECUTION_ID
import time
import subprocess

from ExecutableFunctions.GetAccountPlanData import fn_GetAllDetails
from ExecutableFunctions.MiniDice import fn_VerifyTracefiles, DBRestoreWithBackUp

from ExecutableFunctions.MiniDice import DBRestore

from ExecutableFunctions.MiniDice import fn_VerifyTracefiles

from ExecutableFunctions.ExecutableFunctions import fn_getmaxexecuationidforfeature

# from ExecutableFunctions.ExecutableFunctions import get_global_EXECUTION_ID

from ExecutableFunctions.DataManager import fn_setexeutionID
from ExecutableFunctions.ScenarioExecution import fn_fileSplitter, fn_ExecuteSteps

Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if get_global_EXECUTION_ID() is not None:
    EXECUTION_ID = get_global_EXECUTION_ID()


@given("Create Account")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Account",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")
        # raise Exception('An error occurred during this step')


@when("Verify API response is OK")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@then("Verify Account Number in Database")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Account Number in Database",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@then("Save tag into variable")
def step_impl(context):
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@then('Save tag into variable "{APIName}"')
def step_impl(context, APIName):
    print("Code with new execuationid", get_global_EXECUTION_ID())
    EXECUTION_ID = get_global_EXECUTION_ID()
    print(APIName)
    jsonResponse = fn_GetAPIResponseTags(APIName)
    jsonResponse = fn_OverrideTagName(
        jsonResponse, "MyAccountNumber", "MyAccountNumber"
    )
    table_var = fn_TablefromJSON(jsonResponse)
    print(table_var)
    context.custom_table = table_var
    print(context.custom_table)
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Save tag into variable",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@given("Create Secondary Card")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Create Secondary Card",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@given("Post Transaction")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        # print(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        print(payLoad)
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(sql)
        cursor.execute(sql)
        res = cursor.fetchall()
        res2 = {}
        print(len(res))
        bflag = False
        loopcount = 0
        while bflag == False:
            if len(res) > 0:
                sql = f""" SELECT * FROM CCard_Primary c WITH(NOLOCK) join trans_in_acct tia (nolock)
                 on c.tranid = tia.tran_id_index 
                 WHERE AccountNumber = {context.AccountNumber} AND
                    Tranid = {context.TransactionID} AND tia.ATID=51
                """
                print(sql)
                loopcount = loopcount + 1
                cursor.execute(sql)
                res1 = cursor.fetchall()
                print(len(res1))
                if len(res1) > 0:
                    bflag = True
                    print("Transaction posting sucessfully", context.TransactionID)
                else:
                    bflag = False
                    print("Transaction posting is InProgress", context.TransactionID)
                    time.sleep(5)
                    if loopcount > 10:
                        sql = f""" SELECT * FROM Errortnp e WITH(NOLOCK) 
                                        WHERE  Tranid = {context.TransactionID} 
                                       """
                        print(sql)
                        cursor.execute(sql)
                        res2 = cursor.fetchall()
                        print(len(res2))
                        if len(res2) > 0:
                            print(
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify Transaction in DB",
            "Fail ",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@given("Age TestAccount")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()
        print(EXECUTION_ID)
        # print(get_global_EXECUTION_ID())
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
        print(payLoad)
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
        print(
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(f"AssertionError occurred: {ae}")
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
            print("Ritik")
            query = query.replace("{TableName}",TableName)
            if index+1 == counter:
                query = query+f" {ColumnName} = '{Value}'"
            else:
                query = query+f" {ColumnName} = '{Value}' AND"
                
            previousTableName = str(TableName).strip()
            if index+1 == counter:
                sql.append(query)
        else:
            print("riitkelse")
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
    # print(sql)


@then('Age system "{nDays}" days')
def step_impl(context, nDays):
    CurrentTnpDate = fn_GetAgingDate(nDays)
    tnpdate = CurrentTnpDate.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]

    fn_SetDateInTview(Month, Date, Year)

    while not (fn_checkAgingDate(CurrentTnpDate)):
        print("Aging is InProgress")
        time.sleep(30)


@then('Age system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    CurrentTnpDate = fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)
    while not (fn_checkAgingDate(Datetocheck)):
        print("Aging is InProgress")
        time.sleep(15)


@then('Set system to "{Date}" Date')
def step_impl(context, Date):
    Datetocheck = Date
    # CurrentTnpDate =fn_GetCurrentCommonTNPDate()
    tnpdate = Date.split("-")
    Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
    fn_SetDateInTview(Month, Date, Year)


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
#         print("Aging is InProgress")
#         time.sleep(15)


@given("Post Manual Auth")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Manual Auth",
            "InProgress",
        )
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
        # print(payLoad)
        response = fn_HitAPI("ManualAuth", payLoad)
        context.response = response
        context.AccountNumber = payLoad["AccountNumber"]
        if payLoad.get("TransactionAmount", None) is None:
            # print("RItik===========================")
            # print(fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount'))
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Manual Auth",
            "Fail - ",
        )
        print(e)


@when("Post ReatilAuth")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
            #print("RItik===========================")
            print(fn_GetKeyValueFromJsonFile('RetailManualAuth','TransactionAmount'))
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post ReatilAuth",
            "Fail - ",
        )
        print(e)
        raise Exception("An error occurred during this step")


@then("Verify API response is OK")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(
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
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Verify API response is OK",
            "Fail Exception Occurs",
        )
        print(str(e))
        raise Exception("An error occurred during this step")


@then('Pause for "{WaitforDelay}" Second')
def step_impl(context, WaitforDelay):
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(e)
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("verified in database ")


@given("Take DB Backup")
def step_impl(context):
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"StopProcesses.bat")
    time.sleep(15)
    os.chdir(cwd)


@given("Restore Database")
def step_impl(context):
    print("Code with new execuationid", get_global_EXECUTION_ID())
    EXECUTION_ID = get_global_EXECUTION_ID()
    print("Database Restore")
    DBRestore()


@given("Restore Database with backup")
def step_impl(context):
    print("Code with new execuationid", get_global_EXECUTION_ID())
    EXECUTION_ID = get_global_EXECUTION_ID()
    print("Database Restore with backup")
    DBRestoreWithBackUp()


@given("Start CITNP")
def step_impl(context):
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Code with new execuationid", get_global_EXECUTION_ID())
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
    print("Upgrading with Posting2.0")
    print("Code with new execuationid", get_global_EXECUTION_ID())
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["Posting2.0"])
    context.ps_script_path = os.path.join(
        Configuration["Posting2.0"], Configuration["PSFileName"]
    )
    print(context.ps_script_path)
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
    print("Given is executed")


@given('Run feature file "{feature_file}"')
def step_impl(context, feature_file):
    # feature_file = feature_file + " --no-capture"
    subprocess.run(["behave", feature_file], check=True)


@given('Post purchase of $"{amount}" by trancode "{trancode}"')
def step_impl(context, amount, trancode):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        print(payLoad)
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
        print(
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
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
        print(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        print(payLoad)
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
        print(
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
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new executionid", get_global_EXECUTION_ID())
        print(amount)
        EXECUTION_ID = get_global_EXECUTION_ID()

        # print(re.search(r'^+', amount))
        TotalAmount = 0.0
        if "+" in amount:
            AmountList = amount.split("+")
            print(AmountList)
            for amountValue in AmountList:
                if not re.match(r"^\d+$", amountValue):
                    TotalAmount = TotalAmount + float(
                        fn_GetValueFromDataStore(EXECUTION_ID, amountValue)
                    )
                else:
                    TotalAmount = TotalAmount + float(amountValue)
        elif "-" in amount:
            AmountList = amount.split("-")
            print(AmountList)
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
        print(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)

        print(payLoad)
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
        print("APIResponse", JsonData)
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        print(
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
        print("Rohit", table_var)
        context.payment_table = table_var
        print(context.payment_table)
        print("Rohit here for save variable")
        print("json variable value", context.jsonData)
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
            print(f"AssertionError occurred: {ae}")
            raise Exception("An error occurred during this step")
        except Exception as e:
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Fail ",
            )
            print(str(e))
            raise Exception("An error occurred during this step")

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
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
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "InProgress",
        )
        Payment_1 = "Payment_" + str(cnt) + "_Tranid"
        # print(Payment_1)
        # TxnDetail =fn_GetTxnDetails(0,Payment_1, context.feature.name)
        TxnDetail = fn_GetTxnDetails(EXECUTION_ID, Payment_1, context.feature.name)
        print(TxnDetail)
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
        print("first_item")
        print(first_item)

        # Access the value associated with "ManualReversalTrancode" in the dictionary
        result = first_item.get(
            "ManualReversalTrancode", None
        )  # Use .get() to avoid KeyError
        payLoad["TranType"] = first_item.get("ManualReversalTrancode", None)
        payLoad["TransactionAmount"] = first_item.get("transactionamount", None)
        payLoad["ReversalTargetTranID"] = first_item.get("tranid", None)
        payLoad["AccountNumber"] = first_item.get("accountnumber", None)
        print(payLoad)
        response = fn_HitAPI("PostSingleTransaction", payLoad)
        # if posttime  != "posttime":
        #     payLoad['DateTimeLocalTransaction'] = posttime
        # print (payLoad)
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
        print("APIResponse", JsonData)
        ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
        print(
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
        print("Rohit", table_var)
        context.payment_table = table_var
        print(context.payment_table)
        print("Rohit here for save variable")
        print("json varailbe value", context.jsonData)
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
            print(f"AssertionError occurred: {ae}")
            raise Exception("An error occurred during this step")
        except Exception as e:
            fn_InsertFeatureStepExecutionInfo(
                EXECUTION_ID,
                context.feature.name,
                context.scenario.name,
                "Save tag into variable",
                "Fail ",
            )
            print(str(e))
            raise Exception("An error occurred during this step")

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Post Transaction",
            "Fail - ",
        )
        print(e)


@given('Run as "{action}"')
def step_impl(context, action):
    print(context.feature.name)
    EXECUTION_ID = fn_setexeutionID(context.feature.name, action)
    print(EXECUTION_ID)


@given("Get Account Plan Details")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()
        print(EXECUTION_ID)
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
        # print(payLoad)
        context.AccountNumber = payLoad["AccountNumber"]
        # print(context.AccountNumber)
        response = fn_GetAllDetails(context.AccountNumber)
        # response = fn_HitAPI("AccountSummary", payLoad)
        context.response = response
        # context.AccountNumber = payLoad['AccountNumber']
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get Account Plan Details",
            "Done",
        )

        # file_path = f'E:\\Python\\BehaveBDD\\features\\JsonPayload\\PlanDetails_{context.feature.name}.json'
        file_path = (
            f"Account_Plan_Details_{context.feature.name}_{context.scenario.name}.json"
        )
        # JsonData = context.response.json()
        # context.jsonData = context.response.json()
        with open(file_path, "w") as json_file:
            json.dump(context.response, json_file, indent=2)

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")


@given("Split files")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()

        fn_fileSplitter()

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")


@given("Execute files")
def step_impl(context):
    try:
        print("Code with new execuationid", get_global_EXECUTION_ID())
        EXECUTION_ID = get_global_EXECUTION_ID()

        fn_ExecuteSteps()

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
