from behave import *
import subprocess
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID
from Scripts.ExecutableFunctions import *
from Scripts.DataManager import fn_UpdateCITable

@when("Enable Posting2.0")
def step_impl(context):
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


@when("Disable Posting2.0")
def step_impl(context):
    try:
        EXECUTION_ID = get_global_EXECUTION_ID()
        MessageLogger.info("Code with new execution id: " + str(EXECUTION_ID))
        data = {"TagName": ["AccountNumber"], "VariableName": ["@MyAccountNumber"]}
        context.PaymentTable = fn_TablefromJSON(data)
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
        # MessageLogger.info(payLoad)
        context.AccountNumber = payLoad["AccountNumber"]
        fn_UpdateCITable(context.AccountNumber, "BSegment_Primary", "ReProjectionFlag", "0")
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        MessageLogger.error(f"AssertionError occurred: {ae}")
        raise Exception("An error occurred during this step")
    except Exception as e:
        MessageLogger.error(str(e))
        raise Exception("An error occurred during this step")
    

@then("Upgrade Posting2.0")
def step_impl(context):
    MessageLogger.info("Upgrading with Posting2.0")
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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