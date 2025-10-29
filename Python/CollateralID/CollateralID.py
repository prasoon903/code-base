class CollateralID:

    def __init__(self):
        from SetUp import SetUp
        import datetime
        print("CollateralID")

        from email.mime.multipart import MIMEMultipart
        from email.mime.text import MIMEText
        import smtplib

        A1 = SetUp()
        self.InputDir = A1.CIBUpdateInputFile
        self.OutputDir = A1.CIBUpdateOutFile
        self.ErrorDir = A1.CIBUpdateErrorFile
        self.LogFolder = A1.CIBUpdateLogFile
        self.ProcessedDir = A1.CIBUpdateProcessedFile
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
        self.ErrorCountForFile = 0
        self.Message = ""

        self.Abort = False

        if self.InputDir != "":
            self.InputDir = self.InputDir + "\\"
        else:
            self.Message = "Environment variable CIBUpdateInputFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.OutputDir != "":
            self.OutputDir = self.OutputDir + "\\"
        else:
            self.Message = "Environment variable CIBUpdateOutFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.ErrorDir != "":
            self.ErrorDir = self.ErrorDir + "\\"
        else:
            self.Message = "Environment variable CIBUpdateErrorFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.LogFolder != "":
            self.LogFolder = self.LogFolder + "\\"
        else:
            self.Message = "Environment variable CIBUpdateLogFile is not set. Aborting ..."
            print(self.Message)
            self.Abort = True
        if self.ProcessedDir != "":
            self.ProcessedDir = self.ProcessedDir + "\\"
        else:
            self.Message = "Environment variable CIBUpdateProcessedFile is not set. Aborting ..."
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

        self.LogFileName = self.LogFolder + "CIBUpdateLogFolder" + str(self.LogDateTime.strftime("%Y%m%d%M%S")) + ".log"

    def ConnectDB(self):
        if self.Abort is False:
            import pyodbc
            self.con = pyodbc.connect(p_str=True,
                                      driver="{SQL Server}",
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

    def GetProcDayEnd(self):
        from datetime import datetime
        SQL = "SELECT CONVERT(VARCHAR(10),ProcDayEnd ,111) +' ' +CONVERT(VARCHAR(10),GETDATE()  ,14) " \
              " AS ProcDayEnd FROM " + self.CI_DB + "..ARSystemAccounts  A WITH(NOLOCK) " +  \
              "join " + self.CI_DB + "..org_balances O with (nolock) on " \
              "(A.acctid = o.arsystemacctid) where o.acctid = " + str(self.InstitutionID)

        self.Message = SQL
        self.LogMessage()

        connection = self.ConnectDB()
        row = connection.execute(SQL)
        for r in row:
            p = str(r)

        p = p[2:len(p) - 4]
        # print(p)
        self.ProcDayEnd = datetime.strptime(p, '%Y/%m/%d %H:%M:%S:%f')
        self.Message = str(self.ProcDayEnd)
        self.LogMessage()

        connection.close()

        return self.ProcDayEnd

    def GetNumberOfBlocks(self, FileName):
        from pathlib import Path
        FilePath = Path(self.OutputDir + FileName)
        if FilePath.is_file():
            self.Abort = True
            self.Message = "File " + FileName + " is already present in OUTPUT folder. So it can not be processed."
            self.LogMessage()
            print(self.Message)
        if self.Abort is False:
            SQL = "SELECT TOP 1 * FROM " + self.CI_DB + "..ClearingFiles WITH(NOLOCK) " \
                   "WHERE FileSource = 'CollateralID' AND FileStatus IN " \
                        "('NEW','TNP','DONE') AND ClearingFileName = '" + FileName + "' " \
                            "AND Institutionid = " + str(self.InstitutionID)

            # print(SQL)
            connection = self.ConnectDB()
            Records = connection.execute(SQL)
            FileProcessed = len(Records.fetchall())

            connection.close()

            if FileProcessed > 0:
                self.Message = "File " + FileName + " has already been processed. So it can not be processed."
                self.LogMessage()
                self.Abort = True
                print(self.Message)

    def InsertIntoClearingFiles(self, FileName, FileNameId):
        self.Message = "Inside InsertIntoClearingFiles"
        self.LogMessage()

        InputFileName = FileName
        InputFileName = InputFileName.replace(".csv", "")
        # print(InputFileName)

        # FileNameId = str(self.LogDateTime.strftime("%Y%m%d%M%S"))
        DateReceived = str(self.LogDateTime.strftime("%Y-%m-%d"))

        self.Message = FileNameId + "\n" + DateReceived
        self.LogMessage()

        Date = str(self.ProcDayEnd.strftime("%Y-%m-%d %H:%M:%S"))
        # print(Date)

        if self.Abort is False:
            FileStatus = "NEW"
            InputFilePath = self.OutputDir + FileName
        else:
            FileStatus = "Error"
            InputFilePath = self.ErrorDir + FileName
            self.Abort = True

        InsertString = " INSERT INTO " + self.CI_DB + "..ClearingFiles (FileId, Path_FileName, " \
                                                      "FileStatus,Date_Received,  FileSource, " \
                       "ProcDateTime_Received,ClearingFileName, InstitutionId)"

        # print(InsertString)
        InsertString = InsertString + " Values ('" + FileNameId + "', '" + InputFilePath + "', '" + FileStatus + "', '" + \
                       DateReceived + "', 'CollateralID'" + ", '" + Date + "', '" + FileName + "', " + \
                       str(self.InstitutionID) + ")"

        # print(InsertString)
        self.Message = InsertString
        self.LogMessage()
        connection = self.ConnectDB()
        connection.execute(InsertString)
        Rows = int(connection.rowcount)

        if Rows <= 0:
            self.Abort = True
        else:
            self.Message = "Clearing File Job inserted."
            self.LogMessage()
            connection.commit()

        connection.commit()
        connection.close()

    def ImportFiletoDB(self, FileName):
        if self.Abort is False:
            import csv
            import os
            import sys
            Rows = 0
            File = self.InputDir + FileName
            self.Message = File
            self.LogMessage()

            csvFile = open(File, "r")
            csvData = csv.reader(csvFile)
            next(csvData, None)

            connection = self.ConnectDB()
            print("RecordCount: \r")

            for row in csvData:
                # print(row)
                Query = "INSERT INTO " + self.CI_DB + "..CollateralID_BulkUpdate (AccountNumber," \
                                                           "InstitutionID,OldCollateralID,NewCollateralID," \
                                                           "LetterIndicator)" " VALUES (?, ?, ?, ?, ?)"

                # print(Query)

                connection.execute(Query, row)
                # connection.commit()
                Rows = Rows + 1
                sys.stdout.write("\r" + str(Rows))
                sys.stdout.flush()
            """
            Query = "bcp " + self.CI_DB + "..CollateralID_BulkUpdate IN '" + File + "' -b 5000 -h TABLOCK  " \
                     "-f ./CollateralID_BulkUpdate.xml -e '" + self.LogFolder + "Error1_in.log' -o '" \
                    + self.LogFolder + "Output1_in.log' -S " + self.SERVERNAME + " -T -t , -F 2"

            print(Query)
            self.Message = Query
            self.LogMessage()
            os.popen(Query)
            """
            print("\n")
            Rows = int(connection.rowcount)

            if Rows <= 0:
                self.Abort = True
                self.Message = "Not able to write the file"
                self.LogMessage()
            else:
                self.Message = "Bulk Insert Successful"
                self.LogMessage()
                # connection.commit()

            connection.commit()
            connection.close()

    def DataValidation(self, FileID, FileName):
        self.Message = "Executing USP_CollateralIDUpdate"
        self.LogMessage()

        SQL = "Exec " + self.CI_DB + "..USP_CollateralIDUpdate " + FileID + ", '" + FileName + "'"

        self.Message = SQL
        self.LogMessage()

        connection = self.ConnectDB()
        Result = connection.execute(SQL)
        connection.commit()

        # Row = Result.fetchall()
        RowCount = 1# len(Row)

        if RowCount > 0:
            self.Message = "USP_CollateralIDUpdate executed successfully."
            self.LogMessage()
            for r in Result:
                self.Error = r.fileerror
                self.ErrorCountForFile = r.ErrorCount
                self.SuccessCount = r.SuccessCount
                self.TotalCount = r.TotalCount

            self.Message = "Error flag after: " + str(self.Error)
            self.LogMessage()
            self.Message = "ErrorCountForFile flag after: " + str(self.ErrorCountForFile)
            self.LogMessage()
            self.Message = "SuccessCount flag after: " + str(self.SuccessCount)
            self.LogMessage()
            self.Message = "TotalCount flag after: " + str(self.TotalCount)
            self.LogMessage()
        else:
            self.Abort = True

        # connection.commit()
        connection.close()

    def ExportToCSV(self, TableName, FileName):
        import csv
        Query = "SELECT * FROM " + self.CI_DB + ".." + TableName + " WITH (NOLOCK)"

        connection = self.ConnectDB()
        Result = connection.execute(Query)

        Row = Result.fetchall()
        if len(Row) > 0:
            with open(self.ProcessedDir + FileName + ".csv", 'wb') as File:
                writer = csv.writer(File)

            for value in Row:
                writer.writerow([value])
        else:
            self.Abort = True

        connection.close()

    def SendMail(self, EMailSubject, EmailBody):
        import smtplib
        from email.mime.multipart import MIMEMultipart
        from email.mime.text import MIMEText
        from email.message import EmailMessage

        Body = MIMEText(EmailBody, 'html')

        # msg = EmailMessage()
        msg = MIMEMultipart('alternative')
        msg['Subject'] = EMailSubject
        msg['From'] = self.eMailFrom
        msg['To'] = self.eMailTo
        msg.attach(Body)

        server = smtplib.SMTP(self.SMTP_SERVER, self.SMTPPORT)
        # server.sendmail(self.eMailFrom, self.eMailTo, message)
        server.send_message(msg)
        print("Sending mail...")
        server.quit()

    def main(self):
        import glob
        import os
        import shutil

        print(self.Message)
        self.LogMessage()
        LoopCount = 0
        if self.Abort is False:
            self.Message = "CollateralID Bulk Update Process Started..."
            print(self.Message)
            self.LogMessage()

            EmailBody = "<table border=""1""><tr><td><bold>FileName</bold></td><td><bold>FileStatus</bold>" \
                                    "</td><td><bold>TotalCount</bold></td><td><bold>SuccessCount</bold></td><td>" \
                                    "<bold>ErrorCountForFile</bold></td></tr>"

            EMailSubject = "Alert | CollateralID_BulkUpdate File Processing"

            Path = self.InputDir
            print(Path)
            os.chdir(Path)

            for file in glob.glob("*"):
                print(file)
                FileName = file
                self.Message = "********************" + FileName + "*****************************"
                print(self.Message)
                self.LogMessage()
                LoopCount = LoopCount + 1
                FileNameId = str(self.LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
                self.Abort = False
                if self.Abort is False:
                    self.ProcDayEnd = self.GetProcDayEnd()
                    print(self.ProcDayEnd)
                    self.GetNumberOfBlocks(FileName)
                    if self.Abort is True:
                        shutil.move(self.InputDir + FileName, self.ErrorDir + FileName)
                    else:
                        self.ImportFiletoDB(FileName)
                        if self.Abort is False:
                            self.InsertIntoClearingFiles(FileName, FileNameId)
                            if self.Abort is False:
                                # FileNameId = str(self.LogDateTime.strftime("%Y%m%d%M%S")) + str(LoopCount)
                                # print(FileNameId)
                                # print(LoopCount)
                                self.DataValidation(FileNameId, FileName)
                                if self.Abort is False:
                                    shutil.move(self.InputDir + FileName, self.OutputDir + FileName)
                                    if self.TotalCount > 0:
                                        ProcessedFileName = "Processed_" + FileName
                                        TableName = "Collateral_BulkUpdate_Processed"
                                        self.ExportToCSV(TableName, ProcessedFileName)
                                else:
                                    shutil.move(self.InputDir + FileName, self.ErrorDir + FileName)

                if self.Abort is False:
                    EmailBody = EmailBody + "<tr><td>" + FileName + "</td><td bgcolor = ""green"">Success</td>" \
                                "<td bgcolor = ""green"">" + str(self.TotalCount) + "</td><td bgcolor = ""green"">" \
                                + str(self.SuccessCount) + "</td><td bgcolor = ""red"">" + str(self.ErrorCountForFile)\
                                + "</td></tr>"
                else:
                    EmailBody = EmailBody + "<tr><td>" + FileName + "</td><td bgcolor = ""red"">Error</td>" \
                                "<td bgcolor = ""green"">" + str(self.TotalCount) + "</td><td bgcolor = ""green"">"\
                                + str(self.SuccessCount) + "</td><td bgcolor = ""red"">" + str(self.ErrorCountForFile)\
                                + "</td></tr>"

            EmailBody = EmailBody + "</table>"

            if LoopCount == 0:
                EmailBody = "<h3 bgcolor = ""red"">No file Present in CollateralID_BulkUpdate folder</h3>"

            EmailBody = "<html>" + EmailBody + "</html>"

            self.SendMail(EMailSubject, EmailBody)

        if LoopCount == 0:
            self.Message = "********************" + "No file Exists... Exiting" + "*****************************"
            print(self.Message)
            self.LogMessage()
        else:
            self.Message = "********************" + "All files processed... Exiting" + "*****************************"
            print(self.Message)
            self.LogMessage()


CID = CollateralID()
CID.main()



