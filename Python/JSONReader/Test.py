from ConnectDB import ConnectDB
from SetUp import SetUp as S1
import pandas as pd
import os
import json


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

FileDF = pd.read_json(InputFile)
#print(FileDF)
FileDF.drop('Addendum', axis=1, inplace=True)
#print(FileDF)

print(FileDF.astype(object))

File= open('TestData.json',)
Addendum_Dict = []
data = json.load(File)
for row in data:
    for Addendum in row['Addendum']:
        Addendum_Dict.append(Addendum)
  
# Closing file
File.close()

AddendumDF = pd.DataFrame(Addendum_Dict)

ColumnData(FileDF)
ColumnData(AddendumDF)
