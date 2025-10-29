import csv
from SetUp import SetUp
import os
from Phase2 import RetailAuthorization
import glob

S1 = SetUp()

CI_DB = S1.CI_DB
CL_DB = S1.CL_DB
CAuth_DB = S1.CAuth_DB
SERVERNAME = S1.SERVERNAME
InputfilePath = S1.InputfilePath
DirectoryPath = S1.DirectoryPath

Message = ''


if InputfilePath != "":
    InputfilePath = InputfilePath + "\\"

if DirectoryPath != "":
    DirectoryPath = DirectoryPath + "\\"

def FileImport(MultiThreading, TestNumber, FileName):
    print(FileName)
    print(InputfilePath)
    # Directory = filePath + "TestNumber_" + str(TestNumber) + "/"
    Path = DirectoryPath + '/Account/'
    FilePath = InputfilePath + FileName
    print(Path)
    print(FilePath)
    AccountNumber = ''
    Count = 0
    ThreadCount = 0
    TotalCount = 0

    with open(FilePath) as file:
        while True:
            line = file.readline()
            if not line:
                break
            AccountNumber = line
            if MultiThreading:
                ThreadCount += 1
                if ThreadCount > 8:
                    ThreadCount = 1
                    Count += 1

            FileName = 'TestAccount_' + str(TestNumber) + '_' + str(Count) + '_' + str(ThreadCount) + '.txt'
            print(FileName)
            if MultiThreading:
                Count += 1
                if Count >= 8:
                    Count = 0
            else:
                Count += 1

            TotalCount += 1

            with open(os.path.join(Path, FileName), 'w') as File:
                File.write(AccountNumber)
                File.close()

    return TotalCount



if __name__ == "__main__":
    MultiThreading = 0
    TestNumber = 0
    TotalCount = 0
    while True:
        MultiThreading = int(input("MultiThreading (0 - NO / 1 - YES): "))
        if MultiThreading == 0 or MultiThreading == 1:
            break
        else:
            print("Please select valid option !")

    while True:
        TestNumber = int(input("TestNumber: "))
        if TestNumber > 0:
            break
        else:
            print("Please select valid option (greater than 0) !")


    if InputfilePath != "":
        DirectoryPath = DirectoryPath + "TestNumber_" + str(TestNumber)

        if not os.path.exists(DirectoryPath):
            print("Path doesn't exist. trying to make main directory")
            os.makedirs(DirectoryPath)

        AccountPath = DirectoryPath + "/Account"
        print(AccountPath)
        if not os.path.exists(AccountPath):
            print("Path doesn't exist. trying to make account folder")
            os.makedirs(AccountPath)

        # InputfilePath = filePath + "Input\\"
        os.chdir(InputfilePath)
        for file in glob.glob("*"):
            FileName = file
            print(FileName)
            TotalCount = FileImport(MultiThreading, TestNumber, FileName)

        if TotalCount > 0:
            '''
            AllActivityFilePath = DirectoryPath + "/Activity/"
            AllActivityFileName = "AllActivity.txt"
            # directoryPath = "TestNumber_" + str(TestNumber)            

            Activity = DirectoryPath + "/Activity"
            if not os.path.exists(Activity):
                print("Path doesn't exist. trying to make Activity folder")
                os.makedirs(Activity)

            with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
                ActivityFile.write(Message)
                ActivityFile.write("\n")
            ActivityFile.close()
            Message = ""
            '''

            print("TotalCount")
            print(TotalCount)
            print("Retail Auth starts...")
            RetailAuthorization(MultiThreading, TestNumber, TotalCount)

