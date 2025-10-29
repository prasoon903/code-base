import os
import time
from behave import *
from Scripts.Config import *
from Scripts.DataManager import *
from Scripts.HelperFunction import *
from Scripts.MiniDice import fn_VerifyTracefiles
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID

Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if get_global_EXECUTION_ID() is not None:
    EXECUTION_ID = get_global_EXECUTION_ID()


@given("Start CI AppServer")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    # LogDateTime = datetime.datetime.now()
    # set_global_EXECUTION_TIME(str(LogDateTime.strftime("%Y%m%d%H%M%S")))
    cwd = os.getcwd()
    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"StopProcesses.bat")
    time.sleep(15)
    os.chdir(cwd)


@given("Stop CI AppServer")
def step_impl(context):
    fn_StopProcess("appCardinal")
    fn_GetProcessDetails()


@given("Stop TNP")
def step_impl(context):
    fn_GetProcessDetails()
    fn_StopProcess("APP_wfTnpNad")
    fn_GetProcessDetails()


@given("Stop APIJob")
def step_impl(context):
    fn_StopProcess("APPWFAPJob")
    fn_GetProcessDetails()


@given("Start CITNP")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()

    check = CheckProcessRunningOnDB("APP_wfTnpNad")
    if not check:
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
        while (True):
            if CheckProcessRunningOnDB("APP_wfTnpNad"):
                break
            else:
                time.sleep(3)
    else:
        MessageLogger.info(" TNP is already running  ")


@given("Start CI APJOB")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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


@given("Start APIJOB")
def step_impl(context):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["APIJOB"])
    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"MoveTrace.bat")
    time.sleep(30)
    Output = fn_VerifyTracefiles(
        "sched->Exec() starting",
        Configuration["CITraceFileLocation"],
        "wfAPIJob",
        "APIJOB",
    )
    os.chdir(cwd)
    assert Output != False, fn_InsertFeatureStepExecutionInfo(
        EXECUTION_ID,
        context.feature.name,
        context.scenario.name,
        f"Start APIJOB",
        "APIJOB  Fatal - Assert",
    )


@when('start "sim.bat"')
def step_impl(context):
    try:
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
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
        os.chdir("D:\\OnePackageSetup\\BIN_SETUP\\Input")
        a = subprocess.run(
            ["D:\\OnePackageSetup\\BIN_SETUP\\Input\\sim.bat"],
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
