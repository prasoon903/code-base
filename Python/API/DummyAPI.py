from flask import Flask
from requests import request
from flask_restful import Resource, Api
# from sqlalchemy import create_engine
from json import dumps
from flask.ext.jsonpify import jsonify
import pyodbc

# db_connect = create_engine('sqlite:///chinook.db')
app = Flask(__name__)
api = Api(app)

CI_DB = "PARASHAR_CB_CI"
CL_DB = "PARASHAR_CB_CL"
CAuth_DB = "PARASHAR_CB_CAuth"
SERVERNAME = "XEON-S8"

# Create connection


def ConnectDB():
    con = pyodbc.connect(p_str=True, driver="{SQL Server}", server=SERVERNAME, Trusted_Connection='yes')
    cur = con.cursor()
    return cur


class Employees(Resource):
    def get(self):
        # conn = db_connect.connect() # connect to database
        conn = ConnectDB()
        SQL = 'SELECT acctid, AccountNumber FROM ' + CI_DB + '..BSegment_Primary WITH (NOLOCK)'
        query = conn.execute(SQL)  # This line performs query and returns json result
        return {'Account': [i[0] for i in query.cursor.fetchall()]}  # Fetches first column that is Employee ID

'''
class Tracks(Resource):
    def get(self):
        conn = db_connect.connect()
        query = conn.execute("select trackid, name, composer, unitprice from tracks;")
        result = {'data': [dict(zip(tuple (query.keys()) ,i)) for i in query.cursor]}
        return jsonify(result)

class Employees_Name(Resource):
    def get(self, employee_id):
        conn = db_connect.connect()
        query = conn.execute("select * from employees where EmployeeId =%d "  %int(employee_id))
        result = {'data': [dict(zip(tuple (query.keys()) ,i)) for i in query.cursor]}
        return jsonify(result)		
'''

api.add_resource(Employees, '/employees') # Route_1
# api.add_resource(Tracks, '/tracks') # Route_2
# api.add_resource(Employees_Name, '/employees/<employee_id>') # Route_3


if __name__ == '__main__':
    app.run(port='5002')
     
