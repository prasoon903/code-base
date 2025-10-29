import json
# from ConnectDB import ConnectDB
from DisputeResolution import DisputeResolution
import os

TestNumber = 1
TotalCount = 9

Directory = "TestNumber_" + str(TestNumber) + "/"
Path = Directory + "Account/"
ActivityPath = Directory + "Activity/"

AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
AllActivityFileName = "DisputeActivity.txt"
Message = "\n" + "************** DisputeProcess 3 Started *************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
Message = ""

Action = ""
Reason = ""
Amount = ""
Activity = DisputeResolution()

# LoopCount = 0
for LoopCount in range(TotalCount):
    if LoopCount == 0 or LoopCount == 1:
        Action = "17"
    else:
        Action = "16"

    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + str(AccountNumber)

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_InitiateDispute_Full.json'

    with open(os.path.join(ActivityPath, ActivityFileName)) as json_file:
        InitiateDispute = json.load(json_file)

    CaseID = InitiateDispute["CardIssuerReferenceData"]

    """
    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT CAST(DisputeAmount AS VARCHAR) AS DisputeAmount FROM " + CI_DB + "..DisputeStatusLog " \
                                                                                   "WHERE CaseID = " + CaseID + "AND DisputeTranCode = '110'"

    Result = Connection.execute(SQL)

    for r in Result:
        Amount = r.DisputeAmount

    if LoopCount == 2 or LoopCount == 3:
        Amount = float(Amount)
        Amount = Amount * 0.25

    Connection.close()
    # Activity = DisputeResolution()
    """
    # Amount = 0

    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                   , Action
                                                   , Reason
                                                   , Amount
                                                   , CaseID)

    Message = Message + "\n" + str(DisputeResolution)

    # Partial dispute resolve
    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_InitiateDispute_Partial.json'

    with open(os.path.join(ActivityPath, ActivityFileName)) as json_file:
        InitiateDispute = json.load(json_file)

    CaseID = InitiateDispute["CardIssuerReferenceData"]

    """
    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT CAST(DisputeAmount AS VARCHAR) AS DisputeAmount FROM " + CI_DB + "..DisputeStatusLog " \
                                                                                   "WHERE CaseID = " + CaseID + "AND DisputeTranCode = '110'"

    Result = Connection.execute(SQL)

    for r in Result:
        Amount = r.DisputeAmount

    if LoopCount == 2 or LoopCount == 3:
        Amount = float(Amount)
        Amount = Amount * 0.25

    # Action = "2"
    # Reason = "5"
    """
    # Amount = 0
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                   , Action
                                                   , Reason
                                                   , Amount
                                                   , CaseID)

    Message = Message + "\n" + str(DisputeResolution)
    # Connection.close()

    # print("Dispute closed in customer favor done")

    # Dispute closed in merchant favor without finance charge

Message = Message + "\n" + "*************** END OF DisputeProcess 3 ***************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
