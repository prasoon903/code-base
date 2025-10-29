import pyodbc
from contextlib import contextmanager


# This function retrieves the connection string for a given database name
def get_connection(db_name: str, db_server: str):
    return pyodbc.connect(
        Driver="{ODBC Driver 17 for SQL Server}",
        Server=db_server,
        Database=db_name,
        Trusted_Connection='yes',
        autocommit=True
    )


# Context manager to ensure connection is properly closed
@contextmanager
def db_connection(db_name: str, db_server):
    connection = get_connection(db_name, db_server)
    try:
        yield connection
    finally:
        connection.close()
