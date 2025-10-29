from logging import exception
import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Logger import get_logger
import datetime
import os
import shutil

S1 = SetUp()

LogDateTime = datetime.datetime.now()

# LOG_FILE = S1.LogDir + "\\" + "COPY_DSL_LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

# MessageLogger = get_logger(LOG_FILE)


def CopyDSLs(MessageLogger, Label):
    LabelPath = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + S1.DSLPathSuffix
    MessageLogger.info("LabelPath: " + str(LabelPath))
    PathToCopyDSL = S1.DSLCopyLocation + "\\" + Label
    MessageLogger.info("LabelPath: " + LabelPath)
    MessageLogger.info("PathToCopyDSL: " + PathToCopyDSL)

    if os.path.isdir(PathToCopyDSL):
        MessageLogger.info("Folder already exists, PathToCopyDSL: " + str(PathToCopyDSL))
        # CopyDSLsToLocation(MessageLogger, S1.DSLCopyLocation, EnvDSLLocation)
    else:
        os.mkdir(PathToCopyDSL) 
        MessageLogger.info("Directory '% s' created" % PathToCopyDSL)
        CopyDSLsToLocation(MessageLogger, LabelPath, PathToCopyDSL)


def CopyDSLsToLocation(MessageLogger, FromPath, ToPath):
    MessageLogger.info("FromPath: " + FromPath)
    MessageLogger.info("ToPath: " + ToPath)
    
    if os.path.isdir(FromPath):
        try:
            # CopyScript = "XCopy " + FromPath + " " + ToPath + " /E/H/C/I"
            CopyScript = f'XCopy "{FromPath}" "{ToPath}" /E /H /C /I'
            MessageLogger.info("CopyScript :: " + CopyScript)
            subprocess.run(CopyScript)
            # shutil.copy(FromPath, ToPath)
            MessageLogger.info("DSLs copied successfully")
        except exception:
            MessageLogger.error("FATAL :: Error in copying DSLs :: ", exc_info=True)
    else:
        MessageLogger.info(f"Directory does not exists, FromPath :: {str(FromPath)}")
    

def MoveDSLsToLocation(MessageLogger, FromPath, ToPath):
    MessageLogger.info("FromPath: " + str(FromPath))
    MessageLogger.info("ToPath: " + str(ToPath))

    if os.path.isdir(FromPath):
        try:
            # MoveScript = "move " + FromPath + " " + ToPath
            # MoveScript = "XCopy " + FromPath + " " + ToPath + " /E/H/C/I"
            # MessageLogger.info("MoveScript :: ", MoveScript)
            # subprocess.run(MoveScript)
            # Delete = "rmdir " + FromPath
            # subprocess.run(Delete)
            shutil.move(FromPath, ToPath)
            MessageLogger.info("DSLs moved successfully")
        except exception:
            MessageLogger.error("FATAL :: Error in moving DSLs :: ", exc_info=True) 
    else:
        MessageLogger.info(f"Directory does not exists, FromPath :: {str(FromPath)}")

def CopyDSLToSpecificEnv(MessageLogger, Label, Environment):
    MessageLogger.info("Environment for DSL being copied: " + Environment)

    try:
        if Environment == "POD1":  
            BackupLocation = S1.BackupLocation_POD1
            EnvDSLLocation = S1.EnvDSLLocation_POD1
        elif Environment == "POD2":  
            BackupLocation = S1.BackupLocation_POD2
            EnvDSLLocation = S1.EnvDSLLocation_POD2
        if Environment == "JAZZ":  
            BackupLocation = S1.BackupLocation_JAZZ
            EnvDSLLocation = S1.EnvDSLLocation_JAZZ
              
        if os.path.isdir(BackupLocation):
            shutil.rmtree(BackupLocation)
        os.mkdir(BackupLocation) 
        
        
        MoveDSLsToLocation(MessageLogger, EnvDSLLocation+"\\CI", BackupLocation) 
        MoveDSLsToLocation(MessageLogger, EnvDSLLocation+"\\CoreAuth", BackupLocation)
        MoveDSLsToLocation(MessageLogger, EnvDSLLocation+"\\CoreCollect", BackupLocation)
        MoveDSLsToLocation(MessageLogger, EnvDSLLocation+"\\CoreApp", BackupLocation)
        MoveDSLsToLocation(MessageLogger, EnvDSLLocation+"\\Modularization", BackupLocation)

        CopyDSLsToLocation(MessageLogger, S1.DSLCopyLocation + "\\" + Label, EnvDSLLocation)
    except exception:
        MessageLogger.error("FATAL :: Error in moving DSLs :: ", exc_info=True)   


'''
if __name__ == "__main__":
    MessageLogger.info("PROCESS STARTS")

    ProcessType = 0
    POD = 0
    Label = ""
    LabelPath = ""
    Location = ""

    try:
        if os.path.isdir(EnvDSLLocation):
            while True:
                Label = str(input("ENTER LABEL: "))
                LabelPath = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + S1.DSLPathSuffix
                if os.path.isdir(LabelPath):
                    # MessageLogger.info("LabelPath: " + str(LabelPath))
                    CopyDSLs(MessageLogger, Label)                    
                    break
                else:
                    MessageLogger.info("INVALID PATH: " + str(LabelPath))
        else:
            MessageLogger.info("Environment is not valid: " + EnvDSLLocation)
    except exception:
        MessageLogger.error("FATAL :: ", exc_info=True)

'''