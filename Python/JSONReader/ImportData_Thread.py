from ConnectDB import ConnectDB
from SetUp import SetUp as S1
import pandas as pd
import os
import json
import subprocess
import datetime
from concurrent import futures
import csv
import queue
import sqlactions


conn_params = {
    "p_str": True,
    "server": S1.SERVERNAME,
    "database": S1.CI_DB,
    "driver": "{ODBC Driver 13 for SQL Server}",
}

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

def read_csv(csv_file):
    with open(csv_file, encoding="utf-8", newline="") as in_file:
        reader = csv.reader(in_file, delimiter=",")
        next(reader)  # Header row
        for row in reader:
            yield row

def process_row(row, batch, table_name, conn_params):
    batch.put(row)
    if batch.full():
        sqlactions.multi_row_insert(batch, table_name, conn_params)
    return batch

def load_csv(csv_file, table_def, conn_params):
    # Optional, drops table if it exists before creating
    #sqlactions.make_table(table_def, conn_params)
    batch = queue.Queue(S1.MULTI_ROW_INSERT_LIMIT)
    with futures.ThreadPoolExecutor(max_workers=S1.WORKERS) as executor:
        todo = []
        for row in read_csv(csv_file):
            future = executor.submit(
                process_row, row, batch, table_def, conn_params
            )
            todo.append(future)
        for future in futures.as_completed(todo):
            result = future.result()
    # Handle left overs
    if not result.empty():
        sqlactions.multi_row_insert(result, table_def, conn_params)

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

        load_csv(File, TableName, conn_params)

        #Connection = ConnectDB(MessageLogger)

        #if Error is False:
            

        #Connection.close()
        
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



