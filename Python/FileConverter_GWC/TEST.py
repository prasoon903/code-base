from SetUp import SetUp as S1
import pandas as pd

inputFile = S1.InputFile+'\Issuetesting.xlsx'
print(inputFile)

DataDict = {}

for key, values in zip(S1.Columns, S1.DataTypes):
    DataDict[key] = values

DF = pd.read_excel(inputFile, sheet_name=S1.SheetName, usecols=S1.Columns)

DF1 = pd.DataFrame()
LoopCount = 0

print(DF.dtypes)

for key in S1.Columns:    
    if(DataDict[key] == 'VARCHAR'):
        DF1.insert(LoopCount, key, "'" + DF[key].astype(str) + "'", True)
    elif(DataDict[key] == 'DATETIME'):
        DF1.insert(LoopCount, key, "'" + pd.to_datetime(DF[key]) + "'", True)
    else:
        DF1.insert(LoopCount, key, DF[key].astype(str), True)
    LoopCount+=1
'''
DF2 = pd.DataFrame()
LoopCount = 0
for key in S1.Columns: 
    #print(LoopCount)
    if(LoopCount == 0):
        DF2.insert(LoopCount, 'Value'+str(LoopCount), S1.Prefix+DF1[key], True)
    else:
        DF2.insert(LoopCount, 'Value'+str(LoopCount), DF2['Value'+str(LoopCount-1)]+', '+DF1[key])
    
    LoopCount+=1

DF2.update(DF2['Value'+str(LoopCount-1)]+S1.Suffix)

DF3 = DF2['Value'+str(LoopCount-1)]

print(DF3)

DF3.to_csv('DF.txt', sep=',', index=False, header=False)

Count = 0
with open('DF.txt') as f:
    for line in f:
        line.strip().split('/n')
        LineToPrint = line.strip()
        LineToPrint = LineToPrint.replace('"', '')
        Count += 1

        if LineToPrint != "":
            Message = LineToPrint
            #print(Message)

'''