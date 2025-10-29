def EmailBody_Error(FileName, TotalRecords, SuccessfulRecordsCount, ErrorRecordCount, ErrorReason, MessageLogger):
    MessageLogger.info("INSIDE EmailBody_Error BLOCK")
    try:
        EmailBody = "<tr>" \
                        "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                        "<td style=""color:red;""><b>ERROR</b></td>" \
                        "<td style=""color:green;"">" + str(TotalRecords) + "</td>" \
                        "<td style=""color:green;"">" + str(SuccessfulRecordsCount) + "</td>" \
                        "<td style=""color:red;"">" + str(ErrorRecordCount) + "</td>" \
                        "<td style=""color:red;"">" + str(ErrorReason) + "</td>" \
                    "</tr>"
        MessageLogger.info("EXITING EmailBody_Error BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN EmailBody_Error BLOCK", e)

    return EmailBody