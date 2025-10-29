
import os
import re

def split_file(filename,file_path, keyword,dirpath):
    # Read the input file
    with open(file_path, 'r') as input_file:
        input_lines = input_file.readlines()

    # Define a regular expression pattern to match the "Age system to" line
    pattern  = keyword + ".*$"
    pattern2 = "Feature:" + ".*$"
    current_date = None  # Initialize current_date to None
    output_folder = None  # Initialize the output folder path to None
    FirstFile = False
    FirstDate ="1990-01-01"
    loop = 0
    date1=[]
    lloop =0

    for line in input_lines:
        match = re.search(pattern, line)
        match2 = re.search(pattern2, line)
        if match2:
            feature =line
            FirstFile = True
            lloop = lloop +1
        elif (FirstFile == True):
            if(lloop == 1):
                feature = feature + line
                lloop = lloop + 1
        if match:
            # Extract the date from the match
            matched_substring = match.group(0)
            print(matched_substring)
            pattern1 = r'"(\d{4}-\d{2}-\d{2})"'
            match1 = re.search(pattern1, matched_substring)
            if match1:
                # Extract the matched date from the first capturing group
                matched_date = match1.group(1)
                print(matched_date)
                bCreatefile = True
                date = matched_date
                date1.append(date)
                if FirstDate =="1990-01-01":
                    FirstDate = date
                    print("After Assignement",FirstDate)

            # Create a folder with the date as the name if it doesn't exist
            output_folder = os.path.join(dirpath, date)
            if not os.path.exists(output_folder):
                os.makedirs(output_folder)

            # Create or append to a file with the same name as the date
            output_file_path = os.path.join(output_folder, f'{date}_{filename}.feature')
            if(lloop == 2):
                with open(output_file_path, 'a') as output_file:
                    output_file.write(feature)

    print("date1",date1)
    # Iterate through the lines in the input file and write on created file
    floop = 0
    for line in input_lines:
        match = re.search(pattern, line)
        floop = floop +1
        if match:
            # Extract the date from the match
            matched_substring = match.group(0)
            print(matched_substring)
            pattern1 = r'"(\d{4}-\d{2}-\d{2})"'
            match1 = re.search(pattern1, matched_substring)
            if match1:
                # Extract the matched date from the first capturing group
                matched_date = match1.group(1)
                print(matched_date)
                bCreatefile = True
                date = matched_date
                print(date)
                FirstDate =date
                output_file_path = os.path.join(output_folder, f'{FirstDate}_{filename}.feature')
                with open(output_file_path, 'a') as output_file:
                    output_file.write(line)
                print("First date adjustment")
                print(loop)
                print(len(date1))
                if(loop < len(date1)-1):
                    print(date1)
                    print("Before",FirstDate)
                    FirstDate = date1[loop+1]
                    print("after",FirstDate)
                loop = loop + 1

        else:
            # If current_date is set, append the line to the current output file
            print("Rohit")
            print(FirstDate)
            output_folder =  os.path.join(dirpath, FirstDate)
            print(output_folder)
            if output_folder:
                output_file_path = os.path.join(output_folder, f'{FirstDate}_{filename}.feature')
                if(FirstDate != date1[0] and floop not in (1,2)):
                    with open(output_file_path, 'a') as output_file:
                        output_file.write(line)

    print("File splitting and creation completed.")

file_name = "Backdated_payment_Case2.feature"
print(os.environ.get('RootPath'))
cwd = os.getcwd()
print(cwd)
os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
file_path = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"+file_name
dirpath = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"
print(file_path)
os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
keyword = "Age system to"
split_file(file_name,file_path, keyword,dirpath)


# import os
# import re
# def split_file(file_path, keyword,dirpath):
#     """Splits a file into multiple files based on a keyword.
#     Args:
#         file_path (str): The path to the file to split.
#         keyword (str): The keyword to split the file on.
#     """
#     # Open the file
#     pattern = keyword + ".*$"
#     with open(file_path, 'r') as file:
#         # Read all the lines in the file
#         lines = file.readlines()
#     # Initialize a list to store the lines of each split file
#     split_files = []
#     # Initialize a variable to store the current split file
#     current_split_file = []
#     # Iterate over each line in the file
#     for i, line in enumerate(lines):
#         # If the line contains the keyword, start a new split file
#         bCreatefile  = False
#         if keyword in line:
#             # Get the date from the keyword
#             match = re.search(pattern, line)
#
#             # Check if a match was found
#             if match:
#                 # Extract the matched substring
#                 matched_substring = match.group(0)
#                 print(matched_substring)
#                 pattern1 = r'"(\d{4}-\d{2}-\d{2})"'
#                 match1 = re.search(pattern1, matched_substring)
#                 if match1:
#                     # Extract the matched date from the first capturing group
#                     matched_date = match1.group(1)
#                     print(matched_date)
#                     bCreatefile = True
#             date = matched_date
#             print(date)
#             # Create a new directory for the split files
#             # Clear the current split file
#             current_split_file = []
#         # Add the line to the current split file
#         current_split_file.append(line)
#         if bCreatefile:
#             output_dir = os.path.join(os.path.dirname(dirpath), date)
#             if not os.path.exists(output_dir):
#                 os.makedirs(output_dir)
#             # Write the first two lines of the current split file to a new file
#             with open(os.path.join(output_dir, f'{date}_{i}.feature'), 'a') as file:
#                 file.writelines(current_split_file[:2])
#     # Append the last split file to the list of split files
#     split_files.append(current_split_file)
# # Example usage
# file_path = "Backdated_payment_Case2.feature"
# print(os.environ.get('RootPath'))
# cwd = os.getcwd()
# print(cwd)
# os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# file_path = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"+file_path
# dirpath = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"
# print(file_path)
# os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# keyword = "Age system to"
# split_file(file_path, keyword,dirpath)
#

#
# import os
# import re
# def split_file(file_path, keyword,dirpath):
#     # Open the file in read mode
#     # print(file_path)
#     with open(file_path, 'r') as file:
#
#         # Read all the lines in the file
#         lines = file.readlines()
#         print(lines)
#
#     # Initialize a list to store the lines of each split file
#     split_files = []
#
#
#     # Initialize a variable to store the current split file
#     current_split_file = []
#
#     # Iterate over each line in the file
#     for line in lines:
#
#         # If the line contains the keyword, start a new split file
#         print(keyword)
#         if keyword in line:
#             print("Inside for split")
#             split_files.append(current_split_file)
#             pattern = r'Age system to "(\d{4}-\d{2}-\d{2})" Date'
#             match = re.search(pattern, line)
#             extracted_date = match.group(1)
#             print(extracted_date)
#             current_split_file = []
#             current_split_file['name']=extracted_date
#
#         # Add the line to the current split file
#         current_split_file.append(line)
#
#     # Append the last split file to the list of split files
#     split_files.append(current_split_file)
#
#     # Create the output directory if it does not exist
#     # print("Keyword",keyword.split(" ")[-1])
#     output_dir = extracted_date
#     full_path = os.path.join(dirpath, output_dir)
#     print("Inside",full_path)
#     if not os.path.exists(full_path):
#         os.makedirs(full_path)
#
#     # Iterate over each split file
#     for i, split_file in enumerate(split_files):
#
#         # If the split file is not empty, write it to a new file
#         if split_file:
#             with open(os.path.join(full_path, f'{split_files["name"][i]}_{i}.feature'), 'w') as file:
#                 file.writelines(split_file)
#
# # Example usage
# file_path = "Backdated_payment_Case2.feature"
# print(os.environ.get('RootPath'))
# cwd = os.getcwd()
# print(cwd)
# os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# file_path = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"+file_path
# dirpath = "D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"
# print(file_path)
# os.chdir("D:\\SVN\\CreditProcessing\\Trunk\\ControlParameters\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# keyword = "Age system to "
# split_file(file_path, keyword,dirpath)