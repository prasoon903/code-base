import os
import shutil



def delete_contents(folder_path):
    print(folder_path)
    try:
        for item in os.listdir(folder_path):
            item_path = os.path.join(folder_path, item)

            if os.path.isdir(item_path):
                delete_contents(item_path)
                os.rmdir(item_path)
            else:
                # If the item is a file, delete it
                os.remove(item_path)
        print("All files/folders in this folder have been deleted")
    except Exception as e:
        print(f"Error while deleting: {str(e)}")

# Call the delete_contents function to delete all contents inside the directory
# delete_contents(directory_path)


def fn_clearFiles(folder_path, file_name):
    try:
        # List all files in the directory
        for filename in os.listdir(folder_path):
            if file_name == filename or file_name == "":
                file_path = os.path.join(folder_path, filename)
                # Check if it's a file (not a directory) and then delete it
                if os.path.isfile(file_path):
                    os.remove(file_path)
                    print(f"Deleted: {file_path}")
                if file_name == filename:
                    print(f"{filename} file in the directory have been deleted.")
        if file_name == "":
            print("All files in the directory have been deleted.")
    except Exception as e:
        print(f"An error occurred: {e}")
