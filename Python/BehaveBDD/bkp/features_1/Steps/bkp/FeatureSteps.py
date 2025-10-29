from behave import *
from ExcutableFunctions.ExectableFunction import *
from ExcutableFunctions.DataManager import *
from ExcutableFunctions.DatabaseORM import * 
from ExcutableFunctions.DataManager import EXECUTION_ID



@given('Create Account Using "{APIName}" API using below json tag value')
def CreateAccount(context,APIName):
    
    PayLoad = fn_CreateJsonPayloadUsingTable(context.table)
    Response = fn_HitAPI(APIName,PayLoad)
    context.Response =  Response
    print("Ritik")
    fn_WriteScenarioStaus(context.scenario.tags[0],'PASS')
    print("Ritik..............1")

    
    
         
    
@when('Verify API response is OK')
def CheckResponse(context):

    Response = context.Response
    if Response.ok:
        global ResponseJson 
        ResponseJson = Response.json()
        #print(f"ErrorFound {ResponseJson['ErrorFound']} \nErrorNumber {ResponseJson['ErrorNumber']} \nErrorMessage {ResponseJson['ErrorMessage']}")
        ErrorFound,ErrorNumber,ErrorMessage = fn_CheckErrorFound(ResponseJson)
        print(f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}")
        assert ErrorFound.upper() == 'NO' ,f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}"
    else:
        assert 1==2,f"API Response is other than 200 {Response.status_code}"
    fn_WriteScenarioStaus('SC2','PASS')

@then('Verify Account Number in Database')
def step_impl(context):
    
    a=context.scenario.tags[0]
    cursor = DBCon.cursor()
    #if ResponseJson['AccountNumber'] is not None:
    assert ResponseJson['AccountNumber'] is not None , "Account Number is not found in Json "
    cursor.execute(f"SELECT TOP 1 1 FROM Bsegment_Primary WITH(NOLOCK) WHERE AccountNumber={ResponseJson['AccountNumber']}")
    AccountRes = cursor.fetchall()
    print(ResponseJson['AccountNumber'])
    context.AccountNumber = ResponseJson['AccountNumber']
    
    assert len(AccountRes),f"Account Number Not Exists in database"

    fn_WriteScenarioStaus('SC3','PASS')
        
    
   
@then("Use account Number of Scenario 1")
def step_impl(context):
    assert ResponseJson['AccountNumber'] is not None , "Account Number is not found in Json "

@then('Create Secondary Card Using "{APIName}" API')
def step_impl(context,APIName):
    PayLoad = {
        'AccountNumber' : f"{context.AccountNumber}"
    }
    print(context.scenario.tags)
    APIResponse =fn_HitAPI(APIName,PayLoad) 
    context.APIResponse = APIResponse

    assert APIResponse.status_code==200,f"API Response is other than 200 {APIResponse.status_code}"
        

@then("Verify Error Found = NO and Error description")
def step_impl(context):
    
    
    JsonData = context.APIResponse.json()
    
    ErrorFound,ErrorNumber,ErrorMessage = fn_CheckErrorFound(JsonData)
    print(f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}")
    assert ErrorFound.upper() == 'NO' ,f"ErrorFound {ErrorFound} \nErrorNumber {ErrorNumber} \nErrorMessage {ErrorMessage}"

@then('Post purchase on created account using "{APIName}" API using below data')
def step_impl(context,APIName):
    PayLoad=fn_CreateJsonPayloadUsingTable(context.table)
    PayLoad['AccountNumber']=f"{context.AccountNumber}"

    APIResponse = fn_HitAPI(APIName,PayLoad)
    context.APIResponse = APIResponse
    if APIResponse.ok:
        pass
    else:
        assert 1==2,f"API Response is other than 200 {APIResponse.status_code}"

    print(context.scenario.tags)
@then('Post Payment using "{APIName}" API using below data')
def step_impl(context,APIName):
    PayLoad=fn_CreateJsonPayloadUsingTable(context.table)
    PayLoad['AccountNumber']=f"{context.AccountNumber}"

    APIResponse = fn_HitAPI(APIName,PayLoad)
    context.APIResponse = APIResponse
    if APIResponse.ok:
        pass
    else:
        assert 1==2,f"API Response is other than 200 {APIResponse.status_code}"

    
