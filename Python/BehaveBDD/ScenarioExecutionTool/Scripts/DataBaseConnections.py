import json
import pyodbc
import os
import Scripts.Config as c

# RootPath = os.environ.get('RootPath')

# Configuration = json.load(open(RootPath+"\Configuration/Configuration.json"))

Configuration = c.Configuration

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