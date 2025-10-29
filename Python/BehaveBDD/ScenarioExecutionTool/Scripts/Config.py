import json
import os
# import sys

# print(os.getcwd())

BasePath = "E:\\Python\\BehaveBDD\\ScenarioExecutionTool"
# BasePath = os.getcwd()
Configuration = json.load(open(BasePath+"\Configuration/Configuration.json"))

loggerValue = ""

# print(os.getcwd())



# ScriptsPath = os.path.join(BasePath, "Scripts")
#
#
# # Get the current PATH value
# current_path = os.environ.get("BEHAVEPATH")
#
# # Append the new path to the current PATH
# new_path_value = f"{ScriptsPath}{os.pathsep}{current_path}"
#
# # Set the modified PATH value back to the environment
# print(new_path_value)
# os.environ["BEHAVEPATH"] = new_path_value
# # if ScriptsPath in current_path.split(os.pathsep):
# #     print("Path already present")
# # else:
# #     os.environ["PATH"] = new_path_value
# #     print("Path added successfully")
#
# path_variable = os.environ.get("BEHAVEPATH")
# print(path_variable.split(os.pathsep))


