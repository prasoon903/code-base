from SetUp import SetUp as S1

def DirectoryValidation():
    ErrorFlag = True
    InputDir = ''
    OutputDir = ''
    ErrorDir = ''
    LogDir = ''


    if S1.RetailInputFile == "":
        ErrorFlag = True
        Message = "Environment variable for Input folder is not set"
    elif S1.RetailOutFile == "":
        ErrorFlag = True
        Message = "Environment variable for Output folder is not set"
    elif S1.RetailErrorFile == "":
        ErrorFlag = True
        Message = "Environment variable for Error folder is not set"
    elif S1.RetailLogFile == "":
        ErrorFlag = True
        Message = "Environment variable for Log folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = S1.RetailInputFile + "\\"
        OutputDir = S1.RetailOutFile + "\\"
        ErrorDir = S1.RetailErrorFile + "\\"
        LogDir = S1.RetailLogFile + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, ErrorFlag 