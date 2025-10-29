import time
from behave import *
from Scripts.GetLogger import MessageLogger
from Scripts.DataBaseConnections import *
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID
from Scripts.ExecutableFunctions import *
from Scripts.Config import *

Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()

if get_global_EXECUTION_ID() is not None:
    EXECUTION_ID = get_global_EXECUTION_ID()

@given('Correct ARSystem Setup "{Date}"')
def step_impl(context, Date):

    sql = f"SELECT UpdateStatus FROM LogARSystemHS_Update_Behave WITH(NOLOCK) WHERE Activity = 'Update ARSystemHSAccounts' AND ProcDay = '{Date}'"

    UpdateStatus = None

    if sql is not None:
        cursor = DBCon.cursor()
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                UpdateStatus = str(r.UpdateStatus)

    if UpdateStatus is None or UpdateStatus == "0":
        sql = read_file_to_string(os.path.join(BasePath, 'SQL\\Update_ARSystemHSAccounts_InstitutionID.sql'))
        
        if sql is not None:
            cursor = DBCon.cursor()
            cursor.execute(sql)

@Then('Start ACHProcessStep_1_DayChange "{Date}"')
def step_impl(context, Date):
    MessageLogger.info("Inside Running ACH Batch Day Change")
    sql = f"SELECT TOP 1 1 Status from ACHDailyRun WITH(NOLOCK) WHERE EODFlag = 1 AND RunDate = '{Date}' ORDER BY RunID DESC"
    MessageLogger.info(sql)
    Status = "0"
    if sql is not None:
        cursor = DBCon.cursor()
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                Status = str(r.Status)
    
    MessageLogger.info("Last ACH batch Status " + Status)
    if Status is None or Status == "0" or Status == "":
        MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
        EXECUTION_ID = get_global_EXECUTION_ID()
        cwd = os.getcwd()
        os.chdir(Configuration["CIBatchScripts"])
        os.startfile(Configuration["CIBatchfileName"]["ACHProcessStep_1_DayChange"])
        # os.chdir(Configuration["CITraceFileLocation"])
        # os.startfile(r"MoveIntoTrash.bat")
        time.sleep(10)
        os.chdir(cwd)

@Then('Start ACHProcessStep_1')
def step_impl(context):
    MessageLogger.info("Inside Running ACH Batch")
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    cwd = os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["ACHProcessStep_1"])
    # os.chdir(Configuration["CITraceFileLocation"])
    # os.startfile(r"MoveIntoTrash.bat")
    time.sleep(10)
    os.chdir(cwd)

@Given('Wait for EOD Job "{Date}"')
def step_impl(context, Date):

    sql = f"SELECT UpdateStatus FROM LogARSystemHS_Update_Behave WITH(NOLOCK) WHERE Activity = 'Set NAD Mode' AND ProcDay = '{Date}'"

    UpdateStatus = None

    if sql is not None:
        cursor = DBCon.cursor()
        cursor.execute(sql)
        result = cursor.fetchall()
        if len(result) > 0:
            for r in result:
                UpdateStatus = str(r.UpdateStatus)

    if UpdateStatus is None or UpdateStatus == "0":

        while(True):
            MessageLogger.debug("Waiting for EOD Job to get process")
            sql = """
            SELECT  C.* 
            FROM CommonTNP C WITH (NOLOCK)
            LEFT JOIN ARSystemHSAccounts A WITH(NOLOCK) ON (C.InstitutionID = A.InstitutionID)
            WHERE ATID = 100 
            AND C.TranTime <= A.ProcDayEnd
            """
            if sql is not None:
                cursor = DBCon.cursor()
                cursor.execute(sql)

                result = cursor.fetchall()

                if len(result) > 0:
                    time.sleep(5)
                else:
                    break
        
        while(True):
            MessageLogger.debug("Waiting for EOD Job to get process")
            sql = """
            SELECT * FROM EOD_AsystemHS WITH(NOLOCK) WHERE Status IN ('NEW') 
            """
            count = 0
            if sql is not None:
                cursor = DBCon.cursor()
                cursor.execute(sql)

                result = cursor.fetchall()
                count = len(result)
            sql = """
            SELECT * FROM Institutions WITH(NOLOCK)  
            """
            count2 = 0
            if sql is not None:
                cursor = DBCon.cursor()
                cursor.execute(sql)

                result = cursor.fetchall()
                count2 = len(result)
            
            if count == count2 and count2 > 0:
                break
            else:
                time.sleep(5)
        


@Then('Set NAD Mode "{flag}" "{Date}"')
def step_impl(context, flag, Date):
    if flag == "1":
        sql = f"SELECT UpdateStatus FROM LogARSystemHS_Update_Behave WITH(NOLOCK) WHERE Activity = 'Set NAD Mode' AND ProcDay = '{Date}'"
        UpdateStatus = None

        if sql is not None:
            cursor = DBCon.cursor()
            cursor.execute(sql)
            result = cursor.fetchall()
            if len(result) > 0:
                for r in result:
                    UpdateStatus = str(r.UpdateStatus)

        if UpdateStatus is None or UpdateStatus == "0":
            sql = """
            WHILE (1 = 1)
            BEGIN
                IF EXISTS (SELECT TOP 1 1 FROM EOD_AsystemHS WITH(NOLOCK) WHERE Status IN ('NEW'))
                    EXEC USP_EOD_AsystemHS_JOB
                ELSE
                    BREAK
            END

            INSERT INTO LogARSystemHS_Update_Behave (Activity, ProcDay, UpdateStatus)
	        SELECT TOP 1 'Set NAD Mode', TRY_CAST(OldProcDayEnd AS DATE), 1 FROM EOD_AsystemHS WITH(NOLOCK) ORDER BY Skey DESC
            """
            if sql is not None:
                cursor = DBCon.cursor()
                cursor.execute(sql)

@Given('Wait for Statement "{StatementDate}"')
def step_impl(context, StatementDate):
    MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
    EXECUTION_ID = get_global_EXECUTION_ID()
    AccountNumber = fn_GetValueFromDataStore(EXECUTION_ID, 'MyAccountNumber')
    sql = f"SELECT TOP 1 1 FROM StatementHeader WITH(NOLOCK) WHERE StatementDate = '{StatementDate}' AND AccountNumber = '{AccountNumber}'"

    while (True):
        if sql is not None:
            Cursor.execute(sql)
            result = Cursor.fetchall()
            if len(result) > 0:
                break
            else:
                time.sleep(3)
            