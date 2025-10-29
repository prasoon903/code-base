import sys
import logging
import queue
from logging.handlers import QueueHandler, QueueListener
from colorama import Fore, Style, init

init(autoreset=True)


class ColoredFormatter(logging.Formatter):
    # RESET = "\033[0m"
    # BOLD = "\033[1m"
    # RED = "\033[91m"
    # GREEN = "\033[92m"
    # YELLOW = "\033[93m"
    # BLUE = "\033[94m"
    # MAGENTA = "\033[95m"
    # CYAN = "\033[96m"
    #
    # COLORS = {
    #     'DEBUG': CYAN,
    #     'INFO': GREEN,
    #     'WARNING': YELLOW,
    #     'ERROR': RED,
    #     'CRITICAL': MAGENTA
    # }

    # def format(self, record):
    #     log_message = super(ColoredFormatter, self).format(record)
    #     color = self.COLORS.get(record.levelname, ColoredFormatter.RESET)
    #     return color + log_message + ColoredFormatter.RESET

    COLORS = {
        'DEBUG': Fore.CYAN,
        'INFO': Fore.GREEN,
        'WARNING': Fore.YELLOW,
        'ERROR': Fore.RED,
        'CRITICAL': Fore.MAGENTA
    }

    def format(self, record):
        log_message = super(ColoredFormatter, self).format(record)
        color = self.COLORS.get(record.levelname, Style.RESET_ALL)
        # print(f"My color is {color} for {record.levelname}")
        return color + log_message + Style.RESET_ALL


formatterString = "%(asctime)s — %(thread)s — %(levelname)s — %(message)s"
datefmt = '%m/%d/%Y %H:%M:%S'
consoleFORMATTER = ColoredFormatter(formatterString, datefmt=datefmt)
logFORMATTER = logging.Formatter(formatterString, datefmt=datefmt)


def get_console_handler():
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(consoleFORMATTER)
    return console_handler

###################################################################################################


def get_queue_handler():
    que = queue.Queue(-1)
    queue_handler = QueueHandler(que)
    return que, queue_handler


###################################################################################################


def get_file_handler(LOG_FILE):
    file_handler = logging.FileHandler(LOG_FILE)
    file_handler.setFormatter(logFORMATTER)
    return file_handler


###################################################################################################


def get_logger(logger_name):
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    console_handler = get_console_handler()
    # logger.addHandler(console_handler)
    fileHandler = get_file_handler(logger_name)
    # logger.addHandler(fileHandler)
    que, queue_handler = get_queue_handler()
    logger.addHandler(queue_handler)
    listener = QueueListener(que, fileHandler, console_handler)
    listener.start()
    logger.propagate = False

    return logger

###################################################################################################
