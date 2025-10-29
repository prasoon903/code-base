import pandas as pd
from SetUp import SetUp as S1
import xlrd

InputFileToProcess = S1.InputFile + "\\" + "Scenario.xlsx"
OutputFileDump = S1.OutFile + "\\" + "OUTPUT_Scenario.xlsx"

xls = pd.ExcelFile(InputFileToProcess)

sheetX = xls.parse("Sheet1")

# print(sheetX.shape)

# var1 = sheetX.head(5)

# print(var1)

df = pd.DataFrame(sheetX)

# print(df)

print(df.shape[0])

# df.loc[df['STEP'] == 1, 'TRANID'] = '1234'

# print(df.loc[df['STEP'] == 1])

# df.to_excel(OutputFileDump, index=False)