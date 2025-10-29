import json
import os
import Scripts.Config as c
import glob

from Scripts.GetLogger import MessageLogger

Configuration = c.Configuration
RootPath = c.BasePath

skipComparision = [tag.lower() for tag in Configuration["skipComparisionTags"]]


def fn_LoadJSONData(file):
    # MessageLogger.info("INSIDE fn_LoadJSONData STARTS")
    file_path = file
    data = {}

    with open(file_path, "r") as json_file:
        json_data = json_file.read()
        # MessageLogger.info(json_data)
    try:
        data = json.loads(json_data)
    except json.JSONDecodeError as e:
        print(f"Error loading JSON data: {e}")

    # MessageLogger.info("INSIDE fn_LoadJSONData ENDS")

    return data[0]


# Function to compare two nested JSON objects and return differing values
def compare_json(json1, json2, tag=""):
    # MessageLogger.info("INSIDE compare_json STARTS")
    differing_values = []

    if json1 != json2:
        differing_values.append((tag, json1, json2))

    if isinstance(json1, dict):
        for key in json1.keys():
            # print(f"Key: {key}")
            new_tag = tag + f"['{key}']"
            # MessageLogger.info(new_tag.lower())
            # MessageLogger.info(skipComparision)
            if not any(tag in new_tag.lower() for tag in skipComparision):
                # MessageLogger.info(f"Inside for {new_tag}")
                differing_values.extend(compare_json(json1[key], json2[key], new_tag))
    elif isinstance(json1, list):
        for index, (item1, item2) in enumerate(zip(json1, json2)):
            # print(index)
            new_tag = tag + f'[{index}]'
            if not any(tag in new_tag.lower() for tag in skipComparision):
                differing_values.extend(compare_json(item1, item2, new_tag))

    return differing_values


def fn_JSONComparator(path, file1, file2, diffFile):
    try:
        # MessageLogger.info("INSIDE fn_JSONComparator STARTS")
        dict1 = fn_LoadJSONData(file1)
        # MessageLogger.info("JSON Loaded for File 1")
        dict2 = fn_LoadJSONData(file2)
        # compare_json(dict1, dict2)

        MessageLogger.info("Comparing below files")
        MessageLogger.info(f"file1: {file1}")
        MessageLogger.info(f"file2: {file2}")

        Account1 = dict1
        Plan1 = {}
        Plan2 = {}
        if 'Plan' in Account1:
            Plan1 = Account1.pop('Plan')
        Account2 = dict2
        if 'Plan' in Account2:
            Plan2 = Account2.pop('Plan')

        differing_values = compare_json(Account1, Account2)
        fileToWrite = diffFile
        os.chdir(path)

        with open(fileToWrite, 'w') as file:
            if not differing_values:
                file.write("\nThe JSON objects are identical for account.")
            else:
                file.write("\nDiffering values for account:\n")
                for tag, value1, value2 in differing_values:
                    if tag is not None and tag != "":
                        file.write(f"Tag: {tag}: Value 1: {value1}, Value 2: {value2} \n")

        P1KeyCheck = {}
        P2KeyCheck = {}
        for keyP1, valueP1 in Plan1.items():
            if keyP1 not in P1KeyCheck:
                P1KeyCheck[f'{keyP1}'] = 0
            for keyP2, valueP2 in Plan2.items():
                if keyP2 not in P2KeyCheck:
                    P2KeyCheck[f'{keyP2}'] = 0
                if keyP1 == keyP2:
                    P1KeyCheck[f'{keyP1}'] = 1
                    P2KeyCheck[f'{keyP2}'] = 1
                    differing_values = compare_json(valueP1, valueP2)
                    with open(fileToWrite, 'a') as file:
                        if not differing_values:
                            file.write(f"\nThe JSON objects are identical for {keyP1} with PlanID1 = {valueP1['acctID']} and PlanID2 = {valueP2['acctID']}.")
                        else:
                            file.write(f"\nDiffering values for Plans {keyP1} with PlanID1 = {valueP1['acctID']} and PlanID2 = {valueP2['acctID']}:\n")
                            for tag, value1, value2 in differing_values:
                                if tag is not None and tag != "":
                                    file.write(f"Tag: {tag}: Value 1: {value1}, Value 2: {value2} \n")

        # MessageLogger.info(f"P1KeyCheck: {P1KeyCheck}")
        # MessageLogger.info(f"P2KeyCheck: {P2KeyCheck}")
        for key, value in P1KeyCheck.items():
            if value == 0:
                with open(fileToWrite, 'a') as file:
                    MessageLogger.info(f"Here for {key} is not present in file 1")
                    file.write(f"\n{key} is present in 1st file but not in 2nd file\n")
                    json.dump(Plan1[f"{key}"], file, indent=4)
                    # file.write(str(value))
        for key, value in P2KeyCheck.items():
            if value == 0:
                with open(fileToWrite, 'a') as file:
                    MessageLogger.info(f"Here for {key} is not present in file 2")
                    file.write(f"\n{key} is present in 2nd file but not in 1st file\n")
                    json.dump(Plan2[f"{key}"], file, indent=4)
                    # file.write(str(value))
    except Exception as e:
        MessageLogger.error(f"Error while JSON comparison {e}")


def CompareFromBase():
    BaseResultPath = os.path.join(Configuration['BasePath'], "BaseResult")
    ResponseFilesPath = f"{Configuration['BasePath']}\\{Configuration['JsonResponse']}\\"
    AllFiles = [
        f
        for f in os.listdir(ResponseFilesPath)
        if os.path.isdir(os.path.join(ResponseFilesPath, f))
    ]

    for file in AllFiles:
        folderName = f"{ResponseFilesPath}{file}\\"
        baseFolderName = f"{BaseResultPath}\\{file}\\"
        MessageLogger.info(f"Base folder: {baseFolderName}")
        MessageLogger.info(f"Current folder: {folderName}")
        if os.path.isdir(baseFolderName):
            MessageLogger.info(f"folderName: {folderName}")
            os.chdir(folderName)
            responseFiles = [
                responseFile
                for responseFile in glob.glob("Account_Plan_Details_*.json")
            ]
            os.chdir(baseFolderName)
            baseResponseFiles = [
                baseResponseFile
                for baseResponseFile in glob.glob("*.json")
            ]
            # MessageLogger.info(baseResponseFiles)
            for file_name in responseFiles:
                MessageLogger.info(f"Comparing file from base for {file_name}")
                if file_name in baseResponseFiles:
                    MessageLogger.info(f"fileName: {file_name}")
                    file1 = f"{baseFolderName}{file_name}"
                    file2 = f"{folderName}{file_name}"

                    file_name_with_extension = os.path.basename(file_name)
                    fileName_without_extension, file_extension = os.path.splitext(file_name_with_extension)

                    diffFile = f"{folderName}{fileName_without_extension}_DIFF.txt"
                    MessageLogger.info(folderName)
                    MessageLogger.info(file1)
                    MessageLogger.info(file2)
                    MessageLogger.info(diffFile)

                    fn_JSONComparator(folderName, file1, file2, diffFile)
                else:
                    MessageLogger.info(f"{file_name} is not present in base")
        else:
            MessageLogger.info(f"Base folder is not present for {file}")


# path = "E:\Python\BehaveBDD\ScenarioExecutionTool\\"
# file1 = "E:\Python\BehaveBDD\ScenarioExecutionTool\BaseResult\COOKIE-266974_UC1\Account_Plan_Details_BEFORE_Post purchase.json"
# file2 = "E:\Python\BehaveBDD\ScenarioExecutionTool\JsonResponse\COOKIE-266974_UC1\Account_Plan_Details_AFTER_Post purchase.json"
#
# diffFile = "E:\Python\BehaveBDD\ScenarioExecutionTool\JsonResponse\diff.txt"

# fn_JSONComparator(path, file1, file2, diffFile)
# CompareFromBase()

