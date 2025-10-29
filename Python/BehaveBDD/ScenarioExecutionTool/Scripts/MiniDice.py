import time
import json
import pyodbc
import pandas as pd
import fnmatch
from distutils.dir_util import copy_tree, remove_tree
import os
import Scripts.Config as c
import re
import subprocess
from Scripts.GetLogger import MessageLogger
from Scripts.HelperFunction import *

from colorama import init, Fore, Back, Style

init(autoreset=True)

# RootPath  = os.environ.get('RootPath')
RootPath = c.BasePath
# Configuration =  json.load(open(RootPath+"\Configuration/Configuration.json"))
Configuration = c.Configuration
LDF_Path = Configuration['LDF_Path']
MDF_Path = Configuration['MDF_Path']
PlatformCodeloc = Configuration['PlatformCodeloc']
YourDBNames = Configuration['YourDBNames']
DBName = Configuration['DBName']
LabelDSLPath = os.path.join(Configuration["LabelPath"], Configuration["LabelName"], 'Application', 'DSL')
LabelDBPath = os.path.join(Configuration["LabelPath"], Configuration["LabelName"], 'Application', 'DB')
DBfilePath = RootPath + "\SQL"
restoreDBScript = "restoreDB.sql"
restoreDBWithBackupScript = Configuration["restoreDBWithBackupScript"]
synonymsScript = "synonyms.sql"
killqryName = "Killqyery.sql"
AddlScript = "0_t_user_details.sql"
backupLocation = Configuration['BackupScriptLocation']
backupName = Configuration['BackupName']


##################################################################################################################
def DSLCopy():
    MessageLogger.info(
        '*************************************DSL COPYING*************************************************')
    LocalDSLPath = Configuration["LocalDSLPath"]
    path = LabelDSLPath
    if os.path.exists(path):
        if os.path.exists(LocalDSLPath):
            MessageLogger.info('Deleting Existing DSLs')
            remove_tree(LocalDSLPath)
        MessageLogger.info('DSL Copying........')
        copy_tree(path, LocalDSLPath)
        MessageLogger.info(Fore.GREEN + 'DSL Copied......')
    else:
        MessageLogger.info("enter Valid Source DSL path")
    a = ''
    f1 = open(LocalDSLPath + "\CI\About.DSL")
    for line in f1:
        if 'CreditProcessing' in line:
            a = line
    f1.close()
    a = a.strip(" m_AttrGUIFieldLabel \"CreditProcessing")
    a = a.replace('" appsys30::lngDbb', '')
    MessageLogger.info("DSL Version " + a)


#############################################################################################################################
def WriteRestoreScript(Path, DBNAme, key, value, backupLocation, backupName, type):
    MessageLogger.info(Path)
    Path = os.path.join(Path, DBNAme)
    MessageLogger.info(Path)
    '''
    for i in range(3):
        killQry = "sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+killqryName+"  -o "+DBfilePath+"\\"+killqryName+".txt -b -d master\n echo %ERRORLEVEL%"
        res =  os.system(killQry)'''
    # for key , value in YourDBNames.items():
    if type == 0:
        if key == 'COREISSUE':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\CI.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'COREAUTH':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\Cauth.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'CORELIBRARY':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\CL.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'CORECREDIT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\corecredit.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'CORECOLLECT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\CC.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'COREAPP':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\CoreApp.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
            f.write(RestoreScript)
        elif key == 'CISECONDARY':
            tempp = Path.replace("\\", "/")
            backupfile = os.listdir(tempp)
            backupfile = [names.upper() for names in backupfile]
            if 'CI_SECONDARY.BAK' in backupfile:
                MessageLogger.info('Restoring ' + value)
                f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
                RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'" + value + "'\n,@BACKUP_FILE = '" + Path + "\\CI_Secondary.BAK'\n,@MDF_LOCATION = N'" + MDF_Path + "'\n,@LDF_LOCATION = N'" + LDF_Path + "'"
                f.write(RestoreScript)
    elif type == 1:
        MessageLogger.info("Try to restore with SP_RESTOREDB method")
        if key == 'COREISSUE':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CI.BAK'\n"
            f.write(RestoreScript)
        elif key == 'COREAUTH':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CAuth.BAK'\n"
            f.write(RestoreScript)
        elif key == 'CORELIBRARY':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CL.BAK'\n"
            f.write(RestoreScript)
        elif key == 'CORECREDIT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CoreCredit.BAK'\n"
            f.write(RestoreScript)
        elif key == 'CORECOLLECT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CC.BAK'\n"
            f.write(RestoreScript)
        elif key == 'COREAPP':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CoreApp.BAK'\n"
            f.write(RestoreScript)
        elif key == 'CISECONDARY':
            tempp = Path.replace("\\", "/")
            backupfile = os.listdir(tempp)
            backupfile = [names.upper() for names in backupfile]
            if 'CI_SECONDARY.BAK' in backupfile:
                MessageLogger.info('Restoring ' + value)
                f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
                RestoreScript = "Exec SP_RESTOREDB @DBNAME = N'" + value + "'\n,@BackName = '" + Path + "\\CI_Secondary.BAK'\n"
                f.write(RestoreScript)

    elif type == 2:
        MessageLogger.info("Try to restore with SP_RESTOREDB method using existing backup")
        if key == 'COREISSUE':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CI.bak'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'COREAUTH':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CAuth.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'CORELIBRARY':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CL.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'CORECREDIT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CoreCredit.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'CORECOLLECT':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CC.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'COREAPP':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CoreApp.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)
        elif key == 'CISECONDARY':
            MessageLogger.info('Restoring ' + value)
            f = open(DBfilePath + "\\" + restoreDBScript, 'w+')
            RestoreScript = f"EXEC SP_RestoreDb '{value}','{backupLocation}\\{backupName}CI_Secondary.BAK'\n"
            MessageLogger.info(f"RestoreScript: {RestoreScript}")
            f.write(RestoreScript)


#######################################################################################################################
def DBRestore():
    MessageLogger.info(
        "*************************************Database Restoration*****************************************")
    for key, value in YourDBNames.items():
        MessageLogger.info(LabelDBPath)
        WriteRestoreScript(LabelDBPath, DBName, key, value, backupLocation, backupName, 1)
        # restoreqry = f"sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+restoreDBScript+" -o "+DBfilePath+"\\"+restoreDBScript+".txt -b -d Users_Admin\n echo %ERRORLEVEL%"
        restoreqry = f'sqlcmd -S bpldevdb01 -i "{DBfilePath}\\{restoreDBScript}" -o "{DBfilePath}\\{restoreDBScript}.txt" -b -d Users_Admin\n echo %ERRORLEVEL%'

        MessageLogger.info(restoreqry)
        bproceed = True
        loopcount = 0
        while (loopcount <= 3 and bproceed == True):
            res = os.system(restoreqry)
            if res != 1:
                break
            else:
                MessageLogger.info("sleeping for 10 sec due to restore error")
                time.sleep(3)
            loopcount = loopcount + 1
            MessageLogger.info("Retry Count ", loopcount)
            if (loopcount > 3 and res == 1):
                bproceed = False

        if (bproceed == False):
            MessageLogger.info(LabelDBPath)
            WriteRestoreScript(LabelDBPath, DBName, key, value, backupLocation, backupName, 1)
            restoreqry = f"sqlcmd -S bpldevdb01 -i " + DBfilePath + "\\" + restoreDBScript + " -o " + DBfilePath + "\\" + restoreDBScript + ".txt -b -d Users_Admin\n echo %ERRORLEVEL%"
            MessageLogger.info(restoreqry)
            bproceed = True
            loopcount = 0
            while (loopcount <= 3 and bproceed == True):
                res = os.system(restoreqry)
                if res != 1:
                    break
                else:
                    MessageLogger.info("sleeping for 10 sec due to restore error")
                    time.sleep(3)
                loopcount = loopcount + 1
                MessageLogger.info("Retry Count ", loopcount)
                if (loopcount > 3 and res == 1):
                    bproceed = False
        if res == 1 and bproceed == False:
            MessageLogger.info("Error while Restoring " + value)
            exit()

    MessageLogger.info("DB Restored Successfully")
    time.sleep(5)
    # AddlQry = "sqlcmd -S bpldevdb01 -i " + DBfilePath + "\\" + AddlScript + " -o " + DBfilePath + "\\" + AddlScript + ".txt -b -d master\n echo %ERRORLEVEL%"
    AddlQry = f'sqlcmd -S bpldevdb01 -i "{DBfilePath}\\{AddlScript}" -o "{DBfilePath}\\{AddlScript}.txt" -b -d master\n echo %ERRORLEVEL%'

    res = os.system(AddlQry)
    if res == 1:
        MessageLogger.info(Fore.RED + "Error while executing AddlScript")
    else:
        MessageLogger.info(Fore.GREEN + "AddlScript Executed Successfully")
    time.sleep(5)
    # Synqry="sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+synonymsScript+" -o "+DBfilePath+"\\"+synonymsScript+".txt -b -d master\n echo %ERRORLEVEL%"
    Synqry = f'sqlcmd -S bpldevdb01 -i "{DBfilePath}\\{synonymsScript}" -o "{DBfilePath}\\{synonymsScript}.txt" -b -d master\n echo %ERRORLEVEL%'

    res = os.system(Synqry)
    if res == 1:
        MessageLogger.info(Fore.RED + "Error while executing synonyms")
    else:
        MessageLogger.info(Fore.GREEN + "Synonyms Executed Successfully")
    time.sleep(5)
    con = pyodbc.connect(Driver='{SQL Server}', Server='bpldevdb01', Database=YourDBNames['COREISSUE'],
                         Trusted_Connection='yes', autocommit=True)
    cursor = con.cursor()
    cursor.execute("select top 1 Appversion from version with(nolock) order by entryid desc")
    temp = str(cursor.fetchone()[0])
    MessageLogger.info("version " + temp)
    cursor.execute("SELECT TOP 1 CONVERT(date,tnpdate) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    MessageLogger.info('TNP Date ', tnpdate)
    tnpdate = tnpdate.split('-')
    virtualtime = tnpdate[1] + '/' + tnpdate[2] + '/' + tnpdate[0]
    TviewdateSetCmd = PlatformCodeloc + '\dt.exe -s "^VirtualTime$" "' + virtualtime + '"'
    # os.startfile(PlatformCodeloc+'\\rundbb.exe')
    time.sleep(5)
    MessageLogger.info(TviewdateSetCmd)
    os.system(TviewdateSetCmd)
    # dummy=input('Enter if date set in Tview\n')


###################################################################################################################

def DBRestoreWithBackUp():
    MessageLogger.info(
        "*************************************Database Restoration*****************************************")
    for key, value in YourDBNames.items():
        MessageLogger.info(f"Key: {key} :: Value: {value}")
        MessageLogger.info(LabelDBPath)
        WriteRestoreScript(LabelDBPath, DBName, key, value, backupLocation, backupName, 2)
        restoreqry = f'sqlcmd -S bpldevdb01 -i "{DBfilePath}\\{restoreDBScript}" -o "{DBfilePath}\\{restoreDBScript}.txt" -b -d Users_Admin\n echo %ERRORLEVEL%'
        # MessageLogger.info(restoreqry)
        bproceed = True
        loopcount = 0
        while (loopcount <= 3 and bproceed == True):
            res = os.system(restoreqry)
            if res != 1:
                break
            else:
                MessageLogger.info("sleeping for 10 sec due to restore error")
                time.sleep(3)
            loopcount = loopcount + 1
            MessageLogger.info("Retry Count ", loopcount)
            if (loopcount > 3 and res == 1):
                bproceed = False

        if (bproceed == False):
            MessageLogger.info(LabelDBPath)
            WriteRestoreScript(LabelDBPath, DBName, key, value, backupLocation, backupName, 2)
            restoreqry = f'sqlcmd -S bpldevdb01 -i "{DBfilePath}\\{restoreDBScript}" -o "{DBfilePath}\\{restoreDBScript}.txt" -b -d Users_Admin\n echo %ERRORLEVEL%'
            # MessageLogger.info(restoreqry)
            bproceed = True
            loopcount = 0
            while (loopcount <= 3 and bproceed == True):
                res = os.system(restoreqry)
                if res != 1:
                    break
                else:
                    MessageLogger.info("sleeping for 10 sec due to restore error")
                    time.sleep(3)
                loopcount = loopcount + 1
                MessageLogger.info("Retry Count ", loopcount)
                if (loopcount > 3 and res == 1):
                    bproceed = False
        if res == 1 and bproceed == False:
            MessageLogger.info("Error while Restoring " + value)
            exit()
    MessageLogger.info("DB Restored with Backup Successfully")


def UP():
    os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreIssue")
    os.startfile('1111_CI AppServer_WEB.bat')
    os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreAuth")
    os.startfile('CoreAuthAppserver.bat')
    MessageLogger.info("********************Please Check CI or CAuth Appserver************************\n")
    MessageLogger.info("ENTER 1 For Exit IF AppServer Gives Fatals")
    MessageLogger.info("ENTER 2 For UP TNP MSMQ And RetailAuth")
    temp = int(input())
    if temp == 1:
        exit()
    elif temp == 2:
        os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreIssue")
        os.startfile('2222222222222_CI TnpNad.bat')
        os.startfile('wf_MSMQ.bat')
        if (DBName.upper() != 'JAZZ' and DBName.upper() != 'JAZZ_MASTER'):
            os.startfile('_WF_RetailAuthJobs.bat')


#######################################################################################################


def fn_VerifyTracefiles(KeyWord, TraceFileLoc, TfileName, ProceesName):
    TracefileName = ''
    start_time = time.time()
    for filename in os.listdir(TraceFileLoc):
        MessageLogger.info(filename)
        if fnmatch.fnmatch(filename, f'*{TfileName}*.txt'):
            TracefileName = filename
            MessageLogger.info(TracefileName)
            fn_GetProcessIDByTraceFileName(TracefileName)
            MessageLogger.info(start_time)
            # opening CI trace file and checking for message
            process_Flag = True
            while process_Flag:
                Data_ci = open(TraceFileLoc + '\\' + TracefileName, 'r')
                ci_full_file_content = Data_ci.readlines()
                bcorrectfile = False
                for line in ci_full_file_content:
                    if "Found trace INI file at DBB_TRACE_PATH" in line and bcorrectfile is False:
                        bcorrectfile = True
                        break
                if not bcorrectfile:
                    break
                else:
                    for line in ci_full_file_content:
                        if KeyWord in line:
                            MessageLogger.info(f"\n{ProceesName} is Successfully UP")
                            # fn_GetProcessID(ci_full_file_content)
                            process_Flag = False
                            return True
                            break
                        elif 'Fatal' in line:
                            MessageLogger.info(f"\nPlease check their seems to be some fatal in {ProceesName}")
                            process_Flag = False
                            return False
                        elapsed_time = time.time() - start_time
                        if elapsed_time >= 480:
                            MessageLogger.info(time.time())
                            process_Flag = False
                            break

            if not (process_Flag):
                break


def fn_GetProcessIDByTraceFileName(TraceFileName):
    MessageLogger.info("Inside fn_GetProcessIDByTraceFileName")
    MessageLogger.info(f"FileName: {TraceFileName}")
    processID = 0
    processName = ""
    patternMatched = 0
    pattern1 = r'_([^_]+)_(\d+)_(\d+)_'
    pattern2 = r'_([^_]+)_(\d+)_'
    match = False

    if not match:
        match = re.search(pattern1, TraceFileName)
        if match:
            patternMatched = 1
    if not match:
        match = re.search(pattern2, TraceFileName)
        if match:
            patternMatched = 2
    if match:
        # MessageLogger.info(f"patternMatched: {patternMatched}")
        group = len(match.groups())
        for i in range(1, group + 1):
            # MessageLogger.info("Group loop " + str(i))
            # MessageLogger.info("match: " + str(match.group(i)))
            if i == 1:
                processName = match.group(i)
                # MessageLogger.info(f"ProcessName: {processName}")
            if i == 2 and patternMatched == 2:
                processID = match.group(i)
                # MessageLogger.info(f"processID: {processID}")
            if i == 3 and patternMatched == 1:
                processID = match.group(i)
                # MessageLogger.info(f"processID: {processID}")

    fn_SaveProcessDetails(processName, processID)




