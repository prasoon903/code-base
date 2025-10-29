import shutil

def MoveFileToError(InputDir, ErrorDir, FileName):
    
    shutil.move(InputDir + FileName, ErrorDir + FileName)