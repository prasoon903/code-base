import pandas as pd

def CheckEmptyFile(InputDir, FileName, MessageLogger):
    MessageLogger.info("INSIDE CheckEmptyFile BLOCK")

    EmptyFile = False
    ErrorReason = ""

    try:
        InputFile = InputDir + FileName

        FileDF = pd.read_csv(InputFile)

        RecordCount = len(FileDF)

        MessageLogger.info("Total records in the file " + FileName + " is: " + str(RecordCount))

        if RecordCount > 0:
            EmptyFile = False
            MessageLogger.info("Non-Empty file, going to process")
        else:
            EmptyFile = True
            ErrorReason = "EMPTY FILE"
            MessageLogger.info("Empty file, aborting file processing")

    except Exception as e:
        MessageLogger.error("ERROR IN CheckEmptyFile BLOCK", e)

    return EmptyFile, ErrorReason