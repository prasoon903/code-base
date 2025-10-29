import logging
import configparser
import datetime
import os
import pyodbc
import sys
import shutil
import glob
import pandas as pd
import subprocess
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import json
import smtplib
import boto3
import base64
from botocore.exceptions import ClientError
import unidecode

LogDateTime = datetime.datetime.now()
dir_path = str(os.getcwd()) + "\\"
FileProcessingStartTime = datetime.datetime.now()
EmailSubject = ''
EmailHead = ''
EmailTail = ''
EmailStyle = ''
EmailFooter = ''
EmailBody = ''
EMAIL = ""
FileDetailsRecord = ""
FileDetailsEmailBody = ""
ABORT = False

################################################################################################

Config = configparser.ConfigParser()
Config.read("SetupCIPy.ini")

POD = Config['DEFAULT']['POD']
ProcessingEnvironment = Config['StatementCreditUtility']['ProcessingEnvironment']

CI_DB = Config['DEFAULT']['DBName_CI']
CL_DB = Config['DEFAULT']['DBName_CL']
CAuth_DB = Config['DEFAULT']['DBName_CAuth']
SERVERNAME = Config['DEFAULT']['DB_Server_NAME']

MailFrom = Config['DEFAULT']['alert_email_sender']
MailTo = Config['StatementCreditUtility']['alert_email_receiver']

SMTP_SERVER = Config['DEFAULT']['SMTP_SERVER']
SMTPPORT = int(Config['DEFAULT']['SMTP_PORT'])

AWSEnvironment = int(Config['DEFAULT']['AWSEnvironment'])
AWS_secret_name = Config['DEFAULT']['ses_smtp_secret_name']
AWS_region_name = Config['DEFAULT']['ses_region_name']
SES_smtp_url = Config['DEFAULT']['ses_smtp_url']
AWSPort = Config['DEFAULT']['ses_smtp_port']
AWS_service_name = Config['DEFAULT']['ses_service_name']

SCFUInputDir = Config['StatementCreditUtility']['InputDir']
SCFUOutputDir = Config['StatementCreditUtility']['OutputDir']
SCFUErrorDir = Config['StatementCreditUtility']['ErrorDir']
SCFULogDir = Config['StatementCreditUtility']['LogDir']
SCFUExceptionDir = Config['StatementCreditUtility']['ExceptionDir']
SCFUResponseDir = Config['StatementCreditUtility']['ResponseDir']

ShardMigrationStatusCheck = Config['StatementCreditUtility']['Sharding']

InputFilePrefix = Config['StatementCreditUtility']['InputFilePrefix']
ResponseFilePrefix = Config['StatementCreditUtility']['ResponseFilePrefix']

ValidatorBatchCount = Config['StatementCreditUtility']['ValidatorBatchCount']
PostingBatchCount = Config['StatementCreditUtility']['PostingBatchCount']

CheckForCutOffTime = int(Config['StatementCreditUtility']['CheckForCutOffTime'])
CutoffTime = Config['StatementCreditUtility']['CutoffTime']

FORMATTER = logging.Formatter("%(asctime)s — %(thread)s — %(levelname)s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')

################################################################################################
################################################################################################
################################################################################################
################################################################################################

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

################################################################################################

def ConnectDB_ConnectionObject(MessageLogger):
    ConnectionStatus = False
    con = ""
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 17 for SQL Server}",
                            server=SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True,
                            app="StatementCreditFileUtility")
        
        MessageLogger.info("CONNECTION ESTABLISHED")
        ConnectionStatus = True
    except Exception as e:
        MessageLogger.error("ERROR IN CONNECTING TO THE DATABASE " + str(e))

    MessageLogger.info("ConnectionStatus: " + str(ConnectionStatus))

    return con, ConnectionStatus

################################################################################################

def DirectoryValidation():
    ErrorFlag = True
    Check = True
    Message = ''

    if SCFUInputDir == "":
        ErrorFlag = True
        Message = "Environment variable for Input folder is not set"
    elif SCFUOutputDir == "":
        ErrorFlag = True
        Message = "Environment variable for Output folder is not set"
    elif SCFUErrorDir == "":
        ErrorFlag = True
        Message = "Environment variable for Error folder is not set"
    elif SCFULogDir == "":
        ErrorFlag = True
        Message = "Environment variable for Log folder is not set"
    elif SCFUExceptionDir == "":
        ErrorFlag = True
        Message = "Environment variable for Exception folder is not set"
    elif SCFUResponseDir == "":
        ErrorFlag = True
        Message = "Environment variable for Response folder is not set"  
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = SCFUInputDir + "\\"
        OutputDir = SCFUOutputDir + "\\"
        ErrorDir = SCFUErrorDir + "\\"
        LogDir = SCFULogDir + "\\"
        ExceptionDir = SCFUExceptionDir + "\\"
        ResponseDir = SCFUResponseDir + "\\"
        

    if Check == True:
        Check = os.path.isdir(InputDir)
    if Check == True:
        Check = os.path.isdir(OutputDir)
    if Check == True:
        Check = os.path.isdir(ErrorDir)    
    if Check == True:
        Check = os.path.isdir(LogDir)
    if Check == True:
        Check = os.path.isdir(ExceptionDir)
    if Check == True:
        Check = os.path.isdir(ResponseDir)
    if Check == False:
        ErrorFlag = True

    print(Message)

    return InputDir, OutputDir, ErrorDir, LogDir, ResponseDir, ExceptionDir, ErrorFlag

################################################################################################

def MoveFileToLocation(SourceDir, DestinationDir, FileName):
    shutil.move(SourceDir + FileName, DestinationDir + FileName)

################################################################################################

def FileToProcess(FileName, FileID, MessageLogger):
    FileStatus = ''
    ErrorFlag = 0
    Message = ''
    RowCount = 0
    IsError = False
    SkipImportData = False
    SkipValidation = False

    Query = "EXEC " + CI_DB + "..USP_GetStatusOfStatementCreditFileProcessing '" + FileName + "','" + FileID + "'"

    Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
    MessageLogger.debug(Query)
    
    if ConnectionStatus:
        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            IsError = True
            Message = 'Error in executing the stored procedure USP_GetStatusOfPaymentHoldFileProcessing'
            MessageLogger.debug(Message)

        if RowCount > 0 and IsError == False:
            for r in Row:
                ErrorFlag   = r.ErrorFlag
                FileStatus  = r.FileStatus
                ShouldProcess =  r.ShouldProcess          

            if ErrorFlag == 0:
                if ShouldProcess == 'FALSE':
                    IsError = True
                    Message = 'File is in ERROR state'
                elif FileStatus == 'NEW':
                    IsError = False
                    Message = 'File is in NEW state and going to process'
                elif FileStatus == 'ERROR':
                    IsError = False
                    Message = 'File is in ERROR state and going to process again'
                elif FileStatus == 'READY TO VALIDATE':
                    IsError = False
                    SkipImportData = True
                    Message = 'File is in READY TO VALIDATE state and going to process again'
                elif FileStatus == 'VALIDATION DONE':
                    IsError = False
                    SkipImportData = True
                    Message = 'File is in VALIDATION DONE state and going to process again'
                elif FileStatus == 'READY FOR POSTING TXN':
                    IsError = False
                    SkipImportData = True
                    SkipValidation = True
                    Message = 'File is in READY FOR POSTING TXN state and going to process posting'
                elif FileStatus == 'DONE':
                    IsError = True
                    Message = 'File has already been processed'

                MessageLogger.info(Message)
            else:
                Message = 'Error found in checking the status of the file'
                MessageLogger.debug(Message)

    return IsError, SkipImportData, SkipValidation, Message

################################################################################################

def printVaribales(MessageLogger):
    MessageLogger.info("POD : " + str(POD))
    MessageLogger.info("ProcessingEnvironment : " + ProcessingEnvironment)
    MessageLogger.info("CoreIssue DB : " + CI_DB)
    MessageLogger.info("CoreLibrary DB : " + CL_DB)
    MessageLogger.info("CoreAuth DB : " + CAuth_DB)
    MessageLogger.info("DB Server : " + SERVERNAME)
    MessageLogger.info("AWSEnvironment : " + str(AWSEnvironment))
    MessageLogger.info("SCFUInputDir : " + SCFUInputDir)
    MessageLogger.info("SCFUOutputDir : " + SCFUOutputDir)
    MessageLogger.info("SCFUErrorDir : " + SCFUErrorDir)
    MessageLogger.info("SCFULogDir : " + SCFULogDir)
    MessageLogger.info("SCFUExceptionDir : " + SCFUExceptionDir)
    MessageLogger.info("SCFUResponseDir : " + SCFUResponseDir)
    MessageLogger.info("ShardMigrationStatusCheck : " + ShardMigrationStatusCheck)
    MessageLogger.info("ValidatorBatchCount : " + ValidatorBatchCount)
    MessageLogger.info("PostingBatchCount : " + PostingBatchCount)
    MessageLogger.info("CheckForCutOffTime : " + str(CheckForCutOffTime))
    MessageLogger.info("CutoffTime : " + CutoffTime)


################################################################################################

def ValidateDuplicateFile(OutputDir, FileName, MessageLogger):
    
    MessageLogger.info("INSIDE ValidateDuplicateFile BLOCK")

    ErrorReason = "No Error"
    Error = False

    try:

        FilePath = os.path.join(OutputDir, FileName)
        MessageLogger.debug(FilePath)

        if os.path.isfile(FilePath):
            Error = True
            MessageLogger.info("File " + FileName + " is already present in OUTPUT folder. So it can not be processed.")
            ErrorReason = "Duplicate File"

            MessageLogger.info(ErrorReason)

        MessageLogger.info("EXITING ValidateDuplicateFile BLOCK")

    except Exception:
        MessageLogger.error("ERROR IN ValidateDuplicateFile BLOCK ", exc_info=True)

    return Error, ErrorReason

###################################################################################################

def CheckEmptyFile(InputDir, FileName, MessageLogger):
    MessageLogger.info("INSIDE CheckEmptyFile BLOCK")
    ABORT = False
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
            MessageLogger.info("Empty file")

    except Exception as e:
        ABORT = True
        MessageLogger.error("ERROR IN CheckEmptyFile BLOCK", e)

    return ABORT, EmptyFile, ErrorReason, RecordCount

################################################################################################

def readOutputBCPDetails(LogDir, MessageLogger):
    MessageLogger.info("Reading BCP Output file")
    OutputFile = LogDir + "Output" + "_in.log"
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

################################################################################################

def ImportFileToDB(InputDir, FileName, dir_path, LogDir, MessageLogger):
    MessageLogger.info("INSIDE ImportFileToDB BLOCK")
    Error = True
    ErrorMessage = ''

    try:
        Query = "TRUNCATE TABLE " + CI_DB + "..StatementCredit_DUMP"
        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
        if ConnectionStatus:
            try:
                Connection.execute(Query)
                Error = False
                MessageLogger.info("TABLE StatementCredit_DUMP TRUNCATED SUCCESSFULLY")
            except Exception:
                Error = True
                ErrorMessage = "ERROR IN TRUNCATING THE TABLE :: QUERY :: " + Query
                MessageLogger.info(ErrorMessage, exc_info=True)

            
            MessageLogger.info("IMPORTING FILE DATA OF FILE : " + FileName)
            File = InputDir + FileName

            if Error is False:
                BCP = "bcp " + CI_DB + "..StatementCredit_DUMP IN " + File + " -b 5000 -h TABLOCK " \
                        "-f " + dir_path + "StatementCreditUtility.xml -e " + str(LogDir) + "Error_in.log -o "  \
                        + str(LogDir) + "Output_in.log -S " + SERVERNAME + " -T -t , -F 2"
                
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

def GetResponseFileName(MessageLogger, RecordCount, FileName, ResponseDir):
    ResponseFile = ""
    MessageLogger.info("Inside GetResponseFileName Block")
    try:
        FileName_WithoutExt = FileName[16:24]
        # print(ResponseFilePrefix)
        # print(FileName_WithoutExt)
        # print(RecordCount)
        ResponseFile = ResponseFilePrefix + FileName_WithoutExt + "_" + str(RecordCount) # +".csv"
        NewResponseFile = ResponseFile
        
        count = 1
        while os.path.exists(ResponseDir + NewResponseFile + ".csv" ):
            NewResponseFile = ResponseFile + "_" + str(count)
            count += 1
        
        ResponseFile = NewResponseFile + ".csv"
        
    except Exception as e:
        MessageLogger.error("ERROR IN GetResponseFileName BLOCK " + str(e))

    return ResponseFile

def DataValidation(FileID, FileName, MessageLogger):
    MessageLogger.info("INSIDE DataValidation BLOCK")
    Error = True
    ErrorFlag = 0
    RowCount = 0
    ErrorMessage = ''
    ExceptionFile = ""

    try:

        Query = "EXEC " + CI_DB + "..USP_ValidateStatementCreditRecords '" + FileName + "', '" + FileID + "', " + str(ValidatorBatchCount) + "," + str(ShardMigrationStatusCheck) + ", '" + str(ExceptionFile) + "'"

        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)

        if ConnectionStatus:
            MessageLogger.debug(Query)

            try:
                Result = Connection.execute(Query)
                Row = Result.fetchall()
                RowCount = len(Row)
                # print(RowCount)
                Error = False
            except Exception as e:
                Error = True
                MessageLogger.error("Error in executing USP_ValidateStatementCreditRecords, Query:: " + Query + "\n" + e)

            if RowCount > 0:
                for r in Row:
                    ErrorFlag = r.ErrorFlag
                    JobStatus = int(r.JobStatus)
                    MessageLogger.info("ErrorReason -> " + r.ErrorReason)

                if ErrorFlag == 0:
                    ErrorMessage = 'No Error'
                    MessageLogger.info("USP_ValidateStatementCreditRecords executed successfully")
                    Error = False
                elif ErrorFlag == 1:
                    Error = True
                    ErrorMessage = 'Error in validation'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 2:
                    Error = True
                    ErrorMessage = 'Error in inserting records'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 3:
                    ErrorMessage = 'No record'
                    Error = False
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
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

    return Error, ErrorFlag, ErrorMessage, ExceptionFile


################################################################################################

def FileDetails(FileName, Row, MessageLogger):
    MessageLogger.info("INSIDE FileDetails BLOCK")
    FileDetailsEmailBody = ""
    print(type(FileDetailsEmailBody))
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
            ErrorMessage = str(r.ErrorReason)
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

    print(FileDetailsEmailBody)
    print(type(FileDetailsEmailBody))
    return FileDetailsEmailBody

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
        EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(POD) + "</h4>"

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
    EMailSubject = "ALERT | JAZZ " + ProcessingEnvironment + " ::: Statement Credit file processing"

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

def SendMail(EmailSubject, EmailBody, MessageLogger):
    try:
        #MessageLogger.info("RetailAWSEnvironment Type: " + str(type(RetailAWSEnvironment)))
        if AWSEnvironment == 0:
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
        elif AWSEnvironment == 1:
            MessageLogger.info("INSIDE AWS SES PROCESS")

            Body = MIMEText(EmailBody, 'html')
            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = MailFrom
            msg['To'] = MailTo
            msg.attach(Body)

            AWSSecretKeyStr = get_secret(MessageLogger)
            format_secret = unidecode.unidecode(AWSSecretKeyStr)
            AWSSecretKey = json.loads(format_secret)

            #AWSSecretKey = json.loads(AWSSecretKeyStr)

            #MessageLogger.info("AWSSecretKey: ", AWSSecretKey)

            user        = AWSSecretKey.get("id")
            password    = AWSSecretKey.get("ses_smtp_password_v4")

            MessageLogger.info("user: " + user)
            MessageLogger.info("password: " + password)

            server = smtplib.SMTP(SES_smtp_url, AWSPort)
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

def GetOperatingServer(MessageLogger):
    OperatingServer = ''
    try:
        MessageLogger.info('INSIDE GetOperatingServer BLOCK')
        RowCount = 0

        Query = "SELECT TOP 1 INFO_VALUE FROM Admin.dbo.TB_INFO WHERE INFO_KEY = 'SERVERNAME'"

        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
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
                
            Connection.close()

            MessageLogger.info('OperatingServer: ' + OperatingServer)
        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")
        
        MessageLogger.info('EXITING GetOperatingServer BLOCK')
    except Exception as e:
        MessageLogger.error("ERROR INSIDE GetOperatingServer BLOCK " + str(e))
        #MessageLogger.error(e)

    return OperatingServer


###############################################################################################

def get_secret(MessageLogger): 
    MessageLogger.info("INSIDE GETTING THE AWS SECRET KEY")

    secret = ""

    secret_name = AWS_secret_name
    region_name = AWS_region_name 

    # Create a Secrets Manager client
    try: 
        MessageLogger.info("GETTING SESSION")
        session = boto3.session.Session()
        MessageLogger.info("GETTING CLIENT")
        client = session.client(
            service_name=AWS_service_name,
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

def GenerateResponseFile(FileID, FileName, ResponseDir, MessageLogger):
    MessageLogger.info("INSIDE GenerateResponseFile BLOCK")

    try:

        TotalRecords = 0
        
        ResponseEmailData = ""

        Query = "SELECT account_uuid, transaction_effective_date, transaction_code, statement_credit_amount, RTRIM(campaign_id) campaign_id, ErrorReason Error_Reason " \
                "FROM " + CI_DB + "..StatementCreditTransactionData WITH (NOLOCK) " \
                "WHERE FileName = '" + FileName + "' " \
                "AND FileID = '" + FileID + "' " \
                "AND JobStatus NOT IN (0,1)" 


        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)

        if ConnectionStatus:
            MessageLogger.debug(Query)

            QueryResult = pd.read_sql_query(Query, Connection)

            ResultDataFrame = pd.DataFrame(QueryResult)
            ResultDataFrame['campaign_id'] = ResultDataFrame['campaign_id'].str.replace(r'\r', '', regex=True)
            MessageLogger.debug(ResultDataFrame)

            TotalRecords = len(ResultDataFrame)

            ResponseFileName = GetResponseFileName(MessageLogger, TotalRecords, FileName, ResponseDir)
            ResponseFile = ResponseDir + ResponseFileName
            MessageLogger.info("ResponseFileName: " + ResponseFileName) 

            MessageLogger.info("TOTAL RECORDS FOR RESPONSE FILE: " + str(TotalRecords))

            if TotalRecords > 0:
                ResultDataFrame.to_csv(ResponseFile, sep=',', index=False, mode='w', escapechar='\n')
                ResponseEmailData = "<p style=""color:Crimson;""><b>RESPONSE FILE NAME:</b> " + ResponseFileName + "</p>"
            else:
                GenerateEmptyResponseFile(ResponseDir, FileName, MessageLogger)
                ResponseEmailData = "<p style=""color:Crimson;""><b>RESPONSE FILE NAME:</b> " + ResponseFileName + "</p>"

            Connection.close()

            ResponseEmailData = ResponseEmailData + "<p style=""color:DarkBlue;""><b>TOTAL RECORDS IN RESPONSE FILE: " + str(TotalRecords) + "</b></p>"

        else:
            MessageLogger.info("ERROR IN CONNECTING TO THE DATABASE")

        MessageLogger.info("EXITING GenerateResponseFile BLOCK")

    except Exception as e:
        ResponseEmailData = "<p style=""color:DarkRed;""><b>ERROR :: RESPONSE FILE HAS NOT BEEN GENERATED</b></p>"
        MessageLogger.error("ERROR IN GenerateResponseFile BLOCK " + str(e))

    return ResponseEmailData

################################################################################################

def CreateStatementCreditTransaction(FileName, FileId, MessageLogger):
    MessageLogger.info("INSIDE CreateStatementCreditTransaction BLOCK")
    Error = False
    ErrorReason = ""

    Query = "EXEC " + CI_DB + "..USP_PostingStatementCreditTxn '" + FileName + "', '" + FileId + "', " + str(PostingBatchCount)
    MessageLogger.debug(Query)
    try:
        Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
        if ConnectionStatus:
            try:
                Result = Connection.execute(Query)
                Row = Result.fetchall()
                RowCount = len(Row)
            except Exception as e:
                Error = True
                ErrorReason = 'Error in executing the query :: ' + Query
                MessageLogger.error(ErrorReason + "\n" + e)
            
            if RowCount > 0:
                for r in Row:
                    MessageLogger.info("LOG OF POSTING : Error = " + str(r.Error) + ", ErrorMessage = " + r.ErrorMessage + ", SPName = " + r.SPName)
                    if r.Error == 1:
                        Error = True

            Connection.close()

    except Exception as e:
        Error = True
        MessageLogger.exception("Error in CreateStatementCreditTransaction:: ", e)


    return Error, ErrorReason

##########################################################################################################

def  GetPostingEmailData(FileName, SuccessfullyPosted, MessageLogger):
    MessageLogger.info("INSIDE GetPostingEmailData BLOCK")
    FileDetailsEmailBody = ''
    try:
        FileDetailsEmailBody = "<p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"

        FileDetailsEmailBody = FileDetailsEmailBody + \
                                "<table>" \
                                "<tr>" \
                                    "<th><b>Type of Jobs</b></th>" \
                                    "<th><b>RecordCount</b></th>" \
                                "</tr>"
        
        FileDetailsEmailBody = FileDetailsEmailBody + " \
                                ""<tr>" \
                                    "<td> Successfully Posted Txn </td>" \
                                    "<td><b>" + str(SuccessfullyPosted) + "</b></td>" \
                                "</tr>"

        FileDetailsEmailBody = FileDetailsEmailBody + "</table>"

        MessageLogger.info("EXITING GetPostingEmailData BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN GetPostingEmailData BLOCK " + str(e))

    return FileDetailsEmailBody

###################################################################################################################

def GenerateEmptyResponseFile(ResponseDir, FileName, MessageLogger):
    ResponseFile = "account_uuid,transaction_effective_date,transaction_code,statement_credit_amount,campaign_id,Error_Reason"
    try:
        ResponseFileName = GetResponseFileName(MessageLogger, 0, FileName, ResponseDir)
            
        file1 = open( ResponseDir + ResponseFileName, "w")
        file1.writelines(ResponseFile)
        file1.close()
    except Exception as e:
        MessageLogger.error("Error in GenerateEmptyResponseFile block :: ", e)
    
    return ResponseFileName

###################################################################################################################

def CheckFileName(FileName, FileRecordCount, FileId, MessageLogger):
    ABORT = False
    Message = ''

    try:
        RecordsInFileName = int(FileName[25:-4])

        if RecordsInFileName != FileRecordCount:
            ABORT = True
            Message = 'Records mentioned in FileName doesnt match with record present in File'
            Query = "EXEC " + CI_DB + "..USP_MarkErrorStatementCreditFile '" + FileName + "', '" + FileId + "'"
            
            MessageLogger.info(Query)

            Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
            
            if ConnectionStatus:
                try:
                    Result = Connection.execute(Query)
                    Row = Result.fetchall()
                    RowCount = len(Row)
                except Exception as e:
                    ABORT = True
                    ErrorReason = 'Error in executing the query :: ' + Query
                    MessageLogger.error(ErrorReason + "\n" + e)
            
            if RowCount > 0:
                for r in Row:
                    ErrorFlag = r.ErrorFlag
            if ErrorFlag == 0:
                MessageLogger.info("USP_MarkErrorStatementCreditFile executed successfully")
            if ErrorFlag == 1:
                MessageLogger.info("Error in executing USP_MarkErrorStatementCreditFile ")

            Connection.close()
        else:
            ABORT = False
            Message = 'Records mentioned in FileName matched with record present in File'
    except Exception as e:
            ABORT = True
            ErrorReason = 'Error in CheckFileName Block '
            MessageLogger.error(ErrorReason + "\n" + e)
    return ABORT, Message 

###################################################################################################################

def CheckForAnyPendingPosting(MessageLogger):
    PendingPosting = False
    PendingFile = []
    File = []
    Error = False
    Query = "EXEC " + CI_DB + "..USP_CheckForAnyPendingStatementCredit "
    MessageLogger.info(Query)

    Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)
    if ConnectionStatus:
        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except Exception as e:
            Error = True
            ErrorReason = 'Error in executing the query :: ' + Query
            MessageLogger.error(ErrorReason + "\n" + e)
        
        if RowCount > 0:
            PendingPosting = True
            for r in Row:
                File.append(r.FileName)
                File.append(r.FileID)
                PendingFile.append(File)

        Connection.close()

    return Error, PendingPosting, PendingFile


def GenerateFileEmailBody(FileId, FileName, MessageLogger):
    FileSummary = ""
    RowCount = 0
    Error = False
    RecordCount = 0
    SucessCount = 0
    ErrorCount = 0
    # print(type(FileSummary))

    Query = "SELECT 0 ErrorFlag, COUNT(1) RecordErrorCount, JobStatus, CASE WHEN JobStatus <> 0 THEN ErrorReason ELSE 'No Error' END ErrorReason " \
		    "FROM " + CI_DB + "..StatementCreditTransactionData WITH (NOLOCK) " \
		    "WHERE FileName = " + "'" + FileName + "'" + " AND FileID = " + "'" + FileId + "' "  \
		    "GROUP BY JobStatus, ErrorReason"
    
    Connection, ConnectionStatus = ConnectDB_ConnectionObject(MessageLogger)

    if ConnectionStatus:
        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except Exception as e:
            Error = True
            ErrorReason = 'Error in executing the query :: ' + Query
            MessageLogger.error(ErrorReason + "\n" + e)
        
        if RowCount > 0:
            FileSummary = FileDetails(FileName, Row, MessageLogger)

        if RowCount > 0:
            for r in Row:
                RecordCount = RecordCount + r.RecordErrorCount
                if r.JobStatus == 1:
                    SucessCount = SucessCount + r.RecordErrorCount
                else:
                    ErrorCount = ErrorCount + r.RecordErrorCount

        Connection.close()
    # print(type(FileSummary))
    return Error, FileSummary, RecordCount, SucessCount, ErrorCount

################################################################################################
################################################################################################
################################################################################################
################################################################################################
################################################################################################

InputDir, OutputDir, ErrorDir, LogDir, ResponseDir, ExpDir, ABORT = DirectoryValidation()


if ABORT is False:
    LOG_FILE = LogDir + "LOG_SCFU_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

    MessageLogger = get_logger(LOG_FILE)

    MessageLogger.info("*************************** STATEMENT CREDIT FILE PROCESSING STARTS ***************************")
    MessageLogger.info("START TIME: " + str(FileProcessingStartTime))

    printVaribales(MessageLogger)

    os.chdir(InputDir)
    FileCount = 0

    pendingJob = 0
    pendingPosting = 0 
    SuccessfullyPosted = 0
    ResponseFile = ""
    PostingEmailData = ""

    SkipImportData = False
    SkipValidation = False

    OperatingServer = GetOperatingServer(MessageLogger)

    EmailBody = EmailStructure_Head(FileProcessingStartTime, OperatingServer, MessageLogger)
    EmailSubject = EmailStructure_Subject()
    EmailTail = EmailStrucute_Tail()
    EmailStyle = EmailStructure_Style()
    EmailFooter = EmailStructure_Footer(LogDateTime)

    CurrentTime = FileProcessingStartTime.strftime("%H:%M:%S")
    IsEmptyFile = True
    FileRecordCount = 0
    
    try:
        ABORT, PendingPosting, PendingFile = CheckForAnyPendingPosting(MessageLogger)

        if ABORT is False and PendingPosting is True:
            for f in PendingFile:
                FileName = f[0]
                FileID = f[1]
                ABORT, ErrorReason = CreateStatementCreditTransaction(FileName, FileID, MessageLogger)
                if ABORT is False: 
                    ABORT, FileDetailsEmailBody, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount = GenerateFileEmailBody(FileID, FileName, MessageLogger)
                # if ABORT is False:
                #     PostingEmailData = PostingEmailData + GetPostingEmailData(FileName, FileID, pendingJob, pendingPosting, SuccessfullyPosted, MessageLogger)
                if ABORT is False:
                    PostingEmailData = PostingEmailData + FileDetailsEmailBody
                if ABORT is False:
                    ResponseFile = ResponseFile + GenerateResponseFile(FileID, FileName, ResponseDir, MessageLogger)

        if CutoffTime < CurrentTime and CheckForCutOffTime == 1:
            ABORT = True
            ErrorReason = "CutOff time Reached Utility will not process file"
            MessageLogger.info(ErrorReason)
        else:
            for File in glob.glob("*.csv"):
                FileName = File
                MessageLogger.info("FILENAME: " + FileName)
                FileNameId = str(LogDateTime.strftime("%Y%m%d%H%M%S")) + str(FileCount)
                MessageLogger.info("FileID: " + FileNameId)
                FileCount += 1
                ABORT, SkipImportData, SkipValidation, ErrorReason = FileToProcess(FileName, FileNameId, MessageLogger)

                if ABORT is False:
                    ABORT, ErrorReason =  ValidateDuplicateFile(OutputDir, FileName, MessageLogger)
                if ABORT:
                    MoveFileToLocation(InputDir, ErrorDir, FileName)
                    TotalRecords = 0
                    SuccessfulRecordsCount = 0
                    ErrorRecordCount = 0
                
                if ABORT is False:
                    ABORT, IsEmptyFile, ErrorReason, FileRecordCount = CheckEmptyFile(InputDir, FileName, MessageLogger)
                    TotalRecords = 0
                    SuccessfulRecordsCount = 0
                    ErrorRecordCount = 0
                    if ABORT:
                        MoveFileToLocation(InputDir, ErrorDir, FileName)

                if ABORT is False:
                    ABORT, ErrorReason = CheckFileName(FileName, FileRecordCount, FileNameId, MessageLogger)
                    MessageLogger.info(ErrorReason)
                    if ABORT:
                        MoveFileToLocation(InputDir, ErrorDir, FileName)
                    
                    
                if ABORT is False:
                    ABORT, ErrorReason = ImportFileToDB(InputDir, FileName, dir_path, LogDir, MessageLogger)
                    if ABORT:
                        MoveFileToLocation(InputDir, ErrorDir, FileName)
                
                if ABORT is False:
                    ABORT, ErrorFlag, ErrorReason, ExceptionFile = DataValidation(FileNameId, FileName, MessageLogger)
                    if ABORT:
                        MoveFileToLocation(InputDir, ErrorDir, FileName)
                    else:
                        MoveFileToLocation(InputDir, OutputDir, FileName)
                        
                if ABORT  is False:
                    ABORT, ErrorReason = CreateStatementCreditTransaction(FileName, FileNameId, MessageLogger)
                    # PostingEmailData = GetPostingEmailData(FileName, FileNameId, pendingJob, pendingPosting, SuccessfullyPosted, MessageLogger)
                        
                if ABORT is False:
                    ResponseFile = ResponseFile + GenerateResponseFile(FileNameId, FileName, ResponseDir, MessageLogger)
                    
                if ABORT is False: 
                    ABORT, FileDetailsEmailBody, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount = GenerateFileEmailBody(FileNameId, FileName, MessageLogger)

                if ABORT is False:
                    EmailBody = EmailBody + EmailBody_Success(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)
                else:
                    EmailBody = EmailBody + EmailBody_Error(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger)
                
                # print(type(FileDetailsRecord))
                # print(FileDetailsEmailBody)
                FileDetailsRecord = FileDetailsRecord + FileDetailsEmailBody
            
            EmailBody = EmailBody + EmailStrucute_Tail()
            EmailBody = EmailBody + FileDetailsRecord + PostingEmailData + ResponseFile

            if FileCount == 0:
                EmailBody = "<h4 style=""color:green;>Operating Sever: " + OperatingServer + "</h4>"
                EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(FileProcessingStartTime.strftime('%m/%d/%Y %H:%M:%S')) + "</h4>"
                EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(POD) + "</h4>"
                EmailBody = EmailBody + "<h3 style=""color:red;"">No file Present in Input folder</h3>"
                EmailBody = EmailBody + PostingEmailData

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

    MessageLogger.info("*************************** STATEMENT CREDIT FILE PROCESSING ENDS ***************************")