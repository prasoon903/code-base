import glob
import json
import os

from . import Splitter

# import Splitter

# from .Splitter import *
from .ExecutableFunctions import *
import time

RootPath = os.environ.get("RootPath")
# RootPath = f'E:\\Python\\BehaveBDD\\features'

Configuration = json.load(open(RootPath + "\Configuration/Configuration.json"))
folderPath = f"Rohit.Soni\\BackDatePayment"
RootPath = os.path.join(RootPath, folderPath) + "\\"
TestCasePath = f"Scenario"
output_folder = f"ConsolidatedScenario"
Output_path = os.path.join(RootPath, output_folder) + "\\"

KeywordCriteria = "Age system to"

input_path = os.path.join(RootPath, TestCasePath)
input_path = input_path + "\\"

print(input_path)
print(Output_path)


def fn_fileSplitter():
    if os.path.exists(input_path):
        LoopCount = 0
        os.chdir(input_path)
        for file in glob.glob("*.feature"):
            # fileName = file
            file_name_with_extension = os.path.basename(file)
            fileName, file_extension = os.path.splitext(file_name_with_extension)
            print(file)
            LoopCount += 1
            Splitter.split_file(
                fileName, input_path + file, KeywordCriteria, input_path, Output_path
            )


def fn_ExecuteSteps():
    if os.path.exists(Output_path):
        subfolders = [
            f
            for f in os.listdir(Output_path)
            if os.path.isdir(os.path.join(Output_path, f))
        ]
        subfolders.sort()

        # Print the list of subfolders
        for subfolder in subfolders:
            print(subfolder)
            current_folder = os.path.join(Output_path, subfolder) + "\\"
            os.chdir(current_folder)
            for file in glob.glob("*.feature"):
                fileName = file
                print(fileName)
                print("Now fetching the files from folder and execute steps one by one")
                os.chdir("E:\\Python\\BehaveBDD\\features")
                behaveCMD = f"behave {os.path.join(current_folder, fileName)} --no-capture --stop"
                print(behaveCMD)
                os.system(behaveCMD)

                print(
                    "After execution all the steps it is going to age the system to folder date "
                    + subfolder
                )

                Datetocheck = subfolder
                CurrentTnpDate = fn_GetCurrentCommonTNPDate()
                tnpdate = subfolder.split("-")
                Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
                fn_SetDateInTview(Month, Date, Year)
                while not (fn_checkAgingDate(Datetocheck)):
                    print("Aging is InProgress")
                    time.sleep(15)

                os.chdir(current_folder)
                # break


# fn_fileSplitter()
# fn_ExecuteSteps()
