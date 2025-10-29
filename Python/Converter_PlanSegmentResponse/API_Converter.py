from flask import Flask, request
from flask_restful import Resource, Api
from sqlalchemy import create_engine
from json
from flask_jsonpify import jsonify
import pyodbc
import json

app = Flask(__name__)
api = Api(app)


class OutputResponse(Resource):

    ###################################################################################################


    def ConnectDB(self):
        import pyodbc
        con = pyodbc.connect(p_str=True,
                            driver="{SQL Server}",
                            server=SERVERNAME,
                            Trusted_Connection='yes')
        cur = con.cursor()

        return cur

    ###################################################################################################


    def GetLookUp(self):
        Lookup = ""

        Query = "SELECT  RTRIM(LTRIM(DisplayOrdr)) AS DisplayOrdr, " \
                "RTRIM(LTRIM(LutCode)) AS LutCode, " \
                "RTRIM(LTRIM(LutDescription)) AS LutDescription " \
                "FROM " + CI_DB + "..CCardLookUp WITH (NOLOCK) " \
                "WHERE LUTid = 'PlanSegmentLog' " \
                "ORDER BY DisplayOrdr"

        # print(Query)
        # Connect = Connection()
        Result = Connect.execute(Query)

        Row = Result.fetchall()

        for r in Row:
            if str(r.DisplayOrdr) == '1':
                Lookup = '"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'
            else:
                Lookup = Lookup + ',"' + str(r.LutCode) + '":"' + str(r.LutDescription) + '"'

        # Connect.close()

        Lookup = "{" + Lookup + "}"

        Lookup_dict = json.loads(Lookup)

        return Lookup_dict

    ###################################################################################################


    def GenerateResponse(self, line):
        OutputResponse = line
        # Query = ""
        Lookup_dict = GetLookUp()
        Query = "SELECT CAST(DECOMPRESS(" + OutputResponse + ") AS VARCHAR(MAX)) AS OutputResponse"
        # print(Query)
        Connect = ConnectDB()
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)

        if RowCount > 0:
            for r in Row:
                OutputResponse = r.OutputResponse
                # Lookup_dict = GetLookUp()
                for key, value in Lookup_dict.items():
                    KeyToReplace = '"' + str(key) + '"'
                    Value = '"' + str(value) + '"'
                    # print("Here to replace: " + KeyToReplace + " with " + Value)
                    OutputResponse = OutputResponse.replace(KeyToReplace, Value)
        else:
            OutputResponse = "INVALID DATA"

        Connect.close()
        return OutputResponse

    ###################################################################################################


    @app.route('/postjson', methods = ['POST'])
    def get(self):
        content = request.get_json()
        InputResponse = content['InputResponse']

        OutputResponse = GenerateResponse(InputResponse)
        OutputResponse = json.loads(OutputResponse)
        OutputResponse = jsonify(OutputResponse)
        return OutputResponse


if __name__ == '__main__':
     app.run(port='5001')



