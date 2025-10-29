from pathlib import Path

def ValidateDuplicateFile(OutputDir, FileName, MessageLogger):
    
    MessageLogger.info("INSIDE ValidateDuplicateFile BLOCK")

    ErrorReason = "No Error"
    Error = False

    try:

        FilePath = Path(OutputDir + FileName)
        MessageLogger.debug(FilePath)
        

        if FilePath.is_file():
            Error = True
            MessageLogger.info("File " + FileName + " is already present in OUTPUT folder. So it can not be processed.")
            ErrorReason = "Duplicate File"

            MessageLogger.info(ErrorReason)

        MessageLogger.info("EXITING ValidateDuplicateFile BLOCK")

    except Exception:
        MessageLogger.error("ERROR IN ValidateDuplicateFile BLOCK", exc_info=True)

    return Error, ErrorReason