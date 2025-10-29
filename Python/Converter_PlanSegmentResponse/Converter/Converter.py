import json
import sys
import glob
import os
import datetime
from SetUp import SetUp

S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
Indicator = S1.Indicator
filePath = S1.filePath
if filePath != "":
    filePath = filePath + "\\"

###################################################################################################


def ConnectDB():
    import pyodbc
    con = pyodbc.connect(p_str=True,
                         driver="{SQL Server}",
                         server=SERVERNAME,
                         Trusted_Connection='yes')
    cur = con.cursor()

    return cur

###################################################################################################


Connect = ConnectDB()

###################################################################################################


def ResponseWithSkey(Skey):
    OutputResponse = ""
    OutputFileName = "OutputResponseWithSkey_" + str(Skey) + "_" + str(datetime.datetime.now().strftime("%Y%m%d%M%S")) + ".txt"

    Query = "SELECT CAST(DECOMPRESS(OutputResponse) AS VARCHAR(MAX)) AS OutputResponse " \
            "FROM " + CI_DB + "..RetailPlanSegmentDetailsLog WITH (NOLOCK) " \
            "WHERE Skey = " + str(Skey)

    # print(Query)

    Result = Connect.execute(Query)
    Row = Result.fetchall()
    RowCount = len(Row)

    if RowCount > 0:
        for r in Row:
            OutputResponse = r.OutputResponse
            Lookup_dict = GetLookUp()
            for key, value in Lookup_dict.items():
                KeyToReplace = '"' + str(key) + '"'
                Value = '"' + str(value) + '"'
                # print("Here to replace: " + KeyToReplace + " with " + Value)
                OutputResponse = OutputResponse.replace(KeyToReplace, Value)
                GenerateResponseFile(OutputFileName, OutputResponse)
    else:
        # print("Invalid Skey")
        OutputResponse = "Invalid Skey"
        GenerateResponseFile(OutputFileName, OutputResponse)

    # Connect.close()

###################################################################################################


def GenerateResponseFile(OutputFileName, OutputResponse):
    file = open(OutputFileName, 'w')
    file.write(OutputResponse)
    file.close()

###################################################################################################


def GenerateResponse(line):
    OutputResponse = line
    # Query = ""
    Lookup_dict = GetLookUp()
    Query = "SELECT CAST(DECOMPRESS(" + OutputResponse + ") AS VARCHAR(MAX)) AS OutputResponse"
    # print(Query)
    # Connect = Connection()
    Result = Connect.execute(Query)
    Row = Result.fetchall()
    RowCount = len(Row)

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
        OutputResponse = "INVALID DATA"

    return OutputResponse

###################################################################################################


def ReadFile(FileName):
    FilePath = filePath + FileName
    OutputFileName = "OutputResponse_" + str(datetime.datetime.now().strftime("%Y%m%d%M%S")) + "_" + FileName
    OutputResponseWriteToFile = ""
    with open(FilePath) as file:
        count = 0
        while True:
            line = file.readline()
            # print(count)
            count += 1
            if not line:
                break
            OutputResponseWriteToFile = OutputResponseWriteToFile + GenerateResponse(line) + "\n"

    GenerateResponseFile(OutputFileName, OutputResponseWriteToFile)

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
    # Connect = Connection()
    Result = Connect.execute(Query)

    Row = Result.fetchall()

    for r in Row:
        if str(r.DisplayOrdr) == '1':
            Lookup = '"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'
        else:
            Lookup = Lookup + ',"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'

    # Connect.close()

    Lookup = "{" + Lookup + "}"

    Lookup_dict = json.loads(Lookup)

    return Lookup_dict

###################################################################################################


class Converter:
    print("Welcome to the Converter")
    # Connect = Connection()
    if Indicator == 2:
        if filePath != "":
            print(filePath)
            os.chdir(filePath)
            LoopCount = 0

            for file in glob.glob("*"):
                FileName = file
                print(FileName)
                LoopCount = LoopCount + 1
                ReadFile(FileName)

            print("Thank you")
            if Connect:
                Connect.close()

            sys.exit()
        else:
            print("File path is not set")

        if Connect:
            Connect.close()

    else:
        while True:
            ExitCode = int(input("Enter 0 to exit or 1 to check with Skey: "))
            if ExitCode == 1:
                while True:
                    Skey = int(input("Enter the Skey of Log : "))
                    if Skey > 0:
                        ResponseWithSkey(Skey)
                        print("File created")
                        print("More to convert...")
                        break
                    else:
                        print("Enter a valid number")

                # print(ResponseWithSkey(Skey))
            elif ExitCode == 0:
                print("Thank you")
                sys.exit()

        if Connect:
            Connect.close()

###################################################################################################
