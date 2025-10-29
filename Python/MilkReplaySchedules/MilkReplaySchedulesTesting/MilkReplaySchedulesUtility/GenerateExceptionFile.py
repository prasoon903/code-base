from ConnectDB import ConnectDB_ConnectionObject
from SetUp import SetUp as S1
import pandas as pd
import os

def GenerateExceptionFile(FileID, FileName, MessageLogger):
    MessageLogger.info("INSIDE GenerateExceptionFile BLOCK")

    ExceptionFile = ""

    try:
        FileName_WithoutExt = os.path.splitext(FileName)[0]

        ExceptionFile = S1.RetailExceptionFilePrefix + FileName_WithoutExt + S1.RetailExceptionFileSuffix + S1.RetailFileProcessingPOD +".csv"

        ExceptionFileName = S1.RetailExceptionFile + "\\" + ExceptionFile

        MessageLogger.info("ExceptionFileName: " + ExceptionFileName)    

        Query = "SELECT  Report_Date, Business_Date, Batch_Timestamp, Account_UUID, Plan_UUID, " \
                "Schedule_ID, Institution_ID, Product_ID, Error, [Error_Message], Field_Path, LTRIM(RTRIM(AccountNumber)) AccountNumber " \
                "FROM " + S1.CI_DB + "..ILPScheduleDetailsBAD_Archive WITH (NOLOCK) " \
                "WHERE FileName = '" + FileName + "' " \
                "AND FileID = '" + FileID + "' " \
                "AND JobStatus = 10"

        Connection = ConnectDB_ConnectionObject(MessageLogger)
        MessageLogger.debug(Query)

        QueryResult = pd.read_sql_query(Query, Connection)

        ResultDataFrame = pd.DataFrame(QueryResult)

        ResultDataFrame.to_csv(ExceptionFileName, index=False)

        TotalRecords = len(ResultDataFrame)

        Connection.close()

        ExceptionFile = "<p style=""color:Crimson;""><b>Exception File Name:</b> " + ExceptionFile + "</p>"
        ExceptionFile = ExceptionFile + "<p style=""color:DarkBlue;""><b>Total records in exception file:</b> " + str(TotalRecords) + "</p>"

        MessageLogger.info("EXITING GenerateExceptionFile BLOCK")

    except Exception as e:
        ExceptionFile = "<p style=""color:DarkRed;""><b>ERROR :: Exception file not generated</b></p>"
        MessageLogger.error("ERROR IN GenerateExceptionFile BLOCK", e)

    return ExceptionFile