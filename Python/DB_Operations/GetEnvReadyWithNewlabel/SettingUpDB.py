from logging import exception
import shutil
import os
import glob
import subprocess
from SetUp import SetUp

S1 = SetUp()

def CallSQLScripts(MessageLogger, POD, ENV):
    MessageLogger.info("Running CallSQLScripts for POD: " + str(POD))
    if ENV == "PLAT":
        FolderName = "SettingUpPOD" + str(POD)
    elif ENV == "JAZZ":
        FolderName = "SettingUp" + str(ENV)

    MessageLogger.info("FolderName: " + FolderName)

    FolderPath = S1.SQL + "\\" + FolderName
    
    Path = FolderPath
    MessageLogger.info("Path: " + Path)
    os.chdir(Path)
    '''
    Path = FolderPath + "\\execute.bat"
    print(Path)
    subprocess.run(Path)
    '''
   
    for File in glob.glob("*.sql"):
        FileName = FolderPath + "\\" + File
        FileName = File
        CMD = ""
        try:
            if S1.DefaultDB_Master == 1:
                DB = "master"
            else:
                if ENV == "PLAT":
                    DB = str(S1.CI_DB_POD1 if POD == 1 else S1.CI_DB_POD2)
                else:
                    DB = str(S1.JAZZ_CI_DB)
            
            if ENV == "PLAT":
                CMD = "sqlcmd /S " + str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2) + " /d " + DB + " -E -i " + FileName
            elif ENV == "JAZZ":
                CMD = "sqlcmd /S " + str(S1.JAZZ_SERVERNAME) + " /d " + DB + " -E -i " + FileName
                

            # CMD = "sqlcmd /s " + str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2) + " -E -i " + FileName
            MessageLogger.info("CMD: " + CMD)
            #print("CMD: ", CMD)
            subprocess.run(CMD)
            #abc= os.system(CMD)
            #print(abc)
        except Exception as e:
            MessageLogger.error(f"FATAL :: {e}")
            #print("ERROR")

    MessageLogger.info("EXITING CallSQLScripts")


def CallSQLScriptsFromFolder(MessageLogger, FolderName, SERVER, DB):
    MessageLogger.info("Running CallSQLScripts from FolderName: " + str(FolderName))


    FolderPath = S1.SQL + "\\" + FolderName
    
    Path = FolderPath
    MessageLogger.info("Path: " + Path)
    os.chdir(Path)
   
    for File in glob.glob("*.sql"):
        FileName = FolderPath + "\\" + File
        FileName = File
        try:
            #print(FileName)
            CMD = "sqlcmd /S " + str(SERVER) + " /d " + str(DB) + " -E -i " + FileName
            MessageLogger.info("CMD: " + CMD)
            subprocess.run(CMD)
        except Exception as e:
            MessageLogger.error("FATAL :: " + str(e))
    

    MessageLogger.info("EXITING CallSQLScripts")

'''
if __name__ == "__main__":
    CallSQLScripts(1)
'''
