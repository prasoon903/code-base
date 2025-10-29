'''
import psutil
import subprocess
# from multiprocessing import process

process_list = [p.info for p in psutil.process_iter(attrs=['pid', 'name'])]

for process in process_list:
    if process['name'] == "DbbAppServer.exe":
        print("Process name: " + str(process['name']) + " :: PID: " + str(process['pid']))
        p = psutil.Process(process['pid'])
        p.terminate()

CIAppserver = "D:\BankCard\setup\CI\__CIAppserver.bat"
CAuthAppserver = "D:\BankCard\setup\CoreAuth\____CoreAuthAppserver.bat"

# subprocess.run(CIAppserver)
# Pr = subprocess.Popen(CIAppserver)
print("APSERVER PROCESS ID ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ")
# print(Pr.pid)
'''

# 2018-02-06 17:36:05.040,2018-02-06,17:36:05

import datetime

CurrentDate = datetime.datetime.now()
print(CurrentDate)
print(CurrentDate.strftime('%Y-%m-%d %H:%M:%S'))
print(CurrentDate.strftime('%Y-%m-%d'))
print(CurrentDate.strftime('%H:%M:%S'))