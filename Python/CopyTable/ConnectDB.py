from logging import exception
import pyodbc

class ConnectDB:
    # Create connection
    def ConnectDB(self, Server, MessageLogger):

        MessageLogger.info("TRYING TO OBTAIN THE DB CONNECTION")
        cur = ""
        try:
            con = pyodbc.connect(p_str=True,
                                    driver="{ODBC Driver 13 for SQL Server}",
                                    server=Server,
                                    Trusted_Connection='yes',
                                    autocommit=True,
                                    app="DB_Operations_Utility")
            cur = con.cursor()

            MessageLogger.info("DB CONNECTION ESTABLISHED")
        except exception:
            MessageLogger.error("FATAL :: ERROR IN GETTING CONNECTION", exc_info=True)        

        return cur

    def ConnectServerDB(self, Server, DBName, MessageLogger):

        MessageLogger.info("TRYING TO OBTAIN THE DB CONNECTION")
        cur = ""
        try:
            con = pyodbc.connect(p_str=True,
                                    driver="{ODBC Driver 13 for SQL Server}",
                                    server=Server,
                                    Database=DBName,
                                    Trusted_Connection='yes',
                                    autocommit=True,
                                    app="DB_Operations_Utility")
            cur = con.cursor()

            MessageLogger.info("DB CONNECTION ESTABLISHED")
        except exception:
            MessageLogger.error("FATAL :: ERROR IN GETTING CONNECTION", exc_info=True)        

        return cur