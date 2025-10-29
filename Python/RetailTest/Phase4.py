import json
from ConnectDB import ConnectDB
from Clearing import Clearing
from DisputeResolution import DisputeResolution
import os


def Phase4Process(TestNumber, TotalCount):
    from DisputeResolution import DisputeResolution
    TestNumber = TestNumber
    TotalCount = TotalCount
    ThreadCount = 0

    Directory = "TestNumber_" + str(TestNumber) + "/"
    Path = Directory + "Account/"
    ActivityPath = Directory + "Activity/"

    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = "\n" + "************** Phase 4 Started *************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    Message = ""

    # Payment Reversal
    LoopCount = 3

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_PaymentOfTotalDue.json'

    with open(os.path.join(ActivityPath, ActivityFileName)) as json_file:
        RPayment = json.load(json_file)

    AccountNumber = RPayment["AccountNumber"]
    Amount = RPayment["TransactionAmount"]
    TransactionID = RPayment["TransactionID"]

    print(AccountNumber)

    Message = Message + "\n" + "Payment Reversal" + "\n" + str(AccountNumber)

    TranType = "2204"

    Activity = Clearing(AccountNumber
                        , TranType
                        , TransactionID
                        , Amount)

    PaymentReversal = Activity.clearing()

    Message = Message + "\n" + str(PaymentReversal)
    print("Payment Reversal done")

    # Dispute closed in customer favor
    # Full dispute resolve
    LoopCount = 8
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Dispute closed in customer favor" + "\n" + str(AccountNumber)

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Full.json'

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

    Action = "2"
    Reason = "5"
    Activity = DisputeResolution()

    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)

    # Partial dispute resolve
    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Partial.json'

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

    Action = "2"
    Reason = "5"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)
    Connection.close()

    print("Dispute closed in customer favor done")

    # Dispute closed in merchant favor without finance charge

    # Full dispute resolve
    LoopCount = 9
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Dispute closed in merchant favor without finance charge" + "\n" + str(AccountNumber)

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Full.json'

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

    Connection.close()

    Action = "4"
    Reason = "2"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)

    # Partial dispute resolve

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Partial.json'

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

    Action = "4"
    Reason = "2"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)
    Connection.close()

    print("Dispute closed in merchant favor without finance charge done")

    # Full Dispute resolved in Fraud

    LoopCount = 10
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Full Dispute resolved in Fraud" + "\n" + str(AccountNumber)

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Full.json'

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

    Connection.close()

    Action = "8"
    Reason = "10"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)

    print("Full Dispute resolved in Fraud done")
    # Dispute closed in merchant favor with finance charge

    # Full dispute resolve
    LoopCount = 11
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Dispute closed in merchant favor with finance charge" + "\n" + str(AccountNumber)

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Full.json'

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

    Connection.close()

    Action = "3"
    Reason = "2"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)

    # Partial dispute resolve

    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_InitiateDispute_Partial.json'

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

    Action = "3"
    Reason = "2"
    DisputeResolution = Activity.DisputeResolution(AccountNumber
                                                     , Action
                                                     , Reason
                                                     , Amount
                                                     , CaseID)

    Message = Message + "\n" + str(DisputeResolution)
    Connection.close()

    print("Dispute closed in merchant favor with finance charge done")

    # Charge-off Reversal

    LoopCount = 6
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Charge-off Reversal" + "\n" + str(AccountNumber)

    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT CAST(Amountoftotaldue AS VARCHAR) AS Amountoftotaldue FROM " + CI_DB + "..BSegment_Primary BP WITH (NOLOCK) " \
          "JOIN " + CI_DB + "..BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId) " \
          "JOIN " + CI_DB + "..BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId) " \
          "WHERE AccountNumber = '" + AccountNumber + "'"

    Result = Connection.execute(SQL)

    TranType = "5402"
    ReversalTranID = ""

    for r in Result:
        Amount = r.Amountoftotaldue

    Activity = Clearing(AccountNumber
                        , TranType
                        , ReversalTranID
                        , Amount)

    ChargeOffReversal = Activity.clearing()

    Message = Message + "\n" + str(ChargeOffReversal)

    Connection.close()

    print("Charge-off Reversal done")

    Message = Message + "\n" + "*************** END OF PHASE 4 ***************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

    print("*************END OF PHASE 4***************")

    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "ActivityList.txt"
    Message = "\n" + "************** ActivityList *************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    Message = ""
    Count = 1

    for LoopCount in range(TotalCount):
        FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

        with open(os.path.join(Path, FileName)) as json_file:
            RAccountCreation = json.load(json_file)

        AccountNumber = RAccountCreation["AccountNumber"]

        if LoopCount == 0:
            Message = Message + "\n" + str(Count) + ". Plan Initiated ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 1:
            Message = Message + "\n" + str(Count) + ". Over Payment ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 2:
            Message = Message + "\n" + str(Count) + ". Full Return ===> " + str(AccountNumber)
            Count = Count + 1
            Message = Message + "\n" + str(Count) + ". Partial Return ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 3:
            Message = Message + "\n" + str(Count) + ". Payment Reversal ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 4:
            Message = Message + "\n" + str(Count) + ". Delinquency ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 5:
            Message = Message + "\n" + str(Count) + ". Charge-off ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 6:
            Message = Message + "\n" + str(Count) + ". Full Dispute Open ===> " + str(AccountNumber)
            Count = Count + 1
            Message = Message + "\n" + str(Count) + ". Partial Dispute Open ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 7:
            Message = Message + "\n" + str(Count) + ". Full Dispute closed in customer favor ===> " + str(AccountNumber)
            Count = Count + 1
            Message = Message + "\n" + str(Count) + ". Partial Dispute closed in customer favor ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 8:
            Message = Message + "\n" + str(Count) + ". Full Dispute closed in merchant favor without finance charge ===> " + str(AccountNumber)
            Count = Count + 1
            Message = Message + "\n" + str(Count) + ". Partial Dispute closed in merchant favor without finance charge ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 9:
            Message = Message + "\n" + str(Count) + ". Fraud write-off (account) ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 10:
            Message = Message + "\n" + str(Count) + ". Full Dispute resolved in Fraud ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 11:
            Message = Message + "\n" + str(Count) + ". Charge-off Reversal ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 12:
            Message = Message + "\n" + str(Count) + ". Disaster relief ===> " + str(AccountNumber)
            Count = Count + 1
        if LoopCount == 13:
            Message = Message + "\n" + str(Count) + ". Full Dispute closed in merchant favor with finance charge ===> " + str(AccountNumber)
            Count = Count + 1
            Message = Message + "\n" + str(Count) + ". Partial Dispute closed in merchant favor with finance charge ===> " + str(AccountNumber)

    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
    ActivityFile.close()
