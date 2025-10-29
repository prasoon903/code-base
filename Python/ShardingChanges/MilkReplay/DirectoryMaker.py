import os 
path = "D:\\PLAT\\Dump\\MilkReplaySchedules"

RetailInputFile = os.path.join(path , "INPUT")
RetailOutFile = os.path.join(path , "OUT")
RetailErrorFile = os.path.join(path , "ERROR")
RetailGeneratedFile = os.path.join(path , "GENERATED")
RetailExceptionFile = os.path.join(path , "EXCEPTION")
RetailLogFile = os.path.join(path , "LOG")
RetailGenOutFile = os.path.join(RetailOutFile , "GENERATED")

print(RetailInputFile)
print(RetailOutFile)
print(RetailErrorFile)
print(RetailGeneratedFile)
print(RetailExceptionFile)
print(RetailLogFile)
print(RetailGenOutFile)

if os.path.isdir(RetailInputFile) is False:
    os.mkdir(RetailInputFile)
if os.path.isdir(RetailOutFile) is False:
    os.mkdir(RetailOutFile)
if os.path.isdir(RetailErrorFile) is False:
    os.mkdir(RetailErrorFile)
if os.path.isdir(RetailGeneratedFile) is False:
    os.mkdir(RetailGeneratedFile)
if os.path.isdir(RetailExceptionFile) is False:
    os.mkdir(RetailExceptionFile)
if os.path.isdir(RetailLogFile) is False:
    os.mkdir(RetailLogFile)
if os.path.isdir(RetailGenOutFile) is False:
    os.mkdir(RetailGenOutFile)