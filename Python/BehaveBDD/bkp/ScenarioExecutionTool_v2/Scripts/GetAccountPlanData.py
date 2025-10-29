from Scripts.DataBaseConnections import *
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger

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
    except Exception as e:
        MessageLogger.error("we are here in error" , str(e))
        result_json = {}

    # MessageLogger.info(result_json)
    return result_json


def fn_GetPlanData(AccountID):
    # columnList = ["CreditPlanType", "CurrentBalance", "AmountOfTotalDue"]

    PlanFile = json.load((open(RootPath + "\JsonPayload/PlanDetailsToFetch.json")))
    columnList = PlanFile["columnList"]
    # MessageLogger.info(columnList)

    selectQuery = f"'PlanLevel' Source, TRY_CONVERT(VARCHAR(100), CP.acctID, 20) acctID"
    selectionCriteria = (f'''
                                FROM CPSgmentAccounts CP WITH (NOLOCK)
                                JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (CP.acctID = CC.acctID)
                            ''')

    for column in columnList:
        selectQuery = selectQuery + f', RTRIM(TRY_CONVERT(VARCHAR(100), {column}, 20)) {column}'

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
    except Exception as e:
        MessageLogger.error("we are here in error", e)
        result_json = {}

    # MessageLogger.info(result_json)
    return result_json


def fn_GetAllDetails(AccountNumber):
    AccountData = fn_GetAccountData(AccountNumber)
    PlanData = fn_GetPlanData(AccountData[0]['acctID'])

    PlanRecords = {}
    for index, value in enumerate(PlanData):
        PlanRecords[f"Plan_{index+1}"] = value

    AccountData[0]['Plan'] = PlanRecords

    # MessageLogger.info(AccountData)
    # MessageLogger.info(PlanData)

    return AccountData

# fn_GetAllDetails('1150001100411390')
