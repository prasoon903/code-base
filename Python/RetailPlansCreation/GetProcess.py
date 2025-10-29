import psutil
import subprocess
import time
import socket
# from multiprocessing import process

# import SettingThePythonLibraries

RunningDBBProcesses = {}

CIAppserver = "D:\BankCard\setup\CI\__CIAppserver.bat"
CAuthAppserver = "D:\BankCard\setup\CoreAuth\____CoreAuthAppserver.bat"

def StartProcess(ProcessName, ExeName):
    
    ExeName = ExeName.lower()
    HostName = socket.gethostname()
    if not RunningDBBProcesses or ProcessName not in RunningDBBProcesses['ProcessName']:
        subprocess.run(ProcessName)
        time.sleep(10)

        PID = [p.info['pid'] for p in psutil.process_iter(attrs=['pid', 'name']) if ExeName in p.info['name'].lower() and p.info['pid'] not in RunningDBBProcesses]

        RunningDBBProcesses['HostName'] = HostName
        RunningDBBProcesses['ExeName'] = ExeName
        RunningDBBProcesses['PID'] = PID
        RunningDBBProcesses['ProcessName'] = ProcessName

    print(RunningDBBProcesses)


StartProcess(CIAppserver, "DbbAppServer.exe")

process_list = [p.info for p in psutil.process_iter(attrs=['pid', 'name']) if 'dbbappserver.exe' in p.info['name'].lower()]
print(process_list)

'''
for process in process_list:
    if process['name'] == "DbbAppServer.exe":
        print("Process name: " + str(process['name']) + " :: PID: " + str(process['pid']))
        p = psutil.Process(process['pid'])
        # p.terminate()

print("APSERVER PROCESS ID ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ")
'''