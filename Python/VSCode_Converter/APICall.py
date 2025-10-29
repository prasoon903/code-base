from flask import Flask, request
import json
from flask_restful import Resource, Api
from flask_jsonpify import jsonify
from API_Converter import GenerateResponse
from API_VersionDetails import GetVersionDetails, GetVersionList
from API_AddUser import AddUser
from API_AddVersionDetails import AddDetails

app = Flask(__name__)
api = Api(app)


class OutputResponse(Resource):

    # @app.route('/postjson', methods = ['POST'])
    def post(self):
        content = request.get_json()
        InputResponse = content['InputResponse']

        # UserIP = {'IPAdress': request.remote_addr}
        OutputResponse = GenerateResponse(InputResponse)
        if OutputResponse == "Invalid":
            OutputResponse = {'Message': 'Invalid Data or Uncompressed or corrupted data passed'}
        else:
            OutputResponse = json.loads(OutputResponse)
        # OutputResponse = jsonify(OutputResponse)
        # OutputResponse['UserIPAdress'] =  request.remote_addr
        return OutputResponse

###################################################################################################


class VersionDetails(Resource):
    def post(self):
        content = request.get_json()
        Project = content['Project']
        Project = Project.upper()
        Environment = content['Environment']
        Environment = Environment.upper()
        GetEnvList = content['GetEnvList']

        if Project == "PLAT" or Project == "CREDIT":
            if GetEnvList == 1:
                OutputResponse = GetVersionList(Project)
            else:
                OutputResponse = GetVersionDetails(Project, Environment)
        else:
            OutputResponse = {'Message': 'Invalid Project name. It can be PLAT or CREDIT'}

        return OutputResponse

###################################################################################################

class AddUserDetails(Resource):
    def post(self):
        content = request.get_json()

        Project = content['Project']
        Project = Project.upper()

        Username = content['Username']
        Username = Username.upper()

        UserIP = content['UserIP']
        UserIP = UserIP.upper()

        UserAccess = content['UserAccess']

        ModifierIP = request.remote_addr

        if Project == "PLAT" or Project == "CREDIT":
            OutputResponse = AddUser(Project, Username, UserIP, UserAccess, ModifierIP)
        else:
            OutputResponse = {'Message': 'Invalid Project name. It can be PLAT or CREDIT'}

        return OutputResponse

###################################################################################################

class AddVersionDetails(Resource):
    def post(self):
        content = request.get_json()

        Project = content['Project']
        Project = Project.upper()

        Environment = content['Environment']
        Environment = Environment.upper()

        Version = content['Version']
        Version = Version.upper()

        TimeStamp = content['TimeStamp']
        TimeStamp = TimeStamp.upper()

        ModifierIP = request.remote_addr

        if Project == "PLAT" or Project == "CREDIT":
            OutputResponse = AddDetails(Project, Environment, Version, TimeStamp, ModifierIP)
        else:
            OutputResponse = {'Message': 'Invalid Project name. It can be PLAT or CREDIT'}

        return OutputResponse


###################################################################################################


api.add_resource(OutputResponse, '/PlanSegmentAPI')
api.add_resource(VersionDetails, '/VersionDetails')
api.add_resource(AddUserDetails, '/AddUserDetails')
api.add_resource(AddVersionDetails, '/AddVersionDetails')

if __name__ == '__main__':
     app.run(host='10.206.2.217', port='5001')

