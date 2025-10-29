import json
from flask_jsonpify import jsonify
import pyodbc
from SetUp import SetUp
from collections import OrderedDict
import datetime
from API_AddUser import Local_ConnectDB, CheckUserAccessToModifyRecords

S1 = SetUp()

LocalDB = S1.LocalDB



def CheckVersionExists(Project, Environment, Version, TimeStamp):
    Connect = Local_ConnectDB()
    Output = False

    Query = "SELECT COUNT(1) AS Counter FROM " + LocalDB + "..VersionDetails WITH (NOLOCK) " \
            "WHERE Project = '"+ Project +"' AND Environment = '"+ Environment +"' AND Version = '"+ Version +"'" \
            "AND TimeStamp >= '"+ TimeStamp +"'"

    # print(Query)

    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        for r in Row:
            if r.Counter <= 0:
                Output = True

    Connect.close()
    return Output

###################################################################################################

def ValidateDate(TimeStamp):
    Output = False
    try:
        datetime.datetime.strptime(TimeStamp, '%Y-%m-%d %H:%M:%S')
        Output = True
    except:
        # raise ValueError("Incorrect data format, should be YYYY-MM-DD HH:MM:SS")
        Output = False

    return Output

###################################################################################################

def GetAllEnvironments(Project):
    VersionList = list()
    Query = "SELECT Environment FROM " + LocalDB + "..VersionDetails WITH (NOLOCK)" \
            "WHERE Project = '"+ Project +"'" \
            "GROUP BY Project, Environment"

    # print(Query)
    Connect = Local_ConnectDB()
    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        for r in Row:
            VersionList.append(r.Environment.upper())

    # print(VersionList)
    return VersionList


###################################################################################################

def AddDetails(Project, Environment, Version, TimeStamp, ModifierIP):
    AddDetails = OrderedDict()
    Message = OrderedDict()
    if CheckUserAccessToModifyRecords(Project, ModifierIP, "UserToAddVersion"):
        if ValidateDate(TimeStamp):
            # VersionDict = GetAllEnvironments(Project)
            VersionList = GetAllEnvironments(Project)

            if Environment in VersionList:
                if CheckVersionExists(Project, Environment, Version, TimeStamp):
                    Connect = Local_ConnectDB()
                    InsertQuery = "INSERT INTO " + LocalDB + "..VersionDetails (Project, Environment, Version, TimeStamp) VALUES " \
                                "('"+ Project +"', '"+ Environment +"', '"+ Version +"', '"+ TimeStamp +"')"

                    Connect.execute(InsertQuery)

                    InsertQuery = "INSERT INTO " + LocalDB + "..VersionDetailsModificationLog (Project, Environment, VersionModified, UserIP, DateModified) VALUES " \
                                "('"+ Project +"', '"+ Environment +"', '"+ Version +"', '"+ ModifierIP +"', '"+ TimeStamp +"')"

                    Connect.execute(InsertQuery)

                    Message['Response'] = 'Version added successfully.'

                    AddDetails['Project'] = Project
                    AddDetails['Environment'] = Environment
                    AddDetails['Version'] = Version
                    AddDetails['TimeStamp'] = TimeStamp

                    Message.update(AddDetails)

                    Connect.close()
                else:
                    Message['Response'] = 'Version already exists'
            else:
                Message['Response'] = 'Invalid environment'
        else:
            Message['Response'] = 'Invalid date format, should be YYYY-MM-DD HH:MM:SS'
    else:
        Message['Response'] = 'You are not authorized to add Version'

    Output = Message

    return Output