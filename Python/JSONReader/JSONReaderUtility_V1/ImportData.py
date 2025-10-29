from ConnectDB import ConnectDB
from SetUp import SetUp as S1
import pandas as pd
import json

def ColumnData(FileDF, MessageLogger):
    IsError = True
    try:
        columnList = list(FileDF.columns)
        RecordCount = len(FileDF)
        MessageLogger.info("TOTAL RECORD COUNT = " + str(RecordCount))
        MessageLogger.debug("columnList = " + str(columnList))
        ColumnCount = len(columnList)
        MessageLogger.info("ColumnCount = " + str(ColumnCount))

        Columns = ""
        placeholder = ""
        firstIteration = True
        for column in columnList:
            if firstIteration:
                Columns = str(column)
                placeholder = "?" 
                firstIteration = False
            else:
                Columns = Columns + ", " + str(column)
                placeholder = placeholder + ", ?"

        IsError = False
    
    except Exception as e:
        IsError = True
        MessageLogger.error("ERROR IN ColumnData BLOCK" + str(e))

    return IsError, columnList, Columns, placeholder


def InsertData(Connection, MessageLogger, FileDF, columnList, Columns, placeholder, TableName):
    IsError = True
    try:
        InsertStatement = "INSERT INTO " + S1.CI_DB + ".DBO." + TableName + " (" + Columns + ") VALUES (" + placeholder + ") "

        MessageLogger.debug(InsertStatement)

        
        for index, row in FileDF.iterrows():
            data = list()
            for count in range(len(columnList)):
                data.append(row[count])

            MessageLogger.debug("Data::: ")
            MessageLogger.debug(data)
            Connection.execute(InsertStatement, data)
        

        IsError = False

    
    except Exception as e:
        IsError = True
        MessageLogger.error("ERROR IN InsertData BLOCK" + str(e))

    return IsError


def UpdateData(Connection, MessageLogger, FileDF):
    IsError = True
    
    try:

        for index, row in FileDF.iterrows():
            PrimaryAccountNumber = ""
            VirtualAccountNumber = ""
            PrimaryAccountNumber = "NULL" if row.PrimaryAccountNumber == None else "CONVERT(VARBINARY(MAX), '" + str(row.PrimaryAccountNumber) + "')"
            VirtualAccountNumber = "NULL" if row.VirtualAccountNumber == None else "CONVERT(VARBINARY(MAX), '" + str(row.VirtualAccountNumber) + "')"
            sql = "UPDATE " + S1.CI_DB + ".DBO." + S1.TableName1 + " SET PrimaryAccountNumber = " + PrimaryAccountNumber + ", VirtualAccountNumber = " + VirtualAccountNumber + " WHERE PrimaryAccountNumber IS NULL AND TranId = " + str(row.TranId)
            MessageLogger.debug("SQL = " + str(sql))

            try:
                Result = Connection.execute(sql)
                IsError = False
            except Exception as e:
                IsError = True
                MessageLogger.error("Error in executing SQL script, SQL:: " + sql + "\n" + e)

    except Exception as e:
        IsError = True
        MessageLogger.error("ERROR IN UpdateData BLOCK " + str(e))

    return IsError



def ImportJsonFile(InputDir, FileName, MessageLogger):
    MessageLogger.info("INSIDE ImportJsonFile BLOCK")

    IsError = True

    try:

        InputFile = InputDir + FileName

        File= open(InputFile,)
        Addendum_List = []
        File_List = []
        data = json.load(File)
        for row in data:
            File_List.append(row)
            for Addendum in row['Addendum']:
                Addendum_List.append(Addendum)
            
            # Closing file
            File.close()

        AddendumDF = pd.DataFrame(Addendum_List)
        FileDF = pd.DataFrame(File_List)

        #FileDF = pd.read_json(InputFile)
        DF1 = FileDF.filter(['TranId', 'PrimaryAccountNumber', 'VirtualAccountNumber'], axis=1)

        FileDF.drop('Addendum', axis=1, inplace=True)
        FileDF.drop('PrimaryAccountNumber', axis=1, inplace=True)
        FileDF.drop('VirtualAccountNumber', axis=1, inplace=True)

        #FileDF.PrimaryAccountNumber = "SELECT CONVERT(VARBINARY(MAX), '" + FileDF.PrimaryAccountNumber + "')"

        Connection = ConnectDB(MessageLogger)
        
        IsError, columnList, Columns, placeholder = ColumnData(FileDF, MessageLogger)
        if IsError == False:
            IsError = InsertData(Connection, MessageLogger, FileDF, columnList, Columns, placeholder, S1.TableName1)
        if IsError == False:
            IsError = UpdateData(Connection, MessageLogger, DF1)
        if IsError == False:
            IsError, columnList, Columns, placeholder = ColumnData(AddendumDF, MessageLogger)
        if IsError == False:
            IsError = InsertData(Connection, MessageLogger, AddendumDF, columnList, Columns, placeholder, S1.TableName2)

        if IsError == False:
            MessageLogger.info("NO ERROR, COMMITING DATA")
            Connection.commit()
        else:
            MessageLogger.info("ERROR FOUND, ROLLBACK DATA")
            Connection.rollback()

        Connection.close()
        MessageLogger.info("DATABASE CONNECTION CLOSED")


    except Exception as e:
        IsError = True
        MessageLogger.error("ERROR IN ImportJsonFile BLOCK " + str(e))

    return IsError



