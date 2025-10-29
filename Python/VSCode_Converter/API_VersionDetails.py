import json
from flask_jsonpify import jsonify
import pyodbc
from SetUp import SetUp
from collections import OrderedDict


S1 = SetUp()

LocalDB = S1.LocalDB
LocalSERVERNAME = S1.LocalSERVERNAME


def Local_ConnectDB():
    con = pyodbc.connect(p_str=True,
                        driver="{ODBC Driver 17 for SQL Server}",
                        server=LocalSERVERNAME,
                        Trusted_Connection='yes')
    cur = con.cursor()

    return cur

###################################################################################################

def GetVersionDetails(Project, Environment):
    if Environment == "":
        Output = OrderedDict()
        Query = "SELECT Environment FROM " + LocalDB + "..VersionDetails WITH (NOLOCK)" \
            "WHERE Project = '"+ Project +"'" \
            "GROUP BY Project, Environment"

        Connect = Local_ConnectDB()
        try:
            Result = Connect.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            RowCount = 0

        if RowCount > 0:
            for r in Row:
                RowCountToGetEnv = 0
                Environment = r.Environment

                QueryToGetEnv = "SELECT TOP 1 Project, Environment, Version, " \
                "CONVERT(VARCHAR, TimeStamp, 23) + ' ' + CONVERT(VARCHAR, TimeStamp, 8) AS TimeStamp " \
                "FROM " + LocalDB + "..VersionDetails WITH (NOLOCK) " \
                "WHERE Project = '"+ Project +"' AND Environment = '"+ Environment +"'" \
                "ORDER BY TimeStamp DESC"

                try:
                    ResultToGetEnv = Connect.execute(QueryToGetEnv)
                    RowToGetEnv = ResultToGetEnv.fetchall()
                    RowCountToGetEnv = len(Row)
                except:
                    RowCountToGetEnv = 0

                if RowCountToGetEnv > 0:
                    columns = [column[0] for column in ResultToGetEnv.description]
                    OutputToGetEnv = {Environment: [OrderedDict(zip(columns,i)) for i in RowToGetEnv]}
                else:
                    OutputToGetEnv = {'Message': 'Details not found'}

                Output.update(OutputToGetEnv)

            Output = {'VersionDetails': Output}
            Output = jsonify(Output)

        else:
            Output = {'Message': 'Details not found'}
    else:
        Query = "SELECT TOP 1 Project, Environment, Version, " \
                "CONVERT(VARCHAR, TimeStamp, 23) + ' ' + CONVERT(VARCHAR, TimeStamp, 8) AS TimeStamp " \
                "FROM " + LocalDB + "..VersionDetails WITH (NOLOCK) " \
                "WHERE Project = '"+ Project +"' AND Environment = '"+ Environment +"'" \
                "ORDER BY TimeStamp DESC"

        # print(Query)
        Connect = Local_ConnectDB()
        try:
            Result = Connect.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            RowCount = 0

        if RowCount > 0:
            columns = [column[0] for column in Result.description]
            OutputEnv = {Environment: [OrderedDict(zip(columns,i)) for i in Row]}
            Output = {'VersionDetails': OutputEnv}
            Output = jsonify(Output)
        else:
            Output = {'Message': 'Details not found'}

    Connect.close()
    return Output

###################################################################################################


def GetVersionList(Project):
    Query = "SELECT Environment FROM " + LocalDB + "..VersionDetails WITH (NOLOCK)" \
            "WHERE Project = '"+ Project +"'" \
            "GROUP BY Project, Environment"

    Connect = Local_ConnectDB()
    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        columns = [column[0] for column in Result.description]
        Output = {'EnvironmentDetails': [OrderedDict(zip(columns,i)) for i in Row]}
        Output = jsonify(Output)
    else:
        Output = {'Message': 'Details not found'}

    Connect.close()
    return Output



###################################################################################################