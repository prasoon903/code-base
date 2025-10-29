import datetime
from GetOperatingServer import GetOperatingServer
from SetUp import SetUp as S1

def EmailStructure_Head(FileProcessingStartTime, OperatingServer, MessageLogger):
    MessageLogger.info("INSIDE EmailStructure_Head BLOCK")
    EmailHead = ''
    try:
        OperatingTime = FileProcessingStartTime.strftime('%m/%d/%Y %H:%M:%S')

        EmailHead = "<h4 style=""color:green;>Operating Sever: " + OperatingServer + "</h4>"
        EmailHead = EmailHead + "<h4 style=""color:Coral;>Server operating time: " + str(OperatingTime) + "</h4>"
        EmailHead = EmailHead + "<h4 style=""color:Indigo;>POD ID: " + str(S1.RetailFileProcessingPOD) + "</h4>"

        EmailHead  = EmailHead + \
                        "<table>" \
                        "<tr>" \
                            "<th><b>FileName</b></th>" \
                            "<th><b>FileStatus</b></th>" \
                            "<th><b>TotalRecords</b></th>" \
                            "<th><b>SuccessfulRecordsCount</b></th>" \
                            "<th><b>ErrorRecordCount</b></th>" \
                            "<th><b>ErrorReason</b></th>" \
                        "</tr>"
        MessageLogger.info("EXITING EmailStructure_Head BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN EmailStructure_Head BLOCK", e)

    return EmailHead