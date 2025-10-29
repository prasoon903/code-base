class Dummy:

    def Dummy(self):
        from ConnectDB import ConnectDB
        import datetime

        print("Starting Connection.")
        Conn = ConnectDB()
        Test1 = Conn.ConnectDB()
        CI_DB = Conn.CI_DB


        if Test1 != "":
            res = ""
            print("Connection successful.")
            Command = "SELECT * from " + CI_DB + "..BSegment_Primary With (NoLock) where acctid = 5000"

            Command2 = "SELECT TOP 1 * FROM " + CI_DB + "..ClearingFiles WITH(NOLOCK) WHERE FileSource = 'CollateralID' AND " \
                  "FileStatus IN ('NEW','TNP','DONE')"

            Command3 = "INSERT INTO " + CI_DB + "..TEMP (FirstData, SecondData) VALUES (1, 2)"
            print(Command3)
            Test1.execute(Command3)
            # rows = len(Test1.fetchall())
            # print(rows)
            numrows = int(Test1.rowcount)
            print(numrows)
            # for r in res:
              #   print(r)

            if res == "":
                print("********************************************************")

        Path = "D:\SVN\CreditProcessing\Branch\CreditProcessing_15.00.09\Core\DSL\CI"

        import glob, os
        Path = Path + "\\"
        os.chdir(Path)
        for file in glob.glob("*"):
          print(file)

        import datetime
        LogDateTime = datetime.datetime.now()
        FileNameId = str(LogDateTime.strftime("%Y")) + str(LogDateTime.strftime("%m")) + str(
            LogDateTime.strftime("%d")) + str(LogDateTime.strftime("%M")) + str(
            LogDateTime.strftime("%S"))

        FileNameId1 = str(LogDateTime.strftime("%Y-%m-%d-%M-%S"))

        print(FileNameId)
        print(FileNameId1)



    Dummy(self=True)