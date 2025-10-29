import sqlite3
import pyodbc
import os
import time
import glob
import re
import shutil
from os import path
import datetime
from SetUp import SetUp
import logging
import subprocess
import binascii
import json
import xml
import requests
#import jxmlease
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
def py_Connect_SQLLite():
    conn = sqlite3.connect(Db_Path+'\\'+'OTBReleaseFile_DB.db')
    return  conn 

#---------------------------------------------------------------------------------------------------------------------------
def py_Connect_MSSQL():
    conct = pyodbc.connect(Driver='{SQL Server}',
                      Server=Mssql_server,
                      Database=Mssql_CoreIssue_DB,
                      Trusted_Connection='yes',
                      autocommit=True)
                      
    #Message = "Connection established"
    #MessageLogger.info(Message)
    return  conct 
#================================================ VARIABLES =================================================================

obj_Setup=SetUp()

IncomingDirectory=obj_Setup.OTBReleaseFileIN
Error_Dir=obj_Setup.OTBReleaseFileError
Processed_Dir=obj_Setup.OTBReleaseFileOUT
Db_Path=obj_Setup.SQLLiteOTBDBPath
OTBReleaseFileLog=obj_Setup.OTBReleaseFileLog
CI_DB = obj_Setup.CI_DB

api_url = 'http://sthakur1/CorecardServices/CorecardServices/CoreCardServices.svc/DisputeOTBRelease/'
headers = {'Content-Type': 'application/json','Accept':'application/json'}

#api_url = obj_Setup.api_url
#headers = obj_Setup.headers

Mssql_server=obj_Setup.SERVERNAME
Mssql_CoreIssue_DB=obj_Setup.CI_DB
#--------------------------------------
vr_conn=py_Connect_SQLLite()
vr_crsr=vr_conn.cursor()
#--------------------------------------
vr_conct=py_Connect_MSSQL()
vr_cursr=vr_conct.cursor()
#--------------------------------------

#vr_crsr.execute("""DELETE FROM OTBReleaseDetails_sqllite""")
#vr_crsr.execute("""DELETE FROM OTBReleaseFiles_sqllite""")

vr_conn.isolation_level = None

dtl_line=[]
Error_msg=''
msg_list=[]
dir_path = os.getcwd()
dir_path = str(dir_path) + "\\"

ts = time.time()
CURRENT_TIMESTAMP = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

#=============================================================================================================================

filenamelist=os.listdir(IncomingDirectory)

if not os.path.exists(Error_Dir):
    os.makedirs(Error_Dir)

if(not os.path.isdir(IncomingDirectory)):
    print("\nError:Invalid IncomingDirectory Not found")
    exit(1)

if(not os.path.isdir(Error_Dir)):
    print("\nError:Invalid Error_Dir Not found")
    exit(1)

if(not os.path.isdir(Db_Path)):
    print("\nError:Invalid Db_Path Not found")
    exit(1)

if(not os.path.isdir(Processed_Dir)):
    print("\nError:Invalid Processed_Dir Not found")
    exit(1)

if(not os.path.isdir(OTBReleaseFileLog)):
    print("\nError:Invalid Log_directory Not found")
    exit(1)

#-----------------------------------------------------------------------------------------------------------------------------

def fn_StatusUpdate(filename,timestamp):

    Validatin_Querry="""Select count(1) From OTBRelease_Log_sqllite Where ErrorFound='YES' 
    And Filenames='<file_Name>' and TimeStmps='<timestamp>'"""

    Validatin_Querry=Validatin_Querry.replace('<file_Name>',filename)
    Validatin_Querry=Validatin_Querry.replace('<timestamp>',timestamp)

    LOGGER.debug(Validatin_Querry)
    vr_crsr.execute(Validatin_Querry)

    FetchData=vr_crsr.fetchone()
    

    if FetchData[0] >0:
    
        LOGGER.info("................Upating OTBReleaseFiles_sqllite...............................")
        UpdateQuerry=("""UPDATE OTBReleaseDetails_sqllite SET status='<status>' WHERE Filenames ='<filename>' and TimeStmps='<CurrentTimstamp>'""" )
        UpdateQuerry=UpdateQuerry.replace('<status>','Error')
        UpdateQuerry=UpdateQuerry.replace('<filename>',filename)
        UpdateQuerry=UpdateQuerry.replace('<CurrentTimstamp>',timestamp)

        
        vr_crsr.execute(UpdateQuerry)
 #-----------------------------------------------------------------------------------------------------------------------------   
def fn_JSONCalling(Accountnumber,CaseID,url,hdr):
    LOGGER.info("Accountnumber="+Accountnumber)
    LOGGER.info("CaseID="+CaseID)
    parameters = {
    "UserID":"Platcall",
    "Password":"Test123!",
    "CardNumber":"",
    "AdminNumber":"",
    "AccountNumber":Accountnumber,
    "Source":"plat",
    "IPAddress":"",
    "CallerID":"",
    "CalledID":"",
    "RequestTime":"",
    "SessionID":"",
    "APIVersion":"",
    "ApplicationVersion":"",
    "CardIssuerReferenceData":CaseID,
    "AccountUUID":"",
    "AdminUUID":""
    }
    response = requests.post(url, headers=hdr, json=parameters)
    LOGGER.info(response.status_code)
    rspns=response.json()

    msg=rspns.get('ErrorMessage')
    ResponseCode = rspns.get('ResponseID')
    LOGGER.info(ResponseCode)
    LOGGER.info(msg)
    #vr_cursr.execute("BEGIN")
    UpdateQuery="""UPDATE OTBRleaseAPIFields SET status='DONE', ResponseID= '<ResponseCode>' WHERE FileName ='<file_Name>' and AccountNumber='<Accountnumber>' and CaseID='<CaseID>' and status='NEW' """     
    UpdateQuery=UpdateQuery.replace('<file_Name>',filename)
    UpdateQuery=UpdateQuery.replace('<Accountnumber>',Accountnumber)
    UpdateQuery=UpdateQuery.replace('<ResponseCode>',ResponseCode)
    UpdateQuery=UpdateQuery.replace('<CaseID>',CaseID)
    LOGGER.info(UpdateQuery)
    vr_cursr.execute(UpdateQuery)
    #vr_cursr.execute("COMMIT")
    
#-----------------------------------------------------------------------------------------------------------------------------

def fn_MovingfileToerror(filename):
    Filestatus_query="""Select status From OTBRleaseAPIFields  
    Where FileName='<file_Name>'
    """
    Filestatus_query=Filestatus_query.replace('<file_Name>',filename)

    LOGGER.info(Filestatus_query)
    vr_cursr.execute(Filestatus_query)

    FetchData=vr_cursr.fetchone()
    LOGGER.info(FetchData)
    
    if FetchData is not None:
        Error_msg=str(FetchData[0])
        LOGGER.info(Error_msg)
        LOGGER.info(Error_Dir+'\\'+filename)
        if (os.path.exists(Error_Dir) and Error_msg=='Error'):

            if(path.exists(Error_Dir+'\\'+filename)):
                LOGGER.warn('File alredy exists in error folder')
            else :
                shutil.move(IncomingDirectory+"\\"+filename, Error_Dir)    
                LOGGER.info('File failed one or more validations')
        else:

            if(path.exists(Processed_Dir+'\\'+filename)):
                    LOGGER.warn('File alredy exists in processed folder')
            else :
                shutil.move(IncomingDirectory+"\\"+filename, Processed_Dir) 
                LOGGER.info('File passed all the validations')

###################################################################################################
def fn_FileDataInsertion(F_name):
    Line_Count=0
    with open(IncomingDirectory+"\\"+F_name,'r') as infile:
        for line in infile:
            Line_Count=Line_Count+1
            try:
                if (Line_Count >= 2):
                    dtl_line=line.split(',')
                    dtl_line.append(Line_Count)
                    dtl_line.append(F_name)
                    dtl_line.append(CURRENT_TIMESTAMP)
                    LOGGER.info("------------------------------Insersion1-----------------------------")
                    vr_cursr.execute("INSERT INTO OTBRelease_DUMP VALUES (?,?,?,?,?)", (tuple(dtl_line)))
                    LOGGER.info("------------------------------Insersion2-----------------------------")
            except:
                pass
    #vr_crsr.execute("""INSERT INTO BulkResponseFiles_sqllite VALUES (NULL,?,?,?,?)""", (F_name,CURRENT_TIMESTAMP,Line_Count,'NEW'))
    
###################################################################################################

###################################################################################################
def fn_FileValidationForCaseID(filename):
    Line_Count=0
    s_spcall="EXEC " + CI_DB + "..USP_DumpOTBRelease '"+str(filename)+"', '" + CURRENT_TIMESTAMP + "' "
    LOGGER.info(s_spcall)
   
    vr_cursr.execute(s_spcall)     
###################################################################################################
###################################################################################################
def fn_FetchDetails(filename):
    Line_Count=0
    with open(IncomingDirectory+"\\"+filename,'r') as infile:
        for line in infile:
            Line_Count=Line_Count+1
            try:
                if (Line_Count >= 2):
                    Filestatus_query="""Select Top 1 AccountNumber,CaseID From OTBRleaseAPIFields Where FileName='<file_Name>' and Status='NEW' """
                    Filestatus_query=Filestatus_query.replace('<file_Name>',filename)
                    LOGGER.info(Filestatus_query)
                    vr_cursr.execute(Filestatus_query)
                    FetchSelectData=vr_cursr.fetchone()
                    LOGGER.info(FetchSelectData)
                    LOGGER.info("Accountnumber="+str(FetchSelectData[0]))
                    LOGGER.info("caseID="+str(FetchSelectData[1]))
                    LOGGER.info("api_url="+api_url)
                    fn_JSONCalling(str(FetchSelectData[0]),str(FetchSelectData[1]),api_url,headers)
                    #vr_cursr.execute("BEGIN")
                    #UpdateQuery="""UPDATE OTBRleaseAPIFields SET status='DONE' WHERE FileName ='<file_Name>' and AccountNumber='<FetchSelectData[0]>' and CaseID='<FetchSelectData[1]>'"""     
                    #UpdateQuery=UpdateQuery.replace('<file_Name>',filename)
                    #UpdateQuery=UpdateQuery.replace('<FetchSelectData[0]>',FetchSelectData[0])
                    #UpdateQuery=UpdateQuery.replace('<FetchSelectData[1]>',FetchSelectData[1])
                    #LOGGER.info(UpdateQuery)
                    #vr_cursr.execute(UpdateQuery)
                    #vr_cursr.execute("COMMIT")
            except:
                pass

###################################################################################################
def setup_logger(name, log_file, level=logging.INFO):
    """Function setup as many loggers as you want"""

    handler = logging.FileHandler(log_file)        
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    #logger.setLevel(level)
    logger.setLevel(level)
    console = logging.StreamHandler()
    console.setLevel(level)
    logging.getLogger('').addHandler(console)
    logger.addHandler(handler)

    return logger


vs_Log_File_Name			= 	os.path.join(  obj_Setup.OTBReleaseFileLog+"\LogFile_"+time.strftime("%Y%m%d%H%M%S")+ "." + "log")

LOGGER = setup_logger('first_logger', vs_Log_File_Name)

LOGGER.info("==================================================================================================================")
LOGGER.info("AUTHOR : Poonam Agrawal")
LOGGER.info("DESCRIPTION : This process will read and Insert OTB Release File into sql Table and then call OTB Release api.")
LOGGER.info("==================================================================================================================")

for filename in filenamelist:
    if filename.endswith('.csv'):
        LOGGER.info("Reading File "+filename)
        try:
            #vr_cursr.execute("BEGIN")
            #.................................Insert Fun Calling........................
            fn_FileDataInsertion(filename)
            #.................................Insert Fun Calling........................
            #vr_cursr.execute("COMMIT")
        except Exception as e: 
            shutil.move(IncomingDirectory+"\\"+filename, Error_Dir)    
            LOGGER.warn('ExceptioInputDirn while parsing or inserting file')
            LOGGER.info(str(e))
            
        try:
            #.............................Calling SP.........................................
            fn_FileValidationForCaseID(filename)
            #.............................Fetch CaseID and AccountNumber for API.........................................
            fn_FetchDetails(filename)
            #.............................File Status Update........................................
            fn_StatusUpdate(filename,CURRENT_TIMESTAMP)
            #.............................File moving to error Folder........................................
            fn_MovingfileToerror(filename)
        except Exception as e: 
            shutil.move(IncomingDirectory+"\\"+filename, Error_Dir)    
            LOGGER.warn('Exception while validating file')
            LOGGER.info(str(e))
        
        #.............................File moving to error Folder........................................
    else :
        LOGGER.info("Invalid file or it is directory")

LOGGER.info('\n\r$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--Execution Completed--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
