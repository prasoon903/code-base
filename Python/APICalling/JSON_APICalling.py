import sqlite3
import pyodbc
import os
import time
import glob
import re
import shutil
from os import path
import datetime
import logging
import subprocess
import binascii
import json
#from SetUp import SetUp
import xml
import requests
from requests.exceptions import ConnectTimeout
from datetime import date
import pyodbc
from JSON_SetUp import JSONSetUp
import sys
sys.path.append('P:\\BatchScripts\\CoreIssue')
from SetUp import SetUp
# import jxmlease
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')


# ---------------------------------------------------------------------------------------------------------------------------
def py_Connect_MSSQL():
    conct = pyodbc.connect(Driver='{SQL Server Native Client 11.0}',
                           Server=Mssql_server,
                           Database=Mssql_CoreIssue_DB,
                           Trusted_Connection='yes',
                           autocommit=True)

    return conct


# ================================================ VARIABLES =================================================================

obj_Setup = SetUp()
obj_JSONSetup = JSONSetUp()

IncomingDirectory = obj_JSONSetup.APIJSONRequestFileIN
Error_Dir = obj_JSONSetup.APIJSONRequestFileError
Processed_Dir = obj_JSONSetup.APIJSONRequestFileOUT
APIJSONRequestFileLog = obj_JSONSetup.APIJSONRequestFileLog
CI_DB = obj_Setup.CI_DB
#JSON_Parameter = obj_Setup.JSON_Parameter
JSON_Parameter = obj_JSONSetup.JSON_Parameter


headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}

#api_url = obj_Setup.api_url
api_url = obj_JSONSetup.api_url
#headers = obj_Setup.headers

Mssql_server = obj_Setup.SERVERNAME
Mssql_CoreIssue_DB = obj_Setup.CI_DB


# --------------------------------------
vr_conct = py_Connect_MSSQL()
vr_cursr = vr_conct.cursor()
# --------------------------------------

dtl_line_File = []
dtl_line = []
Error_msg = ''
msg_list = []
dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"

ts = time.time()
CURRENT_TIMESTAMP = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
#GETDATE = date.today()

GETDATE = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
# =============================================================================================================================

filenamelist = os.listdir(IncomingDirectory)

if not os.path.exists(Error_Dir):
    os.makedirs(Error_Dir)

if (not os.path.isdir(IncomingDirectory)):
    print("\nError:Invalid IncomingDirectory Not found")
    exit(1)

if (not os.path.isdir(Error_Dir)):
    print("\nError:Invalid Error_Dir Not found")
    exit(1)

if (not os.path.isdir(Processed_Dir)):
    print("\nError:Invalid Processed_Dir Not found")
    exit(1)

if (not os.path.isdir(APIJSONRequestFileLog)):
    print("\nError:Invalid Log_directory Not found")
    exit(1)


# -----------------------------------------------------------------------------------------------------------------------------

def fn_StatusUpdate(filename, timestamp):
    LOGGER.info("******enter into status update************")
    getDateEOD = str(timestamp)
    str2 = " 23:59:59"
    getDateEOD = getDateEOD + str2
    Validatin_Querry = """Select count(1) From APIJSONRequestLog Where FileName ='<file_Name>' and 
     importdate between '<timestamp>'  and '<getDateEOD>'  and  ErrorFound = 'YES' """
    #LOGGER.debug(Validatin_Querry)
    Validatin_Querry = Validatin_Querry.replace('<file_Name>', filename)
    Validatin_Querry = Validatin_Querry.replace('<timestamp>', timestamp)
    Validatin_Querry = Validatin_Querry.replace('<getDateEOD>', getDateEOD)
    vr_cursr.execute(Validatin_Querry)
    LOGGER.info("****** fetch record *********** ")

    FetchData = vr_cursr.fetchone()
    LOGGER.info(FetchData)
    LOGGER.info(Validatin_Querry)


    if FetchData[0] > 0:
        LOGGER.info("................Upating APIJSONRequestLog...............................")
        UpdateQuerry = (
            """UPDATE APIJSONRequestLog SET APIErrorStatus ='<status>' WHERE FileName ='<filename>'  and
             importdate between '<timestamp>' and '<getDateEOD>' and ErrorFound = 'YES' """)
        UpdateQuerry = UpdateQuerry.replace('<status>', 'Error')
        UpdateQuerry = UpdateQuerry.replace('<filename>', filename)
        UpdateQuerry = UpdateQuerry.replace('<timestamp>', timestamp)
        UpdateQuerry = UpdateQuerry.replace('<getDateEOD>', getDateEOD)
        vr_cursr.execute(UpdateQuerry)
        LOGGER.info(UpdateQuerry)

    ValidatidQueryNew = """Select count(1) From APIJSONRequestLog Where FileName ='<file_Name>' and 
          importdate between '<timestamp>' and '<getDateEOD>'  and  ErrorFound = 'NO' """
    ValidatidQueryNew = ValidatidQueryNew.replace('<file_Name>', filename)
    ValidatidQueryNew = ValidatidQueryNew.replace('<timestamp>', timestamp)
    ValidatidQueryNew = ValidatidQueryNew.replace('<getDateEOD>', getDateEOD)
    vr_cursr.execute(ValidatidQueryNew)
    FetchDataNew = vr_cursr.fetchone()
    LOGGER.info(FetchDataNew)
    LOGGER.info(ValidatidQueryNew)
    if FetchDataNew[0] > 0:
        UpdateQuerryNew = (
            """UPDATE APIJSONRequestLog SET APIErrorStatus ='<status>' WHERE FileName ='<filename>' and importdate between '<timestamp>' and '<getDateEOD>'
            and ErrorFound = 'NO' """)
        UpdateQuerryNew = UpdateQuerryNew.replace('<status>', 'DONE')
        UpdateQuerryNew = UpdateQuerryNew.replace('<filename>', filename)
        UpdateQuerryNew = UpdateQuerryNew.replace('<timestamp>', timestamp)
        UpdateQuerryNew = UpdateQuerryNew.replace('<getDateEOD>', getDateEOD)
        vr_cursr.execute(UpdateQuerryNew)
        LOGGER.info(UpdateQuerryNew)


# -----------------------------------------------------------------------------------------------------------------------------
def fn_JSONCalling(Request_Parameter, url, hdr,Line_Count , GETDATE_NOW):
    LOGGER.info("Request_Parameter=" + str(Request_Parameter))
    LOGGER.info(Line_Count)
    CheckTimeOutError = 0
    Line_Count = str(Line_Count)
    getDateEOD = str(GETDATE_NOW)
    str2 = " 23:59:59"
    getDateEOD = getDateEOD + str2

    try:
        LOGGER.info("*******checking timeout**********")
        response = requests.post(url, headers=hdr, json=Request_Parameter,timeout = 5)
        LOGGER.info("*******checking timeout**********")
    except:
        CheckTimeOutError = 1
        LOGGER.info(" ********************timeout*************************")
        UpdateQuery = """UPDATE APIJSONRequestLog SET status='Error', ErrorMesssage = 'TIMEOUT', 
         ErrorFound = 'TIMEOUTError' WHERE FileName ='<file_Name>' and importdate between '<GETDATE_NOW>' and '<getDateEOD>'
          and LineNumber = '<Line_Count>' """
        UpdateQuery = UpdateQuery.replace('<file_Name>', filename)
        UpdateQuery = UpdateQuery.replace('<Line_Count>', Line_Count)
        UpdateQuery = UpdateQuery.replace('<getDateEOD>', getDateEOD)
        UpdateQuery = UpdateQuery.replace('<GETDATE_NOW>', str(GETDATE_NOW))
        LOGGER.info(UpdateQuery)
        vr_cursr.execute(UpdateQuery)

    if CheckTimeOutError == 0:
        LOGGER.info(response.status_code)
        StatusCode = response.status_code
        if StatusCode == 200:
            rspns = response.json()
            LOGGER.info(rspns)
            msg = rspns.get('ErrorMessage')
            ErrorFound = rspns.get('ErrorFound')
            ResponseCode = rspns.get('ResponseID')
            LOGGER.info(ResponseCode)
            LOGGER.info(msg)

            UpdateQuery = """UPDATE APIJSONRequestLog SET status='DONE', ResponseID= '<ResponseCode>' , ErrorMesssage = '<msg>', 
             ErrorFound = '<ErrorFound>' WHERE FileName ='<file_Name>' and importdate between '<GETDATE_NOW>' and '<getDateEOD>'
              and LineNumber = '<Line_Count>'and  status='NEW'
              """
            UpdateQuery = UpdateQuery.replace('<file_Name>', filename)
            UpdateQuery = UpdateQuery.replace('<Line_Count>', Line_Count)
            UpdateQuery = UpdateQuery.replace('<ResponseCode>', ResponseCode)
            UpdateQuery = UpdateQuery.replace('<msg>', msg)
            UpdateQuery = UpdateQuery.replace('<ErrorFound>', ErrorFound)
            UpdateQuery = UpdateQuery.replace('<getDateEOD>', getDateEOD)
            UpdateQuery = UpdateQuery.replace('<GETDATE_NOW>', str(GETDATE_NOW))
            LOGGER.info(UpdateQuery)
            vr_cursr.execute(UpdateQuery)
        else:
            UpdateQueryStatus = """UPDATE APIJSONRequestLog SET status='Error' , ErrorMesssage = 'Error', 
             ErrorFound = 'ServiceIssue' , APIErrorStatus = '<StatusCode>' WHERE FileName ='<file_Name>' 
               and importdate between '<GETDATE_NOW>' and '<getDateEOD>' and LineNumber = '<Line_Count>'and  status='NEW'"""
            UpdateQueryStatus = UpdateQueryStatus.replace('<file_Name>', filename)
            UpdateQueryStatus = UpdateQueryStatus.replace('<Line_Count>', Line_Count)
            StatusCode = str(StatusCode)
            UpdateQueryStatus = UpdateQueryStatus.replace('<StatusCode>', StatusCode)
            UpdateQueryStatus = UpdateQueryStatus.replace('<getDateEOD>', getDateEOD)
            UpdateQueryStatus = UpdateQueryStatus.replace('<GETDATE_NOW>', str(GETDATE_NOW))
            LOGGER.info(UpdateQueryStatus)
            vr_cursr.execute(UpdateQueryStatus)



# -----------------------------------------------------------------------------------------------------------------------------

#---------------------remove new line ---------------------------
def RemoveNewLine(Incorrect_Column):
    Column_New = Incorrect_Column.replace('\n', '')
    LOGGER.info(Column_New)
    LOGGER.info("**********Remove NewLine***********")
    return (Column_New)


def fn_MovingfileToerror(filename, GETDATE_NOW):
    getDateEOD = str(GETDATE_NOW)
    str2 = " 23:59:59"
    getDateEOD = getDateEOD + str2
    Filestatus_query = """Select status From APIJSONRequestLog  
    Where FileName='<file_Name>' and importdate between '<GETDATE_NOW>' and '<getDateEOD>'
    """
    Filestatus_query = Filestatus_query.replace('<file_Name>', filename)
    Filestatus_query = Filestatus_query.replace('<getDateEOD>', getDateEOD)
    Filestatus_query = Filestatus_query.replace('<GETDATE_NOW>', str(GETDATE_NOW))

    LOGGER.info(Filestatus_query)
    vr_cursr.execute(Filestatus_query)

    FetchData = vr_cursr.fetchone()
    LOGGER.info(FetchData)

    if FetchData is not None:
        Error_msg = str(FetchData[0])
        LOGGER.info(Error_msg)
        LOGGER.info(Error_Dir + '\\' + filename)
        if (path.exists(Processed_Dir + '\\' + filename)):
            LOGGER.warn('File alredy exists in processed folder')
        else:
            shutil.move(IncomingDirectory + "\\" + filename, Processed_Dir)
            LOGGER.info('File passed all the validations')

###################################################################################################
def fn_FileDataInsertion(F_name):
    IsError = 0
    Line_Count = 0
    line = 3
    try:
        with open(IncomingDirectory + "\\" + F_name, 'r') as infile:
            dtl_line_Header = infile.readline()
            LOGGER.info(dtl_line_Header.split(',')[0])
            LOGGER.info(infile)
            for line in infile:
                if IsError == 0:
                    Line_Count = Line_Count + 1
                    if (Line_Count >= 1):
                        dtl_line = line.split(',')
                        LOGGER.info(dtl_line[0])
                        if '\n' in dtl_line[0]:
                            if Line_Count ==1:
                                IsError = 1
                                LOGGER.info("********** No Data In file ***********")
                                break
                        i = -1
                        for columns in dtl_line:
                            i=i+1
                            if '\n' in dtl_line[i]:
                                dtl_line[i] = dtl_line[i].replace('\n', '')
                                LOGGER.info(dtl_line[i])
                            if ' ' in dtl_line[i]:
                                dtl_line[i] = dtl_line[i].replace(" ", '')
                                LOGGER.info(dtl_line[i])
                            if '\n' in dtl_line_Header.split(',')[i]:
                                ColumnWithNewLine = dtl_line_Header.split(',')[i]
                                ColumnWithoutNewLine = RemoveNewLine(ColumnWithNewLine)
                                LOGGER.info(ColumnWithoutNewLine)
                                JSON_Parameter[ColumnWithoutNewLine] = dtl_line[i]
                            else :
                                JSON_Parameter[dtl_line_Header.split(',')[i]] = dtl_line[i]
                        LOGGER.info(JSON_Parameter)
                        if (IsError == 0):
                            dtl_line_File = []
                            dtl_line_File.append(F_name)
                            dtl_line_File.append(Line_Count)
                            dtl_line_File.append("NEW")
                            currentDT = datetime.datetime.now()
                            dtl_line_File.append(currentDT)
                            Request = json.dumps(JSON_Parameter)
                            dtl_line_File.append(Request)
                            Tup_dtl_line = tuple(dtl_line_File)
                            LOGGER.info(Tup_dtl_line)
                            LOGGER.info("------------------------------Insersion1-----------------------------")
                            vr_cursr.execute("INSERT INTO APIJSONRequestLog (FileName,LineNumber,Status,ImportDate,Request) VALUES (?,?,?,?,?)", (tuple(dtl_line_File)))
                            LOGGER.info("------------------------------Insersion2-----------------------------")
                            JSON_Rqst = json.loads(Request)
                            fn_JSONCalling(JSON_Rqst, api_url, headers,Line_Count,GETDATE)

        if (IsError == 1 or Line_Count < 1):
            infile.close()
            shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
            LOGGER.warning('File Move to error folder no record exists')
            IsError = 1

        return (IsError)
    except:
        pass


###########################DuplicateFileCheck###############################################
def fn_CheckDuplicateFileName(F_name, GETDATE_NOW):
    IsError = 0
    getDateEOD = str(GETDATE_NOW)
    str2 = " 23:59:59"
    getDateEOD = getDateEOD + str2

    DuplicateCheckQuery = (
        """SELECT COUNT(1) FROM APIJSONRequestLog  WITH (NOLOCK) WHERE  FileName = '<F_name>' AND importdate between '<GETDATE_NOW>'
         and '<getDateEOD>'""")
    DuplicateCheckQuery = DuplicateCheckQuery.replace('<F_name>', filename)
    DuplicateCheckQuery = DuplicateCheckQuery.replace('<GETDATE_NOW>', str(GETDATE_NOW))
    DuplicateCheckQuery = DuplicateCheckQuery.replace('<getDateEOD>', getDateEOD)
    vr_cursr.execute(DuplicateCheckQuery)
    row = vr_cursr.fetchone()
    LOGGER.info(DuplicateCheckQuery)
    row_tuple = tuple(row)
    LOGGER.info(row_tuple)
    LOGGER.info(row_tuple[0])
    if (row_tuple[0] >= 1):
        shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
        LOGGER.warning('File Move to error folder Duplicate File ')
        IsError = 1
    return (IsError)



############################check valid File####################################


def fn_CheckFileIsValidOrNot(F_name):
    IsError = 0
    with open(IncomingDirectory + "\\" + F_name, 'r') as infile:
        lineList = infile.readlines()
        infile.close()
        LOGGER.info(lineList[0])
        LOGGER.info("The last line is:")
        LOGGER.info(lineList[len(lineList) - 1])
        if ('\n' in lineList[len(lineList) - 1]):
            shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
            LOGGER.info("********Invalid File  move to error folder **********")
            IsError = 1
        else :
            with open(IncomingDirectory + "\\" + F_name, 'r') as infile:
                Line_CountNew = 0
                dtl_line_HeaderNew = infile.readline()
                dtl_line_HeaderNew = dtl_line_HeaderNew.split(',')
                checkHeaderCount = 0
                for columnsheader in dtl_line_HeaderNew:
                    checkHeaderCount = checkHeaderCount+1
                LOGGER.info(infile)
                LOGGER.info("***checking checkHeaderCount********")
                LOGGER.info(checkHeaderCount)
                for lineNew in infile:
                    if IsError == 0:
                        Line_CountNew = Line_CountNew + 1
                        if (Line_CountNew >= 1):
                            dtl_lineNew = lineNew.split(',')
                            checkLineColumnCount = 0
                            for columnsnew in dtl_lineNew:
                                checkLineColumnCount = checkLineColumnCount + 1
                            LOGGER.info("***checking checkLineColumnCount********")
                            LOGGER.info(checkLineColumnCount)
                            if checkLineColumnCount != checkHeaderCount:
                                infile.close()
                                shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
                                LOGGER.info("********Invalid File  move to error folder **********")
                                IsError = 1
                                break


    return (IsError)


###################################################################################################
def setup_logger(name, log_file, level=logging.INFO):
    """Function setup as many loggers as you want"""

    handler = logging.FileHandler(log_file)
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    # logger.setLevel(level)
    logger.setLevel(level)
    console = logging.StreamHandler()
    console.setLevel(level)
    logging.getLogger('').addHandler(console)
    logger.addHandler(handler)

    return logger


vs_Log_File_Name = os.path.join(obj_JSONSetup.APIJSONRequestFileLog + "\LogFile_" + time.strftime("%Y%m%d%H%M%S") + "." + "log")

LOGGER = setup_logger('first_logger', vs_Log_File_Name)

LOGGER.info(
    "==================================================================================================================")
LOGGER.info("AUTHOR :   Neha Vishwakarma")
LOGGER.info("Reviewer : Poonam Agrawal Mam / Jinendra Sir ")
LOGGER.info(
    "DESCRIPTION : This process will read and Insert request of all apis in  sql Table and then call particular API"
    "By making their JSON Request ")
LOGGER.info(
    "==================================================================================================================")
IsError = 0
for filename in filenamelist:
    if filename.endswith('.csv'):
        LOGGER.info("Reading File " + filename)
        try:
            LOGGER.info(GETDATE)
            LOGGER.info(JSON_Parameter)
            LOGGER.info(api_url)
            # ..............................DuplicateFileCheck...........................
            IsError = fn_CheckDuplicateFileName(filename, GETDATE)
            LOGGER.info(IsError)
            if (IsError == 0):
            # .................................Insert Fun Calling........................
                IsError = fn_CheckFileIsValidOrNot(filename)
                LOGGER.info(IsError)
            if (IsError == 0):
                IsError = fn_FileDataInsertion(filename)
            # .................................Insert Fun Calling........................
        except Exception as e:
            shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
            LOGGER.warn('ExceptioInputDirn while parsing or inserting file')
            LOGGER.info(str(e))

        LOGGER.info(IsError)
        try:
            # .............................Calling SP.........................................
            if (IsError == 0):
                # .............................File Status Update..............................
                fn_StatusUpdate(filename, GETDATE)
                # .............................File moving to error Folder......................
                fn_MovingfileToerror(filename, GETDATE)
        except Exception as e:
            shutil.move(IncomingDirectory + "\\" + filename, Error_Dir)
            LOGGER.warn('Exception while validating file')
            LOGGER.info(str(e))

        # .............................File moving to error Folder........................................
    else:
        LOGGER.info("Invalid file or it is directory")

LOGGER.info('\n\r$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--Execution Completed--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')