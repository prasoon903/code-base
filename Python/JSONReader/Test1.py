import json
import pandas as pd
'''
# Opening JSON file
f = open('TestData.json',)
  
Addendum_List = []
data = json.load(f)
  
# Iterating through the json
# list
for row in data:
    for Addendum in row['Addendum']:
        #print(Addendum)
        Addendum_List.append(Addendum)
  
# Closing file
f.close()

#print(Addendum_List)

JsonDF = pd.DataFrame(Addendum_List)

print(JsonDF)

for index, row in JsonDF.iterrows():
    data = list()
    for count in range(len(row)):
        data.append(row[count])

print(data)
#Addendum_Dict = Addendum_List.to_dict()

#print(Addendum_Dict)

#print(Addendum_List.keys())
'''
s = "IQQAAtSyeHKP7Xfd/JGjsbWqNmnvCpsYncURZOg7CWwSm4bBMgM="
b = bytes(s, encoding='utf-8')
print(type(b))							# <class 'bytes'>
print(b)
