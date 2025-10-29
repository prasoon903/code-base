from Scripts.DataBaseConnections import *
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger
import pyodbc

# RootPath = os.environ.get('RootPath')
# RootPath = f'E:\\Python\\BehaveBDD\\features'
# MessageLogger.info(RootPath)

# Configuration = json.load(open(RootPath+"\Configuration/Configuration.json"))
Configuration = c.Configuration
RootPath = c.BasePath
# MessageLogger.info(Configuration)
"""DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'],
                        Server = Configuration['DBServer'],
                        Database = Configuration['YourDBNames']['COREISSUE'],
                        Trusted_Connection ='yes',
                        autocommit = True
                        )
"""
cursor = DBCon.cursor()


def fn_GetAccountData(AccountNumber):
    # columnList = ["AccountNumber", "CurrentBalance", "AmountOfTotalDue", "DateAcctOpened", "LastStatementDate",
    #               "SystemStatus", "CCINHPARENT125AID"]

    AccountFile = json.load((open(RootPath+"\JsonPayload/AccountDetailsToFetch.json")))
    # MessageLogger.info(AccountFile)
    columnList = AccountFile["columnList"]
    # MessageLogger.info(columnList)

    selectQuery = f"'AccountLevel' Source, TRY_CONVERT(VARCHAR(100), BP.acctID, 20) acctID"
    selectionCriteria = (f'''
                            FROM BSegment_Primary BP WITH (NOLOCK)
                            JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctID = BS.acctID)
                            JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BS.acctID = BCC.acctID)
                            JOIN BSegment_Balances BB WITH (NOLOCK) ON (BCC.acctID = BB.acctID)
                        ''')

    for column in columnList:
        selectQuery = selectQuery + f', RTRIM(TRY_CONVERT(VARCHAR(100), {column}, 20)) {column}'

    selectQuery = selectQuery + ", NULL 'Plan'"
    selectQuery = selectQuery + ", NULL 'LPS'"

    sql = f"SELECT {selectQuery} {selectionCriteria} WHERE AccountNumber = '{AccountNumber}'"
    # MessageLogger.info(sql)

    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except pyodbc.Error as SQLError:
        SQLState = SQLError.args[0]
        Error = SQLError.args[1]
        MessageLogger.error(f"we are here in error while fetching account details:  SQLState: {SQLState}, Error: {Error}")
        result_json = {}
    except Exception as e:
        MessageLogger.error("we are here in error while fetching account details", str(e))
        result_json = {}

    # MessageLogger.info(result_json)
    return result_json


def fn_GetPlanData(AccountID):
    # columnList = ["CreditPlanType", "CurrentBalance", "AmountOfTotalDue"]

    PlanFile = json.load((open(RootPath + "\JsonPayload/PlanDetailsToFetch.json")))
    columnList = PlanFile["columnList"]
    # MessageLogger.info(columnList)

    selectQuery = f"'PlanLevel' Source, TRY_CONVERT(VARCHAR(100), CP.acctID, 20) acctID, TRY_CONVERT(VARCHAR(100), ROW_NUMBER() OVER(ORDER BY CP.plansegcreatedate, CP.acctId), 20) PlanCount"
    selectionCriteria = (f'''
                                FROM CPSgmentAccounts CP WITH (NOLOCK)
                                JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (CP.acctID = CC.acctID)
                            ''')

    for column in columnList:
        selectQuery = selectQuery + (f', RTRIM(TRY_CONVERT(VARCHAR(100), {column}, 20)) {column}')

    sql = f"SELECT {selectQuery} {selectionCriteria} WHERE parent02AID = '{AccountID}'"
    # MessageLogger.info(sql)

    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except pyodbc.Error as SQLError:
        SQLState = SQLError.args[0]
        Error = SQLError.args[1]
        MessageLogger.error(
            f"we are here in error while fetching plan details:  SQLState: {SQLState}, Error: {Error}")
        result_json = {}
    except Exception as e:
        MessageLogger.error("we are here in error while fetching plan details ", e)
        result_json = {}

    # MessageLogger.info(result_json)
    return result_json

#Pmaurya : Start Code From here
def fn_GetLPSData(AccountID):
    # columnList = ["CreditPlanType", "CurrentBalance", "AmountOfTotalDue"]

    PlanFile = json.load((open(RootPath + "\\JsonPayload/LpsDetailsToFetch.json")))
    columnList = PlanFile["columnList"]
    # MessageLogger.info(columnList)

    selectQuery = f"'LPSLevel' Source, TRY_CONVERT(VARCHAR(100), acctID, 20) acctID"
    selectionCriteria = (f'''
                             FROM LPSegmentAccounts WITH (NOLOCK)
                        ''')

    for column in columnList:
        selectQuery = selectQuery + (f', RTRIM(TRY_CONVERT(VARCHAR(100), {column}, 20)) {column}')

    sql = f"SELECT {selectQuery} {selectionCriteria} WHERE parent02AID = '{AccountID}'"
    # MessageLogger.info(sql)

    try:
        cursor.execute(sql)
        results = []
        # MessageLogger.info("we are here")
        for row in cursor.fetchall():
            result_dict = {}
            for idx, column in enumerate(cursor.description):
                # MessageLogger.info("we are here inside loop")
                result_dict[column[0]] = row[idx]
            results.append(result_dict)

        # Convert the results to JSON
        result_json = results
    except pyodbc.Error as SQLError:
        SQLState = SQLError.args[0]
        Error = SQLError.args[1]
        MessageLogger.error(
            f"we are here in error while fetching Lps details:  SQLState: {SQLState}, Error: {Error}")
        result_json = {}
    except Exception as e:
        MessageLogger.error("we are here in error while fetching Lps details ", e)
        result_json = {}

    # MessageLogger.info(result_json)
    return result_json



def fn_GetAllDetails(AccountNumber):
    AccountData = []
    try:
        AccountData = fn_GetAccountData(AccountNumber)
        PlanData = fn_GetPlanData(AccountData[0]['acctID'])
        LPSData = fn_GetLPSData(AccountData[0]['acctID'])

        # MessageLogger.info(AccountData)
        # MessageLogger.info(PlanData)

        PlanRecords = {}
        for index, value in enumerate(PlanData):
            # PlanRecords[f"Plan_{index+1}"] = value
            PlanRecords[f"Plan_{value['PlanCount']}"] = value

        AccountData[0]['Plan'] = PlanRecords
        AccountData[0]['LPS'] = LPSData
    except Exception as e:
        MessageLogger.error(f"Error while saving getting all details {e}")

    return AccountData


def fn_SaveAccountPlanData(folder_name, file_name, AccountNumber):
    MessageLogger.info(f"Saving account plan details for {AccountNumber}")
    try:
        response = fn_GetAllDetails(AccountNumber)
        file_path = os.path.join(RootPath, "JsonResponse")
        file_path = os.path.join(file_path, folder_name)
        if not os.path.exists(file_path):
            os.makedirs(file_path)
        file_name = (
            f"Account_Plan_Details_{file_name}.json"
        )
        file_path = file_path + "\\" + file_name
        # JsonData = context.response.json()
        # context.jsonData = context.response.json()
        with open(file_path, "w") as json_file:
            json.dump(response, json_file, indent=2)

    except Exception as e:
        MessageLogger.error(f"Error while saving account plan data in JSON file {e}")


# fn_GetAllDetails('1150001100411390')
