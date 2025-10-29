import datetime
import os

from Scripts.ClearFolder import fn_clearFiles
from Scripts.Logger import get_logger
import Scripts.Config as c
from Scripts.SetLoggerGlobals import get_global_EXECUTION_TIME, set_global_EXECUTION_TIME

LogDateTime = datetime.datetime.now()
log_folder = os.path.join(c.BasePath, "LOG") + "\\"

loggerName = "TraceFile"
ExID = 0

fn_clearFiles(log_folder, "")

LOG_FILE = log_folder + "LOG_" + loggerName + ".log"
# LOG_FILE = log_folder + "LOG_Test3.log"
MessageLogger = get_logger(LOG_FILE)


