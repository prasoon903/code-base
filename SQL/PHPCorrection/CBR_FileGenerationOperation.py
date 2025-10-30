# ******************************************************************************************
# Developed by	: Vinod Prajapati
# Created Date	: 05/01/2021
# Version		: 16.00.05.01
# Purpose - Script call CBR File Generation process and send alert notification email either LOCAL / AWS
# Script Start Point - main()
# ******************************************************************************************
# REVISION HISTORY
# Modify by	: Vinod Prajapati
# Version	: 16.00.10
# ******************************************************************************************
# User defined functions - Common
# ******************************************************************************************


def LineNumber():
    # from inspect import currentframe
    # This function return current line no of code
    cf = currentframe()
    return " LineNumber-" + str(cf.f_back.f_lineno)


# ******************************************************************************************


def udfGetObjectName():
    # import must move at top of main .py file
    # import inspect
    # Purpose: This function returns calling object name
    return inspect.stack()[1][3]


# ******************************************************************************************


def log_msg(lm_msg):
    # import must move at top of main .py file
    # import os
    # import datetime
    # Purpose: Create log file with same as python script

    f = open(LogFileName, "a")
    f.write(str(datetime.datetime.now()) + ": " + str(lm_msg) + '\n')
    f.close()


# ******************************************************************************************


def udfGetSelfFilename():
    # import must move at top of main .py file
    # import os
    # Purpose: This returns current executing file name without extension
    # Dependency: def log_msg():

    self_file_path = os.path.realpath(__file__)
    # print("Current File Name : ", self_file_path)
    self_file_name_long = os.path.basename(self_file_path)
    # print("File Name : ", self_file_name)
    self_filename_short = os.path.splitext(self_file_name_long)[0]
    # print("Short File Name : ", self_filename_short)
    return self_filename_short


# ******************************************************************************************


def udfGetConfigFilename():
    print("CALL: Function - ", udfGetObjectName())
    # import must move at top of main .py file
    # import os
    # Purpose: Function returns config file name of current executing file

    try:
        cf_file_path = os.path.realpath(__file__)
        # print("Current File Name : ", cf_file_path)
        cf_file_name_long = os.path.basename(cf_file_path)
        # print("File Name : ", cf_file_name)
        cf_filename_short = os.path.splitext(cf_file_name_long)[0]
        # print("Short File Name : ", cf_filename_short)
        cf_config_file_name_name = cf_filename_short + "_config.ini"
        # print('Config File Name : ', cf_config_file_name_name)
        return cf_config_file_name_name
    except os.error as err_gcf:
        log_msg("ERROR: " + str(err_gcf))
        # Un-success response
        return "1"


# ******************************************************************************************


def udfGetEnvVar(cev_config_file_name, cev_config_section_name, cev_config_variable_name):
    # import must move at top of main .py file
    # import configparser
    # import os.path
    # from os import path
    # Purpose: function read Config_py.ini file
    # Return value of variable of a section
    # Dependency: def log_msg():
    global bStopProcessing

    cev_obj_config = configparser.ConfigParser()
    # construct config file path
    cev_config_file_name_path = os.path.abspath((os.path.join(os.getcwd(), cev_config_file_name)))
    try:
        cev_obj_config.read(cev_config_file_name_path)
        # print("**************** Sections of Config_py.ini *****************")
        # print(cev_config.sections())
        # print(config_variable_name)
        cev_variable_value = cev_obj_config.get(cev_config_section_name, cev_config_variable_name)
    except NameError as errConfig:
        cev_variable_value = "ERROR: " + str(errConfig)
        print(cev_variable_value)
        bStopProcessing = True
    except configparser.Error as err:
        cev_variable_value = "ERROR: " + str(err)
        print(cev_variable_value)
        bStopProcessing = True

    return cev_variable_value


# ******************************************************************************************


def udfCreateDatabaseConnection(cdc_server_name, cdc_db_name):
    # print("DEBUG: Creating database connection.....")
    # import library must move at top of main .py file
    # import pyodbc
    # Purpose: This returns connection object to connect SQL Server
    # Dependency: install pyodbc library, if not installed command
    global sql_driver

    appName = udfGetSelfFilename()
    try:
        sql_driver = '{ODBC Driver 17 for SQL Server}'
        # print("DEBUG: Specified SQL Driver - " + sql_driver)

        cdc_conn = pyodbc.connect(Driver=sql_driver,
                                  Server=cdc_server_name,
                                  Database=cdc_db_name,
                                  Trusted_Connection='yes',
                                  autocommit=False,
                                  app=appName,
                                  MultiSubnetFailover='yes')
        # if cdc_conn:
        #     print("DEBUG: sql_driver - " + sql_driver)
        return cdc_conn
    except pyodbc.Error:
        try:
            # print("DEBUG: Specified SQL Driver Not Found, Connecting with auto driver")
            driver_name = ''
            driver_names = [x for x in pyodbc.drivers() if x.endswith(' for SQL Server')]

            if driver_names:
                driver_name = driver_names[0]
            if driver_name:
                sql_driver = '{' + driver_name + '}'
            # print("DEBUG: sql_driver - " + sql_driver)

            cdc_conn = pyodbc.connect(Driver=sql_driver,
                                      Server=cdc_server_name,
                                      Database=cdc_db_name,
                                      Trusted_Connection='yes',
                                      autocommit=False,
                                      app=appName,
                                      MultiSubnetFailover='yes')
            # if cdc_conn:
            #     print("DEBUG: sql_driver - " + sql_driver)
            return cdc_conn
        except pyodbc.Error:
            try:
                # print("DEBUG: Connecting with Default Driver")
                driver_name = '{SQL Server Native Client 11.0}'
                # print("DEBUG: sql_driver - " + sql_driver)

                cdc_conn = pyodbc.connect(Driver=driver_name,
                                          Server=cdc_server_name,
                                          Database=cdc_db_name,
                                          Trusted_Connection='yes',
                                          autocommit=False,
                                          app=appName,
                                          MultiSubnetFailover='yes')
                # if cdc_conn:
                #     print("DEBUG: sql_driver - " + sql_driver)
                return cdc_conn
            except pyodbc.Error as err_cdc:
                print("ERROR: + " + str(err_cdc))
                print("***************************** EXIT PROCESS ********************************")
                exit(1)


# ******************************************************************************************


def udfGetRowCount(grc_sql_query):
    # log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import pyodbc
    # Purpose: Function returns record count of table
    # Dependency: def udfCreateDatabaseConnection()

    try:
        # Create connection object
        grc_obj_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Create cursor object
        grc_obj_cursor = grc_obj_conn.cursor()
        # Execute query by using cursor
        grc_obj_cursor.execute(grc_sql_query)
        grc_qry_result = grc_obj_cursor.fetchall()
        grc_row_count = grc_qry_result[-1][-1]
        grc_obj_cursor.close()  # Close cursor
        grc_obj_conn.close()  # Close database connection
        return grc_row_count
    except pyodbc.Error as err_grc:
        log_msg("EXCEPTION: " + str(err_grc))


# ******************************************************************************************


def udfSendEmail(
        se_sender,
        se_receiver,
        se_subject,
        se_message,
        se_stmp_server,
        se_stmp_port):
    log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import smtplib
    # from socket import gaierror
    # from email.mime.text import MIMEText
    # from email.mime.multipart import MIMEMultipart
    # Purpose: Send email
    # Dependency:

    msg = MIMEText(se_message)
    msg['Subject'] = se_subject
    msg['From'] = se_sender
    msg['To'] = ", ".join(se_receiver)

    try:
        se_smtplib = smtplib.SMTP(se_stmp_server, se_stmp_port)
        se_smtplib.sendmail(se_sender, se_receiver, msg.as_string())
        # tell the script to report if your message was sent or which errors need to be fixed
        # print('DEBUG: Email Sent Successfully')
        log_msg('DEBUG: Email Sent Successfully')
    except (gaierror, ConnectionRefusedError):
        # print('ERROR: Failed to connect to the server. Bad connection settings?')
        log_msg('ERROR: Failed to connect to the server. Bad connection settings?')
    except smtplib.SMTPServerDisconnected:
        # print('ERROR: Failed to connect to the server. Wrong user/password?')
        log_msg('ERROR: Failed to connect to the server. Wrong user/password?')
    except smtplib.SMTPException as err_se:
        # print('ERROR: SMTP error occurred: ' + str(err_se))
        log_msg('ERROR: SMTP error occurred: ' + str(err_se))


# ******************************************************************************************


def getAWSSecret(secret_name):
    # import library must move at top of main .py file
    # import boto3
    # import json
    # Purpose: Get secret code of AWS - simple email service
    # Dependency: def log_msg():
    # Dependency: def udfGetEnvVar():
    global bStopProcessing

    from botocore.exceptions import ClientError

    try:
        client = boto3.client('secretsmanager', ses_region_name)
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        raw_string = str(get_secret_value_response['SecretString'])
        format_secret = unidecode.unidecode(raw_string)
        response_dict = json.loads(format_secret)
        # response_dict = json.loads(get_secret_value_response['SecretString'])

        # log_msg(response_dict)
        # log_msg("user : " + response_dict['user'])
        # log_msg("secret : " + response_dict['secret'])
        # log_msg("ses_smtp_password_v4 : " + response_dict['ses_smtp_password_v4'])
        # log_msg("description : " + response_dict['description'])

        if not bool(response_dict):
            log_msg("ERROR: AWS secret values not received")
            bStopProcessing = True
        else:
            return response_dict

    except ClientError as err_as:
        if err_as.response['Error']['Code'] == 'ResourceNotFoundException':
            # print("The requested secret " + secret_name + " was not found")
            log_msg("The requested secret " + secret_name + " was not found")
        elif err_as.response['Error']['Code'] == 'InvalidRequestException':
            # print("The request was invalid due to:", err_as)
            log_msg("The request was invalid due to:" + str(err_as))
        elif err_as.response['Error']['Code'] == 'InvalidParameterException':
            # print("The request had invalid params:", err_as)
            log_msg("The request had invalid params:" + str(err_as))
        elif err_as.response['Error']['Code'] == 'DecryptionFailure':
            # print("The requested secret can't be decrypted using the provided KMS key:", err_as)
            log_msg("The requested secret can't be decrypted using the provided KMS key:" + str(err_as))
        elif err_as.response['Error']['Code'] == 'InternalServiceError':
            # print("An error occurred on service side:", err_as)
            log_msg("An error occurred on service side:" + str(err_as))


# ******************************************************************************************


def udfSendEmailAWS(sea_sender,
                    sea_receiver,
                    sea_subject,
                    sea_message,
                    sea_stmp_server,
                    sea_stmp_port,
                    sea_secret_name):
    log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import smtplib
    # import ssl
    # from socket import gaierror
    # from email.mime.text import MIMEText
    # from email.mime.multipart import MIMEMultipart
    # Purpose: Send email
    # Dependency:

    # Create a secure SSL context
    sea_context = ssl.create_default_context()

    # msg = MIMEText(sea_message)
    msg = MIMEText(sea_message)
    msg['Subject'] = sea_subject
    msg['From'] = sea_sender
    msg['To'] = ", ".join(sea_receiver)

    try:
        # Call function to get aws secret key
        sea_response = getAWSSecret(sea_secret_name)
        sea_smtp_user = sea_response.get('id')
        sea_smtp_password = sea_response.get('ses_smtp_password_v4')

        if sea_stmp_port == '465':
            # For SSL port - 465
            with smtplib.SMTP_SSL(sea_stmp_server, sea_stmp_port, sea_context) as email_server:
                email_server.login(sea_smtp_user, sea_smtp_password)
                email_server.sendmail(sea_sender, sea_receiver, msg.as_string())
        elif sea_stmp_port == '587':
            # For starttls port - 587
            sea_smtplib = smtplib.SMTP(sea_stmp_server, sea_stmp_port)
            sea_smtplib.starttls(context=sea_context)
            sea_smtplib.login(sea_smtp_user, sea_smtp_password)
            sea_smtplib.sendmail(sea_sender, sea_receiver, msg.as_string())

        # print('DEBUG: Email Sent Successfully')
        log_msg('DEBUG: Email Sent Successfully')

    except (gaierror, ConnectionRefusedError):
        # print('ERROR: Failed to connect to the server. Bad connection settings?')
        log_msg('ERROR: Failed to connect to the server. Bad connection settings?')
    except smtplib.SMTPServerDisconnected:
        # print('ERROR: Failed to connect to the server. Wrong user/password?')
        log_msg('ERROR: Failed to connect to the server. Wrong user/password?')
    except smtplib.SMTPException as e:
        # print('ERROR: SMTP error occurred: ' + str(e))
        log_msg('ERROR: SMTP error occurred: ' + str(e))


# ******************************************************************************************


def emailSend():
    # Purpose - This function will send email notification
    global bStopProcessing
    try:
        if alert_email_source.upper() == 'AWS':
            log_msg("DEBUG: email sent through AWS SES")
            udfSendEmailAWS(
                alert_email_sender,
                alert_email_receiver,
                alert_email_subject,
                email_message,
                ses_smtp_url,
                ses_smtp_port,
                ses_smtp_secret_name)
        else:
            log_msg("DEBUG: email sent through LOCAL SMTP")
            udfSendEmail(
                alert_email_sender,
                alert_email_receiver,
                alert_email_subject,
                email_message,
                smtp_server_name,
                smtp_port)
    except Exception as e:
        msg = udfGetException()
        log_msg(msg)
        bStopProcessing = True


# ******************************************************************************************


def getComputerName():
    # Return host computer name on which script is running
    # import socket
    return socket.gethostname()


# ******************************************************************************************


def udfExecSP(es_sp_call):  # Return Value sp
    # log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import pyodbc
    # Purpose: return result of executed in a single column - RESULT
    es_sp_result = ''
    conn_se = None

    try:
        # Create connection object
        conn_se = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Open cursor object
        objCursor_es_exec_sp = conn_se.cursor()
        # Execute Store Procedure
        objCursor_es_exec_sp.execute(es_sp_call)
        es_sp_output = objCursor_es_exec_sp.fetchall()

        for es_row in es_sp_output:
            es_sp_result = es_row.RESULT
        # Commit transaction
        conn_se.commit()
        objCursor_es_exec_sp.close()  # Close cursor
        conn_se.close()  # Close database connection
    except pyodbc.Error as err_es_exec_sp:
        es_sp_result = "ERROR: - " + str(err_es_exec_sp)
        log_msg(es_sp_result)
        # Rollback transaction
        conn_se.rollback()
    except pyodbc.ProgrammingError as err_es_exec_sp_pe:
        es_sp_result = "ERROR: - " + str(err_es_exec_sp_pe)
        log_msg(es_sp_result)
        # Rollback transaction
        conn_se.rollback()
    return es_sp_result

# ******************************************************************************************

def udfExecSP_RPT(es_sp_call):  # Return Value sp
    # log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import pyodbc
    # Purpose: return result of executed in a single column - RESULT
    es_sp_result = ''
    conn_se = None

    try:
        # Create connection object
        conn_se = udfCreateDatabaseConnection(DB_Server_NAME_RPT, DBName_CI_RPT)
        # Open cursor object
        objCursor_es_exec_sp = conn_se.cursor()
        # Execute Store Procedure
        objCursor_es_exec_sp.execute(es_sp_call)
        es_sp_output = objCursor_es_exec_sp.fetchall()

        for es_row in es_sp_output:
            es_sp_result = es_row.RESULT
        # Commit transaction
        conn_se.commit()
        objCursor_es_exec_sp.close()  # Close cursor
        conn_se.close()  # Close database connection
    except pyodbc.Error as err_es_exec_sp:
        es_sp_result = "ERROR: - " + str(err_es_exec_sp)
        log_msg(es_sp_result)
        # Rollback transaction
        conn_se.rollback()
    except pyodbc.ProgrammingError as err_es_exec_sp_pe:
        es_sp_result = "ERROR: - " + str(err_es_exec_sp_pe)
        log_msg(es_sp_result)
        # Rollback transaction
        conn_se.rollback()
    return es_sp_result


# ******************************************************************************************


def udfCheckEnvVal(cev_env_var):
    # import must move at top of main .py file
    # Purpose: check values of environment variables
    if cev_env_var == "":
        print('ERROR: ' + cev_env_var + 'must be set in config file')
    else:
        # Success
        return "0"


# ******************************************************************************************


def udfGetException():
    # log_msg("CALL: Function - " + udfGetObjectName())
    # import must move at top of main .py file
    # import sys
    # import linecache
    # Purpose: check values of environment variables

    exc_type, exc_obj, tb = sys.exc_info()
    f = tb.tb_frame
    line_no = tb.tb_lineno
    filename = f.f_code.co_filename
    linecache.checkcache(filename)
    line = linecache.getline(filename, line_no, f.f_globals)
    # print('EXCEPTION IN ({}, LINE - {}, "{}"): {}'.format(filename, line_no, line.strip(), exc_obj))
    # print('EXCEPTION TYPE : ', exc_type)
    return_exception = 'EXCEPTION IN ({}, Type - {}, LINE - {}, "{}"): {}'.format(filename, exc_type, line_no,
                                                                                  line.strip(), exc_obj)
    return return_exception


# ******************************************************************************************


def udfGetFormatDateTime(Option):
    # import must move at top of main .py file
    # import datetime

    # Purpose: Return current datetime with provided format
    date_value = datetime.datetime.now()
    day = str(date_value.strftime("%d")).zfill(2)
    month = str(date_value.strftime("%m")).zfill(2)
    year_short = date_value.strftime("%y")  # Short version
    year_full = date_value.strftime("%Y")  # Full version

    hour = date_value.strftime("%H")
    minute = date_value.strftime("%M")
    second = date_value.strftime("%S")
    millisecond = date_value.strftime("%f")

    # Convert to upper case
    Option = Option.upper()

    if Option == "MMDDYYYY":
        return month + day + year_full
    elif Option == "DDMMYYYY":
        return day + month + year_full
    elif Option == "YYYYMMDD":
        return year_full + month + day
    elif Option == "MMDDYY":
        return month + day + year_short
    elif Option == "DDMMYY":
        return day + month + year_short
    elif Option == "YYMMDD":
        return year_short + month + day
    elif Option == "HHMMSS":
        return hour + minute + second
    elif Option == "HHMM":
        return hour + minute
    elif Option == "YYYYMMDDHHMMSS":
        return year_full + month + day + hour + minute + second
    elif Option == "MMDDYYYYHHMMSS":
        return month + day + year_full + hour + minute + second
    elif Option == "DD-MM-YYYY":
        return day + "-" + month + "-" + year_full
    elif Option == "MM-DD-YYYY":
        return month + "-" + day + "-" + year_full
    elif Option == "YYYYMMDDHHMMSSNNN":
        return year_full + month + day + hour + minute + second + millisecond
    else:
        print("ERROR: Invalid Option!")


# ******************************************************************************************


def udfExecuteQuery(udf_query):
    # log_msg("DEBUG: Function - " + udfGetObjectName())
    log_msg("DEBUG: Query - " + udf_query)
    # import must move at top of main .py file
    # import pyodbc
    # Purpose: Update data on database
    # Dependency: def log_msg()
    global msg, email_message
    udf_conn = None

    try:
        # Create connection object
        udf_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Create cursor
        udf_cursor = udf_conn.cursor()
        udf_cursor.execute(udf_query)
        udf_conn.commit()
        udf_cursor.close()  # Close cursor
        udf_conn.close()  # Close database connection
        # log_msg("DEBUG: Update successful")
        return True
    except pyodbc.Error as err_euq:
        msg = "ERROR: " + str(err_euq)
        log_msg(msg)
        email_message += '\n' + msg
        udf_conn.rollback()
        return False
    


def udfExecuteQuery_RPT(udf_query):
    # log_msg("DEBUG: Function - " + udfGetObjectName())
    log_msg("DEBUG: Query - " + udf_query)
    # import must move at top of main .py file
    # import pyodbc
    # Purpose: Update data on database
    # Dependency: def log_msg()
    global msg, email_message
    udf_conn = None

    try:
        # Create connection object
        udf_conn = udfCreateDatabaseConnection(DB_Server_NAME_RPT, DBName_CI_RPT)
        # Create cursor
        udf_cursor = udf_conn.cursor()
        udf_cursor.execute(udf_query)
        udf_conn.commit()
        udf_cursor.close()  # Close cursor
        udf_conn.close()  # Close database connection
        # log_msg("DEBUG: Update successful")
        return True
    except pyodbc.Error as err_euq:
        msg = "ERROR: " + str(err_euq)
        log_msg(msg)
        email_message += '\n' + msg
        udf_conn.rollback()
        return False


# ******************************************************************************************


def udfGetRecordCount(grec_sql_query):
    try:
        # Create connection object
        udf_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Create cursor object
        grec_obj_cursor = udf_conn.cursor()
        # Execute query by using cursor
        grec_obj_cursor.execute(grec_sql_query)
        grc_qry_result = grec_obj_cursor.fetchall()
        grec_obj_cursor.close()  # Close cursor
        udf_conn.close()  # Close database connection
        return len(grc_qry_result)
    except pyodbc.Error as err_grc:
        log_msg("EXCEPTION: " + str(err_grc))


# ******************************************************************************************


def udfGetEncryptionKey():
    # import must move at top of main .py file
    # Purpose: Get Encryption / Decryption Key
    global bStopProcessing, msg, email_message, alert_email_subject, pii_key_value
    global bBCPResult
    bcp_result = None

    udf_sql = "SELECT COUNT(1) AS 'row_count' FROM " + DBName_CI + ".dbo.ThirdPartyAPISetup WITH(NOLOCK)"
    udf_sql += " WHERE SysOrgId = " + str(SysOrgID)
    udf_sql += " AND Environment = '" + PIIHubEnv + "'"
    udf_sql += " AND APIName = 'PlatPIIHub' AND KeyValueEncy IS NOT NULL"

    log_msg('DEBUG: udf_sql : ' + udf_sql)
    # Create cursor
    pii_row_count = udfGetRowCount(udf_sql)
    # Start - if block - pii_row_count
    if pii_row_count == 0:
        msg = "ERROR: PII hub setup is missing in ThirdPartyAPISetup table, Please check ASAP"
        print(msg)

        log_msg(msg)
        email_message += '\n' + msg
        bStopProcessing = True

        # Send email notification
        alert_email_subject = 'CBReporing File Generation Process Failed on Environment (' + computer_name + ')'
        emailSend()
    else:
        log_msg("DEBUG: PII hub setup is fine")

        EncryptionTime = udfGetFormatDateTime("YYYYMMDDHHMMSSNNN")

        PIIEncryptedFile = EncryptionTime.strip('\n') + "_PIIEncryptedFile" + ".txt"
        PIIEncryptedFile = os.path.abspath((os.path.join(IntermediateFolder, PIIEncryptedFile)))

        PIIDecryptedFile = EncryptionTime.strip('\n') + "_PIIDecryptedFile" + ".txt"
        PIIDecryptedFile = os.path.abspath((os.path.join(IntermediateFolder, PIIDecryptedFile)))

        log_msg("DEBUG: PIIEncryptedFile : " + PIIEncryptedFile)
        log_msg("DEBUG: PIIDecryptedFile : " + PIIDecryptedFile)

        # Start - try block - remove existing files from intermediate folder
        try:
            if os.path.exists(PIIEncryptedFile):
                os.remove(PIIEncryptedFile)
                log_msg("DEBUG: Delete existing encrypted file")
            else:
                log_msg("DEBUG: Old encrypted file not found")

            if os.path.exists(PIIDecryptedFile):
                os.remove(PIIDecryptedFile)
                log_msg("DEBUG: Delete existing decrypted file")
            else:
                log_msg("DEBUG: Old decrypted file not found")
        except Exception as e:
            msg = udfGetException()
            log_msg(msg)
            email_message += '\n' + msg
            bStopProcessing = True
        # End - try block - remove existing files from intermediate folder

        # Start - if block - generate encrypted file through bcp command
        if not bStopProcessing:
            # Start - if block - authenticationMode
            if authenticationMode == "WA":
                BCP = 'BCP "SELECT ' + "'|'" + ' + CONVERT(VARCHAR(MAX),KeyValueEncy,2) + ' + "'|'" + ' FROM '
                BCP += DBName_CI + '.DBO.ThirdPartyAPISetup WITH(NOLOCK) WHERE SysOrgId = ' + str(SysOrgID)
                BCP += ' AND Environment = \'' + PIIHubEnv + '\' AND APIName = \'PlatPIIHub\'\"  queryout '
                BCP += '"' + PIIEncryptedFile + '"' + ' -c -r ' + "\\n" + ' -S '
                BCP += DB_Server_NAME + '  -U ' + post_dbms_login + ' -P ' + post_dbms_passwd + ' -T'
            else:
                BCP = 'BCP "SELECT ' + "'|'" + ' + CONVERT(VARCHAR(MAX),KeyValueEncy,2) + ' + "'|'" + ' FROM '
                BCP += DBName_CI + '.DBO.ThirdPartyAPISetup WITH(NOLOCK) WHERE SysOrgId = ' + str(SysOrgID)
                BCP += ' AND Environment = \'' + PIIHubEnv + '\' AND APIName = \'PlatPIIHub\'\"  queryout '
                BCP += '"' + PIIEncryptedFile + '"' + ' -c -r ' + "\\n" + ' -S '
                BCP += DB_Server_NAME + '  -U ' + post_dbms_login + ' -P ' + post_dbms_passwd + ' '
            # End - if block - authenticationMode

            log_msg("DEBUG: BCP Command - " + BCP)

            # Start - try block - dump encrypted file
            try:
                bcp_output = subprocess.run(BCP)
                bcp_result = bcp_output.returncode
                log_msg('DEBUG: BCP Command Result - ' + str(bcp_result))
            except subprocess.CalledProcessError as err_subprocess:
                msg = "EXCEPTION: " + str(err_subprocess)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except TypeError as err_te:
                msg = "EXCEPTION: " + str(err_te)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except ValueError as err_ve:
                msg = "EXCEPTION: " + str(err_ve)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except FileNotFoundError as err_fnf:
                msg = "EXCEPTION: " + str(err_fnf)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            # End - try block - dump encrypted file
        # End - if block - generate encrypted file through bcp command

        if bStopProcessing:
            log_msg("ERROR: BCP ERROR")
        elif bcp_result == 1:
            msg = "ERROR: BCP not able to write intermediate file for encryption/decryption key."

            print(msg)
            log_msg(msg)
            email_message += '\n' + msg
            bBCPResult = False
            bStopProcessing = True

        # Start - if block - generate decrypted file through translate.exe
        if not bStopProcessing:
            # Set false result
            translate_result = 1
            BatchScripts = ""
            BatchScripts = os.path.abspath((os.path.join(BatchScripts, "CBRPIIKeyEncryptionPy.bat")))
            translate_exec = BatchScripts \
                             + " " + IntermediateFolder \
                             + " " + EncryptionTime.strip('\n') \
                             + " " + EXECUTABLEPATH_DRIVE.strip('\n') \
                             + " " + EXECUTABLEPATH.strip('\n') \
                             + " " + emKMSdefaultMachines
            log_msg("DEBUG: Translate Command - " + translate_exec)

            # Start - try block - generate decrypted file through translate.exe
            try:
                translate_output = subprocess.run(translate_exec)
                translate_result = translate_output.returncode

                log_msg('DEBUG: Translate Command Result - ' + str(translate_result))

                if translate_result == 0:
                    msg = "DEBUG: Translate done"
                    log_msg(msg)
                else:
                    msg = "ERROR: Translate.exe not responding / failed, please check ASAP"
                    log_msg(msg)
                    email_message += '\n' + msg
                    bStopProcessing = True
            except subprocess.TimeoutExpired as err_subprocess_te:
                msg = "EXCEPTION: " + str(err_subprocess_te)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except subprocess.CalledProcessError as err_subprocess:
                msg = "EXCEPTION: " + str(err_subprocess)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except TypeError as err_te:
                msg = "EXCEPTION: " + str(err_te)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            except ValueError as err_ve:
                msg = "EXCEPTION: " + str(err_ve)
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            # End - try block - generate decrypted file through translate.exe
        # End - if block - generate decrypted file through translate.exe

        # Start - if block - retrieve key value from decrypted file
        if not bStopProcessing:
            # Start - if block - if decrypted file already exits
            if not os.path.exists(PIIDecryptedFile):
                msg = "ERROR: Decrypted file not found"
                log_msg(msg)
                email_message += '\n' + msg
                bStopProcessing = True
            else:
                # Start - try block - read encryption key
                try:
                    objFile = open(PIIDecryptedFile, 'r')
                    pii_key_value = objFile.read()
                    # Replace | with ""
                    pii_key_value = pii_key_value.replace("|", "")
                    # Remove new line character
                    pii_key_value = pii_key_value.rstrip("\n")
                    # log_msg("DEBUG: Value - " + pii_key_value)
                    objFile.close()

                    if pii_key_value == "":
                        msg = "ERROR: Encryption Key not found in DB"
                        log_msg(msg)
                        email_message += '\n' + msg
                        bStopProcessing = True
                except Exception as e:
                    msg = udfGetException()
                    log_msg(msg)
                    email_message += '\n' + msg
                    bStopProcessing = True
                finally:
                    # Start - try block - remove existing files from intermediate folder
                    try:
                        if os.path.exists(PIIEncryptedFile):
                            os.remove(PIIEncryptedFile)
                            log_msg("DEBUG: Delete existing encrypted file")
                        else:
                            log_msg("DEBUG: Old encrypted file not found")

                        if os.path.exists(PIIDecryptedFile):
                            os.remove(PIIDecryptedFile)
                            log_msg("DEBUG: Delete existing decrypted file")
                        else:
                            log_msg("DEBUG: Old decrypted file not found")
                    except Exception as e:
                        msg = udfGetException()
                        log_msg(msg)
                        email_message += '\n' + msg
                        bStopProcessing = True
                    # End - try block - remove existing files from intermediate folder
                # End - try block - read encryption key
            # End - if block - if decrypted file already exits
        # End - if block - retrieve key value from decrypted file
    # End - if block - pii_row_count


# ******************************************************************************************


def udfGetCBRProcessDetail():
    global bStopProcessing, bDBOperation
    global CBRRunID, RunDate, CBRProcessStatus, PIIEnable

    try:
        # Get CBR Process Detail
        udf_sql = "SELECT TOP 1 RunID,RunDate,Status,PIIEnable FROM CBRProcess WITH(NOLOCK)"
        # udf_sql += " WHERE Status = 'FILE_COMPOSSING_DONE'"
        udf_sql += " WHERE Status = 'READY_FOR_FILE_GENERATION'"
        udf_sql += " ORDER BY RunID ASC"
        log_msg('DEBUG: ' + udf_sql)

        # Create connection object
        udf_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Create cursor
        udf_cursor = udf_conn.cursor()
        udf_cursor.execute(udf_sql)
        udf_result = udf_cursor.fetchall()
        RowCount = len(udf_result)
        log_msg("DEBUG: CBR Process Row Count - " + str(RowCount))
        if RowCount == 0:
            log_msg("DEBUG: CBRProcess - 0")
            CBRRunID = 0
        else:
            for row in udf_result:
                CBRRunID = int(row.RunID)
                RunDate = row.RunDate
                CBRProcessStatus = row.Status
                PIIEnable = int(row.PIIEnable)
        udf_cursor.close()  # Close cursor
        udf_conn.close()  # Close database connection
    except Exception as e:
        msg = udfGetException()
        print(msg)
        # email_message = msg
        bStopProcessing = True


# ******************************************************************************************


def udfGetCBRProcessFileDetail():
    global bStopProcessing, bDBOperation
    global InstitutionID, CBRFileID, CBRFileName, CBRFileStatus

    try:
        # Get CBR Process Detail
        udf_sql = "SELECT TOP 1 ISNULL(InstitutionID,0) AS InstitutionID ,FileID,FileName,Status FROM " \
                  "CBRProcessFileDetail WITH(NOLOCK) "
        udf_sql += " WHERE RunID = " + str(CBRRunID)
        udf_sql += " AND Status = 'FILE_COMPOSSING_DONE'"
        udf_sql += " ORDER BY SKey ASC"
        log_msg('DEBUG: ' + udf_sql)

        # Create connection object
        udf_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        # Create cursor
        udf_cursor = udf_conn.cursor()
        udf_cursor.execute(udf_sql)
        udf_result = udf_cursor.fetchall()
        RowCount = len(udf_result)
        if RowCount == 0:
            log_msg("DEBUG: CBRProcessFileDetail - 0")
            CBRFileID = 0
        else:
            for row in udf_result:
                InstitutionID = int(row.InstitutionID)
                CBRFileID = int(row.FileID)
                CBRFileName = row.FileName
                CBRFileStatus = row.Status
        udf_cursor.close()  # Close cursor
        udf_conn.close()  # Close database connection
    except Exception as e:
        msg = udfGetException()
        print(msg)
        # email_message = msg
        bStopProcessing = True


# ******************************************************************************************


def udfCBRFileGeneration():
    # log_msg("CALL: Function - " + udfGetObjectName())
    # Purpose: Whole file generation process
    # Declare global variables which used globally
    global bStopProcessing, email_message, msg, CBRFileStatus
    global bDBOperation, bCBRFileGenerate, bBCPResult

    # Before start processing
    bStopProcessing = False
    start_time = time.time()

    # Start - try block - delete CBRFile if exists at IN folder
    try:
        if os.path.exists(CBRFileNamePath):
            log_msg("DEBUG: Delete existing final file")
            os.remove(CBRFileNamePath)
    except Exception as e:
        msg = udfGetException()
        log_msg(msg)
        email_message += '\n' + msg
        bStopProcessing = True
    # End - try block - delete ACHOutFile if exists at IN folder

    # Start - if block - main
    if not bStopProcessing:
        log_msg("DEBUG: Start file writing on the disk through BCP")
        bcp_result = 1
        # Start - if block - authenticationMode
        if authenticationMode == "WA":
            BCP = 'BCP "SELECT '
            BCP += 'CAST(DecryptByPassPhrase(\'' + pii_key_value + '\',FileRecordEncy) AS VARCHAR(4000)) FROM '
            BCP += DBName_CI + '.DBO.CBRFormattedFile WITH(NOLOCK) WHERE RunID = ' + str(CBRRunID)
            BCP += ' AND FileName = \'' + CBRFileName + '\' ORDER BY RecordType"  queryout '
            BCP += '"' + CBRFileNamePath + '"' + ' -c -r ' + "\\n" + ' -S '
            BCP += DB_Server_NAME + '  -U ' + post_dbms_login + ' -P ' + post_dbms_passwd + ' -T'
        else:
            BCP = 'BCP "SELECT '
            BCP += 'CAST(DecryptByPassPhrase(\'' + pii_key_value + '\',FileRecordEncy) AS VARCHAR(4000)) FROM '
            BCP += DBName_CI + '.DBO.CBRFormattedFile WITH(NOLOCK) WHERE RunID = ' + str(CBRRunID)
            BCP += ' AND FileName = \'' + CBRFileName + '\' ORDER BY RecordType"  queryout '
            BCP += '"' + CBRFileNamePath + '"' + ' -c -r ' + "\\n" + ' -S '
            BCP += DB_Server_NAME + '  -U ' + post_dbms_login + ' -P ' + post_dbms_passwd + ' '
        # End - if block - authenticationMode
        log_msg("DEBUG: BCP Command - " + BCP)
        # print("DEBUG: BCP Command - " + BCP)

        # Start - try block - dump final file
        try:
            bcp_output = subprocess.run(BCP)
            bcp_result = bcp_output.returncode
            log_msg('DEBUG: BCP Command Result - ' + str(bcp_result))
        except subprocess.CalledProcessError as err_subprocess:
            msg = "EXCEPTION: " + str(err_subprocess)
            log_msg(msg)
            email_message += '\n' + msg
            bStopProcessing = True
        except TypeError as err_te:
            msg = "EXCEPTION: " + str(err_te)
            log_msg(msg)
            email_message += '\n' + msg
            bStopProcessing = True
        except ValueError as err_ve:
            msg = "EXCEPTION: " + str(err_ve)
            log_msg(msg)
            email_message += '\n' + msg
            bStopProcessing = True
        except FileNotFoundError as err_fnf:
            msg = "EXCEPTION: " + str(err_fnf)
            log_msg(msg)
            email_message += '\n' + msg
            bStopProcessing = True
        # End - try block - dump final file

        # Start - Update file status ERROR
        if not bStopProcessing and bcp_result == 0:
            CBRFileStatus = "DONE"
            ErrorMessage = "File has been write on the disk"

            bCBRFileGenerate = True

            sql = "UPDATE " + DBName_CI + ".dbo.CBRProcessFileDetail "
            sql += "SET Status = '" + CBRFileStatus + "', FilePath = '" + CBRFileNamePath + "'"
            sql += " WHERE RunID = " + str(CBRRunID) + " AND FileName = '" + CBRFileName + "'"
            # Execute update sql return True means update successfully
            bDBOperation = udfExecuteQuery(sql)

            finish_time = time.time()
            elapsed = finish_time - start_time
            elapsed = round(elapsed, 3)
            if bDBOperation:
                sql = "INSERT INTO " + DBName_CI \
                      + ".dbo.CBRProcessDetail (RunID,FileId,FileName,RunDate,LogTime,TimeTaken,Step,Status) SELECT " \
                      + str(CBRRunID) + "," + str(CBRFileID) + ",'" + CBRFileName + "','" + str(RunDate) \
                      + "',GETDATE()," + str(elapsed) + ",'FILE_WRITING','DONE'"
                # Execute CBRProcessDetailLog
                bDBOperation = udfExecuteQuery(sql)
        else:
            CBRFileStatus = "ERROR"
            msg = "ERROR: BCP Error while file writing error on the disk"

            sql = "INSERT INTO " + DBName_CI \
                  + ".dbo.CBRProcessDetail (RunID,FileId,FileName,RunDate,LogTime,Step,Status,Detail) SELECT " \
                  + str(CBRRunID) + "," + str(CBRFileID) + ",'" + CBRFileName + "','" + str(RunDate) \
                  + "',GETDATE(),'FILE_WRITING','ERROR','" + msg + "'"
            # Execute CBRProcessDetailLog
            bDBOperation = udfExecuteQuery(sql)

            print(msg)
            log_msg(msg)
            email_message += '\n' + msg
            bBCPResult = False
            bStopProcessing = True
        # log_msg("DEBUG: " + ErrorMessage)

        # End - Update file status ERROR
    # End - if block - main
    return bStopProcessing


# ******************************************************************************************


def udfCheckBCPUtility():
    # This function will check existance of BCP
    # import subprocess
    cmd = ['bcp']
    try:
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        output = result.stdout.decode('utf-8')
        # print("RESULT - ", output)
        if output.find("bcp") >= 0:
            print("BCP Utility is installed")
            return True
    except FileNotFoundError as err:
        # print("ERROR - ",err)
        print("BCP Utility is not installed")
        return False


# ******************************************************************************************


def is_date_valid(this_date, option):
    # import time
    # Purpose: Check date validity based on option

    if option.upper() == 'MM-DD-YYYY':
        print(this_date)
        try:
            time.strptime(this_date, '%m-%d-%Y')
        except ValueError:
            return False
        else:
            return True
    elif option.upper() == 'MM/DD/YYYY':
        print(this_date)
        try:
            time.strptime(this_date, '%m/%d/%Y')
        except ValueError:
            return False
        else:
            return True


# ******************************************************************************************


def udfIsJazzEnv():
    # function must be used just after create a database connection object
    # import pyodbc
    # Purpose: Update data on database
    # Dependency: def print()
    db_conn = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
    udf_sql = "SELECT COUNT(1) FROM CPS_Environment WITH(NOLOCK) WHERE PODId = 3"
    # Create cursor object
    grc_obj_cursor = db_conn.cursor()
    try:
        # Execute query by using cursor
        grc_obj_cursor.execute(udf_sql)
        grc_qry_result = grc_obj_cursor.fetchall()
        grc_row_count = grc_qry_result[-1][-1]
        grc_obj_cursor.close()  # Close cursor
        db_conn.close()  # Close connection
        # objCon.close()  # Close database connection
        if grc_row_count == 1:
            return True
        else:
            return False
    except pyodbc.Error as err_grc:
        db_conn.close()  # Close connection
        grc_obj_cursor.close()  # Close cursor
        print("EXCEPTION: " + str(err_grc))


# ******************************************************************************************
# ******************************************************************************************
# main()
# ******************************************************************************************
# Import libraries
# ******************************************************************************************
print("DEBUG: Import modules.....")
try:
    import os
    import datetime
    # package should be install, if not [Command: pip install time]
    import time
    import configparser
    # package should be install, if not [Command: pip install pyodbc]
    import pyodbc
    # package should be install, if not [Command: pip install pandas]
    import pandas as pd
    import os.path
    # package should be install, if not [Command: pip install ssl]
    import ssl
    # package should be install, if not [Command: pip install smtplib]
    import smtplib
    # package should be install, if not [Command: pip install boto3]
    import boto3
    import json
    # package should be install, if not [Command: pip install subprocess]
    import subprocess
    import sys
    import linecache
    # package should be install, if not [Command: pip install inspect]
    import inspect
    # package should be install, if not [Command: pip install socket]
    import socket
    import shutil
    import unidecode

    from socket import gaierror
    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart
    from inspect import currentframe
    from pathlib import Path

    import pandas as pd

except ModuleNotFoundError as err:
    print(str({err.name.strip()}),
          " module is missing, Command to Install - {"" pip install ", str(err.name.strip()), "}")
    # log_msg(str({err.name.strip()}) +
    #         " module is missing, ICommand to Install - {"" pip install " + str(err.name.strip()) + " }")
    exit(1)

# ******************************************************************************************
# Initialize variables
computer_name = getComputerName()
computer_name = computer_name.upper()
# Database variables
objCon = None
DB_Server_NAME = DBName_CI = authenticationMode = post_dbms_login = post_dbms_passwd = ""
DB_Server_NAME_RPT = DBName_CI_RPT = post_dbms_login_RPT = post_dbms_passwd_RPT = ""
# General variables
InstitutionID = SysOrgID = SysSubOrgID = POD = 0
InstitutionDesc = alertName = ""
BatchScripts = EXECUTABLEPATH_DRIVE = EXECUTABLEPATH = emKMSdefaultMachines = PIIHubEnv = ""
bStopProcessing = False
log_file_name = LogFileName = ""
# Email variables
alert_email_source = alert_email_subject = alert_email_sender = alert_email_receiver = ""
ses_smtp_url = ses_smtp_port = ses_smtp_secret_name = ses_region_name = ""
smtp_server_name = smtp_port = ""
email_message = msg = ""
ProcessName = ""
# Folder variables
InFolder = OutFolder = ErrorFolder = LogFolder = IntermediateFolder = MultipleFiles = ""
# Process specific variables
pii_key_value = FileGenerationFlag = ""
LoopBatchSize = MAXRecordInFile = CheckPIIData = CBRReRunID = 0
CBRRunID = CBRFileID = PIIEnable = PortfolioType = 0
RunDate = CBRProcessStatus = CBRFileName = CBRFileStatus = GeneratedFileDetail = ""
CBReportingFrom = CBReportingTo = ""
bDBOperation = bBCPResult = True
bCBRFileGenerate = bPendingFileWriting = False
bcp_result = 1
sp_output = delta_time = cbr_process_start = file_writing_start = ""
sql_driver = file_status = ""
ForceFileGeneration = CBRFile_WithPII_To_WithoutPII = 0
# ******************************************************************************************
# Get values of environment variables from config file
process_dir = Path(__file__).parent
# app_dir = Path(__file__).parent.parent
app_dir = Path(__file__).parent
print("DEBUG: Process Directory - ", process_dir)
print("DEBUG: Application Directory - ", app_dir)
# Move to application directory
os.chdir(app_dir)
# Config file for general setup
config_file_name = "SetupCIPy.ini"
# print('DEBUG: Config File Name - ', config_file_name)

# Start - Check existance of BCP Utility
if not udfCheckBCPUtility():
    bStopProcessing = True
    exit(1)
# End - Check existance of BCP Utility

# Start - if block - check config file
if not os.path.exists(config_file_name):
    msg = 'ERROR: "' + config_file_name + '" not found'
    print(msg)
    # email_message += '\n' + msg
    bStopProcessing = True
# End - if block - check config file

# Start - if block - start reading config file
if not bStopProcessing:
    print("DEBUG: Config file reading...")
    # Get general values from config file
    POD = udfGetEnvVar(config_file_name, 'DEFAULT', 'POD')
    DB_Server_NAME = udfGetEnvVar(config_file_name, 'DEFAULT', 'DB_Server_NAME')
    DBName_CI = udfGetEnvVar(config_file_name, 'DEFAULT', 'DBName_CI')
    post_dbms_login = udfGetEnvVar(config_file_name, 'DEFAULT', 'post_dbms_login')
    post_dbms_passwd = udfGetEnvVar(config_file_name, 'DEFAULT', 'post_dbms_passwd')
    smtp_server_name = udfGetEnvVar(config_file_name, 'DEFAULT', 'SMTP_SERVER')
    smtp_port = udfGetEnvVar(config_file_name, 'DEFAULT', 'SMTP_PORT')
    BatchScripts = udfGetEnvVar(config_file_name, 'DEFAULT', 'BatchScripts')
    EXECUTABLEPATH_DRIVE = udfGetEnvVar(config_file_name, 'DEFAULT', 'EXECUTABLEPATH_DRIVE')
    EXECUTABLEPATH = udfGetEnvVar(config_file_name, 'DEFAULT', 'EXECUTABLEPATH')
    emKMSdefaultMachines = udfGetEnvVar(config_file_name, 'DEFAULT', 'emKMSdefaultMachines')
    authenticationMode = udfGetEnvVar(config_file_name, 'DEFAULT', 'authenticationMode')
    PIIHubEnv = udfGetEnvVar(config_file_name, 'DEFAULT', 'PIIHubEnv')
    # Get folder path from config file
    InFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBREPORTING_FILE_PATH')
    LogFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBR_LogFileFolderName')
    IntermediateFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBR_PIIFileIntermediate')
    MultipleFilesFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBR_MultipleFilesFolderName')
    # Get process specific variables
    LoopBatchSize = udfGetEnvVar(config_file_name, 'DEFAULT', 'LoopBatchSize')
    MAXRecordInFile = udfGetEnvVar(config_file_name, 'DEFAULT', 'MAXRecordInFile')
    ForceFileGeneration = udfGetEnvVar(config_file_name, 'DEFAULT', 'ForceFileGeneration')
    CBRFile_WithPII_To_WithoutPII = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBRFile_WithPII_To_WithoutPII')
    # Get email variables
    alert_email_source = udfGetEnvVar(config_file_name, 'DEFAULT', 'alert_email_source')
    alert_email_sender = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBREmailFrom')
    # if alert_email_source == 'AWS':
    #     alert_email_receiver = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBRNotifyEmail').split(",")
    # else:
    #     alert_email_receiver = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBRNotifyEmail')
    alert_email_receiver = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBRNotifyEmail').split(",")
    # Get AWS variables
    ses_smtp_secret_name = udfGetEnvVar(config_file_name, 'DEFAULT', 'ses_smtp_secret_name')
    ses_smtp_url = udfGetEnvVar(config_file_name, 'DEFAULT', 'ses_smtp_url')
    ses_region_name = udfGetEnvVar(config_file_name, 'DEFAULT', 'ses_region_name')
    ses_smtp_port = udfGetEnvVar(config_file_name, 'DEFAULT', 'ses_smtp_port')

    DB_Server_NAME_RPT = udfGetEnvVar(config_file_name, 'DEFAULT', 'DB_Server_NAME_RPT')
    DBName_CI_RPT = udfGetEnvVar(config_file_name, 'DEFAULT', 'DBName_CI_RPT')
    post_dbms_login_RPT = udfGetEnvVar(config_file_name, 'DEFAULT', 'post_dbms_login_RPT')
    post_dbms_passwd_RPT = udfGetEnvVar(config_file_name, 'DEFAULT', 'post_dbms_passwd_RPT')

    # Start - Hand both environment PROD / PRODDR
    print("DEBUG: ComputerName - ", computer_name)
    if (computer_name.upper().find("PRODDR") == -1):  # If PRODDR not found
        emKMSdefaultMachines = udfGetEnvVar(config_file_name, 'DEFAULT', 'emKMSdefaultMachines')
    else:
        emKMSdefaultMachines = udfGetEnvVar(config_file_name, 'DEFAULT', 'emKMSdefaultMachinesDR')
    print("DEBUG: emKMSdefaultMachines - ", emKMSdefaultMachines)

    if (computer_name.upper().find("PRODDR") == -1):  # If PRODDR not found
        smtp_server_name = udfGetEnvVar(config_file_name, 'DEFAULT', 'SMTP_SERVER')
    else:
        smtp_server_name = udfGetEnvVar(config_file_name, 'DEFAULT', 'SMTP_SERVER_DR')
    print("DEBUG: smtp_server_name - ", smtp_server_name)

    if (computer_name.upper().find("PRODDR") == -1):  # If PRODDR not found
        InFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBREPORTING_FILE_PATH')
    else:
        InFolder = udfGetEnvVar(config_file_name, 'DEFAULT', 'CBREPORTING_FILE_PATH_DR')
    print("DEBUG: CBREPORTING_FILE_PATH - ", InFolder)
    # End - Hand both environment PROD / PRODDR

    # Start - Folder validation
    if not bStopProcessing:
        if udfCheckEnvVal(LogFolder) == "0":
            if not os.path.exists(LogFolder):
                msg = 'ERROR: ' + '"' + LogFolder + '"' + ' folder not exists'
                print(msg)
                # email_message += '\n' + msg
                bStopProcessing = True
        else:
            msg = 'ERROR: "CBR_LogFileFolderName" values must be define in Config file'
            print(msg)
            # email_message += '\n' + msg
            bStopProcessing = True

        if udfCheckEnvVal(IntermediateFolder) == "0":
            if not os.path.exists(IntermediateFolder):
                msg = 'ERROR: "' + IntermediateFolder + '" folder not exists'
                print(msg)
                # email_message += '\n' + msg
                bStopProcessing = True
        else:
            mag = 'ERROR: "CBRIntermediateFolder" values must be define in Config file'
            print(msg)
            # email_message += '\n' + msg
            bStopProcessing = True

        if udfCheckEnvVal(MultipleFilesFolder) == "0":
            if not os.path.exists(MultipleFilesFolder):
                msg = 'ERROR: "' + MultipleFilesFolder + '" folder not exists'
                print(msg)
                # email_message += '\n' + msg
                bStopProcessing = True
        else:
            mag = 'ERROR: "CBR_MultipleFilesFolderName" values must be define in Config file'
            print(msg)
            # email_message += '\n' + msg
            bStopProcessing = True

        if udfCheckEnvVal(InFolder) == "0":
            if not os.path.exists(InFolder):
                msg = 'ERROR: "' + InFolder + '" folder not exists'
                print(msg)
                # email_message += '\n' + msg
                bStopProcessing = True
        else:
            msg = 'ERROR: "CBREPORTING_FILE_PATH" values must be define in Config file'
            print(msg)
            # email_message += '\n' + msg
            bStopProcessing = True
    # End - Folder validation
# End - if block - start reading config file

# Start - if block - Get input parameters
if not bStopProcessing:
    try:
        ParamCount = len(sys.argv)
        print("DEBUG: Parameter Count - " + str(ParamCount))
        if ParamCount == 2:  # ProcessName
            # Param1 - SysOrgID
            ProcessName = str(sys.argv[1])
            msg = "DEBUG: Process Name - " + ProcessName
            print(msg)
        else:
            ProcessName = ""
            msg = "INFO: ProcessName is missing"
            print(msg)

    except IndexError as err_idx:
        print("ERROR: " + str(err_idx))
        bStopProcessing = True
# End - if block - Get input parameters

# Start - if block - Construct log file name
if not bStopProcessing:
    try:
        print("DEBUG: Construct log file name")
        log_current_datetime = datetime.datetime.now()
        log_self_file_name = udfGetSelfFilename()  # user define function
        log_file_name = log_self_file_name + '_' + udfGetFormatDateTime("MMDDYYYY") + ".log"

        print("DEBUG: Log file name - " + log_file_name)

        if os.path.exists(LogFolder):
            LogFileName = os.path.abspath((os.path.join(LogFolder, log_file_name)))
        else:
            # log file will be created at current directory
            LogFileName = os.path.abspath((os.path.join(os.getcwd(), log_file_name)))

        # Custom Variable
        # alert_email_receiver = prasoon.@corecard.com,vprajapati@corecard.com,ritikvardhan.jain@corecard.com".split(",")
        # LogFolder = os.path.abspath(os.path.join(process_dir, "LOG"))
        # LogFileName = os.path.abspath(os.path.join(LogFolder, log_file_name))
    except Exception as e:
        msg = udfGetException()
        print(msg)
        # email_message = msg
        bStopProcessing = True
# End - if block - Construct log file name

# Start - AWS variable validation
if not bStopProcessing and alert_email_source == 'AWS':
    if ses_smtp_secret_name == "":
        log_msg("ERROR: AWS secret name is missing")
        bStopProcessing = True
    if ses_smtp_url == "":
        log_msg("ERROR: AWS smtp url is missing")
        bStopProcessing = True
    if ses_region_name == "":
        log_msg("ERROR: AWS region name is missing")
        bStopProcessing = True
    if ses_smtp_port == "":
        log_msg("ERROR: AWS smtp port is missing")
        bStopProcessing = True
# End - AWS variable validation

# Start - if block - Get Institution Info
if not bStopProcessing:
    try:
        # Create connection object
        objCon = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
        msg = "DEBUG: ODBC Driver - " + sql_driver
        print(msg)
        log_msg(msg)

        objCon.close()
    except Exception as e:
        msg = udfGetException()
        print(msg)
        # email_message = msg
        bStopProcessing = True
# End - if block - Get Institution Info

if bStopProcessing:
    print('ERROR: Exit from CBR File Generation Processing')
    exit(1)  # Exit from script execution, because log file did not created yet++

# Start - if block - default values assignment
if not bStopProcessing:
    log_msg("***********************************************************************************")
    log_msg("DEBUG: START - CBR File Generation Operation")
    # **************************************************************************************
    log_msg("DEBUG: Environment Values")
    log_msg('DEBUG: DB_Server_NAME : ' + DB_Server_NAME)
    log_msg('DEBUG: DBName_CI : ' + DBName_CI)
    log_msg('DEBUG: smtp_server_name : ' + smtp_server_name)
    log_msg('DEBUG: smtp_port : ' + smtp_port)
    # **************************************************************************************
    # log_msg('DEBUG: InFolder : ' + InFolder)
    # log_msg('DEBUG: LogFolder : ' + LogFolder)
    # log_msg('DEBUG: IntermediateFolder = : ' + IntermediateFolder)
    # **************************************************************************************
    # log_msg('DEBUG: BatchScripts : ' + BatchScripts)
    # log_msg('DEBUG: CheckPIIData : ' + str(CheckPIIData))
    # log_msg('DEBUG: PIIHubEnv : ' + PIIHubEnv)
    # log_msg('DEBUG: PortfolioType : ' + str(PortfolioType))
    # log_msg('DEBUG: CBRReRunID : ' + str(CBRReRunID))
    # log_msg('DEBUG: FileGenerationFlag : ' + FileGenerationFlag)
    # log_msg('DEBUG: ForceFileGeneration : ' + ForceFileGeneration)
    log_msg('DEBUG: alert_email_sender : ' + alert_email_sender)
    log_msg('DEBUG: ProcessName : ' + ProcessName)
    # **************************************************************************************
    # log_msg('DEBUG: ses_smtp_secret_name : ' + ses_smtp_secret_name)
    # log_msg('DEBUG: ses_smtp_url : ' + ses_smtp_url)
    # log_msg('DEBUG: ses_region_name : ' + ses_region_name)
    # log_msg('DEBUG: ses_smtp_port : ' + ses_smtp_port)
    # **************************************************************************************
# End - if block - default values assignment

# Start - if block - before process start
log_msg('DEBUG: bStopProcessing - ' + str(bStopProcessing))
if bStopProcessing:
    print('ERROR: Exit from CBR File Generation Operation')

    log_msg('ERROR: Exit from CBR File Generation Operation')
    log_msg('DEBUG: Good bye!')
# End - if block - before process start

email_body_html = 'Process Name:- ' + ProcessName
# Start - main if block

try:
    if not bStopProcessing:
        sp_result = ""
        sp_name = ""

        if str(ProcessName) == 'PHPCorrection' or str(ProcessName) == 'PHPUpdate':
            qry = """
                    TRUNCATE TABLE PHPCorrectionData 
                    """
            udfExecuteQuery_RPT(qry)

            if udfIsJazzEnv():
                msg = "DEBUG: Calling PHP Correction for JAZZ"
                log_msg(msg)
                print(msg)
                sp_name = "USP_PHPCorrectionData_JAZZ"
                msg = "DEBUG: SP Name - " + sp_name
                log_msg(msg)
                print(msg)
            else:
                msg = "DEBUG: Calling PHP Correction for COOKIE"
                log_msg(msg)
                print(msg)
                sp_name = "USP_PHPCorrectionData_PLAT"
                msg = "DEBUG: SP Name - " + sp_name
                log_msg(msg)
                print(msg)

            sql_exec_sp = 'EXEC ' + sp_name 
        else:
            if udfIsJazzEnv():
                msg = "DEBUG: Calling CBR File Generation Operation for JAZZ"
                log_msg(msg)
                print(msg)
                sp_name = "PR_CBR_FileGenerationOperation_JAZZ"
                msg = "DEBUG: SP Name - " + sp_name
                log_msg(msg)
                print(msg)
            else:
                msg = "DEBUG: Calling CBR File Generation Operation for COOKIE"
                log_msg(msg)
                print(msg)
                sp_name = "PR_CBR_FileGenerationOperation_PLAT"
                msg = "DEBUG: SP Name - " + sp_name
                log_msg(msg)
                print(msg)

            sql_exec_sp = 'EXEC ' + sp_name + ' ' + str(ProcessName)

        # sql_exec_sp = 'EXEC ' + sp_name + ' ' + str(ProcessName)

        # log_msg("DEBUG: Stored Procedure Call - " + sp_name)
        print("DEBUG: Stored Procedure Call - " + sp_name)
        log_msg("DEBUG: " + sql_exec_sp)

        # Call stored procedure calling function
        if str(ProcessName) == 'PHPCorrection' or str(ProcessName) == 'PHPUpdate':
            sp_output = udfExecSP_RPT(sql_exec_sp)
        else:
            sp_output = udfExecSP(sql_exec_sp)

        # Start - if block - check sp result
        sp_output = sp_output.split('|')  # Split comma separated output
        # log_msg("RESULT: " + sp_output[0])

        if str(ProcessName) == 'PHPCorrection' or str(ProcessName) == 'PHPUpdate':
            if sp_output[0] == 'SUCCESS':
                if int(sp_output[1]) > 0: 
                    qry = """
                            SELECT RTRIM(AccountNumber) AccountNumber,acctId,StatementDate,PHPCounter,CurrentCounterValue,UpdatedCounterValue 
                            FROM PHPCorrectionData WITH (NOLOCK) 
                            WHERE JobStatus = 'NEW' 
                            ORDER BY acctId
                        """
                    # print("DEBUG: Query Call - " + qry)
                    # log_msg("DEBUG: " + qry)

                    es_sp_result = ''
                    conn_se = None
                    ResultDataFrame = None

                    try:
                        # Create connection object
                        conn_se = udfCreateDatabaseConnection(DB_Server_NAME_RPT, DBName_CI_RPT)
                        es_sp_output = pd.read_sql_query(qry, conn_se)
                        ResultDataFrame = pd.DataFrame(es_sp_output)
                        # print(ResultDataFrame)
                        ResponseFileName = "PHPCorrection_" + udfGetFormatDateTime("YYYYMMDDHHMMSS") + ".txt"
                        ResponseFileName = os.path.join(MultipleFilesFolder, ResponseFileName)
                        ResultDataFrame.to_csv(ResponseFileName, sep=',', index=False)
                        sp_output[1] = sp_output[1] + " RECORDS ARE IMPACTED AND RESPONSE FILE IS PLACED AT MULTIPLEFILES LOCATION."
                    except pyodbc.Error as err_es_exec_sp:
                        es_sp_result = "ERROR: - " + str(err_es_exec_sp)
                        log_msg(es_sp_result)
                        # Rollback transaction
                        # conn_se.rollback()
                    except pyodbc.ProgrammingError as err_es_exec_sp_pe:
                        es_sp_result = "ERROR: - " + str(err_es_exec_sp_pe)
                        log_msg(es_sp_result)
                        # Rollback transaction
                        # conn_se.rollback()

                    if len(ResultDataFrame) > 0 and str(ProcessName) == 'PHPUpdate':
                        # qry = """
                        #     TRUNCATE TABLE PHPCorrectionData 
                        #     """ 
                        # # print("DEBUG: Query Call - " + qry)
                        # # log_msg("DEBUG: " + qry)

                        # udfExecuteQuery_RPT(qry)

                        es_sp_result = ''
                        conn_se = None

                        try:
                            # Create connection object
                            conn_se = udfCreateDatabaseConnection(DB_Server_NAME, DBName_CI)
                            # Open cursor object
                            objCursor_es_exec_sp = conn_se.cursor()
                            # print(ResultDataFrame)
                            # print(len(ResultDataFrame))

                            for index, rows in ResultDataFrame.iterrows():
                                # print(f"Index = {index} == Row = {rows}")
                                objCursor_es_exec_sp.execute(
                                        """
                                            INSERT INTO PHPCorrectionData (AccountNumber,acctId,StatementDate,PHPCounter,CurrentCounterValue,UpdatedCounterValue)
                                            VALUES (?, ?, ?, ?, ?, ?)
                                            """,
                                            rows['AccountNumber'], rows['acctId'], rows['StatementDate'], rows['PHPCounter'], rows['CurrentCounterValue'], rows['UpdatedCounterValue']
                                    )
                                
                            conn_se.commit()
                            objCursor_es_exec_sp.close()  # Close cursor
                            conn_se.close()  # Close database connection

                        except pyodbc.Error as err_es_exec_sp:
                            es_sp_result = "ERROR: - " + str(err_es_exec_sp)
                            log_msg(es_sp_result)
                            # Rollback transaction
                            conn_se.rollback()
                        except pyodbc.ProgrammingError as err_es_exec_sp_pe:
                            es_sp_result = "ERROR: - " + str(err_es_exec_sp_pe)
                            log_msg(es_sp_result)
                            # Rollback transaction
                            conn_se.rollback()

                        qry = f"SELECT COUNT(1) row_count FROM {DBName_CI}..PHPCorrectionData WITH (NOLOCK) WHERE JobStatus = 'NEW'"
                        PHPCount = udfGetRowCount(qry)
                        print(f"DEBUG: Total records to update for PHP = {PHPCount}")

                        if PHPCount > 0:
                            msg = "DEBUG: Calling PHP Updation"
                            log_msg(msg)
                            print(msg)
                            sp_name = "USP_PHPCorrectionUpdate"
                            msg = "DEBUG: SP Name - " + sp_name
                            log_msg(msg)
                            print(msg)

                            sql_exec_sp = 'EXEC ' + sp_name
                            print("DEBUG: Stored Procedure Call - " + sp_name)
                            log_msg("DEBUG: " + sql_exec_sp)
                            sp_output = udfExecSP(sql_exec_sp)

                            sp_output = sp_output.split('|')
                            sp_output[1] = sp_output[1] + " RECORDS ARE UPDATED AND RESPONSE FILE IS PLACED AT MULTIPLEFILES LOCATION."

                        else:
                            sp_output[1] = "NO RECORD TO UPDATE."
                else:
                    sp_output[1] = "NO RECORD TO UPDATE."

        
        if sp_output[0] == 'SUCCESS':
            alert_email_subject = "CBR_FileGenerationOperation Success on Environment (" + computer_name + ") [POD - " + str(
                POD) + "]"
            msg = "DEBUG: SP Result - " + sp_output[0]
            log_msg(msg)
            print(msg)

            msg = "DEBUG: Description - \n" + sp_output[1]
            log_msg(msg)
            print(msg)
            email_body_html += '\n' + "Description - \n" + sp_output[1]

        else:
            alert_email_subject = "CBR_FileGenerationOperation Failed on Environment (" + computer_name + ") [POD - " + str(
                POD) + "]"

            msg = "DEBUG: SP Result - " + sp_output[0]
            log_msg(msg)
            print(msg)

            msg = "DEBUG: Description - \n" + sp_output[1]
            log_msg(msg)
            print(msg)
            email_body_html += '\n' + "Description - \n" + sp_output[1]

        # End - If Block bPendingFileWriting

        email_message = email_body_html
        # Send notification mail
except Exception as Ex:
    msg = "ERROR: - " + str(Ex)
    log_msg(msg)
    print(msg)
    alert_email_subject = "CBR_FileGenerationOperation Failed on Environment (" + computer_name + ") [POD - " + str(
        POD) + "]"
    email_message = msg

emailSend()
# End - main if block

# ******************************************************************************************
# Main Body - End
# ******************************************************************************************
print("***************************************************************************")
print("** CBR File Generation Operation has been done                           **")
print("** Thank You For Running                                                 **")
print("***************************************************************************")
