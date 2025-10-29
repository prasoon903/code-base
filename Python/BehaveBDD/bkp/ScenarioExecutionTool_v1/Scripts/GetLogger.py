import datetime
import os
from Scripts.Logger import get_logger
import Scripts.Config as c


LogDateTime = datetime.datetime.now()

log_folder = os.path.join(c.BasePath, "LOG") + "\\"

# LOG_FILE = log_folder + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"
LOG_FILE = log_folder + "LOG_Test2.log"
MessageLogger = get_logger(LOG_FILE)

