import json
from flask_jsonpify import jsonify
import pyodbc
from SetUp import SetUp
from collections import OrderedDict


S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME

###################################################################################################


def ConnectDB():
    con = pyodbc.connect(p_str=True,
                        driver="{ODBC Driver 17 for SQL Server}",
                        server=SERVERNAME,
                        Trusted_Connection='yes')
    cur = con.cursor()

    return cur

###################################################################################################



def GetLookUp():
    Lookup = ""

    Query = "SELECT  RTRIM(LTRIM(DisplayOrdr)) AS DisplayOrdr, " \
            "RTRIM(LTRIM(LutCode)) AS LutCode, " \
            "RTRIM(LTRIM(LutDescription)) AS LutDescription " \
            "FROM " + CI_DB + "..CCardLookUp WITH (NOLOCK) " \
            "WHERE LUTid = 'PlanSegmentLog' " \
            "ORDER BY DisplayOrdr"

    # print(Query)
    Connect = ConnectDB()
    Result = Connect.execute(Query)

    Row = Result.fetchall()

    for r in Row:
        if str(r.DisplayOrdr) == '1':
            Lookup = '"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'
        else:
            Lookup = Lookup + ',"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'

    Connect.close()

    Lookup = "{" + Lookup + "}"

    Lookup_dict = json.loads(Lookup)

    return Lookup_dict

###################################################################################################


def GenerateResponse(line):
    OutputResponse = line
    # Query = ""
    Lookup_dict = GetLookUp()
    Query = "SELECT CAST(DECOMPRESS(" + OutputResponse + ") AS VARCHAR(MAX)) AS OutputResponse"
    # print(Query)
    Connect = ConnectDB()
    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        for r in Row:
            OutputResponse = r.OutputResponse
            # Lookup_dict = GetLookUp()
            for key, value in Lookup_dict.items():
                KeyToReplace = '"' + str(key) + '"'
                Value = '"' + str(value) + '"'
                # print("Here to replace: " + KeyToReplace + " with " + Value)
                OutputResponse = OutputResponse.replace(KeyToReplace, Value)
    else:
        OutputResponse = "Invalid"

    Connect.close()
    return OutputResponse

###################################################################################################