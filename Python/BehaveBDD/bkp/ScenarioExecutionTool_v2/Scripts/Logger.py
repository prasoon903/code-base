import sys
import logging


RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
MAGENTA = "\033[95m"
CYAN = "\033[96m"


class ColoredFormatter(logging.Formatter):
    COLORS = {
        'DEBUG': CYAN,
        'INFO': GREEN,
        'WARNING': YELLOW,
        'ERROR': RED,
        'CRITICAL': MAGENTA
    }

    def format(self, record):
        log_message = super(ColoredFormatter, self).format(record)
        color = self.COLORS.get(record.levelname, RESET)
        return color + log_message + RESET


consoleFORMATTER = ColoredFormatter("%(asctime)s — %(thread)s — %(levelname)s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')
logFORMATTER = logging.Formatter("%(asctime)s — %(thread)s — %(levelname)s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')


def get_console_handler():
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(consoleFORMATTER)
    return console_handler


###################################################################################################


def get_file_handler(LOG_FILE):
    file_handler = logging.FileHandler(LOG_FILE)
    file_handler.setFormatter(logFORMATTER)
    return file_handler


###################################################################################################


def get_logger(logger_name):
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    logger.addHandler(get_console_handler())
    logger.addHandler(get_file_handler(logger_name))
    logger.propagate = False

    return logger

###################################################################################################
