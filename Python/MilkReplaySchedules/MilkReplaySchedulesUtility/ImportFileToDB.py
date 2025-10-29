from SetUp import SetUp as S1
import subprocess
import datetime
from ConnectDB import ConnectDB

def readOutputBCPDetails(LogDir, MessageLogger):
    MessageLogger.info("Reading BCP Output file")
    OutputFile = LogDir + "Output1_in.log"
    Count = 0

    with open(OutputFile) as f:
        for line in f:
            line.strip().split('/n')
            LineToPrint = line.strip()
            Count += 1

            if LineToPrint != "":
                MessageLogger.info(LineToPrint)
    f.close()


def ImportFileToDB(InputDir, FileName, dir_path, LogDir, MessageLogger):
    MessageLogger.info("INSIDE ImportFileToDB BLOCK")
    Error = True
    ErrorMessage = ''

    try:

        File = InputDir + FileName

        Query = "TRUNCATE TABLE " + S1.CI_DB + "..ILPScheduleDetailsBAD_DUMP"

        Connection = ConnectDB(MessageLogger)

        try:
            Connection.execute(Query)
            Error = False
            MessageLogger.info("TABLE ILPScheduleDetailsBAD_DUMP TRUNCATED SUCCESSFULLY")
        except Exception:
            Error = True
            ErrorMessage = "ERROR IN TRUNCATING THE TABLE :: QUERY :: " + Query
            MessageLogger.info(ErrorMessage, exc_info=True)


        if Error is False:
            BCP = "bcp " + S1.CI_DB + "..ILPScheduleDetailsBAD_DUMP IN " + File + " -b 5000 -h TABLOCK " \
                    "-f " + dir_path + "MilkReplaySchedules.xml -e " + str(LogDir) + "Error1_in.log -o "  \
                    + str(LogDir) + "Output1_in.log -S " + S1.SERVERNAME + " -T -t , -F 2"

            MessageLogger.debug(BCP)
            try:
                MessageLogger.info("BCP START TIME::: " + str(datetime.datetime.now()))
                subprocess.run(BCP)
                readOutputBCPDetails(LogDir, MessageLogger)
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
        MessageLogger.error("ERROR IN ImportFileToDB BLOCK", e)

    return Error, ErrorMessage