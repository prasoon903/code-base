import subprocess
import os

# Define the absolute path to the primary .bat file
bat_file = r"\\10.206.0.57\D$\ApplicationSetUp\DBBSetup\BatchScripts\CoreIssue\_wfTnpNad.bat"

# Ensure the directory is set correctly
working_dir = r"\\10.206.0.57\D$\ApplicationSetUp\DBBSetup\BatchScripts\CoreIssue"

try:
    result = subprocess.run(
        bat_file,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        shell=True,
        cwd=working_dir  # Set the working directory
    )
    print(result.stdout)
except subprocess.CalledProcessError as e:
    print(f"Error: {e.stderr}")
