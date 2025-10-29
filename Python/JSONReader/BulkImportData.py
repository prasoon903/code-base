from ConnectDB import ConnectDB
from SetUp import SetUp as S1
import pandas as pd
import os
import json
import subprocess
import datetime


def readOutputBCPDetails(LogDir, MessageLogger, FileToRead):
    MessageLogger.info("Reading BCP generated file")
    OutputFile = LogDir + FileToRead
    Count = 0

    with open(OutputFile) as f:
        for line in f:
            line.strip().split('/n')
            LineToPrint = line.strip()
            Count += 1

            if LineToPrint != "":
                MessageLogger.info(LineToPrint)
    f.close()

def ImportFileToDB(InputDir, FileName, TableName, XML, dir_path, LogDir, MessageLogger):
    MessageLogger.info("INSIDE ImportFileToDB BLOCK")

    MessageLogger.info("InputDir: " + str(InputDir))
    MessageLogger.info("FileName: " + str(FileName))
    MessageLogger.info("TableName: " + str(TableName))
    MessageLogger.info("XML: " + str(XML))
    MessageLogger.info("dir_path: " + str(dir_path))

    Error = True
    ErrorMessage = ''

    try:

        File = InputDir + FileName

        Error = False

        Connection = ConnectDB(MessageLogger)

        if Error is False:
            BCP = "bcp " + S1.CI_DB + ".DBO." + TableName + " IN " + File + " -b 5000 -h TABLOCK " \
                    "-f " + dir_path + XML + " -e " + str(LogDir) + str(FileName) + "_Error_in.log -o "  \
                    + str(LogDir) + str(FileName) + "_Output_in.log -S " + S1.SERVERNAME + " -T -t , -F 2"

            MessageLogger.info(BCP)
            try:
                MessageLogger.info("BCP START TIME::: " + str(datetime.datetime.now()))
                subprocess.run(BCP)
                readOutputBCPDetails(LogDir, MessageLogger, str(FileName) + "_Output_in.log")
                readOutputBCPDetails(LogDir, MessageLogger, str(FileName) + "_Error_in.log")
                Error = False
                ErrorMessage = "NO ERROR"
                MessageLogger.info("BCP EXECUTION SUCCESSFULL")
                MessageLogger.info("BCP FINISH TIME::: " + str(datetime.datetime.now()))
            except Exception:
                Error = True
                ErrorMessage = "ERROR IN EXECUTING THE BCP :: BCP :: " + BCP
                MessageLogger.error(ErrorMessage, exc_info=True)

        Connection.close()
        
        MessageLogger.info("EXITING ImportFileToDB :: Message :: " + ErrorMessage)
    except Exception as e:
        MessageLogger.error("ERROR IN ImportFileToDB BLOCK ", str(e))

    return Error

def GenerateCSV(InputDir, FileName, dir_path, LogDir, MessageLogger):
    MessageLogger.info("INSIDE GenerateCSV BLOCK")

    IsError = True

    try:

        InputFile = InputDir + FileName
        FileName_WithoutExt = os.path.splitext(FileName)[0]
        SplitFile = S1.JSONSplitFile + "\\"

        #SplitFileName = SplitFile + "IPM_" + FileName_WithoutExt + ".csv"
        #SplitAddendumName = SplitFile + "Addendum_" + FileName_WithoutExt + ".csv"

        SplitFileName = SplitFile + "IPM.csv"
        SplitAddendumName = SplitFile + "Addendum.csv"

        File= open(InputFile,)
        Addendum_List = []
        File_List = []
        data = json.load(File)
        for row in data:
            File_List.append(row)
            for Addendum in row['Addendum']:
                Addendum_List.append(Addendum)
            
            # Closing file
            File.close()

        AddendumDF = pd.DataFrame(Addendum_List)
        FileDF = pd.DataFrame(File_List)
        FileDF.drop('Addendum', axis=1, inplace=True)

        FileDF.to_csv(SplitFileName, index=False)
        AddendumDF.to_csv(SplitAddendumName, index=False)

        Error = ImportFileToDB(SplitFile, "IPM.csv", S1.TableName1, S1.XML1, dir_path, LogDir, MessageLogger)
        if Error == False:
            IsError = ImportFileToDB(SplitFile, "Addendum.csv", S1.TableName2, S1.XML2, dir_path, LogDir, MessageLogger)
        else:
            IsError = Error


    except Exception as e:
        IsError = True
        MessageLogger.error("ERROR IN ImportJsonFile BLOCK " + str(e))

    return IsError



