from Logger import get_logger
from ConnectDB import ConnectDB
from DirectoryValidation import DirectoryValidation
from ValidateDuplicateFile import ValidateDuplicateFile
from EmailStructure_Subject import EmailStructure_Subject
from EmailStructure_Head import EmailStructure_Head
from EmailStructure_Tail import EmailStrucute_Tail
from EmailStrucute_Footer import EmailStructure_Footer
from EmailStructure_Style import EmailStructure_Style
from EmailBody_Success import EmailBody_Success
from EmailBody_Error import EmailBody_Error
from SendMail import SendMail
from MoveFileToError import MoveFileToError
from MoveFileToOutput import MoveFileToOutput
from ImportFileToDB import ImportFileToDB
from DataValidation import DataValidation
import datetime
from pathlib import Path
import glob
import shutil
import os
from GetOperatingServer import GetOperatingServer
from GenerateExceptionFile import GenerateExceptionFile
from SetUp import SetUp as S1
from CheckEmptyFile import CheckEmptyFile

LogDateTime = datetime.datetime.now()

dir_path = str(os.getcwd()) + "\\"

ABORTPROCESSING = False
ErrorReason = ""

FileProcessingStartTime = datetime.datetime.now()

EmailSubject = ''
EmailHead = ''
EmailTail = ''
EmailStyle = ''
EmailFooter = ''
EmailBody = ''
EMAIL = ""
FileRecordDetails = ""
OperatingServer = ""
ExceptionFile = ""



InputDir, OutputDir, ErrorDir, LogDir, ABORTPROCESSING = DirectoryValidation()

if ABORTPROCESSING is False:
    LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

    MessageLogger = get_logger(LOG_FILE)

    MessageLogger.info("*************************** RETAIL ERROR FEED PROCESSING STARTS ***************************")
    MessageLogger.info("START TIME: " + str(FileProcessingStartTime))
    MessageLogger.info("PATH OF THE INPUT FILE DIRECTORY: " + InputDir)

    OperatingServer = GetOperatingServer(MessageLogger)

    EmailBody = EmailStructure_Head(FileProcessingStartTime, OperatingServer, MessageLogger)
    EmailSubject = EmailStructure_Subject()
    EmailTail = EmailStrucute_Tail()
    EmailStyle = EmailStructure_Style()
    EmailFooter = EmailStructure_Footer(LogDateTime)

    os.chdir(InputDir)
    FileCount = 0

    try:
        for File in glob.glob("*"):
            FileName = File
            MessageLogger.info("FILENAME: " + FileName)
            FileCount += 1
            FileNameId = str(LogDateTime.strftime("%Y%m%d%H%M%S")) + str(FileCount)
            MessageLogger.info("FileID: " + FileNameId)

            ABORTPROCESSING, ErrorReason =  ValidateDuplicateFile(OutputDir, FileName, MessageLogger)
            if ABORTPROCESSING:
                MoveFileToError(InputDir, ErrorDir, FileName)
                TotalRecords = 0
                SuccessfulRecordsCount = 0
                ErrorRecordCount = 0

            if ABORTPROCESSING is False:
                ABORTPROCESSING, ErrorReason = CheckEmptyFile(InputDir, FileName, MessageLogger)
                TotalRecords = 0
                SuccessfulRecordsCount = 0
                ErrorRecordCount = 0
                if ABORTPROCESSING:
                    MoveFileToOutput(InputDir, ErrorDir, FileName)

            if ABORTPROCESSING is False:
                ABORTPROCESSING, ErrorReason = ImportFileToDB(InputDir, FileName, dir_path, LogDir, MessageLogger)
                if ABORTPROCESSING:
                    MoveFileToError(InputDir, ErrorDir, FileName)

            if ABORTPROCESSING is False:
                ABORTPROCESSING, ErrorFlag, ErrorReason, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, FileDetailsEmailBody = DataValidation(FileNameId, FileName, MessageLogger)
                if ABORTPROCESSING:
                    MoveFileToError(InputDir, ErrorDir, FileName)
                else:
                    MoveFileToOutput(InputDir, OutputDir, FileName)
                    FileRecordDetails = FileRecordDetails + FileDetailsEmailBody
                    if S1.AccountNumberCheck == 1:
                        ExceptionFile = GenerateExceptionFile(FileNameId, FileName, MessageLogger)

            if ABORTPROCESSING is False:
                EmailBody = EmailBody + EmailBody_Success(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)
            else:
                EmailBody = EmailBody + EmailBody_Error(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)

        EmailBody = EmailBody + EmailStrucute_Tail()
        EmailBody = EmailBody + FileRecordDetails + ExceptionFile

        if FileCount == 0:
            EmailBody = "<h4 style=""color:green;>Operating Sever: " + OperatingServer + "</h4>"
            EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(FileProcessingStartTime.strftime('%m/%d/%Y %H:%M:%S')) + "</h4>"
            EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(S1.RetailFileProcessingPOD) + "</h4>"
            EmailBody = EmailBody + "<h3 style=""color:red;"">No file Present in Input folder</h3>"

        EMAIL = EmailStyle + "<html>" + EmailBody + "<br>" + "<br>" + "<br>" + EmailFooter + "</html>"

        MessageLogger.debug(EMAIL)

        SendMail(EmailSubject, EMAIL, MessageLogger)

        MessageLogger.info("Finish Time::: " + str(datetime.datetime.now()))

        if FileCount == 0:
            MessageLogger.info("*************************** NO FILE EXISTS, EXITING ***************************")
        else:
            MessageLogger.info("*************************** ALL FILES PROCESSED, EXITING ***************************")
    except Exception as e:
        MessageLogger.error("ERROR ENCOUNTERED IN PROCESSING THE FILE :: ", e)

else:
    print("ERROR ENCOUNTERED IN DIRECTORY VALIDATION")
