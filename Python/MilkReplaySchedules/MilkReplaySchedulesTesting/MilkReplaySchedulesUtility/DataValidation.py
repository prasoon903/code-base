from ConnectDB import ConnectDB
from SetUp import SetUp as S1
from FileDetails import FileDetails


def DataValidation(FileID, FileName, MessageLogger):
    MessageLogger.info("INSIDE DataValidation BLOCK")
    Error = True
    RecordErrorCount = 0
    TotalRecords = 0
    ErrorFlag = 0
    SuccessfulRecords = 0
    RowCount = 0
    InsertedRowCount = 0
    FileDetailsEmailBody = ''
    ErrorMessage = ''

    try:

        Query = "EXEC " + S1.CI_DB + "..USP_ValidateRetailReplaySchedules '" + FileName + "', '" + FileID + "', " + str(S1.BatchCount) + ", " + str(S1.AccountNumberCheck)

        Connection = ConnectDB(MessageLogger)
        MessageLogger.debug(Query)

        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
            Error = False
        except Exception as e:
            Error = True
            MessageLogger.error("Error in executing USP_ValidateRetailReplaySchedules, Query:: " + Query + "\n" + e)

        if RowCount > 0:
            for r in Row:
                ErrorFlag = r.ErrorFlag
                TotalRecords = TotalRecords + int(r.RecordErrorCount)
                JobStatus = int(r.JobStatus)
                if JobStatus != 1:
                    RecordErrorCount = RecordErrorCount + int(r.RecordErrorCount)

            FileDetailsEmailBody = FileDetails(FileName, Row, MessageLogger)

            SuccessfulRecords = TotalRecords - RecordErrorCount

            if ErrorFlag == 0:
                ErrorMessage = 'No Error'
                MessageLogger.info("USP_ValidateRetailReplaySchedules executed successfully")
                Error = False
            elif ErrorFlag == 1:
                ErrorMessage = 'Error in validation'
                MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
            elif ErrorFlag == 2:
                ErrorMessage = 'Error in inserting records'
                MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
            elif ErrorFlag == 3:
                ErrorMessage = 'No record to update'
                MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)

            if SuccessfulRecords > 0 and ErrorFlag == 0:
                Query = "EXEC " + S1.CI_DB + "..USP_UpdateScheduleTypeOfBadSchedule '" + FileName + "', '" + FileID + "'"

                # MessageLogger.debug(Query)

                try:
                    Result = Connection.execute(Query)
                    InsertedRow = Result.fetchall()
                    InsertedRowCount = len(Row)
                    Error = False
                except Exception as e:
                    Error = True
                    MessageLogger.error("Error in executing USP_UpdateScheduleTypeOfBadSchedule, Query:: " + Query + "\n" + e)

                if InsertedRowCount > 0:
                    for r in InsertedRow:
                        ErrorFlag = r.ErrorFlag

                if ErrorFlag == 0:
                    ErrorMessage = 'No Error'
                    MessageLogger.info("USP_UpdateScheduleTypeOfBadSchedule executed successfully")
                    Error = False
                elif ErrorFlag == 1:
                    ErrorMessage = 'Error in inserting records'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 2:
                    ErrorMessage = 'Error in updating records'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
                elif ErrorFlag == 3:
                    ErrorMessage = 'No record to update'
                    MessageLogger.info('ErrorFlag: ' + str(ErrorFlag) + '::' + ErrorMessage)
            elif SuccessfulRecords <= 0:
                ErrorMessage = 'No new record to update'
                MessageLogger.info(ErrorMessage)
        else:
            Error = True
            ErrorMessage = 'Error in validating records'
            MessageLogger.info(ErrorMessage)


        Connection.close()

        MessageLogger.info("EXITING DataValidation BLOCK")

    except Exception as e:
        MessageLogger.error("ERROR IN DataValidation BLOCK", e)

    return Error, ErrorFlag, ErrorMessage, TotalRecords, SuccessfulRecords, RecordErrorCount, FileDetailsEmailBody