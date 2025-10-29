from bs4 import BeautifulSoup
import os
import glob
import re
from Scripts.ClearFolder import fn_clearFiles


def fn_ExtractFileName(FileName):
    print(FileName)
    ActualFileName = ""
    # pattern = r'(report_) (\w+) ("(\d{4}-\d{2}-\d{2})")'
    pattern = r'report_'
    # print(pattern)
    match = re.split(pattern, FileName)
    for part in match:
        # print(part)
        pattern = r'_\d{4}-\d{2}-\d{2}.feature.html'
        match = re.split(pattern, part)
        for part1 in match:
            print(part1)
            ActualFileName = part1

    return ActualFileName


def fn_mergeReports(directory):
    target_file_name = "merged_report.html"
    fn_clearFiles(directory, target_file_name)
    os.chdir(directory)
    files = [
                file
                for file in glob.glob("*.html")
            ]

    # ActualFiles = [fn_ExtractFileName(file for file in files)]

    sorted_file_names = sorted(files)

    for file in sorted_file_names:
        # Open the source file in read mode
        # fn_ExtractFileName(file)
        # target_file_name = ""
        # ActualFileName = fn_ExtractFileName(file)
        # if ActualFileName in ActualFiles:
        # target_file_name = f'report_{ActualFileName}.html'
        with open(file, 'r') as source_file:
            source_content = source_file.read()

        # Open the target file in append mode
        with open(target_file_name, 'a') as target_file:
            # Append the content of the source file to the target file
            target_file.write(source_content)

# fn_mergeReports("E:\\Python\\BehaveBDD\\ScenarioExecutionTool\\FeatureFiles\\reports\\")
