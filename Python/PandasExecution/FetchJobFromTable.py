from SetUp import SetUp as S1
from ConnectDB import ConnectDB

def FetchJobFromTable(AccountNumber = ""):
    CMTTRANTYPE = ''
    TransactionAmount = 0
    Trantime = ''
    PostTime = ''
    CreditPlanMaster = ''
    RMATranUUID = ''
    RevTgt = 0
    CaseID = 0
    TxnSource = ''
    TxnCode_Internal = ''
    TransactionAPI = ''
    ActualTranCode = '' 
    LogicModule = ''

    if Skey == 0:
        Query = "SELECT " \
                "CMTTRANTYPE, TransactionAmount, Trantime, PostTime, CreditPlanMaster, " \
                "RMATranUUID, RevTgt, CaseID, TxnSource, TxnCode_Internal, TransactionAPI, InstitutionID, ActualTranCode, LogicModule " \
                "FROM " + S1.CI_DB + "..ScenarioExecution WITH (NOLOCK) " \
                "WHERE CMTTRANTYPE = 'QNA'"

        Connect = ConnectDB()

        try:
            Result = Connect.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            RowCount = 0

        if RowCount > 0:
            for r in Row:
                CMTTRANTYPE = r.CMTTRANTYPE
                TransactionAmount = r.TransactionAmount
                Trantime = r.Trantime
                PostTime = r.PostTime
                CreditPlanMaster = r.CreditPlanMaster
                RMATranUUID = r.RMATranUUID
                RevTgt = r.RevTgt
                CaseID = r.CaseID
                TxnSource = r.TxnSource
                TxnCode_Internal = r.TxnCode_Internal
                TransactionAPI = r.TransactionAPI
                InstitutionID = r.InstitutionID

        Connect.close()

    else:
        Query = "SELECT TOP 1 " \
                "CMTTRANTYPE, TransactionAmount, Trantime, PostTime, CreditPlanMaster, " \
                "RMATranUUID, RevTgt, CaseID, TxnSource, TxnCode_Internal, TransactionAPI, InstitutionID, ActualTranCode, LogicModule " \
                "FROM " + S1.CI_DB + "..ScenarioExecution WITH (NOLOCK) " \
                "WHERE AccountNumber = " + AccountNumber + " " \
                "ORDER BY Skey ASC" 

        Connect = ConnectDB()

        try:
            Result = Connect.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except:
            RowCount = 0

        if RowCount > 0:
            for r in Row:
                CMTTRANTYPE = r.CMTTRANTYPE
                TransactionAmount = r.TransactionAmount
                Trantime = r.Trantime
                PostTime = r.PostTime
                CreditPlanMaster = r.CreditPlanMaster
                RMATranUUID = r.RMATranUUID
                RevTgt = r.RevTgt
                CaseID = r.CaseID
                TxnSource = r.TxnSource
                TxnCode_Internal = r.TxnCode_Internal
                TransactionAPI = r.TransactionAPI
                InstitutionID = r.InstitutionID
                
        Connect.close()

    return CMTTRANTYPE, TransactionAmount, Trantime, PostTime, CreditPlanMaster, RMATranUUID, RevTgt, CaseID, TxnSource, TxnCode_Internal, TransactionAPI, InstitutionID, ActualTranCode, LogicModule