import json
import time
from faker import Faker
from SQL_Operations import execute_sql
from RandomPII import NewYorkZipCodeProvider, get_all_account_ids, update_clientid_and_generate_pii


if __name__ == '__main__':

    # Load the JSON config file
    with open('./dbsetup.config', 'r') as f:
        config = json.load(f)
        
    load_profile = int(config['loadprofile'])

    CI_DB = config[f"{load_profile}"]["coreissue"]
    CI_Secondary_DB = config[f"{load_profile}"]["coreissue_secondary"]
    SERVERNAME = config[f"{load_profile}"]["server"]
    
    qry = f"""
    IF NOT EXISTS (SELECT TOP 1 1 FROM sys.tables WHERE name = 'RandomPIIGenerator')
    BEGIN
        CREATE TABLE RandomPIIGenerator (
            PersonID VARCHAR(64),
            BSAcctID INT,
            CustomerID INT,
            CustomerType INT,
            Status VARCHAR(10)
        )
    END
    """
    execute_sql(CI_DB, SERVERNAME, qry)
    
    fake = Faker()
    fake.add_provider(NewYorkZipCodeProvider)
    
    while(True):
        new_pii_accounts = get_all_account_ids(SERVERNAME, CI_DB)
        print("found account/customer for pii yet to be generated", len(new_pii_accounts))
        if len(new_pii_accounts) > 0:
            update_clientid_and_generate_pii(new_pii_accounts, CI_DB, CI_Secondary_DB, SERVERNAME, fake)
            print("pii generated for ", len(new_pii_accounts))
        else:
            print("Sleep for 5 sec")
            time.sleep(5)
        