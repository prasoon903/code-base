'''
=============================================
Author:    Prasoon Parashar
Create date:  11/16/2018
Description:  Cookie - 8808	 | Plat - Make the Payment OTB hold after the Payment variable at the Account Level.
=============================================
'''

class IntraDayAccountOTBRule:

    def __init__(self):
        from SetUp import SetUp
        import os
        import datetime
        print("IntraDayAccountOTBRule")

        A1 = SetUp()
        self.InputDir = A1.POTBInputFile
        self.OutputDir = A1.POTBOutFile
        self.ErrorDir = A1.POTBErrorFile
        self.LogFolder = A1.POTBLogFile
        self.InstitutionID = A1.InsitutionID
        self.SMTP_SERVER = A1.SMTP_SERVER
        self.SMTPPORT = A1.SMTPPORT
        self.eMailFrom = A1.MailFrom
        self.eMailTo = A1.MailTo
        self.SERVERNAME = A1.SERVERNAME
        self.CI_DB = A1.CI_DB
        self.CL_DB = A1.CL_DB
        self.Error = 0
        self.TotalCount = 0
        self.SuccessCount = 0
        self.ErrorCountForAccountFile = 0
        self.ArchiveCount = 0
        self.notprocessedCount = 0
        self.Message = ""
        self.ErrorReason = ""
        self.dir_path = os.getcwd()

        self.dir_path = str(self.dir_path) + "\\"
        print("Working directory...")
        print(self.dir_path)

        self.Abort = False

        if self.InputDir != "":
            self.InputDir = self.InputDir + "\\"
        else:
            self.Message = "Environment variable POTBInputFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.OutputDir != "":
            self.OutputDir = self.OutputDir + "\\"
        else:
            self.Message = "Environment variable POTBOutFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.ErrorDir != "":
            self.ErrorDir = self.ErrorDir + "\\"
        else:
            self.Message = "Environment variable POTBErrorFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.LogFolder != "":
            self.LogFolder = self.LogFolder + "\\"
        else:
            self.Message = "Environment variable POTBLogFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.InstitutionID != "":
            self.InstitutionID = self.InstitutionID
        else:
            self.Message = "Environment variable InstitutionID is not set. Aborting ..."
            print(self.Message)
            self.Abort = True

        if self.Abort is False:
            self.Message = "Environment variables are set."

        self.LogDateTime = datetime.datetime.now()
        self.ProcDayEnd = self.LogDateTime

        self.LogFileName = self.LogFolder + "Log" + str(self.LogDateTime.strftime("%Y%m%d%M%S")) + ".log"

    def ConnectDB(self):
        if self.Abort is False:
            import pyodbc
            self.con = pyodbc.connect(p_str=True,
                                      driver="{ODBC Driver 13 for SQL Server}",
                                      server=self.SERVERNAME,
                                      Trusted_Connection='yes')
            self.cur = self.con.cursor()

            if self.cur == "":
                self.Abort = True
            return self.cur

    def LogMessage(self):
        with open(self.LogFileName, 'a+') as LogFile:
            LogFile.write(self.Message)
            LogFile.write("\n")

    def ImportFiletoDB(self, FileName):
        if self.Abort is False:
            # import csv
            import os
            import subprocess
            import datetime
            # Rows = 0
            File = self.InputDir + FileName
            self.Message = File
            self.LogMessage()

            # csvFile = open(File, "r")
            # csvData = csv.reader(csvFile)
            # next(csvData, None)

            connection = self.ConnectDB()

            """
            for row in csvData:
                # print(row)
                Query = "INSERT INTO " + self.CI_DB + "..IntraDayAccountOTBRule_External (UniversalUniqueID," \
                         "InstitutionID,IntradayThreshholdAmount,HeldDays_LessThanIntradayThreshhold," \
                           "HeldDays_GreaterThanIntradayThreshhold,StartDate,Transactioncode)" \
                                                      " VALUES (?, ?, ?, ?, ?, ?, ?)"

                # print(Query)

                connection.execute(Query, row)
                connection.commit()
                Rows = Rows + 1
                sys.stdout.write("\r" + str(Rows))
                
                sys.stdout.flush()
            """
            Query = "bcp " + self.CI_DB + "..IntraDayAccountOTBRule_External IN " + File + " -b 5000 -h TABLOCK " \
                     "-f " + self.dir_path + "IntraDayAccountOTB.xml -e " + str(self.LogFolder) + "Error1_in.log -o "  \
                    + str(self.LogFolder) + "Output1_in.log -S " + self.SERVERNAME + " -T -t , -F 2"

            # print(Query)
            # self.Message = Query
            # self.LogMessage()
            subprocess.run(Query)
            connection.commit()

            self.Message = "Record Insert Time:::" + str(datetime.datetime.now())
            print(self.Message)
            self.LogMessage()

            # Rows = int(connection.rowcount)

            """
            if Rows <= 0:
                self.Abort = True
                self.Message = "Not able to write the file"
                self.ErrorReason = " Format of file is not correct "
                self.LogMessage()
            else:
                self.Message = "Bulk Insert Successful"
                self.LogMessage()
                connection.commit()
            """
            connection.close()

    def GetNumberOfBlocks(self, FileName):
        from pathlib import Path
        FilePath = Path(self.OutputDir + FileName)
        if FilePath.is_file():
            self.Abort = True
            self.Message = "File " + FileName + " is already present in OUTPUT folder. So it can not be processed."
            print(self.Message)
            self.ErrorReason = "Duplicate File"
            self.LogMessage()
        if self.Abort is False:
            SQL = "Select FileID from " + self.CI_DB + "..AdvPromoTargetListFile with(nolock) where FileName = '" \
                  + FileName + "' and (Status = 'DONE' or Status = 'NEW' )"

            # print(SQL)
            # self.Message = SQL
            # self.LogMessage()
            connection = self.ConnectDB()
            Records = connection.execute(SQL)
            FileProcessed = len(Records.fetchall())

            connection.close()

            if FileProcessed > 0:
                self.Message = "File " + FileName + " has already been processed. So it can not be processed."
                print(self.Message)
                self.ErrorReason = "Duplicate File"
                self.LogMessage()
                self.Abort = True

    def DataValidation(self, FileID, FileName):
        import datetime
        self.Message = "Executing USP_InsertInto_IntraDayAccountOTBRule_Internal"
        self.LogMessage()

        SQL = "Exec " + self.CI_DB + "..USP_InsertInto_IntraDayAccountOTBRule_Internal '" + FileID + "', '" \
                                                                    + FileName + "' ," + str(self.InstitutionID)

        self.Message = SQL
        self.LogMessage()

        connection = self.ConnectDB()
        connection.commit()
        Result = connection.execute(SQL)

        Row = Result.fetchall()
        RowCount = len(Row)

        if RowCount > 0:
            self.Message = "USP_InsertInto_IntraDayAccountOTBRule_Internal executed successfully."
            self.LogMessage()
            for r in Row:
                self.Error = r.fileerror
                self.ErrorCountForAccountFile = r.ErrorCount
                self.SuccessCount = r.SuccessCount
                self.ArchiveCount = r.ArchiveCount
                self.notprocessedCount = r.notprocessedCount
                self.TotalCount = r.TotalCount

            self.Message = "Error flag after: " + str(self.Error)
            self.LogMessage()
            self.Message = "ErrorCountForFile flag after: " + str(self.ErrorCountForAccountFile)
            self.LogMessage()
            self.Message = "SuccessCount flag after: " + str(self.SuccessCount)
            self.LogMessage()
            self.Message = "ArchiveCount flag after: " + str(self.ArchiveCount)
            self.LogMessage()
            self.Message = "notprocessedCount flag after: " + str(self.notprocessedCount)
            self.LogMessage()
            self.Message = "TotalCount flag after: " + str(self.TotalCount)
            self.LogMessage()
        else:
            self.Abort = True

        # print(self.Error)
        self.Message = self.Message + "\n USP_InsertInto_IntraDayAccountOTBRule_Internal Finish Time:::" + \
                       str(datetime.datetime.now())
        # print(self.Message)
        self.LogMessage()

        print("Total records count:::")
        print(self.TotalCount)

        if self.ErrorCountForAccountFile > 0:
            self.ErrorReason = "Error in records."

        if self.Error != 0:
            self.Abort = True
        else:
            self.Message = "Executing USP_Archiveintradayaccountotbrule_Internal"
            self.LogMessage()

            SQL = "Exec " + self.CI_DB + "..USP_Archiveintradayaccountotbrule_Internal"

            connection.execute(SQL)
            connection.commit()
            self.Message = self.Message + "\n USP_Archiveintradayaccountotbrule_Internal Finish Time:::" + \
                           str(datetime.datetime.now())
            # print(self.Message)
            self.LogMessage()

        connection.close()

    def FileDetails(self, FileName):
        self.Message = "Executing query to find file details."
        self.LogMessage()
        SendFileDetails = False

        FileDetailsEmailBody = "<p style=""color:blue;""><b>File Name:</b> " + FileName + "</p>"

        FileDetailsEmailBody = FileDetailsEmailBody + \
                               "<table>" \
                               "<tr>" \
                                   "<td><b>HeldDays_LessThanIntradayThreshold</b></td>" \
                                   "<td><b>HeldDays_GreaterThanIntradayThreshold</b></td>" \
                                   "<td><b>RecordCount</b></td>" \
                               "</tr>"

        Query = "SELECT COUNT(1) AS RecordCount, HeldDays_LessThanIntradayThresHhold AS LessDays, " \
                "HeldDays_GreaterThanIntradayThreshhold AS GreaterDays FROM " + self.CI_DB + "..IntradayAccountOTBRule_Internal " \
                "WITH (NOLOCK) GROUP BY HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold, " \
                "FileName HAVING FileName = '" + FileName + "'"

        self.Message = Query
        self.LogMessage()

        connection = self.ConnectDB()
        Result = connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)

        if RowCount > 0:
            SendFileDetails = True

        for r in Row:
            RecordCount = r.RecordCount
            HeldDays_LessThanIntradayThreshhold = r.LessDays
            HeldDays_GreaterThanIntradayThreshhold = r.GreaterDays

            FileDetailsEmailBody = FileDetailsEmailBody + " \
                                    ""<tr>" \
                                        "<td>" + str(HeldDays_LessThanIntradayThreshhold) + "</td>" \
                                        "<td>" + str(HeldDays_GreaterThanIntradayThreshhold) + "</td>" \
                                        "<td><b>" + str(RecordCount) + "</b></td>" \
                                    "</tr>"

        if SendFileDetails:
            FileDetailsEmailBody = FileDetailsEmailBody + "</table>"
        else:
            FileDetailsEmailBody = ""

        connection.close()
        return FileDetailsEmailBody

    def SendMail(self, EMailSubject, EmailBody):
        import smtplib
        from email.mime.multipart import MIMEMultipart
        from email.mime.text import MIMEText
        from email.message import EmailMessage

        Body = MIMEText(EmailBody, 'html')
        # self.Message = EmailBody
        # self.LogMessage()

        # msg = EmailMessage()
        msg = MIMEMultipart('alternative')
        msg['Subject'] = EMailSubject
        msg['From'] = self.eMailFrom
        msg['To'] = self.eMailTo
        msg.attach(Body)

        server = smtplib.SMTP(self.SMTP_SERVER, self.SMTPPORT)
        # server.sendmail(self.eMailFrom, self.eMailTo, message)
        self.Message = "Sending mail..."
        print(self.Message)
        self.LogMessage()
        server.send_message(msg)
        server.quit()

    def main(self):
        import glob
        import os
        import shutil
        import datetime

        print(self.Message)
        self.LogMessage()
        LoopCount = 0
        if self.Abort is False:
            self.Message = "START PROCESSING ................................................"
            self.Message = self.Message + "\n Start Time:::" + str(self.LogDateTime)
            print(self.Message)
            self.LogMessage()
            FileRecordDetails = ""

            EmailBody = "<table>" \
                        "<tr>" \
                            "<td><b>FileName</b></td>" \
                            "<td><b>FileStatus</b></td>" \
                            "<td><b>TotalRecord</b></td>" \
                            "<td><b>SuccessCount</b></td>" \
                            "<td><b>ErrorCountForAccountFile</b></td>" \
                            "<td><b>ArchiveCount</b></td>" \
                            "<td><b>NotProcessedCount</b></td>" \
                            "<td><b>ErrorReason</b></td>" \
                        "</tr>"

            EMailSubject = "Alert | PLAT :: Account level payment hold File Processing"

            Path = self.InputDir
            print(Path)
            os.chdir(Path)

            for file in glob.glob("*"):
                # print(file)
                FileName = file
                self.ErrorReason = ""
                self.Message = "********************" + FileName + "*****************************"
                print(self.Message)
                self.LogMessage()
                LoopCount = LoopCount + 1
                FileNameId = str(self.LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
                self.Abort = False
                if self.Abort is False:
                    self.GetNumberOfBlocks(FileName)
                    if self.Abort is True:
                        shutil.move(self.InputDir + FileName, self.ErrorDir + FileName)
                    else:
                        self.ImportFiletoDB(FileName)
                        if self.Abort is False:
                            # print(FileNameId)
                            # print(LoopCount)
                            self.DataValidation(FileNameId, FileName)
                            if self.Abort is False:
                                shutil.move(self.InputDir + FileName, self.OutputDir + FileName)
                            else:
                                shutil.move(self.InputDir + FileName, self.ErrorDir + FileName)

                if self.Abort is False:
                    EmailBody = EmailBody + \
                                "<tr>" \
                                    "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                    "<td style=""color:green;""><b>Success</b></td>" \
                                    "<td style=""color:green;"">" + str(self.TotalCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(self.SuccessCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(self.ErrorCountForAccountFile) + "</td>" \
                                    "<td style=""color:green;"">" + str(self.ArchiveCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(self.notprocessedCount) + "</td>" \
                                    "<td style=""color:green;"">No error found</td>" \
                                "</tr>"
                else:
                    EmailBody = EmailBody + \
                                "<tr>" \
                                    "<td style=""color:blue;""><b>" + FileName + "<b></td>" \
                                    "<td style=""color:red;""><b>Error</b></td>" \
                                    "<td style=""color:green;"">" + str(self.TotalCount) + "</td>" \
                                    "<td style=""color:green;"">" + str(self.SuccessCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(self.ErrorCountForAccountFile) + "</td>" \
                                    "<td style=""color:green;"">" + str(self.ArchiveCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(self.notprocessedCount) + "</td>" \
                                    "<td style=""color:red;"">" + str(self.ErrorReason) + "</td>" \
                                "</tr>"

                if self.Abort is False:
                    FileRecordDetails = FileRecordDetails + self.FileDetails(FileName)

            EmailBody = EmailBody + "</table>"
            EmailBody = EmailBody + FileRecordDetails

            if LoopCount == 0:
                EmailBody = "<h3 style=""color:red;"">No file Present in Input folder</h3>"

            currentYear = str(self.LogDateTime.strftime("%Y"))
            Footer = "<div class=\"footer\">" \
                        "<footer>" \
                            "<small>&copy; Copyright " + currentYear +", CoreCard Software, Inc. All rights reserved</small>" \
                        "</footer>" \
                    "</div>"

            EmailBody = EmailBody + Footer

            StyleBody = "<style>" \
                        "table, th {"\
                          "border: 2px solid black;" \
                          "border-collapse: collapse;" \
                        "}" \
                        "td {" \
                          "border: 1px solid black;" \
                          "border-collapse: collapse;" \
                        "}" \
                        ".footer {" \
                        "position: fixed;" \
                        "left: 0;" \
                        "bottom: 0;" \
                        "width: 100%;" \
                        "background-color: grey;" \
                        "color: white;" \
                        "text-align: center;" \
                        "}" \
                        "</style>"

            EmailBody = StyleBody + "<html>" + EmailBody + "</html>"

            self.SendMail(EMailSubject, EmailBody)

        if LoopCount == 0:
            self.Message = "********************" + "No file Exists... Exiting" + "*****************************"
            self.Message = self.Message + "\n Finish Time:::" + str(datetime.datetime.now())
            print(self.Message)
            self.LogMessage()
        else:
            self.Message = "********************" + "All files processed... Exiting" + "*****************************"
            self.Message = self.Message + "\n Finish Time:::" + str(datetime.datetime.now())
            print(self.Message)
            self.LogMessage()


PH = IntraDayAccountOTBRule()
PH.main()
