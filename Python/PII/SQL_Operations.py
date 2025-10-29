from DataBaseConnections import db_connection
import pyodbc


# General function for executing any query
def execute_sql(db_name: str, db_server, sql_query: str, fetch_mode=None, params=None):
    result = None
    # print(sql_query)
    # print(db_name)
    try:
        with db_connection(db_name, db_server) as connection:
            with connection.cursor() as cursor:
                # Execute query with optional parameters
                if params:
                    cursor.execute(sql_query, params)
                else:
                    cursor.execute(sql_query)

                # Fetch results if specified
                if fetch_mode == "one":
                    result = cursor.fetchone()
                elif fetch_mode == "all":
                    result = cursor.fetchall()

                # Commit for any update/insert operations
                connection.commit()
    except pyodbc.DatabaseError as e:
        print(f"Database error occurred: {e}")
        raise
    except Exception as e:
        print(f"An error occurred: {e}")
        raise

    return result
