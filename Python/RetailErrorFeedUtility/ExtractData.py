import pandas as pd
from SetUp import SetUp
import pyodbc
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
import csv

S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
InputDir = S1.InputFile
OutputDir = S1.OutFile
ErrorDir = S1.ErrorFile
LogDir = S1.LogFile
InsitutionID = S1.InsitutionID
MailFrom = S1.MailFrom
MailTo = S1.MailTo
SMTP_SERVER = S1.SMTP_SERVER
SMTPPORT = S1.SMTPPORT

dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"
LOG_FILE = ""
EMailSubject = ""
EmailBody = ""
Footer = ""
ABORT = False
# MessageLogger = logging()

IntermediateFileName = ''
ErrorMessage = ''

FORMATTER = logging.Formatter("%(asctime)s — %(levelname)s — %(message)s")

LogDateTime = datetime.datetime.now()


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
   logger.setLevel(logging.DEBUG)
   logger.addHandler(get_console_handler())
   logger.addHandler(get_file_handler())
   logger.propagate = False

   return logger


###################################################################################################


def ConnectDB():
    con = pyodbc.connect(p_str=True,
                        driver="{ODBC Driver 13 for SQL Server}",
                        server=SERVERNAME,
                        Trusted_Connection='yes',
                        autocommit=True)
    cur = con.cursor()
    Message = "Connection established"
    MessageLogger.info(Message)

    return cur

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

def GenerateIntermediateFile(InputDir, FileName):
    MessageLogger.debug("Inside ImportFileToDB")
    Error = True
    File = InputDir + FileName
    ErrorMessage = ''
    IntermediateFileName = 'Intermediate_' + FileName
    IntermediateFile = InputDir + IntermediateFileName
    try:
        dataset = pd.read_csv(File)
        df = pd.DataFrame(dataset)
        cols = [4,5]
        df = df[df.columns[cols]]

        df.to_csv(IntermediateFile, encoding='utf-8', index=False)
        Error = False
    except:
        Error = True

    return Error

###################################################################################################

def GenerateResponseFile(InputDir, InputFile, FileName):
    MessageLogger.debug("Inside ImportFileToDB")
    Error = True
    File = InputDir + FileName
    ErrorMessage = ''
    OutputFile = OutputDir + 'Output_' + InputFile

    with open(OutputFile, 'a') as FileForOutput:
    with open(File, 'r') as FileToRead:
        for r in FileToRead:
            Row = r
            Row = '( + +)'

###################################################################################################


if __name__ == '__main__':
    '''
    LOG_FILE = ""
    EMailSubject = ""
    EmailBody = ""
    Footer = ""
    ABORT = False
    '''
    Error = True

    InputDir, OutputDir, ErrorDir, LogDir, Error = DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir)

    if Error is False:
        
        LOG_FILE = LogDir + "Log_" + str(LogDateTime.strftime("%Y%m%d%M%S")) + ".log"

        MessageLogger = get_logger(LOG_FILE)

        Message = "File Processing starts ..."
        MessageLogger.info(Message)
        Message = "Start Time::: " + str(LogDateTime)
        MessageLogger.info(Message)

        Path = InputDir
        MessageLogger.info(Path)
        os.chdir(Path)

        LoopCount = 0

        for File in glob.glob("*"):
            FileName = File
            Message = "********************" + FileName + "*****************************"
            MessageLogger.info(Message)
            LoopCount = LoopCount + 1

            FileNameId = str(LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
            MessageLogger.info("FileID: " + FileNameId)
            ABORT = False

            if ABORT is False:
                ABORT = GenerateIntermediateFile(InputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

            if ABORT is False:
                ABORT = GenerateResponseFileFile(InputDir, FileName, IntermediateFileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

        if LoopCount == 0:
            Message = "Finish Time::: " + str(datetime.datetime.now())
            MessageLogger.info(Message)
            Message = "********************" + "No file Exists... Exiting" + "*****************************"
            MessageLogger.info(Message)
        else:
            Message = "Finish Time::: " + str(datetime.datetime.now())
            MessageLogger.info(Message)
            Message = "********************" + "All files processed... Exiting" + "*****************************"
            MessageLogger.info(Message)