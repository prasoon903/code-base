from logging import exception
import pyodbc
import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Logger import get_logger
import datetime
import os
from SettingUpDB import CallSQLScripts, CallSQLScriptsFromFolder

S1 = SetUp()

# LogDateTime = datetime.datetime.now()

# LOG_FILE = S1.LogDir + "\\" + "RESTORE_DB_LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

# MessageLogger = get_logger(LOG_FILE)

def Connection(MessageLogger, Server, DBName='master'):
    MessageLogger.info("ServerName: " + Server)
    MessageLogger.info("DBName: " + DBName)
    try:
        C1 = ConnectDB()
        if DBName == 'master':
            return C1.ConnectDB(Server, MessageLogger)
        else:
            return C1.ConnectServerDB(Server, DBName, MessageLogger)
    except Exception:
        MessageLogger.error("Connection not established, inside the exception block ", exc_info=True)
    

#########################################################################################

def RestoreSQL(MessageLogger, Server, DBName, SQL):
    MessageLogger.info("RestoreSQL :: TRYING TO OBTAIN THE DB CONNECTION")
    MessageLogger.info("Server: " + Server)
    MessageLogger.info("DBName: " + DBName)
    MessageLogger.info("SQL: " + SQL)
    cursor = ""
    con = ""
    try:
        con = pyodbc.connect(p_str=True,
                                driver=S1.Driver,
                                server=Server,
                                Database="master",
                                Trusted_Connection='yes',
                                autocommit=True)
        cursor = con.cursor()

        MessageLogger.info("DB CONNECTION ESTABLISHED")

        cursor.execute(SQL)
        while cursor.nextset():
            pass
    except:
        MessageLogger.error("FATAL :: ERROR IN GETTING CONNECTION", exc_info=True) 
    finally:
        cursor.commit()
        cursor.close()
        con.commit()
        con.close()

#########################################################################################

def GetEnhancedSQL(MessageLogger, DB, Path, MDF, LDF):
    MessageLogger.info("START GetEnhancedSQL DB: " + str(DB))

    Restore = """EXEC SP_RESTOREDB_Enhanced @DB_NAME = N'{DB}', @BACKUP_FILE= N'{Path}', @MDF_LOCATION = N'{MDF}', @LDF_LOCATION = N'{LDF}'"""

    MessageLogger.info("Restore: " + Restore)

    Restore = Restore.replace("{DB}", DB)
    Restore = Restore.replace("{Path}", Path)
    Restore = Restore.replace("{MDF}", MDF)
    Restore = Restore.replace("{LDF}", LDF)

    MessageLogger.info("Restore: " + Restore)

    return Restore

#########################################################################################


def GetSQL(MessageLogger, Type, DB, Path, MDF, LDF):
    MessageLogger.info("START GetEnhancedSQL DB: " + str(DB))
    SQL = ""

    if Type == 1:
        SQL = "EXEC SP_RestoreDb " + "'" + DB + "', '" + Path + "'"
    elif Type == 2:
        SQL = """EXEC SP_RESTOREDB_Enhanced @DB_NAME = N'{DB}', @BACKUP_FILE= N'{Path}', @MDF_LOCATION = N'{MDF}', @LDF_LOCATION = N'{LDF}'"""
        SQL = SQL.replace("{DB}", DB)
        SQL = SQL.replace("{Path}", Path)
        SQL = SQL.replace("{MDF}", MDF)
        SQL = SQL.replace("{LDF}", LDF)
    elif Type == 3:
        SQL = """EXEC SP_RESTOREDB_Enhanced_V4 @DB_NAME = N'{DB}', @BACKUP_FILE= N'{Path}', @MDF_LOCATION = N'{MDF}', @LDF_LOCATION = N'{LDF}'"""
        SQL = SQL.replace("{DB}", DB)
        SQL = SQL.replace("{Path}", Path)
        SQL = SQL.replace("{MDF}", MDF)
        SQL = SQL.replace("{LDF}", LDF)

    MessageLogger.info("Restore: " + SQL)

    return SQL

#########################################################################################


def RestoreDB(MessageLogger, ProcessType, Label, POD, Env):
    MessageLogger.info("START RESTORE DB")
    try:
        MDF = ""
        LDF = ""
        FolderName = ""
        SERVER = ""
        DB_PATH = ""
        CI = ""
        CI_SEC = ""
        CAuth = ""
        CC = ""
        CL = ""
        CoreApp = ""
        CoreCredit = ""

        if Env == "PLAT":
            SERVER = S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2
            MDF = S1.POD1_MDF if POD == 1 else S1.POD2_MDF
            LDF = S1.POD1_LDF if POD == 1 else S1.POD2_LDF
            # ProcessType = S1.RestoreProcess_POD1 if POD == 1 else S1.RestoreProcess_POD2
            FolderName = "SettingUpPOD" + str(POD) + "\BeforeDBRestore"
            DB_PATH = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + str(S1.LabelPathSuffix_POD1 if POD == 1 else S1.LabelPathSuffix_POD2)
            CI = str(S1.CI_DB_POD1 if POD == 1 else S1.CI_DB_POD2)
            CI_SEC = str(S1.CI_SEC_DB_POD1 if POD == 1 else S1.CI_SEC_DB_POD2)
            CAuth = str(S1.CAuth_DB_POD1 if POD == 1 else S1.CAuth_DB_POD2)
            CC = str(S1.CC_DB_POD1 if POD == 1 else S1.CC_DB_POD2)
            CL = str(S1.CL_DB_POD1 if POD == 1 else S1.CL_DB_POD1)
            CoreApp = str(S1.CoreApp_DB_POD1 if POD == 1 else S1.CoreApp_DB_POD1)
            CoreCredit = str(S1.CoreCredit_DB_POD1 if POD == 1 else S1.CoreCredit_DB_POD1)

        elif Env == "JAZZ":
            SERVER = S1.JAZZ_SERVERNAME
            MDF = S1.JAZZ_MDF
            LDF = S1.JAZZ_LDF
            # ProcessType = S1.RestoreProcess_JAZZ
            FolderName = "SettingUpJAZZ\BeforeDBRestore"
            DB_PATH = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + str(S1.JAZZ_LabelPathSuffix)
            CI = str(S1.JAZZ_CI_DB)
            CI_SEC = str(S1.JAZZ_CI_SEC_DB)
            CAuth = str(S1.JAZZ_CAuth_DB)
            CC = str(S1.JAZZ_CC_DB)
            CL = str(S1.JAZZ_CL_DB)
            CoreApp = str(S1.JAZZ_CoreApp_DB)
            CoreCredit = str(S1.JAZZ_CoreCredit_DB)

        else:
            MessageLogger.error("INVALID ENVIRONMENT")
            return

        CIDB = DB_PATH + "\\CI.bak"
        CI_SECDB = DB_PATH + "\\CI_Secondary.bak"
        CAuthDB = DB_PATH + "\\CAuth.bak"
        CCDB = DB_PATH + "\\CC.bak"
        CLDB = DB_PATH + "\\CL.bak"
        CoreAppDB = DB_PATH + "\\CoreApp.bak"
        CoreCreditDB = DB_PATH + "\\CoreCredit.bak"

        CallSQLScriptsFromFolder(MessageLogger, FolderName, SERVER, "master")

        RestoreSQL(MessageLogger, SERVER, CI, GetSQL(MessageLogger, ProcessType, CI, CIDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CI_SEC, GetSQL(MessageLogger, ProcessType, CI_SEC, CI_SECDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CAuth, GetSQL(MessageLogger, ProcessType, CAuth, CAuthDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CC, GetSQL(MessageLogger, ProcessType, CC, CCDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CL, GetSQL(MessageLogger, ProcessType, CL, CLDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CoreApp, GetSQL(MessageLogger, ProcessType, CoreApp, CoreAppDB, MDF, LDF))
        RestoreSQL(MessageLogger, SERVER, CoreCredit, GetSQL(MessageLogger, ProcessType, CoreCredit, CoreCreditDB, MDF, LDF))

        MessageLogger.info(":: DB RESTORED :: ")
    except Exception as e:
        MessageLogger.error(f"FATAL :: {e}")


def RestoreDB_v1(MessageLogger, ProcessType, Label, POD, Env):
    MessageLogger.info("START RESTORE DB")
    MDF = ""
    LDF = ""
    try:
        if Env == "PLAT":            
            Server = S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2
            MDF = S1.POD1_MDF if POD == 1 else S1.POD2_MDF
            LDF = S1.POD1_LDF if POD == 1 else S1.POD2_LDF
            FolderName = "SettingUpPOD" + str(POD) + "\BeforeDBRestore"
            CallSQLScriptsFromFolder(MessageLogger, FolderName, Server, "master")

            Path = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + str(S1.LabelPathSuffix_POD1 if POD == 1 else S1.LabelPathSuffix_POD2)

            CIDB = Path + "\\CI.bak"
            CI_SECDB = Path + "\\CI_Secondary.bak"
            CAuthDB = Path + "\\CAuth.bak"
            CCDB = Path + "\\CC.bak"
            CLDB = Path + "\\CL.bak"
            CoreAppDB = Path + "\\CoreApp.bak"
            CoreCreditDB = Path + "\\CoreCredit.bak"

            MessageLogger.info(CIDB)
            MessageLogger.info(CI_SECDB)
            MessageLogger.info(CAuthDB)
            MessageLogger.info(CCDB)
            MessageLogger.info(CLDB)
            MessageLogger.info(CoreAppDB)
            MessageLogger.info(CoreCreditDB)

            if ProcessType == 1:
                # Server = S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2
                DBName = str(S1.CI_DB_POD1 if POD == 1 else S1.CI_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CIDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.CI_SEC_DB_POD1 if POD == 1 else S1.CI_SEC_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CI_SECDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.CAuth_DB_POD1 if POD == 1 else S1.CAuth_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CAuthDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.CL_DB_POD1 if POD == 1 else S1.CL_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CLDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.CC_DB_POD1 if POD == 1 else S1.CC_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CCDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.CoreApp_DB_POD1 if POD == 1 else S1.CoreApp_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CoreAppDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)
                
                DBName = str(S1.CoreCredit_DB_POD1 if POD == 1 else S1.CoreCredit_DB_POD2)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CoreCreditDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)
                
                MessageLogger.info(":: DB RESTORED :: ")
            elif ProcessType == 2:
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CI_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CI_DB,            CIDB,             S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CI_SEC_DB,        GetEnhancedSQL(MessageLogger,   S1.JAZZ_CI_SEC_DB,        CI_SECDB,         S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CL_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CL_DB,            CLDB,             S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CAuth_DB,         GetEnhancedSQL(MessageLogger,   S1.JAZZ_CAuth_DB,         CAuthDB,          S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CC_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CC_DB,            CCDB,             S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CoreApp_DB,       GetEnhancedSQL(MessageLogger,   S1.JAZZ_CoreApp_DB,       CoreAppDB,        S1.MDF,    S1.LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CoreCredit_DB,    GetEnhancedSQL(MessageLogger,   S1.JAZZ_CoreCredit_DB,    CoreCreditDB,     S1.MDF,    S1.LDF))
            
        #JAZZ
        if Env == "JAZZ":
            CallSQLScriptsFromFolder(MessageLogger, "SettingUpJAZZ\BeforeDBRestore", S1.JAZZ_SERVERNAME, "master")

            Path = "\\\\" + S1.LabelPathPrefix + "\\" + Label + "\\" + str(S1.JAZZ_LabelPathSuffix)

            CIDB = Path + "\\CI.bak"
            CI_SECDB = Path + "\\CI_Secondary.bak"
            CAuthDB = Path + "\\CAuth.bak"
            CCDB = Path + "\\CC.bak"
            CLDB = Path + "\\CL.bak"
            CoreAppDB = Path + "\\CoreApp.bak"
            CoreCreditDB = Path + "\\CoreCredit.bak"

            MessageLogger.info(CIDB)
            MessageLogger.info(CI_SECDB)
            MessageLogger.info(CAuthDB)
            MessageLogger.info(CCDB)
            MessageLogger.info(CLDB)
            MessageLogger.info(CoreAppDB)
            MessageLogger.info(CoreCreditDB)

            if ProcessType == 2:
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CI_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CI_DB,            CIDB,             S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CI_SEC_DB,        GetEnhancedSQL(MessageLogger,   S1.JAZZ_CI_SEC_DB,        CI_SECDB,         S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CL_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CL_DB,            CLDB,             S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CAuth_DB,         GetEnhancedSQL(MessageLogger,   S1.JAZZ_CAuth_DB,         CAuthDB,          S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CC_DB,            GetEnhancedSQL(MessageLogger,   S1.JAZZ_CC_DB,            CCDB,             S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CoreApp_DB,       GetEnhancedSQL(MessageLogger,   S1.JAZZ_CoreApp_DB,       CoreAppDB,        S1.JAZZ_MDF,    S1.JAZZ_LDF))
                RestoreSQL(MessageLogger, S1.JAZZ_SERVERNAME, S1.JAZZ_CoreCredit_DB,    GetEnhancedSQL(MessageLogger,   S1.JAZZ_CoreCredit_DB,    CoreCreditDB,     S1.JAZZ_MDF,    S1.JAZZ_LDF))            
            elif ProcessType == 1:
                Server = S1.JAZZ_SERVERNAME
                DBName = str(S1.JAZZ_CI_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CIDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.JAZZ_CI_SEC_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CI_SECDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.JAZZ_CAuth_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CAuthDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.JAZZ_CL_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CLDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.JAZZ_CC_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CCDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                DBName = str(S1.JAZZ_CoreApp_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CoreAppDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)
                
                DBName = str(S1.JAZZ_CoreCredit_DB)
                Restore = "EXEC SP_RestoreDb " + "'" + DBName + "', '" + CoreCreditDB + "'"
                RestoreSQL(MessageLogger, Server, DBName, Restore)

                MessageLogger.info(":: DB RESTORED :: ")

    except exception:
        MessageLogger.error("FATAL:: ", exc_info=True)


'''
#########################################################################################

if __name__ == "__main__":
    MessageLogger.info("PROCESS STARTS")

    ProcessType = 0
    POD = 0
    Label = ""
    LabelPath = ""
    Location = ""

    try:
        while True:
            ProcessType = int(input("RESTORE FROM LABEL (1) / RESTORE FROM LOCATION (2): "))
            if ProcessType == 1 or ProcessType == 2:
                MessageLogger.info("PROCESS TO EXECUTE: " + str(ProcessType))
                if ProcessType == 1:
                    while True:
                        POD = int(input("ENTER POD (1/2): "))
                        if POD == 1 or POD == 2:
                            MessageLogger.info("POD: " + str(POD))
                            while True:
                                Label = str(input("ENTER LABEL: "))                                
                                LabelPath = "\\\\" + S1.LabelPathPrefix + "\\" + Label
                                if os.path.isdir(LabelPath):
                                    MessageLogger.info("LabelPath: " + str(LabelPath))
                                    RestoreDB(MessageLogger, ProcessType, Label, POD)
                                    break
                                else:
                                    MessageLogger.info("INVALID PATH: " + str(LabelPath))
                            break
                        else:
                            MessageLogger.info("Invalid value is passed for POD type: " + str(POD))
                else:
                    while True:
                        Location = str(input("ENTER DIRECTORY LOCATION: "))
                        if os.path.isdir(Location):
                            MessageLogger.info("Location: " + str(Location))
                            break
                        else:
                            MessageLogger.info("INVALID Location: " + str(Location))
                break
            else:
                MessageLogger.info("Invalid value is passed for ProcessType: " + str(ProcessType))
    except exception:
        MessageLogger.error("FATAL :: ", exc_info=True)

'''