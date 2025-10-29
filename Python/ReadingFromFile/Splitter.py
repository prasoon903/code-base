from SetUp import SetUp
import logging
import os
import sys
import subprocess
import datetime
from pathlib import Path
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.message import EmailMessage
import glob
import shutil

S1 = SetUp()

InputDir = S1.DBCRInputFile
OutputDir = S1.DBCROutFile
ErrorDir = S1.DBCRErrorFile
LogDir = S1.DBCRLogFile

dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"
LOG_FILE = ""
EMailSubject = ""
EmailBody = ""
Footer = ""
ABORT = False
ProcessTheFile = False
ErrorReason = ""
FileHeader = "Report_Date,business_date,batch_timestamp,account_uuid,plan_uuid,schedule_id,institution_id,Product_ID,error,error_message,field_path\n"

FORMATTER = logging.Formatter("%(asctime)s — %(levelname)s — %(message)s")

LogDateTime = datetime.datetime.now()

OutFileName = 'correction_feed_request_' + str(LogDateTime.strftime('%Y%m%d'))

ProcessingTime  = str(LogDateTime.strftime("%Y-%m-%d %H:%M:%S"))

term1 = "Start Time"
term2 = "Finish Time"


def get_console_handler():
   console_handler = logging.StreamHandler(sys.stdout)
   console_handler.setFormatter(FORMATTER)
   return console_handler

###################################################################################################


def get_file_handler():
   file_handler = logging.FileHandler(LOG_FILE)
   file_handler.setFormatter(FORMATTER)
   return file_handler

###################################################################################################


def get_logger(logger_name):
   logger = logging.getLogger(logger_name)
   logger.setLevel(logging.INFO)
   logger.addHandler(get_console_handler())
   logger.addHandler(get_file_handler())
   logger.propagate = False

   return logger


###################################################################################################


def DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir):
    ErrorFlag = True
    ErrorNumber = 0
    if InputDir == "":
        ErrorFlag = True
        Message = "Environment variable for Input folder is not set"
    elif OutputDir == "":
        ErrorFlag = True
        Message = "Environment variable for Output folder is not set"
    elif ErrorDir == "":
        ErrorFlag = True
        Message = "Environment variable for Error folder is not set"
    elif LogDir == "":
        ErrorFlag = True
        Message = "Environment variable for Log folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = InputDir + "\\"
        OutputDir = OutputDir + "\\"
        ErrorDir = ErrorDir + "\\"
        LogDir = LogDir + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, ErrorFlag    

###################################################################################################


def ReadingTheFile(FileName):
    File = InputDir + FileName
    Message = ""
    Count = 0

    with open(File) as f:
        for line in f:
            line.strip().split('/n')
            LineToPrint = line.strip()
            Count += 1

            if LineToPrint != "":
                Message = LineToPrint
                WritingTheFile(Message)



###################################################################################################


def WritingTheFile(Message):

    f = open(OutputFile, 'a')

    OutputMessage = str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S')) + "," + str(LogDateTime.strftime('%Y-%m-%d')) + "," + str(LogDateTime.strftime('%H:%M:%S')) + "," + Message + ",1,6981,7133," + OutFileName + ",NA,NA\n" #production
    # OutputMessage = "INSERT INTO #TempErrorPlans VALUES ('" + Message + "')\n"
    # OutputMessage = "'" + Message + "'\n"	
    # OutputMessage = str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S')) + "," + str(LogDateTime.strftime('%Y-%m-%d')) + "," + str(LogDateTime.strftime('%H:%M:%S')) + "," + Message + ",1,6969,7131,ManualPlanIDCorrection\n" #local

    f.write(OutputMessage)

    f.close()



###################################################################################################




if __name__ == '__main__':

    Error = True


    InputDir, OutputDir, ErrorDir, LogDir, Error = DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir)

    if Error is False:
        
        LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

        OutputFile = OutputDir + OutFileName + ".csv"

        f = open(OutputFile, 'a')
        f.write(FileHeader)
        f.close()

        MessageLogger = get_logger(LOG_FILE)

        Message = "File Processing starts ..."
        MessageLogger.info(Message)
        Message = "START TIME::: " + str(LogDateTime)
        MessageLogger.info(Message)

        try:
            Path = InputDir
            MessageLogger.info(Path)
            os.chdir(Path)

            LoopCount = 0
            JobID = 0

            for File in glob.glob("*"):
                FileName = File
                Message = "********************" + FileName + "*****************************"
                MessageLogger.info(Message)
                LoopCount = LoopCount + 1

                ReadingTheFile(FileName)
        except Exception:
            MessageLogger.error("ERROR IN BLOCK", exc_info=True)


        MessageLogger.info("*********************** FINISHED ***********************")
