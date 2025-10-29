
import time
import json
import pyodbc
import pandas as pd
import fnmatch
from distutils.dir_util import copy_tree, remove_tree
import os

from colorama import init,Fore,Back, Style
init(autoreset=True)


Configuration =  json.load(open("Configuration/Configuration.json"))
LDF_Path = Configuration['LDF_Path']
MDF_Path = Configuration['MDF_Path']
PlatformCodeloc = Configuration['PlatformCodeloc']
YourDBNames = Configuration['YourDBNames']
DBName= Configuration['DBName']
LabelDSLPath = os.path.join(Configuration["LabelPath"],Configuration["LabelName"],'Application','DSL')
LabelDBPath = os.path.join(Configuration["LabelPath"],Configuration["LabelName"],'Application','DB')
DBfilePath = "ExecutableFunctions\sqlfiles"
restoreDBScript =  "restoreDB.sql"
synonymsScript =  "synonyms.sql"
killqryName =  "Killqyery.sql"

##################################################################################################################
def DSLCopy(): 
    print('*************************************DSL COPYING*************************************************')
    LocalDSLPath = Configuration["LocalDSLPath"] 
    path = LabelDSLPath
    if os.path.exists(path):
        if os.path.exists(LocalDSLPath):
            print('Deleting Existing DSLs')
            remove_tree(LocalDSLPath)
        print('DSL Copying........')
        copy_tree(path,LocalDSLPath)
        print(Fore.GREEN+'DSL Copied......')
    else:
        print("enter Valid Source DSL path")
    a = ''
    f1 = open(LocalDSLPath+"\CI\About.DSL")
    for line in f1:
        if 'CreditProcessing' in line:
            a = line
    f1.close()
    a=a.strip(" m_AttrGUIFieldLabel \"CreditProcessing")
    a=a.replace('" appsys30::lngDbb','')
    print("DSL Version "+a)
    
#############################################################################################################################
def WriteRestoreScript(Path,DBNAme,key,value):
    Path=os.path.join(Path,DBNAme)
    '''
    for i in range(3):
        killQry = "sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+killqryName+"  -o "+DBfilePath+"\\"+killqryName+".txt -b -d master\n echo %ERRORLEVEL%"
        res =  os.system(killQry)'''
    #for key , value in YourDBNames.items():
    if key == 'COREISSUE':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\CI.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'COREAUTH':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\Cauth.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'CORELIBRARY':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\CL.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'CORECREDIT':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\corecredit.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'CORECOLLECT':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\CC.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'COREAPP':
        print('Restoring '+value)
        f = open(DBfilePath+"\\"+restoreDBScript,'w+')
        RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\CoreApp.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
        f.write(RestoreScript)
    elif key == 'CISECONDARY': 
        tempp = Path.replace("\\","/")
        backupfile = os.listdir(tempp)
        backupfile = [names.upper() for names in backupfile]
        if 'CI_SECONDARY.BAK' in backupfile:
            print('Restoring '+value)
            f = open(DBfilePath+"\\"+restoreDBScript,'w+')
            RestoreScript = "Exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = N'"+value+"'\n,@BACKUP_FILE = '"+Path+"\\CI_Secondary.BAK'\n,@MDF_LOCATION = N'"+MDF_Path+"'\n,@LDF_LOCATION = N'"+LDF_Path+"'"
            f.write(RestoreScript)

#######################################################################################################################            
def DBRestore():
    print("*************************************Database Restoration*****************************************")
    for key , value in YourDBNames.items():
        WriteRestoreScript(LabelDBPath,DBName,key,value)
        restoreqry = f"sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+restoreDBScript+" -o "+DBfilePath+"\\"+restoreDBScript+".txt -b -d Users_Admin\n echo %ERRORLEVEL%"
        res =  os.system(restoreqry)
        if res == 1:
            print("Error while Restoring "+value)
            exit()
    print(Fore.GREEN+"DB Restored Successfully")
    time.sleep(5)
    Synqry="sqlcmd -S bpldevdb01 -i "+DBfilePath+"\\"+synonymsScript+" -o "+DBfilePath+"\\"+synonymsScript+".txt -b -d master\n echo %ERRORLEVEL%"
    res = os.system(Synqry)
    if res == 1 :
        print(Fore.RED+"Error while executing synonyms")
    else:
        print(Fore.GREEN+"Synonyms Executed Successfully")
    con = pyodbc.connect(Driver = '{SQL Server}',Server = 'bpldevdb01',Database = YourDBNames['COREISSUE'],Trusted_Connection ='yes',autocommit = True)
    cursor = con.cursor()
    cursor.execute("select top 1 Appversion from version with(nolock) order by entryid desc")
    temp = str(cursor.fetchone()[0])
    print("version "+temp)
    cursor.execute("SELECT TOP 1 CONVERT(date,tnpdate) FROM CommonTNP where atid = 60")
    tnpdate = str(cursor.fetchone()[0])
    print('TNP Date ',tnpdate)
    tnpdate = tnpdate.split('-')
    virtualtime=tnpdate[1]+'/'+tnpdate[2]+'/'+tnpdate[0]
    TviewdateSetCmd = PlatformCodeloc+'\dt.exe -s "^VirtualTime$" "'+virtualtime+'"'
    #os.startfile(PlatformCodeloc+'\\rundbb.exe')
    time.sleep(5)
    os.system(TviewdateSetCmd)
    #dummy=input('Enter if date set in Tview\n')
###################################################################################################################

def UP():
    os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreIssue")
    os.startfile('1111_CI AppServer_WEB.bat')
    os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreAuth")
    os.startfile('CoreAuthAppserver.bat')
    print("********************Please Check CI or CAuth Appserver************************\n")
    print("ENTER 1 For Exit IF AppServer Gives Fatals")
    print("ENTER 2 For UP TNP MSMQ And RetailAuth")
    temp = int(input())
    if temp == 1 :
        exit()
    elif temp == 2 :
        os.chdir("D:\OnePackageSetup\DBBSetup\BatchScripts\CoreIssue")
        os.startfile('2222222222222_CI TnpNad.bat')
        os.startfile('wf_MSMQ.bat')
        if (DBName.upper() != 'JAZZ' and DBName.upper() !='JAZZ_MASTER'):
            os.startfile('_WF_RetailAuthJobs.bat')
 #######################################################################################################

def fn_VerifyTracefiles(KeyWord,TraceFileLoc,TfileName,ProceesName):
    TracefileName = ''
    for filename in os.listdir(TraceFileLoc):
        if fnmatch.fnmatch(filename, f'*{TfileName}*.txt'):
            TracefileName = filename
    
    # opening CI trace file and checking for message
    process_Flag = True
    while(process_Flag):
        Data_ci = open (TraceFileLoc +'\\' + TracefileName,'r')
        ci_full_file_content = Data_ci.readlines() 
        for line in ci_full_file_content:
            if KeyWord in line:
                print(f"\n{ProceesName} is Successfully UP")
                process_Flag = False
                return True
                break
            elif 'Fatal' in line:
                print(f"\nPlease check their seems to be some fatal in {ProceesName}")
                process_Flag = False
                return False
                
        if not(process_Flag):
            break
        time.sleep(60)
