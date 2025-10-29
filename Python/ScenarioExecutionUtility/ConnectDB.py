from SetUp import SetUp


A1 = SetUp()
SERVERNAME = A1.SERVERNAME
CI_DB = A1.CI_DB
CL_DB = A1.CL_DB
CAuth_DB = A1.CAuth_DB

# Create connection
def ConnectDB(self):
    import pyodbc
    con = pyodbc.connect(p_str=True,
                                driver="{ODBC Driver 13 for SQL Server}",
                                server=SERVERNAME,
                                Trusted_Connection='yes',
                                autocommit=True)
    cur = con.cursor()

    return cur