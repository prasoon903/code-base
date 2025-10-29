import logging
import sys

FORMATTER = logging.Formatter("%(asctime)s — %(thread)7s — %(levelname)8s — %(message)s", datefmt='%m/%d/%Y %H:%M:%S')

def get_console_handler():
   console_handler = logging.StreamHandler(sys.stdout)
   console_handler.setFormatter(FORMATTER)
   return console_handler

###################################################################################################


def get_file_handler(LOG_FILE):
   file_handler = logging.FileHandler(LOG_FILE)
   file_handler.setFormatter(FORMATTER)
   return file_handler

###################################################################################################


def get_logger(logger_name):
   logger = logging.getLogger(logger_name)
   logger.setLevel(logging.INFO)
   logger.addHandler(get_console_handler())
   logger.addHandler(get_file_handler(logger_name))
   logger.propagate = False

   return logger


###################################################################################################
