import json
import pyodbc

Configuration = json.load(open("Configuration/Configuration.json"))

DBCon = pyodbc.connect(Driver = Configuration['ODBCDriver'] ,
                    Server = Configuration['DBServer'],
                    Database = Configuration["YourDBNames"]["COREISSUE"],
                    Trusted_Connection ='yes',
                    autocommit = True
                    )
DBCon_CoreAuth = pyodbc.connect(Driver = Configuration['ODBCDriver'] ,
                    Server = Configuration['DBServer'],
                    Database = Configuration["YourDBNames"]["COREAUTH"],
                    Trusted_Connection ='yes',
                    autocommit = True
                    )