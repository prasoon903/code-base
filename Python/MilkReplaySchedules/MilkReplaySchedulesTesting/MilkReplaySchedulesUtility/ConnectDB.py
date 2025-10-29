import pyodbc
from SetUp import SetUp as S1

def ConnectDB(MessageLogger):
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 13 for SQL Server}",
                            server=S1.SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True)
        cur = con.cursor()
        MessageLogger.info("CONNECTION ESTABLISHED")
    except Exception as e:
        MessageLogger.error("ERROR IN CONNECTING TO THE DATABASE", e)

    return cur

def ConnectDB_ConnectionObject(MessageLogger):
    try:
        con = pyodbc.connect(p_str=True,
                            driver="{ODBC Driver 13 for SQL Server}",
                            server=S1.SERVERNAME,
                            Trusted_Connection='yes',
                            autocommit=True)
        
        MessageLogger.info("CONNECTION ESTABLISHED")
    except Exception as e:
        MessageLogger.error("ERROR IN CONNECTING TO THE DATABASE", e)

    return con