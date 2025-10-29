from SetUp import SetUp as S1
from ConnectDB import ConnectDB as C1


def GetStoreFromProduct(ProductID):
    Query = "SELECT TOP 1 LTRIM(RTRIM(MPL.MPLMerchantDesc)) AS MPLMerchantDesc FROM " + S1.CI_DB +"..MerchantPLAccounts MPL WITH (NOLOCK) "\
            "JOIN " + S1.CI_DB +"..Logo_Primary LP WITH (NOLOCK) ON (MPL.parent02AID = LP.parent02AID) "\
            "WHERE LP.acctId = " + ProductID + " AND MPL.MPLMerchantLevel = 1"

    Connection = C1.ConnectDB()
    Store = ''
    Error = False

    try:
        Result = Connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0
        Error = True

    if RowCount > 0:
        for r in Row:
            Store = str(r.MPLMerchantDesc)

    # print(Store)
    Connection.close()

    return Error, Store