from MoveFileToError import MoveFileToError
from MoveFileToOutput import MoveFileToOutput
from DirectoryValidation import DirectoryValidation
from ValidateDuplicateFile import ValidateDuplicateFile
from Logger import get_logger
import datetime
from pathlib import Path
import glob
import shutil
import os
from ImportData import ImportJsonFile
from BulkImportData import GenerateCSV
from SetUp import SetUp as S1
#from ImportData_Thread import GenerateCSV


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

    MessageLogger.info("*************************** JSON READER PROCESSING STARTS ***************************")
    MessageLogger.info("START TIME: " + str(FileProcessingStartTime))
    MessageLogger.info("PATH OF THE INPUT FILE DIRECTORY: " + InputDir)

   

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
                if S1.BulkInsert == 0:
                    ABORTPROCESSING = ImportJsonFile(InputDir, FileName, MessageLogger)
                else:
                    ABORTPROCESSING = GenerateCSV(InputDir, FileName, dir_path, LogDir, MessageLogger)
                if ABORTPROCESSING:
                    MoveFileToError(InputDir, ErrorDir, FileName)
                else:
                    MoveFileToOutput(InputDir, OutputDir, FileName)

        MessageLogger.info("FINISH TIME: " + str(datetime.datetime.now()))
        
        if FileCount == 0:
            MessageLogger.info("*************************** NO FILE EXISTS, EXITING ***************************")
        else:
            MessageLogger.info("*************************** ALL FILES PROCESSED, EXITING ***************************")

    except Exception as e:
        MessageLogger.error("ERROR ENCOUNTERED IN PROCESSING THE FILE :: ", e)

else:
    print("ERROR ENCOUNTERED IN DIRECTORY VALIDATION")