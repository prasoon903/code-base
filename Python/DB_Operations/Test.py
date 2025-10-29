from logging import exception
from SetUp import SetUp
from ConnectDB import ConnectDB
import pyodbc

S1 = SetUp()

def Connection(Server, DBName='master'):
    print("ServerName: " + Server)
    print("DBName: " + DBName)
    try:
        C1 = ConnectDB()
        if DBName == 'master':
            return C1.ConnectDB(Server)
        else:
            return C1.ConnectServerDB(Server, DBName)
    except Exception:
        print("Connection not established, inside the exception block ", exc_info=True)
    

#########################################################################################

def BackupSQL(Server, SQL):
    print("BackupSQL :: TRYING TO OBTAIN THE DB CONNECTION")
    print("Server: " + Server)
    # print("DBName: " + DBName)
    print("SQL: " + SQL)
    cursor=""
    con=""
    try:
        con = pyodbc.connect(p_str=True,
                                driver="{ODBC Driver 17 for SQL Server}",
                                server=Server,
                                Database="master",
                                Trusted_Connection='yes',
                                autocommit=True)
        cursor = con.cursor()

        print("DB CONNECTION ESTABLISHED")

        cursor.execute(SQL)
        while cursor.nextset():
            pass
    except:
        print("FATAL :: ERROR IN GETTING CONNECTION", exc_info=True) 
    finally:
        cursor.commit()
        cursor.close()
        con.commit()
        con.close()

#########################################################################################

def GetBackupSQL(DB, BackUpName, Label, DBBackupLocation):
    BackupSql = '''BACKUP DATABASE {DB} TO  DISK = N'{DBBackupLocation}\{Label}_{BackUpName}.bak' WITH NOFORMAT, INIT,  NAME = N'{DB}-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'''

    BackupSql = BackupSql.replace("{DB}", DB)
    BackupSql = BackupSql.replace("{DBBackupLocation}", DBBackupLocation)
    BackupSql = BackupSql.replace("{Label}", Label)
    BackupSql = BackupSql.replace("{BackUpName}", BackUpName)

    print("BackupSql: " + BackupSql)

    return BackupSql


#########################################################################################

def BackupDB(ProcessType, Label, POD):
    print("START RESTORE DB")
    try:
        if ProcessType == 1:

            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CI_DB_POD1 if POD == 1 else S1.CI_DB_POD2), "CI", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CAuth_DB_POD1 if POD == 1 else S1.CAuth_DB_POD2), "CAuth", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CL_DB_POD1 if POD == 1 else S1.CL_DB_POD2), "CL", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CC_DB_POD1 if POD == 1 else S1.CC_DB_POD2), "CC", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CoreApp_DB_POD1 if POD == 1 else S1.CoreApp_DB_POD2), "CoreApp", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))
            BackupSQL(str(S1.SERVERNAME_POD1 if POD == 1 else S1.SERVERNAME_POD2), GetBackupSQL(str(S1.CoreCredit_DB_POD1 if POD == 1 else S1.CoreCredit_DB_POD2), "CoreCredit", Label, str(S1.DBBackupLocation_POD1 if POD == 1 else S1.DBBackupLocation_POD2)))

            print(":: DB BACKED UP :: ")

        elif ProcessType == 2:

            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CI_DB), "CI", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CI_SEC_DB), "CI_Secondary", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CAuth_DB), "CAuth", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CL_DB), "CL", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CC_DB), "CC", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CoreApp_DB), "CoreApp", Label, str(S1.JAZZ_DBBackupLocation)))
            BackupSQL(str(S1.JAZZ_SERVERNAME), GetBackupSQL(str(S1.JAZZ_CoreCredit_DB), "CoreCredit", Label, str(S1.JAZZ_DBBackupLocation)))

            print(":: DB BACKED UP :: ")

    except exception:
        print("FATAL:: ", exc_info=True)



BackupDB(1, "Plat_22.10_PLAT", 1)