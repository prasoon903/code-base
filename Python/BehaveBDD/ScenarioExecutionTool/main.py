import time

from Scripts.GetLogger import MessageLogger
from Scripts.ScenarioExecution import fn_ScenarioExecute
import datetime

# from Scripts.SetLoggerGlobals import set_global_EXECUTION_TIME

if __name__ == '__main__':
    LogDateTime = datetime.datetime.now()
    # set_global_EXECUTION_TIME("Test123")
    MessageLogger.debug("EXECUTION STARTED FOR SCENARIO EXECUTION TOOL")
    # time.sleep(5)
    MessageLogger.debug(f"Start time: {str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S'))}")
    fn_ScenarioExecute()
    MessageLogger.debug("EXECUTION FINISHED FOR SCENARIO EXECUTION TOOL")
    LogDateTime = datetime.datetime.now()
    MessageLogger.debug(f"End time: {str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S'))}")

