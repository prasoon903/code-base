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

FORMATTER = logging.Formatter("%(asctime)s — %(levelname)s — %(message)s")

LogDateTime = datetime.datetime.now()

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

    with open(File) as f:
        for line in f:
            line.strip().split('/n')
            if term1 in line:
                Message = Message + term1 + line.split(term1,1)[1]
            elif term2 in line:
                Message = Message + term2 + line.split(term2,1)[1]

    if Message != "":
        Message = Message + "\n"
        WritingTheFile(FileName, Message)



###################################################################################################


def WritingTheFile(FileName, Message):
    File = InputDir + FileName

    f = open(OutputFile, 'a')

    OutputMessage = FileName + ": " + "\n" + Message

    f.write(OutputMessage)

    f.close()



###################################################################################################




if __name__ == '__main__':

    Error = True


    InputDir, OutputDir, ErrorDir, LogDir, Error = DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir)

    if Error is False:
        
        LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

        OutputFile = OutputDir + "Response_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".txt"

        MessageLogger = get_logger(LOG_FILE)

        Message = "File Processing starts ..."
        MessageLogger.info(Message)
        Message = "START TIME::: " + str(LogDateTime)
        MessageLogger.info(Message)

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