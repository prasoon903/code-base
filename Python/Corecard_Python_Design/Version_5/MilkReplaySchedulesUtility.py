import shutil
import datetime
from pathlib import Path
import glob
import pyodbc
import pandas as pd
import os
import boto3
import base64
from botocore.exceptions import ClientError
import logging
import sys
import subprocess
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
import json
import configparser

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


################################################################################################

Config = configparser.ConfigParser()
Config.read("SetupCIPy.ini")

POD = Config['DEFAULT']['POD']
CI_DB = Config['DEFAULT']['DBName_CI']
CL_DB = Config['DEFAULT']['DBName_CL']
CAuth_DB = Config['DEFAULT']['DBName_CAuth']
SERVERNAME = Config['DEFAULT']['DB_Server_NAME']
MailFrom = Config['DEFAULT']['alert_email_sender']
SMTP_SERVER = Config['DEFAULT']['SMTP_SERVER']
SMTPPORT = int(Config['DEFAULT']['SMTP_PORT'])
RetailAWS_secret_name = Config['DEFAULT']['ses_smtp_secret_name']
RetailAWS_region_name = Config['DEFAULT']['ses_region_name']
RetailSES_smtp_url = Config['DEFAULT']['ses_smtp_url']
RetailAWSPort = Config['DEFAULT']['ses_smtp_port']


MailTo = Config['MilkReplaySchedulesUtility']['alert_email_receiver']
RetailAWSEnvironment = int(Config['MilkReplaySchedulesUtility']['RetailAWSEnvironment'])
RetailAWS_service_name = Config['MilkReplaySchedulesUtility']['RetailAWS_service_name']
RetailInputFile = Config['MilkReplaySchedulesUtility']['RetailInputFile']
RetailErrorFile = Config['MilkReplaySchedulesUtility']['RetailErrorFile']
RetailOutFile = Config['MilkReplaySchedulesUtility']['RetailOutFile']
RetailLogFile = Config['MilkReplaySchedulesUtility']['RetailLogFile']
RetailInstitutionID = int(Config['MilkReplaySchedulesUtility']['RetailInstitutionID'])
RetailEnvironment = Config['MilkReplaySchedulesUtility']['RetailEnvironment']
RetailExceptionFile = Config['MilkReplaySchedulesUtility']['RetailExceptionFile']
RetailExceptionFilePrefix = Config['MilkReplaySchedulesUtility']['RetailExceptionFilePrefix']
RetailExceptionFileSuffix = Config['MilkReplaySchedulesUtility']['RetailExceptionFileSuffix']
BatchCount = int(Config['MilkReplaySchedulesUtility']['BatchCount'])
AccountNumberCheck = int(Config['MilkReplaySchedulesUtility']['AccountNumberCheck'])


RetailFileProcessingPOD = "POD" + str(POD)




################################################################################################


def printVaribales(MessageLogger):
    MessageLogger.info("PRINTING ENVIRONMENT VARIABLES")
    MessageLogger.info("CI_DB: " + str(CI_DB))
    MessageLogger.info("CL_DB: " + str(CL_DB))
    MessageLogger.info("CAuth_DB: " + str(CAuth_DB))
    MessageLogger.info("SERVERNAME: " + str(SERVERNAME))
    MessageLogger.info("MailFrom: " + str(MailFrom))
    MessageLogger.info("MailTo: " + str(MailTo))
    MessageLogger.info("SMTP_SERVER: " + str(SMTP_SERVER))
    MessageLogger.info("SMTPPORT: " + str(SMTPPORT))
    MessageLogger.info("RetailAWSEnvironment: " + str(RetailAWSEnvironment))
    MessageLogger.info("RetailAWS_secret_name: " + str(RetailAWS_secret_name))
    MessageLogger.info("RetailAWS_region_name: " + str(RetailAWS_region_name))
    MessageLogger.info("RetailAWS_service_name: " + str(RetailAWS_service_name))
    MessageLogger.info("RetailSES_smtp_url: " + str(RetailSES_smtp_url))
    MessageLogger.info("RetailAWSPort: " + str(RetailAWSPort))
    MessageLogger.info("RetailInputFile: " + str(RetailInputFile))
    MessageLogger.info("RetailErrorFile: " + str(RetailErrorFile))
    MessageLogger.info("RetailOutFile: " + str(RetailOutFile))
    MessageLogger.info("RetailLogFile: " + str(RetailLogFile))
    MessageLogger.info("RetailInstitutionID: " + str(RetailInstitutionID))
    MessageLogger.info("RetailEnvironment: " + str(RetailEnvironment))
    MessageLogger.info("RetailExceptionFile: " + str(RetailExceptionFile))
    MessageLogger.info("RetailExceptionFilePrefix: " + str(RetailExceptionFilePrefix))
    MessageLogger.info("RetailExceptionFileSuffix: " + str(RetailExceptionFileSuffix))
    MessageLogger.info("RetailFileProcessingPOD: " + str(RetailFileProcessingPOD))
    MessageLogger.info("BatchCount: " + str(BatchCount))
    MessageLogger.info("AccountNumberCheck: " + str(AccountNumberCheck))


################################################################################################
################################################################################################
################################################################################################
################################################################################################


FORMATTER = logging.Formatter("%(asctime)s — %(thread)s — %(levelname)s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')

def get_console_handler():
   console_handler = logging.StreamHandler(sys.stdout)
   console_handler.setFormatter(FORMATTER)
   return console_handler

###################################################################################################


def get_file_handler(LOG_FILE):
   file_handler = logging.FileHandler(LOG_FILE)
   file_handler.setFormatter(FORMATTER)
   return file_handler

###################################################################################################


def get_logger(logger_name):
   logger = logging.getLogger(logger_name)
   logger.setLevel(logging.DEBUG)
   logger.addHandler(get_console_handler())
   logger.addHandler(get_file_handler(logger_name))
   logger.propagate = False

   return logger


###################################################################################################

def CheckEmptyFile(InputDir, FileName, MessageLogger):
    MessageLogger.info("INSIDE CheckEmptyFile BLOCK")

    EmptyFile = False
    ErrorReason = ""

    try:
        InputFile = InputDir + FileName

        FileDF = pd.read_csv(InputFile)

        RecordCount = len(FileDF)

        MessageLogger.info("Total records in the file " + FileName + " is: " + str(RecordCount))

        if RecordCount > 0:
            EmptyFile = False
            MessageLogger.info("Non-Empty file, going to process")
        else:
            EmptyFile = True
            ErrorReason = "EMPTY FILE"
            MessageLogger.info("Empty file, aborting file processing")

    except Exception as e:
        MessageLogger.error("ERROR IN CheckEmptyFile BLOCK", e)

    return EmptyFile, ErrorReason


################################################################################################


def ConnectDB(MessageLogger):
    ConnectionStatus = False
    cur = ""
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 17 for SQL Server}",
                            server=SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True,
                            app="MilkReplayUtility")
        cur = con.cursor()
        MessageLogger.info("CONNECTION ESTABLISHED")
        ConnectionStatus = True
    except Exception as e:
        MessageLogger.error("ERROR IN CONNECTING TO THE DATABASE " + str(e))

    MessageLogger.info("ConnectionStatus: " + str(ConnectionStatus))

    return cur, ConnectionStatus

def ConnectDB_ConnectionObject(MessageLogger):
    ConnectionStatus = False
    con = ""
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 17 for SQL Server}",
                            server=SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True,
                            app="MilkReplayUtility")
        
        MessageLogger.info("CONNECTION ESTABLISHED")
        ConnectionStatus = True
    except Exception as e:
        MessageLogger.error("ERROR IN CONNECTING TO THE DATABASE " + str(e))

    MessageLogger.info("ConnectionStatus: " + str(ConnectionStatus))

    return con, ConnectionStatus


################################################################################################


def DirectoryValidation():
    ErrorFlag = True
    InputDir = ''
    OutputDir = ''
    ErrorDir = ''
    LogDir = ''


    if RetailInputFile == "":
        ErrorFlag = True
        Message = "Environment variable for Input folder is not set"
    elif RetailOutFile == "":
        ErrorFlag = True
        Message = "Environment variable for Output folder is not set"
    elif RetailErrorFile == "":
        ErrorFlag = True
        Message = "Environment variable for Error folder is not set"
    elif RetailLogFile == "":
        ErrorFlag = True
        Message = "Environment variable for Log folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = RetailInputFile + "\\"
        OutputDir = RetailOutFile + "\\"
        ErrorDir = RetailErrorFile + "\\"
        LogDir = RetailLogFile + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, ErrorFlag 


################################################################################################


def FileDetails(FileName, Row, MessageLogger):
    MessageLogger.info("INSIDE FileDetails BLOCK")
    FileDetailsEmailBody = ''
    try:
        FileDetailsEmailBody = "<p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"
        Count = 0

        FileDetailsEmailBody = FileDetailsEmailBody + \
                                "<table>" \
                                "<tr>" \
                                    "<th><b>S.No.</b></th>" \
                                    "<th><b>ErrorMessage</b></th>" \
                                    "<th><b>RecordCount</b></th>" \
                                "</tr>"

        for r in Row:
            Count += 1
            ErrorMessage = str(r.ValidationMessage)
            RecordCount = str(r.RecordErrorCount)

            FileDetailsEmailBody = FileDetailsEmailBody + " \
                                    ""<tr>" \
                                        "<td>" + str(Count) + "</td>" \
                                        "<td>" + ErrorMessage + "</td>" \
                                        "<td><b>" + RecordCount + "</b></td>" \
                                    "</tr>"

        FileDetailsEmailBody = FileDetailsEmailBody + "</table>"

        MessageLogger.info("EXITING FileDetails BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN FileDetails BLOCK " + str(e))

    return FileDetailsEmailBody


################################################################################################


def DataValidation(FileID, FileName, MessageLogger):
    MessageLogger.info("INSIDE DataValidation BLOCK")
    Error = True
    RecordErrorCount = 0
    TotalRecords = 0
    ErrorFlag = 0
    SuccessfulRecords = 0
    RowCount = 0
    InsertedRowCount = 0
    FileDetailsEmailBody = ''
    ErrorMessage = ''
    ExceptionFile = ""

    try:

        IsExceptionFile = FileName.find(RetailExceptionFilePrefix)

        if IsExceptionFile == -1:
            FileType = 0
            MessageLogger.info("PROCESSING NEW FILE")
        else:
            FileType = 1
            MessageLogger.info("PROCESSING EXCEPTION FILE")

        if AccountNumberCheck == 1:
            ExceptionFile = GetExceptionFileName(MessageLogger, FileName)
            MessageLogger.info("ExceptionFile: " + str(ExceptionFile))

        Query = "EXEC " + CI_DB + "..USP_ValidateRetailReplaySchedules '" + FileName + "', '" + FileID + "', " + str(BatchCount) + ", " + str(AccountNumberCheck) + ", " + str(FileType) + ", '" + str(ExceptionFile) + "'"

        Connection, ConnectionStatus = ConnectDB(MessageLogger)

        if ConnectionStatus:
            MessageLogger.debug(Query)

            try:
                Result = Connection.execute(Query)
                Row = Result.fetchall()
                RowCount = len(Row)
                Error = False
            except Exception as e:
                Error = True
                MessageLogger.error("Error in executing USP_ValidateRetailReplaySchedules, Query:: " + Query + "\n" + e)

            if RowCount > 0:
                for r in Row:
                    ErrorFlag = r.ErrorFlag
                    TotalRecords = TotalRecords + int(r.RecordErrorCount)
                    JobStatus = int(r.JobStatus)
                    if JobStatus != 1:
                        RecordErrorCount = RecordErrorCount + int(r.RecordErrorCount)

                FileDetailsEmailBody = FileDetails(FileName, Row, MessageLogger)

                SuccessfulRecords = TotalRecords - RecordErrorCount

                if ErrorFlag == 0:
                    ErrorMessage = 'No Error'
                    MessageLogger.info("USP_ValidateRetailReplaySchedules executed successfully")
                    Error = False
                elif ErrorFlag == 1:
                    ErrorMessage = 'Error in validation'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 2:
                    ErrorMessage = 'Error in inserting records'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 3:
                    ErrorMessage = 'No record to update'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)

                if SuccessfulRecords > 0 and ErrorFlag == 0:
                    Query = "EXEC " + CI_DB + "..USP_UpdateScheduleTypeOfBadSchedule '" + FileName + "', '" + FileID + "'"

                    # MessageLogger.debug(Query)

                    try:
                        Result = Connection.execute(Query)
                        InsertedRow = Result.fetchall()
                        InsertedRowCount = len(Row)
                        Error = False
                    except Exception as e:
                        Error = True
                        MessageLogger.error("Error in executing USP_UpdateScheduleTypeOfBadSchedule, Query:: " + Query + "\n" + e)

                    if InsertedRowCount > 0:
                        for r in InsertedRow:
                            ErrorFlag = r.ErrorFlag

                    if ErrorFlag == 0:
                        ErrorMessage = 'No Error'
                        MessageLogger.info("USP_UpdateScheduleTypeOfBadSchedule executed successfully")
                        Error = False
                    elif ErrorFlag == 1:
                        ErrorMessage = 'Error in inserting records'
                        MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                    elif ErrorFlag == 2:
                        ErrorMessage = 'Error in updating records'
                        MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                    elif ErrorFlag == 3:
                        ErrorMessage = 'No record to update'
                        MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif SuccessfulRecords <= 0:
                    ErrorMessage = 'No new record to update'
                    MessageLogger.info(ErrorMessage)
            else:
                Error = True
                ErrorMessage = 'Error in validating records'
                MessageLogger.info(ErrorMessage)


            Connection.close()
        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")

        MessageLogger.info("EXITING DataValidation BLOCK")

    except Exception as e:
        MessageLogger.error("ERROR IN DataValidation BLOCK ", str(e))

    return Error, ErrorFlag, ErrorMessage, TotalRecords, SuccessfulRecords, RecordErrorCount, FileDetailsEmailBody, ExceptionFile

################################################################################################


def GetExceptionFileName(MessageLogger, FileName):
    ExceptionFile = ""

    try:
        FileName_WithoutExt = os.path.splitext(FileName)[0]
        ExceptionFile = RetailExceptionFilePrefix + FileName_WithoutExt + RetailExceptionFileSuffix + RetailFileProcessingPOD +".csv"
    except Exception as e:
        MessageLogger.error("ERROR IN GetExceptionFileName BLOCK " + str(e))

    return ExceptionFile


def GenerateExceptionFile(FileID, FileName, ExceptionFile, MessageLogger):
    MessageLogger.info("INSIDE GenerateExceptionFile BLOCK")

    #ExceptionFile = ""

    try:
        #FileName_WithoutExt = os.path.splitext(FileName)[0]

        TotalRecords = 0

        #ExceptionFile = RetailExceptionFilePrefix + FileName_WithoutExt + RetailExceptionFileSuffix + RetailFileProcessingPOD +".csv"

        #ExceptionFileName = RetailExceptionFile + "\\" + GetExceptionFileName(MessageLogger, FileName)

        ExceptionFileName = RetailExceptionFile + "\\" + ExceptionFile

        MessageLogger.info("ExceptionFileName: " + ExceptionFileName)    

        Query = "SELECT  Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, " \
                "Schedule_ID, Institution_ID, Product_ID, Error, [Error_Message], Field_Path, LTRIM(RTRIM(AccountNumber)) AccountNumber " \
                "FROM " + CI_DB + "..ILPScheduleDetailsBAD_Archive WITH (NOLOCK) " \
                "WHERE FileName = '" + FileName + "' " \
                "AND FileID = '" + FileID + "' " \
                "AND JobStatus = 10"

        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)

        if ConnectionStatus:
            MessageLogger.debug(Query)

            QueryResult = pd.read_sql_query(Query, Connection)

            ResultDataFrame = pd.DataFrame(QueryResult)

            #MessageLogger.debug(ResultDataFrame)

            TotalRecords = len(ResultDataFrame)

            MessageLogger.info("TOTAL RECORDS FOR EXCEPTION FILE: " + str(TotalRecords))

            if TotalRecords > 0:
                ResultDataFrame.to_csv(ExceptionFileName, index=False)
                ExceptionFile = "<p style=""color:Crimson;""><b>EXCEPTION FILE NAME:</b> " + ExceptionFile + "</p>"
            else:
                ExceptionFile = "<p style=""color:Crimson;""><b>NO RECORDS FOR EXCEPTION FILE, IT HAS NOT BEEN GENERATED</b></p>"

            Connection.close()

        
            ExceptionFile = ExceptionFile + "<p style=""color:DarkBlue;""><b>TOTAL RECORDS IN EXCEPTION FILE: " + str(TotalRecords) + "</b></p>"

        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")

        MessageLogger.info("EXITING GenerateExceptionFile BLOCK")

    except Exception as e:
        ExceptionFile = "<p style=""color:DarkRed;""><b>ERROR :: EXCEPTION FILE HAS NOT BEEN GENERATED</b></p>"
        MessageLogger.error("ERROR IN GenerateExceptionFile BLOCK " + str(e))

    return ExceptionFile


################################################################################################


def get_secret(MessageLogger): 
    MessageLogger.info("INSIDE GETTING THE AWS SECRET KEY")

    secret = ""

    secret_name = RetailAWS_secret_name
    region_name = RetailAWS_region_name 

    # Create a Secrets Manager client
    try: 
        MessageLogger.info("GETTING SESSION")
        session = boto3.session.Session()
        MessageLogger.info("GETTING CLIENT")
        client = session.client(
            service_name=RetailAWS_service_name,
            region_name=region_name
        )
    except Exception as E:
        MessageLogger.exception("Error in getting session and client:: ", E)

 

    # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
    # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    # We rethrow the exception by default.

 

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        MessageLogger.error("ERROR IN FETCHING THE SECRET KEY")
        if e.response['Error']['Code'] == 'DecryptionFailureException':
            # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("DecryptionFailureException error")
            raise e
        elif e.response['Error']['Code'] == 'InternalServiceErrorException':
            # An error occurred on the server side.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("InternalServiceErrorException error")
            raise e
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            # You provided an invalid value for a parameter.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("InvalidParameterException error")
            raise e
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            # You provided a parameter value that is not valid for the current state of the resource.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("InvalidRequestException error")
            raise e
        elif e.response['Error']['Code'] == 'ResourceNotFoundException':
            # We can't find the resource that you asked for.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("ResourceNotFoundException error")
            raise e
        elif e.response['Error']['Code'] == 'NoCredentialsError':
            # We can't find the resource that you asked for.
            # Deal with the exception here, and/or rethrow at your discretion.
            MessageLogger.error("NoCredentialsError error")
            raise e
    else:
        # Decrypts secret using the associated KMS CMK.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        MessageLogger.info("NO ERROR IN FETCHING THE SECRET KEY")
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
            MessageLogger.info("SECRET KEY (secret): " + secret)
        else:
            decoded_binary_secret = base64.b64decode(get_secret_value_response['SecretBinary'])
            MessageLogger.info("SECRET KEY (decoded_binary_secret): " + decoded_binary_secret)

    return secret if secret != "" else decoded_binary_secret


################################################################################################


def ValidateDuplicateFile(OutputDir, FileName, MessageLogger):
    
    MessageLogger.info("INSIDE ValidateDuplicateFile BLOCK")

    ErrorReason = "No Error"
    Error = False

    try:

        FilePath = Path(OutputDir + FileName)
        MessageLogger.debug(FilePath)
        

        if FilePath.is_file():
            Error = True
            MessageLogger.info("File " + FileName + " is already present in OUTPUT folder. So it can not be processed.")
            ErrorReason = "Duplicate File"

            MessageLogger.info(ErrorReason)

        MessageLogger.info("EXITING ValidateDuplicateFile BLOCK")

    except Exception:
        MessageLogger.error("ERROR IN ValidateDuplicateFile BLOCK ", exc_info=True)

    return Error, ErrorReason

################################################################################################


def GetOperatingServer(MessageLogger):
    OperatingServer = ''
    try:
        MessageLogger.info('INSIDE GetOperatingServer BLOCK')
        RowCount = 0

        Query = "SELECT TOP 1 INFO_VALUE FROM Admin.dbo.TB_INFO WHERE INFO_KEY = 'SERVERNAME'"

        Connection, ConnectionStatus = ConnectDB(MessageLogger)
        if ConnectionStatus:
            try:
                Result = Connection.execute(Query)
                Row = Result.fetchall()
                RowCount = len(Row)
                Error = False
            except Exception as e:
                Error = True
                Message = 'Error in executing the query :: ' + Query
                MessageLogger.error(Message + "\n" + e)

            if RowCount > 0:
                for r in Row:
                    OperatingServer = r.INFO_VALUE

            MessageLogger.info('OperatingServer: ' + OperatingServer)
        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")
        
        MessageLogger.info('EXITING GetOperatingServer BLOCK')

    except Exception as e:
        MessageLogger.error("ERROR INSIDE GetOperatingServer BLOCK " + str(e))
        #MessageLogger.error(e)

    return OperatingServer


###################################################################################################


def EmailBody_Error(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger):
    MessageLogger.info("INSIDE EmailBody_Error BLOCK")
    try:
        EmailBody = "<tr>" \
                        "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                        "<td style=""color:red;""><b>ERROR</b></td>" \
                        "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                        "<td style=""color:green;"">" + str(SuccessfulRecordsCount) + "</td>" \
                        "<td style=""color:red;"">" + str(ErrorRecordCount) + "</td>" \
                        "<td style=""color:red;"">" + str(ErrorReason) + "</td>" \
                    "</tr>"
        MessageLogger.info("EXITING EmailBody_Error BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN EmailBody_Error BLOCK " +  str(e))

    return EmailBody


################################################################################################


def EmailBody_Success(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger):
    MessageLogger.info("INSIDE EmailBody_Success BLOCK")
    try:
        EmailBody = "<tr>" \
                        "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                        "<td style=""color:green;""><b>Success</b></td>" \
                        "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                        "<td style=""color:green;"">" + str(SuccessfulRecordsCount) + "</td>" \
                        "<td style=""color:red;"">" + str(ErrorRecordCount) + "</td>" \
                        "<td style=""color:green;"">" + str(ErrorReason) + "</td>" \
                    "</tr>"
        MessageLogger.info("EXITING EmailBody_Error BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN EmailBody_Success BLOCK " +  str(e))

    return EmailBody


################################################################################################


def EmailStructure_Head(FileProcessingStartTime, OperatingServer, MessageLogger):
    MessageLogger.info("INSIDE EmailStructure_Head BLOCK")
    EmailHead = ''
    try:
        OperatingTime = FileProcessingStartTime.strftime('%m/%d/%Y %H:%M:%S')

        EmailHead = "<h4 style=""color:green;>Operating Sever: " + OperatingServer + "</h4>"
        EmailHead = EmailHead + "<h4 style=""color:Coral;>Server operating time: " + str(OperatingTime) + "</h4>"
        EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(RetailFileProcessingPOD) + "</h4>"

        EmailHead  = EmailHead + \
                        "<table>" \
                        "<tr>" \
                            "<th><b>FileName</b></th>" \
                            "<th><b>FileStatus</b></th>" \
                            "<th><b>TotalRecords</b></th>" \
                            "<th><b>SuccessfulRecordsCount</b></th>" \
                            "<th><b>ErrorRecordCount</b></th>" \
                            "<th><b>ErrorReason</b></th>" \
                        "</tr>"
        MessageLogger.info("EXITING EmailStructure_Head BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN EmailStructure_Head BLOCK " + str(e))

    return EmailHead


################################################################################################


def EmailStructure_Style():
    Style = "<style>" \
                "table, th {"\
                    "border: 2px solid black;" \
                    "border-collapse: collapse;" \
                    "font-family: Calibri;" \
                    "font-size: 19px;" \
                "}" \
                "td {" \
                    "border: 1px solid black;" \
                    "border-collapse: collapse;" \
                    "font-family: Calibri;" \
                    "font-size: 17px;" \
                "}" \
                "tr {"\
                    "font-family: Calibri;" \
                "}" \
                ".footer {" \
                "position: fixed;" \
                "left: 0;" \
                "bottom: 0;" \
                "width: 100%;" \
                "background-color: grey;" \
                "color: white;" \
                "text-align: center;" \
                "font-family: Calibri;" \
                "}" \
            "</style>"

    return Style


################################################################################################


def EmailStructure_Subject():
    EMailSubject = "Alert | PLAT - " + RetailEnvironment + " ::: Milk Replay Schedules file processing"

    return EMailSubject


################################################################################################

def EmailStrucute_Tail():
    Tail = "</table>"

    return Tail


################################################################################################


def EmailStructure_Footer(LogDateTime):
    currentYear = str(LogDateTime.strftime("%Y"))
    Footer = "<div class=\"footer\">" \
                "<footer>" \
                    "<small>&copy; Copyright " + currentYear +", CoreCard Software, Inc. All rights reserved</small>" \
                "</footer>" \
            "</div>"

    return Footer


################################################################################################


def readOutputBCPDetails(LogDir, MessageLogger):
    MessageLogger.info("Reading BCP Output file")
    OutputFile = LogDir + "Output1_in.log"
    Count = 0
    MessageLogger.info("Output File Location: " + OutputFile)

    with open(OutputFile) as f:
        for line in f:
            line.strip().split('/n')
            LineToPrint = line.strip()
            Count += 1

            if LineToPrint != "":
                MessageLogger.info(LineToPrint)
    f.close()


def ImportFileToDB(InputDir, FileName, dir_path, LogDir, MessageLogger):
    MessageLogger.info("INSIDE ImportFileToDB BLOCK")
    Error = True
    ErrorMessage = ''

    try:

        File = InputDir + FileName

        Query = "TRUNCATE TABLE " + CI_DB + "..ILPScheduleDetailsBAD_DUMP"

        Connection, ConnectionStatus = ConnectDB(MessageLogger)

        if ConnectionStatus:

            try:
                Connection.execute(Query)
                Error = False
                MessageLogger.info("TABLE ILPScheduleDetailsBAD_DUMP TRUNCATED SUCCESSFULLY")
            except Exception:
                Error = True
                ErrorMessage = "ERROR IN TRUNCATING THE TABLE :: QUERY :: " + Query
                MessageLogger.info(ErrorMessage, exc_info=True)


            if Error is False:
                BCP = "bcp " + CI_DB + "..ILPScheduleDetailsBAD_DUMP IN " + File + " -b 5000 -h TABLOCK " \
                        "-f " + dir_path + "MilkReplaySchedules.xml -e " + str(LogDir) + "Error1_in.log -o "  \
                        + str(LogDir) + "Output1_in.log -q -S " + SERVERNAME + " -T -t , -F 2"

                MessageLogger.debug(BCP)
                try:
                    MessageLogger.info("BCP START TIME::: " + str(datetime.datetime.now()))
                    subprocess.run(BCP)
                    readOutputBCPDetails(LogDir, MessageLogger)
                    Error = False
                    ErrorMessage = "NO ERROR"
                    MessageLogger.info("BCP EXECUTION SUCCESSFULL")
                    MessageLogger.info("BCP FINISH TIME::: " + str(datetime.datetime.now()))
                except Exception:
                    Error = True
                    ErrorMessage = "ERROR IN EXECUTING THE BCP :: BCP :: " + BCP
                    MessageLogger.error(ErrorMessage, exc_info=True)

            Connection.close()
        
        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")
        
        MessageLogger.info("EXITING ImportFileToDB :: Message :: " + ErrorMessage)
    except Exception as e:
        MessageLogger.error("ERROR IN ImportFileToDB BLOCK " + str(e))

    return Error, ErrorMessage


################################################################################################


def MoveFileToError(InputDir, ErrorDir, FileName):
    
    shutil.move(InputDir + FileName, ErrorDir + FileName)

    
################################################################################################


def MoveFileToOutput(InputDir, OutputDir, FileName):
    
    shutil.move(InputDir + FileName, OutputDir + FileName)


################################################################################################


def SendMail(EmailSubject, EmailBody, MessageLogger):
    try:
        #MessageLogger.info("RetailAWSEnvironment Type: " + str(type(RetailAWSEnvironment)))
        if RetailAWSEnvironment == 0:
            MessageLogger.debug("Inside SendMail")
            Body = MIMEText(EmailBody, 'html')

            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = MailFrom
            msg['To'] = MailTo
            msg.attach(Body)

            server = smtplib.SMTP(SMTP_SERVER, SMTPPORT)
            # server.sendmail(self.eMailFrom, self.eMailTo, message)
            Message = "SENDING MAIL ..."
            MessageLogger.info(Message)
            server.send_message(msg)
            server.quit()
        elif RetailAWSEnvironment == 1:
            MessageLogger.info("INSIDE AWS SES PROCESS")

            Body = MIMEText(EmailBody, 'html')
            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = MailFrom
            msg['To'] = MailTo
            msg.attach(Body)

            AWSSecretKeyStr = get_secret(MessageLogger)

            AWSSecretKey = json.loads(AWSSecretKeyStr)

            #MessageLogger.info("AWSSecretKey: ", AWSSecretKey)

            user        = AWSSecretKey.get("id")
            password    = AWSSecretKey.get("ses_smtp_password_v4")

            MessageLogger.info("user: " + user)
            MessageLogger.info("password: " + password)

            server = smtplib.SMTP(RetailSES_smtp_url, RetailAWSPort)
            server.set_debuglevel(1)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login(user, password)
            MessageLogger.info("SENDING MAIL ...")
            server.send_message(msg)
            MessageLogger.info("MAIL SENT")

        else:
            MessageLogger.info("INVALID ENVIRONMENT")
    except Exception as e:
        Error = True
        MessageLogger.exception("Error in sending mail ")


################################################################################################
################################################################################################
################################################################################################
################################################################################################
################################################################################################

InputDir, OutputDir, ErrorDir, LogDir, ABORTPROCESSING = DirectoryValidation()

if ABORTPROCESSING is False:
    LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

    MessageLogger = get_logger(LOG_FILE)

    MessageLogger.info("*************************** RETAIL ERROR FEED PROCESSING STARTS ***************************")
    MessageLogger.info("START TIME: " + str(FileProcessingStartTime))

    printVaribales(MessageLogger)

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
                ABORTPROCESSING, ErrorFlag, ErrorReason, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, FileDetailsEmailBody, ExceptionFile = DataValidation(FileNameId, FileName, MessageLogger)
                if ABORTPROCESSING:
                    MoveFileToError(InputDir, ErrorDir, FileName)
                else:
                    MoveFileToOutput(InputDir, OutputDir, FileName)
                    FileRecordDetails = FileRecordDetails + FileDetailsEmailBody
                    if AccountNumberCheck == 1:
                        ExceptionFile = GenerateExceptionFile(FileNameId, FileName, ExceptionFile, MessageLogger)

            if ABORTPROCESSING is False:
                EmailBody = EmailBody + EmailBody_Success(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)
            else:
                EmailBody = EmailBody + EmailBody_Error(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)

        EmailBody = EmailBody + EmailStrucute_Tail()
        EmailBody = EmailBody + FileRecordDetails + ExceptionFile

        if FileCount == 0:
            EmailBody = "<h4 style=""color:green;>Operating Sever: " + OperatingServer + "</h4>"
            EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(FileProcessingStartTime.strftime('%m/%d/%Y %H:%M:%S')) + "</h4>"
            EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(RetailFileProcessingPOD) + "</h4>"
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
