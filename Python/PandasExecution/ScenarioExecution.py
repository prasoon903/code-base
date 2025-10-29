import pandas as pd
import xlrd
import datetime
from Logger import get_logger
from FileProcessing import DirectoryValidation
from AccountCreation import AccountCreation
from VirtualCard import VirtualCard
from AccountUpdate import AccountUpdate
from AddManualStatus import AddManualStatus
from CheckSystemAging import CheckSystemAging
from ReAgeEnrollment import ReAgeEnrollment
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
import os
from glob import glob

ABORTPROCESSING = True

InputDir, OutputDir, ErrorDir, LogDir, SQLDir, ABORTPROCESSING = DirectoryValidation(S1.InputFile, S1.OutFile, S1.ErrorFile, S1.LogFile, S1.SQLFile)

if ABORTPROCESSING == False:

    LogDateTime = datetime.datetime.now()

    LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

    MessageLogger = get_logger(LOG_FILE)

    MessageLogger.info("********************* PROCESSING STARTS ************************")

    Path = InputDir
    os.chdir(Path)

    LoopCount = 0

    for File in glob.glob("*"):
        FileName = File
        MessageLogger.info("********************" + FileName + "*****************************")
        LoopCount = LoopCount + 1

        ACTIVITY = ""
        LOGICMODULE = ""
        BILLINGCYCLE = ""
        TRANSACTIONAMOUNT = ""
        RETAIL = ""
        TRANID = ""

        xls = pd.ExcelFile(InputDir + FileName)

        ScenarioSheet = xls.parse("Sheet1")
        ScenarioSheet_DataFrame = pd.DataFrame(ScenarioSheet)

        EXECUTIONSTEP = 0
        TOTALSTEPSTOEXECUTE = ScenarioSheet_DataFrame.shape[0]

        AccountNumber = ""

        for Steps in range(TOTALSTEPSTOEXECUTE):
            EXECUTIONSTEP = Steps + 1

            ACTIVITY            = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'ACTIVITY'].upper()
            LOGICMODULE         = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'LOGICMODULE'].upper()
            BILLINGCYCLE        = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'BILLINGCYCLE'].upper()
            TRANSACTIONAMOUNT   = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'TRANSACTIONAMOUNT'].upper()
            RETAIL              = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'RETAIL'].upper()
            TRANID              = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'TRANID'].upper()
            ACCOUNTNUMBER       = ScenarioSheet_DataFrame.loc[ScenarioSheet_DataFrame['STEP'] == EXECUTIONSTEP, 'ACCOUNTNUMBER'].upper()

            if ACTIVITY == "ACCOUNTCREATION":
                AccountCreate = AccountCreation(7131, 'CookieStore', BILLINGCYCLE)
                AccountNumber = AccountCreate["AccountNumber"]
                MessageLogger.info("Account generated :: " + str(AccountNumber) + " :: Message :: " + AccountCreate["ErrorMessage"])

                VirtualCardCreate = VirtualCard(AccountNumber)
                MessageLogger.info("Virtual card generation :: Message :: " + VirtualCardCreate["ErrorMessage"])






else:
    print("ERROR ENCOUNTERED IN DIRECTORY VALIDATION")



