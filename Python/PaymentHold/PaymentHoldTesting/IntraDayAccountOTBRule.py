'''
=============================================
Author:    Prasoon Parashar
Create date:  11/16/2018
Description:  Cookie - 8808	 | Plat - Make the Payment OTB hold after the Payment variable at the Account Level.
=============================================
Modified on 04/23/2020
Label: PLAT 15.00.18
Changes: Implemented new design for this utility
=============================================
'''

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
import boto3
import base64
from botocore.exceptions import ClientError
import json


S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
InputDir = S1.POTBInputFile
OutputDir = S1.POTBOutFile
ErrorDir = S1.POTBErrorFile
LogDir = S1.POTBLogFile
InstitutionID = S1.POTBInstitutionID
MailFrom = S1.MailFrom
MailTo = S1.MailTo
SMTP_SERVER = S1.SMTP_SERVER
SMTPPORT = S1.SMTPPORT
Environment = S1.POTBEnvironment
POTBPolicy = S1.POTBPolicy
POTBIdentifier = S1.POTBIdentifier
dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"
LOG_FILE = ""
EMailSubject = ""
EmailBody = ""
Footer = ""
ABORT = False

IsFileRecordDetailsNeeded = True
if  POTBPolicy == "G2":
   IsFileRecordDetailsNeeded = False


# MessageLogger = logging()

FileRecordDetails = ''
ErrorMessage = ''

Error = 0
TotalCount = 0
SuccessCount = 0
ErrorCountForAccountFile = 0
ArchiveCount = 0
notprocessedCount = 0

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

def get_secret(): 
    MessageLogger.info("INSIDE GETTING THE AWS SECRET KEY")

    secret = dict()

    secret_name = S1.POTBAWS_secret_name
    region_name = S1.POTBAWS_region_name 

    # Create a Secrets Manager client
    try: 
        MessageLogger.info("GETTING SESSION")
        session = boto3.session.Session()
        MessageLogger.info(session)
        MessageLogger.info("GETTING CLIENT")
        client = session.client(
            service_name=S1.POTBAWS_service_name,
            region_name=region_name
        )
        MessageLogger.info(client)
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

###################################################################################################

def FileToProcess(FileName):
    FileStatus = ''
    ErrorFlag = 0
    ProcessTheFile = False
    Message = ''
    RowCount = 0
    Error = False
    IsError = False

    Query = "EXEC " + CI_DB + "..USP_GetStatusOfPaymentHoldFileProcessing '" + FileName + "'"

    Connection = ConnectDB()
    MessageLogger.debug(Query)

    try:
        Result = Connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
        Error = False
    except:
        Error = True
        Message = 'Error in executing the stored procedure USP_GetStatusOfPaymentHoldFileProcessing'
        MessageLogger.debug(Message)

    if RowCount > 0:
        for r in Row:
            ErrorFlag   = r.ErrorFlag
            FileStatus  = r.FileStatus            

        if ErrorFlag == 0:
            if FileStatus == 'NEW':
                ProcessTheFile = True
                IsError = False
                Message = 'File is in NEW state and going to process'
            elif FileStatus == 'ERROR':
                ProcessTheFile = True
                IsError = False
                Message = 'File is in ERROR state and going to process again'
            elif FileStatus == 'INPROCESS':
                ProcessTheFile = False
                IsError = True
                Message = 'File is in INPROCESS state and can not be processed again'
            elif FileStatus == 'DONE':
                ProcessTheFile = False
                IsError = True
                Message = 'File has already been processed'

            MessageLogger.info(Message)
        else:
            Message = 'Error found in checking the status of the file'
            MessageLogger.debug(Message)

    return IsError, Message 


###################################################################################################


def ValidateDuplicateFile(OutputDir, FileName):
    from pathlib import Path
    MessageLogger.debug("Inside ValidateDuplicateFile")

    FilePath = Path(OutputDir + FileName)
    MessageLogger.debug(FilePath)
    ErrorReason = "No Error"
    Error = False

    if FilePath.is_file():
        Error = True
        Message = "File " + FileName + " is already present in OUTPUT folder. So it can not be processed."
        ErrorReason = "Duplicate File"

        MessageLogger.info(ErrorReason)

    return Error, ErrorReason

###################################################################################################


def ImportFileToDB(InputDir, FileName):
    MessageLogger.debug("Inside ImportFileToDB")
    Error = True
    File = InputDir + FileName
    ErrorMessage = ''

    if POTBPolicy != "G2":
       Query = "TRUNCATE TABLE " + CI_DB + "..IntraDayAccountOTBRule_External"

    if POTBPolicy == "G2":
       Query = "TRUNCATE TABLE " + CI_DB + "..IntraDayAccountOTBRule_External_G2"

    Connection = ConnectDB()

    try:
        Connection.execute(Query)
        Error = False
    except:
        Error = True
        Message = "Error in truncating the table"

    if Error is False  and POTBPolicy != "G2":
        BCP = "bcp " + CI_DB + "..IntraDayAccountOTBRule_External IN " + File + " -b 5000 -h TABLOCK " \
                "-f " + dir_path + "IntraDayAccountOTB.xml -e " + str(LogDir) + "Error1_in.log -o "  \
                + str(LogDir) + "Output1_in.log -S " + SERVERNAME + " -T -t , -F 2"


    if Error is False and  POTBPolicy == "G2":
        BCP = "bcp " + CI_DB + "..IntraDayAccountOTBRule_External_G2 IN " + File + " -b 5000 -h TABLOCK " \
                "-f " + dir_path + "IntraDayAccountOTBRule_External_G2_n.xml -e " + str(LogDir) + "Error1_in.log -o "  \
                + str(LogDir) + "Output1_in.log -S " + SERVERNAME + " -T -t , -F 2"

    MessageLogger.info(BCP)
    MessageLogger.debug(BCP)
    try:
        subprocess.run(BCP)
        Error = False
        ErrorMessage = 'No Error'
        # Connection.commit()
    except:
        Error = True
        ErrorMessage = 'Error in dumping the file'

    Message = "Record Insert Time:::" + str(datetime.datetime.now())

    MessageLogger.info(Message)
    MessageLogger.debug("Error ===> " + str(Error))


    Connection.close

    return Error, ErrorMessage

###################################################################################################

def FileDetails(FileName):
    FileDetailsEmailBody = "<p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"
    Count = 0

    FileDetailsEmailBody = FileDetailsEmailBody + \
                            "<table>" \
                            "<tr>" \
                                "<th><b>S.No.</b></th>" \
                                "<th><b>HeldDays_LessThanIntradayThreshold</b></th>" \
                                "<th><b>HeldDays_GreaterThanIntradayThreshold</b></th>" \
                                "<th><b>RecordCount</b></th>" \
                            "</tr>"

    Query = "SELECT COUNT(1) AS RecordCount, HeldDays_LessThanIntradayThresHhold AS LessDays, " \
            "HeldDays_GreaterThanIntradayThreshhold AS GreaterDays FROM " + CI_DB + "..IntradayAccountOTBRule_Internal " \
            "WITH (NOLOCK) GROUP BY HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold, " \
            "FileName HAVING FileName = '" + FileName + "'"

    Connection = ConnectDB()
    MessageLogger.debug(Query)

    try:
        Result = Connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
        Error = False
    except:
        Error = True

    if RowCount > 0:
        for r in Row:
            Count += 1
            RecordCount = r.RecordCount
            HeldDays_LessThanIntradayThreshhold = r.LessDays
            HeldDays_GreaterThanIntradayThreshhold = r.GreaterDays

            FileDetailsEmailBody = FileDetailsEmailBody + " \
                                    ""<tr>" \
                                        "<td>" + str(Count) + "</td>" \
                                        "<td>" + str(HeldDays_LessThanIntradayThreshhold) + "</td>" \
                                        "<td>" + str(HeldDays_GreaterThanIntradayThreshhold) + "</td>" \
                                        "<td><b>" + str(RecordCount) + "</b></td>" \
                                    "</tr>"

        FileDetailsEmailBody = FileDetailsEmailBody + "</table>"
    else:
        FileDetailsEmailBody = ""

    Connection.close()
    
    return FileDetailsEmailBody


###################################################################################################


def DataValidation(FileID, FileName):
    MessageLogger.debug("Inside DataValidation")
    Error = True
    FileError = 0
    ErrorCountForAccountFile = 0
    SuccessCount = 0
    ArchiveCount = 0
    notprocessedCount = 0
    TotalCount = 0
    RowCount = 0
    InsertedRowCount = 0
    FileDetailsEmailBody = ''
    ErrorMessage = ''

    Query = "EXEC " + CI_DB + "..USP_InsertInto_IntraDayAccountOTBRule_Internal '" + FileID + "', '" + FileName + "' ,'" + str(InstitutionID) + "', '" + POTBPolicy  +  "', '" + str(POTBIdentifier) + "'"

    Connection = ConnectDB()
    MessageLogger.debug(Query)

    try:
        Result = Connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
        Error = False
    except:
        Error = True

    if RowCount > 0:
        for r in Row:
            FileError                   = r.fileerror
            ErrorCountForAccountFile    = r.ErrorCount
            SuccessCount                = r.SuccessCount
            ArchiveCount                = r.ArchiveCount
            notprocessedCount           = r.notprocessedCount
            TotalCount                  = r.TotalCount

        # FileDetailsEmailBody = FileDetails(FileName, Row)

        if FileError == 0:
            ErrorMessage = 'No Error'
            MessageLogger.info("USP_InsertInto_IntraDayAccountOTBRule_Internal executed successfully")
            Error = False
        elif FileError == 1:
            ErrorMessage = 'Error in validation'
            MessageLogger.info('ErrorFlag: ' + str(FileError) + '::' + ErrorMessage)
        elif FileError == 2:
            ErrorMessage = 'Error in making entry into PaymentHoldFileProcessing table'
            MessageLogger.info('ErrorFlag: ' + str(FileError) + '::' + ErrorMessage)
        elif FileError == 4:
            ErrorMessage = 'No record to update'
            MessageLogger.info('ErrorFlag: ' + str(FileError) + '::' + ErrorMessage)

        if SuccessCount > 0 and FileError == 0:
            Query = "EXEC " + CI_DB + "..USP_Archiveintradayaccountotbrule_Internal"

            MessageLogger.debug(Query)

            try:
                Connection.execute(Query)
                Error = False
            except:
                Error = True

            if IsFileRecordDetailsNeeded:
                FileDetailsEmailBody = FileDetails(FileName)

        elif SuccessCount <= 0:
            ErrorMessage = 'No new record to update'
            MessageLogger.info(ErrorMessage)
    else:
        Error = True
        ErrorMessage = 'Error in validating records'
        MessageLogger.info(ErrorMessage)


    Connection.close()
    return Error, FileError, ErrorMessage, TotalCount, SuccessCount, ErrorCountForAccountFile, ArchiveCount, notprocessedCount, FileDetailsEmailBody

###################################################################################################

'''
def SendMail(EMailSubject, EmailBody):
    MessageLogger.debug("Inside SendMail")
    Body = MIMEText(EmailBody, 'html')

    msg = MIMEMultipart('alternative')
    msg['Subject'] = EMailSubject
    msg['From'] = MailFrom
    msg['To'] = MailTo
    msg.attach(Body)

    server = smtplib.SMTP(SMTP_SERVER, SMTPPORT)
    # server.sendmail(self.eMailFrom, self.eMailTo, message)
    # MessageLogger.debug(EmailBody)
    Message = "Sending mail..."
    MessageLogger.info(Message)
    server.send_message(msg)
    server.quit()
'''


def SendMail(EmailSubject, EmailBody):
    try:
        if S1.POTBAWSEnvironment == 0:
            MessageLogger.debug("Inside SendMail")
            Body = MIMEText(EmailBody, 'html')

            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = S1.MailFrom
            msg['To'] = S1.MailTo
            msg.attach(Body)

            server = smtplib.SMTP(S1.SMTP_SERVER, S1.SMTPPORT)
            # server.sendmail(self.eMailFrom, self.eMailTo, message)
            Message = "SENDING MAIL ..."
            MessageLogger.info(Message)
            server.send_message(msg)
            server.quit()
        elif S1.POTBAWSEnvironment == 1:
            MessageLogger.info("INSIDE AWS SES PROCESS")

            Body = MIMEText(EmailBody, 'html')
            msg = MIMEMultipart('alternative')
            msg['Subject'] = EmailSubject
            msg['From'] = S1.MailFrom
            msg['To'] = S1.MailTo
            msg.attach(Body)

            AWSSecretKeyStr = get_secret()

            AWSSecretKey = json.loads(AWSSecretKeyStr)

            #MessageLogger.info("AWSSecretKey: ", AWSSecretKey)

            user        = AWSSecretKey.get("id")
            password    = AWSSecretKey.get("ses_smtp_password_v4")

            MessageLogger.info("user: " + user)
            MessageLogger.info("password: " + password)

            server = smtplib.SMTP(S1.POTBSES_smtp_url, S1.POTBAWSPort)
            server.set_debuglevel(1)
            server.ehlo()
            server.starttls()
            server.ehlo()
            server.login(user, password)
            server.send_message(msg)

        else:
            MessageLogger.info("INVALID ENVIRONMENT")
    except Exception as e:
        Error = True
        MessageLogger.exception("Error in sending mail ")

###################################################################################################

def EmailStructure(Type, EmailBody):
    # Type: "Head" and "Tail"
    if Type == "Head":
        # EMailSubject = "ALERT | PLAT ::: Milk Replay Schedules file processing"

        EmailBody = "<table>" \
                        "<tr>" \
                            "<th><b>FileName</b></th>" \
                            "<th><b>FileStatus</b></th>" \
                            "<th><b>TotalRecords</b></th>" \
                            "<th><b>SuccessCount</b></th>" \
                            "<th><b>ErrorCount</b></th>" \
                            "<th><b>ArchiveCount</b></th>" \
                            "<th><b>NotProcessedCount</b></th>" \
                            "<th><b>ErrorReason</b></th>" \
                            "<th><b>PolicyVersion</b></th>" \
                        "</tr>"

        # EmailBody = "<html>" + EmailBody
    elif Type == "Tail":
        currentYear = str(LogDateTime.strftime("%Y"))
        Footer = "<div class=\"footer\">" \
                    "<footer>" \
                        "<small>&copy; Copyright " + currentYear +", CoreCard Software, Inc. All rights reserved</small>" \
                    "</footer>" \
                "</div>"

        StyleBody = "<style>" \
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

        EmailBody = StyleBody + "<html>" + EmailBody + "<br>" + "<br>" + "<br>" + Footer + "</html>"

    return EmailBody

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

        EMailSubject = "Alert | PLAT - " + Environment + " :: Account Level Payment Hold File Processing"
        EmailBody = EmailStructure("Head", EmailBody)

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
                ABORT, ErrorMessage = FileToProcess(FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

            if ABORT is False:
                ABORT, ErrorReason = ValidateDuplicateFile(OutputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

            if ABORT is False:
                ABORT, ErrorMessage = ImportFileToDB(InputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

            if ABORT is False:
                ABORT, ErrorFlag, ErrorMessage, TotalCount, SuccessCount, ErrorCountForAccountFile, ArchiveCount, notprocessedCount, FileDetailsEmailBody = DataValidation(FileNameId, FileName)
                Message = "ABORT: " + str(ABORT) + '\n' + "ErrorFlag: " + str(ErrorFlag) + '\n' + "ErrorMessage: " + ErrorMessage 
                MessageLogger.debug(Message)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage
                else:
                    shutil.move(InputDir + FileName, OutputDir + FileName)
                    FileRecordDetails = FileRecordDetails + FileDetailsEmailBody
                    if ErrorFlag != 0:
                        # ABORT = True
                        ErrorReason = ErrorMessage

            if ABORT is False:
                    EmailBody = EmailBody + \
                                "<tr>" \
                                    "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                    "<td style=""color:green;""><b>Success</b></td>" \
                                    "<td style=""color:green;"">" + str(TotalCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(ErrorCountForAccountFile) + "</td>" \
                                    "<td style=""color:green;"">" + str(ArchiveCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(notprocessedCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(ErrorReason) + "</td>" \
                                    "<td style=""color:green;"">" + POTBPolicy + "</td>" \
                                "</tr>"
            else:
                EmailBody = EmailBody + \
                            "<tr>" \
                                "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                "<td style=""color:red;""><b>Error</b></td>" \
                                "<td style=""color:green;"">" + str(TotalCount) + "</td>" \
                                "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                                "<td style=""color:red;"">" + str(ErrorCountForAccountFile) + "</td>" \
                                "<td style=""color:green;"">" + str(ArchiveCount) + "</td>" \
                                "<td style=""color:red;"">" + str(notprocessedCount) + "</td>" \
                                "<td style=""color:red;"">" + str(ErrorReason) + "</td>" \
                                "<td style=""color:green;"">" + POTBPolicy + "</td>" \
                            "</tr>"

        EmailBody = EmailBody + "</table>"
        EmailBody = EmailBody + FileRecordDetails

        if LoopCount == 0:
            EmailBody = "<h3 style=""color:red;"">No file Present in Input folder</h3>"

        EmailBody = EmailStructure("Tail", EmailBody)

        # MessageLogger.debug(EmailBody)
        # MessageLogger.debug(EMailSubject)

        SendMail(EMailSubject, EmailBody)

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

