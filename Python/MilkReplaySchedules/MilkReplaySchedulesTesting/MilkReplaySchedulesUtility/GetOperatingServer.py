from ConnectDB import ConnectDB

def GetOperatingServer(MessageLogger):
    OperatingServer = ''
    try:
        MessageLogger.info('INSIDE GetOperatingServer BLOCK')
        RowCount = 0

        Query = "SELECT TOP 1 INFO_VALUE FROM Admin.dbo.TB_INFO WHERE INFO_KEY = 'SERVERNAME'"

        Connection = ConnectDB(MessageLogger)
        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
        except Exception as e:
            Error = True
            Message = 'Error in executing the query :: ' + Query
            MessageLogger.error(Message + "\n" + e)

        if RowCount > 0:
            for r in Row:
                OperatingServer = r.INFO_VALUE

        MessageLogger.info('OperatingServer: ' + OperatingServer)
        
        MessageLogger.info('EXITING GetOperatingServer BLOCK')

    except Exception as e:
        MessageLogger.error("ERROR INSIDE GetOperatingServer BLOCK", e)

    return OperatingServer


###################################################################################################