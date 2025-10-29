def FileDetails(FileName, Row, MessageLogger):
    MessageLogger.info("INSIDE FileDetails BLOCK")
    FileDetailsEmailBody = ''
    try:
        FileDetailsEmailBody = "<p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"
        Count = 0

        FileDetailsEmailBody = FileDetailsEmailBody + \
                                "<table>" \
                                "<tr>" \
                                    "<th><b>S.No.</b></th>" \
                                    "<th><b>ErrorMessage</b></th>" \
                                    "<th><b>RecordCount</b></th>" \
                                "</tr>"

        for r in Row:
            Count += 1
            ErrorMessage = str(r.ValidationMessage)
            RecordCount = str(r.RecordErrorCount)

            FileDetailsEmailBody = FileDetailsEmailBody + " \
                                    ""<tr>" \
                                        "<td>" + str(Count) + "</td>" \
                                        "<td>" + ErrorMessage + "</td>" \
                                        "<td><b>" + RecordCount + "</b></td>" \
                                    "</tr>"

        FileDetailsEmailBody = FileDetailsEmailBody + "</table>"

        MessageLogger.info("EXITING FileDetails BLOCK")
    except Exception as e:
        MessageLogger.error("ERROR IN FileDetails BLOCK", e)

    return FileDetailsEmailBody