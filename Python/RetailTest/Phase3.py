import json
from ConnectDB import ConnectDB
from Payment import Payment
from ChargeOff import ChargeOff
from RetailAuth_SingleItem import RetailAuth_SingleItem
from InitiateDispute import InitiateDispute
from AddManualStatus import AddManualStatus
import os


def Phase3Process(TestNumber, TotalCount):
    from ChargeOff import ChargeOff
    TestNumber = TestNumber
    TotalCount = TotalCount
    ThreadCount = 0

    Directory = "TestNumber_" + str(TestNumber) + "/"
    Path = Directory + "Account/"

    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = "\n" + "************** Phase 3 Started *************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    Message = ""

    # OverPayment
    LoopCount = 1
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "OverPayment" + "\n" + str(AccountNumber)

    TranType = "2104"
    Amount = "1000"

    Activity2 = Payment(AccountNumber
                        , TranType
                        , Amount)

    OverPayment = Activity2.Payment()

    Message = Message + "\n" + str(OverPayment)

    print("OverPayment done.")

    # Full Return
    LoopCount = 2
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Return" + "\n" + str(AccountNumber)

    Partial = False

    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT TOP 2 CAST(CC.CoreAuthTranID AS VARCHAR) AS CoreAuthTranID, CAST(ILPS.OriginalLoanAmount AS VARCHAR) " \
          "AS OriginalLoanAmount, CC.PlanUUID " \
          "FROM " + CI_DB + "..CPSgmentAccounts CA WITH (NOLOCK) " \
                            "JOIN " + CI_DB + "..CPSgmentCreditCard CC WITH (NOLOCK) ON (CA.acctId = CC.acctId) " \
                                              "JOIN " + CI_DB + "..BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CA.parent02AID) " \
                                                                "JOIN " + CI_DB + "..ILPScheduleDetailSummary ILPS WITH (NOLOCK) ON (ILPS.PlanID = CA.acctId) " \
                                                                                  "WHERE BP.AccountNumber = '" + AccountNumber + "'" \
                                                                                                                                 "AND ILPS.ScheduleIndicator IN (0, 1) " \
                                                                                                                                 "ORDER BY ILPS.LoanDate"

    Result = Connection.execute(SQL)
    Row = Result.fetchall()

    for r in Row:
        # LoopCount = LoopCount + 1
        CoreAuthTranID = r.CoreAuthTranID
        OriginalLoanAmount = r.OriginalLoanAmount

        OriginalLoanAmount = float(OriginalLoanAmount)
        if Partial:
            OriginalLoanAmount = OriginalLoanAmount / 2
        else:
            Partial = True
        PlanUUID = r.PlanUUID

        PlanID = ""
        EqualPaymentAmount = 0
        Term = 0
        MTI = "9220"
        CoreAuthTranID = str(CoreAuthTranID)
        Amount = OriginalLoanAmount

        Activity3 = RetailAuth_SingleItem(AccountNumber
                                          , Amount
                                          , PlanID
                                          , EqualPaymentAmount
                                          , Term
                                          , MTI
                                          , CoreAuthTranID
                                          , PlanUUID
                                          )

        Return = Activity3.RetailAuth_SingleItem()

        Message = Message + "\n" + str(Return)

    Connection.close()

    print("Return done")

    # Payment of Total Due
    LoopCount = 3
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Payment of Total Due" + "\n" + str(AccountNumber)

    Connect = ConnectDB()
    Connection = Connect.ConnectDB()
    CI_DB = Connect.CI_DB

    SQL = "SELECT CAST(Amountoftotaldue AS VARCHAR) AS Amountoftotaldue FROM " + CI_DB + "..BSegment_Primary BP WITH (NOLOCK) " \
                                                                                         "JOIN " + CI_DB + "..BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId) " \
                                                                                                           "JOIN " + CI_DB + "..BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId) " \
                                                                                                                             "WHERE AccountNumber = '" + AccountNumber + "'"

    Result = Connection.execute(SQL)

    TranType = "2104"

    for r in Result:
        Amount = r.Amountoftotaldue

    Activity5 = Payment(AccountNumber
                        , TranType
                        , Amount)

    PaymentOfTotalDue = Activity5.Payment()

    ActivityPath = Directory + "Activity/"
    ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '_PaymentOfTotalDue.json'

    with open(os.path.join(ActivityPath, ActivityFileName), 'w') as f:
        json.dump(PaymentOfTotalDue, f)

    Message = Message + "\n" + str(PaymentOfTotalDue)

    Connection.close()

    print("Payment of Total Due done.")

    # Charge-off(1)

    LoopCount = 5
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Charge-off" + "\n" + str(AccountNumber)

    """
    Status:
    0	Not Charged-off                                                                                     
    1	Pending Manual Initial Charge-off                                                                  
    2	Hold Initial Charge-off                                                                            
    3	Started Initial Charge-off                                                                         
    4	Started Final Charge-off   
    """

    """
    Reason: 
    0	None                                                                                               
    1	Credit Losses                                                                                      
    2	Bankruptcy                                                                                         
    3	Fraud                                                                                              
    4	Other                                                                                              
    6	Deceased                                                                                          
    7	Contractional                                                                                     
    """

    Status = "1"
    Reason = "2"

    Activity6 = ChargeOff()

    ChargeOff = Activity6.ChargeOff(AccountNumber
                                    , Status
                                    , Reason)

    Message = Message + "\n" + str(ChargeOff)

    print("Charge-off(1) done")

    # Charge-Off (2)
    LoopCount = 6
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Charge-off" + "\n" + str(AccountNumber)

    Status = "1"
    Reason = "2"

    ChargeOff = Activity6.ChargeOff(AccountNumber
                                    , Status
                                    , Reason)

    Message = Message + "\n" + str(ChargeOff)

    print("Charge-off(2) done")

    # Initiate Dispute
    NumberOfAccountsForDispute = 5

    for Count in range(NumberOfAccountsForDispute):
        LoopCount = LoopCount + 1
        FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

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
              "AS OriginalLoanAmount " \
              "FROM " + CI_DB + "..ILPScheduleDetailSummary ILPS WITH (NOLOCK) " \
                                "JOIN " + CI_DB + "..BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = ILPS.parent02AID) " \
                                                  "WHERE BP.AccountNumber = '" + AccountNumber + "'" \
                                                                                                 "AND ILPS.ScheduleIndicator IN (0, 1) " \
                                                                                                 "ORDER BY ILPS.LoanDate"

        Result = Connection.execute(SQL)
        Row = Result.fetchall()

        for r in Row:
            # print("After query")
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
            ActivityFileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) +\
                               '_InitiateDispute_' + DisputeType + '.json'

            with open(os.path.join(ActivityPath, ActivityFileName), 'w') as f:
                json.dump(Dispute, f)

            Message = Message + "\n" + str(Dispute)

        Connection.close()

    print("Initiate Dispute done")

    # Fraud write-off (account)

    LoopCount = 12
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Fraud write-off (account)" + "\n" + str(AccountNumber)

    Status = "1"
    Reason = "3"

    FraudWriteOff = Activity6.ChargeOff(AccountNumber
                                        , Status
                                        , Reason)

    Message = Message + "\n" + str(FraudWriteOff)

    print("Fraud write-off (account) done")

    # Disaster relief

    LoopCount = 13
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)

    Message = Message + "\n" + "Disaster relief" + "\n" + str(AccountNumber)

    Status = "15996"
    EndDate = "03252018"

    Activity9 = AddManualStatus(AccountNumber
                                , Status
                                , EndDate)

    DisasterRelief = Activity9.AddManualStatus()

    Message = Message + "\n" + str(DisasterRelief)

    print("Disaster relief done")

    Message = Message + "\n" + "*************** END OF PHASE 3 ***************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

    print("************* END OF PHASE 3 *************")
