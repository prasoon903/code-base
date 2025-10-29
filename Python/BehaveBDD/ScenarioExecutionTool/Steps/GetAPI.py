from behave import *

from Scripts.DataManager import *
from Scripts.HelperFunction import *
from Scripts.ExecutableFunctions import *
from Scripts.Config import *
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID
from Scripts.GetAccountPlanData import fn_GetAllDetails


@given("Get AccountSummary")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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
        # MessageLogger.info(payLoad)
        (response,request) = fn_HitAPI("AccountSummary", payLoad)
        context.response = response
        context.request = request
        context.AccountNumber = payLoad["AccountNumber"]
        # MessageLogger.info(context.response)
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
        if response.status_code == 200 and JsonData is not None:
            fileName = f"{context.feature.name}_{context.scenario.name}_AccountSummary.json"
            ReposnseFileDir = os.path.join(BasePath, "JsonResponse", context.feature.name)
            FullFilePath = os.path.join(ReposnseFileDir , fileName)

            if not os.path.exists(ReposnseFileDir): 
                os.makedirs(ReposnseFileDir)

            with open(FullFilePath, "w") as file:
                json.dump(JsonData, file, indent=2)
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get AccountSummary",
            "Fail ",
        )


@given('Get StatementMetaData "{Date}"')
def step_impl(context, Date):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get StatementMetaData",
            "InProgress",
        )
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        MessageLogger.debug(f"Payload here {payLoad}")

        yyyy, mm, dd = Date.split("-")

        payLoad["StatementDate"] = mm + dd + yyyy
        MessageLogger.debug(f"Payload here {payLoad}")
        (response,request)  = fn_HitAPI("StatementMetaData", payLoad)
        context.response = response
        context.request = request
        context.AccountNumber = payLoad["AccountNumber"]
        JsonData = context.response.json()
        if response.status_code == 200 and JsonData is not None:
            fileName = f"{context.feature.name}_{context.scenario.name}_StatementMetaData_{Date}.json"
            ReposnseFileDir = os.path.join(BasePath, "JsonResponse", context.feature.name)
            FullFilePath = os.path.join(ReposnseFileDir , fileName)

            if not os.path.exists(ReposnseFileDir):
                os.makedirs(ReposnseFileDir)
            

            with open(FullFilePath, "w") as file:
                json.dump(JsonData, file, indent=2)

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
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get StatementMetaData",
            "Fail ",
        )
        MessageLogger.error(f"Error -> {e}")


@given("Get PlanSegmentDetails")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get PlanSegmentDetails",
            "InProgress",
        )
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        (response,request) = fn_HitAPI("PlanSegmentDetails", payLoad)
        context.response = response
        context.request = request
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
        if response.status_code == 200 and JsonData is not None:
            fileName = f"{context.feature.name}_{context.scenario.name}_PlanSegmentDetails.json"
            ReposnseFileDir = os.path.join(BasePath, "JsonResponse", context.feature.name)
            FullFilePath = os.path.join(ReposnseFileDir , fileName)

            if not os.path.exists(ReposnseFileDir):
                os.makedirs(ReposnseFileDir)

            with open(FullFilePath, "w") as file:
                json.dump(JsonData, file, indent=2)

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get PlanSegmentDetails",
            "Fail ",
        )
        MessageLogger.error(f"Error -> {e}")
        
        
@given("Get Account Plan Details")
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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

        file_path = os.path.join(RootPath, "JsonResponse")
        file_path = os.path.join(file_path, context.feature.name)
        if not os.path.exists(file_path):
            os.makedirs(file_path)

        # file_path = f'E:\\Python\\BehaveBDD\\features\\JsonPayload\\PlanDetails_{context.feature.name}.json'
        file_name = (
            f"{context.feature.name}_{context.scenario.name}_Account_Plan_Details.json"
        )
        file_path = file_path + "\\" + file_name
        # JsonData = context.response.json()
        # context.jsonData = context.response.json()
        with open(file_path, "w") as json_file:
            json.dump(context.response, json_file, indent=2)

    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(
            EXECUTION_ID,
            context.feature.name,
            context.scenario.name,
            "Get Account Plan Details",
            "Fail ",
        )
        MessageLogger.error(f"Error -> {e}")