import os
import re


def split_file(filename, file_path, keyword, dirpath, Output_path):
    # Read the input file
    with open(file_path, "r") as input_file:
        input_lines = input_file.readlines()

    # Define a regular expression pattern to match the "Age system to" line
    pattern = keyword + ".*$"
    pattern2 = "Feature:" + ".*$"
    current_date = None  # Initialize current_date to None
    output_folder = None  # Initialize the output folder path to None
    FirstFile = False
    FirstDate = "1990-01-01"
    loop = 0
    date1 = []
    lloop = 0
    FileExists = False

    for line in input_lines:
        match = re.search(pattern, line)
        match2 = re.search(pattern2, line)
        if match2:
            feature = line
            FirstFile = True
            lloop = lloop + 1
        elif FirstFile == True:
            if lloop == 1:
                feature = feature + line
                lloop = lloop + 1
        if match:
            # Extract the date from the match
            matched_substring = match.group(0)
            # print(matched_substring)
            pattern1 = r'"(\d{4}-\d{2}-\d{2})"'
            match1 = re.search(pattern1, matched_substring)
            if match1:
                # Extract the matched date from the first capturing group
                matched_date = match1.group(1)
                # print(matched_date)
                bCreatefile = True
                date = matched_date
                date1.append(date)
                if FirstDate == "1990-01-01":
                    FirstDate = date
                    # print("After Assignement", FirstDate)

            # Create a folder with the date as the name if it doesn't exist
            output_folder = os.path.join(Output_path, date)
            if not os.path.exists(output_folder):
                os.makedirs(output_folder)

            # Create or append to a file with the same name as the date
            output_file_path = os.path.join(output_folder, f"{date}_{filename}.feature")
            if os.path.exists(output_file_path):
                FileExists = True
            if lloop == 2 and not FileExists:
                with open(output_file_path, "a") as output_file:
                    output_file.write(feature)

    # print("date1", date1)
    # Iterate through the lines in the input file and write on created file
    floop = 0
    for line in input_lines:
        match = re.search(pattern, line)
        floop = floop + 1
        if match:
            # Extract the date from the match
            matched_substring = match.group(0)
            # print(matched_substring)
            pattern1 = r'"(\d{4}-\d{2}-\d{2})"'
            match1 = re.search(pattern1, matched_substring)
            if match1:
                # Extract the matched date from the first capturing group
                matched_date = match1.group(1)
                # print(matched_date)
                bCreatefile = True
                date = matched_date
                # print(date)
                FirstDate = date
                output_file_path = os.path.join(
                    output_folder, f"{FirstDate}_{filename}.feature"
                )
                with open(output_file_path, "a") as output_file:
                    # output_file.write(line)
                    output_file.write("")
                # print("First date adjustment")
                # print(loop)
                # print(len(date1))
                if loop < len(date1) - 1:
                    # print(date1)
                    # print("Before", FirstDate)
                    FirstDate = date1[loop + 1]
                    # print("after", FirstDate)
                loop = loop + 1

        else:
            # If current_date is set, append the line to the current output file
            # print("Rohit")
            # print(FirstDate)
            # print(line)
            output_folder = os.path.join(Output_path, FirstDate)
            # print(output_folder)
            if output_folder:
                output_file_path = os.path.join(
                    output_folder, f"{FirstDate}_{filename}.feature"
                )
                if FirstDate != date1[0] and floop not in (1, 2):
                    with open(output_file_path, "a") as output_file:
                        output_file.write(line)

    print("File splitting and creation completed.")


# file_name = "Scenario20.feature"
# print(os.environ.get("RootPath"))
# cwd = os.getcwd()
# print(cwd)
# os.chdir("E:\\Python\\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# file_path = "E:\\Python\\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\" + file_name
# dirpath = "E:\\Python\\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\"
# print(file_path)
# os.chdir("E:\\Python\\BehaveBDD\\features\\Rohit.Soni\\BackDatePayment\\")
# keyword = "Age system to"
# split_file(file_name, file_path, keyword, dirpath)
