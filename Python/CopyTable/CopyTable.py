import pyodbc
from ConnectDB import ConnectDB



def Connection(MessageLogger, Server, DBName='master'):
    print("ServerName: " + Server)
    print("DBName: " + DBName)
    try:
        C1 = ConnectDB()
        if DBName == 'master':
            return C1.ConnectDB(Server, MessageLogger)
        else:
            return C1.ConnectServerDB(Server, DBName, MessageLogger)
    except Exception:
        print("Connection not established, inside the exception block ", exc_info=True)


def RestoreSQL(MessageLogger, Server, DBName, SQL):
    MessageLogger.info("RestoreSQL :: TRYING TO OBTAIN THE DB CONNECTION")
    MessageLogger.info("Server: " + Server)
    MessageLogger.info("DBName: " + DBName)
    MessageLogger.info("SQL: " + SQL)
    cursor=""
    con=""
    try:
        con = pyodbc.connect(p_str=True,
                                driver="{ODBC Driver 13 for SQL Server}",
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