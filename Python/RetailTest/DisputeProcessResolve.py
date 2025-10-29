import json
from ConnectDB import ConnectDB
from DisputeResolution import DisputeResolution
import os

TestNumber = 1
TotalCount = 9

Directory = "TestNumber_" + str(TestNumber) + "/"
Path = Directory + "Account/"
ActivityPath = Directory + "Activity/"

AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
AllActivityFileName = "DisputeActivity.txt"
Message = "\n" + "************** DisputeProcess 2 Started *************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
Message = ""

Action = ""
Reason = ""
Amount = 0
Activity = DisputeResolution()

# LoopCount = 0
for LoopCount in range(TotalCount):
    if LoopCount == 0:
        Action = "1"
        Reason = "1"
        Message = Message + "\n" + "Dispute Reverse WFC"
    elif LoopCount == 1:
        Action = "7"
        Reason = "5"
        Message = Message + "\n" + "Dispute Reverse WOFC"
    elif LoopCount == 2:
        Action = "15"
        Reason = "5"
        Message = Message + "\n" + "Dispute Rebill 115 - CURRENT DATE"
    elif LoopCount == 3:
        Action = "14"
        Reason = "5"
        Message = Message + "\n" + "Dispute Rebill 117 PRESENTMENTDATE"
    elif LoopCount == 4:
        Action = "2"
        Reason = "5"
        Message = Message + "\n" + "Dispute closed in customer favor"
    elif LoopCount == 5:
        Action = "4"
        Reason = "5"
        Message = Message + "\n" + "Dispute closed in merchant favor without finance charge"
    elif LoopCount == 6:
        Action = "3"
        Reason = "5"
        Message = Message + "\n" + "Dispute closed in merchant favor with finance charge"
    elif LoopCount == 7:
        Action = "8"
        Reason = "10"
        Message = Message + "\n" + "Dispute resolved in Fraud"
    elif LoopCount == 8:
        Action = "5"
        Reason = "5"
        Message = Message + "\n" + "Dispute resolved in Non-Fraud"

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
    """
    Action will be 
    
    1—Dispute Reversal in favor of Bank/Merchant with Finance Charge
    2—Resolve in favor of Cardholder
    3—Resolve in favor of Bank/Merchant with Finance Charge 
    4—Resolved in favor of Bank/Merchant without Finance Charge        
    5—Representment - Written off by Bank(Non Fraud) 
    7—Dispute Reversal in favor of Bank/Merchant without Finance Charge 
    8 — Representment - Written off by Bank(Fraud) 
    10   - Reverse Chargeback
    12  - Arbitration Chargeback      
    14 - Rebilled (Presentment Date)
    15 - Rebilled (Current Date)
    16 - Dispute Resolution Reversal
    17 – ReOpen Dispute 
    
    Reason can have following values -
    
    0—Merchandise Not Ordered 
    1—Merchandise Not Received—To Customer
    2—Merchandise Not Received—From Customer 
    3—Sent Payment Not Applied
    4—Product not as described
    5—Defective Merchandise
    6—Billing Error
    7—Duplicate Processing
    8—Clarification 
    9—Other  
    10—Fraud 
    
    Reason Code  is Conditional. If not provided then  will take it from original dispute transaction.  
    """

    # Action = "2"
    # Reason = "5"
    # Activity = DisputeResolution()

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
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)
    Connection.close()

    # print("Dispute closed in customer favor done")

    # Dispute closed in merchant favor without finance charge

Message = Message + "\n" + "*************** END OF DisputeProcess 2 ***************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
