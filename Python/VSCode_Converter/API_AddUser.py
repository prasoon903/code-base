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
                        Trusted_Connection='yes',
                        autocommit=True)
    cur = con.cursor()

    return cur

###################################################################################################

def CheckUserAccess(UserAccess, UserType):
    Output = False
    if UserType == "UserToAdd" and (UserAccess == 0 or UserAccess == 1 or UserAccess == 2):
        Output = True
    elif UserType == "UserModifier" and UserAccess == 3:
        Output = True
    elif UserType == "UserToAddVersion" and (UserAccess == 2 or UserAccess == 3):
        Output = True
    else:
        Output = False

    return Output 

###################################################################################################


def CheckExistingUser(Project, UserIP):
    Connect = Local_ConnectDB()
    Output = False
    Query = "SELECT COUNT(1) AS UserID FROM " + LocalDB + "..UserDetails WITH (NOLOCK) " \
            "WHERE Project = '"+ Project +"' AND UserIP = '"+ UserIP +"'"

    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount == 1:
        for r in Row:
            if r.UserID <= 0:
                Output = True

    Connect.close()
    return Output    

###################################################################################################

def CheckUserAccessToModifyRecords(Project, ModifierIP, UserType):
    Connect = Local_ConnectDB()
    Output = False
    Query = "SELECT TOP 1 UserAccess FROM " + LocalDB + "..UserDetails WITH (NOLOCK) " \
            "WHERE Project = '"+ Project +"' AND UserIP = '"+ ModifierIP +"'"

    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        for r in Row:
            if CheckUserAccess(r.UserAccess, UserType):
                Output = True

    Connect.close()
    return Output  


###################################################################################################


def AddUser(Project, Username, UserIP, UserAccess, ModifierIP):
    Message = OrderedDict()

    if CheckUserAccess(UserAccess, "UserToAdd"):
        if CheckExistingUser(Project, UserIP):
            if CheckUserAccessToModifyRecords(Project, ModifierIP, "UserModifier"):
                UserDetails = OrderedDict()
                Message = OrderedDict()

                Connect = Local_ConnectDB()
                UserAccess = str(UserAccess)

                InsertQuery = "INSERT INTO " + LocalDB + "..UserDetails (Project, Username, UserIP, UserAccess, DateAdded, AddedByUserIP) VALUES " \
                                "('"+ Project +"', '"+ Username +"', '"+ UserIP +"', '"+ UserAccess +"', GETDATE(), '"+ ModifierIP +"')"

                Connect.execute(InsertQuery)

                Message['Response'] = 'User added successfully.'

                UserDetails['Project'] = Project
                UserDetails['Username'] = Username
                UserDetails['UserIP'] = UserIP
                UserDetails['UserAccess'] = UserAccess

                Message.update(UserDetails)

                Connect.close()
            else:
                Message['Response'] = 'You are not authorized to add user'
        else:
            Message['Response'] = 'UserIP already exists.'
    else:
        Message['Response'] = 'Invalid UserAccess, it can be either 0: No Access or 1: ReadOnly or 2: ReadWrite.'
    
    Output = Message

    return Output

###################################################################################################