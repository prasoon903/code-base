from logging import exception
from SetUp import SetUp
from ConnectDB import ConnectDB
import pyodbc

S1 = SetUp()

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

def BackupSQL(MessageLogger, Server, SQL):
    MessageLogger.info("BackupSQL :: TRYING TO OBTAIN THE DB CONNECTION")
    MessageLogger.info("Server: " + Server)
    # MessageLogger.info("DBName: " + DBName)
    MessageLogger.info("SQL: " + SQL)
    cursor=""
    con=""
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

def GetBackupSQL(MessageLogger, DB, BackUpName, Label, DBBackupLocation):
    BackupSql = '''BACKUP DATABASE {DB} TO  DISK = N'{DBBackupLocation}\{Label}_{BackUpName}.bak' WITH NOFORMAT, INIT,  NAME = N'{DB}-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'''

    BackupSql = BackupSql.replace("{DB}", DB)
    BackupSql = BackupSql.replace("{DBBackupLocation}", DBBackupLocation)
    BackupSql = BackupSql.replace("{Label}", Label)
    BackupSql = BackupSql.replace("{BackUpName}", BackUpName)

    MessageLogger.info("BackupSql: " + BackupSql)

    return BackupSql


#########################################################################################

def BackupDB(MessageLogger, ProcessType, Label, POD):
    MessageLogger.info("START RESTORE DB")
    try:
        if ProcessType == 1:

            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CI_DB_POD1 if POD == 1 else S1.CI_DB_POD2), "CI", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CI_SEC_DB_POD1 if POD == 1 else S1.CI_SEC_DB_POD2), "CI_Secondary", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CAuth_DB_POD1 if POD == 1 else S1.CAuth_DB_POD2), "CAuth", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CL_DB_POD1 if POD == 1 else S1.CL_DB_POD2), "CL", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CC_DB_POD1 if POD == 1 else S1.CC_DB_POD2), "CC", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CoreApp_DB_POD1 if POD == 1 else S1.CoreApp_DB_POD2), "CoreApp", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(MessageLogger, str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(MessageLogger, str(S1.CoreCredit_DB_POD1 if POD == 1 else S1.CoreCredit_DB_POD2), "CoreCredit", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))

            MessageLogger.info(":: DB BACKED UP :: ")

        elif ProcessType == 2:

            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CI_DB), "CI", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CI_SEC_DB), "CI_Secondary", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CAuth_DB), "CAuth", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CL_DB), "CL", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CC_DB), "CC", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CoreApp_DB), "CoreApp", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(MessageLogger, str(S1.JAZZ_SERVERNAME), GetBackupSQL(MessageLogger, str(S1.JAZZ_CoreCredit_DB), "CoreCredit", Label, str(S1.JAZZ_DBBackupLocation)))

            MessageLogger.info(":: DB BACKED UP :: ")

    except exception:
        MessageLogger.error("FATAL:: ", exc_info=True)

