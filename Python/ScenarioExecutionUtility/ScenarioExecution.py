import datetime
import logging
from Logger import get_logger
from FileProcessing import FileInsert, DirectoryValidation
from AccountCreation import AccountCreation
from AccountUpdate import AccountUpdate
from AddManualStatus import AddManualStatus
from CheckSystemAging import CheckSystemAging
from CheckTNPJobs import CheckTNPJobs
from Clearing import Clearing
from ConnectDB import ConnectDB
from CreateAccountandVirtualCard import CreateAccountAndVirtualCard
from DisputeResolution import DisputeResolution
from InitiateDispute import InitiateDispute
from RemoveManualStatus import RemoveManualStatus
from SetTView import SetTViewByPostTime
from SetUp import SetUp as S1
from FetchJobFromTable import FetchJobFromTable
from GetStoreFromProduct import GetStoreFromProduct

FORMATTER = logging.Formatter("%(asctime)s — %(levelname)s — %(message)s")

LogDateTime = datetime.datetime.now()

LOG_FILE = S1.LogDir + "\\" + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

MessageLogger = get_logger(LOG_FILE)

# Process the file


###################################################################################################

FileName = FileInsert()

for File in FileName:
    CMTTRANTYPE, TransactionAmount, Trantime, PostTime, CreditPlanMaster, RMATranUUID, RevTgt, CaseID, TxnSource, TxnCode_Internal, TransactionAPI, InstitutionID, ActualTranCode, LogicModule = FetchJobFromTable()

    Error, PostTimeFromTview = SetTViewByPostTime(PostTime)

    if Error:
        print('Error occured while setting the TView')
        break

    CheckSystemAging(PostTimeFromTview)

    ProductID = '7131'
    Error, Store = GetStoreFromProduct(ProductID)

    if Error:
        print('Error occured while fetching the store')
        break

    try:
        Account = CreateAccountAndVirtualCard(ProductID, Store)

        AccountNumber = str(Account['AccountNumber'])

        Script = "EXEC " + S1.CI_DB + "..USP_GenerateTransactionsForScenarioExecution '" + AccountNumber + "', '" + File + "'"

        TotalRecords = 0

        Connection = ConnectDB()

        try:
            Result = Connection.execute(Script)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            print("Error occured while executing USP_GenerateTransactionsForScenarioExecution")
            RowCount = 0
            break

        if RowCount > 0:
            for r in Row:
               TotalRecords = r.TotalRecords 

        Connection.close()

        if TotalRecords > 0:
            for Record in TotalRecords:
                CMTTRANTYPE, TransactionAmount, Trantime, PostTime, CreditPlanMaster, RMATranUUID, RevTgt, CaseID, TxnSource, TxnCode_Internal, TransactionAPI, InstitutionID, ActualTranCode, LogicModule = FetchJobFromTable(AccountNumber)

                if TransactionAPI == "CLEARING":
                    print("Code to do")                  

    except:
        print('An error occured')



