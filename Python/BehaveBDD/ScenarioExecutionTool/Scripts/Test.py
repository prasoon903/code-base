import json
import os

columnName = ['acctId']

json_file_path = "E:\\Python\\BehaveBDD\\ScenarioExecutionTool" + f"\\JsonPayload\\BSegment.json"
# MessageLogger.info(f"json_file_path: {json_file_path}")
# columnMapping = []

if os.path.exists(json_file_path):
    try:
        with open(json_file_path) as json_file:
            columnMapping = json.load(json_file)
            print(columnMapping)
    except Exception as e:
        print(f"Error loading column mapping from {json_file_path}: {e}")
else:
    print(f"JSON file not found at path: {json_file_path}")
    columnMapping = {}

for columns in columnName:
    print(f"columns: {columns}")
    print(f"columns.lower: {columns.lower()}")
    if columns.lower() in columnMapping:
        table = columnMapping[f"{columns.lower()}"]
        print(f"table: {table}")
