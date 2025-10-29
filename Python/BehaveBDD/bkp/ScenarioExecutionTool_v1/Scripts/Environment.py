from behave import *
from Scripts.MiniDice import *
from threading import Thread
import Scripts.Config as c
from Scripts.GetLogger import MessageLogger


userinput=str(input("Do you Want Take DSLs Press Yes\ No "))
if userinput.upper()=='YES':
    DSLCopy()
userinput=str(input("Do you Want to restor DB Press Yes\ No "))
if userinput.upper()=='YES':
    os.system(RootPath+"\ExecutableFunctions\stopProcess.cmd")
    DBRestore()

# RootPath  = os.environ.get('RootPath')
#
# Configuration =  json.load(open(RootPath+"\Configuration/Configuration.json"))
Configuration = c.Configuration




MessageLogger.info("===================Starting Processes========================")
userinput=str(input("Do yo want to start process Yes \\ No "))
if userinput.upper()=='YES':
    cwd  =  os.getcwd()

    os.system(RootPath+"\ExecutableFunctions\stopProcess.cmd")

    os.chdir(Configuration["CIBatchScripts"])
    os.startfile(Configuration["CIBatchfileName"]["CIAppServerName"])
    time.sleep(4)
    os.startfile(Configuration["CIBatchfileName"]["TnpWfName"])
    time.sleep(4)
    os.startfile(Configuration["CIBatchfileName"]["RetailAuthWfName"])
    time.sleep(4)
    os.startfile(Configuration["CIBatchfileName"]["MSMQWfName"])
    time.sleep(4)
    os.chdir(Configuration["CoreAuthBatchScripts"])
    os.startfile(Configuration["CoreAuthBatchfileName"]["CoreAuthAppServerName"])
    time.sleep(4)
    os.startfile(Configuration["CoreAuthBatchfileName"]["SourceWfName"])
    time.sleep(4)
    os.startfile(Configuration["CoreAuthBatchfileName"]["SinkAuthWfName"])
    

    MessageLogger.info("Waiting for AppServers Ready for Login And Verifying Trace files")

    os.chdir(Configuration["CoreAuthTraceFileLocation"])
    os.startfile(r"Flush.bat")

    os.chdir(Configuration["CITraceFileLocation"])
    os.startfile(r"Flush.bat")
    time.sleep(60) 
    t1=Thread(target=fn_VerifyTracefiles,args=('Ready for Login',Configuration["CoreAuthTraceFileLocation"],'appCoreAuth','CoreAuth Appserver'))
    t2=Thread(target=fn_VerifyTracefiles,args=('Ready for Login',Configuration["CITraceFileLocation"],'appCardinal','CoreIusse Appserver'))
    t3=Thread(target=fn_VerifyTracefiles,args=('sched->Exec() starting',Configuration["CITraceFileLocation"],'wfTnpNad','WF TNP'))
    t4=Thread(target=fn_VerifyTracefiles,args=('sched->Exec() starting',Configuration["CITraceFileLocation"],'WfReceiveMessageFromCoreAuth','WF MSMQ'))
    t5=Thread(target=fn_VerifyTracefiles,args=('sched->Exec() starting',Configuration["CITraceFileLocation"],'WfReceiveMessageFromCoreAuth','WF WfRetailAuthJobs'))
    t6=Thread(target=fn_VerifyTracefiles,args=('sched->Exec() starting',Configuration["CoreAuthTraceFileLocation"],'wfCommonAuthScaleSink','Sink Workflow'))
    t7=Thread(target=fn_VerifyTracefiles,args=('sched->Exec() starting',Configuration["CoreAuthTraceFileLocation"],'wfCommonAuthScaleSource','Source Workflow'))


    t1.start()
    t2.start()
    t3.start()
    t4.start()
    t5.start()
    t6.start()
    t7.start()

    t1.join()
    t2.join()
    t3.join()
    t4.join()
    t5.join()
    t6.join()
    t7.join()
    os.chdir(cwd)



    


def after_all(context):
    MessageLogger.info("++++++++RitikAFterAll++++++++++++++")