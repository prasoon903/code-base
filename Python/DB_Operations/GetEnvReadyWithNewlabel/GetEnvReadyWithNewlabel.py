from RestoreDB import S1
from logging import exception
import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Logger import get_logger
import datetime
import os
import shutil
from RestoreDB import RestoreDB
from GetDSLFromLabel import CopyDSLs, CopyDSLsToLocation, MoveDSLsToLocation, CopyDSLToSpecificEnv
from SettingUpDB import CallSQLScripts
from TakeBackUp import BackupDB

S1 = SetUp()

LogDateTime = datetime.datetime.now()

LOG_FILE = S1.LogDir + "\\" + "ENV_LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

MessageLogger = get_logger(LOG_FILE)

ProcessToKill = str(input("KILL rundbb.exe (Y/N): "))
if ProcessToKill.upper() == 'Y':
    CMD = "TASKKILL /F /IM rundbb.exe /T"
    subprocess.run(CMD)

ProcessToKill = 'N'
ProcessToKill = str(input("KILL DbbAppServer (Y/N): "))
if ProcessToKill.upper() == 'Y':
    CMD = "TASKKILL /F /IM DbbAppServer.exe /T"
    subprocess.run(CMD)

ProcessToKill = 'N'
ProcessToKill = str(input("KILL DBBIDE (Y/N): "))
if ProcessToKill.upper() == 'Y':
    CMD = "TASKKILL /F /IM dbbide30.exe /T"
    subprocess.run(CMD)

ProcessToKill = 'N'
ProcessToKill = str(input("KILL TView (Y/N): "))
if ProcessToKill.upper() == 'Y':
    CMD = "TASKKILL /F /IM TView.exe /T"
    subprocess.run(CMD)


if __name__ == "__main__":
    MessageLogger.info("PROCESS STARTS")

    ProcessType = 0
    POD = 0
    Label = ""
    LabelPath = ""
    Location = ""
    EnvToReady = ""
    time.sleep(1)

    try:
        while True:
            Label = str(input("ENTER LABEL: "))
            LabelPath = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + S1.DSLPathSuffix
            if os.path.isdir(LabelPath):
                MessageLogger.info("LabelPath: " + str(LabelPath))

                DBorDSL = int(input("SELECT THE OPERATION \n 1-DSL/ 2-DB/ 3-BOTH:: "))
                MessageLogger.info("SELECTED VALUE:: " + str(DBorDSL))
                while DBorDSL != 1 and DBorDSL != 2 and DBorDSL != 3:
                    MessageLogger.info("SELECTED VALUE:: " + str(DBorDSL))
                    MessageLogger.info("INVALID OPERATION SELECTED")
                    DBorDSL = int(input("TRY AGAIN, 1-DSL/ 2-DB/ 3-BOTH:: "))

                # if DBorDSL == 2 or DBorDSL == 3:
                EnvToReady = int(input("SELECT THE ENVIRONMENT TO READY \n 1-PLAT:POD1/2-PLAT:POD2/3-PLAT:BOTH/4-JAZZ/5-ALL THREE:: "))
                while EnvToReady != 1 and EnvToReady != 2 and EnvToReady != 3 and EnvToReady != 4 and EnvToReady != 5:
                    MessageLogger.info("SELECTED VALUE:: " + str(EnvToReady))
                    MessageLogger.info("INVALID ENVIRONMENT SELECTED")
                    EnvToReady = int(input("TRY AGAIN, 1-PLAT:POD1/2-PLAT:POD2/3-PLAT:BOTH/4-JAZZ/5-ALL THREE:: "))
                
                MessageLogger.info("SELECTED VALUE:: " + str(EnvToReady))

                Go = True

                if EnvToReady == 1 or EnvToReady == 3 or EnvToReady == 5 or DBorDSL == 1:                
                    if os.path.isdir(S1.EnvDSLLocation_POD1) == False:
                        MessageLogger.info("POD1 Environment is not valid: " + str(S1.EnvDSLLocation_POD1))
                        Go = False

                if EnvToReady == 2 or EnvToReady == 3 or EnvToReady == 5:                
                    if os.path.isdir(S1.EnvDSLLocation_POD1) == False:
                        MessageLogger.info("POD2 Environment is not valid: " + str(S1.EnvDSLLocation_POD2))
                        Go = False

                if EnvToReady == 4 or EnvToReady == 5:                
                    if os.path.isdir(S1.EnvDSLLocation_JAZZ) == False:
                        MessageLogger.info("JAZZ Environment is not valid: " + str(S1.EnvDSLLocation_JAZZ))
                        Go = False

                if Go:
                    if DBorDSL == 1 or DBorDSL == 3:
                        CopyDSLs(MessageLogger, Label)
                        
                        if EnvToReady == 1 or EnvToReady == 3 or EnvToReady == 5:
                            CopyDSLToSpecificEnv(MessageLogger, Label, "POD1")

                        if EnvToReady == 2 or EnvToReady == 3 or EnvToReady == 5:
                            CopyDSLToSpecificEnv(MessageLogger, Label, "POD2")

                        if EnvToReady == 4 or EnvToReady == 5:
                            CopyDSLToSpecificEnv(MessageLogger, Label, "JAZZ")

                        '''

                        if os.path.isdir(S1.DSLAdjusmentLoc) and S1.AdjustDSLs == 1:
                            shutil.copy2(S1.DSLAdjusmentLoc+"\\CI\\Client.dsl", S1.EnvDSLLocation + "\\" + Label + "\\CI")
                            shutil.copy2(S1.DSLAdjusmentLoc+"\\CAuth\\Client.dsl", S1.EnvDSLLocation + "\\" + Label + "\\CoreAuth")
                        
                        if os.path.isdir(S1.BackupLocation):
                            shutil.rmtree(S1.BackupLocation)
                        os.mkdir(S1.BackupLocation) 
                        
                        MoveDSLsToLocation(MessageLogger, S1.EnvDSLLocation+"\\CI", S1.BackupLocation)
                        MoveDSLsToLocation(MessageLogger, S1.EnvDSLLocation+"\\CoreAuth", S1.BackupLocation)
                        MoveDSLsToLocation(MessageLogger, S1.EnvDSLLocation+"\\CoreCollect", S1.BackupLocation)
                        MoveDSLsToLocation(MessageLogger, S1.EnvDSLLocation+"\\CoreApp", S1.BackupLocation)
                        MoveDSLsToLocation(MessageLogger, S1.EnvDSLLocation+"\\Modularization", S1.BackupLocation)

                        CopyDSLsToLocation(MessageLogger, S1.EnvDSLLocation + "\\" + Label, S1.EnvDSLLocation)

                        '''
                    
                    if DBorDSL == 2 or DBorDSL == 3:
                        if EnvToReady == 1 or EnvToReady == 3 or EnvToReady == 5:
                            RestoreDB(MessageLogger, S1.RestoreProcess_POD1, Label, 1, "PLAT")
                            CallSQLScripts(MessageLogger, 1, "PLAT")
                            BackupDB(MessageLogger, 1, Label, 1)

                        if EnvToReady == 2 or EnvToReady == 3 or EnvToReady == 5:
                            RestoreDB(MessageLogger, S1.RestoreProcess_POD2, Label, 2, "PLAT") 
                            CallSQLScripts(MessageLogger, 2, "PLAT")
                            BackupDB(MessageLogger, 1, Label, 2)

                        if EnvToReady == 4 or EnvToReady == 5:
                            RestoreDB(MessageLogger, S1.RestoreProcess_JAZZ, Label, 3, "JAZZ")
                            CallSQLScripts(MessageLogger, 3, "JAZZ") 
                            BackupDB(MessageLogger, 2, Label, 3)

                    Exit = str(input("PRESS ANY KEY TO EXIT: "))
                    MessageLogger.info("ALL PROCESSES DONE. EXITING...: ")

                break
            else:
                MessageLogger.info("INVALID PATH: " + str(LabelPath))
    except:
        MessageLogger.error("FATAL :: ", exc_info=True)
