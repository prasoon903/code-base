from SetUp import SetUp
import pyodbc
import os
import sys
import subprocess
import datetime
from pathlib import Path
import smtplib
import glob
import shutil


S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
InputDir = S1.RetailInputFile
OutputDir = S1.RetailOutFile
ErrorDir = S1.RetailErrorFile
LogDir = S1.RetailLogFile
InsitutionID = S1.RetailInsitutionID
MailFrom = S1.MailFrom
MailTo = S1.MailTo
SMTP_SERVER = S1.SMTP_SERVER
SMTPPORT = S1.SMTPPORT

FileNameToReturn = []

dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"
LOG_FILE = ""
EMailSubject = ""
EmailBody = ""
Footer = ""
ABORT = False

LogDateTime = datetime.datetime.now()


def ConnectDB():
    con = pyodbc.connect(p_str=True,
                        driver="{ODBC Driver 13 for SQL Server}",
                        server=SERVERNAME,
                        Trusted_Connection='yes',
                        autocommit=True)
    cur = con.cursor()
    Message = "Connection established"

    return cur

###################################################################################################


def DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir, SQLDir):
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
    elif SQLDir == "":
        ErrorFlag = True
        Message = "Environment variable for SQL folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = InputDir + "\\"
        OutputDir = OutputDir + "\\"
        ErrorDir = ErrorDir + "\\"
        LogDir = LogDir + "\\"
        SQLDir = SQLDir + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, SQLDir, ErrorFlag    

###################################################################################################


def ValidateDuplicateFile(OutputDir, FileName):
    from pathlib import Path

    FilePath = Path(OutputDir + FileName)
    ErrorReason = "No Error"
    Error = False

    if FilePath.is_file():
        Error = True
        Message = "File " + FileName + " is already present in OUTPUT folder. So it can not be processed."
        ErrorReason = "Duplicate File"


    return Error, ErrorReason

###################################################################################################


def ImportFileToDB(InputDir, FileName):
    Error = True
    File = InputDir + FileName
    ErrorMessage = ''

    # Connection = ConnectDB()

    BCP = "bcp " + CI_DB + "..ScenarioExecution IN " + File + " -b 5000 -h TABLOCK " \
            "-f " + dir_path + "ScenarioExecution.xml -e " + str(LogDir) + "Error1_in.log -o "  \
            + str(LogDir) + "Output1_in.log -S " + SERVERNAME + " -T -t , -F 2"

    try:
        subprocess.run(BCP)
        Error = False
        ErrorMessage = 'No Error'
        # Connection.commit()
    except:
        Error = True
        ErrorMessage = 'Error in dumping the file'

    Message = "Record Insert Time:::" + str(datetime.datetime.now())


    # Connection.close

    return Error, ErrorMessage

###################################################################################################

def CreateTable(SQLDir):
    Path = SQLDir
    Error = False

    os.chdir(Path)

    for File in glob.glob("*.sql"):

        FileName = Path + File
        Error = True
        CMD = "sqlcmd -S " + SERVERNAME + " -d " + CI_DB + " -E -i " + FileName

        print(CMD)

        # Connection = ConnectDB()

        try:
            subprocess.run(CMD)
            Error = False
        except:
            print("Unable to execute the SQL file")
            Error = True

    return Error


###################################################################################################


def FileInsert():
    Error = True

    InputDir, OutputDir, ErrorDir, LogDir, SQLDir, Error = DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir, SQLDir)

    if Error is False:
        Error = CreateTable(SQLDir)

    if Error is False:

        Path = InputDir
        os.chdir(Path)

        LoopCount = 0

        for File in glob.glob("*"):
            FileName = File
            Message = "********************" + FileName + "*****************************"
            LoopCount = LoopCount + 1

            FileNameId = str(LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
            ABORT = False

            if ABORT is False:
                ABORT, ErrorReason = ValidateDuplicateFile(OutputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)

            if ABORT is False:
                ABORT, ErrorMessage = ImportFileToDB(InputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

                    FileNameToReturn.append(FileName)

    return FileNameToReturn