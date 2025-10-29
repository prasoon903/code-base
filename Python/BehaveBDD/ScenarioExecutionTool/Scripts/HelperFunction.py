import random
import os
import json
import uuid
import re
import subprocess
from Scripts.GetLogger import MessageLogger
import Scripts.Config as c
from faker import Faker

RootPath = c.BasePath
fake = Faker()


def get_random_uuid_from_file():
    file_path = RootPath + f"\JsonPayload/Qaclientid.txt"
    with open(file_path, 'r') as file:
        uuid_list = [line.strip() for line in file if line.strip()]  # Read non-empty lines from the file

    if not uuid_list:
        MessageLogger.debug("The file is empty or does not contain valid UUIDs.")
        return None

    random_uuid = random.choice(uuid_list)
    return random_uuid


def replace_guids(obj):
    if isinstance(obj, dict):
        for key, value in obj.items():
            if isinstance(value, (str, bytes)):
                obj[key] = value.replace("{{$guid}}", str(uuid.uuid1()))
            elif isinstance(value, (dict, list)):
                replace_guids(value)
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            if isinstance(item, (str, bytes)):
                obj[i] = item.replace("{{$guid}}", str(uuid.uuid1()))
            elif isinstance(item, (dict, list)):
                replace_guids(item)


def read_file_to_string(file_path):
    try:
        MessageLogger.debug(file_path)
        if os.path.isfile(file_path):
            with open(file_path, 'r') as file:
                file_contents = file.read()
            return file_contents
    except FileNotFoundError:
        MessageLogger.debug(f"File '{file_path}' not found.")
        return None


def fn_GetAPIResponseTags(APIName):
    json_data = json.load(open(RootPath + f"\JsonPayload/Response_{APIName}.json"))
    return json_data


def fn_GetKeyValueFromJsonFile(APIName, tagName, RootPath):
    APIJson = json.load(open(RootPath+f"\JsonPayload/{APIName}.json"))
    return APIJson[tagName]


def fn_OverrideTagName(json_data, oldname, newname):
    # Find the index of the "TransactionID" tag in the "TagName" list
    # json_data = json.dumps(json_data, indent=2)
    MessageLogger.debug("json_data before " + str(json_data))
    try:
        
        for i in range(len(json_data["VariableName"])):
            if json_data["VariableName"][i] == oldname:
                json_data["VariableName"][i] = newname
            
        # Convert the JSON data back to a JSON string
        # overridden_json = json.dumps(json_data, indent=2)
        MessageLogger.debug("json_data after " + str(json_data))
    except ValueError:
        index_to_override = None
    except Exception as e:
        MessageLogger.error(f"Error in fn_OverrideTagName {e}", exc_info=True)
    return json_data


def fn_TablefromJSON(json_data):
    table_var = None
    try:
    #df = pd.DataFrame(APIJson)
    #table_var = df.to(index=False)
    #table_var = [(json_data["TagName"][i], json_data["VariableName"][i]) for i in range(len(json_data["TagName"]))]
    # Combine the headers and data into a list of tuples
    # table_var = list(zip(['TagName', 'VariableName'], json_data["TagName"], json_data["VariableName"]))
        table_var = list(zip(json_data["TagName"], json_data["VariableName"]))
    # MessageLogger.info the table
        MessageLogger.debug(table_var)
    except Exception as e:
        MessageLogger.error(f"Error in fn_TablefromJSON -> {e}")
    return table_var


def fn_GetTableofResponseTags(json_data):
    # json_data = json.load(open(RootPath+f"\JsonPayload/Response_{APIName}.json"))
    #df = pd.DataFrame(APIJson)
    #table_var = df.to(index=False)
    MessageLogger.debug(json_data)
    # table_var = [(json_data["TagName"][i], json_data["VariableName"][i]) for i in range(len(json_data["VariableName"]))]
    table_var = [('TagName', 'VariableName')] + list(zip(json_data["TagName"], json_data["VariableName"]))
    # MessageLogger.info the table
    MessageLogger.debug("Table after" + str(table_var))
    return table_var


def fn_SaveProcessDetails(ProcessName, ProcessID):
    file_path = RootPath + f"\ProcessDetails/ProcessDetails.json"
    ProcessDetails = json.load((open(file_path)))
    if ProcessName in ProcessDetails:
        ProcessDetails[f"{ProcessName}"] = ProcessID
    else:
        ProcessDetails[f"{ProcessName}"] = ProcessID
    MessageLogger.info(ProcessDetails)
    with open(file_path, "w") as json_file:
        json.dump(ProcessDetails, json_file, indent=2)


def fn_StopProcess(ProcessName):
    file_path = RootPath + f"\ProcessDetails/ProcessDetails.json"
    ProcessDetails = json.load((open(file_path)))
    MessageLogger.info(f"ProcessName: {ProcessName}")
    ProcessID = 0
    if ProcessName in ProcessDetails:
        ProcessID = ProcessDetails[f"{ProcessName}"]
        MessageLogger.info(f"ProcessID: {ProcessID}")
    else:
        MessageLogger.info("Process does not exists")
    try:
        cmd = f"taskkill /F /PID {ProcessID}"
        MessageLogger.info(f"cmd: {cmd}")
        subprocess.run(cmd)
        MessageLogger.info(f"Process with PID {ProcessID} terminated.")
    except ProcessLookupError:
        MessageLogger.info(f"Process with PID {ProcessID} not found.")
    except PermissionError:
        MessageLogger.info(f"Permission error. Unable to terminate process with PID {ProcessID}.")


def generate_insert_statement_for_PII(ClientID, CIDB):
    
    person_id = ClientID # str(uuid.uuid4())
    EmmaReference = "75906447"
    first_name = fake.first_name()
    last_name = fake.last_name()
    address_id = str(uuid.uuid4())
    address_type = 'LegalResidence'
    address_lines = fake.street_address()
    city = fake.city()[:20]
    state = fake.state_abbr()
    country_code = 'USA'
    postal_code = fake.postcode()
    is_primary = '1'
    locale = 'UnitedStates'
    address_added_date = fake.date_time_this_year(before_now=True, after_now=False).strftime('%b %d %Y %I:%M%p')
    emails_id = str(uuid.uuid4())
    email_address = fake.email()
    emails_type = 'Personal'
    emails_added_date = fake.date_time_this_year(before_now=True, after_now=False).strftime('%b %d %Y %I:%M%p')
    emails_is_verified = '0'
    national_identifier_country_code = 'USA'
    national_identifier_type = 'SSN'
    national_identifier_id = fake.ssn()
    phone_numbers_id = str(uuid.uuid4())
    phone_number = '+121' + str(random.randint(10000000, 99999999))
    phone_numbers_type = 'MOBILE'
    phone_numbers_country_code = 'USA'
    phone_numbers_priority = 'Primary'
    phone_numbers_added_date = fake.date_time_this_year(before_now=True, after_now=False).strftime('%b %d %Y %I:%M%p')
    phone_numbers_is_varified = '0'
    tcpa_consent = 'YES'
    date_of_birth = fake.date_of_birth(minimum_age=18, maximum_age=90).strftime('%Y-%m-%d')
    marital_status = random.choice(['SINGLE', 'MARRIED', 'DIVORCED'])
    modified_on = fake.date_time_this_year(before_now=True, after_now=False).strftime('%b %d %Y %I:%M%p')
    created_on = fake.date_time_this_year(before_now=True, after_now=False).strftime('%b %d %Y %I:%M%p')
    citizenships = 'US'
    unverified = '0'

    return f"insert into {CIDB}..PersonHubDetail ([PersonID] ,[EmmaReference] ,[FirstName], [LastName], [AddressId], [AddressType], [AddressLines], [Addresses_City], [Addresses_StateOrProvince], [Addresses_CountryCode], [Addresses_PostalCode], [IsPrimary], [Locale], [AddressAddedDate], [Emails_Id], [EmailAddress], [Emails_Type], [Emails_AddedDate], [Emails_IsVerified], [NationalIdentifier_CountryCode], [NationalIdentifier_Type], [NationalIdentifier_Id], [PhoneNumbers_Id], [PhoneNumber], [PhoneNumbers_Type], [PhoneNumbers_CountryCode], [PhoneNumbers_Priority], [PhoneNumbers_AddedDate], [PhoneNumbers_IsVarified], [TCPAConsent], [DateOfBirth], [MaritalStatus], [ModifiedOn], [CreatedOn], [Citizenships], [Unvarified]) VALUES ('{person_id}', '{EmmaReference}', '{first_name}', '{last_name}', '{address_id}', '{address_type}', '{address_lines}', '{city}', '{state}', '{country_code}', '{postal_code}', '{is_primary}', '{locale}', '{address_added_date}', '{emails_id}', '{email_address}', '{emails_type}', '{emails_added_date}', '{emails_is_verified}', '{national_identifier_country_code}', '{national_identifier_type}', '{national_identifier_id}', '{phone_numbers_id}', '{phone_number}', '{phone_numbers_type}', '{phone_numbers_country_code}', '{phone_numbers_priority}', '{phone_numbers_added_date}', '{phone_numbers_is_varified}', '{tcpa_consent}', '{date_of_birth}', '{marital_status}', '{modified_on}', '{created_on}', '{citizenships}', '{unverified}');"