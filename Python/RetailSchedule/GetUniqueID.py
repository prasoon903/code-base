from ConnectDB import ConnectDB


class GetUniqueID:
    def GetUniqueID(self, Name):

        Connect = ConnectDB()
        Connection = Connect.ConnectDB()
        CI_DB = Connect.CI_DB

        Query = "EXEC" + CI_DB + "..USP_GetUniqueID '" + Name + "'"

        UniqueID = 0
        Result = Connection.execute(Query)
        Row = Result.fetchall()

        for r in Row:
            UniqueID = r.ID

        return UniqueID

