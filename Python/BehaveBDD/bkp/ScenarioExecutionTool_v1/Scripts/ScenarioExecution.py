import glob
import shutil
from threading import Thread
import Scripts.Config as c
import Scripts.Splitter
from Scripts import Splitter
# from Scripts.Logger import get_logger
# from .Splitter import *
from Scripts.ExecutableFunctions import *
import time
from Scripts.GetLogger import MessageLogger


# LogDateTime = datetime.datetime.now()

# RootPath = os.environ.get("RootPath")
# RootPath = f'E:\\Python\\BehaveBDD\\features'
RootPath = c.BasePath

# log_folder = os.path.join(c.BasePath, "LOG") + "\\"
#
# LOG_FILE = log_folder + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"
# MessageLogger = get_logger(LOG_FILE)

# Configuration = json.load(open(RootPath + "\Configuration/Configuration.json"))
Configuration = c.Configuration
folderPath = f"FeatureFiles"
RootPath = os.path.join(RootPath, folderPath) + "\\"
TestCasePath = f"Scenario\\Input"
output_folder = f"ConsolidatedScenario"
Output_path = os.path.join(RootPath, output_folder) + "\\"
MultiThread = Configuration["MultiThread"]

KeywordCriteria = "Age system to"

input_path = os.path.join(RootPath, TestCasePath)
input_path = input_path + "\\"
MessageLogger.info("I have started execution")
MessageLogger.info(input_path)
MessageLogger.info(Output_path)
FileInProcess = []


def fn_fileSplitter():
    MessageLogger.info("Inside fn_fileSplitter")
    if os.path.exists(input_path):
        LoopCount = 0
        os.chdir(input_path)
        for file in glob.glob("*.feature"):
            # fileName = file
            file_name_with_extension = os.path.basename(file)
            fileName, file_extension = os.path.splitext(file_name_with_extension)
            MessageLogger.info(file)
            LoopCount += 1
            Splitter.split_file(fileName, input_path + file, KeywordCriteria, input_path, Output_path)
            shutil.move(input_path+file, os.path.join(RootPath, f"Scenario\\Output") + "\\")
            # MessageLogger.info(LoopCount)
            # if LoopCount == 10:
            #     break


def fn_ProcessFile(current_folder, fileName, processIndicator, workingThread):
    MessageLogger.info("Inside fn_ProcessFile")
    MessageLogger.info("workingThread: " + str(workingThread))
    MessageLogger.info("processIndicator: " + str(processIndicator))
    MessageLogger.info("fileName: " + fileName)
    if processIndicator:
        if fileName not in FileInProcess:
            behaveCMD = f"behave {os.path.join(current_folder, fileName)} --no-capture --stop"
            MessageLogger.info(behaveCMD)
            FileInProcess.append(fileName)
            os.system(behaveCMD)
            shutil.move(os.path.join(current_folder, fileName), os.path.join(current_folder, f"Processed") + "\\")
        else:
            MessageLogger.info(f"{fileName} is already in process")
    else:
        MessageLogger.info("No file need to process via this thread")


def fn_ExecuteSteps():
    MessageLogger.info("Inside fn_ExecuteSteps")
    if os.path.exists(Output_path):
        subfolders = [
            f
            for f in os.listdir(Output_path)
            if os.path.isdir(os.path.join(Output_path, f))
        ]
        subfolders.sort()
        LoopCount = 0

        # MessageLogger.info the list of subfolders
        for subfolder in subfolders:
            MessageLogger.info(subfolder)
            current_folder = os.path.join(Output_path, subfolder) + "\\"
            os.chdir(current_folder)
            if MultiThread == "1":
                files = [
                    file
                    for file in glob.glob("*.feature")
                ]
                MessageLogger.info("Multithreading environment")
                os.chdir(RootPath)
                totalFiles = len(files)
                MaxThreads = 8
                # threadRequired = totalFiles / MaxThreads + 1
                TotalExecutionLoop = int(totalFiles / MaxThreads) + 1

                for Loop in range(TotalExecutionLoop):
                    t1 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+0 if MaxThreads*Loop+0 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 1,))
                    t2 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+1 if MaxThreads*Loop+1 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 2,))
                    t3 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+2 if MaxThreads*Loop+2 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 3,))
                    t4 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+3 if MaxThreads*Loop+3 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 4,))
                    t5 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+4 if MaxThreads*Loop+4 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 5,))
                    t6 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+5 if MaxThreads*Loop+5 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 6,))
                    t7 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+6 if MaxThreads*Loop+6 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 7,))
                    t8 = Thread(target=fn_ProcessFile, args=(current_folder, files[MaxThreads*Loop+7 if MaxThreads*Loop+7 < totalFiles else MaxThreads*Loop], True if MaxThreads*Loop+0 < totalFiles else False, 8,))

                    t1.start()
                    t2.start()
                    t3.start()
                    t4.start()
                    t5.start()
                    t6.start()
                    t7.start()
                    t8.start()

                    t1.join()
                    t2.join()
                    t3.join()
                    t4.join()
                    t5.join()
                    t6.join()
                    t7.join()
                    t8.join()
            else:
                for file in glob.glob("*.feature"):
                    LoopCount += 1
                    fileName = file
                    MessageLogger.info(fileName)
                    MessageLogger.info("Now fetching the files from folder and execute steps one by one")
                    os.chdir(RootPath)
                    MessageLogger.info("Single threaded environment")
                    # behaveCMD = f"behave {os.path.join(current_folder, fileName)} --no-capture --stop"
                    # MessageLogger.info(behaveCMD)
                    # os.system(behaveCMD)
                    # shutil.move(os.path.join(current_folder, fileName),
                    # os.path.join(current_folder, f"Processed") + "\\")
                    fn_ProcessFile(current_folder, fileName, True, 0)


            MessageLogger.info("After execution all the steps it is going to age the system to folder date " + subfolder)

            Datetocheck = subfolder
            CurrentTnpDate = fn_GetCurrentCommonTNPDate()
            tnpdate = subfolder.split("-")
            Month, Date, Year = tnpdate[1], tnpdate[2], tnpdate[0]
            fn_SetDateInTview(Month, Date, Year)
            while not (fn_checkAgingDate(Datetocheck)):
                MessageLogger.info("Aging is InProgress")
                time.sleep(15)

            os.chdir(current_folder)


fn_fileSplitter()
fn_ExecuteSteps()
