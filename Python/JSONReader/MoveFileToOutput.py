import shutil

def MoveFileToOutput(InputDir, OutputDir, FileName):
    
    shutil.move(InputDir + FileName, OutputDir + FileName)