import subprocess
arguments = ["bcp", "BehaviorResearch.." + table_to_upload_to, "in", filename_to_be_uploaded, "-T", "-c", "-S PBB-C202B-2\BEHAVIORRESEARCH", "-e bulk_copy_errors.log"]
subprocess.call(arguments, timeout=30)