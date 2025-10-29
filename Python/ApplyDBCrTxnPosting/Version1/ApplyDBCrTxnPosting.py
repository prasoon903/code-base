'''
=============================================
Author:         Prasoon Parashar
Create date:    07/09/2020
Description:    Apply Debit and Credit on account.
=============================================
'''

# from SetUp import SetUp
import configparser
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

'''
S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
InputDir = S1.DBCRInputFile
OutputDir = S1.DBCROutFile
ErrorDir = S1.DBCRErrorFile
LogDir = S1.DBCRLogFile
ArchiveDir = S1.DBCRArchiveFile
InstitutionID = S1.DBCRInstitutionID
MailFrom = S1.DBCRMailFrom
MailTo = S1.DBCRMailTo
SMTP_SERVER = S1.SMTP_SERVER
SMTPPORT = S1.SMTPPORT
Environment = S1.DBCREnvironment
ACMITrancode = S1.ACMITrancode
PIFTrancode = S1.PIFTrancode
ACMIRefundTrancode = S1.ACMIRefundTrancode
PIFRefundTrancode = S1.PIFRefundTrancode
ValidateBatchCount = S1.ValidateBatchCount
TranscationBatchCount = S1.TranscationBatchCount

'''

# We will use the configuration file instead of SetUp file

Config = configparser.ConfigParser()
Config.read("Config.ini")

CI_DB = Config['ApplyDBCrTxnPosting']['CI_DB']
CL_DB = Config['ApplyDBCrTxnPosting']['CL_DB']
CAuth_DB = Config['ApplyDBCrTxnPosting']['CAuth_DB']
SERVERNAME = Config['ApplyDBCrTxnPosting']['SERVERNAME']
InputDir = Config['ApplyDBCrTxnPosting']['DBCRInputFile']
OutputDir = Config['ApplyDBCrTxnPosting']['DBCROutFile']
ErrorDir = Config['ApplyDBCrTxnPosting']['DBCRErrorFile']
LogDir = Config['ApplyDBCrTxnPosting']['DBCRLogFile']
ArchiveDir = Config['ApplyDBCrTxnPosting']['DBCRArchiveFile']
InstitutionID = Config['ApplyDBCrTxnPosting']['DBCRInstitutionID']
MailFrom = Config['ApplyDBCrTxnPosting']['DBCRMailFrom']
MailTo = Config['ApplyDBCrTxnPosting']['DBCRMailTo']
SMTP_SERVER = Config['ApplyDBCrTxnPosting']['SMTP_SERVER']
SMTPPORT = Config['ApplyDBCrTxnPosting']['SMTPPORT']
Environment = Config['ApplyDBCrTxnPosting']['DBCREnvironment']
ACMITrancode = Config['ApplyDBCrTxnPosting']['ACMITrancode']
PIFTrancode = Config['ApplyDBCrTxnPosting']['PIFTrancode']
ACMIRefundTrancode = Config['ApplyDBCrTxnPosting']['ACMIRefundTrancode']
PIFRefundTrancode = Config['ApplyDBCrTxnPosting']['PIFRefundTrancode']
ValidateBatchCount = Config['ApplyDBCrTxnPosting']['ValidateBatchCount']
TranscationBatchCount = Config['ApplyDBCrTxnPosting']['TranscationBatchCount']

dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"
LOG_FILE = ""
EMailSubject = ""
EmailBody = ""
Footer = ""
ABORT = False
ProcessTheFile = False
ErrorReason = ""
OperatingServer = ""

IsFileRecordDetailsNeeded = False

# MessageLogger = logging()

FileRecordDetails = ''
ErrorMessage = ''

# MAIL PARAMETERS
Error           = 0
TotalRecords    = 0
SuccessCount    = 0
ErrorCount      = 0

ErrorReason     = ''
InProcessJobs   = 0

RecordSummary = ''
ErrorRecordDetails = ''

FORMATTER = logging.Formatter("%(asctime)s — %(thread)s — %(levelname)s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')

LogDateTime = datetime.datetime.now()

ProcessingTime  = str(LogDateTime.strftime("%Y-%m-%d %H:%M:%S"))


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


def ConnectDB():
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 13 for SQL Server}",
                            server=SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True)
        cur = con.cursor()
        Message = "Connection established"
        MessageLogger.info(Message)
    except Exception:
        MessageLogger.error("Error in connecting to the DATABASE :: ", exc_info=True)

    return cur

###################################################################################################


def GetOperatingServer():
    OperatingServer = ''
    try:
        MessageLogger.info('INSIDE GetOperatingServer BLOCK')
        RowCount = 0

        Query = "SELECT TOP 1 INFO_VALUE FROM Admin.dbo.TB_INFO WHERE INFO_KEY = 'SERVERNAME'"

        Connection = ConnectDB()
        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
        except Exception:
            Error = True
            Message = 'Error in executing the query :: ' + Query
            MessageLogger.error(Message, exc_info=True)

        if RowCount > 0:
            for r in Row:
                OperatingServer = r.INFO_VALUE

        MessageLogger.info('EXITING GetOperatingServer BLOCK')

    except Exception:
        MessageLogger.error("ERROR INSIDE GetOperatingServer BLOCK", exc_info=True)

    return OperatingServer


###################################################################################################


def DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir, ArchiveDir):
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
    elif ArchiveDir == "":
        ErrorFlag = True
        Message = "Environment variable for Archive folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = InputDir + "\\"
        OutputDir = OutputDir + "\\"
        ErrorDir = ErrorDir + "\\"
        LogDir = LogDir + "\\"
        ArchiveDir = ArchiveDir + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, ArchiveDir, ErrorFlag    

###################################################################################################

def CheckForInProcessJobs(EmailBody, FileRecordDetails):
    Error = True
    Message = ''
    RowCount = 0
    FileName = ''
    JobID = 0
    InProcessJobs = 0
    MessageLogger.info('Checking the INPROCESS jobs')

    TotalRecords = 0
    SuccessCount = 0 
    ErrorCount = 0
    ErrorMessage = ''

    MailBodyFormat = ''
    try:
        Query = "SELECT TOP 1 JobID, FileName FROM " + CI_DB + "..ExternalFileProcessing WITH (NOLOCK) WHERE JobStatus = 'INPROCESS' ORDER BY JobID ASC"

        Connection = ConnectDB()
        MessageLogger.debug(Query)

        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
        except Exception:
            Error = True
            Message = 'Error in executing the query :: ' + Query
            MessageLogger.error(Message, exc_info=True)

        if RowCount > 0:
            MessageLogger.info('Record found for INPROCESS jobs')
            for r in Row:
                InProcessJobs   = 1
                FileName        = r.FileName
                JobID           = r.JobID
                Message         = FileName

                MessageLogger.info("Records for the file to process: " + Message)

        if InProcessJobs == 1:
            # Go for processing the records
            MessageLogger.info('Processing starts for the INPROCESS jobs')
            Error, TotalRecords, SuccessCount, ErrorCount, ErrorMessage = DataValidation(FileName, JobID)

            if Error:
                MailBodyFormat = "<td style=""color:red;""><b>ERROR</b></td>"
                EmailBody = EmailBody + "<h3 style=""color:red;"">Error occured while processing INPROCESS jobs</h3>"
            else:
                MailBodyFormat = "<td style=""color:green;""><b>SUCCESS</b></td>"
                EmailBody = EmailBody + "<h3 style=""color:green;"">INPROCESS jobs has been processed</h3>"
                FileRecordDetails = FileRecordDetails + FileDetails(FileName, JobID, ErrorCount)

            EmailBody = EmailBody + \
                        "<tr>" \
                            "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                            "<td style=""color:blue;""><b>OLD<b></td>" \
                            "" + str(MailBodyFormat) + ""\
                            "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                            "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                            "<td style=""color:red;"">" + str(ErrorCount) + "</td>" \
                            "<td style=""color:green;"">" + str(ProcessingTime) + "</td>" \
                            "<td style=""color:green;"">" + str(ErrorMessage) + "</td>" \
                        "</tr>"

        MessageLogger.info('EXITING CheckForInProcessJobs BLOCK')
    except Exception:
        MessageLogger.error("ERROR INSIDE CheckForInProcessJobs BLOCK", exc_info=True)

    return InProcessJobs, EmailBody, FileRecordDetails


###################################################################################################

def FileToProcess(FileName):
    MessageLogger.info('INSIDE FileToProcess BLOCK')
    FileStatus = ''
    ErrorFlag = 0
    ProcessTheFile = False
    Message = ''
    RowCount = 0
    Error = False
    IsError = False
    FileSource = "DBCR"
    JobID = 0
    try:
        Query = "EXEC " + CI_DB + "..USP_GetStatusOfExternalFileProcessing '" + FileName + "', '" + FileSource + "'"

        Connection = ConnectDB()
        MessageLogger.debug(Query)

        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
            MessageLogger.info("Query executed successfully.")
        except Exception:
            Error = True
            MessageLogger.error('Error in executing the stored procedure USP_GetStatusOfExternalFileProcessing', exc_info=True)

        if RowCount > 0:
            for r in Row:
                ErrorFlag   = r.ErrorFlag
                FileStatus  = r.JobStatus 
                JobID       = r.JobID           

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
                elif FileStatus == 'WAIT':
                    ProcessTheFile = False
                    IsError = False
                    Message = 'Other file is being processed'
                elif FileStatus == 'DONE':
                    ProcessTheFile = False
                    IsError = True
                    Message = 'File has already been processed'

                MessageLogger.info(Message)
            else:
                Message = 'Error found in checking the status of the file'
                MessageLogger.debug(Message)

        MessageLogger.info('EXITING FileToProcess BLOCK')
    except Exception:
        MessageLogger.error("ERROR INSIDE FileToProcess BLOCK", exc_info=True)

    return IsError, JobID, ProcessTheFile, Message 


###################################################################################################


def ValidateDuplicateFile(OutputDir, FileName):
    from pathlib import Path

    ErrorReason = "No Error"
    Error = False

    try:
        MessageLogger.debug("INSIDE ValidateDuplicateFile BLOCK")

        FilePath = Path(OutputDir + FileName)
        MessageLogger.debug(FilePath)

        if FilePath.is_file():
            Error = True
            Message = "File " + FileName + " is already present in OUTPUT folder. So it can not be processed."
            ErrorReason = "Duplicate File"

            MessageLogger.info(Message)

        MessageLogger.info("EXITING ValidateDuplicateFile")
    except Exception:
        MessageLogger.error("ERROR INSIDE ValidateDuplicateFile BLOCK", exc_info=True)

    return Error, ErrorReason

###################################################################################################


def ImportFileToDB(InputDir, FileName):
    MessageLogger.info("Inserting records to the database")
    Error = True
    File = InputDir + FileName
    ErrorMessage = ''
    try:
        Query = "TRUNCATE TABLE " + CI_DB + "..Apply_DBCr_FileDump"

        Connection = ConnectDB()

        try:
            Connection.execute(Query)
            Error = False
            MessageLogger.info("TABLE TRUNCATED SUCCESSFULY")
        except Exception:
            Error = True
            MessageLogger.error("ERROR IN TRUNCATING THE TABLE, QUERY:: ", + Query, exc_info=True)

        if Error is False:
            BCP = "bcp " + CI_DB + "..Apply_DBCr_FileDump IN " + File + " -b 5000 -h TABLOCK " \
                    "-f " + dir_path + "ApplyDBCrTxnPosting.xml -e " + str(LogDir) + "Error1_in.log -o "  \
                    + str(LogDir) + "Output1_in.log -S " + SERVERNAME + " -T -t , -F 2"

            MessageLogger.debug(BCP)
            try:
                MessageLogger.info("BCP START TIME::: " + str(datetime.datetime.now()))
                subprocess.run(BCP)
                Error = False
                MessageLogger.info("BCP execution successful")
                MessageLogger.info("BCP FINISH TIME::: " + str(datetime.datetime.now()))
            except:
                Error = True
                MessageLogger.info("Error in dumping the file")

        Connection.close
    except Exception:
        MessageLogger.error("ERROR INSIDE ImportFileToDB BLOCK", exc_info=True)

    return Error, ErrorMessage

###################################################################################################

def FileDetails(FileName, JobID, ErrorCountFromExternal):
    MessageLogger.info("INSIDE FileDetails BLOCK")
    FileDetailsEmailBody = "<br> <p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"
    FileDetailsEmailBody = FileDetailsEmailBody + "<p style=""color:black;""><b>RecordSummary</b></p>"
    Count = 0
    TransactionType = ''
    Method = ''
    Success = 0
    ErrorCount = 0
    Total = 0
    Error = True
    ErrorRecordsTable = ''
    ErrorCountFromExternal = int(ErrorCountFromExternal)
    try:

        FileDetailsEmailBody = FileDetailsEmailBody + \
                                "<table>" \
                                "<tr>" \
                                    "<th><b>S.No.</b></th>" \
                                    "<th><b>TransactionType</b></th>" \
                                    "<th><b>Method</b></th>" \
                                    "<th><b>TotalCount</b></th>" \
                                    "<th><b>Success</b></th>" \
                                    "<th><b>Error</b></th>" \
                                "</tr>"

        Query_RecordSummary =   ";WITH CTE " \
                                "AS " \
                                "( " \
                                "SELECT " \
                                "    Transaction_Method AS TransactionType, Transaction_Type AS Method,  " \
                                "    CASE WHEN Reason = 'SUCCESS' THEN COUNT(1) ELSE 0 END AS Success, " \
                                "    CASE WHEN Reason <> 'SUCCESS' THEN COUNT(1) ELSE 0 END AS Error " \
                                "FROM " + CI_DB + "..Apply_DBCr_Transaction WITH (NOLOCK) " \
                                "WHERE FileName = '"+ FileName +"' " \
                                "AND JobID = " + str(JobID) + " " \
                                "GROUP BY Transaction_Method, Transaction_Type, Reason " \
                                ") " \
                                "SELECT TransactionType,  Method, SUM(Success) AS Success, SUM(Error) AS Error, SUM(Success) + SUM(Error) AS Total " \
                                "FROM CTE WITH (NOLOCK) " \
                                "GROUP BY TransactionType,  Method " \
                                "ORDER BY TransactionType,  Method"

        Connection = ConnectDB()
        MessageLogger.debug(Query_RecordSummary)

        try:
            Result = Connection.execute(Query_RecordSummary)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
        except Exception:
            Error = True
            MessageLogger.info(Query_RecordSummary)
            FileDetailsEmailBody = ""
            MessageLogger.error("Error in finding Record summary details", exc_info=True)

        if RowCount > 0:
            for r in Row:
                Count += 1
                TransactionType = r.TransactionType
                Method = r.Method
                Success = r.Success
                ErrorCount = r.Error
                Total = r.Total

                FileDetailsEmailBody = FileDetailsEmailBody + " \
                                        ""<tr>" \
                                            "<td><b>" + str(Count) + "</b></td>" \
                                            "<td>" + str(TransactionType) + "</td>" \
                                            "<td>" + str(Method) + "</td>" \
                                            "<td>" + str(Total) + "</td>" \
                                            "<td>" + str(Success) + "</td>" \
                                            "<td>" + str(ErrorCount) + "</td>" \
                                        "</tr>"

            FileDetailsEmailBody = FileDetailsEmailBody + "</table>"

            if ErrorCountFromExternal > 0:
                ErrorRecordsTable = ErrorRecordsTable + "<br>" + "<p style=""color:brown;""><b>ErrorRecords</b></p>"
                TransactionType = ''
                Method = ''
                ResponseID = ''
                Last4Pan = ''
                TransactionAmount = 0
                AccountNumber = ''
                ErrorReason = ''
                Count = 0

                ErrorRecordsTable = ErrorRecordsTable + \
                                    "<table>" \
                                    "<tr>" \
                                        "<th><b>S.No.</b></th>" \
                                        "<th><b>TransactionType</b></th>" \
                                        "<th><b>Method</b></th>" \
                                        "<th><b>ResponseID</b></th>" \
                                        "<th><b>Last4Pan</b></th>" \
                                        "<th><b>TransactionAmount</b></th>" \
                                        "<th><b>AccountNumber</b></th>" \
                                        "<th><b>ErrorReason</b></th>" \
                                    "</tr>"

                Query_ErrorRecords = "SELECT " \
                                    "    Transaction_Method AS TransactionType,  " \
                                    "    Transaction_Type AS Method,  " \
                                    "    Response_Id AS ResponseID,  " \
                                    "    Pan_Last_4_Nr AS Last4Pan, " \
                                    "    CAST(Amount AS FLOAT) AS TransactionAmount, " \
                                    "    RTRIM(AccountNumber) AS AccountNumber, " \
                                    "    Reason AS ErrorReason " \
                                    "FROM " + CI_DB + "..Apply_DBCr_Transaction WITH (NOLOCK) " \
                                    "WHERE FileName = '"+ FileName +"' " \
                                    "AND JobID = " + str(JobID) + " " \
                                    "AND JobStatus <> 3 " \
                                    "ORDER BY Transaction_Method, Transaction_Type"

                MessageLogger.debug(Query_ErrorRecords)

                RowCount = 0

                try:
                    Result = Connection.execute(Query_ErrorRecords)
                    Row = Result.fetchall()
                    RowCount = len(Row)
                    Error = False
                except Exception:
                    Error = True
                    MessageLogger.info(Query_ErrorRecords)
                    MessageLogger.error("Error in finding Error record details ", exc_info=True)

                if RowCount > 0:
                    for r in Row:
                        Count += 1
                        TransactionType = r.TransactionType
                        Method = r.Method
                        ResponseID = r.ResponseID
                        Last4Pan = r.Last4Pan
                        TransactionAmount = r.TransactionAmount
                        AccountNumber = r.AccountNumber
                        ErrorReason = r.ErrorReason

                        ErrorRecordsTable = ErrorRecordsTable + " \
                                            ""<tr>" \
                                                "<td><b>" + str(Count) + "</b></td>" \
                                                "<td>" + str(TransactionType) + "</td>" \
                                                "<td>" + str(Method) + "</td>" \
                                                "<td>" + str(ResponseID) + "</td>" \
                                                "<td>" + str(Last4Pan) + "</td>" \
                                                "<td>" + str(TransactionAmount) + "</td>" \
                                                "<td>" + str(AccountNumber) + "</td>" \
                                                "<td><b>" + str(ErrorReason) + "</b></td>" \
                                            "</tr>"

                    ErrorRecordsTable = ErrorRecordsTable + "</table>"
                else:
                    ErrorRecordsTable = ""
        else:
            FileDetailsEmailBody = ""

        FileDetailsEmailBody = FileDetailsEmailBody + ErrorRecordsTable

        Connection.close()

        MessageLogger.info("EXITING FileDetails BLOCK")

    except Exception:
        FileDetailsEmailBody = ""
        MessageLogger.error("ERROR INSIDE FileDetails BLOCK", exc_info=True)
    
    return FileDetailsEmailBody


###################################################################################################


def DataValidation(FileName, JobID):
    MessageLogger.info("Inside DataValidation for file: " + FileName)
    Error = True
    RowCount = 0
    ErrorMessage = ''
    LogMessage = ''
    ErrorReason = ''

    TotalRecords = 0
    SuccessCount = 0 
    ErrorCount = 0
    ErrorMessage = ''

    try:

        Query = "EXEC " + CI_DB + "..PR_ApplyDBCrFileProcessing " \
                "'" + str(PIFTrancode) + "', '" + str(PIFRefundTrancode) + "', " + str(ValidateBatchCount) + ", " + str(TranscationBatchCount)

        Connection = ConnectDB()
        MessageLogger.info(Query)

        try:
            MessageLogger.info("PR_ApplyDBCrFileProcessing EXECUTION START TIME::: " + str(datetime.datetime.now()))
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
            MessageLogger.info('PR_ApplyDBCrFileProcessing executed successfully')
            MessageLogger.info("PR_ApplyDBCrFileProcessing EXECUTION FINISH TIME::: " + str(datetime.datetime.now()))
        except Exception:
            Error = True
            MessageLogger.error('Exception while executing PR_ApplyDBCrFileProcessing', exc_info=True)

        if RowCount > 0:
            for r in Row:
                ErrorMessage = r.RESULT
                if ErrorMessage == 'SUCCESS':
                    Error = False
                else:
                    Error = True

            MessageLogger.info("ErrorMessage: " + ErrorMessage)

        if Error is False:
            QueryForGettingRecords = "SELECT RTRIM(JobStatus) AS JobStatus, TotalRecord, SuccesRecord, ErrorRecord, RTRIM(ErrorReason) AS ErrorReason " \
                                    "FROM " + CI_DB + "..ExternalFileProcessing WITH (NOLOCK) " \
                                    "WHERE FileName = '" + FileName + "' AND JobID = " + str(JobID)

            MessageLogger.debug(QueryForGettingRecords)
            RowCount = 0

            try:
                Result = Connection.execute(QueryForGettingRecords)
                Row = Result.fetchall()
                RowCount = len(Row)
                Error = False
            except Exception:
                Error = True
                MessageLogger.info(QueryForGettingRecords)
                MessageLogger.error('Exception while executing QueryForGettingRecords from the ExternalFileProcessing table', exc_info=True)

            if RowCount > 0:
                for r in Row:
                    JobStatus       = str(r.JobStatus)
                    TotalRecords    = str(r.TotalRecord)
                    SuccessCount    = str(r.SuccesRecord)
                    ErrorCount      = str(r.ErrorRecord)
                    ErrorReason     = str(r.ErrorReason)

                    MessageLogger.info("Criteria 1: TotalRecords != '' :: " + str(TotalRecords != ''))
                    MessageLogger.info("Criteria 2: TotalRecords > 0  :: " + str(int(TotalRecords) > 0))
                    
                    if TotalRecords != '' and int(TotalRecords) > 0:
                        ErrorReason = 'No Error'
                    else:
                        Error = True
                        ErrorReason = 'ExternalFileProcessing table has not been filled successfully'
                        ErrorMessage = ErrorReason
                        MessageLogger.info("ErrorReason:: " + ErrorReason)

                    MessageLogger.info("JobStatus:: " + JobStatus)
                    MessageLogger.info("TotalRecords:: " + TotalRecords)
                    MessageLogger.info("SuccessCount:: " + SuccessCount)
                    MessageLogger.info("ErrorCount:: " + ErrorCount)
                    MessageLogger.info("ErrorReason:: " + ErrorReason)

        else:
            ErrorMessage = "Exception while executing PR_ApplyDBCrFileProcessing"


        Connection.close()

    except Exception:
        Error = True
        ErrorReason = 'Error in validating records'
        MessageLogger.error("ERROR IN DataValidation BLOCK ", exc_info=True)


    return Error, TotalRecords, SuccessCount, ErrorCount, ErrorMessage

###################################################################################################


def SendMail(EMailSubject, EmailBody):
    try:
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
    except Exception:
        MessageLogger.error("ERROR IN SendMail BLOCK", exc_info=True)

###################################################################################################

def EmailStructure(Type, EmailBody):
    # Type: "Head" and "Tail"
    try:
        MessageLogger.info("INSIDE EmailStructure BLOCK")
        if Type == "Head":

            OperatingTime = LogDateTime.strftime('%m/%d/%Y %H:%M:%S')

            EmailBody = "<h4 style=""color:green;>Operating Server: " + OperatingServer + "</h4>"
            EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(OperatingTime) + "</h4>"
            
            EmailBody = EmailBody + \
                        "<table>" \
                            "<tr>" \
                                "<th><b>FileName</b></th>" \
                                "<th><b>FileType</b></th>" \
                                "<th><b>FileStatus</b></th>" \
                                "<th><b>TotalRecords</b></th>" \
                                "<th><b>SuccessCount</b></th>" \
                                "<th><b>ErrorCount</b></th>" \
                                "<th><b>ProcessingTime</b></th>" \
                                "<th><b>ErrorReason</b></th>" \
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

        MessageLogger.info("EXITING EmailStructure BLOCK")

    except Exception:
        MessageLogger.error("ERROR IN EmailStructure BLOCK", exc_info=True)

    return EmailBody

###################################################################################################

if __name__ == '__main__':
    Error = True


    InputDir, OutputDir, ErrorDir, LogDir, ArchiveDir, Error = DirectoryValidation(InputDir, OutputDir, ErrorDir, LogDir, ArchiveDir)

    if Error is False:
        
        LOG_FILE = LogDir + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

        MessageLogger = get_logger(LOG_FILE)

        Message = "File Processing starts ..."
        MessageLogger.info(Message)
        Message = "Start Time::: " + str(LogDateTime)
        MessageLogger.info(Message)

        OperatingServer = GetOperatingServer()

        EMailSubject = "Alert | PLAT - " + Environment + " :: Apply Debit - Credit File Processing"
        EmailBody = EmailStructure("Head", EmailBody)

        # First we have to check for INPROCESS records, if they are present we will process them only.
        InProcessJobs, EmailBody, FileRecordDetails = CheckForInProcessJobs(EmailBody, FileRecordDetails)

        Path = InputDir
        MessageLogger.info(Path)
        os.chdir(Path)

        LoopCount = 0
        JobID = 0

        for File in glob.glob("*.csv"):
            FileName = File
            Message = "********************" + FileName + "*****************************"
            MessageLogger.info(Message)
            LoopCount = LoopCount + 1

            FileNameId = str(LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
            MessageLogger.info("FileID: " + FileNameId)
            ABORT = False

            if ABORT is False:
                ABORT, ErrorMessage = ValidateDuplicateFile(OutputDir, FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage

            if ABORT is False:
                ABORT, JobID, ProcessTheFile, ErrorMessage = FileToProcess(FileName)
                if ABORT:
                    shutil.move(InputDir + FileName, ErrorDir + FileName)
                    ErrorReason = ErrorMessage
                elif ProcessTheFile is False and ABORT is False:
                    ErrorReason = ErrorMessage                

                if ABORT is False:
                    ABORT, ErrorMessage = ImportFileToDB(InputDir, FileName)
                    if ABORT:
                        shutil.move(InputDir + FileName, ErrorDir + FileName)
                        ErrorReason = ErrorMessage

                if ABORT is False:
                    ABORT, TotalRecords, SuccessCount, ErrorCount, ErrorMessage = DataValidation(FileName, JobID)
                    if ABORT:
                        shutil.move(InputDir + FileName, ErrorDir + FileName)
                        ErrorReason = ErrorMessage
                    else:
                        shutil.move(InputDir + FileName, OutputDir + FileName)
                        FileDetailsEmailBody = FileDetails(FileName, JobID, ErrorCount)
                        FileRecordDetails = FileRecordDetails + FileDetailsEmailBody
                        ErrorReason = "NO ERROR"

            if ABORT is False:
                if ProcessTheFile is False:
                    EmailBody = EmailBody + \
                                "<tr>" \
                                    "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                    "<td style=""color:blue;""><b>NEW<b></td>" \
                                    "<td style=""color:orange;""><b>WAIT</b></td>" \
                                    "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                                    "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(ErrorCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(ProcessingTime) + "</td>" \
                                    "<td style=""color:orange;"">" + str(ErrorReason) + "</td>" \
                                "</tr>"                
                else:
                    EmailBody = EmailBody + \
                                "<tr>" \
                                    "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                    "<td style=""color:blue;""><b>NEW<b></td>" \
                                    "<td style=""color:green;""><b>Success</b></td>" \
                                    "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                                    "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(ErrorCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(ProcessingTime) + "</td>" \
                                    "<td style=""color:green;"">" + str(ErrorReason) + "</td>" \
                                "</tr>"
            else:
                EmailBody = EmailBody + \
                            "<tr>" \
                                "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                "<td style=""color:blue;""><b>NEW<b></td>" \
                                "<td style=""color:red;""><b>Error</b></td>" \
                                "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                                "<td style=""color:green;"">" + str(SuccessCount) + "</td>" \
                                "<td style=""color:red;"">" + str(ErrorCount) + "</td>" \
                                "<td style=""color:green;"">" + str(ProcessingTime) + "</td>" \
                                "<td style=""color:red;"">" + str(ErrorReason) + "</td>" \
                            "</tr>"

        EmailBody = EmailBody + "</table>"
        EmailBody = EmailBody + FileRecordDetails

        if LoopCount == 0:
            if InProcessJobs == 1:
                # EmailBody = "<h4 style=""color:green;>Operating Server: " + OperatingServer + "</h4>"
                # EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(LogDateTime.strftime('%m/%d/%Y %H:%M:%S')) + "</h4><br>"
                # EmailBody = EmailBody + "<h3 style=""color:green;"">INPROCESS jobs has been processed</h3>"
                EmailBody = EmailBody + "</table>"
                EmailBody = EmailBody + FileRecordDetails
            else:
                EmailBody = "<h4 style=""color:green;>Operating Server: " + OperatingServer + "</h4>"
                EmailBody = EmailBody + "<h4 style=""color:green;>Server operating time: " + str(LogDateTime.strftime('%m/%d/%Y %H:%M:%S')) + "</h4><br>"
                EmailBody = EmailBody + "<h3 style=""color:red;"">No file Present in Input folder</h3>"

        EmailBody = EmailStructure("Tail", EmailBody)

        # MessageLogger.debug(EmailBody)
        # MessageLogger.debug(EMailSubject)

        SendMail(EMailSubject, EmailBody)

        if LoopCount == 0:
            Message = "********************" + "No file Exists... Exiting" + "*****************************"
            MessageLogger.info(Message)
        else:
            Message = "********************" + "All files processed... Exiting" + "*****************************"
            MessageLogger.info(Message)

        Message = "FINISH TIME::: " + str(datetime.datetime.now())
        MessageLogger.info(Message)

