import uuid
import random
from faker.providers import BaseProvider
from SQL_Operations import execute_sql



# List of New York zip codes
new_york_zip_codes = [
    '10001', '10002', '10003', '10004', '10005', '10006', '10007', '10008', 
    '10009', '10010', '10011', '10012', '10013', '10014', '10016', '10017', 
    '10018', '10019', '10020', '10021', '10022', '10023', '10024', '10025', 
    '10026', '10027', '10028', '10029', '10030', '10031', '10032', '10033', 
    '10034', '10035', '10036', '10037', '10038', '10039', '10040', '10041', 
    '10044', '10045', '10048', '10055', '10060', '10065', '10069', '10075', 
    '10080', '10081', '10087', '10103', '10110', '10111', '10112', '10115', 
    '10118', '10119', '10120', '10121', '10122', '10123', '10128', '10151', 
    '10152', '10153', '10154', '10155', '10158', '10162', '10165', '10166', 
    '10167', '10168', '10169', '10170', '10171', '10172', '10173', '10174', 
    '10175', '10176', '10177', '10178', '10179', '10199', '10271', '10278', 
    '10279', '10280', '10281', '10282', '10301', '10302', '10303', '10304', 
    '10305', '10306', '10307', '10308', '10309', '10310', '10311', '10312', 
    '10314', '10451', '10452', '10453', '10454', '10455', '10456', '10457', 
    '10458', '10459', '10460', '10461', '10462', '10463', '10464', '10465', 
    '10466', '10467', '10468', '10469', '10470', '10471', '10472', '10473', 
    '10474', '10475', '11004', '11005', '11101', '11102', '11103', '11104', 
    '11105', '11106', '11109', '11201', '11203', '11204', '11205', '11206', 
    '11207', '11208', '11209', '11210', '11211', '11212', '11213', '11214', 
    '11215', '11216', '11217', '11218', '11219', '11220', '11221', '11222', 
    '11223', '11224', '11225', '11226', '11228', '11229', '11230', '11231', 
    '11232', '11233', '11234', '11235', '11236', '11237', '11238', '11239', 
    '11240', '11241', '11242', '11243', '11249', '11251', '11252', '11256', 
    '11351', '11354', '11355', '11356', '11357', '11358', '11359', '11360', 
    '11361', '11362', '11363', '11364', '11365', '11366', '11367', '11368', 
    '11369', '11370', '11371', '11372', '11373', '11374', '11375', '11377', 
    '11378', '11379', '11385', '11411', '11412', '11413', '11414', '11415', 
    '11416', '11417', '11418', '11419', '11420', '11421', '11422', '11423', 
    '11424', '11425', '11426', '11427', '11428', '11429', '11430', '11432', 
    '11433', '11434', '11435', '11436', '11691', '11692', '11693', '11694', 
    '11695', '11697'
]

class NewYorkZipCodeProvider(BaseProvider):
    def ny_zipcode(self):
        return self.random_element(new_york_zip_codes)



def generate_insert_statement(ClientID, CIDB, fake):
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
    postal_code = fake.ny_zipcode()
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

def check_pii_generator(account_id, customer_id, db_server, db_name) -> bool:
    
    check = False
    
    query = f"SELECT TOP 1 1 [Check] FROM {db_name}..RandomPIIGenerator WITH (NOLOCK) WHERE BSAcctID = {account_id} AND CustomerID = {customer_id} AND Status = 'DONE'"
    # print(query)
    row = execute_sql(db_name, db_server, query, "all")
    row_count = len(row)
    
    if row_count > 0:
        for r in row:
            value = str(r.Check)
            if value == "1":
                check = True
            break
        
    return check

def get_all_account_ids(db_server, db_name) -> list:
    
    new_pii_accounts = []
    
    query = f"select bsacctid, c.customerid, c.customertype from {db_name}..customer c (nolock) join {db_name}..BSegment_Primary bp (nolock) ON c.BsAcctid = bp.acctId"
    
    row = execute_sql(db_name, db_server, query, "all")
    row_count = len(row)
    
    query = f"DELETE FROM {db_name}..RandomPIIGenerator WHERE Status = 'NEW'"
    execute_sql(db_name, db_server, query)
    
    if row_count > 0:
        for r in row:
            bsacctid = str(r.bsacctid)
            customerid = str(r.customerid)
            customertype = str(r.customertype)
            
            check = check_pii_generator(bsacctid, customerid, db_server, db_name)
            
            if check == False:
                query = f"INSERT INTO {db_name}..RandomPIIGenerator (BSAcctID, CustomerID, CustomerType, Status) VALUES ({bsacctid},{customerid},{customertype},'NEW')"
                execute_sql(db_name, db_server, query)
                new_pii_accounts.append([bsacctid, customerid, customertype])
    
    return new_pii_accounts

def update_clientid_and_generate_pii(new_pii_accounts, ci_db, ci_secondary_db, db_server, fake):
    ClientIDGenerated = []
    
    for bsacctid, customerid, customertype in new_pii_accounts:
        gen_cid = str(uuid.uuid4())
        ClientIDGenerated.append(gen_cid)
        
        if customertype == "01":
            qry = f"UPDATE {ci_db}..BSegment_Secondary SET ClientID = '" + gen_cid + "' WHERE AcctID = " +  str(bsacctid)
            execute_sql(ci_db, db_server, qry)
            qry = f"UPDATE {ci_db}..StatementJobs SET ClientID = '" + gen_cid + "' WHERE AcctID = " +  str(bsacctid)
            execute_sql(ci_db, db_server, qry)
            qry = f"UPDATE {ci_secondary_db}..StatementHeader SET ClientID = '" + gen_cid + "' WHERE AcctID = " +  str(bsacctid)
            execute_sql(ci_db, db_server, qry)
            
        
        qry = f"UPDATE {ci_db}..Customer SET ClientID = '" + gen_cid + "' WHERE customerid = " +  str(customerid)
        execute_sql(ci_db, db_server, qry)
        qry = "UPDATE SHC SET SHC.ClientID = '" + gen_cid + f"' FROM {ci_db}..SummaryHeaderCreditCard SHC JOIN {ci_secondary_db}..SummaryHeader SH ON SHC.StatementID = SH.StatementID AND SHC.AcctID = SH.AcctID WHERE SH.CustomerID = " +  str(customerid)
        execute_sql(ci_db, db_server, qry)
        qry = "UPDATE SHC SET SHC.ClientID = '" + gen_cid + f"' FROM {ci_db}..CPSgmentCreditCard SHC JOIN {ci_db}..CPSgmentAccounts SH ON SHC.AcctID = SH.AcctID WHERE SH.CustomerID = " +  str(customerid)
        execute_sql(ci_db, db_server, qry)
        qry = f"UPDATE {ci_db}..RandomPIIGenerator SET PersonID = '{gen_cid}' WHERE BSAcctID = {bsacctid} AND CustomerID = {customerid} AND CustomerType = {customertype}"
        execute_sql(ci_db, db_server, qry)
        
        print(f"generated personid {gen_cid} assigned to account {bsacctid} customer {customerid} customertype {customertype}")


    print("Count of ClientID " + str(len(ClientIDGenerated)))

    for ClientID in ClientIDGenerated:
        
        qry = generate_insert_statement(ClientID, ci_db, fake)
        execute_sql(ci_db, db_server, qry)
        qry = f"UPDATE {ci_db}..RandomPIIGenerator SET Status = 'DONE' WHERE PersonID = '{ClientID}'"
        execute_sql(ci_db, db_server, qry)
        print("pii generator for personid ", ClientID)
            
    
    



