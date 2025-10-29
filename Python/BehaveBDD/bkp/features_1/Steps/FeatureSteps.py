from behave import *
# from ExecutableFunctions.Environment import *
from ExecutableFunctions.DataBaseConnections import *
from ExecutableFunctions.DatabaseORM import *
from ExecutableFunctions.ExecutableFunctions import *
from ExecutableFunctions.DataManager import *
from ExecutableFunctions.DataManager import EXECUTION_ID
import time
import subprocess
from ExecutableFunctions.MiniDice import fn_VerifyTracefiles

Cursor = DBCon.cursor()
Cursor_CoreAuth = DBCon_CoreAuth.cursor()



@given('Create Account')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Account",'InProgress')
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)
        response =  fn_HitAPI("AccountCreation",payLoad)
        context.response = response
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Account",'Done')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Account",'Fail ')
        print(str(e))
        raise Exception('An error occurred during this step')
        #raise Exception('An error occurred during this step')

@when('Verify API response is OK')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'InProgress')

        assert context.response.ok , fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Fail Assert API Response is not ok')
        JsonData = context.response.json()
        ErrorFound,ErrorNumber,ErrorMessage = fn_CheckErrorFound(JsonData)
        print(f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}")
        assert ErrorFound.upper() == 'NO' ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'FAIL Error Found Yes')
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Fail Exception Occurs')
        print(str(e))
        raise Exception('An error occurred during this step')


@then('Verify Account Number in Database')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Account Number in Database",'InProgress')
        if context.response.ok:
            context.jsonData = context.response.json()
            cursor.execute(f"SELECT TOP 1 1 FROM Bsegment_Primary WITH(NOLOCK) WHERE AccountNumber={context.jsonData['AccountNumber']}")
            AccountRes = cursor.fetchall()

            assert len(AccountRes)>=1,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Account Number in Database",'Fail AccountNumber Not found in DB')
            fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Account Number in Database",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Account Number in Database",'Fail ')
        print(str(e))
        raise Exception('An error occurred during this step')




@then('Save tag into variable')
def step_impl(context):
    assert len(context.table[0]) ==2 ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Save tag into variable",'Fail More than two column')
    try:
        for row in context.table:
            fn_InsertFeatureStepDataStore(EXECUTION_ID,context.feature.name,context.scenario.name,row[1],str(context.jsonData[row[0]]))
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Save tag into variable",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Save tag into variable",'Fail ')
        print(str(e))
        raise Exception('An error occurred during this step')



@given("Create Secondary Card")
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Secondary Card",'InProgress')
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)
        response =  fn_HitAPI("SecondaryCardCreation",payLoad)
        context.response = response
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Secondary Card",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Create Secondary Card",'Fail ')
        print(str(e))
        raise Exception('An error occurred during this step')


""" @given('Post Transaction')
def step_impl(context,APIName):
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,'InProgress')
    payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)
    response = fn_HitAPI(APIName,payLoad)
    context.response = response
    assert response.ok ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,'Fail API Response is not ok ')
"""

@given('Post Transaction')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Transaction",'InProgress')
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)
        response = fn_HitAPI('PostSingleTransaction',payLoad)
        context.response = response
        context.AccountNumber = payLoad['AccountNumber']
        context.TransactionAmount = payLoad['TransactionAmount']
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Transaction",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Transaction",'Fail - ')


@then('Verify Transaction in DB')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'InProgress')
        sql = f""" SELECT * FROM CCard_Primary WITH(NOLOCK) WHERE AccountNumber = {context.AccountNumber} AND
            TransactionAmount = {context.TransactionAmount}
        """
        #print(sql)
        cursor.execute(sql)
        res =cursor.fetchall()
        assert len(res)>=1 ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'Fail - Transaction is not present in CCard_Primary')
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify Transaction in DB",'Fail ')
        print(str(e))
        raise Exception('An error occurred during this step')

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
    #print(sql)

@then('Age system "{nDays}" days')
def step_impl(context,nDays):
    CurrentTnpDate =fn_GetAgingDate(nDays)
    tnpdate = CurrentTnpDate.split('-')
    Month , Date , Year = tnpdate[1] , tnpdate[2] , tnpdate[0]

    fn_SetDateInTview(Month , Date , Year)

    while not(fn_checkAgingDate(CurrentTnpDate)):
        print("Aging is InProgress")
        time.sleep(30)

@given('Post Manual Auth')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Manual Auth",'InProgress')
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)
        #print(payLoad)
        response = fn_HitAPI('ManualAuth',payLoad)
        context.response = response
        context.AccountNumber = payLoad['AccountNumber']
        if payLoad.get('TransactionAmount' , None) is None:
            #print("RItik===========================")
            #print(fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount'))
            context.TransactionAmount = fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount')
        else:
            context.TransactionAmount = payLoad['TransactionAmount']
        time.sleep(2)
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Manual Auth",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post Manual Auth",'Fail - ')
        print(e)



@when('Post ReatilAuth')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post ReatilAuth",'InProgress')
        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID,context.table)

        response = fn_HitAPI('RetailManualAuth',payLoad)
        context.response = response
        context.AccountNumber = payLoad['AccountNumber']
        """ if payLoad.get('TransactionAmount' , None) is None:
            #print("RItik===========================")
            print(fn_GetKeyValueFromJsonFile('RetailManualAuth','TransactionAmount'))
            context.TransactionAmount = fn_GetKeyValueFromJsonFile('ManualAuth','TransactionAmount')
        else:
            context.TransactionAmount = payLoad['TransactionAmount']  """
        time.sleep(2)
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post ReatilAuth",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Post ReatilAuth",'Fail - ')
        print(e)
        raise Exception('An error occurred during this step')

@then(u'Verify API response is OK')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'InProgress')

        assert context.response.ok , fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Fail Assert API Response is not ok')
        JsonData = context.response.json()
        ErrorFound,ErrorNumber,ErrorMessage = fn_CheckErrorFound(JsonData)
        print(f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}")
        assert ErrorFound.upper() == 'NO' ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'FAIL Error Found Yes')
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Done')
    except AssertionError as ae:
        # Handle AssertionError specifically (if needed)
        print(f"AssertionError occurred: {ae}")
        raise Exception('An error occurred during this step')
    except Exception as e:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,"Verify API response is OK",'Fail Exception Occurs')
        print(str(e))
        raise Exception('An error occurred during this step')


@then('Pause for "{WaitforDelay}" Second')
def step_impl(context,WaitforDelay):
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Wait for {WaitforDelay} Second','InProgress')
    time.sleep(int(WaitforDelay))
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Wait for {WaitforDelay} Second','Done')


@given('Make bin file entry in txt file')
def step_impl(context):
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Make bin file entry in txt file','InProgress')
    FI = open(r"D:\OnePackageSetup\BIN_SETUP\Input\Main.txt","w")
    FI.write("100_MC_Card.bin")
    FI.close()
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Make bin file entry in txt file','Done')


@when(u'start "sim.bat"')
def step_impl(context):
    try:
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'start sim.bat','InProgress')
        cwd  = os.getcwd()
        Cursor_CoreAuth.execute("SELECT Count(1) AS Count from CoreAuthTransactions WITH(NOLOCK)")
        context.count = int(Cursor_CoreAuth.fetchone()[0])
        os.chdir("D:\OnePackageSetup\BIN_SETUP\Input")
        a=subprocess.run(["D:\OnePackageSetup\BIN_SETUP\Input\sim.bat"],shell=True,stdout=subprocess.PIPE,text=True,check=True)
        os.chdir(cwd)
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'start sim.bat','Done')
    except subprocess.CalledProcessError as e:
        print(e)
        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'start sim.bat','Fail')
        raise Exception('An error occurred during this step')


@then(u'verify entry in CoreAuthTransaction')
def step_impl(context):
    Cursor_CoreAuth.execute("SELECT Count(1) AS Count from CoreAuthTransactions WITH(NOLOCK)")
    AfterExecCount = int(Cursor_CoreAuth.fetchone()[0])
    assert AfterExecCount > context.count,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'verify entry in CoreAuthTransaction','Fail - Assert')
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'verify entry in CoreAuthTransaction','Done')
    print("verified in database ")



@given(u'Take DB Backup')
def step_impl(context):
    res =  fn_TakeDBbackup()
    assert res!=1 ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Fail - Assert')
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Done')

@given(u'Pause')
def step_impl(context):
    input("Press ENTER to continue execution")

@when(u'Take DB Backup')
def step_impl(context):
    res =  fn_TakeDBbackup()
    assert res!=1 ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Fail - Assert')
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Done')

@when(u'Pause')
def step_impl(context):
    input("Press ENTER to continue execution")

@then(u'Take DB Backup')
def step_impl(context):
    res =  fn_TakeDBbackup()
    assert res!=1 ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Fail - Assert')
    fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Take DB Backup','Done')

@then(u'Pause')
def step_impl(context):
    input("Press ENTER to continue execution")

@given('Start CI AppServer')
def step_impl(context):
    cwd =  os.getcwd()
    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["CIAppServerName"])

    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"Flush.bat")
    time.sleep(60)
    Output = fn_VerifyTracefiles('Ready for Login',Configuration["CITraceFileLocation"],'appCardinal','CoreIusse Appserver')
    os.chdir(cwd)
    assert Output!=False ,fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,context.feature.name,context.scenario.name,f'Start CI AppServer','AppServer Fatal - Assert')

