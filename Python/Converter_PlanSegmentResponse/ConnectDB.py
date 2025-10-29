class ConnectDB:

    def __init__(self):
        from SetUp import SetUp
        A1 = SetUp()
        self.SERVERNAME = A1.SERVERNAME
        self.CI_DB = A1.CI_DB
        self.CL_DB = A1.CL_DB
        self.CAuth_DB = A1.CAuth_DB

    # Create connection
    def ConnectDB(self):
            import pyodbc
            con = pyodbc.connect(p_str=True,
                                      driver="{SQL Server}",
                                      server=self.SERVERNAME,
                                      Trusted_Connection='yes')
            cur = con.cursor()

            return cur