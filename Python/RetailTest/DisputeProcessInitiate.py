import json
from ConnectDB import ConnectDB
from InitiateDispute import InitiateDispute

import os

TestNumber = 1
TotalCount = 9

Directory = "TestNumber_" + str(TestNumber) + "/"
Path = Directory + "Account/"

AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
AllActivityFileName = "DisputeActivity.txt"
Message = "\n" + "************** DisputeProcess 1 Started *************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
Message = ""

for LoopCount in range(TotalCount):
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Initiate Dispute" + "\n" + str(AccountNumber)

    Partial = False
    DisputeType = "Full"

    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT TOP 2 CAST(ILPS.TranId AS VARCHAR) AS TranId, CAST(ILPS.OriginalLoanAmount AS VARCHAR) " \
          "AS OriginalLoanAmount FROM " + CI_DB + "..ILPScheduleDetailSummary ILPS WITH (NOLOCK) " \
          "JOIN " + CI_DB + "..BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = ILPS.parent02AID) " \
          "WHERE BP.AccountNumber = '" + AccountNumber + "' AND ILPS.ScheduleIndicator IN (0, 1) " \
          "ORDER BY ILPS.LoanDate"

    Result = Connection.execute(SQL)
    Row = Result.fetchall()

    for r in Row:
        TranId = r.TranId
        OriginalLoanAmount = r.OriginalLoanAmount

        OriginalLoanAmount = float(OriginalLoanAmount)

        if Partial:
            OriginalLoanAmount = OriginalLoanAmount / 2
            DisputeType = "Partial"
        else:
            Partial = True

        """
        Action:
        0—Initiate Dispute
        9 – send chargeBack to MC

        Reason:
        0	Merchandise Not Ordered                                                                             
        1	Merchandise Not Received  - To Customer                                                             
        2	Merchandise Not Received - From Customer                                                            
        3	Sent Payment Not Applied                                                                            
        4	Product Not as Described                                                                            
        5	Defective merchandise                                                                               
        6	Billing Error                                                                                       
        7	Duplicate Processing                                                                                
        8	Clarification                                                                                       
        9	Other 
        10  Fraud  
        """
        Action = "0"
        Reason = "1"

        Activity7 = InitiateDispute(AccountNumber
                                    , Action
                                    , Reason
                                    , OriginalLoanAmount
                                    , TranId)

        Dispute = Activity7.InitiateDispute()

        ActivityPath = Directory + "Activity/"
        ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_InitiateDispute_' \
                           + DisputeType + '.json'

        with open(os.path.join(ActivityPath, ActivityFileName), 'w') as f:
            json.dump(Dispute, f)

        Message = Message + "\n" + str(Dispute)

    Connection.close()

print("Initiate Dispute done")

Message = Message + "\n" + "*************** END OF DisputeProcess 1 ***************"
with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
    ActivityFile.write(Message)
    ActivityFile.write("\n")
ActivityFile.close()
