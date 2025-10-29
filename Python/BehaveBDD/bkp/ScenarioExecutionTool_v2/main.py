from Scripts.ScenarioExecution import fn_ScenarioExecute
from Scripts.GetLogger import MessageLogger
import datetime

if __name__ == '__main__':
    LogDateTime = datetime.datetime.now()
    MessageLogger.debug("EXECUTION STARTED FOR SCENARIO EXECUTION TOOL")
    MessageLogger.debug(f"Start time: {str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S'))}")
    fn_ScenarioExecute()
    MessageLogger.debug("EXECUTION FINISHED FOR SCENARIO EXECUTION TOOL")
    MessageLogger.debug(f"End time: {str(LogDateTime.strftime('%Y-%m-%d %H:%M:%S'))}")

