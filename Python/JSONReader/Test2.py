from numpy import NAN
from ConnectDB import ConnectDB
from SetUp import SetUp as S1
import pandas as pd
import os
import json
import csv


def ColumnData(FileDF):
    #print(type(FileDF))
    columnList = list(FileDF.columns)
    RecordCount = len(FileDF)
    print(columnList)
    ColumnCount = len(columnList)
    print(ColumnCount)

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

    print(Columns)
    print(placeholder)

    for index, row in FileDF.iterrows():
        data = list()
        for count in range(len(columnList)):
            data.append(row[count])
    
    #print(FileDF)
    print("DATA===============")
    print(data)


FileName= "TestData.json"
InputFile = S1.JSONInputFile + "\\" + FileName

File= open('IPM.csv',)
Addendum_List = []
AllRecord_List = []

#data = json.load(File)
data = csv.load(File)
for row in data:
    AllRecord_List.append(row)
    for Addendum in row['Addendum']:
        Addendum_List.append(Addendum)

#FileDF = pd.read_json(InputFile)
#print(FileDF)
#FileDF.drop('Addendum', axis=1, inplace=True)
#print(FileDF)

#print(FileDF.astype(object))


  
# Closing file
File.close()

#AddendumDF = pd.DataFrame(Addendum_List)
FileDF = pd.DataFrame(AllRecord_List)
ColumnData(FileDF)

#FileDF.drop('Addendum', axis=1, inplace=True)

#print(FileDF.PrimaryAccountNumber)

#FileDF.PrimaryAccountNumber = "SELECT CONVERT(VARBINARY(MAX), '" + FileDF.PrimaryAccountNumber + "')"
#print(FileDF.PrimaryAccountNumber)

#Connection = ConnectDB()

#SQL = pd.read_sql_query(''' SELECT CONVERT(VARBINARY(MAX), PrimaryAccountNumber''', Connection)

#DF_PrimaryAccountNumber = FileDF.filter(['TranId', 'PrimaryAccountNumber'], axis=1)
#DF_VirtualAccountNumber = FileDF.filter(['TranId', 'VirtualAccountNumber'], axis=1)
#DF1 = FileDF.filter(['TranId', 'PrimaryAccountNumber', 'VirtualAccountNumber'], axis=1)

#print(DF_PrimaryAccountNumber)
#print(DF_VirtualAccountNumber)
#print(DF1)

#DICT_PrimaryAccountNumber = dict(zip(DF_PrimaryAccountNumber.TranId, DF_PrimaryAccountNumber.PrimaryAccountNumber))
#DICT_VirtualAccountNumber = dict(zip(DF_VirtualAccountNumber.TranId, DF_VirtualAccountNumber.VirtualAccountNumber))

#print(DICT_PrimaryAccountNumber)
#print(DICT_VirtualAccountNumber)
'''
for key, values in DF1_Dict.iterrows():
    sql = "SELECT CONVERT(VARBINARY(MAX), '" + DF1_Dict.values + "')"
    Result = Connection.execute(sql)
    print(Result)

'''

#for index, row in DF1.iterrows():
    
    #if row.PrimaryAccountNumber == None:
    #    print("NULL DATA PrimaryAccountNumber")
    #    PrimaryAccountNumber = 'NULL'
    #else:
    #    PrimaryAccountNumber = "CONVERT(VARBINARY(MAX), '" + row.PrimaryAccountNumber + "')"
#
    #if row.VirtualAccountNumber == None:
    #    print("NULL DATA VirtualAccountNumber")
    #    VirtualAccountNumber = 'NULL'
    #else:
    #    VirtualAccountNumber = "CONVERT(VARBINARY(MAX), '" + row.VirtualAccountNumber + "')"
    
    #PrimaryAccountNumber = "NULL" if row.PrimaryAccountNumber == None else "CONVERT(VARBINARY(MAX), '" + row.PrimaryAccountNumber + "')"
    #VirtualAccountNumber = "NULL" if row.VirtualAccountNumber == None else "CONVERT(VARBINARY(MAX), '" + row.VirtualAccountNumber + "')"
#
    #print(PrimaryAccountNumber)
    #print(VirtualAccountNumber)
    #sql = "UPDATE " + S1.TableName1 + " SET PrimaryAccountNumber = " + PrimaryAccountNumber + ", SET VirtualAccountNumber = " + VirtualAccountNumber + " WHERE TranId = " + str(row.TranId)
    #print(sql)
    
    #Result = Connection.execute(sql)
    #Row = Result.fetchall()
    #for r in Row:
    #    print(r.Message)
    


#ColumnData(FileDF)
#ColumnData(AddendumDF)

#FileDF.to_csv("File.csv", index=False)
#AddendumDF.to_csv("AddendumDF.csv", index=False)
