from SetUp import SetUp as S1

def DirectoryValidation():
    ErrorFlag = True
    InputDir = ''
    OutputDir = ''
    ErrorDir = ''
    LogDir = ''


    if S1.JSONInputFile == "":
        ErrorFlag = True
        Message = "Environment variable for Input folder is not set"
    elif S1.JSONOutFile == "":
        ErrorFlag = True
        Message = "Environment variable for Output folder is not set"
    elif S1.JSONErrorFile == "":
        ErrorFlag = True
        Message = "Environment variable for Error folder is not set"
    elif S1.JSONLogFile == "":
        ErrorFlag = True
        Message = "Environment variable for Log folder is not set"
    else:
        ErrorFlag = False

    if ErrorFlag == False:
        InputDir = S1.JSONInputFile + "\\"
        OutputDir = S1.JSONOutFile + "\\"
        ErrorDir = S1.JSONErrorFile + "\\"
        LogDir = S1.JSONLogFile + "\\"

    return InputDir, OutputDir, ErrorDir, LogDir, ErrorFlag 